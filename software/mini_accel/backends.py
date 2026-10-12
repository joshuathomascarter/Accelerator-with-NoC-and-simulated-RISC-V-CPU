"""Ways to execute a list of accelerator runs.

    model  bit-exact Python model of the RTL (no tools needed)
    xsim   the real RTL in Vivado's simulator, through the AXI-Lite top level
    pynq   the bitstream on a PYNQ-Z2 board, through the ARM's AXI GP0 port

Each backend returns (results, stats): results[i] is the list of uint32 tile
results for runs[i], and stats holds whatever timing the backend can measure.
"""

from __future__ import annotations

import os
import shutil
import subprocess
import tempfile
import time
from pathlib import Path

from .mapping import Run, reference_run

REPO = Path(__file__).resolve().parents[2]

# RTL for the board top level, in compile order.
PYNQ_RTL = [
    "accelerator/Communication/noc_packet.sv",
    "rtl/pynq_accel_pkg.sv",
    "accelerator/Communication/noc_endpoint.sv",
    "accelerator/Communication/noc_router.sv",
    "accelerator/Communication/simple_grid_noc.sv",
    "accelerator/Communication/schedular.sv",
    "accelerator/Storage/tile_scratchpad.sv",
    "accelerator/computation/mac.sv",
    "accelerator/computation/pe.sv",
    "accelerator/computation/systolic_array.sv",
    "accelerator/computation/tile.sv",
    "accelerator/chip_top.sv",
    "rtl/pynq_accel_axi_lite.sv",
    "rtl/axi_result_readback.sv",
    "rtl/accel_core.sv",
    "rtl/pynq_accel_top.sv",
]


def run_model(runs: list[Run]) -> tuple[list[list[int]], dict]:
    return [reference_run(r) for r in runs], {}


def find_vivado_bin() -> Path:
    """Locate Vivado's bin directory (XILINX_VIVADO, PATH, or a default install)."""

    if os.environ.get("XILINX_VIVADO"):
        return Path(os.environ["XILINX_VIVADO"]) / "bin"
    on_path = shutil.which("xvlog")
    if on_path:
        return Path(on_path).parent
    roots = [Path("C:/AMDDesignTools"), Path("C:/Xilinx/Vivado"), Path("/tools/Xilinx/Vivado"), Path("/opt/Xilinx/Vivado")]
    for root in roots:
        candidates = sorted(root.glob("*/Vivado/bin")) + sorted(root.glob("*/bin"))
        for c in reversed(candidates):
            if (c / "xvlog.bat").exists() or (c / "xvlog").exists():
                return c
    raise FileNotFoundError("Vivado not found; set XILINX_VIVADO to the Vivado install directory")


def _tool(bin_dir: Path, name: str) -> str:
    bat = bin_dir / f"{name}.bat"
    return str(bat if bat.exists() else bin_dir / name)


def default_sim_dir() -> Path:
    # Kept outside the repo: synced folders (OneDrive) lock xsim's build files.
    return Path(os.environ.get("MINI_ACCEL_SIM_DIR", Path(tempfile.gettempdir()) / "mini_accel_xsim"))


def build_xsim(work: Path | None = None, testbench: str = "Tests/tb_pynq_axi_vectors.sv",
               top: str = "tb_pynq_axi_vectors", rtl: list[str] | None = None) -> Path:
    """Compile and elaborate the RTL plus a testbench; returns the work directory."""

    work = work or default_sim_dir()
    work.mkdir(parents=True, exist_ok=True)
    bin_dir = find_vivado_bin()
    prj = work / f"{top}.prj"
    files = (rtl or PYNQ_RTL) + [testbench]
    prj.write_text("".join(f'sv work "{(REPO / f).as_posix()}"\n' for f in files))
    for cmd in ([_tool(bin_dir, "xvlog"), "-prj", prj.name],
                [_tool(bin_dir, "xelab"), top, "-s", f"{top}_snap", "-timescale", "1ns/1ps"]):
        proc = subprocess.run(cmd, cwd=work, capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"{Path(cmd[0]).stem} failed:\n{proc.stdout[-4000:]}{proc.stderr[-2000:]}")
    return work


def run_xsim(runs: list[Run], work: Path | None = None, rebuild: bool = True) -> tuple[list[list[int]], dict]:
    """Run every transaction through pynq_accel_top in XSIM via tb_pynq_axi_vectors."""

    work = work or default_sim_dir()
    if rebuild or not (work / "xsim.dir" / "tb_pynq_axi_vectors_snap").exists():
        build_xsim(work)

    with (work / "vectors.txt").open("w") as f:
        for r in runs:
            w = r.weights + [0] * (4 - r.tiles)
            a = r.activations + [0] * (4 - r.tiles)
            f.write(f"{r.tiles:x} " + " ".join(f"{v:08x}" for v in w + a) + "\n")
    (work / "results.txt").unlink(missing_ok=True)

    t0 = time.perf_counter()
    proc = subprocess.run([_tool(find_vivado_bin(), "xsim"), "tb_pynq_axi_vectors_snap", "-runall"],
                          cwd=work, capture_output=True, text=True)
    sim_wall = time.perf_counter() - t0
    if proc.returncode != 0 or "runs complete" not in proc.stdout:
        raise RuntimeError(f"xsim failed:\n{proc.stdout[-4000:]}{proc.stderr[-2000:]}")

    results, compute_cycles, run_cycles = [], [], []
    for line in (work / "results.txt").read_text().split("\n"):
        if not line.strip():
            continue
        fields = line.split()
        results.append([int(v, 16) for v in fields[:4]])
        compute_cycles.append(int(fields[4]))
        run_cycles.append(int(fields[5]))
    if len(results) != len(runs):
        raise RuntimeError(f"xsim returned {len(results)} results for {len(runs)} runs")
    return results, {"compute_cycles": compute_cycles, "run_cycles": run_cycles, "sim_wall_s": sim_wall}


