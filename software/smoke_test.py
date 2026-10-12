"""First test on the PYNQ-Z2: a few runs with known answers.

    sudo python3 smoke_test.py --bitstream mini_accel.bit
"""

from __future__ import annotations

import argparse
import random
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from mini_accel.driver import PynqAccelerator  # noqa: E402
from mini_accel.mapping import Run, reference_run  # noqa: E402


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--bitstream", default="mini_accel.bit")
    ap.add_argument("--random-runs", type=int, default=200)
    args = ap.parse_args()

    accel = PynqAccelerator(args.bitstream)

    # Weights 1,2,3,4 . activations 1,1,1,1 = 10; then signed and saturating lanes.
    runs = [
        Run([0x04030201], [0x01010101]),
        Run([0x04030201, 0x01010101, 0xFF02FE03, 0x7F7F7F7F],
            [0x04030201, 0x05050505, 0x01010101, 0x7F7F7F7F]),
        Run([0x80808080] * 4, [0x80808080] * 4),
    ]
    rng = random.Random(0)
    for _ in range(args.random_runs):
        t = rng.randint(1, 4)
        runs.append(Run([rng.getrandbits(32) for _ in range(t)], [rng.getrandbits(32) for _ in range(t)]))

    failures = 0
    for i, run in enumerate(runs):
        got, want = accel.run(run.weights, run.activations), reference_run(run)
        if got != want:
            failures += 1
            print(f"run {i}: got {[hex(v) for v in got]} expected {[hex(v) for v in want]}")
        elif i < 3:
            print(f"run {i}: {[hex(v) for v in got]} OK")

    accel.set_leds(0xF if failures == 0 else 0x1)
    print(f"{len(runs) - failures}/{len(runs)} runs matched the reference model")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
