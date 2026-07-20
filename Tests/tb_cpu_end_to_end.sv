`timescale 1ns / 1ps

module tb_cpu_end_to_end;
    import cpu_pkg::*;

    localparam int CLK_PERIOD = 20;

    logic clk = 1'b0;
    logic rst_n;
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
    logic saw_result_read;

    soc_top #(
        .IMEM_DEPTH(32),
        .DMEM_DEPTH(256),
        .USE_INTERNAL_ACCEL_MODEL(1'b1),
        .ACCEL_MODEL_LATENCY(4)
    ) u_soc (
        .clk(clk),
        .rst_n(rst_n),
        .accel_busy_i(1'b0),
        .accel_done_i(1'b0),
        .accel_result_valid_i(1'b0),
        .accel_overflow_i(1'b0),
        .accel_result_data_i('0),
        .accel_error_flags_i('0),
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
            saw_result_read <= 1'b0;
        end else begin
            saw_start       <= saw_start || accel_start;
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
        rst_n = 1'b0;
        repeat (3) @(posedge clk);
        rst_n = 1'b1;

        repeat (30) @(posedge clk);

        if (!saw_start) begin
            $fatal(1, "CPU did not start the internal accelerator model");
        end

        if (!saw_result_read) begin
            $fatal(1, "CPU did not read the accelerator result register");
        end

        if (cpu_mmio_error) begin
            $fatal(1, "Unexpected MMIO error in CPU end-to-end test");
        end

        if (accel_num_tiles !== 32'd4) begin
            $fatal(1, "Expected num_tiles=4, got %0d", accel_num_tiles);
        end

        if (!accel_final_layer) begin
            $fatal(1, "Expected final_layer to be latched high");
        end

        expect_reg(5'd6, 32'h0000_0006);
        expect_reg(5'd7, 32'hACCE_0004);
        expect_reg(5'd8, 32'h0000_0000);

        $display("CPU-to-accelerator end-to-end June 10 test passed");
        $finish;
    end
endmodule