ACCEL_BASE = 0x43C00000

# Zynq SLCR registers used to set up the PL from JTAG.
SLCR_UNLOCK, SLCR_LOCK = 0xF8000008, 0xF8000004
IO_PLL_CTRL, FPGA0_CLK_CTRL = 0xF8000108, 0xF8000170
FPGA_RST_CTRL, LVL_SHFTR_EN = 0xF8000240, 0xF8000900
PS_CLK_HZ = 33.333e6
FCLK_TARGET_HZ = 45e6   # timing-closed clock (Vivado/build_pynq_z2.tcl)


def _xsdb(script: str, work: Path, timeout: float = 3600) -> str:
    work.mkdir(parents=True, exist_ok=True)
    (work / "run.tcl").write_text(script)
    proc = subprocess.run([_tool(find_vivado_bin(), "xsdb"), "run.tcl"], cwd=work,
                          capture_output=True, text=True, timeout=timeout)
    if proc.returncode != 0:
        raise RuntimeError(f"xsdb failed:\n{proc.stdout[-3000:]}{proc.stderr[-2000:]}")
    return proc.stdout


def jtag_setup(bitstream: str | Path, work: Path) -> tuple[float, int]:
    """Program the PL over JTAG and set FCLK0 to the fastest clock <= FCLK_TARGET_HZ (45 MHz).

    Returns (clock in Hz, FPGA0_CLK_CTRL value written).

    Follows the Zynq PL-reconfiguration sequence: isolate PS from PL (level
    shifters off, PL in reset), program, set the clock, then reconnect, so no
    PS access can reach the PL while it is being reconfigured.
    """

    apu = 'targets -set -filter {name =~ "APU*"}'
    out = _xsdb(f"""connect
if {{[catch {{{apu}}}]}} {{ puts "NOAPU"; exit }}
puts "IOPLL [mrd -force -value {IO_PLL_CTRL:#x}]"
puts "FCLK [mrd -force -value {FPGA0_CLK_CTRL:#x}]"
""", work)
    if "NOAPU" in out or "IOPLL " not in out:
        raise RuntimeError("Zynq ARM debug targets not visible over JTAG; power-cycle the board and retry")
    io_pll = int(out.split("IOPLL ")[1].split()[0])
    fclk = int(out.split("FCLK ")[1].split()[0])
    pll_hz = PS_CLK_HZ * ((io_pll >> 12) & 0x7F)
    div0, div1 = max(((d0, d1) for d0 in range(1, 64) for d1 in range(1, 64)
                      if pll_hz / (d0 * d1) <= FCLK_TARGET_HZ),
                     key=lambda d: pll_hz / (d[0] * d[1]))
    new = (fclk & ~((0x3F << 20) | (0x3F << 8))) | (div1 << 20) | (div0 << 8)
    _xsdb(f"""connect
{apu}
mwr -force {SLCR_UNLOCK:#x} 0xDF0D
mwr -force {LVL_SHFTR_EN:#x} 0x0
mwr -force {FPGA_RST_CTRL:#x} 0xF
targets -set -filter {{name =~ "xc7z020"}}
fpga -file {{{Path(bitstream).resolve().as_posix()}}}
{apu}
mwr -force {FPGA0_CLK_CTRL:#x} {new:#x}
mwr -force {LVL_SHFTR_EN:#x} 0xF
mwr -force {FPGA_RST_CTRL:#x} 0x0
mwr -force {SLCR_LOCK:#x} 0x767B
""", work)
    return pll_hz / (div0 * div1), new


def _xsdb_stream(script: str, work: Path, on_line=None) -> str:
    """Run an xsdb script, passing each stdout line to on_line as it arrives."""

    work.mkdir(parents=True, exist_ok=True)
    (work / "run.tcl").write_text(script)
    proc = subprocess.Popen([_tool(find_vivado_bin(), "xsdb"), "run.tcl"], cwd=work, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=1)
    out = []
    for line in proc.stdout:
        out.append(line)
        if on_line:
            on_line(line.rstrip("\n"))
    if proc.wait() != 0:
        raise RuntimeError("xsdb failed:\n" + "".join(out)[-3000:])
    return "".join(out)


