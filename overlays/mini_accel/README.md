# Mini accelerator PYNQ-Z2 overlay

`Vivado/build_pynq_z2.tcl` writes `mini_accel.bit`, `mini_accel.hwh` and the
implementation reports here. They are generated files and are not committed.

To run on the board, either:

- **From the PC over the USB cable (JTAG):**
  `python software/run_dataset.py --dataset digits --backend jtag`
- **On the board (network):** `python scripts/make_board_bundle.py`, copy
  `build/pynq_bundle/` to the board, then run `sudo python3 smoke_test.py` and
  `sudo python3 run_dataset.py --model models/digits.npz --backend pynq`.

The accelerator is at `0x43C00000`. PYNQ reads the address from the `.hwh`
file, so the driver does not hard-code it.
