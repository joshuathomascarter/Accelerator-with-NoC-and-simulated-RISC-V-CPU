package cpu_pkg;

localparam int CPU_XLEN      = 32;
localparam int CPU_REG_COUNT = 32;
localparam int CPU_REG_W     = 5;
localparam int CPU_INSTR_W   = 32;

localparam logic [31:0] CPU_MMIO_ACCEL_BASE       = 32'h8000_0000;
localparam logic [31:0] CPU_MMIO_ACCEL_CTRL       = 32'h8000_0000;
localparam logic [31:0] CPU_MMIO_ACCEL_STATUS     = 32'h8000_0004;
localparam logic [31:0] CPU_MMIO_ACCEL_TILE_COUNT = 32'h8000_0008;
localparam logic [31:0] CPU_MMIO_ACCEL_WEIGHT     = 32'h8000_000C;
localparam logic [31:0] CPU_MMIO_ACCEL_ACT        = 32'h8000_0010;
localparam logic [31:0] CPU_MMIO_ACCEL_RESULT     = 32'h8000_0014;
localparam logic [31:0] CPU_MMIO_ACCEL_ERROR      = 32'h8000_0018;
localparam logic [31:0] CPU_MMIO_LED              = 32'h8000_001C;  // handled by pynq_soc_top
localparam logic [31:0] CPU_MMIO_ACCEL_MASK       = 32'hFFFF_FFE0;

localparam int CPU_MMIO_CTRL_START_BIT       = 0;
localparam int CPU_MMIO_CTRL_CLEAR_BIT       = 1;
localparam int CPU_MMIO_CTRL_FINAL_LAYER_BIT = 2;

localparam int CPU_MMIO_STATUS_BUSY_BIT         = 0;
localparam int CPU_MMIO_STATUS_DONE_BIT         = 1;
localparam int CPU_MMIO_STATUS_RESULT_VALID_BIT = 2;
localparam int CPU_MMIO_STATUS_OVERFLOW_BIT     = 3;

typedef struct packed {
    logic [6:0] funct7;
    logic [4:0] rs2;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] rd;
    logic [6:0] opcode;
} r_instruction_t;

typedef struct packed {
    logic [11:0] imm;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] rd;
    logic [6:0] opcode;
} i_instruction_t;

typedef struct packed {
    logic [6:0] imm1; //imm[11:5]
    logic [4:0] rs2;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] imm2; //imm[4:0]
    logic [6:0] opcode;
} s_instruction_t;

typedef struct packed {
    logic [6:0] imm1; // imm[12|10:5]
    logic [4:0] rs2;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] imm2; // imm[4:1|11]
    logic [6:0] opcode;
} b_instruction_t;

typedef struct packed {
    logic [19:0] imm; // imm[31:12]
    logic [4:0] rd;
    logic [6:0] opcode;
} u_instruction_t;

typedef struct packed {
    logic [19:0] imm; // imm [20 | 10:1 | 11 | 19:12]
    logic [4:0] rd;
    logic [6:0] opcode;
} j_instruction_t;

localparam logic [6:0] OPCODE_OP      = 7'b0110011;
localparam logic [6:0] OPCODE_OP_IMM  = 7'b0010011;
localparam logic [6:0] OPCODE_LOAD    = 7'b0000011;
localparam logic [6:0] OPCODE_STORE   = 7'b0100011;
localparam logic [6:0] OPCODE_BRANCH  = 7'b1100011;
localparam logic [6:0] OPCODE_JAL     = 7'b1101111;
localparam logic [6:0] OPCODE_JALR    = 7'b1100111;
localparam logic [6:0] OPCODE_LUI     = 7'b0110111;
localparam logic [6:0] OPCODE_AUIPC   = 7'b0010111;

localparam logic [2:0] FUNCT3_ADD_SUB = 3'b000;
localparam logic [2:0] FUNCT3_SLL     = 3'b001;
localparam logic [2:0] FUNCT3_SLT     = 3'b010;
localparam logic [2:0] FUNCT3_SLTU    = 3'b011;
localparam logic [2:0] FUNCT3_XOR     = 3'b100;
localparam logic [2:0] FUNCT3_SR      = 3'b101;
localparam logic [2:0] FUNCT3_OR      = 3'b110;
localparam logic [2:0] FUNCT3_AND     = 3'b111;

localparam logic [2:0] FUNCT3_BYTE    = 3'b000;
localparam logic [2:0] FUNCT3_HALF    = 3'b001;
localparam logic [2:0] FUNCT3_WORD    = 3'b010;

localparam logic [2:0] FUNCT3_BEQ     = 3'b000;
localparam logic [2:0] FUNCT3_BNE     = 3'b001;
localparam logic [2:0] FUNCT3_BLT     = 3'b100;
localparam logic [2:0] FUNCT3_BGE     = 3'b101;
localparam logic [2:0] FUNCT3_BLTU    = 3'b110;
localparam logic [2:0] FUNCT3_BGEU    = 3'b111;

localparam logic [6:0] FUNCT7_BASE    = 7'b0000000;
localparam logic [6:0] FUNCT7_SUB_SRA = 7'b0100000;

typedef enum logic [4:0] {
    CPU_INST_ADD,
    CPU_INST_SUB,
    CPU_INST_AND,
    CPU_INST_OR,
    CPU_INST_XOR,
    CPU_INST_ADDI,
    CPU_INST_ANDI,
    CPU_INST_ORI,
    CPU_INST_XORI,
    CPU_INST_LW,
    CPU_INST_SW,
    CPU_INST_BEQ,
    CPU_INST_BNE,
    CPU_INST_JAL,
    CPU_INST_JALR,
    CPU_INST_LUI,
    CPU_INST_SLL,
    CPU_INST_SRL,
    CPU_INST_ILLEGAL
} cpu_inst_t;

endpackage
