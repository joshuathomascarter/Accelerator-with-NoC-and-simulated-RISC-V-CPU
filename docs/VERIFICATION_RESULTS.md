# Verification results

Vivado 2026.1 · TUL PYNQ-Z2 (xc7z020clg400-1) · fabric clock 45 MHz

## Bugs found and fixed

Before these fixes, every accelerator run returned zero. The earlier tests only
checked that results were not X, so this went unnoticed.

1. **The scheduler dropped the WEIGHT packet.** Its send states checked
   `cmd_ready` against the previously registered packet, so CLEAR was sent twice
   and WEIGHT never reached the tile. Fix: hold `cmd_valid`/`cmd_packet` until
   the handshake completes (`schedular.sv`).
2. **REDUCE overtook COMPUTE.** It arrived after two of the four activation lanes
   had been replayed. Fix: the tile holds REDUCE until the replay finishes
   (`tile.sv`).
3. **Tiles did not compute a dot product.** Every PE accumulated the same
   activation stream (`w_i * sum(a)`), and the result was clipped to 8 bits.
   Fix: activation lane *i* is enabled into PE *i* only, and REDUCE sums the four
   accumulators into a signed 32-bit result (`systolic_array.sv`, `pe.sv`,
   `tile.sv`).
4. **The Vivado block-design flow had never run.** Package-qualified parameter
   defaults broke the module reference, paths with spaces were not quoted, and
   the LED port helper failed in batch mode (`build_pynq_z2.tcl`).
5. **The CPU core test failed under XSIM.** A second `cpu_regfile` instance in
   the same testbench made the simulator mis-wire the core's ALU inputs. The
   register-file checks now have their own testbench (`tb_cpu_regfile`).

## RTL regression

`python scripts/run_regression.py`, all in XSIM. 16 of 16 pass:

| Test | What it checks |
|---|---|
| tb_systolic_array | each PE multiplies its own activation lane |
| tb_tile | a tile returns the exact signed dot product |
| tb_noc | packets route across the 2x2 mesh |
| tb_chip_end_to_end | scheduler, NoC and four tiles together |
| tb_pynq_accel_axi_lite | AXI-Lite register shell |
| tb_pynq_axi_single_tile, tb_pynq_axi_four_tiles | full AXI path with exact expected results |
| tb_cpu_regfile, tb_cpu_core, tb_cpu_branch_jump | CPU register file, datapath, branches and jumps |
| tb_cpu_mmio, tb_cpu_mmio_bridge, tb_cpu_end_to_end, tb_cpu_real_chip_end_to_end | CPU MMIO bridge and CPU-to-accelerator paths |
| random_vectors | 303 random and corner-case runs vs. the Python model, all bit-exact |
| cpu_firmware | CPU in `pynq_soc_top` runs the MNIST-8 network on 5 images, all bit-exact |

## FPGA implementation

| | |
|---|---|
| Top level | `pynq_soc_top`: accelerator + CPU + 1 KB instruction and 4 KB data memory |
| Clock | 45 MHz; worst setup slack +1.40 ns, 0 failing paths |
| Critical path | the single-cycle CPU: PC -> instruction memory -> decode -> register file -> ALU -> data memory -> register file |
| LUTs | 8,608 / 53,200 (16.2 %), of which 2,525 are used as memory |
| Flip-flops | 4,683 / 106,400 (4.4 %) |
| DSP / block RAM | 0 / 0 |
| Total on-chip power | 1.70 W (including the ARM processing system) |

## Results

Every result below was checked against the software reference: the board's
32-bit logits must match the INT8 model's logits exactly, not only the predicted
class.

See [RESULTS.md](RESULTS.md) for speed.
