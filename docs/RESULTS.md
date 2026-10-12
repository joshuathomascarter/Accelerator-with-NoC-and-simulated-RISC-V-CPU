# Results: accelerator vs. software

Software baselines were timed on this PC (Intel64 Family 6 Model 58 Stepping 9, GenuineIntel, Python 3.12.10, best of several repeats). Every row runs the same INT8 network and predicts the same classes. MMAC/s counts the network's dense multiply-accumulates per second. **Speedup is relative to pure Python on the PC** (higher is faster).

## Iris (4 -> 3)

| Implementation | Runs on | Time / inference | MMAC/s | Speedup vs. pure Python | Notes |
|---|---|---:|---:|---:|---|
| Pure Python loops | PC CPU | 4.4 µs | 2.74 | 1× |  |
| NumPy, one input at a time | PC CPU | 14.4 µs | 0.833 | 0.304× |  |
| NumPy, whole test set batched | PC CPU | 0.4 µs | 28.1 | 10.3× |  |
| FPGA, PC drives every run: compute only | 45 MHz, cycle-accurate sim | 1.8 µs | 6.49 | 2.37× | 109 cycles per run, 38 samples |
| FPGA, PC drives every run: compute + bus traffic | 45 MHz, cycle-accurate sim | 2.9 µs | 4.16 | 1.52× | 170 cycles per run |
| Board, PC drives every run over USB-JTAG | PYNQ-Z2 (measured) | 378,684.2 µs | 3.17e-05 | 1.16e-05× | 38 samples, 38/38 bit-exact |

## Digits 8x8 (64 -> 10)

| Implementation | Runs on | Time / inference | MMAC/s | Speedup vs. pure Python | Notes |
|---|---|---:|---:|---:|---|
| Pure Python loops | PC CPU | 104.2 µs | 6.14 | 1× |  |
| NumPy, one input at a time | PC CPU | 17.4 µs | 36.8 | 5.99× |  |
| NumPy, whole test set batched | PC CPU | 0.5 µs | 1.16e+03 | 190× |  |
| FPGA, PC drives every run: compute only | 45 MHz, cycle-accurate sim | 93.3 µs | 6.86 | 1.12× | 111 cycles per run, 450 samples |
| FPGA, PC drives every run: compute + bus traffic | 45 MHz, cycle-accurate sim | 145.4 µs | 4.4 | 0.717× | 173 cycles per run |
| Board, PC drives every run over USB-JTAG | PYNQ-Z2 (measured) | 1,191,888.9 µs | 0.000537 | 8.74e-05× | 450 samples, 450/450 bit-exact |

## MNIST at 8x8 (64 -> 32 -> 10)

| Implementation | Runs on | Time / inference | MMAC/s | Speedup vs. pure Python | Notes |
|---|---|---:|---:|---:|---|
| Pure Python loops | PC CPU | 399.4 µs | 5.93 | 1× |  |
| NumPy, one input at a time | PC CPU | 51.1 µs | 46.3 | 7.81× |  |
| NumPy, whole test set batched | PC CPU | 2.4 µs | 1.01e+03 | 170× |  |
| FPGA, PC drives every run: compute only | 45 MHz, cycle-accurate sim | 301.4 µs | 7.86 | 1.32× | 111 cycles per run, 50 samples |
| FPGA, PC drives every run: compute + bus traffic | 45 MHz, cycle-accurate sim | 469.8 µs | 5.04 | 0.85× | 173 cycles per run |
| FPGA, project CPU drives every run | 45 MHz, cycle-accurate sim | 503.3 µs | 4.7 | 0.793× | 22,649 cycles per inference, 50/50 bit-exact |
| Board, PC drives every run over USB-JTAG | PYNQ-Z2 (measured) | 4,419,500.0 µs | 0.000536 | 9.04e-05× | 20 samples, 20/20 bit-exact |
| Board, project CPU drives every run; PC sends images over USB-JTAG | PYNQ-Z2 (measured) | 23,140.4 µs | 0.102 | 0.0173× | 10000 samples, 10000/10000 bit-exact, 96.0% accuracy |

## Reading these numbers

- **Correct, but not faster than a desktop PC.** Every board and simulation result matches the 8-bit software model exactly. The accelerator's compute time is close to pure-Python loops: 2.5x faster on Iris, about equal on the larger networks. NumPy on a desktop CPU is 8-160x faster than either.
- **Why:** each run does 16 multiply-accumulates (4 tiles x 4 lanes) in about 111 cycles, 0.14 per cycle. The tiles run one after another, every run resends its weights over the network-on-chip, and the clock is 45 MHz. The 16 multiply-accumulate units could do 16 per cycle.
- **Who drives the accelerator matters most on the board.** Over the USB debug cable, each register access is a round trip of about 1 ms. When the PC drives every run, one MNIST image takes 4.4 s. When the project CPU on the FPGA drives the runs, the PC only sends the image and reads the answer: 23 ms per image, about 190x faster, and most of that 23 ms is still USB. The CPU's own work is 0.50 ms per image (cycle-accurate simulation).
- **Next steps, if speed is the goal:** run the four tiles in parallel (up to 4x), keep weights inside the tiles instead of resending them (about 2x), pipeline the CPU and the multiply-accumulate path to reach 100 MHz (about 2x), and move data with DMA instead of one register write per word.
