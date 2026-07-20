"""Train and export a tiny quantized MNIST model.

This intentionally starts with a softmax classifier instead of a large CNN.
That keeps the first FPGA demo honest and achievable:

    784 input pixels -> 10 digit logits

The model is small enough to understand, quantize, tile, and compare against
the RTL accelerator path. We can upgrade to a hidden-layer MLP once the board
transport is solid.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np

from accelerator.Software.mnist.accel_format import pack_int8x4, quantize_symmetric, write_hex_words
from accelerator.Software.mnist.tile_mapping import DEFAULT_ASSIGNMENTS, export_tile_payloads, tile_reference_logits


def load_mnist() -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Load MNIST using TensorFlow if available, otherwise sklearn OpenML."""

    try:
        from tensorflow.keras.datasets import mnist  # type: ignore

        (x_train, y_train), (x_test, y_test) = mnist.load_data()
        x_train = x_train.reshape(-1, 784).astype(np.float32) / 255.0
        x_test = x_test.reshape(-1, 784).astype(np.float32) / 255.0
        return x_train, y_train.astype(np.int64), x_test, y_test.astype(np.int64)
    except Exception:
        from sklearn.datasets import fetch_openml  # type: ignore
        from sklearn.model_selection import train_test_split  # type: ignore

        x, y = fetch_openml("mnist_784", version=1, return_X_y=True, as_frame=False)
        x = x.astype(np.float32) / 255.0
        y = y.astype(np.int64)
        return train_test_split(x, y, test_size=10_000, random_state=1, stratify=y)


def one_hot(labels: np.ndarray, classes: int = 10) -> np.ndarray:
    out = np.zeros((labels.size, classes), dtype=np.float32)
    out[np.arange(labels.size), labels] = 1.0
    return out


def softmax(logits: np.ndarray) -> np.ndarray:
    shifted = logits - np.max(logits, axis=1, keepdims=True)
    exp = np.exp(shifted)
    return exp / np.sum(exp, axis=1, keepdims=True)


def train_softmax(
    x_train: np.ndarray,
    y_train: np.ndarray,
    epochs: int,
    batch_size: int,
    lr: float,
    seed: int,
) -> tuple[np.ndarray, np.ndarray]:
    rng = np.random.default_rng(seed)
    num_features = x_train.shape[1]
    num_classes = 10

    weights = rng.normal(0.0, 0.01, size=(num_features, num_classes)).astype(np.float32)
    bias = np.zeros(num_classes, dtype=np.float32)
    y_oh = one_hot(y_train, num_classes)

    for epoch in range(epochs):
        order = rng.permutation(x_train.shape[0])
        total_loss = 0.0

        for start in range(0, order.size, batch_size):
            idx = order[start : start + batch_size]
            xb = x_train[idx]
            yb = y_oh[idx]

            logits = xb @ weights + bias
            probs = softmax(logits)
            loss = -np.mean(np.sum(yb * np.log(probs + 1e-8), axis=1))
            total_loss += float(loss) * idx.size

            grad_logits = (probs - yb) / idx.size
            grad_w = xb.T @ grad_logits
            grad_b = np.sum(grad_logits, axis=0)

            weights -= lr * grad_w
            bias -= lr * grad_b

        train_pred = np.argmax(x_train @ weights + bias, axis=1)
        train_acc = float(np.mean(train_pred == y_train))
        avg_loss = total_loss / float(x_train.shape[0])
        print(f"epoch {epoch + 1:02d}: loss={avg_loss:.4f} train_acc={train_acc:.4f}")

    return weights, bias


