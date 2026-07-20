module cpu_core #(
    parameter int INSTR_WIDTH = cpu_pkg::CPU_INSTR_W,
    parameter int DMEM_DEPTH  = 256
)(
    input  logic clk,
    input  logic rst_n,

    input  logic [INSTR_WIDTH-1:0] instruction,

    output logic [31:0] pc,
    output logic [31:0] next_pc,
    output logic [INSTR_WIDTH-1:0] current_instruction,
    output cpu_pkg::cpu_inst_t decoded_inst,
    output logic [31:0] alu_result,
    input  logic [31:0] dmem_rd_data,
    output logic        reg_wr_en,
    output logic [4:0]  reg_wr_addr,
    output logic [31:0] reg_wr_data,
    output logic        dmem_rd_en,
    output logic        dmem_wr_en,
    output logic [31:0] dmem_addr,
    output logic [31:0] dmem_wr_data,
    output logic        mem_misaligned
);
    import cpu_pkg::*;

    logic pc_write;
    logic instr_write;
    logic [4:0] decoded_rd;
    logic [4:0] decoded_rs1;
    logic [4:0] decoded_rs2;
    logic [31:0] decoded_imm;
    logic [6:0] decoded_opcode;
    logic [2:0] decoded_funct3;
    logic [6:0] decoded_funct7;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] load_data;
    logic reg_wr_en_d;
    logic [31:0] reg_wr_data_d;
    logic [31:0] pc_plus_4;
    logic        branch_taken;

    cpu_control u_control (
        .clk(clk),
        .rst_n(rst_n),
        .pc_write(pc_write),
        .instr_write(instr_write)
    );

    cpu_decode u_decode (
        .instruction(instruction),
        .decoded_inst(decoded_inst),
        .rd(decoded_rd),
        .rs1(decoded_rs1),
        .rs2(decoded_rs2),
        .imm(decoded_imm),
        .opcode(decoded_opcode),
        .funct3(decoded_funct3),
        .funct7(decoded_funct7)
    );

    cpu_regfile u_regfile (
        .clk(clk),
        .rst_n(rst_n),
        .rd_addr_a(decoded_rs1),
        .rd_data_a(rs1_data),
        .rd_addr_b(decoded_rs2),
        .rd_data_b(rs2_data),
        .wr_en(reg_wr_en),
        .wr_addr(reg_wr_addr),
        .wr_data(reg_wr_data)
    );

    cpu_alu u_alu (
        .decoded_inst(decoded_inst),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm(decoded_imm),
        .result(alu_result)
    );

    cpu_lsu u_lsu (
        .decoded_inst(decoded_inst),
        .address(alu_result),
        .store_data(rs2_data),
        .dmem_rd_data(dmem_rd_data),
        .dmem_rd_en(dmem_rd_en),
        .dmem_wr_en(dmem_wr_en),
        .dmem_addr(dmem_addr),
        .dmem_wr_data(dmem_wr_data),
        .load_data(load_data),
        .misaligned(mem_misaligned)
    );

    always_comb begin
        pc_plus_4    = pc + 32'd4;
        branch_taken = 1'b0;
        next_pc      = pc_plus_4;

        unique case (decoded_inst)
            CPU_INST_BEQ: begin
                branch_taken = (rs1_data == rs2_data);
                if (branch_taken) begin
                    next_pc = pc + decoded_imm;
                end
            end

            CPU_INST_BNE: begin
                branch_taken = (rs1_data != rs2_data);
                if (branch_taken) begin
                    next_pc = pc + decoded_imm;
                end
            end

            CPU_INST_JAL: begin
                next_pc = pc + decoded_imm;
            end

            CPU_INST_JALR: begin
                next_pc = (rs1_data + decoded_imm) & 32'hFFFF_FFFE;
            end

            default: begin
                next_pc = pc_plus_4;
            end
        endcase
    end

    always_comb begin
        reg_wr_en_d   = 1'b0;
        reg_wr_data_d = alu_result;

        unique case (decoded_inst)
            CPU_INST_ADD,
            CPU_INST_SUB,
            CPU_INST_AND,
            CPU_INST_OR,
            CPU_INST_XOR,
            CPU_INST_SLL,
            CPU_INST_SRL,
            CPU_INST_ADDI,
            CPU_INST_ANDI,
            CPU_INST_ORI,
            CPU_INST_XORI,
            CPU_INST_LUI: begin
                reg_wr_en_d = 1'b1;
            end

            CPU_INST_LW: begin
                reg_wr_en_d   = !mem_misaligned;
                reg_wr_data_d = load_data;
            end

            CPU_INST_JAL,
            CPU_INST_JALR: begin
                reg_wr_en_d   = 1'b1;
                reg_wr_data_d = pc_plus_4;
            end

            default: begin
                reg_wr_en_d = 1'b0;
            end
        endcase
    end

    assign reg_wr_en   = reg_wr_en_d;
    assign reg_wr_addr = decoded_rd;
    assign reg_wr_data = reg_wr_data_d;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc                  <= 32'h0000_0000;
            current_instruction <= '0;
        end else begin
            if (instr_write) begin
                current_instruction <= instruction;
            end

            if (pc_write) begin
                pc <= next_pc;
            end
        end
    end

endmodule
