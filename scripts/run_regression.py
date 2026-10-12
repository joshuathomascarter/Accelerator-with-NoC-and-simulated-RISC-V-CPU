"""Run every RTL testbench in Vivado XSIM, plus a randomized check against the Python model.

    python scripts/run_regression.py            # all tests
    python scripts/run_regression.py tb_tile    # only the named testbenches

Set XILINX_VIVADO if Vivado is not on PATH or in a default install location.
Build files go to %TEMP%/mini_accel_xsim (override with MINI_ACCEL_SIM_DIR).
"""

from __future__ import annotations

import random
import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "software"))

from mini_accel import backends  # noqa: E402
from mini_accel.mapping import Run, reference_run  # noqa: E402

PACKAGES = [
    "accelerator/Communication/noc_packet.sv",
    "cpu/cpu_pkg.sv",
    "rtl/pynq_accel_pkg.sv",
]

TESTBENCHES = [
    "tb_systolic_array",
    "tb_tile",
    "tb_noc",
    "tb_chip_end_to_end",
    "tb_pynq_accel_axi_lite",
    "tb_pynq_axi_single_tile",
    "tb_pynq_axi_four_tiles",
    "tb_cpu_regfile",
    "tb_cpu_core",
    "tb_cpu_branch_jump",
    "tb_cpu_mmio",
    "tb_cpu_mmio_bridge",
    "tb_cpu_end_to_end",
    "tb_cpu_real_chip_end_to_end",
]

RANDOM_RUNS = 300


def sources() -> list[Path]:
    rtl = [REPO / p for p in PACKAGES]
    for pattern in ("accelerator/**/*.sv", "cpu/**/*.sv", "rtl/*.sv", "*.sv", "Tests/**/*.sv"):
        rtl += sorted(p for p in REPO.glob(pattern) if p not in rtl)
    return rtl


def tool(name: str) -> str:
    return backends._tool(backends.find_vivado_bin(), name)


SIM_TIMEOUT_S = 180


def run(cmd: list[str], cwd: Path, timeout: float | None = None) -> subprocess.CompletedProcess:
    proc = subprocess.Popen(cmd, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    try:
        out, err = proc.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        # Kill the whole tree: xsim.bat -> xsim.exe -> xsimk.exe.
        if sys.platform == "win32":
            subprocess.run(["taskkill", "/F", "/T", "/PID", str(proc.pid)], capture_output=True)
        else:
            proc.kill()
        out, err = proc.communicate()
        return subprocess.CompletedProcess(cmd, -1, out + f"\nFATAL: timed out after {timeout}s", err)
    return subprocess.CompletedProcess(cmd, proc.returncode, out, err)


def random_vector_check(work: Path) -> tuple[bool, str]:
    """Drive random INT8 operands through pynq_accel_top and compare with the model."""

    rng = random.Random(1)
    word = lambda: rng.getrandbits(32)  # noqa: E731
    runs = [Run([word() for _ in range(t)], [word() for _ in range(t)])
            for t in (rng.randint(1, 4) for _ in range(RANDOM_RUNS))]
    # Corner cases: saturating lanes and all-negative operands.
    runs += [Run([0x7F7F7F7F] * 4, [0x7F7F7F7F] * 4), Run([0x80808080] * 4, [0x80808080] * 4),
             Run([0x80808080] * 4, [0x7F7F7F7F] * 4)]
    results, _ = backends.run_xsim(runs, work, rebuild=True)
    bad = [i for i, (r, run_) in enumerate(zip(results, runs)) if r[:run_.tiles] != reference_run(run_)]
    return not bad, f"{len(runs) - len(bad)}/{len(runs)} random runs bit-exact"


def cpu_firmware_check() -> tuple[bool, str]:
    """The CPU in pynq_soc_top runs the MNIST-8 network on 5 test images through the accelerator."""

    import numpy as np
    from mini_accel.cpu_host import CpuRunner
    from mini_accel.firmware import build
    from mini_accel.model import train_quantized

    model = train_quantized("mnist8")
    x = model.x_test_q[:5]
    preds, logits, cycles, err = CpuRunner(build(model), "xsim").classify(x)
    exact = int(np.all(logits == model.golden_logits(x), axis=1).sum())
    return exact == 5 and not err, f"{exact}/5 images bit-exact, {np.mean(cycles):,.0f} cycles per image"


def main() -> int:
    selected = sys.argv[1:] or TESTBENCHES + ["random_vectors", "cpu_firmware"]
    work = backends.default_sim_dir() / "regression"
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir(parents=True, exist_ok=True)
    for hex_file in (REPO / "Tests").rglob("*.hex"):   # CPU tests load Tests/... relative to cwd
        dest = work / hex_file.relative_to(REPO)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(hex_file, dest)

    prj = work / "all.prj"
    prj.write_text("".join(f'sv work "{p.as_posix()}"\n' for p in sources()))
    proc = run([tool("xvlog"), "-prj", prj.name], work)
    if proc.returncode != 0:
        print(proc.stdout[-4000:])
        print("FAIL: compile")
        return 1

    failures = 0
    for name in selected:
        if name == "random_vectors":
            ok, detail = random_vector_check(backends.default_sim_dir() / "vectors")
        elif name == "cpu_firmware":
            ok, detail = cpu_firmware_check()
        else:
            elab = run([tool("xelab"), name, "-s", f"{name}_snap", "-timescale", "1ns/1ps"], work)
            sim = run([tool("xsim"), f"{name}_snap", "-runall"], work, SIM_TIMEOUT_S) if elab.returncode == 0 else elab
            log = sim.stdout
            ok = (elab.returncode == 0 and sim.returncode == 0
                  and "Fatal" not in log and "FATAL" not in log and "ERROR" not in log)
            detail = next((ln.strip() for ln in reversed(log.splitlines())
                           if ("pass" in ln.lower() or "fatal" in ln.lower() or "error" in ln.lower())), "")
        failures += not ok
        print(f"{'PASS' if ok else 'FAIL'}  {name:<30} {detail[:100]}")

    print(f"\n{len(selected) - failures}/{len(selected)} passed")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
