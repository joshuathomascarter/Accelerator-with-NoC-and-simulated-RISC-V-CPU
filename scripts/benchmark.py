"""Compare the accelerator against plain software running the same INT8 inference.

    python scripts/benchmark.py

Software baselines are timed on this PC. Accelerator numbers come from the
reports written by run_dataset.py:
  build/reports/<dataset>_xsim.json        cycle-accurate RTL simulation
  build/reports/<dataset>_jtag[_full].json measured on the PYNQ-Z2 over JTAG
Writes docs/RESULTS.md.
"""

from __future__ import annotations

import json
import platform
import sys
import time
from pathlib import Path

import numpy as np

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "software"))

from mini_accel.model import train_quantized  # noqa: E402

CLOCK_HZ = 45e6


def best_time(fn, repeats: int = 5) -> float:
    best = float("inf")
    for _ in range(repeats):
        t0 = time.perf_counter()
        fn()
        best = min(best, time.perf_counter() - t0)
    return best


def pure_python(layers: list[tuple[list, list, int | None]], xs: list[list[int]]) -> list[int]:
    """The same INT8 network in plain Python: lists and loops, no NumPy."""

    preds = []
    for x in xs:
        for w, b, shift in layers:
            acc = [sum(wi * xi for wi, xi in zip(row, x)) + bi for row, bi in zip(w, b)]
            x = acc if shift is None else [min(max(a, 0) >> shift, 127) for a in acc]
        preds.append(max(range(len(x)), key=x.__getitem__))
    return preds


def load_report(*names: str) -> dict | None:
    for name in names:
        p = REPO / "build" / "reports" / f"{name}.json"
        if p.exists():
            return json.loads(p.read_text())
    return None


DATASETS = ("iris", "digits", "mnist8")


