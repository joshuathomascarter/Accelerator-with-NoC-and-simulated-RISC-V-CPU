# Mini NoC Accelerator + RISC-V-style CPU on a PYNQ-Z2

An INT8 neural-network accelerator and a small CPU, both written in
SystemVerilog and running together on a PYNQ-Z2 FPGA board. The CPU runs a
two-layer neural network by itself: it streams weights and inputs into the
accelerator, collects the results, applies the activation function, and shows
the predicted digit on the board's LEDs.

- **Accelerator:** four compute tiles on a 2x2 network-on-chip. Each tile holds
  a 2x2 grid of multiply-accumulate units and returns one 4-element signed
  8-bit dot product per run.
- **CPU:** a single-cycle RISC-V-style core (an RV32I subset) with its own
  instruction and data memory. It controls the accelerator through
  memory-mapped registers.
- **Host:** the PC (over the USB cable) or the board's ARM processor loads the
  program and data, then either lets the CPU run or drives the accelerator
  directly.

## Results on the board

All results below were measured on the PYNQ-Z2. Each one was checked against a
software model of the same 8-bit network. The FPGA's 32-bit output scores had
to match it exactly, not only the predicted class.

| Dataset | Network | Who drives the accelerator | Test inputs | Accuracy | Exact match with software |
|---|---|---|---|---|---|
| MNIST handwritten digits, reduced to 8x8 | 64 -> 32 -> 10 | **the CPU on the FPGA** | 10,000 (full test set) | 96.0 % | 10,000 / 10,000 |
| Handwritten digits 8x8 (scikit-learn) | 64 -> 10 | PC over USB | 450 (full test set) | 96.0 % | 450 / 450 |
| Iris flowers | 4 -> 3 | PC over USB | 38 (full test set) | 97.4 % | 38 / 38 |

The same networks in 32-bit floating point score 96.1 %, 96.0 % and 97.4 %, so
the 8-bit versions lose almost no accuracy.

**Who drives the accelerator matters.** One MNIST image needs 148 accelerator
runs. When the PC drives each run over the USB debug cable, every register
access is a USB round trip, and an image takes about 4.4 s. When the CPU on the
FPGA drives the runs, the PC only sends the 16 words of the image and reads
back the answer: **43 images per second, about 190x faster on the same board.**
In simulation, the CPU itself needs 22,650 clock cycles per image, which is
0.50 ms at 45 MHz.

## Speed compared with software

The accelerator is correct, but this version is not faster than a desktop PC.
Times are per image for the MNIST-8 network. The full tables are in
[docs/RESULTS.md](docs/RESULTS.md).

| Implementation | Time per image |
|---|---|
| Pure Python loops on the PC | about 400 µs |
| NumPy on the PC, one image at a time | 51 µs |
| NumPy on the PC, whole test set at once | 2.4 µs |
| FPGA accelerator compute only (45 MHz) | 301 µs |
| FPGA, the CPU on the FPGA drives every run (45 MHz) | 503 µs |

Reasons, in order of impact:

- The four tiles run one after another instead of at the same time.
- Weights are resent for every run instead of staying in the tiles.
- The CPU is single-cycle, which limits the clock to 45 MHz.

Running the tiles in parallel, keeping weights in the tiles, and pipelining the
CPU are the next steps.

## How it works

1. **One tile, one dot product.** A tile receives one 32-bit weight word and
   one 32-bit input word, each holding four signed 8-bit numbers. Each of its
   four multiply-accumulate units multiplies one pair. The tile adds the four
   products and returns a signed 32-bit result.
2. **One run, up to four tiles.** The weight and input words are written, then
   the run is started. A scheduler sends each tile its packets (clear, weight,
   start, compute, reduce) over the network-on-chip. The tiles send their
   results back, and they are read in tile order.
3. **A layer.** A layer with 64 inputs and 32 outputs is split into groups of
   4 inputs: 16 groups x 32 outputs = 512 dot products, four per run. The
   partial sums are added and the bias is applied.
4. **Between layers.** Negative values are set to zero (ReLU), and each value is
   shifted right and limited to 0-127, so the next layer gets 8-bit inputs
   again.
5. **The CPU firmware** does steps 3 and 4 for both layers, then picks the
   highest score. It is 151 instructions, written in assembly
   ([software/mini_accel/firmware.py](software/mini_accel/firmware.py)) and
   assembled by a small assembler for this CPU
   ([software/mini_accel/rv32.py](software/mini_accel/rv32.py)).

Register map and CPU memory map: [docs/PYNQ_REGISTER_MAP.md](docs/PYNQ_REGISTER_MAP.md).

## FPGA build

| | |
|---|---|
| Device | Zynq-7020 (xc7z020clg400-1) on a TUL PYNQ-Z2 |
| Clock | 45 MHz, timing met with 1.4 ns of slack |
| Logic used | 8,608 LUTs (16 %), 4,683 flip-flops (4 %), no DSP or block RAM |
| Power | 1.7 W total, including the ARM processing system |
| Tools | Vivado 2026.1 |

## Running it

Requirements: Vivado (any version with Zynq-7000 support), and Python 3 with
`numpy` and `scikit-learn`. The MNIST data (about 15 MB) is downloaded the
first time it is needed.

**Tests.** Every testbench, 300 random accelerator runs compared with a Python
model, and the CPU running the network on 5 images:

```text
python scripts/run_regression.py
```

**Build the bitstream.** Writes `overlays/mini_accel/mini_accel.bit` and reports.
The build stops without writing the bitstream if timing is not met:

```text
vivado -mode batch -source Vivado/build_pynq_z2.tcl
```

**Run on the board from a PC.** Power the board and connect the micro-USB
cable. These program the FPGA over JTAG, so nothing needs to be copied to the
board:

```text
python software/run_dataset.py --dataset mnist8 --backend cpu-jtag --samples 0   # the CPU runs the network
python software/run_dataset.py --dataset digits --backend jtag --samples 0       # the PC drives every run
```

Other backends: `model` (Python model only), `xsim` and `cpu-xsim` (simulation
with exact cycle counts), and `pynq` and `cpu-pynq` (run on the board's ARM; see
`scripts/make_board_bundle.py`).

**Draw a digit and classify it on the board:**

```text
python software/draw_digit_demo.py
```

Draw a digit with the mouse and press Run. You can choose who drives the
accelerator:

- **PC over USB:** the window lists every run. It shows the weight and input
  words sent to the board and the result each tile returns.
- **The CPU on the FPGA:** the PC sends only the image. The CPU runs both
  layers and returns the answer.

Either way, the board's 10 scores are shown next to the scores computed in
software, and the predicted digit is shown in binary on the board's four LEDs.
Use `--backend model` to try the window without a board.

## Board LEDs

When the CPU is running, the LEDs show the last predicted digit in binary. When
the PC drives the accelerator:

| LED | Meaning |
|---|---|
| LD3 | last run finished |
| LD2 | results waiting to be read |
| LD1 | accelerator busy |
| LD0 | bus protocol error |

## Repository layout

```text
accelerator/   network-on-chip, scheduler, tiles, multiply-accumulate units
cpu/           the RISC-V-style CPU and its MMIO bridge
rtl/           AXI-Lite registers, accelerator core, board top level (pynq_soc_top)
software/      Python driver, assembler, CPU firmware, dataset runner, digit demo
scripts/       test runner, benchmark, board bundle
Tests/         testbenches
Vivado/        block design and bitstream build script, pin constraints
overlays/      generated bitstream and reports (not committed)
docs/          register map, verification results, speed results
```
