`timescale 1ns / 1ps

module tb_simple();
    parameter int DATA_WIDTH = 8;
    parameter int CLK_PERIOD = 20;

    logic clk = 1'b0;
    logic rst_n;

    logic [DATA_WIDTH-1:0] host_tx_data;
    logic                  host_tx_start;
    logic                  host_tx_busy;
    logic                  host_serial;

    logic [DATA_WIDTH-1:0] dut_rx_data;
    logic                  dut_rx_done;
    logic                  dut_tx_active;
    logic                  dut_serial_out;

    uart_tx #(
        .DATA_WIDTH(DATA_WIDTH),
        .CLK_FREQUENCY(50_000_000),
        .DIV(434)
    ) host_uart_tx (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(host_tx_data),
        .tx_start(host_tx_start),
        .tx_busy(host_tx_busy),
        .tx_out(host_serial)
    );

    uart_loopback #(
        .UART_DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(16),
        .FIFO_ADDR_W(4)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx_i(host_serial),
        .uart_tx_o(dut_serial_out),
        .rx_debug_data(dut_rx_data),
        .rx_done(dut_rx_done),
        .tx_active(dut_tx_active),
        .fifo_full(),
        .fifo_empty()
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    task automatic send_byte(input logic [7:0] value);
        begin
            @(posedge clk);
            while (host_tx_busy) @(posedge clk);
            host_tx_data <= value;
            host_tx_start <= 1'b1;
            @(posedge clk);
            host_tx_start <= 1'b0;
        end
    endtask

    initial begin
        rst_n = 1'b0;
        host_tx_start = 1'b0;
        host_tx_data = '0;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (5) @(posedge clk);

        $display("Sending WRITE 0x57 (opcode)");
        send_byte(8'h57);

        $display("Sending address 0x03");
        send_byte(8'h03);

        $display("Sending data bytes");
        send_byte(8'hAB);
        send_byte(8'h00);
        send_byte(8'h00);
        send_byte(8'h00);

        repeat (200) @(posedge clk);
        $display("Test completed");
        $finish;
    end
endmodule
