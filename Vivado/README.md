# PYNQ-Z2 build and simulation

The custom simulation CPU is not part of the board design. The Zynq ARM
processing system controls `pynq_accel_top` through its GP0 AXI-Lite master.

Run the board-facing simulations first:

```text
vivado -mode batch -source Vivado/run_preflight_sim.tcl
```

Then create the Zynq block design, synthesize, implement, and export the PYNQ
overlay:

```text
vivado -mode batch -source Vivado/build_pynq_z2.tcl
```

Successful implementation writes these files to `overlays/mini_accel/`:

- `mini_accel.bit`
- `mini_accel.hwh`
- `utilization.rpt`
- `timing_summary.rpt`

The accelerator is mapped at `0x43C00000`. PYNQ normally obtains that address
from the HWH file, so Python software should not hard-code it.

The current hardware transaction processes one packed INT8x4 weight word and
one packed INT8x4 activation word per selected tile. It proves the complete ARM
AXI -> NoC -> systolic tile -> AXI result path. Processing a full 784-feature
MNIST image requires a later multi-word accumulation protocol or DMA design;
the existing MNIST exporter alone does not add that missing hardware behavior.
