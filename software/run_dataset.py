"""Classify a small dataset on the mini accelerator and report accuracy and timing.

Examples (from the repository root):

    python software/run_dataset.py --dataset digits --samples 50 --backend xsim
    python software/run_dataset.py --dataset iris --backend model
    python software/run_dataset.py --dataset digits --export build/digits_model.npz

On the PYNQ-Z2 (numpy only, no scikit-learn needed):

    python3 run_dataset.py --model build/digits_model.npz --backend pynq \
        --bitstream overlays/mini_accel/mini_accel.bit
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))

from mini_accel import backends  # noqa: E402
from mini_accel.inference import infer  # noqa: E402
from mini_accel.model import DATASETS, QuantizedModel  # noqa: E402

CLOCK_HZ = 45e6  # FCLK0 in the PYNQ-Z2 block design (Vivado/build_pynq_z2.tcl)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dataset", choices=DATASETS, default="mnist8")
    ap.add_argument("--model", type=Path, help="load a model exported with --export instead of training")
    ap.add_argument("--export", type=Path, help="save the quantized model and test set to this .npz and exit")
    ap.add_argument("--backend", choices=("model", "xsim", "jtag", "pynq", "cpu-xsim", "cpu-jtag", "cpu-pynq"), default="xsim",
                    help="cpu-* backends: the CPU on the FPGA runs the whole network; the host only loads images and reads answers")
    ap.add_argument("--samples", type=int, default=50, help="test samples to run on the backend (0 = all)")
    ap.add_argument("--bitstream", type=Path, default=Path("overlays/mini_accel/mini_accel.bit"))
    ap.add_argument("--no-skip-zero", action="store_true", help="send all-zero chunks to hardware too")
    ap.add_argument("--report", type=Path, help="JSON report path (default build/reports/<dataset>_<backend>.json)")
    args = ap.parse_args()

    if args.model:
        model = QuantizedModel.load(args.model)
    else:
        from mini_accel.model import train_quantized
        model = train_quantized(args.dataset)

    if args.export:
        model.save(args.export)
        print(f"Saved {model.name} model and {len(model.y_test)} test samples to {args.export}")
        return 0

    golden_all = model.golden_logits()
    int8_acc_all = float((golden_all.argmax(1) == model.y_test).mean())

    n = len(model.y_test) if args.samples <= 0 else min(args.samples, len(model.y_test))
    x, y, golden = model.x_test_q[:n], model.y_test[:n], golden_all[:n]
    shape = " -> ".join(str(d) for d in [model.features] + [int(l.w_q.shape[0]) for l in model.layers])
    print(f"Dataset {model.name}: {shape} ({len(model.layers)} layer(s) on the accelerator), "
          f"{n} test samples on '{args.backend}'")

    if args.backend.startswith("cpu-"):
        return run_cpu(args, model, x, y, golden, int8_acc_all, shape)

    execute = backends.make_executor(args.backend, args.bitstream)
    logits, info = infer(model, x, execute, skip_zero=not args.no_skip_zero)
    print(f"  {info.jobs} tile dot products in {len(info.runs)} accelerator runs "
          f"({info.skipped} all-zero chunks skipped)")

    pred = logits.argmax(1)
    exact = np.all(logits == golden, axis=1)
    macs = info.jobs * 4

    report = {
        "dataset": model.name,
        "backend": args.backend,
        "network": shape,
        "samples_run": n,
        "float_accuracy_full_test_set": model.float_test_accuracy,
        "int8_reference_accuracy_full_test_set": int8_acc_all,
        "int8_reference_accuracy_on_run_samples": float((golden.argmax(1) == y).mean()),
        "accelerator_accuracy": float((pred == y).mean()),
        "logits_bit_exact_vs_reference": f"{int(exact.sum())}/{n}",
        "accelerator_runs": len(info.runs),
        "tile_dot_products": info.jobs,
        "skipped_zero_chunks": info.skipped,
        "int8_macs": macs,
    }

    def merged(key: str) -> list:
        return [v for st in info.stats for v in st.get(key, [])]

    def total(key: str) -> float:
        return sum(st.get(key, 0.0) for st in info.stats)

    if any("compute_cycles" in st for st in info.stats):
        cc, rc = np.array(merged("compute_cycles")), np.array(merged("run_cycles"))
        tiles = np.array([r.tiles for r in info.runs])
        report.update({
            "compute_cycles_per_run_mean": float(cc.mean()),
            "compute_cycles_per_run_by_tiles": {int(t): float(cc[tiles == t].mean()) for t in sorted(set(tiles))},
            "axi_cycles_per_run_mean": float(rc.mean()),
            "total_compute_cycles": int(cc.sum()),
            "total_cycles_including_axi": int(rc.sum()),
            "est_time_per_inference_us_at_45MHz": float(rc.sum() / CLOCK_HZ / n * 1e6),
            "est_inferences_per_s_at_45MHz": float(n * CLOCK_HZ / rc.sum()),
            "est_compute_only_macs_per_s_at_45MHz": float(macs * CLOCK_HZ / cc.sum()),
            "xsim_wall_time_s": round(total("sim_wall_s"), 2),
        })
    if any("jtag_wall_s" in st for st in info.stats):
        wall = total("jtag_wall_s")
        report.update({
            "board_fabric_clock_mhz": round(max(st.get("fclk_hz", 0) for st in info.stats) / 1e6, 2),
            "jtag_wall_time_s": round(wall, 2),
            "jtag_runs_per_s": len(info.runs) / wall,
        })
    if any("board_wall_s" in st for st in info.stats):
        wall = total("board_wall_s")
        report.update({
            "board_wall_time_s": wall,
            "board_time_per_inference_ms": wall / n * 1e3,
            "board_inferences_per_s": n / wall,
            "board_runs_per_s": len(info.runs) / wall,
        })

    finish(args, model, report)
    return 0 if exact.all() else 1


def finish(args, model, report: dict) -> None:
    print()
    width = max(len(k) for k in report)
    for k, v in report.items():
        if isinstance(v, float):
            v = f"{v:.4f}" if v < 10 else f"{v:,.1f}"
        print(f"  {k:<{width}}  {v}")

    out = args.report or Path("build/reports") / f"{model.name}_{args.backend}.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(report, indent=2))
    print(f"\nReport written to {out}")


def run_cpu(args, model, x, y, golden, int8_acc_all: float, shape: str) -> int:
    """The CPU on the FPGA runs every layer; the host loads images and reads answers."""

    from mini_accel.cpu_host import CpuRunner
    from mini_accel.firmware import build

    fw = build(model)
    runs_per_image = sum(l.w_q.shape[0] * (l.w_q.shape[1] // 16) for l in model.layers)
    print(f"  firmware: {fw.layout['program_words']} instructions, {fw.layout['data_words']} data words; "
          f"{runs_per_image} accelerator runs per image, all issued by the CPU")
    target = args.backend.split("-", 1)[1]
    runner = CpuRunner(fw, target, args.bitstream)
    t0 = time.perf_counter()
    preds, logits, per_image, cpu_error = runner.classify(x)
    wall = time.perf_counter() - t0
    exact = np.all(logits == golden, axis=1)
    n = len(y)
    report = {
        "dataset": model.name,
        "backend": args.backend,
        "network": shape,
        "samples_run": n,
        "float_accuracy_full_test_set": model.float_test_accuracy,
        "int8_reference_accuracy_full_test_set": int8_acc_all,
        "int8_reference_accuracy_on_run_samples": float((golden.argmax(1) == y).mean()),
        "accelerator_accuracy": float((preds == y).mean()),
        "logits_bit_exact_vs_reference": f"{int(exact.sum())}/{n}",
        "cpu_prediction_matches_reference": f"{int((preds == golden.argmax(1)).sum())}/{n}",
        "cpu_mmio_error": bool(cpu_error),
        "accelerator_runs": runs_per_image * n,
        "firmware_instructions": fw.layout["program_words"],
    }
    if target == "xsim":
        cyc = float(np.mean(per_image))
        report.update({
            "cpu_cycles_per_inference": cyc,
            "est_time_per_inference_us_at_45MHz": cyc / CLOCK_HZ * 1e6,
            "est_inferences_per_s_at_45MHz": CLOCK_HZ / cyc,
        })
    else:
        us = float(np.mean(per_image))
        report.update({
            "board_cpu_time_per_inference_us": us,
            "board_wall_time_s": round(wall, 2),
            "board_inferences_per_s": n / wall,
        })
        if target == "jtag":
            report["note"] = ("cpu time includes one JTAG status poll per image; the CPU itself "
                              "takes about 0.5 ms per image at 45 MHz (see cpu-xsim)")
    finish(args, model, report)
    return 0 if exact.all() and not cpu_error else 1


if __name__ == "__main__":
    raise SystemExit(main())
