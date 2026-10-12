`timescale 1ns / 1ps

module tb_tile;
    import noc_packet_pkg::*;

    parameter int TILE_X       = 1;
    parameter int TILE_Y       = 1;
    parameter int M            = 2;
    parameter int N            = 2;
    parameter int DATA_WIDTH   = 8;
    parameter int RESULT_WIDTH = 32;
    parameter int CLK_PERIOD   = 20;
    localparam noc_coord_t TB_TILE_X = noc_coord_t'(TILE_X);
    localparam noc_coord_t TB_TILE_Y = noc_coord_t'(TILE_Y);

    logic clk = 1'b0;
    logic rst_n;

    logic start;
    logic clear;
    logic compute_en;
    logic reduce_en;
    logic [DATA_WIDTH-1:0] activation_data;

    logic inject_valid;
    noc_packet_t inject_packet;
    logic inject_ready;

    logic deliver_valid;
    noc_packet_t deliver_packet;
    logic deliver_ready;

    logic done;
    logic [M*N-1:0] overflow_hazard;
    logic [M*N*RESULT_WIDTH-1:0] pe_results;

    tile #(
        .TILE_X(TILE_X),
        .TILE_Y(TILE_Y),
        .M(M),
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .clear(clear),
        .compute_en(compute_en),
        .reduce_en(reduce_en),
        .activation_data(activation_data),
        .inject_valid(inject_valid),
        .inject_packet(inject_packet),
        .inject_ready(inject_ready),
        .deliver_valid(deliver_valid),
        .deliver_packet(deliver_packet),
        .deliver_ready(deliver_ready),
        .done(done),
        .overflow_hazard(overflow_hazard),
        .pe_results(pe_results)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    task automatic pulse_clear();
        begin
            @(negedge clk);
            clear = 1'b1;
            @(posedge clk);
            @(negedge clk);
            clear = 1'b0;
        end
    endtask

    task automatic pulse_reduce(output logic saw_done);
        begin
            saw_done = 1'b0;
            @(negedge clk);
            reduce_en = 1'b1;
            @(posedge clk);
            #1;
            saw_done = done;
            @(negedge clk);
            reduce_en = 1'b0;
        end
    endtask

    task automatic send_local_packet(input noc_packet_t pkt);
        begin
            @(negedge clk);
            inject_packet = pkt;
            inject_valid   = 1'b1;
            @(posedge clk);
            @(negedge clk);
            inject_valid   = 1'b0;
        end
    endtask

    initial begin
        noc_packet_t pkt;
        logic [RESULT_WIDTH-1:0] expected_payload;
        logic saw_done;
        logic saw_response;
        int response_wait;

        rst_n         = 1'b0;
        start         = 1'b0;
        clear         = 1'b0;
        compute_en    = 1'b0;
        reduce_en     = 1'b0;
        activation_data = '0;
        inject_valid  = 1'b0;
        inject_packet = '0;
        deliver_ready  = 1'b1;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        $display("Clearing tile");
        pulse_clear();
        @(posedge clk);

        pkt.src_x        = TB_TILE_X;
        pkt.src_y        = TB_TILE_Y;
        pkt.dst_x        = TB_TILE_X;
        pkt.dst_y        = TB_TILE_Y;
        pkt.payload_type  = 4'h1;
        pkt.payload       = 32'h0000_0000;

        $display("Injecting local packet into tile (%0d,%0d)", TILE_X, TILE_Y);
        inject_packet = pkt;
        #1;
        $display("pkt src=(%0d,%0d) dst=(%0d,%0d) inject_ready=%b",
            inject_packet.src_x, inject_packet.src_y,
            inject_packet.dst_x, inject_packet.dst_y,
            inject_ready);
        if (!inject_ready) begin
            $fatal(1, "Tile did not advertise ready for a packet addressed to itself");
        end
        send_local_packet(pkt);

        pkt.payload_type  = NOC_PKT_WEIGHT;
        pkt.payload       = 32'h0403_0201;
        $display("Loading weights 1,2,3,4 through NoC packet");
        send_local_packet(pkt);
        repeat (3) @(posedge clk);

        pkt.payload_type  = NOC_PKT_COMPUTE;
        pkt.payload       = 32'h05FE_0302;   // lanes 2, 3, -2, 5
        $display("Running compute with packed activation NoC packet");
        send_local_packet(pkt);
        repeat (5) @(posedge clk);

        $display("Reducing tile results");
        deliver_ready = 1'b0;
        pulse_reduce(saw_done);
        if (!saw_done) begin
            $fatal(1, "Tile did not assert done during reduce");
        end

        saw_response = 1'b0;
        response_wait = 0;
        while (!saw_response && response_wait < 10) begin
            @(posedge clk);
            #1;
            if (deliver_valid) begin
                saw_response = 1'b1;
            end
            response_wait++;
        end

        // 1*2 + 2*3 + 3*(-2) + 4*5 = 22
        expected_payload = 32'd22;

        $display("done=%b", done);
        $display("overflow_hazard=%b", overflow_hazard);
        $display("pe_results[0]=%0d", pe_results[0*RESULT_WIDTH +: RESULT_WIDTH]);
        $display("pe_results[1]=%0d", pe_results[1*RESULT_WIDTH +: RESULT_WIDTH]);
        $display("pe_results[2]=%0d", pe_results[2*RESULT_WIDTH +: RESULT_WIDTH]);
        $display("pe_results[3]=%0d", pe_results[3*RESULT_WIDTH +: RESULT_WIDTH]);
        $display("internal last_src_valid_q=%b tx_valid_q=%b tx_packet.payload=%0d dst=(%0d,%0d)",
            dut.last_src_valid_q,
            dut.tx_valid_q,
            dut.tx_packet_q.payload,
            dut.tx_packet_q.dst_x,
            dut.tx_packet_q.dst_y);
        $display("internal done_seen_q=%b", dut.done_seen_q);

        if (!saw_response) begin
            $fatal(1, "Tile did not present a response packet");
        end

        if (deliver_packet.src_x !== TB_TILE_X || deliver_packet.src_y !== TB_TILE_Y) begin
            $fatal(1, "Response packet has wrong source coordinates");
        end

        if (deliver_packet.dst_x !== TB_TILE_X || deliver_packet.dst_y !== TB_TILE_Y) begin
            $fatal(1, "Response packet has wrong destination coordinates");
        end

        if (deliver_packet.payload_type !== 4'hE) begin
            $fatal(1, "Response packet has wrong payload type");
        end

        if (deliver_packet.payload !== expected_payload) begin
            $fatal(1, "Response payload 0x%08h did not match expected dot product 0x%08h",
                deliver_packet.payload, expected_payload);
        end

        deliver_ready = 1'b1;
        @(posedge clk);

        $display("Tile test passed");
        $finish;
    end

endmodule
