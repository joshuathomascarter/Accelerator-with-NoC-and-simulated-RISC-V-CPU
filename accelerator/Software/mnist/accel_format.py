"""Packing helpers for the mini accelerator MNIST demo.

The RTL datapath currently moves packed 32-bit words where each word contains
four signed INT8 lanes:

    bits [7:0]   lane 0
    bits [15:8]  lane 1
    bits [23:16] lane 2
    bits [31:24] lane 3

These helpers keep that packing convention consistent across training,
export, and PYNQ demo code.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import numpy as np


LANES_PER_WORD = 4


@dataclass(frozen=True)
class QuantizedArray:
    values: np.ndarray
    scale: float
    zero_point: int = 0


def quantize_symmetric(values: np.ndarray, bits: int = 8) -> QuantizedArray:
    """Symmetrically quantize a float array to signed INT8-style values."""

    if bits != 8:
        raise ValueError("Only 8-bit quantization is supported for this demo")

    values = np.asarray(values, dtype=np.float32)
    max_abs = float(np.max(np.abs(values))) if values.size else 0.0
    scale = max_abs / 127.0 if max_abs > 0.0 else 1.0
    quantized = np.round(values / scale)
    quantized = np.clip(quantized, -128, 127).astype(np.int8)
    return QuantizedArray(values=quantized, scale=scale, zero_point=0)


def dequantize_symmetric(q: QuantizedArray) -> np.ndarray:
    return q.values.astype(np.float32) * np.float32(q.scale)


def pack_int8x4(values: Iterable[int] | np.ndarray) -> np.ndarray:
    """Pack signed INT8 values into little-lane 32-bit words."""

    arr = np.asarray(list(values) if not isinstance(values, np.ndarray) else values)
    arr = arr.astype(np.int8).reshape(-1)

    pad = (-arr.size) % LANES_PER_WORD
    if pad:
        arr = np.concatenate([arr, np.zeros(pad, dtype=np.int8)])

    lanes = arr.reshape(-1, LANES_PER_WORD).astype(np.uint8)
    words = (
        lanes[:, 0].astype(np.uint32)
        | (lanes[:, 1].astype(np.uint32) << 8)
        | (lanes[:, 2].astype(np.uint32) << 16)
        | (lanes[:, 3].astype(np.uint32) << 24)
    )
    return words.astype(np.uint32)


def unpack_int8x4(words: Iterable[int] | np.ndarray) -> np.ndarray:
    """Unpack little-lane 32-bit words into signed INT8 values."""

    words_arr = np.asarray(list(words) if not isinstance(words, np.ndarray) else words)
    words_arr = words_arr.astype(np.uint32).reshape(-1)
    lanes = np.empty(words_arr.size * LANES_PER_WORD, dtype=np.uint8)
    lanes[0::4] = words_arr & 0xFF
    lanes[1::4] = (words_arr >> 8) & 0xFF
    lanes[2::4] = (words_arr >> 16) & 0xFF
    lanes[3::4] = (words_arr >> 24) & 0xFF
    return lanes.view(np.int8)


def write_hex_words(path: str | Path, words: np.ndarray) -> None:
    """Write one 32-bit hex word per line for testbenches or ROM init."""

    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        for word in np.asarray(words, dtype=np.uint32).reshape(-1):
            f.write(f"{int(word):08x}\n")


def read_hex_words(path: str | Path) -> np.ndarray:
    with Path(path).open("r", encoding="utf-8") as f:
        return np.array([int(line.strip(), 16) for line in f if line.strip()], dtype=np.uint32)
