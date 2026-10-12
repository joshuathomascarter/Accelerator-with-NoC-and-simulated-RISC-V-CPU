"""Assembler for the project CPU (an RV32I subset, see cpu/docs/CPU_ISA.md).

Instructions: add sub and or xor sll srl addi andi ori xori lw sw beq bne jal jalr lui
Pseudo-instructions: li rd, imm (always 2 words: lui + addi), mv, j, call, ret, nop
Syntax: one instruction per line, "label:" on its own line, "#" comments,
registers x0-x31, loads/stores as "lw x5, 8(x6)".
"""

from __future__ import annotations

import re

R_TYPE = {"add": (0, 0x00), "sub": (0, 0x20), "sll": (1, 0x00), "xor": (4, 0x00),
          "srl": (5, 0x00), "or": (6, 0x00), "and": (7, 0x00)}
I_ALU = {"addi": 0, "xori": 4, "ori": 6, "andi": 7}
BRANCH = {"beq": 0, "bne": 1}


def _reg(tok: str) -> int:
    m = re.fullmatch(r"x(\d+)", tok.strip())
    if not m or int(m.group(1)) > 31:
        raise ValueError(f"bad register {tok!r}")
    return int(m.group(1))


def _imm(tok: str, labels: dict[str, int] | None = None) -> int:
    tok = tok.strip()
    if labels is not None and tok in labels:
        return labels[tok]
    return int(tok, 0)


def _check(value: int, bits: int, what: str) -> int:
    lo, hi = -(1 << (bits - 1)), (1 << (bits - 1)) - 1
    if not lo <= value <= hi:
        raise ValueError(f"{what} {value} does not fit in {bits} signed bits")
    return value & ((1 << bits) - 1)


def _expand(lines: list[str]) -> list[tuple[str, list[str], int]]:
    """Strip comments, expand pseudo-instructions; returns (op, args, source line)."""

    out = []
    for n, raw in enumerate(lines, 1):
        line = raw.split("#")[0].strip()
        if not line:
            continue
        if line.endswith(":"):
            out.append((":", [line[:-1].strip()], n))
            continue
        op, _, rest = line.partition(" ")
        args = [a.strip() for a in rest.split(",")] if rest.strip() else []
        op = op.lower()
        if op == "li":
            value = int(args[1], 0)
            if value >= 1 << 31:
                value -= 1 << 32
            upper = ((value + 0x800) >> 12) & 0xFFFFF
            lower = ((value - (upper << 12)) + (1 << 31)) % (1 << 32) - (1 << 31)
            out += [("lui", [args[0], str(upper)], n), ("addi", [args[0], args[0], str(lower)], n)]
        elif op == "mv":
            out.append(("addi", [args[0], args[1], "0"], n))
        elif op == "j":
            out.append(("jal", ["x0", args[0]], n))
        elif op == "call":
            out.append(("jal", ["x1", args[0]], n))
        elif op == "ret":
            out.append(("jalr", ["x0", "0(x1)"], n))
        elif op == "nop":
            out.append(("addi", ["x0", "x0", "0"], n))
        else:
            out.append((op, args, n))
    return out


def assemble(source: str) -> list[int]:
    """Assemble source text into 32-bit instruction words (program starts at address 0)."""

    items = _expand(source.splitlines())
    labels: dict[str, int] = {}
    pc = 0
    for op, args, _ in items:
        if op == ":":
            if args[0] in labels:
                raise ValueError(f"duplicate label {args[0]}")
            labels[args[0]] = pc
        else:
            pc += 4

    words: list[int] = []
    pc = 0
    for op, args, n in items:
        if op == ":":
            continue
        try:
            words.append(_encode(op, args, pc, labels))
        except (ValueError, IndexError) as exc:
            raise ValueError(f"line {n}: {op} {', '.join(args)}: {exc}") from None
        pc += 4
    return words


def _mem_operand(tok: str) -> tuple[int, int]:
    m = re.fullmatch(r"\s*(-?\w+)\((x\d+)\)\s*", tok)
    if not m:
        raise ValueError(f"bad memory operand {tok!r}")
    return int(m.group(1), 0), _reg(m.group(2))


def _encode(op: str, a: list[str], pc: int, labels: dict[str, int]) -> int:
    if op in R_TYPE:
        f3, f7 = R_TYPE[op]
        return (f7 << 25) | (_reg(a[2]) << 20) | (_reg(a[1]) << 15) | (f3 << 12) | (_reg(a[0]) << 7) | 0x33
    if op in I_ALU:
        imm = _check(_imm(a[2]), 12, "immediate")
        return (imm << 20) | (_reg(a[1]) << 15) | (I_ALU[op] << 12) | (_reg(a[0]) << 7) | 0x13
    if op == "lw":
        off, base = _mem_operand(a[1])
        return (_check(off, 12, "offset") << 20) | (base << 15) | (2 << 12) | (_reg(a[0]) << 7) | 0x03
    if op == "sw":
        off, base = _mem_operand(a[1])
        imm = _check(off, 12, "offset")
        return ((imm >> 5) << 25) | (_reg(a[0]) << 20) | (base << 15) | (2 << 12) | ((imm & 0x1F) << 7) | 0x23
    if op in BRANCH:
        off = _imm(a[2], labels) - pc
        imm = _check(off, 13, "branch offset")
        return (((imm >> 12) & 1) << 31) | (((imm >> 5) & 0x3F) << 25) | (_reg(a[1]) << 20) | \
               (_reg(a[0]) << 15) | (BRANCH[op] << 12) | (((imm >> 1) & 0xF) << 8) | (((imm >> 11) & 1) << 7) | 0x63
    if op == "jal":
        off = _imm(a[1], labels) - pc
        imm = _check(off, 21, "jump offset")
        return (((imm >> 20) & 1) << 31) | (((imm >> 1) & 0x3FF) << 21) | (((imm >> 11) & 1) << 20) | \
               (((imm >> 12) & 0xFF) << 12) | (_reg(a[0]) << 7) | 0x6F
    if op == "jalr":
        off, base = _mem_operand(a[1])
        return (_check(off, 12, "offset") << 20) | (base << 15) | (_reg(a[0]) << 7) | 0x67
    if op == "lui":
        return ((_imm(a[1]) & 0xFFFFF) << 12) | (_reg(a[0]) << 7) | 0x37
    raise ValueError(f"unsupported instruction {op!r}")
