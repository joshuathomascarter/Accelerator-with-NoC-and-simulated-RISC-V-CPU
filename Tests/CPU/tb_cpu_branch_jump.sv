`timescale 1ns / 1ps

module tb_cpu_branch_jump;
    import cpu_pkg::*;

    localparam int CLK_PERIOD = 20;
    localparam int IMEM_DEPTH = 16;

    logic clk = 1'b0;
    logic rst_n;

    logic [31:0] core_pc;
    logic [31:0] core_next_pc;
    logic [31:0] imem_instruction;
    logic [31:0] current_instruction;
    cpu_inst_t   core_decoded_inst;
    logic [31:0] core_alu_result;
    logic [31:0] core_dmem_rd_data;
    logic        core_reg_wr_en;
    logic [4:0]  core_reg_wr_addr;
    logic [31:0] core_reg_wr_data;
    logic        core_dmem_rd_en;
    logic        core_dmem_wr_en;
    logic [31:0] core_dmem_addr;
    logic [31:0] core_dmem_wr_data;
    logic        core_mem_misaligned;

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
        .DATA_WIDTH(32),
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

    always #(CLK_PERIOD / 2) clk = ~clk;

    task automatic expect_reg(
        input logic [4:0] addr,
        input logic [31:0] expected
    );
        begin
            #1;
            if (u_cpu_core.u_regfile.register_file[addr] !== expected) begin
                $fatal(1, "x%0d mismatch: got 0x%08h expected 0x%08h",
                       addr, u_cpu_core.u_regfile.register_file[addr], expected);
            end
        end
    endtask

    initial begin
        rst_n = 1'b0;
        repeat (3) @(posedge clk);

        rst_n = 1'b1;
        repeat (20) @(posedge clk);

        // The program in Tests/cpu_imem_test.hex proves:
        // - BEQ is taken and skips x6.
        // - BNE is not taken and allows x7 to execute.
        // - JAL writes x8 = link address and skips x9.
        // - JALR writes x1 = link address and jumps to x11.
        expect_reg(5'd6,  32'h0000_0000);
        expect_reg(5'd7,  32'h0000_004D);
        expect_reg(5'd8,  32'h0000_002C);
        expect_reg(5'd9,  32'h0000_0000);
        expect_reg(5'd1,  32'h0000_0038);
        expect_reg(5'd10, 32'h0000_0037);
        expect_reg(5'd11, 32'h0000_0037);

        $display("CPU branch/jump focused test passed");
        $finish;
    end
endmodule
