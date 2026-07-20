`timescale 1ns / 1ps

module tb_cpu_real_chip_end_to_end;
    import cpu_pkg::*;
    import noc_packet_pkg::*;

    localparam int CLK_PERIOD = 20;

    logic clk = 1'b0;
    logic rst_n;
    logic [31:0] cpu_pc;
    logic [31:0] cpu_mem_addr;
    logic cpu_mmio_error;
    logic chip_busy;
    logic chip_done;
    logic chip_result_valid;
    logic [31:0] chip_result_data;
    logic [31:0] chip_error_flags;
    logic [31:0] accel_num_tiles;

    soc_real_chip_top #(
        .IMEM_DEPTH(256),
        .DMEM_DEPTH(256)
    ) u_soc (
        .clk(clk),
        .rst_n(rst_n),
        .cpu_pc(cpu_pc),
        .cpu_mem_addr(cpu_mem_addr),
        .cpu_mmio_error(cpu_mmio_error),
        .chip_busy(chip_busy),
        .chip_done(chip_done),
        .chip_result_valid(chip_result_valid),
        .chip_result_data(chip_result_data),
        .chip_error_flags(chip_error_flags),
        .accel_num_tiles(accel_num_tiles)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    task automatic expect_reg_non_x(input logic [4:0] addr);
        begin
            #1;
            if (^u_soc.u_cpu.u_regfile.register_file[addr] === 1'bx) begin
                $fatal(1, "x%0d contains X", addr);
            end
        end
    endtask

    initial begin
        rst_n = 1'b0;
        repeat (5) @(posedge clk);
        rst_n = 1'b1;

        repeat (260) @(posedge clk);

        if (cpu_mmio_error) begin
            $fatal(1, "Unexpected MMIO error during real chip SoC test");
        end

        if (accel_num_tiles !== 32'd4) begin
            $fatal(1, "Expected num_tiles=4, got %0d", accel_num_tiles);
        end

        if (!chip_done || !chip_result_valid) begin
            $fatal(1, "Real chip path did not report done/result_valid");
        end

        expect_reg_non_x(5'd6);
        expect_reg_non_x(5'd7);
        expect_reg_non_x(5'd8);

        if ((u_soc.u_cpu.u_regfile.register_file[5'd6] & 32'h0000_0006) != 32'h0000_0006) begin
            $fatal(1, "CPU status register x6 did not capture done/result_valid: 0x%08h",
                   u_soc.u_cpu.u_regfile.register_file[5'd6]);
        end

        $display("CPU-to-real-2x2-chip end-to-end test passed: status=0x%08h result=0x%08h error=0x%08h",
                 u_soc.u_cpu.u_regfile.register_file[5'd6],
                 u_soc.u_cpu.u_regfile.register_file[5'd7],
                 u_soc.u_cpu.u_regfile.register_file[5'd8]);
        $finish;
    end
endmodule
