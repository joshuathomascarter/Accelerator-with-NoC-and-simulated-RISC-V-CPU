"""Host side of the CPU path: load the firmware, then let the CPU classify images.

The host only touches pynq_soc_top's CPU registers and memory windows:
    SOC_CTRL 0x0100 (bit0 = CPU runs), instruction memory at 0x0400,
    data memory at 0x1000 (see rtl/pynq_soc_top.sv).
Per image: hold the CPU in reset, write the image and clear DONE, release the
CPU, wait for DONE, read PRED and the logits.

The same command list runs on three targets:
    xsim  pynq_soc_top in Vivado's simulator (Tests/tb_pynq_soc_cmds.sv)
    jtag  the PYNQ-Z2 over the USB cable, from this PC (xsdb)
    pynq  the PYNQ-Z2's ARM, through the pynq MMIO driver
"""

from __future__ import annotations

import subprocess
import time
from pathlib import Path

import numpy as np

from . import backends
from .firmware import DONE, LOGITS, PRED, Firmware

SOC_CTRL = 0x0100
SOC_STATUS = 0x0104
IMEM_BASE = 0x0400
DMEM_BASE = 0x1000

SOC_RTL = backends.PYNQ_RTL + [
    "cpu/cpu_pkg.sv", "cpu/cpu_alu.sv", "cpu/cpu_control.sv", "cpu/cpu_decode.sv",
    "cpu/cpu_lsu.sv", "cpu/cpu_regfile.sv", "cpu/cpu_core.sv", "cpu/cpu_mmio_bridge.sv",
    "rtl/pynq_soc_top.sv",
]


def load_commands(fw: Firmware) -> list[tuple]:
    cmds: list[tuple] = [("W", SOC_CTRL, 0)]
    cmds += [("W", IMEM_BASE + 4 * i, w) for i, w in enumerate(fw.program)]
    cmds += [("W", DMEM_BASE + 4 * i, v) for i, v in sorted(fw.dmem.items())]
    return cmds


def image_commands(fw: Firmware, x_q: np.ndarray) -> list[tuple]:
    cmds: list[tuple] = [("W", SOC_CTRL, 0)]
    cmds += [("W", DMEM_BASE + 4 * (fw.image_word + i), w) for i, w in enumerate(fw.image(x_q))]
    cmds += [("W", DMEM_BASE + 4 * DONE, 0), ("C",), ("W", SOC_CTRL, 1),
             ("P", DMEM_BASE + 4 * DONE, 1, 1), ("C",), ("R", DMEM_BASE + 4 * PRED)]
    cmds += [("R", DMEM_BASE + 4 * (LOGITS + c)) for c in range(fw.classes)]
    cmds += [("R", SOC_STATUS)]
    return cmds


def parse(fw: Firmware, lines: list[str], images: int) -> tuple[np.ndarray, np.ndarray, list[float], int]:
    """Return (preds, logits, per-image time between the two C markers, error flags OR'd)."""

    stamps = [float(ln.split()[1]) for ln in lines if ln.startswith("C ")]
    reads = [int(ln.split()[2], 16) for ln in lines if ln.startswith("R ")]
    per = 2 + fw.classes
    if len(reads) != per * images:
        raise RuntimeError(f"expected {per * images} reads, got {len(reads)}")
    reads = np.array(reads, dtype=np.uint32).reshape(images, per)
    preds = reads[:, 0].astype(np.int64)
    logits = reads[:, 1:1 + fw.classes].view(np.int32).astype(np.int64)
    errors = int(np.bitwise_or.reduce(reads[:, -1]) & 0x2)
    times = [stamps[2 * i + 1] - stamps[2 * i] for i in range(images)]
    return preds, logits, times, errors


def _fmt(cmd: tuple) -> str:
    return " ".join([cmd[0]] + [f"{v:x}" for v in cmd[1:]])


def run_xsim(cmds: list[tuple], work: Path | None = None) -> list[str]:
    work = work or backends.default_sim_dir() / "soc"
    if not (work / "xsim.dir" / "tb_pynq_soc_cmds_snap").exists():
        backends.build_xsim(work, "Tests/tb_pynq_soc_cmds.sv", "tb_pynq_soc_cmds", rtl=SOC_RTL)
    (work / "cmds.txt").write_text("\n".join(_fmt(c) for c in cmds) + "\n")
    (work / "results.txt").unlink(missing_ok=True)
    proc = subprocess.run([backends._tool(backends.find_vivado_bin(), "xsim"), "tb_pynq_soc_cmds_snap", "-runall"],
                          cwd=work, capture_output=True, text=True)
    if proc.returncode != 0 or "commands complete" not in proc.stdout:
        raise RuntimeError(f"xsim failed:\n{proc.stdout[-4000:]}")
    return (work / "results.txt").read_text().splitlines()


