"""Train small classifiers and quantize them for the accelerator.

A model is a list of linear layers, logits = W @ x + b, each run on the
accelerator. Inputs and weights are INT8 with symmetric per-tensor scales, and
biases are INT32 at the accumulator scale. Between layers the host (or the CPU)
applies ReLU and an arithmetic right shift back to INT8:

    h = clip(max(acc, 0) >> shift, 0, 127)

A power-of-two shift keeps that step to one instruction on the CPU.

Datasets:
    iris     4 features, 3 classes, logistic regression
    digits   scikit-learn 8x8 digits, 64 -> 10 logistic regression
    mnist8   MNIST reduced to 8x8 with the drawing demo's preprocessing,
             64 -> 32 -> 10 network (the model used by the drawing demo)
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path

import numpy as np

from .packing import quantize_symmetric

DATASETS = ("iris", "digits", "mnist8")
REPO = Path(__file__).resolve().parents[2]
CACHE = REPO / "build" / "models"
DATA = REPO / "build" / "data"


@dataclass
class Layer:
    w_q: np.ndarray            # (outputs, inputs) int8
    b_q: np.ndarray            # (outputs,) int32
    shift: int | None = None   # ReLU + >> shift after this layer; None for the output layer


def requantize(acc: np.ndarray, shift: int) -> np.ndarray:
    return np.clip(np.maximum(acc, 0) >> shift, 0, 127).astype(np.int8)


@dataclass
class QuantizedModel:
    name: str
    layers: list[Layer]
    x_test_q: np.ndarray       # (samples, features) int8
    y_test: np.ndarray         # (samples,)
    float_test_accuracy: float | None = None
    x_scale: float = 1.0       # float input = int8 input * x_scale
    notes: dict = field(default_factory=dict)

    @property
    def features(self) -> int:
        return int(self.layers[0].w_q.shape[1])

    @property
    def classes(self) -> int:
        return int(self.layers[-1].w_q.shape[0])

    def golden_logits(self, x_q: np.ndarray | None = None) -> np.ndarray:
        x = (self.x_test_q if x_q is None else x_q).astype(np.int64)
        for layer in self.layers:
            acc = x @ layer.w_q.astype(np.int64).T + layer.b_q.astype(np.int64)
            x = requantize(acc, layer.shift).astype(np.int64) if layer.shift is not None else acc
        return x

    def save(self, path: str | Path) -> None:
        Path(path).parent.mkdir(parents=True, exist_ok=True)
        arrays = {f"w{i}": l.w_q for i, l in enumerate(self.layers)}
        arrays |= {f"b{i}": l.b_q for i, l in enumerate(self.layers)}
        arrays |= {f"s{i}": np.int64(-1 if l.shift is None else l.shift) for i, l in enumerate(self.layers)}
        np.savez(path, name=self.name, n_layers=len(self.layers), x_test_q=self.x_test_q,
                 y_test=self.y_test, x_scale=self.x_scale,
                 float_test_accuracy=np.nan if self.float_test_accuracy is None else self.float_test_accuracy,
                 **arrays)

    @classmethod
    def load(cls, path: str | Path) -> "QuantizedModel":
        d = np.load(path)
        layers = [Layer(d[f"w{i}"], d[f"b{i}"], None if int(d[f"s{i}"]) < 0 else int(d[f"s{i}"]))
                  for i in range(int(d["n_layers"]))]
        acc = float(d["float_test_accuracy"])
        return cls(name=str(d["name"]), layers=layers, x_test_q=d["x_test_q"], y_test=d["y_test"],
                   float_test_accuracy=None if np.isnan(acc) else acc, x_scale=float(d["x_scale"]))


def _mnist8() -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """MNIST (60k train / 10k test) reduced to 8x8 by to_digits_format; cached in build/data."""

    from .preprocess import to_digits_format

    cached = DATA / "mnist8.npz"
    if not cached.exists():
        from sklearn.datasets import fetch_openml  # type: ignore

        print("Downloading MNIST (about 15 MB, once)...")
        x, y = fetch_openml("mnist_784", version=1, return_X_y=True, as_frame=False, parser="liac-arff")
        x8 = np.stack([to_digits_format((im.reshape(28, 28) > 100).astype(np.uint8)) for im in x])
        DATA.mkdir(parents=True, exist_ok=True)
        np.savez_compressed(cached, x=x8.reshape(-1, 64).astype(np.uint8), y=y.astype(np.int64))
    d = np.load(cached)
    x, y = d["x"].astype(np.float64), d["y"]
    return x[:60000], x[60000:], y[:60000], y[60000:]


def _sklearn(name: str):
    from sklearn import datasets  # type: ignore
    from sklearn.model_selection import train_test_split  # type: ignore

    x, y = (datasets.load_iris if name == "iris" else datasets.load_digits)(return_X_y=True)
    return train_test_split(x.astype(np.float64), y, test_size=0.25, random_state=0, stratify=y)


def _train_logistic(name: str) -> QuantizedModel:
    from sklearn.linear_model import LogisticRegression  # type: ignore

    x_train, x_test, y_train, y_test = _sklearn(name)
    # Iris features are centred so they use the signed INT8 range. Pixel data is
    # kept as-is so blank pixels stay exactly zero (and their jobs can be skipped).
    if name == "iris":
        mean, std = x_train.mean(axis=0), x_train.std(axis=0)
        x_train, x_test = (x_train - mean) / std, (x_test - mean) / std

    clf = LogisticRegression(max_iter=5000).fit(x_train, y_train)
    _, x_scale = quantize_symmetric(x_train)
    x_test_q, _ = quantize_symmetric(x_test, x_scale)
    w_q, w_scale = quantize_symmetric(clf.coef_)
    b_q = np.round(clf.intercept_ / (x_scale * w_scale)).astype(np.int32)
    return QuantizedModel(name, [Layer(w_q, b_q)], x_test_q, np.asarray(y_test),
                          float(clf.score(x_test, y_test)), x_scale)


def _train_mlp(name: str, hidden: int = 32) -> QuantizedModel:
    from sklearn.neural_network import MLPClassifier  # type: ignore

    x_train, x_test, y_train, y_test = _mnist8()
    clf = MLPClassifier(hidden_layer_sizes=(hidden,), max_iter=80, random_state=0)
    clf.fit(x_train / 16.0, y_train)
    float_acc = float(clf.score(x_test / 16.0, y_test))

    x_scale = 16.0 / 127.0                       # pixel counts 0..16 -> int8 0..127
    s_in = x_scale / 16.0                        # network input = x_q * s_in
    xq_train = np.round(x_train / x_scale).astype(np.int8)
    x_test_q = np.round(x_test / x_scale).astype(np.int8)

    w1, s_w1 = quantize_symmetric(clf.coefs_[0].T)
    w2_f, b1_f, b2_f = clf.coefs_[1].T, clf.intercepts_[0], clf.intercepts_[1]
    b1 = np.round(b1_f / (s_in * s_w1)).astype(np.int32)
    w2, s_w2 = quantize_symmetric(w2_f)

    # Pick the shift that gives the best training accuracy (usually the one that
    # maps the largest hidden activations to about 127).
    best = None
    for shift in range(4, 20):
        s_h = s_in * s_w1 * 2 ** shift
        b2 = np.round(b2_f / (s_h * s_w2)).astype(np.int32)
        m = QuantizedModel(name, [Layer(w1, b1, shift), Layer(w2, b2)], x_test_q, np.asarray(y_test),
                           float_acc, x_scale)
        acc = float((m.golden_logits(xq_train[:10000]).argmax(1) == y_train[:10000]).mean())
        if best is None or acc > best[0]:
            best = (acc, m)
    return best[1]


def train_quantized(name: str, use_cache: bool = True) -> QuantizedModel:
    """Train (or load from build/models) the quantized model for a dataset."""

    if name not in DATASETS:
        raise ValueError(f"Unknown dataset {name!r}; choose from {DATASETS}")
    path = CACHE / f"{name}.npz"
    if use_cache and path.exists():
        return QuantizedModel.load(path)
    model = _train_mlp(name) if name == "mnist8" else _train_logistic(name)
    model.save(path)
    return model
