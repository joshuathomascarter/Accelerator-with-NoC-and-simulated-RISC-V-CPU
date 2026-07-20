"""Register-level driver for the mini accelerator PYNQ-Z2 overlay."""

from __future__ import annotations

import time
from pathlib import Path
from typing import Iterable


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


class AcceleratorError(RuntimeError):
    pass


class PynqAccelerator:
    """Blocking AXI-Lite driver for the four-tile bring-up accelerator."""

    def __init__(self, bitstream: str | Path, ip_name: str = "accel_0", download: bool = True):
        try:
            from pynq import Overlay, MMIO  # type: ignore
        except ImportError as exc:
            raise RuntimeError("The pynq package is required; run this driver on the PYNQ-Z2") from exc

        self.overlay = Overlay(str(bitstream), download=download)
        matches = [name for name in self.overlay.ip_dict if name == ip_name or name.endswith("/" + ip_name)]
        if not matches:
            matches = [name for name in self.overlay.ip_dict if "accel" in name.lower()]
        if not matches:
            raise AcceleratorError(f"Accelerator IP not found in overlay; IPs are {list(self.overlay.ip_dict)}")
        description = self.overlay.ip_dict[matches[0]]
        self.mmio = MMIO(description["phys_addr"], description["addr_range"])

    def read(self, offset: int) -> int:
        return int(self.mmio.read(offset))

    def write(self, offset: int, value: int) -> None:
        self.mmio.write(offset, int(value) & 0xFFFF_FFFF)

    def clear(self) -> None:
        self.write(CTRL, CTRL_CLEAR)

    def set_leds(self, value: int) -> None:
        self.write(LED_MIRROR, value & 0xF)

    def load(self, weights: Iterable[int], activations: Iterable[int], tile_count: int) -> None:
        if not 1 <= tile_count <= 4:
            raise ValueError("tile_count must be from 1 to 4")
        weight_words = list(weights)
        activation_words = list(activations)
        if len(weight_words) != tile_count or len(activation_words) != tile_count:
            raise ValueError("The current 2x2 tile engine requires exactly one packed weight and activation word per tile")
        self.clear()
        self.write(TILE_COUNT, tile_count)
        for word in weight_words:
            self.write(WEIGHT_DATA, word)
        for word in activation_words:
            self.write(ACT_DATA, word)

    def start(self) -> None:
        self.write(CTRL, CTRL_START | CTRL_FINAL_LAYER)

    def wait(self, timeout_s: float = 1.0, poll_s: float = 0.0001) -> int:
        deadline = time.monotonic() + timeout_s
        while time.monotonic() < deadline:
            status = self.read(STATUS)
            if status & STATUS_DONE:
                error = self.read(ERROR)
                if error:
                    raise AcceleratorError(f"Accelerator error flags 0x{error:08x}")
                return status
            time.sleep(poll_s)
        raise TimeoutError(f"Accelerator timed out; status=0x{self.read(STATUS):08x}")

    def read_results(self, tile_count: int) -> list[int]:
        results: list[int] = []
        for index in range(tile_count):
            if not (self.read(STATUS) & STATUS_RESULT_VALID):
                raise AcceleratorError(f"Result {index} is not valid")
            results.append(self.read(RESULT))
        return results

    def run(self, weights: Iterable[int], activations: Iterable[int], tile_count: int, timeout_s: float = 1.0) -> list[int]:
        self.load(weights, activations, tile_count)
        self.start()
        self.wait(timeout_s)
        return self.read_results(tile_count)