def _tcl(cmds: list[tuple], fclk: int) -> str:
    """xsdb script; consecutive word writes become one block mwr."""

    out = ["connect", 'targets -set -filter {name =~ "APU*"}', f"set b {backends.ACCEL_BASE:#x}",
           f"if {{[mrd -force -value {backends.FPGA0_CLK_CTRL:#x}] != {fclk}}} {{ puts REPROGRAMMED; exit }}"]
    i = 0
    while i < len(cmds):
        c = cmds[i]
        if c[0] == "W":
            j = i
            while j + 1 < len(cmds) and cmds[j + 1][0] == "W" and cmds[j + 1][1] == cmds[j][1] + 4 \
                    and j + 1 - i < 256:
                j += 1
            values = " ".join(f"{cmds[k][2]:#x}" for k in range(i, j + 1))
            out.append(f"mwr -force [expr {{$b + {c[1]:#x}}}] {{{values}}}")
            i = j + 1
            continue
        if c[0] == "R":
            out.append(f'puts "R {c[1]:04x} [format %08x [mrd -force -value [expr {{$b + {c[1]:#x}}}]]]"')
        elif c[0] == "P":
            out.append(f"set n 0; while {{([mrd -force -value [expr {{$b + {c[1]:#x}}}]] & {c[2]:#x}) != {c[3]:#x}}}"
                       f" {{ if {{[incr n] > 100000}} {{ error timeout }} }}; puts \"P $n\"")
        elif c[0] == "C":
            out.append('puts "C [clock microseconds]"')
        i += 1
    return "\n".join(out) + "\n"


def run_jtag(make_cmds, bitstream: str | Path, session: dict, work: Path | None = None) -> list[str]:
    """make_cmds(need_load) builds the command list; need_load is True right after
    the FPGA is (re)programmed, when instruction and data memory are empty."""

    import tempfile
    work = work or Path(tempfile.gettempdir()) / "mini_accel_jtag"
    for _ in range(3):
        if "fclk" not in session:
            session["clk"], session["fclk"] = backends.jtag_setup(bitstream, work)
        need_load = not session.get("firmware_loaded")
        out = backends._xsdb_stream(_tcl(make_cmds(need_load), session["fclk"]), work)
        if "REPROGRAMMED" not in out:
            session["firmware_loaded"] = True
            return [ln for ln in out.splitlines() if ln[:2] in ("R ", "P ", "C ")]
        session.clear()
    raise RuntimeError("bitstream kept being replaced on the board")


def run_pynq(cmds: list[tuple], accel) -> list[str]:
    lines = []
    for c in cmds:
        if c[0] == "W":
            accel.write(c[1], c[2])
        elif c[0] == "R":
            lines.append(f"R {c[1]:04x} {accel.read(c[1]):08x}")
        elif c[0] == "P":
            n = 0
            while (accel.read(c[1]) & c[2]) != c[3]:
                n += 1
            lines.append(f"P {n}")
        elif c[0] == "C":
            lines.append(f"C {time.perf_counter() * 1e6}")
    return lines


class CpuRunner:
    """Classify images with the CPU on one target, loading the firmware only when needed."""

    def __init__(self, fw: Firmware, target: str, bitstream: str | Path | None = None):
        self.fw, self.target, self.bitstream = fw, target, bitstream
        self.session: dict = {}          # jtag: FPGA programming state
        self.loaded = False              # pynq: firmware already in memory
        if target == "pynq":
            from .driver import PynqAccelerator
            self.accel = PynqAccelerator(bitstream)

    def classify(self, x_q: np.ndarray) -> tuple[np.ndarray, np.ndarray, list[float], int]:
        """Return (predictions, logits, time per image, CPU error flag) for x_q (samples, features).

        Time per image is in clock cycles on xsim and in microseconds on the board.
        """

        x_q = np.atleast_2d(x_q)

        def make_cmds(need_load: bool) -> list[tuple]:
            cmds = load_commands(self.fw) if need_load else []
            for x in x_q:
                cmds += image_commands(self.fw, x)
            return cmds + [("W", SOC_CTRL, 0)]   # hand the accelerator back to the host

        if self.target == "xsim":
            lines = run_xsim(make_cmds(True))    # every simulation starts from empty memories
        elif self.target == "jtag":
            lines = run_jtag(make_cmds, self.bitstream, self.session)
        else:
            lines = run_pynq(make_cmds(not self.loaded), self.accel)
            self.loaded = True
        return parse(self.fw, lines, len(x_q))
