`timescale 1ns / 1ps

// Register-file unit checks live in tb_cpu_regfile.sv: a second cpu_regfile
// instance in this testbench made XSIM mis-elaborate the core's datapath.
module tb_cpu_core;
    import cpu_pkg::*;

    localparam int CLK_PERIOD = 20;
    localparam int REG_COUNT  = 32;
    localparam int DATA_WIDTH = 32;
    localparam int IMEM_DEPTH = 16;
    localparam int REG_ADDR_W = $clog2(REG_COUNT);

    logic clk = 1'b0;
    logic rst_n;


    logic [31:0] core_pc;
    logic [31:0] core_next_pc;
    logic [31:0] imem_instruction;
    logic [31:0] current_instruction;
    cpu_inst_t core_decoded_inst;
    logic [31:0] core_alu_result;
    logic [31:0] core_dmem_rd_data;
    logic core_reg_wr_en;
    logic [4:0] core_reg_wr_addr;
    logic [31:0] core_reg_wr_data;
    logic core_dmem_rd_en;
    logic core_dmem_wr_en;
    logic [31:0] core_dmem_addr;
    logic [31:0] core_dmem_wr_data;
    logic core_mem_misaligned;
    logic [31:0] decode_instruction;
    cpu_inst_t decoded_inst;
    logic [REG_ADDR_W-1:0] decode_rd;
    logic [REG_ADDR_W-1:0] decode_rs1;
    logic [REG_ADDR_W-1:0] decode_rs2;
    logic [31:0] decode_imm;
    logic [6:0] decode_opcode;
    logic [2:0] decode_funct3;
    logic [6:0] decode_funct7;

    cpu_imem #(
        .INSTR_WIDTH(32),
        .DEPTH(IMEM_DEPTH),
        .INIT_FILE("Tests/cpu_imem_test.hex")
    ) u_imem (
        .pc(core_pc),
        .instruction(imem_instruction)
    );

    cpu_core #(
        .INSTR_WIDTH(32)
    ) u_cpu_core (
        .clk(clk),
        .rst_n(rst_n),
        .instruction(imem_instruction),
        .pc(core_pc),
        .next_pc(core_next_pc),
        .current_instruction(current_instruction),
        .decoded_inst(core_decoded_inst),
        .alu_result(core_alu_result),
        .dmem_rd_data(core_dmem_rd_data),
        .reg_wr_en(core_reg_wr_en),
        .reg_wr_addr(core_reg_wr_addr),
        .reg_wr_data(core_reg_wr_data),
        .dmem_rd_en(core_dmem_rd_en),
        .dmem_wr_en(core_dmem_wr_en),
        .dmem_addr(core_dmem_addr),
        .dmem_wr_data(core_dmem_wr_data),
        .mem_misaligned(core_mem_misaligned)
    );

    cpu_dmem #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(256)
    ) u_core_dmem (
        .clk(clk),
        .rst_n(rst_n),
        .rd_en(core_dmem_rd_en),
        .wr_en(core_dmem_wr_en),
        .addr(core_dmem_addr),
        .wr_data(core_dmem_wr_data),
        .rd_data(core_dmem_rd_data)
    );

    cpu_decode u_decode (
        .instruction(decode_instruction),
        .decoded_inst(decoded_inst),
        .rd(decode_rd),
        .rs1(decode_rs1),
        .rs2(decode_rs2),
        .imm(decode_imm),
        .opcode(decode_opcode),
        .funct3(decode_funct3),
        .funct7(decode_funct7)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    task automatic expect_core_state(
        input logic [31:0] expected_pc,
        input logic [31:0] expected_next_pc,
        input logic [31:0] expected_current_instruction
    );
        begin
            #1;

            if (core_pc !== expected_pc) begin
                $fatal(1, "PC mismatch: got 0x%08h expected 0x%08h",
                       core_pc, expected_pc);
            end

            if (core_next_pc !== expected_next_pc) begin
                $fatal(1, "next_pc mismatch: got 0x%08h expected 0x%08h",
                       core_next_pc, expected_next_pc);
            end

            if (current_instruction !== expected_current_instruction) begin
                $fatal(1, "current_instruction mismatch: got 0x%08h expected 0x%08h",
                       current_instruction, expected_current_instruction);
            end
        end
    endtask

    task automatic expect_decode(
        input logic [31:0] instruction_value,
        input cpu_inst_t expected_inst,
        input logic [REG_ADDR_W-1:0] expected_rd,
        input logic [REG_ADDR_W-1:0] expected_rs1,
        input logic [REG_ADDR_W-1:0] expected_rs2,
        input logic [31:0] expected_imm
    );
        begin
             decode_instruction = instruction_value;
            #1;

            if (decoded_inst !== expected_inst) begin
                $fatal(1, "decode instruction mismatch for 0x%08h: got %0d expected %0d",
                       instruction_value, decoded_inst, expected_inst);
            end

            if (decode_rd !== expected_rd) begin
                $fatal(1, "decode rd mismatch for 0x%08h: got x%0d expected x%0d",
                       instruction_value, decode_rd, expected_rd);
            end

            if (decode_rs1 !== expected_rs1) begin
                $fatal(1, "decode rs1 mismatch for 0x%08h: got x%0d expected x%0d",
                       instruction_value, decode_rs1, expected_rs1);
            end

            if (decode_rs2 !== expected_rs2) begin
                $fatal(1, "decode rs2 mismatch for 0x%08h: got x%0d expected x%0d",
                       instruction_value, decode_rs2, expected_rs2);
            end

            if (decode_imm !== expected_imm) begin
                $fatal(1, "decode imm mismatch for 0x%08h: got 0x%08h expected 0x%08h",
                       instruction_value, decode_imm, expected_imm);
            end
        end
    endtask

    task automatic expect_core_reg(
        input logic [REG_ADDR_W-1:0] addr,
        input logic [31:0] expected
    );
        begin
            #1;

            if (u_cpu_core.u_regfile.register_file[addr] !== expected) begin
                $fatal(1, "core register x%0d mismatch: got 0x%08h expected 0x%08h",
                       addr, u_cpu_core.u_regfile.register_file[addr], expected);
            end
        end
    endtask

    task automatic expect_core_dmem_word(
        input int unsigned idx,
        input logic [31:0] expected
    );
        begin
            #1;

            if (u_core_dmem.dmem[idx] !== expected) begin
                $fatal(1, "core dmem[%0d] mismatch: got 0x%08h expected 0x%08h",
                       idx, u_core_dmem.dmem[idx], expected);
            end
        end
    endtask

    initial begin
        rst_n     = 1'b0;
        decode_instruction = '0;

        repeat (3) @(posedge clk);
        expect_core_state(32'h0000_0000, 32'h0000_0004, 32'h0000_0000);

        rst_n = 1'b1;
        repeat (2) @(posedge clk);


        @(negedge clk);
        rst_n = 1'b0;
        repeat (2) @(posedge clk);
        expect_core_state(32'h0000_0000, 32'h0000_0004, 32'h0000_0000);

        @(negedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        $display("Checking CPU core fetch and PC update");
        expect_core_state(32'h0000_0004, 32'h0000_0008, 32'h0050_0093);

        @(posedge clk);
        expect_core_state(32'h0000_0008, 32'h0000_000C, 32'h0010_0113);

        @(posedge clk);
        expect_core_state(32'h0000_000C, 32'h0000_0010, 32'h0020_81B3);

        @(posedge clk);
        expect_core_state(32'h0000_0010, 32'h0000_0014, 32'h0030_2023);

        @(posedge clk);
        expect_core_state(32'h0000_0014, 32'h0000_0018, 32'h0000_2203);

        @(posedge clk);
        expect_core_state(32'h0000_0018, 32'h0000_0020, 32'h0032_02B3);

        @(posedge clk);
        expect_core_state(32'h0000_0020, 32'h0000_0024, 32'h0031_8463);

        @(posedge clk);
        expect_core_state(32'h0000_0024, 32'h0000_0028, 32'h0032_1463);

        @(posedge clk);
        expect_core_state(32'h0000_0028, 32'h0000_0030, 32'h04D0_0393);

        @(posedge clk);
        expect_core_state(32'h0000_0030, 32'h0000_0034, 32'h0080_046F);

        @(posedge clk);
        expect_core_state(32'h0000_0034, 32'h0000_0038, 32'h0370_0513);

        $display("Checking out-of-range instruction fetch returns zero");
        repeat (4) @(posedge clk);
        expect_core_state(32'h0000_0044, 32'h0000_0048, 32'h0000_0000);

        $display("Checking CPU ALU arithmetic writeback");
        expect_core_reg(5'd2, 32'h0000_0001);
        expect_core_reg(5'd3, 32'h0000_0006);

        $display("Checking CPU load/store data memory path");
        expect_core_dmem_word(0, 32'h0000_0006);
        expect_core_reg(5'd4, 32'h0000_0006);
        expect_core_reg(5'd5, 32'h0000_000C);

        $display("Checking CPU branch and jump control flow");
        expect_core_reg(5'd6, 32'h0000_0000);
        expect_core_reg(5'd7, 32'h0000_004D);
        expect_core_reg(5'd8, 32'h0000_002C);
        expect_core_reg(5'd9, 32'h0000_0000);
        expect_core_reg(5'd1, 32'h0000_0038);
        expect_core_reg(5'd10, 32'h0000_0037);
        expect_core_reg(5'd11, 32'h0000_0037);

        $display("Checking CPU decoder and immediate generation");
        expect_decode(
            {FUNCT7_BASE, 5'd2, 5'd1, FUNCT3_ADD_SUB, 5'd3, OPCODE_OP},
            CPU_INST_ADD, 5'd3, 5'd1, 5'd2, 32'h0000_0000
        );
        expect_decode(
            {FUNCT7_SUB_SRA, 5'd2, 5'd1, FUNCT3_ADD_SUB, 5'd3, OPCODE_OP},
            CPU_INST_SUB, 5'd3, 5'd1, 5'd2, 32'h0000_0000
        );
        expect_decode(
            {12'h005, 5'd0, FUNCT3_ADD_SUB, 5'd1, OPCODE_OP_IMM},
            CPU_INST_ADDI, 5'd1, 5'd0, 5'd5, 32'h0000_0005
        );
        expect_decode(
            {12'hFFC, 5'd6, FUNCT3_WORD, 5'd5, OPCODE_LOAD},
            CPU_INST_LW, 5'd5, 5'd6, 5'd28, 32'hFFFF_FFFC
        );
        expect_decode(
            {7'b1111111, 5'd5, 5'd6, FUNCT3_WORD, 5'b11000, OPCODE_STORE},
            CPU_INST_SW, 5'd24, 5'd6, 5'd5, 32'hFFFF_FFF8
        );
        expect_decode(
            {1'b0, 6'b000000, 5'd2, 5'd1, FUNCT3_BEQ, 4'b0100, 1'b0, OPCODE_BRANCH},
            CPU_INST_BEQ, 5'd8, 5'd1, 5'd2, 32'h0000_0008
        );
        expect_decode(
            {1'b0, 6'b000000, 5'd2, 5'd1, FUNCT3_BNE, 4'b0100, 1'b0, OPCODE_BRANCH},
            CPU_INST_BNE, 5'd8, 5'd1, 5'd2, 32'h0000_0008
        );
        expect_decode(
            {1'b0, 10'b0000001000, 1'b0, 8'h00, 5'd1, OPCODE_JAL},
            CPU_INST_JAL, 5'd1, 5'd0, 5'd16, 32'h0000_0010
        );
        expect_decode(
            {12'h004, 5'd2, FUNCT3_ADD_SUB, 5'd1, OPCODE_JALR},
            CPU_INST_JALR, 5'd1, 5'd2, 5'd4, 32'h0000_0004
        );
        expect_decode(
            {20'h80000, 5'd1, OPCODE_LUI},
            CPU_INST_LUI, 5'd1, 5'd0, 5'd0, 32'h8000_0000
        );
        expect_decode(
            32'hFFFF_FFFF,
            CPU_INST_ILLEGAL, 5'd31, 5'd31, 5'd31, 32'h0000_0000
        );

        $display("CPU core branch/jump June 6 test passed");
        $finish;
    end
endmodule
