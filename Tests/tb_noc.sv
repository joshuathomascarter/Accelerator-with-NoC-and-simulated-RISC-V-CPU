`timescale 1ns / 1ps

module tb_noc;
    import noc_packet_pkg::*;

    parameter int CLK_PERIOD = 20;
    localparam int TILE_COUNT = 4;

    logic clk = 1'b0;
    logic rst_n;

    logic [TILE_COUNT-1:0] local_in_valid;
    noc_flit_t local_in_flit [TILE_COUNT];
    logic [TILE_COUNT-1:0] local_in_ready;
    logic [TILE_COUNT-1:0] local_out_valid;
    noc_flit_t local_out_flit[TILE_COUNT];
    logic [TILE_COUNT-1:0] local_out_ready;
    logic [3:0]  tile_occupied;

    simple_grid_noc dut (
        .clk(clk),
        .rst_n(rst_n),
        .local_in_valid(local_in_valid),
        .local_in_flit(local_in_flit),
        .local_in_ready(local_in_ready),
        .local_out_valid(local_out_valid),
        .local_out_flit(local_out_flit),
        .local_out_ready(local_out_ready),
        .tile_occupied(tile_occupied)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    function automatic int unsigned tile_index(
        input noc_coord_t x,
        input noc_coord_t y
    );
        return (int'(y) * 2) + int'(x);
    endfunction

    function automatic logic local_out_valid_at(input int unsigned idx);
        unique case (idx)
            0: local_out_valid_at = local_out_valid[0];
            1: local_out_valid_at = local_out_valid[1];
            2: local_out_valid_at = local_out_valid[2];
            default: local_out_valid_at = local_out_valid[3];
        endcase
    endfunction

    function automatic noc_flit_t local_out_flit_at(input int unsigned idx);
        unique case (idx)
            0: local_out_flit_at = local_out_flit[0];
            1: local_out_flit_at = local_out_flit[1];
            2: local_out_flit_at = local_out_flit[2];
            default: local_out_flit_at = local_out_flit[3];
        endcase
    endfunction

    task automatic set_local_out_ready(
        input int unsigned idx,
        input logic value
    );
        begin
            unique case (idx)
                0: local_out_ready[0] = value;
                1: local_out_ready[1] = value;
                2: local_out_ready[2] = value;
                default: local_out_ready[3] = value;
            endcase
        end
    endtask

    task automatic set_local_in(
        input int unsigned idx,
        input logic value,
        input noc_packet_t pkt
    );
        begin
            unique case (idx)
                0: begin
                    local_in_valid[0]  = value;
                    local_in_flit[0] = packet_to_flit(pkt);
                end
                1: begin
                    local_in_valid[1]  = value;
                    local_in_flit[1] = packet_to_flit(pkt);
                end
                2: begin
                    local_in_valid[2]  = value;
                    local_in_flit[2] = packet_to_flit(pkt);
                end
                default: begin
                    local_in_valid[3]  = value;
                    local_in_flit[3] = packet_to_flit(pkt);
                end
            endcase
        end
    endtask

    task automatic clear_local_ports();
        begin
            for (int i = 0; i < TILE_COUNT; i++) begin
                local_in_valid[i]  = 1'b0;
                local_in_flit[i]   = '0;
                local_out_ready[i] = 1'b0;
            end
        end
    endtask

    task automatic pulse_inject(input noc_packet_t pkt);
        int unsigned src_idx;
        begin
            src_idx = tile_index(pkt.src_x, pkt.src_y);
            set_local_in(src_idx, 1'b1, pkt);
            @(posedge clk);
            #1;
            set_local_in(src_idx, 1'b0, pkt);
        end
    endtask

    task automatic wait_for_delivery(
        input int unsigned dst_idx,
        input int max_cycles
    );
        int cycle_count;
        begin
            cycle_count = 0;
            while (local_out_valid_at(dst_idx) !== 1'b1 && cycle_count < max_cycles) begin
                #(CLK_PERIOD);
                cycle_count++;
                $display("cycle %0d tile_occupied=%b local_out_valid=%b%b%b%b",
                         cycle_count,
                         tile_occupied,
                         local_out_valid[3],
                         local_out_valid[2],
                         local_out_valid[1],
                         local_out_valid[0]);
            end

            if (local_out_valid_at(dst_idx) !== 1'b1) begin
                $fatal(1, "Packet never reached the destination router");
            end
        end
    endtask

    task automatic wait_for_output_payload(
        input int unsigned dst_idx,
        input logic [31:0] expected_payload,
        input int max_cycles
    );
        int cycle_count;
        noc_packet_t observed_pkt;
        begin
            cycle_count = 0;
            observed_pkt = '0;
            while (cycle_count < max_cycles) begin
                if (local_out_valid_at(dst_idx) === 1'b1) begin
                    observed_pkt = flit_to_packet(local_out_flit_at(dst_idx));
                    if (observed_pkt.payload === expected_payload) begin
                        return;
                    end
                end

                #(CLK_PERIOD);
                cycle_count++;
                $display("payload wait cycle %0d tile_occupied=%b local_out_valid=%b%b%b%b observed=0x%08h expected=0x%08h",
                         cycle_count,
                         tile_occupied,
                         local_out_valid[3],
                         local_out_valid[2],
                         local_out_valid[1],
                         local_out_valid[0],
                         observed_pkt.payload,
                         expected_payload);
            end

            $fatal(1, "Expected payload 0x%08h never appeared at output %0d",
                   expected_payload,
                   dst_idx);
        end
    endtask

    task automatic ack_delivery(input int unsigned dst_idx);
        begin
            set_local_out_ready(dst_idx, 1'b1);
            @(posedge clk);
            #1;
            set_local_out_ready(dst_idx, 1'b0);
            @(posedge clk);
        end
    endtask

    task automatic expect_route_case(
        input noc_packet_t pkt,
        input logic [31:0] expected_payload,
        input noc_coord_t expected_dst_x,
        input noc_coord_t expected_dst_y,
        input string label
    );
        int unsigned dst_idx;
        noc_packet_t observed_pkt;
        begin
            dst_idx = tile_index(expected_dst_x, expected_dst_y);

            $display("Injecting packet %s from (%0d,%0d) to (%0d,%0d)",
                label, pkt.src_x, pkt.src_y, pkt.dst_x, pkt.dst_y);

            pulse_inject(pkt);
            wait_for_delivery(dst_idx, 10);
            observed_pkt = flit_to_packet(local_out_flit_at(dst_idx));

            $display("Delivered packet payload=0x%08h type=0x%0h src=(%0d,%0d) dst=(%0d,%0d)",
                observed_pkt.payload,
                observed_pkt.payload_type,
                observed_pkt.src_x,
                observed_pkt.src_y,
                observed_pkt.dst_x,
                observed_pkt.dst_y);

            if (observed_pkt.payload !== expected_payload) begin
                $fatal(1, "Unexpected payload: 0x%08h", observed_pkt.payload);
            end

            if (observed_pkt.dst_x !== expected_dst_x ||
                observed_pkt.dst_y !== expected_dst_y) begin
                $fatal(1, "Packet arrived at the wrong destination");
            end

            if (tile_occupied !== 4'b0000) begin
                $fatal(1, "Grid still has occupied tiles after delivery: %b", tile_occupied);
            end

            ack_delivery(dst_idx);
        end
    endtask

    task automatic source_recovery_case();
        noc_packet_t pkt_first;
        noc_packet_t pkt_next;
        begin
            $display("Injecting source recovery case");
            $fflush();

            pkt_first.src_x        = 2'd0;
            pkt_first.src_y        = 2'd0;
            pkt_first.dst_x        = 2'd1;
            pkt_first.dst_y        = 2'd1;
            pkt_first.payload_type = 4'h4;
            pkt_first.payload      = 32'h1111_2222;

            pkt_next.src_x        = 2'd0;
            pkt_next.src_y        = 2'd0;
            pkt_next.dst_x        = 2'd0;
            pkt_next.dst_y        = 2'd1;
            pkt_next.payload_type = 4'h5;
            pkt_next.payload      = 32'h3333_4444;

            $display("  step 1: injecting first packet");
            $fflush();
            pulse_inject(pkt_first);

            $display("  step 2: checking that the source router recovered after the first hop");
            $fflush();
            local_in_flit[0] = packet_to_flit(pkt_next);
            #0;
            if (local_in_ready[0]) begin
                $display("  step 2a: source is ready again after the flit advanced");
                $fflush();
            end else begin
                $fatal(1, "Expected source router to be ready once the first flit advanced");
            end

            $display("  step 3: first packet has moved beyond source; current occupancy=%b", tile_occupied);
            $fflush();

            wait_for_delivery(3, 10);
            ack_delivery(3);
        end
    endtask

    task automatic expect_parallel_nonconflicting_case();
        noc_packet_t pkt_top;
        noc_packet_t pkt_bottom;
        noc_packet_t observed_top;
        noc_packet_t observed_bottom;
        int cycle_count;
        begin
            $display("Injecting two non-conflicting packets in parallel");
            $fflush();

            // Top row: router 0 -> router 1.
            pkt_top.src_x        = 2'd0;
            pkt_top.src_y        = 2'd0;
            pkt_top.dst_x        = 2'd1;
            pkt_top.dst_y        = 2'd0;
            pkt_top.payload_type = 4'h6;
            pkt_top.payload      = 32'hAAAA_0001;

            // Bottom row: router 2 -> router 3.
            pkt_bottom.src_x        = 2'd0;
            pkt_bottom.src_y        = 2'd1;
            pkt_bottom.dst_x        = 2'd1;
            pkt_bottom.dst_y        = 2'd1;
            pkt_bottom.payload_type = 4'h7;
            pkt_bottom.payload      = 32'hBBBB_0002;

            set_local_in(0, 1'b1, pkt_top);
            set_local_in(2, 1'b1, pkt_bottom);
            @(posedge clk);
            #1;
            set_local_in(0, 1'b0, pkt_top);
            set_local_in(2, 1'b0, pkt_bottom);

            cycle_count = 0;
            while ((local_out_valid[1] !== 1'b1 || local_out_valid[3] !== 1'b1) &&
                   cycle_count < 10) begin
                #(CLK_PERIOD);
                cycle_count++;
                $display("parallel cycle %0d tile_occupied=%b local_out_valid=%b%b%b%b",
                         cycle_count,
                         tile_occupied,
                         local_out_valid[3],
                         local_out_valid[2],
                         local_out_valid[1],
                         local_out_valid[0]);
            end

            if (local_out_valid[1] !== 1'b1 || local_out_valid[3] !== 1'b1) begin
                $fatal(1, "Expected both non-conflicting packets to be delivered");
            end

            observed_top    = flit_to_packet(local_out_flit[1]);
            observed_bottom = flit_to_packet(local_out_flit[3]);

            if (observed_top.payload !== 32'hAAAA_0001 ||
                observed_top.dst_x !== 2'd1 ||
                observed_top.dst_y !== 2'd0) begin
                $fatal(1, "Top-row parallel packet was corrupted or misrouted");
            end

            if (observed_bottom.payload !== 32'hBBBB_0002 ||
                observed_bottom.dst_x !== 2'd1 ||
                observed_bottom.dst_y !== 2'd1) begin
                $fatal(1, "Bottom-row parallel packet was corrupted or misrouted");
            end

            $display("Parallel non-conflicting packets delivered together");
            $fflush();

            local_out_ready[1] = 1'b1;
            local_out_ready[3] = 1'b1;
            @(posedge clk);
            #1;
            local_out_ready[1] = 1'b0;
            local_out_ready[3] = 1'b0;
            @(posedge clk);
        end
    endtask

    task automatic expect_conflicting_next_hop_case();
        noc_packet_t pkt_from_west;
        noc_packet_t pkt_from_east;
        noc_packet_t observed_first;
        noc_packet_t observed_second;
        begin
            $display("Injecting two packets that both want router (0,1)");
            $fflush();

            // Router 0 moves south into router 2.
            pkt_from_west.src_x        = 2'd0;
            pkt_from_west.src_y        = 2'd0;
            pkt_from_west.dst_x        = 2'd0;
            pkt_from_west.dst_y        = 2'd1;
            pkt_from_west.payload_type = 4'h8;
            pkt_from_west.payload      = 32'hCCCC_0001;

            // Router 3 moves west into router 2 during that same cycle.
            pkt_from_east.src_x        = 2'd1;
            pkt_from_east.src_y        = 2'd1;
            pkt_from_east.dst_x        = 2'd0;
            pkt_from_east.dst_y        = 2'd1;
            pkt_from_east.payload_type = 4'h9;
            pkt_from_east.payload      = 32'hDDDD_0002;

            set_local_in(0, 1'b1, pkt_from_west);
            set_local_in(3, 1'b1, pkt_from_east);
            @(posedge clk);
            #1;
            set_local_in(0, 1'b0, pkt_from_west);
            set_local_in(3, 1'b0, pkt_from_east);

            wait_for_delivery(2, 10);
            observed_first = flit_to_packet(local_out_flit[2]);

            if (observed_first.payload !== 32'hCCCC_0001 ||
                observed_first.dst_x !== 2'd0 ||
                observed_first.dst_y !== 2'd1) begin
                $fatal(1, "First conflicting packet was corrupted or misrouted");
            end

            ack_delivery(2);
            wait_for_delivery(2, 10);
            observed_second = flit_to_packet(local_out_flit[2]);

            if (observed_second.payload !== 32'hDDDD_0002 ||
                observed_second.dst_x !== 2'd0 ||
                observed_second.dst_y !== 2'd1) begin
                $fatal(1, "Second conflicting packet was dropped, corrupted, or misrouted");
            end

            $display("Conflicting next-hop packets delivered one after the other");
            $fflush();

            ack_delivery(2);
        end
    endtask

    task automatic expect_response_bypasses_blocked_request_case();
        noc_packet_t request_pkt;
        noc_packet_t response_pkt;
        noc_packet_t observed_pkt;
        begin
            $display("Injecting response-class packet behind a blocked request-class output");
            $fflush();

            request_pkt.src_x        = 2'd0;
            request_pkt.src_y        = 2'd0;
            request_pkt.dst_x        = 2'd0;
            request_pkt.dst_y        = 2'd1;
            request_pkt.payload_type = NOC_PKT_WEIGHT;
            request_pkt.payload      = 32'hCAFE_1000;

            response_pkt.src_x        = 2'd1;
            response_pkt.src_y        = 2'd1;
            response_pkt.dst_x        = 2'd0;
            response_pkt.dst_y        = 2'd1;
            response_pkt.payload_type = NOC_PKT_RESULT;
            response_pkt.payload      = 32'hFACE_2000;

            pulse_inject(request_pkt);
            wait_for_output_payload(2, 32'hCAFE_1000, 10);

            // Leave the request-class output blocked, then prove the response
            // class has a separate slot and can become visible anyway.
            pulse_inject(response_pkt);
            wait_for_output_payload(2, 32'hFACE_2000, 10);
            observed_pkt = flit_to_packet(local_out_flit_at(2));

            if (observed_pkt.payload_type !== NOC_PKT_RESULT) begin
                $fatal(1, "Expected response-class packet to bypass blocked request output");
            end

            ack_delivery(2);
            wait_for_output_payload(2, 32'hCAFE_1000, 4);
            observed_pkt = flit_to_packet(local_out_flit_at(2));

            if (observed_pkt.payload_type !== NOC_PKT_WEIGHT) begin
                $fatal(1, "Blocked request-class packet was lost after response bypass");
            end

            $display("Response-class packet bypassed blocked request, and request remained intact");
            $fflush();

            ack_delivery(2);
        end
    endtask

    initial begin
        noc_packet_t pkt;

        rst_n = 1'b0;
        clear_local_ports();

        #(4*CLK_PERIOD);
        rst_n = 1'b1;
        #(2*CLK_PERIOD);

        pkt.src_x        = 2'd0;
        pkt.src_y        = 2'd0;
        pkt.dst_x        = 2'd1;
        pkt.dst_y        = 2'd1;
        pkt.payload_type  = 4'h1;
        pkt.payload       = 32'hDEADBEEF;
        expect_route_case(pkt, 32'hDEADBEEF, 2'd1, 2'd1, "(east/south path)");

        pkt.src_x        = 2'd1;
        pkt.src_y        = 2'd1;
        pkt.dst_x        = 2'd0;
        pkt.dst_y        = 2'd0;
        pkt.payload_type  = 4'h2;
        pkt.payload       = 32'hCAFEBABE;
        expect_route_case(pkt, 32'hCAFEBABE, 2'd0, 2'd0, "(west/north path)");

        source_recovery_case();
        expect_parallel_nonconflicting_case();
        expect_conflicting_next_hop_case();
        expect_response_bypasses_blocked_request_case();

        $display("NoC smoke test passed");
        $finish;
    end
endmodule
