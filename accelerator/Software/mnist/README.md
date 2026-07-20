# MNIST Software Flow

This folder holds the software side of the PYNQ-Z2 demo.

The intended split is:

- `train_quant_mnist.py`: train a tiny MNIST model and export INT8 weights.
- `pynq_demo.py`: PYNQ-side demo script that loads the bitstream, sends one image to the accelerator, reads the result, and optionally drives LEDs.
- `accel_format.py`: shared packing helpers for 4 x INT8 values per 32-bit word.
- `draw_digit.py`: preprocessing helpers for live drawn-digit notebook demos.

The current RTL accelerator is ready for small packed INT8 words, but the final board path still needs an AXI/MMIO or AXI DMA wrapper. Until that wrapper exists, the PYNQ demo uses a small `AcceleratorDriver` abstraction with TODO methods where the AXI transactions will go.

## Tile Mapping

The first MNIST mapping uses the four tiles as parallel output-neuron workers:

```text
tile 0 -> digits 0, 1, 2
tile 1 -> digits 3, 4, 5
tile 2 -> digits 6, 7
tile 3 -> digits 8, 9
```

All four tiles reuse the same packed activation stream. Each tile receives only
the weights and biases for its assigned digits. That is the clean first mapping
because it maximizes activation reuse and keeps each tile's weights local.

Recommended first board demo:

1. Train/export a quantized softmax MNIST classifier.
2. Use Python on the ARM side to load one MNIST image.
3. Quantize and pack the image into 32-bit activation words.
4. Send the same activation words to all tiles.
5. Send per-tile weight/bias words according to the digit mapping above.
6. Read back per-tile logits and reconstruct the 10-class output vector.
7. Show the prediction in Jupyter and optionally mirror it on the four user LEDs.

The four LEDs are useful as a secondary display:

```text
digit 7 -> LED binary 0111
```

But the primary demo should be the Jupyter notebook because it can show the image, predicted digit, and logits clearly.

## Draw-Your-Own-Digit Demo

Use `notebooks/draw_digit_realtime_demo.ipynb` for the live demo path.

It does:

1. Draw on a 280x280 canvas.
2. Crop and center the ink.
3. Downsample to 28x28.
4. Quantize to INT8.
5. Pack to accelerator words.
6. Run software reference today or hardware driver later.
7. Print the predicted digit and mirror it on the LEDs.
