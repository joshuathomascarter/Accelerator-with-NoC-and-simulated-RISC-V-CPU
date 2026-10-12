# PYNQ-Z2 build

`build_pynq_z2.tcl` creates a Zynq block design: the PS7, plus `pynq_soc_top`
(the accelerator and the project CPU) on GP0 AXI-Lite at `0x43C00000`, 8 KB.
It runs synthesis, implementation and bitstream generation, then writes the
following to `overlays/mini_accel/`:

- `mini_accel.bit`, `mini_accel.hwh`
- `utilization.rpt`, `utilization_hier.rpt`, `timing_summary.rpt`, `power.rpt`

```text
set MINI_ACCEL_VIVADO_DIR=C:\mini_accel_vivado
vivado -mode batch -source Vivado/build_pynq_z2.tcl
```

`MINI_ACCEL_VIVADO_DIR` is optional. Set it when the repo lives in a synced
folder such as OneDrive, which locks Vivado's cache files mid-build.

The fabric clock (FCLK0) is 45 MHz, set by the single-cycle CPU path. The script
stops without copying the bitstream if timing is not met. If the PYNQ-Z2 board files are installed,
the PS7 board preset is applied. Without them the default PS7 configuration is
used, which is fine for an overlay: PYNQ's Linux image has already configured
the PS.

Simulate the RTL before building with `python scripts/run_regression.py`.
