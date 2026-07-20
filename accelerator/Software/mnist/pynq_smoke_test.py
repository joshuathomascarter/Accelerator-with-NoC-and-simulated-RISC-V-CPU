"""First board test for the PYNQ-Z2 mini accelerator overlay."""

from __future__ import annotations

import argparse

try:
    from .pynq_driver import PynqAccelerator
except ImportError:
    from pynq_driver import PynqAccelerator


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bitstream", default="mini_accel.bit")
    parser.add_argument("--tiles", type=int, default=4, choices=range(1, 5))
    args = parser.parse_args()

    weights = [0x04030201, 0x08070605, 0x0C0B0A09, 0x100F0E0D][: args.tiles]
    activations = [0x00000101, 0x00000102, 0x00000201, 0x00000202][: args.tiles]
    accelerator = PynqAccelerator(args.bitstream)
    results = accelerator.run(weights, activations, args.tiles)
    accelerator.set_leds(len(results))
    print("Mini accelerator completed successfully")
    for index, result in enumerate(results):
        print(f"tile {index}: 0x{result:08x}")


if __name__ == "__main__":
    main()