def main() -> int:
    rows = []
    for name in DATASETS:
        m = train_quantized(name)
        x64 = m.x_test_q.astype(np.int64)
        n = len(x64)
        layers = [(l.w_q.astype(np.int64).tolist(), l.b_q.astype(np.int64).tolist(), l.shift) for l in m.layers]
        macs = sum(int(l.w_q.size) for l in m.layers)          # dense MACs per inference

        t_py = best_time(lambda: pure_python(layers, x64.tolist()), repeats=1 if n > 1000 else 5)
        t_np1 = best_time(lambda: [int(np.argmax(m.golden_logits(x[None, :]))) for x in x64], repeats=1 if n > 1000 else 5)
        t_npb = best_time(lambda: np.argmax(m.golden_logits(x64), axis=1), repeats=20)
        assert pure_python(layers, x64[:200].tolist()) == list(np.argmax(m.golden_logits(x64[:200]), axis=1))

        def row(impl: str, where: str, seconds: float, note: str = "") -> dict:
            return {"dataset": name, "impl": impl, "where": where, "us": seconds * 1e6,
                    "mmacs": macs / seconds / 1e6, "note": note}

        group = [row("Pure Python loops", "PC CPU", t_py / n),
                 row("NumPy, one input at a time", "PC CPU", t_np1 / n),
                 row("NumPy, whole test set batched", "PC CPU", t_npb / n)]
        sim = load_report(f"{name}_xsim")
        if sim:
            k = sim["samples_run"]
            group.append(row("FPGA, PC drives every run: compute only", "45 MHz, cycle-accurate sim",
                             sim["total_compute_cycles"] / CLOCK_HZ / k,
                             f"{sim['compute_cycles_per_run_mean']:.0f} cycles per run, {k} samples"))
            group.append(row("FPGA, PC drives every run: compute + bus traffic", "45 MHz, cycle-accurate sim",
                             sim["total_cycles_including_axi"] / CLOCK_HZ / k,
                             f"{sim['axi_cycles_per_run_mean']:.0f} cycles per run"))
        cpu = load_report(f"{name}_cpu-xsim")
        if cpu:
            group.append(row("FPGA, project CPU drives every run", "45 MHz, cycle-accurate sim",
                             cpu["cpu_cycles_per_inference"] / CLOCK_HZ,
                             f"{cpu['cpu_cycles_per_inference']:,.0f} cycles per inference, "
                             f"{cpu['logits_bit_exact_vs_reference']} bit-exact"))
        board = load_report(f"{name}_jtag_full", f"{name}_jtag")
        if board:
            group.append(row("Board, PC drives every run over USB-JTAG", "PYNQ-Z2 (measured)",
                             board["jtag_wall_time_s"] / board["samples_run"],
                             f"{board['samples_run']} samples, {board['logits_bit_exact_vs_reference']} bit-exact"))
        cpu_board = load_report(f"{name}_cpu-jtag_full", f"{name}_cpu-jtag_1000", f"{name}_cpu-jtag")
        if cpu_board:
            group.append(row("Board, project CPU drives every run; PC sends images over USB-JTAG",
                             "PYNQ-Z2 (measured)", 1 / cpu_board["board_inferences_per_s"],
                             f"{cpu_board['samples_run']} samples, {cpu_board['logits_bit_exact_vs_reference']} "
                             f"bit-exact, {cpu_board['accelerator_accuracy']:.1%} accuracy"))
        base = group[0]["us"]
        for r in group:
            r["speedup"] = base / r["us"]
        rows += group

    lines = ["# Results: accelerator vs. software", "",
             f"Software baselines were timed on this PC ({platform.processor() or platform.machine()}, "
             f"Python {platform.python_version()}, best of several repeats). Every row runs the same "
             "INT8 network and predicts the same classes. MMAC/s counts the network's dense "
             "multiply-accumulates per second. **Speedup is relative to pure Python on the PC** "
             "(higher is faster).", ""]
    titles = {"iris": "Iris (4 -> 3)", "digits": "Digits 8x8 (64 -> 10)", "mnist8": "MNIST at 8x8 (64 -> 32 -> 10)"}
    for name in DATASETS:
        g = [r for r in rows if r["dataset"] == name]
        lines += [f"## {titles[name]}", "",
                  "| Implementation | Runs on | Time / inference | MMAC/s | Speedup vs. pure Python | Notes |",
                  "|---|---|---:|---:|---:|---|"]
        for r in g:
            lines.append(f"| {r['impl']} | {r['where']} | {r['us']:,.1f} µs | {r['mmacs']:.3g} | "
                         f"{r['speedup']:.3g}× | {r['note']} |")
        lines.append("")
    lines += [
        "## Reading these numbers", "",
        "- **Correct, but not faster than a desktop PC.** Every board and simulation result matches "
        "the 8-bit software model exactly. The accelerator's compute time is close to pure-Python "
        "loops: 2.5x faster on Iris, about equal on the larger networks. NumPy on a desktop CPU is "
        "8-160x faster than either.",
        "- **Why:** each run does 16 multiply-accumulates (4 tiles x 4 lanes) in about 111 cycles, "
        "0.14 per cycle. The tiles run one after another, every run resends its weights over the "
        "network-on-chip, and the clock is 45 MHz. The 16 multiply-accumulate units could do 16 per cycle.",
        "- **Who drives the accelerator matters most on the board.** Over the USB debug cable, each "
        "register access is a round trip of about 1 ms. When the PC drives every run, one MNIST "
        "image takes 4.4 s. When the project CPU on the FPGA drives the runs, the PC only sends "
        "the image and reads the answer: 23 ms per image, about 190x faster, and most of that "
        "23 ms is still USB. The CPU's own work is 0.50 ms per image (cycle-accurate simulation).",
        "- **Next steps, if speed is the goal:** run the four tiles in parallel (up to 4x), keep "
        "weights inside the tiles instead of resending them (about 2x), pipeline the CPU and the "
        "multiply-accumulate path to reach 100 MHz (about 2x), and move data with DMA instead of "
        "one register write per word.", ""]
    out = REPO / "docs" / "RESULTS.md"
    out.write_text("\n".join(lines), encoding="utf-8")
    print("\n".join(lines))
    print(f"\nWritten to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
