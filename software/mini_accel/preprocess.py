"""Turn a drawing or a 28x28 MNIST image into the 8x8, 0-16 accelerator input format."""

from __future__ import annotations

import numpy as np


def to_digits_format(ink: np.ndarray) -> np.ndarray | None:
    """Reduce a binary image of any size to 8x8 with values 0-16.

    Same method as the UCI/scikit-learn "digits" set: crop to the ink, scale it to
    fit 28x28 (narrow shapes such as a "1" are stretched to at least 16 pixels
    wide), centre it in a 32x32 bitmap, and count the ink pixels in each 4x4 block.
    The drawing demo and the MNIST training data both go through this function,
    so the model is trained on exactly what the demo produces.
    """

    ys, xs = np.nonzero(ink)
    if len(xs) == 0:
        return None
    crop = ink[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    h, w = crop.shape
    scale = 28 / max(h, w)
    nh, nw = max(1, round(h * scale)), max(16, round(w * scale))
    rows = (np.arange(nh) * h / nh).astype(int).clip(0, h - 1)
    cols = (np.arange(nw) * w / nw).astype(int).clip(0, w - 1)
    bitmap = np.zeros((32, 32), dtype=np.int64)
    top, left = (32 - nh) // 2, (32 - nw) // 2
    bitmap[top:top + nh, left:left + nw] = crop[np.ix_(rows, cols)] > 0
    return bitmap.reshape(8, 4, 8, 4).sum(axis=(1, 3))
