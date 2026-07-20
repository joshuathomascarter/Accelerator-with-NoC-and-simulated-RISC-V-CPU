`timescale 1ns / 1ps

module tb_uart_loopback();

    parameter int DATA_WIDTH = 8;
    parameter int CLK_PERIOD = 20;

    logic clk = 1'b0;
    logic rst_n;

    logic                  host_tx_start;
    logic [DATA_WIDTH-1:0] host_tx_data;
    logic                  host_tx_busy;
    logic                  host_serial;

    logic [DATA_WIDTH-1:0] dut_rx_data;
    logic                  dut_rx_done;
    logic                  dut_tx_active;
    logic                  dut_fifo_full;
    logic                  dut_fifo_empty;
    logic                  dut_serial_out;

    logic [DATA_WIDTH-1:0] sink_data;
    logic                  sink_ready;

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
        .fifo_full(dut_fifo_full),
        .fifo_empty(dut_fifo_empty)
    );

    uart_rx #(
        .DIV_16(27)
    ) sink_uart_rx (
        .clk(clk),
        .rst_n(rst_n),
        .rx_in(dut_serial_out),
        .data_out(sink_data),
        .rx_ready(sink_ready)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    task automatic send_host_byte(input logic [7:0] value);
        begin
            @(posedge clk);
            while (host_tx_busy) begin
                @(posedge clk);
            end

            host_tx_data  <= value;
            host_tx_start <= 1'b1;
            @(posedge clk);
            host_tx_start <= 1'b0;
        end
    endtask

    task automatic send_write_cmd(input logic [3:0] addr, input logic [31:0] data);
        begin
            send_host_byte(8'h57); // 'W'
            send_host_byte({4'b0, addr});
            send_host_byte(data[7:0]);     // LSB
            send_host_byte(data[15:8]);
            send_host_byte(data[23:16]);
            send_host_byte(data[31:24]);   // MSB
        end
    endtask

    task automatic send_read_cmd(input logic [3:0] addr);
        begin
            send_host_byte(8'h52); // 'R'
            send_host_byte({4'b0, addr});
        end
    endtask

    task automatic expect_read_response(input logic [31:0] expected_value);
        logic [7:0] expected_bytes [3:0];
        logic [7:0] got_bytes [3:0];
        integer i;
        begin
            expected_bytes[0] = expected_value[7:0];
            expected_bytes[1] = expected_value[15:8];
            expected_bytes[2] = expected_value[23:16];
            expected_bytes[3] = expected_value[31:24];

            for (i = 0; i < 4; i = i + 1) begin
                @(posedge sink_ready);
                got_bytes[i] = sink_data;
                if (sink_data !== expected_bytes[i]) begin
                    $display("ERROR byte %d: expected %h, got %h", i, expected_bytes[i], sink_data);
                    $finish;
                end
            end
        end
    endtask

    initial begin
        rst_n         = 1'b0;
        host_tx_start = 1'b0;
        host_tx_data  = '0;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (5) @(posedge clk);

        $display("Test 1: WRITE 0x000000AB to reg0, READ reg0");
        send_write_cmd(4'h0, 32'h000000AB);
        repeat (7000) @(posedge clk);
        send_read_cmd(4'h0);
        expect_read_response(32'h000000AB);
        $display("Test 1 PASSED");

        repeat (3000) @(posedge clk);

        $display("Test 2: WRITE 0xDEADBEEF to reg5, READ reg5");
        send_write_cmd(4'h5, 32'hDEADBEEF);
        repeat (7000) @(posedge clk);
        send_read_cmd(4'h5);
        expect_read_response(32'hDEADBEEF);
        $display("Test 2 PASSED");

        repeat (3000) @(posedge clk);

        $display("Test 3: verify no aliasing - WRITE different values to reg1 and reg2");
        send_write_cmd(4'h1, 32'h11111111);
        repeat (7000) @(posedge clk);
        send_write_cmd(4'h2, 32'h22222222);
        repeat (7000) @(posedge clk);
        send_read_cmd(4'h1);
        expect_read_response(32'h11111111);
        send_read_cmd(4'h2);
        expect_read_response(32'h22222222);
        $display("Test 3 PASSED");

        if (!dut_fifo_empty) begin
            $display("ERROR: FIFO should be empty after all bytes drain");
            $finish;
        end

        $display("All command processor tests passed.");
        repeat (20) @(posedge clk);
        $finish;
    end

endmodule
