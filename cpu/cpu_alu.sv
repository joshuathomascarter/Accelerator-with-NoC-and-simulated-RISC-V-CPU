module cpu_alu (
    input  cpu_pkg::cpu_inst_t           decoded_inst,
    input  logic [cpu_pkg::CPU_XLEN-1:0] rs1_data,
    input  logic [cpu_pkg::CPU_XLEN-1:0] rs2_data,
    input  logic [cpu_pkg::CPU_XLEN-1:0] imm,

    output logic [cpu_pkg::CPU_XLEN-1:0] result
);
    import cpu_pkg::*;

    always_comb begin
        result = '0;

        unique case (decoded_inst)
            CPU_INST_ADD:  result = rs1_data + rs2_data;
            CPU_INST_SUB:  result = rs1_data - rs2_data;
            CPU_INST_AND:  result = rs1_data & rs2_data;
            CPU_INST_OR:   result = rs1_data | rs2_data;
            CPU_INST_XOR:  result = rs1_data ^ rs2_data;
            CPU_INST_SLL:  result = rs1_data << rs2_data[4:0];
            CPU_INST_SRL:  result = rs1_data >> rs2_data[4:0];
            CPU_INST_ADDI: result = rs1_data + imm;
            CPU_INST_ANDI: result = rs1_data & imm;
            CPU_INST_ORI:  result = rs1_data | imm;
            CPU_INST_XORI: result = rs1_data ^ imm;
            CPU_INST_LW:   result = rs1_data + imm;
            CPU_INST_SW:   result = rs1_data + imm;
            CPU_INST_LUI:  result = imm;
            default:       result = '0;
        endcase
    end

endmodule
