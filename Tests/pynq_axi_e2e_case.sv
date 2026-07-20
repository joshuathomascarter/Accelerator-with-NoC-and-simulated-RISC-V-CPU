`timescale 1ns/1ps

module pynq_axi_e2e_case #(
    parameter int RUN_TILES = 4
)(output logic passed);
    import pynq_accel_pkg::*;

    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [7:0] awaddr, araddr;
    logic awvalid, awready, wvalid, wready, bvalid, bready;
    logic [31:0] wdata, rdata;
    logic [3:0] wstrb;
    logic [1:0] bresp, rresp;
    logic arvalid, arready, rvalid, rready;
    logic [3:0] leds;

    pynq_accel_top dut (
        .s_axi_aclk(clk), .s_axi_aresetn(rst_n),
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .leds(leds)
    );

    always #5 clk = ~clk;

    task automatic axi_write(input logic [7:0] addr, input logic [31:0] data);
        begin
            @(negedge clk);
            awaddr = addr; awvalid = 1'b1;
            wdata = data; wstrb = 4'hf; wvalid = 1'b1;
            while (!(awready && wready)) @(negedge clk);
            @(negedge clk);
            awvalid = 1'b0; wvalid = 1'b0; bready = 1'b1;
            while (!bvalid) @(negedge clk);
            if (bresp != 2'b00) $fatal(1, "AXI write failed at %02h", addr);
            @(negedge clk); bready = 1'b0;
        end
    endtask

    task automatic axi_read(input logic [7:0] addr, output logic [31:0] data);
        begin
            @(negedge clk); araddr = addr; arvalid = 1'b1;
            while (!arready) @(negedge clk);
            @(negedge clk); arvalid = 1'b0; rready = 1'b1;
            while (!rvalid) @(negedge clk);
            if (rresp != 2'b00) $fatal(1, "AXI read failed at %02h", addr);
            data = rdata;
            @(negedge clk); rready = 1'b0;
        end
    endtask

    initial begin
        logic [31:0] status, result, error_word;
        int timeout;

        passed = 1'b0;
        awaddr = '0; awvalid = 0; wdata = '0; wstrb = '0; wvalid = 0; bready = 0;
        araddr = '0; arvalid = 0; rready = 0;
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (3) @(posedge clk);

        axi_write(PYNQ_REG_CTRL, 32'h2);
        axi_write(PYNQ_REG_TILE_COUNT, RUN_TILES);
        for (int i = 0; i < RUN_TILES; i++) begin
            axi_write(PYNQ_REG_WEIGHT_DATA, 32'h0403_0201 + (i * 32'h0404_0404));
        end
        for (int i = 0; i < RUN_TILES; i++) begin
            axi_write(PYNQ_REG_ACT_DATA, 32'h0000_0101 + i);
        end
        axi_write(PYNQ_REG_CTRL, 32'h5);

        timeout = 0;
        status = '0;
        while (!(status[PYNQ_STATUS_DONE_BIT]) && timeout < 2500) begin
            axi_read(PYNQ_REG_STATUS, status);
            timeout++;
        end
        if (!status[PYNQ_STATUS_DONE_BIT]) $fatal(1, "Timed out waiting for AXI accelerator completion");
        if (status[PYNQ_STATUS_BUSY_BIT]) $fatal(1, "Busy remained set after completion");

        for (int i = 0; i < RUN_TILES; i++) begin
            axi_read(PYNQ_REG_STATUS, status);
            if (!status[PYNQ_STATUS_RESULT_VALID_BIT]) $fatal(1, "Result %0d was not valid", i);
            axi_read(PYNQ_REG_RESULT, result);
            if (^result === 1'bx) $fatal(1, "Result %0d contains X", i);
        end
        axi_read(PYNQ_REG_STATUS, status);
        if (status[PYNQ_STATUS_RESULT_VALID_BIT]) $fatal(1, "Result FIFO did not drain");
        axi_read(PYNQ_REG_ERROR, error_word);
        if (error_word != 0) $fatal(1, "Accelerator error flags: %08h", error_word);

        passed = 1'b1;
        $display("PYNQ AXI end-to-end test passed for %0d tile(s)", RUN_TILES);
    end
endmodule
