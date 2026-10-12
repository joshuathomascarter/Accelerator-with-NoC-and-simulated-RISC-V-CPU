"""CPU firmware that runs a whole quantized network on the accelerator.

The host loads the program into instruction memory and the weights, biases and
one input image into data memory, then releases the CPU from reset. The CPU
runs every layer through the accelerator's MMIO registers, applies ReLU and
the right shift between layers, finds the largest logit, shows it on the LEDs,
and sets DONE. The host then reads PRED and LOGITS.

Data memory layout (32-bit words; CPU byte address = 4 * word index):
    0       DONE    host writes 0, CPU writes 1 when finished
    1       PRED    predicted class
    2..     LOGITS  one int32 per class
    then    X0      input image, packed INT8x4
    then    per layer: weights (row-major, packed), biases (int32), outputs
"""

from __future__ import annotations

from dataclasses import dataclass, field

import numpy as np

from .model import QuantizedModel
from .packing import pack_int8x4
from .rv32 import assemble

DMEM_WORDS = 1024
IMEM_WORDS = 256
DONE, PRED, LOGITS = 0, 1, 2


@dataclass
class Firmware:
    program: list[int]
    dmem: dict[int, int]            # word index -> value, loaded once
    image_word: int                 # first word of the input image
    image_words: int
    classes: int
    layout: dict[str, int] = field(default_factory=dict)

    def image(self, x_q: np.ndarray) -> list[int]:
        return [int(w) for w in pack_int8x4(np.asarray(x_q, dtype=np.int8).reshape(-1))]


LAYER_ROUTINE = """
# layer: x10 = weights, x11 = input words, x12 = biases, x13 = outputs (byte addresses)
#        x14 = number of outputs, x15 = groups of 4 input words per output
layer:
layer_out:
    lw   x16, 0(x12)        # acc = bias
    mv   x17, x11
    mv   x18, x15
layer_group:
    sw   x3, 0(x2)          # CTRL = clear
    sw   x4, 8(x2)          # TILE_COUNT = 4
    lw   x19, 0(x10)
    sw   x19, 12(x2)        # WEIGHT_DATA x4
    lw   x19, 4(x10)
    sw   x19, 12(x2)
    lw   x19, 8(x10)
    sw   x19, 12(x2)
    lw   x19, 12(x10)
    sw   x19, 12(x2)
    lw   x19, 0(x17)
    sw   x19, 16(x2)        # ACT_DATA x4
    lw   x19, 4(x17)
    sw   x19, 16(x2)
    lw   x19, 8(x17)
    sw   x19, 16(x2)
    lw   x19, 12(x17)
    sw   x19, 16(x2)
    sw   x5, 0(x2)          # CTRL = start | final_layer
layer_poll:
    lw   x19, 4(x2)         # STATUS
    and  x19, x19, x3       # done bit
    beq  x19, x0, layer_poll
    lw   x19, 20(x2)        # RESULT x4, summed into acc
    add  x16, x16, x19
    lw   x19, 20(x2)
    add  x16, x16, x19
    lw   x19, 20(x2)
    add  x16, x16, x19
    lw   x19, 20(x2)
    add  x16, x16, x19
    addi x10, x10, 16
    addi x17, x17, 16
    addi x18, x18, -1
    bne  x18, x0, layer_group
    sw   x16, 0(x13)
    addi x12, x12, 4
    addi x13, x13, 4
    addi x14, x14, -1
    bne  x14, x0, layer_out
    ret
"""

REQUANT_ROUTINE = """
# requant: x10 = int32 accumulators, x11 = packed output words, x12 = output words,
#          x13 = shift. Each value becomes clip(max(v, 0) >> shift, 0, 127).
requant:
    lui  x20, 0x80000       # sign-bit mask
    addi x21, x0, 7
    addi x22, x0, 127
requant_word:
    addi x16, x0, 0
""" + "".join(f"""
    lw   x19, {4 * b}(x10)
    and  x23, x19, x20
    bne  x23, x0, requant_skip{b}     # negative -> 0
    srl  x19, x19, x13
    srl  x23, x19, x21
    beq  x23, x0, requant_fit{b}
    mv   x19, x22                    # >= 128 -> 127
requant_fit{b}:
    addi x23, x0, {8 * b}
    sll  x19, x19, x23
    or   x16, x16, x19
requant_skip{b}:
""" for b in range(4)) + """
    sw   x16, 0(x11)
    addi x10, x10, 16
    addi x11, x11, 4
    addi x12, x12, -1
    bne  x12, x0, requant_word
    ret
"""