def run_jtag(runs: list[Run], bitstream: str | Path, work: Path | None = None,
             attempts: int = 5, session: dict | None = None, on_result=None,
             leds: int | None = None) -> tuple[list[list[int]], dict]:
    """Drive the accelerator on a USB-connected PYNQ-Z2 from this PC through xsdb.

    Before every run a guard reads FCLK0's divisor (a PS register, always safe to
    read): PYNQ rewrites it whenever it loads an overlay, so a changed value means
    something on the board (e.g. PYNQ loading its base overlay at boot) replaced
    our bitstream. Touching the accelerator's address then would hang the AXI bus,
    so the script stops, and the PL is reprogrammed and the remaining runs resumed.

    session: pass the same dict across calls to program the FPGA only once.
    on_result(index, results): called as each run's results arrive from the board.
    leds: value for the 4 user LEDs after the last run (status bits cleared first).
    """

    work = work or Path(tempfile.gettempdir()) / "mini_accel_jtag"
    session = {} if session is None else session
    results: list[list[int]] = []
    reprograms = 0
    t0 = time.perf_counter()

    def line_seen(line: str) -> None:
        if line.startswith("RES ") and on_result:
            on_result(len(results) + line_seen.count, [int(v, 16) for v in line.split()[1:]])
            line_seen.count += 1

    while len(results) < len(runs) or (not runs and "fclk" not in session):
        if reprograms >= attempts:
            raise RuntimeError(f"bitstream was replaced {reprograms} times; is PYNQ still booting?")
        if "fclk" not in session:
            session["clk"], session["fclk"] = jtag_setup(bitstream, work)
        fclk = session["fclk"]
        lines = ["connect", 'targets -set -filter {name =~ "APU*"}',
                 f"set b {ACCEL_BASE:#x}",
                 "proc w {o v} { global b; mwr -force [expr {$b + $o}] $v }",
                 "proc r {o} { global b; return [mrd -force -value [expr {$b + $o}]] }",
                 "proc guard {} {",
                 f"  if {{[mrd -force -value {FPGA0_CLK_CTRL:#x}] != {fclk}}} {{ puts REPROGRAMMED; exit }}",
                 "}",
                 "proc run {ws as} {",
                 "  guard",
                 "  w 0x00 0x2; w 0x08 [llength $ws]",
                 "  foreach v $ws { w 0x0C $v }; foreach v $as { w 0x10 $v }",
                 "  w 0x00 0x5",
                 "  set n 0; while {!([r 0x04] & 0x2)} { if {[incr n] > 1000} { error timeout } }",
                 "  set e [r 0x18]; if {$e} { error [format {error flags 0x%x} $e] }",
                 "  set out {}; foreach v $ws { lappend out [format %08x [r 0x14]] }",
                 "  puts \"RES $out\"",
                 "}"]
        for r in runs[len(results):]:
            lines.append("run {" + " ".join(f"{v:#x}" for v in r.weights) + "} {"
                         + " ".join(f"{v:#x}" for v in r.activations) + "}")
        if leds is not None:
            lines += ["guard", "w 0x00 0x2", f"w 0x1C {leds & 0xF:#x}"]
        line_seen.count = 0
        out = _xsdb_stream("\n".join(lines) + "\n", work, line_seen)
        results += [[int(v, 16) for v in ln.split()[1:]] for ln in out.splitlines() if ln.startswith("RES ")]
        if "REPROGRAMMED" in out:
            session.clear()
            reprograms += 1
            print(f"  bitstream replaced on the board after {len(results)} runs; reprogramming and resuming")
        elif len(results) < len(runs):
            raise RuntimeError(f"board stopped after {len(results)}/{len(runs)} runs:\n{out[-3000:]}")
        elif not runs:
            break
    wall = time.perf_counter() - t0
    return results, {"jtag_wall_s": wall, "fclk_hz": session.get("clk", 0.0), "reprograms": reprograms}


def run_pynq(runs: list[Run], accel) -> tuple[list[list[int]], dict]:
    """Run on the board's ARM; accel is a driver.PynqAccelerator."""

    t0 = time.perf_counter()
    results = [accel.run(r.weights, r.activations) for r in runs]
    wall = time.perf_counter() - t0
    return results, {"board_wall_s": wall}


def make_executor(backend: str, bitstream: str | Path | None = None):
    """Return execute(runs) -> (results, stats) that keeps its connection between calls.

    The simulator is compiled once, the FPGA is programmed once over JTAG, and the
    PYNQ overlay is loaded once, however many layers or images are run.
    """

    if backend == "model":
        return run_model
    if backend == "xsim":
        built = []

        def execute(runs):
            out = run_xsim(runs, rebuild=not built)
            built.append(True)
            return out
        return execute
    if backend == "jtag":
        session: dict = {}
        return lambda runs, **kw: run_jtag(runs, bitstream, session=session, **kw)
    if backend == "pynq":
        from .driver import PynqAccelerator
        accel = PynqAccelerator(bitstream)
        return lambda runs: run_pynq(runs, accel)
    raise ValueError(f"unknown backend {backend!r}")
