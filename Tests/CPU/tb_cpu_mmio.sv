`timescale 1ns / 1ps

module tb_cpu_mmio;
    import cpu_pkg::*;

    localparam int CLK_PERIOD = 20;

    logic clk = 1'b0;
    logic rst_n;
    logic accel_busy_i;
    logic accel_done_i;
    logic accel_result_valid_i;
    logic accel_overflow_i;
    logic [31:0] accel_result_data_i;
    logic [31:0] accel_error_flags_i;
    logic accel_start;
    logic accel_clear;
    logic accel_final_layer;
    logic [31:0] accel_num_tiles;
    logic accel_weight_wr_en;
    logic [31:0] accel_weight_wr_data;
    logic accel_act_wr_en;
    logic [31:0] accel_act_wr_data;
    logic accel_result_rd_en;
    logic [31:0] cpu_pc;
    logic [31:0] cpu_mem_addr;
    logic cpu_mem_rd_en;
    logic cpu_mem_wr_en;
    logic cpu_mmio_hit;
    logic cpu_mmio_error;

    logic saw_start;
    logic saw_weight_write;
    logic saw_act_write;
    logic saw_result_read;

    soc_top #(
        .IMEM_DEPTH(32),
        .DMEM_DEPTH(256)
    ) u_soc (
        .clk(clk),
        .rst_n(rst_n),
        .accel_busy_i(accel_busy_i),
        .accel_done_i(accel_done_i),
        .accel_result_valid_i(accel_result_valid_i),
        .accel_overflow_i(accel_overflow_i),
        .accel_result_data_i(accel_result_data_i),
        .accel_error_flags_i(accel_error_flags_i),
        .accel_start(accel_start),
        .accel_clear(accel_clear),
        .accel_final_layer(accel_final_layer),
        .accel_num_tiles(accel_num_tiles),
        .accel_weight_wr_en(accel_weight_wr_en),
        .accel_weight_wr_data(accel_weight_wr_data),
        .accel_act_wr_en(accel_act_wr_en),
        .accel_act_wr_data(accel_act_wr_data),
        .accel_result_rd_en(accel_result_rd_en),
        .cpu_pc(cpu_pc),
        .cpu_mem_addr(cpu_mem_addr),
        .cpu_mem_rd_en(cpu_mem_rd_en),
        .cpu_mem_wr_en(cpu_mem_wr_en),
        .cpu_mmio_hit(cpu_mmio_hit),
        .cpu_mmio_error(cpu_mmio_error)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            saw_start       <= 1'b0;
            saw_weight_write <= 1'b0;
            saw_act_write   <= 1'b0;
            saw_result_read <= 1'b0;
        end else begin
            saw_start       <= saw_start || accel_start;
            saw_weight_write <= saw_weight_write || accel_weight_wr_en;
            saw_act_write   <= saw_act_write || accel_act_wr_en;
            saw_result_read <= saw_result_read || accel_result_rd_en;
        end
    end

    task automatic expect_reg(
        input logic [4:0] addr,
        input logic [31:0] expected
    );
        begin
            #1;
            if (u_soc.u_cpu.u_regfile.register_file[addr] !== expected) begin
                $fatal(1, "x%0d mismatch: got 0x%08h expected 0x%08h",
                       addr, u_soc.u_cpu.u_regfile.register_file[addr], expected);
            end
        end
    endtask

    initial begin
        rst_n                = 1'b0;
        accel_busy_i         = 1'b1;
        accel_done_i         = 1'b1;
        accel_result_valid_i = 1'b1;
        accel_overflow_i     = 1'b0;
        accel_result_data_i  = 32'hCAFE_BABE;
        accel_error_flags_i  = 32'h0000_00A5;

        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        repeat (24) @(posedge clk);

        if (!saw_start) begin
            $fatal(1, "CPU program never generated accel_start");
        end

        if (!saw_weight_write || accel_weight_wr_data !== 32'h1122_3344) begin
            $fatal(1, "CPU program did not write expected weight payload");
        end

        if (!saw_act_write || accel_act_wr_data !== 32'h5566_7788) begin
            $fatal(1, "CPU program did not write expected activation payload");
        end

        if (!saw_result_read) begin
            $fatal(1, "CPU program never read ACCEL_RESULT");
        end

        if (cpu_mmio_error) begin
            $fatal(1, "Unexpected MMIO error during CPU MMIO program");
        end

        if (accel_num_tiles !== 32'd4) begin
            $fatal(1, "accel_num_tiles mismatch: got %0d expected 4", accel_num_tiles);
        end

        if (!accel_final_layer) begin
            $fatal(1, "final_layer should be latched high by ACCEL_CTRL write");
        end

        expect_reg(5'd6, 32'h0000_0007);
        expect_reg(5'd7, 32'hCAFE_BABE);
        expect_reg(5'd8, 32'h0000_00A5);

        $display("CPU-to-MMIO SoC June 8-9 test passed");
        $finish;
    end
endmodule
