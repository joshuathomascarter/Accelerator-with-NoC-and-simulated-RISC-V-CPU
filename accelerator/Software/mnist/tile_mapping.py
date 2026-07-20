"""4-tile MNIST workload mapping.

The first useful mapping is output-neuron parallelism:

    tile 0 -> digits 0, 1, 2
    tile 1 -> digits 3, 4, 5
    tile 2 -> digits 6, 7
    tile 3 -> digits 8, 9

Each tile receives the same activation chunks, but different weights. That gives
good activation reuse and keeps each tile's weights local while it accumulates
its assigned logits.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable

import numpy as np

from accelerator.Software.mnist.accel_format import pack_int8x4


TILE_COUNT = 4
INPUT_FEATURES = 28 * 28
DIGIT_COUNT = 10


@dataclass(frozen=True)
class TileAssignment:
    tile_id: int
    digits: tuple[int, ...]


DEFAULT_ASSIGNMENTS: tuple[TileAssignment, ...] = (
    TileAssignment(tile_id=0, digits=(0, 1, 2)),
    TileAssignment(tile_id=1, digits=(3, 4, 5)),
    TileAssignment(tile_id=2, digits=(6, 7)),
    TileAssignment(tile_id=3, digits=(8, 9)),
)


def validate_assignments(assignments: Iterable[TileAssignment] = DEFAULT_ASSIGNMENTS) -> None:
    seen: list[int] = []
    for assignment in assignments:
        if assignment.tile_id < 0 or assignment.tile_id >= TILE_COUNT:
            raise ValueError(f"Invalid tile id {assignment.tile_id}")
        seen.extend(assignment.digits)

    if sorted(seen) != list(range(DIGIT_COUNT)):
        raise ValueError(f"Assignments must cover digits 0..9 exactly once, got {sorted(seen)}")


def activation_words_for_image(image_int8: np.ndarray) -> np.ndarray:
    """Pack a 28x28 INT8 image into activation words reused by all tiles."""

    image = np.asarray(image_int8, dtype=np.int8).reshape(INPUT_FEATURES)
    return pack_int8x4(image)


def weight_words_for_tile(weights_int8: np.ndarray, assignment: TileAssignment) -> np.ndarray:
    """Pack this tile's assigned output-neuron weights.

    The exported order is digit-major:

        all weights for first assigned digit,
        then all weights for second assigned digit,
        ...

    That is the easiest first software schedule for row-stationary reuse because
    each tile keeps a digit's weights local while the activation stream is
    replayed over chunks.
    """

    weights = np.asarray(weights_int8, dtype=np.int8)
    if weights.shape != (INPUT_FEATURES, DIGIT_COUNT):
        raise ValueError(f"Expected weights shape {(INPUT_FEATURES, DIGIT_COUNT)}, got {weights.shape}")

    tile_weights = weights[:, list(assignment.digits)].T.reshape(-1)
    return pack_int8x4(tile_weights)


def bias_words_for_tile(bias_int8: np.ndarray, assignment: TileAssignment) -> np.ndarray:
    bias = np.asarray(bias_int8, dtype=np.int8).reshape(DIGIT_COUNT)
    return pack_int8x4(bias[list(assignment.digits)])


def export_tile_payloads(
    weights_int8: np.ndarray,
    bias_int8: np.ndarray,
    image_int8: np.ndarray,
    assignments: Iterable[TileAssignment] = DEFAULT_ASSIGNMENTS,
) -> dict[str, np.ndarray]:
    """Return packed words keyed by tile and payload role."""

    validate_assignments(assignments)
    payloads: dict[str, np.ndarray] = {
        "activation_words": activation_words_for_image(image_int8),
    }

    for assignment in assignments:
        payloads[f"tile{assignment.tile_id}_weight_words"] = weight_words_for_tile(weights_int8, assignment)
        payloads[f"tile{assignment.tile_id}_bias_words"] = bias_words_for_tile(bias_int8, assignment)

    return payloads


def tile_reference_logits(
    image_int8: np.ndarray,
    weights_int8: np.ndarray,
    bias_int8: np.ndarray,
    assignments: Iterable[TileAssignment] = DEFAULT_ASSIGNMENTS,
) -> tuple[np.ndarray, dict[int, np.ndarray]]:
    """Compute logits using the same output-neuron split as the tile schedule."""

    validate_assignments(assignments)
    image_i32 = np.asarray(image_int8, dtype=np.int8).reshape(INPUT_FEATURES).astype(np.int32)
    weights_i32 = np.asarray(weights_int8, dtype=np.int8).astype(np.int32)
    bias_i32 = np.asarray(bias_int8, dtype=np.int8).reshape(DIGIT_COUNT).astype(np.int32)

    logits = np.zeros(DIGIT_COUNT, dtype=np.int32)
    per_tile: dict[int, np.ndarray] = {}

    for assignment in assignments:
        digit_idx = np.array(assignment.digits, dtype=np.int64)
        tile_logits = image_i32 @ weights_i32[:, digit_idx] + bias_i32[digit_idx]
        tile_logits = tile_logits.astype(np.int32)
        logits[digit_idx] = tile_logits
        per_tile[assignment.tile_id] = tile_logits

    return logits, per_tile
