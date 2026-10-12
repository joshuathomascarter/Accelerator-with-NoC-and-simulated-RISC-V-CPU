"""INT8x4 word packing and symmetric quantization.

Every accelerator data word holds four signed INT8 lanes:

    bits [7:0]   lane 0
    bits [15:8]  lane 1
    bits [23:16] lane 2
    bits [31:24] lane 3
"""

from __future__ import annotations

import numpy as np

LANES = 4


def quantize_symmetric(values: np.ndarray, scale: float | None = None) -> tuple[np.ndarray, float]:
    """Quantize to INT8 with a symmetric per-tensor scale (computed if not given)."""

    values = np.asarray(values, dtype=np.float64)
    if scale is None:
        max_abs = float(np.max(np.abs(values))) if values.size else 0.0
        scale = max_abs / 127.0 if max_abs > 0.0 else 1.0
    q = np.clip(np.round(values / scale), -128, 127).astype(np.int8)
    return q, scale


def pad_lanes(values: np.ndarray) -> np.ndarray:
    """Zero-pad the last axis to a multiple of four lanes."""

    values = np.asarray(values)
    pad = (-values.shape[-1]) % LANES
    if pad == 0:
        return values
    widths = [(0, 0)] * (values.ndim - 1) + [(0, pad)]
    return np.pad(values, widths)


def pack_int8x4(values: np.ndarray) -> np.ndarray:
    """Pack INT8 values along the last axis into uint32 words (shape [..., n/4])."""

    lanes = pad_lanes(np.asarray(values, dtype=np.int8)).view(np.uint8)
    lanes = lanes.reshape(*lanes.shape[:-1], -1, LANES).astype(np.uint32)
    return lanes[..., 0] | (lanes[..., 1] << 8) | (lanes[..., 2] << 16) | (lanes[..., 3] << 24)


def unpack_int8x4(words: np.ndarray) -> np.ndarray:
    """Unpack uint32 words into INT8 lanes (shape [..., 4*n])."""

    words = np.asarray(words, dtype=np.uint32)
    lanes = np.stack([(words >> (8 * i)) & 0xFF for i in range(LANES)], axis=-1).astype(np.uint8)
    return lanes.view(np.int8).reshape(*words.shape[:-1], -1)


def to_signed32(words: np.ndarray) -> np.ndarray:
    return np.asarray(words, dtype=np.uint32).view(np.int32)
