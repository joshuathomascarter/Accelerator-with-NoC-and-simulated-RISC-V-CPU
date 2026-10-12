"""Collect everything the PYNQ-Z2 needs into build/pynq_bundle/.

    python scripts/make_board_bundle.py

Copy the folder to the board (e.g. scp -r build/pynq_bundle xilinx@pynq:~/mini_accel),
then on the board:

    cd ~/mini_accel
    sudo python3 smoke_test.py
    sudo python3 run_dataset.py --model models/digits.npz --backend pynq --samples 0
"""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "software"))

from mini_accel.model import train_quantized  # noqa: E402

OUT = REPO / "build" / "pynq_bundle"


def main() -> int:
    overlay = REPO / "overlays" / "mini_accel"
    missing = [f for f in ("mini_accel.bit", "mini_accel.hwh") if not (overlay / f).exists()]
    if missing:
        print(f"Missing {missing} in {overlay}; build the bitstream first (Vivado/build_pynq_z2.tcl)")
        return 1

    shutil.rmtree(OUT, ignore_errors=True)
    OUT.mkdir(parents=True)
    for f in ("mini_accel.bit", "mini_accel.hwh"):
        shutil.copy(overlay / f, OUT / f)
    shutil.copytree(REPO / "software" / "mini_accel", OUT / "mini_accel",
                    ignore=shutil.ignore_patterns("__pycache__"))
    for f in ("run_dataset.py", "smoke_test.py"):
        shutil.copy(REPO / "software" / f, OUT / f)

    # The board has numpy but usually not scikit-learn, so models are trained here.
    for name in ("iris", "digits", "mnist8"):
        train_quantized(name).save(OUT / "models" / f"{name}.npz")

    print(f"Board bundle ready: {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
