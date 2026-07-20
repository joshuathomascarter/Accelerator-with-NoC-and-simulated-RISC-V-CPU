`timescale 1ns / 1ps

module tb_pynq_accel_axi_lite;
    import pynq_accel_pkg::*;

    localparam int CLK_PERIOD = 10;
    localparam logic [1:0] AXI_RESP_OKAY   = 2'b00;
    localparam logic [1:0] AXI_RESP_SLVERR = 2'b10;

    logic clk = 1'b0;
    logic rst_n;

    logic [PYNQ_ADDR_W-1:0] s_axi_awaddr;
    logic                   s_axi_awvalid;
    logic                   s_axi_awready;
    logic [PYNQ_REG_W-1:0]  s_axi_wdata;
    logic [3:0]             s_axi_wstrb;
    logic                   s_axi_wvalid;
    logic                   s_axi_wready;
    logic [1:0]             s_axi_bresp;
    logic                   s_axi_bvalid;
    logic                   s_axi_bready;
    logic [PYNQ_ADDR_W-1:0] s_axi_araddr;
    logic                   s_axi_arvalid;
    logic                   s_axi_arready;
    logic [PYNQ_REG_W-1:0]  s_axi_rdata;
    logic [1:0]             s_axi_rresp;
    logic                   s_axi_rvalid;
    logic                   s_axi_rready;

    logic                   accel_busy;
    logic                   accel_done;
    logic                   accel_result_valid;
    logic                   accel_overflow;
    logic [PYNQ_REG_W-1:0]  accel_result_data;
    logic [PYNQ_REG_W-1:0]  accel_error_flags;
    logic                   packet_ready;

    logic                   accel_start;
    logic                   accel_clear;
    logic                   accel_final_layer;
    logic [PYNQ_REG_W-1:0]  accel_tile_count;
    logic                   accel_weight_wr_en;
    logic [PYNQ_REG_W-1:0]  accel_weight_wr_data;
    logic                   accel_act_wr_en;
    logic [PYNQ_REG_W-1:0]  accel_act_wr_data;
    logic                   accel_result_rd_en;
    logic [3:0]             led_mirror;
    logic [7:0]             tile_select;
    logic [7:0]             packet_type;
    logic [PYNQ_REG_W-1:0]  packet_payload;
    logic                   packet_valid;
    logic [PYNQ_REG_W-1:0]  dma_src_addr;
    logic [PYNQ_REG_W-1:0]  dma_dst_addr;
    logic [PYNQ_REG_W-1:0]  dma_length;

    logic saw_start;
    logic saw_clear;
    logic saw_weight_write;
    logic saw_act_write;
    logic saw_result_read;
    logic saw_packet_valid;
    logic [PYNQ_REG_W-1:0] captured_weight_data;
    logic [PYNQ_REG_W-1:0] captured_act_data;

    pynq_accel_axi_lite u_dut (
        .clk(clk),
        .rst_n(rst_n),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready),
        .accel_busy(accel_busy),
        .accel_done(accel_done),
        .accel_result_valid(accel_result_valid),
        .accel_overflow(accel_overflow),
        .accel_result_data(accel_result_data),
        .accel_error_flags(accel_error_flags),
        .packet_ready(packet_ready),
        .accel_start(accel_start),
        .accel_clear(accel_clear),
        .accel_final_layer(accel_final_layer),
        .accel_tile_count(accel_tile_count),
        .accel_weight_wr_en(accel_weight_wr_en),
        .accel_weight_wr_data(accel_weight_wr_data),
        .accel_act_wr_en(accel_act_wr_en),
        .accel_act_wr_data(accel_act_wr_data),
        .accel_result_rd_en(accel_result_rd_en),
        .led_mirror(led_mirror),
        .tile_select(tile_select),
        .packet_type(packet_type),
        .packet_payload(packet_payload),
        .packet_valid(packet_valid),
        .dma_src_addr(dma_src_addr),
        .dma_dst_addr(dma_dst_addr),
        .dma_length(dma_length)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            saw_start          <= 1'b0;
            saw_clear          <= 1'b0;
            saw_weight_write   <= 1'b0;
            saw_act_write      <= 1'b0;
            saw_result_read    <= 1'b0;
            saw_packet_valid   <= 1'b0;
            captured_weight_data <= '0;
            captured_act_data    <= '0;
        end else begin
            if (accel_start) begin
                saw_start <= 1'b1;
            end

            if (accel_clear) begin
                saw_clear <= 1'b1;
            end

            if (accel_weight_wr_en) begin
                saw_weight_write    <= 1'b1;
                captured_weight_data <= accel_weight_wr_data;
            end

            if (accel_act_wr_en) begin
                saw_act_write    <= 1'b1;
                captured_act_data <= accel_act_wr_data;
            end

            if (accel_result_rd_en) begin
                saw_result_read <= 1'b1;
            end

            if (packet_valid) begin
                saw_packet_valid <= 1'b1;
            end
        end
    end

    task automatic axi_write(
        input logic [PYNQ_ADDR_W-1:0] addr,
        input logic [PYNQ_REG_W-1:0] data,
        input logic [3:0] strb,
        input logic [1:0] expected_resp
    );
        begin
            @(negedge clk);
            s_axi_awaddr  = addr;
            s_axi_awvalid = 1'b1;
            s_axi_wdata   = data;
            s_axi_wstrb   = strb;
            s_axi_wvalid  = 1'b1;

            do begin
                @(posedge clk);
            end while (!(s_axi_awready && s_axi_awvalid && s_axi_wready && s_axi_wvalid));

            @(negedge clk);
            s_axi_awvalid = 1'b0;
            s_axi_wvalid  = 1'b0;
            s_axi_awaddr  = '0;
            s_axi_wdata   = '0;
            s_axi_wstrb   = '0;
            s_axi_bready  = 1'b1;

            do begin
                @(posedge clk);
            end while (!s_axi_bvalid);

            if (s_axi_bresp !== expected_resp) begin
                $fatal(1, "AXI write 0x%02h response mismatch: got %b expected %b",
                       addr, s_axi_bresp, expected_resp);
            end

            @(negedge clk);
            s_axi_bready = 1'b0;
        end
    endtask

    task automatic axi_read(
        input  logic [PYNQ_ADDR_W-1:0] addr,
        output logic [PYNQ_REG_W-1:0] data,
        input  logic [1:0] expected_resp
    );
        begin
            @(negedge clk);
            s_axi_araddr  = addr;
            s_axi_arvalid = 1'b1;

            do begin
                @(posedge clk);
            end while (!(s_axi_arready && s_axi_arvalid));

            @(negedge clk);
            s_axi_arvalid = 1'b0;
            s_axi_araddr  = '0;
            s_axi_rready  = 1'b1;

            do begin
                @(posedge clk);
            end while (!s_axi_rvalid);

            data = s_axi_rdata;
            if (s_axi_rresp !== expected_resp) begin
                $fatal(1, "AXI read 0x%02h response mismatch: got %b expected %b",
                       addr, s_axi_rresp, expected_resp);
            end

            @(negedge clk);
            s_axi_rready = 1'b0;
        end
    endtask

    task automatic expect_word(
        input string label_name,
        input logic [PYNQ_REG_W-1:0] got,
        input logic [PYNQ_REG_W-1:0] expected
    );
        begin
            if (got !== expected) begin
                $fatal(1, "%s mismatch: got 0x%08h expected 0x%08h",
                       label_name, got, expected);
            end
        end
    endtask

    initial begin
        logic [PYNQ_REG_W-1:0] read_word;

        rst_n = 1'b0;
        s_axi_awaddr  = '0;
        s_axi_awvalid = 1'b0;
        s_axi_wdata   = '0;
        s_axi_wstrb   = '0;
        s_axi_wvalid  = 1'b0;
        s_axi_bready  = 1'b0;
        s_axi_araddr  = '0;
        s_axi_arvalid = 1'b0;
        s_axi_rready  = 1'b0;

        accel_busy         = 1'b0;
        accel_done         = 1'b0;
        accel_result_valid = 1'b0;
        accel_overflow     = 1'b0;
        accel_result_data  = 32'h1234_5678;
        accel_error_flags  = 32'h0000_00A5;
        packet_ready       = 1'b0;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        axi_write(PYNQ_REG_TILE_COUNT, 32'd4, 4'hF, AXI_RESP_OKAY);
        axi_read(PYNQ_REG_TILE_COUNT, read_word, AXI_RESP_OKAY);
        expect_word("tile_count", read_word, 32'd4);

        axi_write(PYNQ_REG_CTRL, 32'h0000_0005, 4'hF, AXI_RESP_OKAY);
        repeat (2) @(posedge clk);
        if (!saw_start || saw_clear || !accel_final_layer) begin
            $fatal(1, "CTRL write did not create expected start/final_layer behavior");
        end
        axi_read(PYNQ_REG_CTRL, read_word, AXI_RESP_OKAY);
        expect_word("ctrl_readback", read_word, 32'h0000_0004);

        axi_write(PYNQ_REG_WEIGHT_DATA, 32'h0403_0201, 4'hF, AXI_RESP_OKAY);
        repeat (2) @(posedge clk);
        if (!saw_weight_write) begin
            $fatal(1, "WEIGHT_DATA write did not pulse accel_weight_wr_en");
        end
        expect_word("weight_data", captured_weight_data, 32'h0403_0201);

        axi_write(PYNQ_REG_ACT_DATA, 32'h0807_0605, 4'hF, AXI_RESP_OKAY);
        repeat (2) @(posedge clk);
        if (!saw_act_write) begin
            $fatal(1, "ACT_DATA write did not pulse accel_act_wr_en");
        end
        expect_word("act_data", captured_act_data, 32'h0807_0605);

        accel_busy         = 1'b1;
        accel_done         = 1'b1;
        accel_result_valid = 1'b1;
        accel_overflow     = 1'b1;
        axi_read(PYNQ_REG_STATUS, read_word, AXI_RESP_OKAY);
        expect_word("status", read_word, 32'h0000_000F);

        axi_read(PYNQ_REG_RESULT, read_word, AXI_RESP_OKAY);
        expect_word("result", read_word, 32'h1234_5678);
        repeat (2) @(posedge clk);
        if (!saw_result_read) begin
            $fatal(1, "RESULT read did not pulse accel_result_rd_en");
        end

        axi_read(PYNQ_REG_ERROR, read_word, AXI_RESP_OKAY);
        expect_word("error_flags", read_word, 32'h0000_00A5);

        axi_write(PYNQ_REG_LED_MIRROR, 32'h0000_000B, 4'hF, AXI_RESP_OKAY);
        if (led_mirror !== 4'hB) begin
            $fatal(1, "LED mirror mismatch: got 0x%h", led_mirror);
        end

        axi_write(PYNQ_REG_TILE_SELECT, 32'h0000_0003, 4'hF, AXI_RESP_OKAY);
        axi_write(PYNQ_REG_PACKET_TYPE, 32'h0000_0012, 4'hF, AXI_RESP_OKAY);
        axi_write(PYNQ_REG_PACKET_PAYLOAD, 32'hCAFE_BABE, 4'hF, AXI_RESP_OKAY);
        axi_write(PYNQ_REG_PACKET_VALID, 32'h0000_0001, 4'hF, AXI_RESP_OKAY);
        repeat (2) @(posedge clk);

        if ((tile_select !== 8'h03) || (packet_type !== 8'h12) ||
            (packet_payload !== 32'hCAFE_BABE) || !saw_packet_valid) begin
            $fatal(1, "Packet debug registers did not update correctly");
        end

        packet_ready = 1'b1;
        axi_read(PYNQ_REG_PACKET_READY, read_word, AXI_RESP_OKAY);
        expect_word("packet_ready", read_word, 32'h0000_0001);

        axi_write(PYNQ_REG_DMA_SRC_ADDR, 32'h1000_0000, 4'hF, AXI_RESP_OKAY);
        axi_write(PYNQ_REG_DMA_DST_ADDR, 32'h2000_0000, 4'hF, AXI_RESP_OKAY);
        axi_write(PYNQ_REG_DMA_LENGTH, 32'h0000_0040, 4'hF, AXI_RESP_OKAY);
        axi_read(PYNQ_REG_DMA_SRC_ADDR, read_word, AXI_RESP_OKAY);
        expect_word("dma_src_addr", read_word, 32'h1000_0000);
        axi_read(PYNQ_REG_DMA_DST_ADDR, read_word, AXI_RESP_OKAY);
        expect_word("dma_dst_addr", read_word, 32'h2000_0000);
        axi_read(PYNQ_REG_DMA_LENGTH, read_word, AXI_RESP_OKAY);
        expect_word("dma_length", read_word, 32'h0000_0040);

        axi_write(8'h02, 32'hDEAD_BEEF, 4'hF, AXI_RESP_SLVERR);
        axi_read(8'h44, read_word, AXI_RESP_SLVERR);

        $display("PYNQ AXI-Lite register shell test passed");
        $finish;
    end

endmodule
