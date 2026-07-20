module cpu_decode (
    input  logic [cpu_pkg::CPU_INSTR_W-1:0] instruction,

    output cpu_pkg::cpu_inst_t              decoded_inst,
    output logic [cpu_pkg::CPU_REG_W-1:0]   rd,
    output logic [cpu_pkg::CPU_REG_W-1:0]   rs1,
    output logic [cpu_pkg::CPU_REG_W-1:0]   rs2,
    output logic [cpu_pkg::CPU_XLEN-1:0]    imm,
    output logic [6:0]                      opcode,
    output logic [2:0]                      funct3,
    output logic [6:0]                      funct7
);
    import cpu_pkg::*;

    always_comb begin
        opcode = instruction[6:0];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        funct7 = instruction[31:25];

        imm          = '0;
        decoded_inst = CPU_INST_ILLEGAL;

        unique case (opcode)
            OPCODE_OP: begin
                unique case (funct3)
                    FUNCT3_ADD_SUB: begin
                        if (funct7 == FUNCT7_BASE) begin
                            decoded_inst = CPU_INST_ADD;
                        end else if (funct7 == FUNCT7_SUB_SRA) begin
                            decoded_inst = CPU_INST_SUB;
                        end
                    end

                    FUNCT3_AND: begin
                        if (funct7 == FUNCT7_BASE) begin
                            decoded_inst = CPU_INST_AND;
                        end
                    end

                    FUNCT3_OR: begin
                        if (funct7 == FUNCT7_BASE) begin
                            decoded_inst = CPU_INST_OR;
                        end
                    end

                    FUNCT3_XOR: begin
                        if (funct7 == FUNCT7_BASE) begin
                            decoded_inst = CPU_INST_XOR;
                        end
                    end

                    FUNCT3_SLL: begin
                        if (funct7 == FUNCT7_BASE) begin
                            decoded_inst = CPU_INST_SLL;
                        end
                    end

                    FUNCT3_SR: begin
                        if (funct7 == FUNCT7_BASE) begin
                            decoded_inst = CPU_INST_SRL;
                        end
                    end

                    default: begin
                        decoded_inst = CPU_INST_ILLEGAL;
                    end
                endcase
            end

            OPCODE_OP_IMM: begin
                imm = {{20{instruction[31]}}, instruction[31:20]};

                unique case (funct3)
                    FUNCT3_ADD_SUB: decoded_inst = CPU_INST_ADDI;
                    FUNCT3_AND:     decoded_inst = CPU_INST_ANDI;
                    FUNCT3_OR:      decoded_inst = CPU_INST_ORI;
                    FUNCT3_XOR:     decoded_inst = CPU_INST_XORI;
                    default:        decoded_inst = CPU_INST_ILLEGAL;
                endcase
            end

            OPCODE_LOAD: begin
                imm = {{20{instruction[31]}}, instruction[31:20]};

                if (funct3 == FUNCT3_WORD) begin
                    decoded_inst = CPU_INST_LW;
                end
            end

            OPCODE_STORE: begin
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

                if (funct3 == FUNCT3_WORD) begin
                    decoded_inst = CPU_INST_SW;
                end
            end

            OPCODE_BRANCH: begin
                imm = {{19{instruction[31]}},
                       instruction[31],
                       instruction[7],
                       instruction[30:25],
                       instruction[11:8],
                       1'b0};

                unique case (funct3)
                    FUNCT3_BEQ: decoded_inst = CPU_INST_BEQ;
                    FUNCT3_BNE: decoded_inst = CPU_INST_BNE;
                    default:    decoded_inst = CPU_INST_ILLEGAL;
                endcase
            end

            OPCODE_JAL: begin
                imm = {{11{instruction[31]}},
                       instruction[31],
                       instruction[19:12],
                       instruction[20],
                       instruction[30:21],
                       1'b0};
                decoded_inst = CPU_INST_JAL;
            end

            OPCODE_JALR: begin
                imm = {{20{instruction[31]}}, instruction[31:20]};

                if (funct3 == FUNCT3_ADD_SUB) begin
                    decoded_inst = CPU_INST_JALR;
                end
            end

            OPCODE_LUI: begin
                imm          = {instruction[31:12], 12'b0};
                decoded_inst = CPU_INST_LUI;
            end

            default: begin
                decoded_inst = CPU_INST_ILLEGAL;
            end
        endcase
    end

endmodule
