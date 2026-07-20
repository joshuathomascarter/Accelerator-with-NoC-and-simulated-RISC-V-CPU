"""Helpers for drawn-digit MNIST demos.

The board demo should let someone draw a digit in a notebook, convert that
drawing into the same 28x28 INT8 format used by the accelerator, then run
inference through either the software reference or the PYNQ hardware driver.
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np

from accelerator.Software.mnist.accel_format import QuantizedArray, pack_int8x4, quantize_symmetric


@dataclass(frozen=True)
class DrawnDigit:
    image_float: np.ndarray
    image_int8: np.ndarray
    packed_words: np.ndarray
    scale: float


def _resize_with_pillow(image: np.ndarray, size: tuple[int, int]) -> np.ndarray:
    try:
        from PIL import Image  # type: ignore
    except Exception as exc:
        raise RuntimeError("Pillow is required for drawn digit resizing: pip install pillow") from exc

    img = Image.fromarray(np.clip(image * 255.0, 0, 255).astype(np.uint8), mode="L")
    img = img.resize(size, Image.Resampling.LANCZOS)
    return np.asarray(img, dtype=np.float32) / 255.0


def crop_to_ink(image: np.ndarray, threshold: float = 0.05, margin: int = 12) -> np.ndarray:
    """Crop a drawn image to its non-empty region with a small margin."""

    image = np.asarray(image, dtype=np.float32)
    mask = image > threshold
    if not np.any(mask):
        return image

    ys, xs = np.where(mask)
    y0 = max(int(ys.min()) - margin, 0)
    y1 = min(int(ys.max()) + margin + 1, image.shape[0])
    x0 = max(int(xs.min()) - margin, 0)
    x1 = min(int(xs.max()) + margin + 1, image.shape[1])
    return image[y0:y1, x0:x1]


def center_on_square(image: np.ndarray, size: int = 280) -> np.ndarray:
    """Place a digit crop onto a square canvas before MNIST downsampling."""

    image = np.asarray(image, dtype=np.float32)
    h, w = image.shape
    scale = min(size / max(h, 1), size / max(w, 1))
    resized_h = max(1, min(size, int(round(h * scale))))
    resized_w = max(1, min(size, int(round(w * scale))))
    resized = _resize_with_pillow(image, (resized_w, resized_h))

    square = np.zeros((size, size), dtype=np.float32)
    y0 = (size - resized_h) // 2
    x0 = (size - resized_w) // 2
    square[y0 : y0 + resized_h, x0 : x0 + resized_w] = resized
    return square


def canvas_rgba_to_grayscale(rgba: np.ndarray) -> np.ndarray:
    """Convert an RGBA canvas array into MNIST-style white-ink intensity."""

    arr = np.asarray(rgba)
    if arr.ndim != 3 or arr.shape[2] < 3:
        raise ValueError(f"Expected HxWxRGBA/RGB canvas array, got shape {arr.shape}")

    rgb = arr[..., :3].astype(np.float32)
    if rgb.max() > 1.0:
        rgb = rgb / 255.0

    gray = 0.299 * rgb[..., 0] + 0.587 * rgb[..., 1] + 0.114 * rgb[..., 2]

    # Most canvas widgets draw black ink on a white background. MNIST is easier
    # to treat as white ink on black background, so invert if the background is
    # mostly bright.
    if float(np.mean(gray)) > 0.5:
        gray = 1.0 - gray

    if arr.shape[2] >= 4:
        alpha = arr[..., 3].astype(np.float32)
        if alpha.max() > 1.0:
            alpha = alpha / 255.0
        gray = np.maximum(gray, alpha * gray)

    return np.clip(gray, 0.0, 1.0).astype(np.float32)


def preprocess_drawn_digit(grayscale: np.ndarray, canvas_size: int = 280) -> DrawnDigit:
    """Convert a drawn grayscale digit into 28x28 INT8 accelerator payloads."""

    crop = crop_to_ink(grayscale)
    centered = center_on_square(crop, size=canvas_size)
    mnist_float = _resize_with_pillow(centered, (28, 28)).reshape(28, 28)

    q: QuantizedArray = quantize_symmetric(mnist_float)
    packed_words = pack_int8x4(q.values.reshape(-1))
    return DrawnDigit(
        image_float=mnist_float,
        image_int8=q.values.reshape(28, 28),
        packed_words=packed_words,
        scale=q.scale,
    )


def ascii_preview(image: np.ndarray) -> str:
    chars = " .:-=+*#%@"
    img = np.asarray(image, dtype=np.float32).reshape(28, 28)
    img = img - img.min()
    if img.max() > 0:
        img = img / img.max()
    lines = []
    for row in img:
        lines.append("".join(chars[min(int(v * (len(chars) - 1)), len(chars) - 1)] for v in row))
    return "\n".join(lines)
