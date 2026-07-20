`timescale 1ns / 1ps

module tb_cpu_mmio_bridge;
    import cpu_pkg::*;

    localparam int CLK_PERIOD = 20;

    logic clk = 1'b0;
    logic rst_n;
    logic cpu_rd_en;
    logic cpu_wr_en;
    logic [31:0] cpu_addr;
    logic [31:0] cpu_wr_data;
    logic [31:0] cpu_rd_data;
    logic cpu_ready;
    logic cpu_error;
    logic mmio_hit;
    logic accel_busy;
    logic accel_done;
    logic accel_result_valid;
    logic accel_overflow;
    logic [31:0] accel_result_data;
    logic [31:0] accel_error_flags;
    logic accel_start;
    logic accel_clear;
    logic accel_final_layer;
    logic [31:0] accel_num_tiles;
    logic accel_weight_wr_en;
    logic [31:0] accel_weight_wr_data;
    logic accel_act_wr_en;
    logic [31:0] accel_act_wr_data;
    logic accel_result_rd_en;

    cpu_mmio_bridge u_bridge (
        .clk(clk),
        .rst_n(rst_n),
        .cpu_rd_en(cpu_rd_en),
        .cpu_wr_en(cpu_wr_en),
        .cpu_addr(cpu_addr),
        .cpu_wr_data(cpu_wr_data),
        .cpu_rd_data(cpu_rd_data),
        .cpu_ready(cpu_ready),
        .cpu_error(cpu_error),
        .mmio_hit(mmio_hit),
        .accel_busy(accel_busy),
        .accel_done(accel_done),
        .accel_result_valid(accel_result_valid),
        .accel_overflow(accel_overflow),
        .accel_result_data(accel_result_data),
        .accel_error_flags(accel_error_flags),
        .accel_start(accel_start),
        .accel_clear(accel_clear),
        .accel_final_layer(accel_final_layer),
        .accel_num_tiles(accel_num_tiles),
        .accel_weight_wr_en(accel_weight_wr_en),
        .accel_weight_wr_data(accel_weight_wr_data),
        .accel_act_wr_en(accel_act_wr_en),
        .accel_act_wr_data(accel_act_wr_data),
        .accel_result_rd_en(accel_result_rd_en)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    task automatic mmio_write(
        input logic [31:0] addr,
        input logic [31:0] data
    );
        begin
            @(negedge clk);
            cpu_addr    = addr;
            cpu_wr_data = data;
            cpu_wr_en   = 1'b1;
            cpu_rd_en   = 1'b0;
            @(posedge clk);
            @(negedge clk);
            cpu_wr_en   = 1'b0;
            cpu_wr_data = '0;
        end
    endtask

    task automatic mmio_read(
        input logic [31:0] addr
    );
        begin
            @(negedge clk);
            cpu_addr  = addr;
            cpu_rd_en = 1'b1;
            cpu_wr_en = 1'b0;
            @(posedge clk);
            @(negedge clk);
            cpu_rd_en = 1'b0;
        end
    endtask

    task automatic expect_word(
        input logic [31:0] got,
        input logic [31:0] expected,
        input string label
    );
        begin
            #1;
            if (got !== expected) begin
                $fatal(1, "%s mismatch: got 0x%08h expected 0x%08h",
                       label, got, expected);
            end
        end
    endtask

    initial begin
        rst_n              = 1'b0;
        cpu_rd_en          = 1'b0;
        cpu_wr_en          = 1'b0;
        cpu_addr           = '0;
        cpu_wr_data        = '0;
        accel_busy         = 1'b0;
        accel_done         = 1'b0;
        accel_result_valid = 1'b0;
        accel_overflow     = 1'b0;
        accel_result_data  = 32'hCAFE_BABE;
        accel_error_flags  = 32'h0000_00A5;

        repeat (3) @(posedge clk);
        rst_n = 1'b1;

        mmio_write(CPU_MMIO_ACCEL_TILE_COUNT, 32'd4);
        expect_word(accel_num_tiles, 32'd4, "accel_num_tiles");

        mmio_write(CPU_MMIO_ACCEL_CTRL, 32'b101);
        #1;
        if (!accel_start || accel_clear || !accel_final_layer) begin
            $fatal(1, "CTRL write did not produce expected start/final_layer behavior");
        end

        @(posedge clk);
        #1;
        if (accel_start || accel_clear) begin
            $fatal(1, "start/clear should be one-cycle pulses");
        end

        mmio_write(CPU_MMIO_ACCEL_WEIGHT, 32'h1122_3344);
        #1;
        if (!accel_weight_wr_en || accel_weight_wr_data !== 32'h1122_3344) begin
            $fatal(1, "weight write pulse/data mismatch");
        end

        mmio_write(CPU_MMIO_ACCEL_ACT, 32'h5566_7788);
        #1;
        if (!accel_act_wr_en || accel_act_wr_data !== 32'h5566_7788) begin
            $fatal(1, "activation write pulse/data mismatch");
        end

        accel_busy         = 1'b1;
        accel_done         = 1'b1;
        accel_result_valid = 1'b1;
        accel_overflow     = 1'b1;
        mmio_read(CPU_MMIO_ACCEL_STATUS);
        expect_word(cpu_rd_data, 32'h0000_000F, "status read");

        mmio_read(CPU_MMIO_ACCEL_RESULT);
        expect_word(cpu_rd_data, 32'hCAFE_BABE, "result read");
        #1;
        if (!accel_result_rd_en) begin
            $fatal(1, "result read did not pulse accel_result_rd_en");
        end

        mmio_read(CPU_MMIO_ACCEL_ERROR);
        expect_word(cpu_rd_data, 32'h0000_00A5, "error read");

        @(negedge clk);
        cpu_addr  = CPU_MMIO_ACCEL_BASE + 32'h0000_0001;
        cpu_rd_en = 1'b1;
        #1;
        if (!cpu_error) begin
            $fatal(1, "misaligned MMIO access should assert cpu_error");
        end

        @(negedge clk);
        cpu_addr  = 32'h0000_0000;
        cpu_rd_en = 1'b1;
        #1;
        if (mmio_hit || cpu_ready || cpu_error) begin
            $fatal(1, "non-MMIO address should not be claimed by bridge");
        end

        $display("CPU MMIO bridge June 7 test passed");
        $finish;
    end
endmodule
