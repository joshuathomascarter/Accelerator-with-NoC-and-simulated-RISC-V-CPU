`timescale 1ns / 1ps

module tb_chip_end_to_end;
    import noc_packet_pkg::*;

    localparam int GRID_W       = 2;
    localparam int GRID_H       = 2;
    localparam int TILE_COUNT   = GRID_W * GRID_H;
    localparam int M            = 2;
    localparam int N            = 2;
    localparam int ADDR_WIDTH   = 8;
    localparam int DATA_WIDTH   = 8;
    localparam int RESULT_WIDTH = 32;
    localparam int CLK_PERIOD   = 20;

    logic clk = 1'b0;
    logic rst_n;

    logic [31:0]              num_tiles;
    logic                     final_layer;
    logic                     act_last;
    logic                     weight_last;
    logic                     weight_full;
    logic                     activation_full;
    logic                     loopback_done;
    logic [RESULT_WIDTH-1:0]  weight_rd_data;
    logic [RESULT_WIDTH-1:0]  act_rd_data;
    logic [ADDR_WIDTH-1:0]    weight_rd_addr;
    logic [ADDR_WIDTH-1:0]    act_rd_addr;
    logic                     weight_rd_en;
    logic                     act_rd_en;
    logic                     weight_bank_sel;
    logic                     act_bank_sel;
    logic                     loopback_start;
    logic [31:0]              loopback_words;
    logic                     output_valid;

    logic                     start;
    logic                     clear;
    logic                     compute_en;
    logic                     reduce_en;
    logic [DATA_WIDTH-1:0]    activation_data;

    logic [TILE_COUNT-1:0]    done;
    logic [TILE_COUNT-1:0]    overflow_hazard;
    logic [TILE_COUNT-1:0]    tile_result_valid;
    noc_packet_t              tile_result_packet [TILE_COUNT];
    logic                     result_wr_en;
    logic [ADDR_WIDTH-1:0]    result_wr_addr;
    logic [RESULT_WIDTH-1:0]  result_wr_data;
    logic [TILE_COUNT-1:0]    tile_occupied;

    int unsigned              result_count;
    logic [RESULT_WIDTH-1:0]  captured_results [TILE_COUNT];
    logic [ADDR_WIDTH-1:0]    captured_addrs [TILE_COUNT];

    task automatic dump_timeout_diagnostics();
        begin
            $display("Timeout diagnostics:");
            $display("  scheduler state=%0d tile_cnt=%0d amount_of_tiles=%0d result_count_q=%0d",
                     dut.u_scheduler.state,
                     dut.u_scheduler.tile_cnt,
                     dut.u_scheduler.amount_of_tiles,
                     dut.u_scheduler.result_count_q);
            $display("  cmd_valid=%b cmd_ready=%b status_valid=%b status_ready=%b",
                     dut.sched_cmd_valid,
                     dut.sched_cmd_ready,
                     dut.sched_status_valid,
                     dut.sched_status_ready);
            $display("  router0 local in valid/ready=%b/%b out valid/ready=%b/%b occupied=%b",
                     dut.noc_local_in_valid[0],
                     dut.noc_local_in_ready[0],
                     dut.noc_local_out_valid[0],
                     dut.noc_local_out_ready[0],
                     tile_occupied);
            $display("  tile done=%b result_valid=%b result_count=%0d",
                     done,
                     tile_result_valid,
                     result_count);
            $display("  tile3 internals: last_src_valid=%b done_seen=%b tx_valid=%b tx_pending_done=%b unpack_w=%b unpack_c=%b",
                     dut.gen_tiles[3].u_tile.last_src_valid_q,
                     dut.gen_tiles[3].u_tile.done_seen_q,
                     dut.gen_tiles[3].u_tile.tx_valid_q,
                     dut.gen_tiles[3].u_tile.tx_done_pending_q,
                     dut.gen_tiles[3].u_tile.unpack_weight_active_q,
                     dut.gen_tiles[3].u_tile.unpack_compute_active_q);
        end
    endtask

    chip_top #(
        .GRID_W(GRID_W),
        .GRID_H(GRID_H),
        .M(M),
        .N(N),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .num_tiles(num_tiles),
        .final_layer(final_layer),
        .act_last(act_last),
        .weight_last(weight_last),
        .weight_full(weight_full),
        .activation_full(activation_full),
        .loopback_done(loopback_done),
        .weight_rd_data(weight_rd_data),
        .act_rd_data(act_rd_data),
        .weight_rd_addr(weight_rd_addr),
        .act_rd_addr(act_rd_addr),
        .weight_rd_en(weight_rd_en),
        .act_rd_en(act_rd_en),
        .weight_bank_sel(weight_bank_sel),
        .act_bank_sel(act_bank_sel),
        .loopback_start(loopback_start),
        .loopback_words(loopback_words),
        .output_valid(output_valid),
        .start(start),
        .clear(clear),
        .compute_en(compute_en),
        .reduce_en(reduce_en),
        .activation_data(activation_data),
        .done(done),
        .overflow_hazard(overflow_hazard),
        .tile_result_valid(tile_result_valid),
        .tile_result_packet(tile_result_packet),
        .result_wr_en(result_wr_en),
        .result_wr_addr(result_wr_addr),
        .result_wr_data(result_wr_data),
        .tile_occupied(tile_occupied)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    function automatic logic [RESULT_WIDTH-1:0] weight_word_for(
        input logic [ADDR_WIDTH-1:0] addr
    );
        unique case (addr[1:0])
            2'd0: weight_word_for = 32'h0403_0201;
            2'd1: weight_word_for = 32'h0807_0605;
            2'd2: weight_word_for = 32'h0c0b_0a09;
            default: weight_word_for = 32'h100f_0e0d;
        endcase
    endfunction

    function automatic logic [RESULT_WIDTH-1:0] act_word_for(
        input logic [ADDR_WIDTH-1:0] addr
    );
        unique case (addr[1:0])
            2'd0: act_word_for = 32'h0000_0101;
            2'd1: act_word_for = 32'h0000_0201;
            2'd2: act_word_for = 32'h0000_0102;
            default: act_word_for = 32'h0000_0202;
        endcase
    endfunction

    // The chip-top boundary sees SRAM read data as an input. For this first
    // grid proof, model that memory as immediately address-visible so failures
    // point at packet movement/control rather than SRAM latency.
    always_comb begin
        weight_rd_data = weight_word_for(weight_rd_addr);
        act_rd_data    = act_word_for(act_rd_addr);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_count = 0;
            for (int i = 0; i < TILE_COUNT; i++) begin
                captured_results[i] = '0;
                captured_addrs[i]   = '0;
            end
        end else begin
            #1;
            if (result_wr_en) begin
            if (result_count >= TILE_COUNT) begin
                $fatal(1, "Saw more result writes than expected");
            end

                captured_results[result_count] = result_wr_data;
                captured_addrs[result_count]   = result_wr_addr;

                $display("Captured result %0d: addr=%0d data=%0d",
                         result_count, result_wr_addr, $signed(result_wr_data));

                result_count = result_count + 1;
            end
        end
    end

    initial begin
        int timeout_cycles;

        rst_n           = 1'b0;
        num_tiles       = TILE_COUNT;
        final_layer     = 1'b1;
        act_last        = 1'b0;
        weight_last     = 1'b0;
        weight_full     = 1'b0;
        activation_full = 1'b0;
        loopback_done   = 1'b0;

        start           = 1'b0;
        clear           = 1'b0;
        compute_en      = 1'b0;
        reduce_en       = 1'b0;
        activation_data = '0;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        $display("Starting chip end-to-end final-layer grid test");
        weight_full     = 1'b1;
        activation_full = 1'b1;

        timeout_cycles = 0;
        while (!output_valid && timeout_cycles < 2000) begin
            @(posedge clk);
            timeout_cycles++;
        end

        if (!output_valid) begin
            dump_timeout_diagnostics();
            $fatal(1, "Timed out waiting for chip_top output_valid");
        end

        @(posedge clk);

        if (result_count !== TILE_COUNT) begin
            $fatal(1, "Expected %0d result writes, saw %0d",
                   TILE_COUNT, result_count);
        end

        for (int i = 0; i < TILE_COUNT; i++) begin
            if (captured_addrs[i] !== ADDR_WIDTH'(i)) begin
                $fatal(1, "Result %0d wrote addr %0d instead of %0d",
                       i, captured_addrs[i], i);
            end

            if (^captured_results[i] === 1'bx) begin
                $fatal(1, "Result %0d contains X data", i);
            end
        end

        if (loopback_start) begin
            $fatal(1, "Final-layer run should not request loopback");
        end

        $display("Chip end-to-end test passed with %0d result writes",
                 result_count);
        $finish;
    end

endmodule
