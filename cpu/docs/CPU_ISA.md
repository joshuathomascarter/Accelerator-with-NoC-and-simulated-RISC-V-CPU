# CPU ISA

## Goal
Tiny RV32I-inspired control CPU for driving the accelerator.

## Scope
This CPU is not a full Linux/programming CPU. It only needs enough instructions to:
- configure accelerator registers
- load/store MMIO values
- poll status
- branch in simple loops
- read results

## Architectural State
- 32-bit instructions
- 32-bit registers
- 32 general-purpose registers: x0-x31
- x0 is hardwired to zero
- 32-bit program counter
- little-endian word accesses

## Instruction Formats
Show R/I/S/B/U/J formats.

## Supported Instructions
Table:

| Instruction | Format | Meaning |
|---|---|---|
| ADD | R | rd = rs1 + rs2 |
| SUB | R | rd = rs1 - rs2 |
| ADDI | I | rd = rs1 + imm |
| LW | I | rd = mem[rs1 + imm] |
| SW | S | mem[rs1 + imm] = rs2 |
| BEQ | B | if rs1 == rs2, pc += imm |
| BNE | B | if rs1 != rs2, pc += imm |
| JAL | J | rd = pc+4; pc += imm |
| JALR | I | rd = pc+4; pc = rs1 + imm |
| LUI | U | rd = imm << 12 |

## Unsupported Instructions
No multiply/divide.
No atomics.
No floating point.
No compressed instructions.
No interrupts/exceptions.
No privilege modes.
No caches.

## Decode Rules
The decoder reads the 32-bit instruction and first checks the 7-bit `opcode`.

The `opcode` selects the broad instruction family:
- `OPCODE_OP`: register-register arithmetic/logical instructions
- `OPCODE_OP_IMM`: register-immediate arithmetic/logical instructions
- `OPCODE_LOAD`: load instructions
- `OPCODE_STORE`: store instructions
- `OPCODE_BRANCH`: conditional branches
- `OPCODE_JAL`: jump and link
- `OPCODE_JALR`: jump and link register
- `OPCODE_LUI`: load upper immediate
- `OPCODE_AUIPC`: add upper immediate to PC

For arithmetic/logical instructions, `funct3` selects the operation group and `funct7` disambiguates operations that share the same `funct3`.

Example:
- `opcode = OPCODE_OP`, `funct3 = FUNCT3_ADD_SUB`, `funct7 = FUNCT7_BASE` decodes as `ADD`
- `opcode = OPCODE_OP`, `funct3 = FUNCT3_ADD_SUB`, `funct7 = FUNCT7_SUB_SRA` decodes as `SUB`
- `opcode = OPCODE_OP_IMM`, `funct3 = FUNCT3_ADD_SUB` decodes as `ADDI`

The decoder should convert raw instruction fields into the internal `cpu_inst_t` enum from `cpu_pkg.sv`.

If an opcode/funct combination is not supported by this CPU, the decoder should output `CPU_INST_ILLEGAL`.

## Immediate Generation
Immediate fields are not always stored contiguously in the instruction. The immediate generator reconstructs the full immediate value based on instruction format, then sign-extends it to 32 bits unless stated otherwise.

I-type immediate:
- Used by `ADDI`, `ANDI`, `ORI`, `XORI`, `LW`, and `JALR`
- Raw immediate: `instr[31:20]`
- Sign-extend bit `instr[31]` to 32 bits

S-type immediate:
- Used by `SW`
- Raw immediate: `{instr[31:25], instr[11:7]}`
- Sign-extend bit `instr[31]` to 32 bits

B-type immediate:
- Used by `BEQ` and `BNE`
- Raw branch offset: `{instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}`
- Sign-extend bit `instr[31]` to 32 bits
- The low bit is always zero because branch targets are 2-byte aligned in the base encoding

U-type immediate:
- Used by `LUI`
- Raw immediate: `{instr[31:12], 12'b0}`
- No extra sign-extension step is needed after placing the upper 20 bits into `[31:12]`

J-type immediate:
- Used by `JAL`
- Raw jump offset: `{instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}`
- Sign-extend bit `instr[31]` to 32 bits
- The low bit is always zero because jump targets are 2-byte aligned in the base encoding

## Memory Model
- The CPU uses a 32-bit byte-addressed address space.
- Instruction memory is addressed by byte address through the program counter.
- Data memory and MMIO are also byte-addressed.
- This first CPU only supports aligned 32-bit word loads and stores.
- `LW` and `SW` require `addr[1:0] == 2'b00`.
- Byte and halfword loads/stores are not supported in the first version.
- Misaligned `LW` or `SW` should set the CPU error flag and halt execution.
- Normal RAM and MMIO must occupy non-overlapping address ranges.

The accelerator is controlled through MMIO. A store to an accelerator MMIO address updates an accelerator register instead of normal RAM.

## Reset Behavior
- On reset, the program counter starts at `32'h0000_0000`.
- General-purpose registers are cleared to zero.
- Register `x0` must always read as zero, even if software attempts to write it.
- CPU control state returns to the fetch state.
- CPU error/halt state is cleared.
- The CPU does not directly reset the accelerator unless software writes the accelerator clear bit after reset.
- System-level reset may still reset both CPU and accelerator together if the top-level SoC connects reset that way.

## Illegal Instruction Behavior
For our first CPU:
- Unsupported opcode/funct combinations decode as `CPU_INST_ILLEGAL`.
- Executing an illegal instruction sets an illegal-instruction error flag.
- The CPU enters a halted state after an illegal instruction.
- While halted, the CPU stops fetching new instructions.
- The CPU leaves the halted state only through reset.
- Future versions may replace halt behavior with a trap/exception path, but traps are out of scope for this CPU.
