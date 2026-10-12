`timescale 1ns / 1ps

// cpu_regfile unit test: reset to zero, write/read, x0 hard-wired to zero,
// asynchronous read ports.
module tb_cpu_regfile;
    localparam int CLK_PERIOD = 20;
    localparam int REG_COUNT  = 32;
    localparam int DATA_WIDTH = 32;
    localparam int REG_ADDR_W = $clog2(REG_COUNT);

    logic clk = 1'b0;
    logic rst_n;

    logic [REG_ADDR_W-1:0] rd_addr_a;
    logic [DATA_WIDTH-1:0] rd_data_a;
    logic [REG_ADDR_W-1:0] rd_addr_b;
    logic [DATA_WIDTH-1:0] rd_data_b;
    logic                  wr_en;
    logic [REG_ADDR_W-1:0] wr_addr;
    logic [DATA_WIDTH-1:0] wr_data;

    cpu_regfile #(
        .REG_COUNT(REG_COUNT),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_regfile (
        .clk(clk),
        .rst_n(rst_n),
        .rd_addr_a(rd_addr_a),
        .rd_data_a(rd_data_a),
        .rd_addr_b(rd_addr_b),
        .rd_data_b(rd_data_b),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    task automatic write_reg(
        input logic [REG_ADDR_W-1:0] addr,
        input logic [DATA_WIDTH-1:0] data
    );
        begin
            @(negedge clk);
            wr_en   = 1'b1;
            wr_addr = addr;
            wr_data = data;
            @(posedge clk);
            @(negedge clk);
            wr_en   = 1'b0;
            wr_addr = '0;
            wr_data = '0;
        end
    endtask

    task automatic expect_reg_read(
        input logic [REG_ADDR_W-1:0] addr_a,
        input logic [DATA_WIDTH-1:0] expected_a,
        input logic [REG_ADDR_W-1:0] addr_b,
        input logic [DATA_WIDTH-1:0] expected_b
    );
        begin
            rd_addr_a = addr_a;
            rd_addr_b = addr_b;
            #1;
            if (rd_data_a !== expected_a) begin
                $fatal(1, "rd_data_a mismatch for x%0d: got 0x%08h expected 0x%08h",
                       addr_a, rd_data_a, expected_a);
            end
            if (rd_data_b !== expected_b) begin
                $fatal(1, "rd_data_b mismatch for x%0d: got 0x%08h expected 0x%08h",
                       addr_b, rd_data_b, expected_b);
            end
        end
    endtask

    initial begin
        rst_n     = 1'b0;
        rd_addr_a = '0;
        rd_addr_b = '0;
        wr_en     = 1'b0;
        wr_addr   = '0;
        wr_data   = '0;

        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        $display("Checking register file reset and x0 behavior");
        expect_reg_read(5'd0, 32'h0000_0000, 5'd1, 32'h0000_0000);

        write_reg(5'd1, 32'h1111_2222);
        write_reg(5'd2, 32'h3333_4444);
        expect_reg_read(5'd1, 32'h1111_2222, 5'd2, 32'h3333_4444);

        $display("Checking writes to x0 are ignored");
        write_reg(5'd0, 32'hFFFF_FFFF);
        expect_reg_read(5'd0, 32'h0000_0000, 5'd1, 32'h1111_2222);

        $display("Checking async read address changes");
        expect_reg_read(5'd2, 32'h3333_4444, 5'd0, 32'h0000_0000);

        $display("CPU register file test passed");
        $finish;
    end
endmodule
