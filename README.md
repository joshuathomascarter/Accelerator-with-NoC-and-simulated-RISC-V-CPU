# Mini NoC Accelerator with Simulated RISC-V CPU and PYNQ-Z2 AXI Control

This repository contains a small SystemVerilog accelerator built around four
2x2 processing-element tiles connected by a 2x2 network-on-chip. A compact
RISC-V-style CPU is included for simulation and MMIO verification. On a
PYNQ-Z2 board, the custom CPU is not synthesized; the Zynq ARM processor
controls the accelerator through AXI-Lite.

## Architecture

The accelerator consists of:

- four compute tiles arranged in a 2x2 grid;
- a 2x2 systolic processing-element array in each tile;
- signed INT8 multiply-accumulate datapaths with 32-bit accumulators;
- packetized clear, weight, start, compute, reduce, result, and done messages;
- XY-routed request and response traffic over a simple grid NoC;
- a scheduler that sends work to each selected tile;
- ordered result storage for AXI-Lite reads.

Two host paths are provided:

1. The simulated CPU issues loads and stores through `cpu_mmio_bridge` for RTL
   verification.
2. `pynq_accel_top` connects the Zynq processing system's AXI GP0 master to the
   real accelerator for the PYNQ-Z2 implementation.

## Current operation

For each selected tile, software writes one packed 32-bit weight word and one
packed 32-bit activation word. Each word contains four signed INT8 lanes. A
start command causes the scheduler to send the data through the NoC, execute
the tile, and return one packed 32-bit result. Results are read in tile order.

The AXI-Lite register map is documented in
[`docs/PYNQ_REGISTER_MAP.md`](docs/PYNQ_REGISTER_MAP.md). The main sequence is:

1. clear the accelerator;
2. write the tile count;
3. write one weight word per tile;
4. write one activation word per tile;
5. start a final-layer run;
6. poll the status register;
7. read one result per tile.

## Repository layout

```text
accelerator/   NoC, scheduler, storage, tiles, PE arrays, and Python software
cpu/           Simulated RISC-V-style CPU and MMIO bridge
rtl/           PYNQ AXI-Lite wrapper, result readback, and board accelerator top
Tests/         CPU, NoC, accelerator, AXI-Lite, and end-to-end testbenches
Vivado/        PYNQ-Z2 XSIM and block-design/bitstream scripts
docs/          Register map and verification results
notebooks/     MNIST and digit-drawing software prototypes
scripts/       Local regression helper
overlays/      Destination and instructions for generated PYNQ overlay files
```

## Verification

The completed checks are recorded in
[`docs/VERIFICATION_RESULTS.md`](docs/VERIFICATION_RESULTS.md). They include:

- standalone AXI-Lite register simulation;
- Verilator elaboration and lint of the complete PYNQ hierarchy;
- Yosys/Slang synthesis checking;
- synthesized-netlist simulations for one-tile and four-tile AXI transactions;
- Python syntax checks for the board driver and smoke test.

To repeat the board-facing simulations with Vivado XSIM:

```text
vivado -mode batch -source Vivado/run_preflight_sim.tcl
```

## Building the PYNQ-Z2 overlay

Vivado with Zynq-7000 device support is required. Run:

```text
vivado -mode batch -source Vivado/build_pynq_z2.tcl
```

The script creates a Zynq processing-system block design, connects GP0 AXI to
the accelerator, assigns address `0x43C00000`, runs implementation, and writes
the following files under `overlays/mini_accel/`:

- `mini_accel.bit`
- `mini_accel.hwh`
- `utilization.rpt`
- `timing_summary.rpt`

Copy the bitstream, HWH file, `pynq_driver.py`, and `pynq_smoke_test.py` to the
PYNQ-Z2. On the board, run:

```bash
python3 pynq_smoke_test.py --bitstream mini_accel.bit --tiles 4
```

## Limitations

- The custom CPU is a small simulation model, not the processor used on the
  physical board.
- The current board transaction accepts one packed weight word and one packed
  activation word per tile per run.
- Full 28x28 MNIST inference is not implemented in hardware. It requires
  multi-word weight storage and accumulation across all 784 input features.
- AXI DMA is not implemented; board communication currently uses AXI-Lite.
- Vivado timing closure and physical-board behavior must be checked with the
  generated implementation reports and the PYNQ-Z2 board.
