# Verification results

Pre-board verification completed on July 20, 2026.

| Check | Result |
|---|---|
| Standalone AXI-Lite register test | PASS |
| Complete PYNQ top Verilator elaboration/lint | PASS, no design warnings |
| Complete PYNQ top Yosys/Slang synthesis check | PASS, zero structural problems |
| One-tile AXI-to-NoC-to-result synthesized-netlist simulation | PASS |
| Four-tile AXI-to-NoC-to-result synthesized-netlist simulation | PASS |
| PYNQ driver and smoke-test Python syntax | PASS |

The behavioral full-chip model is not run with Icarus because Icarus stalls on
the existing NoC hierarchy. The successful synthesized-netlist simulations
exercise the same AXI transactions through the flattened hardware logic.
`Vivado/run_preflight_sim.tcl` is included to repeat both tests with XSIM before
generating a bitstream.

Vivado implementation, timing closure, bitstream generation, and physical-board
testing require a local Vivado installation and the PYNQ-Z2 board.

## Functional scope

The verified transaction supplies one packed INT8x4 weight word and one packed
INT8x4 activation word to each selected tile. Full 28x28 MNIST inference is not
implemented by this transaction: it requires multi-word accumulation across
image chunks and storage/scheduling for all classifier weights. The Python
MNIST exporter is preparation software, not evidence that the current hardware
can consume the complete model.