ARGMAX_ROUTINE = """
# argmax: x10 = int32 logits, x11 = count. Result index in x17 (first maximum wins).
argmax:
    lw   x16, 0(x10)
    addi x17, x0, 0
    addi x18, x0, 1
    addi x19, x10, 4
    lui  x24, 0x80000
argmax_loop:
    beq  x18, x11, argmax_done
    lw   x20, 0(x19)
    sub  x21, x16, x20      # negative when this logit is larger
    and  x21, x21, x24
    beq  x21, x0, argmax_next
    mv   x16, x20
    mv   x17, x18
argmax_next:
    addi x18, x18, 1
    addi x19, x19, 4
    j    argmax_loop
argmax_done:
    ret
"""


def build(model: QuantizedModel) -> Firmware:
    """Lay out the model in data memory and generate the matching program."""

    dmem: dict[int, int] = {}
    classes = model.classes
    image_word = LOGITS + classes
    image_word += (-image_word) % 4
    in_words = (model.features + 3) // 4
    cursor = image_word + in_words
    layout = {"image": image_word}
    main = ["    li   x2, 0x80000000", "    addi x3, x0, 2", "    addi x4, x0, 4", "    addi x5, x0, 5"]

    x_word = image_word
    for i, layer in enumerate(model.layers):
        outputs, inputs = layer.w_q.shape
        words = pack_int8x4(layer.w_q)                # (outputs, inputs / 4)
        k = words.shape[1]
        if k % 4:
            raise ValueError(f"layer {i}: {inputs} inputs is not a multiple of 16")
        w_word, cursor = cursor, cursor + words.size
        b_word, cursor = cursor, cursor + outputs
        last = i == len(model.layers) - 1
        if last:
            out_word = LOGITS
        else:
            out_word, cursor = cursor, cursor + outputs
            if outputs % 16:
                raise ValueError(f"layer {i}: {outputs} hidden outputs is not a multiple of 16")
        for j, w in enumerate(words.reshape(-1)):
            dmem[w_word + j] = int(w)
        for j, b in enumerate(layer.b_q):
            dmem[b_word + j] = int(b) & 0xFFFF_FFFF
        layout |= {f"w{i}": w_word, f"b{i}": b_word, f"out{i}": out_word}
        main += [f"    li   x10, {4 * w_word}", f"    li   x11, {4 * x_word}", f"    li   x12, {4 * b_word}",
                 f"    li   x13, {4 * out_word}", f"    addi x14, x0, {outputs}", f"    addi x15, x0, {k // 4}",
                 "    call layer"]
        if not last:
            x_word, cursor = cursor, cursor + outputs // 4
            layout[f"x{i + 1}"] = x_word
            main += [f"    li   x10, {4 * out_word}", f"    li   x11, {4 * x_word}",
                     f"    addi x12, x0, {outputs // 4}", f"    addi x13, x0, {layer.shift}", "    call requant"]
    if cursor > DMEM_WORDS:
        raise ValueError(f"model needs {cursor} data words; the CPU has {DMEM_WORDS}")

    main += [f"    addi x10, x0, {4 * LOGITS}", f"    addi x11, x0, {classes}", "    call argmax",
             f"    sw   x17, {4 * PRED}(x0)", "    sw   x17, 28(x2)        # LEDs show the class",
             "    addi x19, x0, 1", f"    sw   x19, {4 * DONE}(x0)",
             "halt:", "    j    halt"]
    source = "main:\n" + "\n".join(main) + "\n" + LAYER_ROUTINE + REQUANT_ROUTINE + ARGMAX_ROUTINE
    program = assemble(source)
    if len(program) > IMEM_WORDS:
        raise ValueError(f"program is {len(program)} words; the CPU has {IMEM_WORDS}")
    layout["data_words"] = cursor
    layout["program_words"] = len(program)
    return Firmware(program, dmem, image_word, in_words, classes, layout)

