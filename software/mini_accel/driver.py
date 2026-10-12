"""AXI-Lite register driver for the mini accelerator PYNQ-Z2 overlay.

Runs on the board's ARM cores; needs the `pynq` package. Register offsets
match docs/PYNQ_REGISTER_MAP.md.
"""

from __future__ import annotations

import time
from pathlib import Path
from typing import Sequence

CTRL = 0x00
STATUS = 0x04
TILE_COUNT = 0x08
WEIGHT_DATA = 0x0C
ACT_DATA = 0x10
RESULT = 0x14
ERROR = 0x18
LED_MIRROR = 0x1C

CTRL_START = 1 << 0
CTRL_CLEAR = 1 << 1
CTRL_FINAL_LAYER = 1 << 2
STATUS_BUSY = 1 << 0
STATUS_DONE = 1 << 1
STATUS_RESULT_VALID = 1 << 2

MAX_TILES = 4


class AcceleratorError(RuntimeError):
    pass


class PynqAccelerator:
    """Blocking driver: one call to run() is one accelerator transaction."""

    def __init__(self, bitstream: str | Path, ip_name: str = "accel_0", download: bool = True):
        try:
            from pynq import MMIO, Overlay  # type: ignore
        except ImportError as exc:
            raise RuntimeError("The pynq package is required; run this on the PYNQ-Z2") from exc

        self.overlay = Overlay(str(bitstream), download=download)
        names = [n for n in self.overlay.ip_dict if n == ip_name or n.endswith("/" + ip_name)]
        names = names or [n for n in self.overlay.ip_dict if "accel" in n.lower()]
        if not names:
            raise AcceleratorError(f"Accelerator IP not found; overlay IPs are {list(self.overlay.ip_dict)}")
        desc = self.overlay.ip_dict[names[0]]
        self.mmio = MMIO(desc["phys_addr"], desc["addr_range"])

    def read(self, offset: int) -> int:
        return int(self.mmio.read(offset))

    def write(self, offset: int, value: int) -> None:
        self.mmio.write(offset, int(value) & 0xFFFF_FFFF)

    def set_leds(self, value: int) -> None:
        self.write(LED_MIRROR, value & 0xF)

    def run(self, weights: Sequence[int], activations: Sequence[int], timeout_s: float = 1.0) -> list[int]:
        """Send one weight and one activation word per tile; return one uint32 result per tile."""

        tiles = len(weights)
        if not 1 <= tiles <= MAX_TILES or len(activations) != tiles:
            raise ValueError("run() takes 1-4 tiles with one weight and one activation word each")

        self.write(CTRL, CTRL_CLEAR)
        self.write(TILE_COUNT, tiles)
        for word in weights:
            self.write(WEIGHT_DATA, word)
        for word in activations:
            self.write(ACT_DATA, word)
        self.write(CTRL, CTRL_START | CTRL_FINAL_LAYER)

        deadline = time.monotonic() + timeout_s
        while not (self.read(STATUS) & STATUS_DONE):
            if time.monotonic() > deadline:
                raise TimeoutError(f"Accelerator timed out; status=0x{self.read(STATUS):08x}")

        error = self.read(ERROR)
        if error:
            raise AcceleratorError(f"Accelerator error flags 0x{error:08x}")
        return [self.read(RESULT) for _ in range(tiles)]
