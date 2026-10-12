"""Run every layer of a quantized model on an accelerator backend."""

from __future__ import annotations

from dataclasses import dataclass, field

import numpy as np

from .mapping import assemble, plan_linear
from .model import QuantizedModel, requantize


@dataclass
class InferenceInfo:
    runs: list = field(default_factory=list)       # every Run sent, all layers, in order
    jobs: int = 0
    skipped: int = 0
    stats: list[dict] = field(default_factory=list)  # one per layer, from the backend


def infer(model: QuantizedModel, x_q: np.ndarray, execute, skip_zero: bool = True,
          **execute_kwargs) -> tuple[np.ndarray, InferenceInfo]:
    """Return int64 logits for x_q (samples, features); every dot product runs on `execute`.

    Between layers the host applies ReLU and the layer's right shift
    (model.requantize), exactly as model.golden_logits does in software.
    """

    info = InferenceInfo()
    x = x_q
    for layer in model.layers:
        plan = plan_linear(layer.w_q, x, skip_zero=skip_zero)
        results, stats = execute(plan.runs, **execute_kwargs) if plan.runs else ([], {})
        acc = assemble(plan, results, layer.b_q)
        info.runs += plan.runs
        info.jobs += plan.jobs
        info.skipped += plan.skipped_jobs
        info.stats.append(stats)
        x = requantize(acc, layer.shift) if layer.shift is not None else acc
    return x, info
