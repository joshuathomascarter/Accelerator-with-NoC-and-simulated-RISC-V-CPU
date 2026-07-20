## CPU MMIO Map

All addresses are byte addresses. The bridge accepts aligned 32-bit accesses only, so valid register addresses step by 4 bytes.

| Address | Name | Access | Bits | Description |
|---|---|---|---|---|
| 0x8000_0000 | ACCEL_CTRL | RW | bit0=start, bit1=clear, bit2=final_layer | Control accelerator |
| 0x8000_0004 | ACCEL_STATUS | RO | bit0=busy, bit1=done, bit2=result_valid, bit3=overflow | Accelerator status |
| 0x8000_0008 | ACCEL_TILE_COUNT | RW | [31:0] num_tiles | Number of tiles to run |
| 0x8000_000C | ACCEL_WEIGHT_DATA | WO | [31:0] packed weights | Write packed weight payload |
| 0x8000_0010 | ACCEL_ACT_DATA | WO | [31:0] packed activations | Write packed activation payload |
| 0x8000_0014 | ACCEL_RESULT | RO | [31:0] packed result | Read output result |
| 0x8000_0018 | ACCEL_ERROR | RO | [31:0] error flags | Debug/error state |

## Bridge Behavior

- `ACCEL_CTRL.start` and `ACCEL_CTRL.clear` are one-cycle pulses.
- `ACCEL_CTRL.final_layer` is stored until software writes it again or reset is asserted.
- `ACCEL_TILE_COUNT` is stored until software writes it again or reset is asserted.
- `ACCEL_WEIGHT_DATA` and `ACCEL_ACT_DATA` produce one-cycle write pulses with the CPU write payload.
- `ACCEL_RESULT` returns the accelerator result word and pulses `accel_result_rd_en`.
- Misaligned accesses inside the MMIO region assert `cpu_error`.
- Unknown aligned addresses inside the MMIO region assert `cpu_error`.
