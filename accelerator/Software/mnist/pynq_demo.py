"""PYNQ-Z2 MNIST demo scaffold.

This script is designed to run on the PYNQ board after we add the AXI/MMIO or
AXI DMA wrapper around the accelerator.

For now, the hardware access methods are isolated in `AcceleratorDriver`.
When the AXI map is finalized, only that class should need real board-specific
register writes/reads.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

from accelerator.Software.mnist.accel_format import pack_int8x4
from accelerator.Software.mnist.tile_mapping import DEFAULT_ASSIGNMENTS, export_tile_payloads, tile_reference_logits


class AcceleratorDriver:
    """Thin PYNQ-side driver for the future AXI accelerator wrapper."""

    def __init__(self, bitstream: str | None = None):
        self.bitstream = bitstream
        self.overlay = None
        self.leds = None

        if bitstream:
            try:
                from pynq import Overlay  # type: ignore

                self.overlay = Overlay(bitstream)
            except Exception as exc:
                raise RuntimeError(
                    "Could not load PYNQ Overlay. Run this on the board or omit --bitstream for software-only demo."
                ) from exc

        try:
            from pynq.overlays.base import BaseOverlay  # type: ignore

            base = BaseOverlay("base.bit")
            self.leds = base.leds
        except Exception:
            self.leds = None

    def write_led_digit(self, digit: int) -> None:
        """Mirror the predicted digit on four LEDs as binary."""

        if self.leds is None:
            print(f"LED digit mirror: {digit:04b}")
            return

        for bit in range(4):
            self.leds[bit].write((digit >> bit) & 1)

    def load_tile_payloads(self, payloads: dict[str, np.ndarray]) -> None:
        """TODO: write packed per-tile weight/bias words through AXI or DMA."""

        _ = payloads
        raise NotImplementedError("AXI tile payload load path is added after the AXI wrapper exists")

    def run_image(self, packed_activation_words: np.ndarray) -> np.ndarray:
        """TODO: send shared activation words and return 10 reconstructed logits."""

        _ = packed_activation_words
        raise NotImplementedError("AXI image/run/readback path is added after the AXI wrapper exists")


def software_reference(
    image_int8: np.ndarray,
    weights_int8: np.ndarray,
    bias_int8: np.ndarray,
) -> np.ndarray:
    """Integer reference path that mirrors the eventual accelerator-level dot products."""

    image_i32 = image_int8.astype(np.int32).reshape(1, -1)
    weights_i32 = weights_int8.astype(np.int32)
    bias_i32 = bias_int8.astype(np.int32)
    return (image_i32 @ weights_i32 + bias_i32).reshape(-1)


def software_tile_reference(
    image_int8: np.ndarray,
    weights_int8: np.ndarray,
    bias_int8: np.ndarray,
) -> tuple[np.ndarray, dict[int, np.ndarray]]:
    return tile_reference_logits(image_int8, weights_int8, bias_int8, DEFAULT_ASSIGNMENTS)


def show_digit_ascii(image: np.ndarray) -> None:
    chars = " .:-=+*#%@"
    image = image.reshape(28, 28).astype(np.float32)
    image = image - image.min()
    if image.max() > 0:
        image = image / image.max()
    for row in image:
        print("".join(chars[min(int(v * (len(chars) - 1)), len(chars) - 1)] for v in row))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--artifact", default="artifacts/mnist/mnist_softmax_int8.npz")
    parser.add_argument("--bitstream", default=None)
    parser.add_argument("--sample", type=int, default=0)
    parser.add_argument("--software-only", action="store_true")
    args = parser.parse_args()

    artifact = Path(args.artifact)
    data = np.load(artifact)

    image = data["sample_images_int8"][args.sample]
    label = int(data["sample_labels"][args.sample])
    weights = data["weights_int8"]
    bias = data["bias_int8"]

    tile_payloads = export_tile_payloads(weights, bias, image)
    packed_image = tile_payloads["activation_words"]

    driver = AcceleratorDriver(None if args.software_only else args.bitstream)

    if args.software_only:
        logits, per_tile_logits = software_tile_reference(image, weights, bias)
    else:
        driver.load_tile_payloads(tile_payloads)
        logits = driver.run_image(packed_image)
        per_tile_logits = {}

    pred = int(np.argmax(logits))
    driver.write_led_digit(pred)

    print(f"MNIST sample index: {args.sample}")
    print(f"Expected label: {label}")
    print(f"Predicted digit: {pred}")
    print(f"Logits: {logits.tolist()}")
    if per_tile_logits:
        print("Per-tile logits:")
        for assignment in DEFAULT_ASSIGNMENTS:
            print(f"  tile {assignment.tile_id} digits {assignment.digits}: {per_tile_logits[assignment.tile_id].tolist()}")
    print("Input image:")
    show_digit_ascii(image)


if __name__ == "__main__":
    main()
