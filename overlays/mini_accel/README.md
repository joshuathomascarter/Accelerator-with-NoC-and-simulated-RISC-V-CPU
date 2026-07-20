# Mini Accelerator PYNQ-Z2 Overlay

`Vivado/build_pynq_z2.tcl` generates `mini_accel.bit`, `mini_accel.hwh`,
`utilization.rpt`, and `timing_summary.rpt` in this directory.

Copy this directory and `accelerator/Software/mnist/pynq_driver.py` plus
`pynq_smoke_test.py` to the PYNQ board. From a board terminal run:

```bash
python3 pynq_smoke_test.py --bitstream mini_accel.bit --tiles 4
```

The overlay uses the Zynq PS GP0 AXI master and assigns the accelerator base
address `0x43C00000`. The `.hwh` file lets PYNQ discover that address, so the
Python driver does not hard-code it.
