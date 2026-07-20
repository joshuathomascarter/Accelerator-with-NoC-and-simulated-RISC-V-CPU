# PYNQ Accelerator Register Map

All addresses are byte offsets from the AXI-Lite base address assigned by Vivado.
All registers are 32 bits wide and require aligned word accesses.

| Offset | Name | Access | Bits | Description |
|---|---|---|---|---|
| `0x00` | `CTRL` | RW | bit0=start, bit1=clear, bit2=final_layer | Host control register. `start` and `clear` are pulse-style commands. |
| `0x04` | `STATUS` | RO | bit0=busy, bit1=done, bit2=result_valid, bit3=overflow | Accelerator status packed into one word. |
| `0x08` | `TILE_COUNT` | RW | `[31:0]` | Number of tiles/work items for the scheduler. |
| `0x0C` | `WEIGHT_DATA` | WO | `[31:0]` | Packed weight payload. |
| `0x10` | `ACT_DATA` | WO | `[31:0]` | Packed activation payload. |
| `0x14` | `RESULT` | RO | `[31:0]` | Packed result payload. Reading may consume/acknowledge the current result. |
| `0x18` | `ERROR` | RO | `[31:0]` | Sticky/debug error flags. |
| `0x1C` | `LED_MIRROR` | RW | `[3:0]` | Optional direct LED/debug mirror for PYNQ bring-up. |
| `0x20` | `TILE_SELECT` | RW | `[7:0]` | Optional tile select/debug register. |
| `0x24` | `PACKET_TYPE` | RW | `[7:0]` | Optional direct NoC packet type/debug injection field. |
| `0x28` | `PACKET_PAYLOAD` | RW | `[31:0]` | Optional direct NoC packet payload/debug injection field. |
| `0x2C` | `PACKET_VALID` | RW | bit0=valid | Optional direct packet valid/debug trigger. |
| `0x30` | `PACKET_READY` | RO | bit0=ready | Optional direct packet ready/debug status. |
| `0x34` | `DMA_SRC_ADDR` | RW | `[31:0]` | Future DMA source descriptor address. |
| `0x38` | `DMA_DST_ADDR` | RW | `[31:0]` | Future DMA destination descriptor address. |
| `0x3C` | `DMA_LENGTH` | RW | `[31:0]` | Future DMA transfer length in bytes or words, depending on wrapper mode. |

## Software Flow

1. Write `TILE_COUNT`.
2. Stream packed weights through `WEIGHT_DATA`.
3. Stream packed activations through `ACT_DATA`.
4. Write `CTRL.start=1` with `CTRL.final_layer` set as needed.
5. Poll `STATUS.done` or `STATUS.result_valid`.
6. Read `RESULT`.
7. Check `ERROR` if unexpected status appears.

## Notes

- This register map intentionally mirrors the CPU MMIO map where possible so the same software mental model works in simulation and on PYNQ.
- AXI-Lite will expose these offsets from whatever base address Vivado assigns.
- DMA registers are reserved for the later higher-throughput path and do not need to be implemented for the first AXI-Lite bring-up.
