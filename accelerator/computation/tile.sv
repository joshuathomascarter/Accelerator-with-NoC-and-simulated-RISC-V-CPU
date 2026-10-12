module tile #(
    parameter int TILE_X      = 0,
    parameter int TILE_Y      = 0,
    parameter int M           = 2,
    parameter int N           = 2,
    parameter int DATA_WIDTH  = 8,
    parameter int RESULT_WIDTH = 32
)(
    input  logic                     clk,
    input  logic                     rst_n,

    // Direct control path. These are still useful for the current scheduler
    // flow and act as a fallback even after NoC hookup.
    input  logic                     start,
    input  logic                     clear,
    input  logic                     compute_en,
    input  logic                     reduce_en,
    input  logic [DATA_WIDTH-1:0]    activation_data,

    // NoC input from the mesh into this tile.
    input  logic                     inject_valid,
    input  noc_packet_pkg::noc_packet_t inject_packet,
    output logic                     inject_ready,

    // NoC output from this tile back into the mesh.
    output logic                     deliver_valid,
    output noc_packet_pkg::noc_packet_t deliver_packet,
    input  logic                     deliver_ready,

    // Tile status / results.
    output logic                     done,
    output logic [M*N-1:0]           overflow_hazard,
    output logic [M*N*RESULT_WIDTH-1:0] pe_results
);
    import noc_packet_pkg::*;

    localparam noc_coord_t TILE_X_C = noc_coord_t'(TILE_X);
    localparam noc_coord_t TILE_Y_C = noc_coord_t'(TILE_Y);
    localparam logic [1:0] LAST_ACT_LANE    = 2'(M*N-1);
    localparam int COL_IDX_W = (N <= 1) ? 1 : $clog2(N);

    logic                    start_req;
    logic                    clear_req;
    logic [M*N-1:0]          compute_en_req;
    logic                    reduce_en_req;
    logic                    reduce_pending_q;
    logic [DATA_WIDTH-1:0]    activation_data_req;

    logic                    inject_fire;
    logic                    inject_packet_is_local;
    logic                    last_src_valid_q;
    noc_coord_t              last_src_x_q;
    noc_coord_t              last_src_y_q;
    logic                    done_seen_q;

    logic                    tx_valid_q;
    noc_packet_t             tx_packet_q;
    logic                    tx_done_pending_q;
    logic                    unpack_weight_active_q;
    logic                    unpack_compute_active_q;
    logic [1:0]              weight_lane_q;
    logic [1:0]              activation_lane_q;
    logic [COL_IDX_W-1:0]    weight_preload_col_q;
    logic [N-1:0]            weight_col_load_req;
    logic [M*DATA_WIDTH-1:0] row_weight_data_req;
    logic                    scratch_weight_we;
    logic                    scratch_activation_we;
    logic                    scratch_result_we;
    logic [DATA_WIDTH-1:0]   scratch_weight_rd_data;
    logic [M*DATA_WIDTH-1:0] scratch_weight_col_rd_data;
    logic [DATA_WIDTH-1:0]   scratch_activation_rd_data;
    logic [RESULT_WIDTH-1:0] scratch_result_rd_data;
    logic                    scratch_weights_valid;
    logic                    scratch_activations_valid;
    logic                    scratch_result_valid;

    logic [RESULT_WIDTH-1:0]  result_word;
    logic [M*N-1:0]          overflow_hazard_i;
    logic [M*N*RESULT_WIDTH-1:0] pe_results_i;
    logic                    done_i;


    assign inject_packet_is_local = is_local_dest(TILE_X_C, TILE_Y_C, inject_packet);
    assign inject_ready = 1'b1;
    assign inject_fire  = inject_valid && inject_packet_is_local;

    // The tile accepts one packet at a time and only turns it into control
    // if the packet is addressed to this tile.
    always_comb begin
        int loaded_cols;

        start_req         = start;
        clear_req         = clear;
        compute_en_req    = {(M*N){compute_en}};
        reduce_en_req     = reduce_en || (reduce_pending_q && !unpack_compute_active_q);
        activation_data_req = activation_data;
        weight_col_load_req = '0;
        row_weight_data_req = '0;
        loaded_cols = 0;

        if (inject_fire) begin
            unique case (inject_packet.payload_type)
                NOC_PKT_START: begin
                    start_req = 1'b1;
                end
                NOC_PKT_CLEAR: begin
                    clear_req = 1'b1;
                end
                NOC_PKT_WEIGHT: begin
                    // The packed payload is replayed by the tile over the next
                    // cycles so the scheduler only sends one weight packet.
                end
                NOC_PKT_COMPUTE: begin
                    // The packed payload is replayed locally as compute pulses.
                end
                NOC_PKT_REDUCE: begin
                    // Reduce waits until every activation lane has been
                    // replayed; reduce_pending_q holds it until then.
                    if (!unpack_compute_active_q) begin
                        reduce_en_req = 1'b1;
                    end
                end

                default: begin
                    // Leave the direct control path alone for unknown packets.
                end
            endcase
        end

        if (unpack_weight_active_q) begin
            loaded_cols = N - 1 - int'(weight_preload_col_q);
            row_weight_data_req = scratch_weight_col_rd_data;
            for (int col = 0; col < N; col++) begin
                weight_col_load_req[col] = (col <= loaded_cols);
            end
        end

        // Replay activation lane i into PE i only, so the tile accumulates
        // sum_i(weight_i * activation_i): a 4-lane INT8 dot product.
        if (unpack_compute_active_q) begin
            compute_en_req = '0;
            compute_en_req[activation_lane_q] = 1'b1;
            activation_data_req = scratch_activation_rd_data;
        end
    end

    // Reduce: sum the PE accumulators into one signed 32-bit result word.
    always_comb begin
        result_word = '0;
        for (int i = 0; i < M*N; i++) begin
            result_word = result_word + pe_results_i[i*RESULT_WIDTH +: RESULT_WIDTH];
        end
    end

    // Outbound response packet. This is a tiny status/result return path so the
    // tile can hand something back to the mesh after a compute completes.
    always_comb begin
        deliver_valid  = tx_valid_q;
        deliver_packet = tx_packet_q;
    end

    systolic_array #(
        .M(M),
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) u_systolic_array (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_req),
        .clear(clear_req),
        .row_weight_data(row_weight_data_req),
        .weight_col_load(weight_col_load_req),
        .compute_en(compute_en_req),
        .reduce_en(reduce_en_req),
        .activation_data(activation_data_req),
        .done(done_i),
        .overflow_hazard(overflow_hazard_i),
        .pe_results(pe_results_i)
    );

    assign scratch_weight_we     = inject_fire && (inject_packet.payload_type == NOC_PKT_WEIGHT);
    assign scratch_activation_we = inject_fire && (inject_packet.payload_type == NOC_PKT_COMPUTE);
    assign scratch_result_we     = done_seen_q && last_src_valid_q && !tx_valid_q;

    tile_scratchpad #(
        .M(M),
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH),
        .PAYLOAD_W(NOC_PAYLOAD_W)
    ) u_tile_scratchpad (
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear_req),
        .weight_payload_we(scratch_weight_we),
        .weight_payload(inject_packet.payload),
        .activation_payload_we(scratch_activation_we),
        .activation_payload(inject_packet.payload),
        .result_we(scratch_result_we),
        .result_data(result_word),
        .weight_rd_idx(weight_lane_q[$clog2(M*N)-1:0]),
        .weight_rd_data(scratch_weight_rd_data),
        .weight_rd_col_idx(weight_preload_col_q),
        .weight_col_rd_data(scratch_weight_col_rd_data),
        .activation_rd_idx(activation_lane_q[$clog2(M*N)-1:0]),
        .activation_rd_data(scratch_activation_rd_data),
        .result_rd_data(scratch_result_rd_data),
        .weights_valid(scratch_weights_valid),
        .activations_valid(scratch_activations_valid),
        .result_valid(scratch_result_valid)
    );

    assign done             = done_i;
    assign overflow_hazard   = overflow_hazard_i;
    assign pe_results        = pe_results_i;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_valid_q       <= 1'b0;
            tx_packet_q      <= '0;
            tx_done_pending_q <= 1'b0;
            last_src_valid_q  <= 1'b0;
            last_src_x_q      <= '0;
            last_src_y_q      <= '0;
            done_seen_q      <= 1'b0;
            unpack_weight_active_q <= 1'b0;
            unpack_compute_active_q <= 1'b0;
            weight_lane_q <= '0;
            activation_lane_q <= '0;
            weight_preload_col_q <= '0;
            reduce_pending_q <= 1'b0;
        end else begin
            if (inject_fire && inject_packet.payload_type == NOC_PKT_REDUCE &&
                unpack_compute_active_q) begin
                reduce_pending_q <= 1'b1;
            end else if (reduce_pending_q && !unpack_compute_active_q) begin
                reduce_pending_q <= 1'b0;
            end

            if (inject_fire) begin
                last_src_valid_q <= 1'b1;
                last_src_x_q     <= inject_packet.src_x;
                last_src_y_q     <= inject_packet.src_y;

                if (inject_packet.payload_type == NOC_PKT_WEIGHT) begin
                    weight_lane_q <= '0;
                    weight_preload_col_q <= COL_IDX_W'(N-1);
                    unpack_weight_active_q <= 1'b1;
                end

                if (inject_packet.payload_type == NOC_PKT_COMPUTE) begin
                    activation_lane_q <= '0;
                    unpack_compute_active_q <= 1'b1;
                end
            end

            if (unpack_weight_active_q) begin
                if (weight_preload_col_q == '0) begin
                    unpack_weight_active_q <= 1'b0;
                end else begin
                    weight_preload_col_q <= weight_preload_col_q - 1'b1;
                end
            end

            if (unpack_compute_active_q) begin
                if (activation_lane_q == LAST_ACT_LANE) begin
                    unpack_compute_active_q <= 1'b0;
                end else begin
                    activation_lane_q <= activation_lane_q + 1'b1;
                end
            end

            // Capture the one-cycle done pulse from the systolic array so we
            // can build the response packet on the next cycle.
            done_seen_q <= done_i;

            if (tx_valid_q && deliver_ready) begin
                if (tx_done_pending_q && tx_packet_q.payload_type == NOC_PKT_RESULT) begin
                    tx_valid_q           <= 1'b1;
                    tx_done_pending_q    <= 1'b0;
                    tx_packet_q.src_x    <= TILE_X_C;
                    tx_packet_q.src_y    <= TILE_Y_C;
                    tx_packet_q.dst_x    <= last_src_x_q;
                    tx_packet_q.dst_y    <= last_src_y_q;
                    tx_packet_q.payload_type <= NOC_PKT_DONE;
                    tx_packet_q.payload  <= {{(NOC_PAYLOAD_W-(M*N)){1'b0}}, overflow_hazard_i};
                end else begin
                    tx_valid_q <= 1'b0;
                end
            end

            if (done_seen_q && last_src_valid_q && !tx_valid_q) begin
                tx_valid_q           <= 1'b1;
                tx_done_pending_q    <= 1'b1;
                tx_packet_q.src_x    <= TILE_X_C;
                tx_packet_q.src_y    <= TILE_Y_C;
                tx_packet_q.dst_x    <= last_src_x_q;
                tx_packet_q.dst_y    <= last_src_y_q;
                tx_packet_q.payload_type <= NOC_PKT_RESULT;
                tx_packet_q.payload  <= result_word;
            end
        end
    end

endmodule