def accuracy(x: np.ndarray, y: np.ndarray, weights: np.ndarray, bias: np.ndarray) -> float:
    pred = np.argmax(x @ weights + bias, axis=1)
    return float(np.mean(pred == y))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out-dir", default="artifacts/mnist")
    parser.add_argument("--epochs", type=int, default=6)
    parser.add_argument("--batch-size", type=int, default=256)
    parser.add_argument("--lr", type=float, default=0.5)
    parser.add_argument("--seed", type=int, default=7)
    parser.add_argument("--train-limit", type=int, default=20000)
    args = parser.parse_args()

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    x_train, y_train, x_test, y_test = load_mnist()
    if args.train_limit:
        x_train = x_train[: args.train_limit]
        y_train = y_train[: args.train_limit]

    weights, bias = train_softmax(
        x_train=x_train,
        y_train=y_train,
        epochs=args.epochs,
        batch_size=args.batch_size,
        lr=args.lr,
        seed=args.seed,
    )

    fp32_acc = accuracy(x_test, y_test, weights, bias)
    q_weights = quantize_symmetric(weights)
    q_bias = quantize_symmetric(bias)
    q_images = quantize_symmetric(x_test[:256])

    # Host-side reference for the quantized payloads. This is not bit-exact
    # final hardware math yet, but it catches bad packing and scale mistakes.
    deq_w = q_weights.values.astype(np.float32) * q_weights.scale
    deq_b = q_bias.values.astype(np.float32) * q_bias.scale
    quant_acc = accuracy(x_test, y_test, deq_w, deq_b)

    weight_words = pack_int8x4(q_weights.values.reshape(-1))
    bias_words = pack_int8x4(q_bias.values.reshape(-1))
    sample_words = pack_int8x4(q_images.values.reshape(-1))
    tile_payloads = export_tile_payloads(
        weights_int8=q_weights.values,
        bias_int8=q_bias.values,
        image_int8=q_images.values[0],
    )
    tile_ref_logits, tile_ref_by_tile = tile_reference_logits(
        image_int8=q_images.values[0],
        weights_int8=q_weights.values,
        bias_int8=q_bias.values,
    )

    np.savez(
        out_dir / "mnist_softmax_int8.npz",
        weights_int8=q_weights.values,
        weights_scale=np.float32(q_weights.scale),
        bias_int8=q_bias.values,
        bias_scale=np.float32(q_bias.scale),
        sample_images_int8=q_images.values,
        sample_image_scale=np.float32(q_images.scale),
        sample_labels=y_test[:256].astype(np.int64),
        weight_words=weight_words,
        bias_words=bias_words,
        sample_words=sample_words,
        tile_ref_logits=tile_ref_logits,
        **tile_payloads,
    )

    write_hex_words(out_dir / "weights.hex", weight_words)
    write_hex_words(out_dir / "bias.hex", bias_words)
    write_hex_words(out_dir / "sample_images.hex", sample_words)
    write_hex_words(out_dir / "sample0_activation_words.hex", tile_payloads["activation_words"])
    for assignment in DEFAULT_ASSIGNMENTS:
        write_hex_words(
            out_dir / f"tile{assignment.tile_id}_weights.hex",
            tile_payloads[f"tile{assignment.tile_id}_weight_words"],
        )
        write_hex_words(
            out_dir / f"tile{assignment.tile_id}_bias.hex",
            tile_payloads[f"tile{assignment.tile_id}_bias_words"],
        )

    metadata = {
        "model": "softmax_784x10",
        "input_shape": [1, 28, 28],
        "classes": 10,
        "weight_shape": list(q_weights.values.shape),
        "bias_shape": list(q_bias.values.shape),
        "weight_scale": q_weights.scale,
        "bias_scale": q_bias.scale,
        "sample_image_scale": q_images.scale,
        "fp32_accuracy": fp32_acc,
        "dequantized_accuracy": quant_acc,
        "packing": "4 signed INT8 lanes per little-lane 32-bit word",
        "tile_mapping": [
            {"tile_id": assignment.tile_id, "digits": list(assignment.digits)}
            for assignment in DEFAULT_ASSIGNMENTS
        ],
        "sample0_tile_reference": {
            str(tile_id): logits.astype(int).tolist()
            for tile_id, logits in tile_ref_by_tile.items()
        },
    }
    (out_dir / "metadata.json").write_text(json.dumps(metadata, indent=2), encoding="utf-8")

    print(f"fp32 test accuracy: {fp32_acc:.4f}")
    print(f"dequantized test accuracy: {quant_acc:.4f}")
    print(f"wrote {out_dir}")


if __name__ == "__main__":
    main()
