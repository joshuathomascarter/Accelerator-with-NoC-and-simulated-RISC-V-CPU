"""Map an INT8 linear layer onto the accelerator's runs.

One accelerator run drives up to four tiles. Each tile receives one weight
word and one activation word and returns their signed 32-bit dot product:

    result[t] = sum_{i<4} int8(weight[t].lane[i]) * int8(act[t].lane[i])

A layer y = W @ x + b with W of shape (outputs, inputs) is split into
4-input chunks. Every (output, chunk) pair is one tile job, jobs are packed four
per run, and the host sums the partial results and adds the bias.
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np

from .packing import pack_int8x4, to_signed32, unpack_int8x4

TILES = 4


@dataclass
class Run:
    """One accelerator transaction: up to four (weight, activation) word pairs."""

    weights: list[int]
    activations: list[int]

    @property
    def tiles(self) -> int:
        return len(self.weights)


def reference_run(run: Run) -> list[int]:
    """Bit-exact software model of one accelerator run (results as uint32)."""

    w = unpack_int8x4(np.array(run.weights, dtype=np.uint32)).reshape(-1, 4).astype(np.int64)
    a = unpack_int8x4(np.array(run.activations, dtype=np.uint32)).reshape(-1, 4).astype(np.int64)
    dots = (w * a).sum(axis=1)
    return [int(d) & 0xFFFF_FFFF for d in dots]


@dataclass
class LayerPlan:
    """Runs for a batch of samples through one linear layer, plus how to reassemble them."""

    runs: list[Run]
    job_index: np.ndarray      # (n_jobs, 3): sample, output, chunk for each tile job in run order
    samples: int
    outputs: int
    chunks: int
    skipped_jobs: int

    @property
    def jobs(self) -> int:
        return len(self.job_index)


def plan_linear(weights_q: np.ndarray, inputs_q: np.ndarray, skip_zero: bool = True) -> LayerPlan:
    """Build the run list for inputs_q (samples, inputs) through weights_q (outputs, inputs).

    With skip_zero, jobs whose weight or activation word is all zeros are not sent
    to the hardware: their dot product is known to be zero.
    """

    w_words = pack_int8x4(weights_q)          # (outputs, chunks)
    x_words = pack_int8x4(inputs_q)           # (samples, chunks)
    samples, chunks = x_words.shape
    outputs = w_words.shape[0]

    s, o, k = np.meshgrid(np.arange(samples), np.arange(outputs), np.arange(chunks), indexing="ij")
    jobs = np.stack([s.ravel(), o.ravel(), k.ravel()], axis=1)
    jw = w_words[jobs[:, 1], jobs[:, 2]]
    jx = x_words[jobs[:, 0], jobs[:, 2]]
    keep = (jw != 0) & (jx != 0) if skip_zero else np.ones(len(jobs), dtype=bool)
    jobs, jw, jx = jobs[keep], jw[keep], jx[keep]

    runs = [
        Run(weights=[int(v) for v in jw[i:i + TILES]], activations=[int(v) for v in jx[i:i + TILES]])
        for i in range(0, len(jobs), TILES)
    ]
    return LayerPlan(runs=runs, job_index=jobs, samples=samples, outputs=outputs,
                     chunks=chunks, skipped_jobs=int((~keep).sum()))


def assemble(plan: LayerPlan, results: list[list[int]], bias_q: np.ndarray) -> np.ndarray:
    """Sum per-tile partial results back into int64 logits of shape (samples, outputs)."""

    flat = np.concatenate([np.asarray(r[:run.tiles], dtype=np.uint32)
                           for r, run in zip(results, plan.runs)]) if plan.runs else np.zeros(0, np.uint32)
    partial = to_signed32(flat).astype(np.int64)
    logits = np.zeros((plan.samples, plan.outputs), dtype=np.int64)
    np.add.at(logits, (plan.job_index[:, 0], plan.job_index[:, 1]), partial)
    return logits + np.asarray(bias_q, dtype=np.int64)[None, :]
