module chip_top #(
    parameter int GRID_W       = 2,
    parameter int GRID_H       = 2,
    parameter int M            = 2,
    parameter int N            = 2,
    parameter int ADDR_WIDTH   = 8,
    parameter int DATA_WIDTH   = 8,
    parameter int RESULT_WIDTH = 32
)(
    input  logic clk,
    input  logic rst_n,

    // Scheduler configuration and memory-side status.
    input  logic [31:0]              num_tiles,
    input  logic                     final_layer,
    input  logic                     act_last,
    input  logic                     weight_last,
    input  logic                     weight_full,
    input  logic                     activation_full,
    input  logic                     loopback_done,
    input  logic [RESULT_WIDTH-1:0]  weight_rd_data,
    input  logic [RESULT_WIDTH-1:0]  act_rd_data,
    output logic [ADDR_WIDTH-1:0]    weight_rd_addr,
    output logic [ADDR_WIDTH-1:0]    act_rd_addr,
    output logic                     weight_rd_en,
    output logic                     act_rd_en,
    output logic                     weight_bank_sel,
    output logic                     act_bank_sel,
    output logic                     loopback_start,
    output logic [31:0]              loopback_words,
    output logic                     output_valid,

    // Shared tile control for the first chip-level skeleton.
    input  logic                    start,
    input  logic                    clear,
    input  logic                    compute_en,
    input  logic                    reduce_en,
    input  logic [DATA_WIDTH-1:0]   activation_data,

    // Per-tile compute status and results.
    output logic [GRID_W*GRID_H-1:0] done,
    output logic [GRID_W*GRID_H-1:0] overflow_hazard,
    output logic [GRID_W*GRID_H-1:0] tile_result_valid,
    output noc_packet_pkg::noc_packet_t tile_result_packet [GRID_W*GRID_H],
    output logic                     result_wr_en,
    output logic [ADDR_WIDTH-1:0]    result_wr_addr,
    output logic [RESULT_WIDTH-1:0]  result_wr_data,

    // Mesh occupancy visibility for bring-up/debug.
    output logic [GRID_W*GRID_H-1:0] tile_occupied
);
    import noc_packet_pkg::*;

    localparam int TILE_COUNT      = GRID_W * GRID_H;

    logic                     sched_cmd_valid;
    noc_packet_t              sched_cmd_packet;
    logic                     sched_cmd_ready;
    logic                     sched_status_valid;
    noc_packet_t              sched_status_packet;
    logic                     sched_status_ready;

    logic                     tile_inject_valid   [TILE_COUNT];
    noc_packet_t              tile_inject_packet  [TILE_COUNT];
    logic                     tile_inject_ready   [TILE_COUNT];
    logic                     tile_deliver_valid  [TILE_COUNT];
    noc_packet_t              tile_deliver_packet [TILE_COUNT];
    logic                     tile_deliver_ready  [TILE_COUNT];

    logic                     ep_packet_in_valid  [TILE_COUNT];
    noc_packet_t              ep_packet_in        [TILE_COUNT];
    logic                     ep_packet_in_ready  [TILE_COUNT];
    logic                     ep_src_valid        [TILE_COUNT];
    noc_packet_t              ep_src_packet       [TILE_COUNT];
    logic                     ep_packet_out_valid [TILE_COUNT];
    noc_packet_t              ep_packet_out       [TILE_COUNT];
    logic                     ep_packet_out_ready [TILE_COUNT];
    logic                     ep_flit_out_valid   [TILE_COUNT];
    noc_flit_t                ep_flit_out         [TILE_COUNT];
    logic                     ep_flit_out_ready   [TILE_COUNT];
    logic                     ep_flit_in_valid    [TILE_COUNT];
    noc_flit_t                ep_flit_in          [TILE_COUNT];
    logic                     ep_flit_in_ready    [TILE_COUNT];

    logic [TILE_COUNT-1:0]    noc_local_in_valid;
    noc_flit_t                noc_local_in_flit [TILE_COUNT];
    logic [TILE_COUNT-1:0]    noc_local_in_ready;
    logic [TILE_COUNT-1:0]    noc_local_out_valid;
    noc_flit_t                noc_local_out_flit[TILE_COUNT];
    logic [TILE_COUNT-1:0]    noc_local_out_ready;
    noc_packet_t              host_out_packet;

    logic [M*N-1:0]           tile_overflow_hazard [TILE_COUNT];
    logic                     tile_done            [TILE_COUNT];
    logic                     result_capture_fire;
    logic [ADDR_WIDTH-1:0]    result_wr_addr_q;

    assign host_out_packet = ep_packet_out[0];

    genvar p;
    generate
        for (p = 0; p < TILE_COUNT; p++) begin : gen_noc_endpoints
            noc_endpoint u_endpoint (
                .packet_in_valid(ep_packet_in_valid[p]),
                .packet_in(ep_packet_in[p]),
                .packet_in_ready(ep_packet_in_ready[p]),
                .flit_out_valid(ep_flit_out_valid[p]),
                .flit_out(ep_flit_out[p]),
                .flit_out_ready(ep_flit_out_ready[p]),
                .flit_in_valid(ep_flit_in_valid[p]),
                .flit_in(ep_flit_in[p]),
                .flit_in_ready(ep_flit_in_ready[p]),
                .packet_out_valid(ep_packet_out_valid[p]),
                .packet_out(ep_packet_out[p]),
                .packet_out_ready(ep_packet_out_ready[p])
            );

            assign noc_local_in_valid[p] = ep_flit_out_valid[p];
            assign ep_flit_out_ready[p]  = noc_local_in_ready[p];
            assign noc_local_in_flit[p]  = ep_flit_out[p];
            assign ep_flit_in_valid[p] = noc_local_out_valid[p];
            assign ep_flit_in[p] = noc_local_out_flit[p];
            assign noc_local_out_ready[p] = ep_flit_in_ready[p];
        end
    endgenerate

    scheduler #(
        .M(M),
        .N(N),
        .GRID_W(GRID_W),
        .GRID_H(GRID_H),
        .ADDR_WIDTH(ADDR_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) u_scheduler (
        .clk(clk),
        .rst_n(rst_n),
        .num_tiles(num_tiles),
        .final_layer(final_layer),
        .act_last(act_last),
        .weight_last(weight_last),
        .weight_full(weight_full),
        .activation_full(activation_full),
        .weight_rd_data(weight_rd_data),
        .act_rd_data(act_rd_data),
        .status_valid(sched_status_valid),
        .status_packet(sched_status_packet),
        .status_ready(sched_status_ready),
        .cmd_valid(sched_cmd_valid),
        .cmd_packet(sched_cmd_packet),
        .cmd_ready(sched_cmd_ready),
        .array_done(1'b0),
        .loopback_done(loopback_done),
        .array_results({M*N*RESULT_WIDTH{1'b0}}),
        .weight_rd_addr(weight_rd_addr),
        .act_rd_addr(act_rd_addr),
        .weight_rd_en(weight_rd_en),
        .act_rd_en(act_rd_en),
        .weight_bank_sel(weight_bank_sel),
        .act_bank_sel(act_bank_sel),
        .array_clear(),
        .array_start(),
        .array_weight_load(),
        .array_compute_en(),
        .array_reduce_en(),
        .result_wr_en(),
        .result_wr_addr(),
        .result_wr_data(),
        .loopback_start(loopback_start),
        .loopback_words(loopback_words),
        .output_valid(output_valid)
    );

    // Each tile talks to the local port of its attached router. Router 0 also
    // acts as the simple host/scheduler endpoint for this bring-up design.
    simple_grid_noc #(
        .GRID_W(GRID_W),
        .GRID_H(GRID_H)
    ) u_noc_grid (
        .clk(clk),
        .rst_n(rst_n),
        .local_in_valid(noc_local_in_valid),
        .local_in_flit(noc_local_in_flit),
        .local_in_ready(noc_local_in_ready),
        .local_out_valid(noc_local_out_valid),
        .local_out_flit(noc_local_out_flit),
        .local_out_ready(noc_local_out_ready),
        .tile_occupied(tile_occupied)
    );

    genvar t;
    generate
        for (t = 0; t < TILE_COUNT; t++) begin : gen_tiles
            localparam int TILE_X = t % GRID_W;
            localparam int TILE_Y = t / GRID_W;

            tile #(
                .TILE_X(TILE_X),
                .TILE_Y(TILE_Y),
                .M(M),
                .N(N),
                .DATA_WIDTH(DATA_WIDTH),
                .RESULT_WIDTH(RESULT_WIDTH)
            ) u_tile (
                .clk(clk),
                .rst_n(rst_n),
                .start(start),
                .clear(clear),
                .compute_en(compute_en),
                .reduce_en(reduce_en),
                .activation_data(activation_data),
                .inject_valid(tile_inject_valid[t]),
                .inject_packet(tile_inject_packet[t]),
                .inject_ready(tile_inject_ready[t]),
                .deliver_valid(tile_deliver_valid[t]),
                .deliver_packet(tile_deliver_packet[t]),
                .deliver_ready(tile_deliver_ready[t]),
                .done(tile_done[t]),
                .overflow_hazard(tile_overflow_hazard[t]),
                .pe_results()
            );

            assign done[t] = tile_done[t];
            assign overflow_hazard[t] = |tile_overflow_hazard[t];
            assign tile_result_valid[t] = tile_deliver_valid[t];
            assign tile_result_packet[t] = tile_deliver_packet[t];
        end
    endgenerate

    always_comb begin
        for (int i = 0; i < TILE_COUNT; i++) begin
            ep_src_valid[i]  = 1'b0;
            ep_src_packet[i] = '0;
        end

        // Scheduler commands enter at router 0. If the scheduler is idle, tile
        // 0 may use that same local router input for its response packets.
        if (sched_cmd_valid) begin
            ep_src_valid[0]  = 1'b1;
            ep_src_packet[0] = sched_cmd_packet;
        end else begin
            ep_src_valid[0]  = tile_deliver_valid[0];
            ep_src_packet[0] = tile_deliver_packet[0];
        end

        for (int i = 1; i < TILE_COUNT; i++) begin
            ep_src_valid[i]  = tile_deliver_valid[i];
            ep_src_packet[i] = tile_deliver_packet[i];
        end
    end

    always_comb begin
        sched_cmd_ready = 1'b0;

        for (int i = 0; i < TILE_COUNT; i++) begin
            tile_deliver_ready[i] = 1'b0;
        end

        if (sched_cmd_valid) begin
            sched_cmd_ready = !ep_packet_in_valid[0] || ep_packet_in_ready[0];
        end else begin
            tile_deliver_ready[0] = !ep_packet_in_valid[0] || ep_packet_in_ready[0];
        end

        for (int i = 1; i < TILE_COUNT; i++) begin
            tile_deliver_ready[i] = !ep_packet_in_valid[i] || ep_packet_in_ready[i];
        end
    end

    always_comb begin
        sched_status_valid  = 1'b0;
        sched_status_packet = '0;

        for (int i = 0; i < TILE_COUNT; i++) begin
            tile_inject_valid[i]  = 1'b0;
            tile_inject_packet[i] = '0;
            ep_packet_out_ready[i] = 1'b0;
        end

        // Router 0 is the host endpoint. Result packets are captured here and
        // done packets return to the scheduler. Other local packets go to tile 0.
        if (ep_packet_out_valid[0]) begin
            if (host_out_packet.payload_type == NOC_PKT_RESULT) begin
                ep_packet_out_ready[0] = 1'b1;
            end else if (host_out_packet.payload_type == NOC_PKT_DONE) begin
                sched_status_valid  = 1'b1;
                sched_status_packet = host_out_packet;
                ep_packet_out_ready[0] = sched_status_ready;
            end else begin
                tile_inject_valid[0]   = 1'b1;
                tile_inject_packet[0]  = host_out_packet;
                ep_packet_out_ready[0] = tile_inject_ready[0];
            end
        end

        for (int i = 1; i < TILE_COUNT; i++) begin
            tile_inject_valid[i]   = ep_packet_out_valid[i];
            tile_inject_packet[i]  = ep_packet_out[i];
            ep_packet_out_ready[i] = tile_inject_ready[i];
        end
    end

    assign result_capture_fire = ep_packet_out_valid[0] && ep_packet_out_ready[0] &&
                                 (host_out_packet.payload_type == NOC_PKT_RESULT);

    always_comb begin
        result_wr_en   = result_capture_fire;
        result_wr_addr = result_wr_addr_q;
        result_wr_data = host_out_packet.payload[RESULT_WIDTH-1:0];
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_wr_addr_q <= '0;
            for (int i = 0; i < TILE_COUNT; i++) begin
                ep_packet_in_valid[i] <= 1'b0;
                ep_packet_in[i]       <= '0;
            end
        end else begin
            for (int i = 0; i < TILE_COUNT; i++) begin
                if (ep_packet_in_valid[i] && ep_packet_in_ready[i]) begin
                    ep_packet_in_valid[i] <= 1'b0;
                end

                if (ep_src_valid[i] && (!ep_packet_in_valid[i] || ep_packet_in_ready[i])) begin
                    ep_packet_in_valid[i] <= 1'b1;
                    ep_packet_in[i]       <= ep_src_packet[i];
                end
            end

            if (loopback_done || output_valid) begin
                result_wr_addr_q <= '0;
            end else if (result_capture_fire) begin
                result_wr_addr_q <= result_wr_addr_q + 1'b1;
            end
        end
    end

endmodule
