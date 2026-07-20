module simple_grid_noc #(
    parameter int GRID_W = 2,
    parameter int GRID_H = 2
)(
    input  logic                         clk,
    input  logic                         rst_n,

    input  logic [GRID_W*GRID_H-1:0]     local_in_valid,
    input  noc_packet_pkg::noc_flit_t    local_in_flit [GRID_W*GRID_H],
    output logic [GRID_W*GRID_H-1:0]     local_in_ready,

    output logic [GRID_W*GRID_H-1:0]     local_out_valid,
    output noc_packet_pkg::noc_flit_t    local_out_flit[GRID_W*GRID_H],
    input  logic [GRID_W*GRID_H-1:0]     local_out_ready,

    output logic [GRID_W*GRID_H-1:0]     tile_occupied
);
    import noc_packet_pkg::*;

    localparam int TILE_COUNT = GRID_W * GRID_H;

    logic                  tile_valid_q       [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  tile_valid_d       [TILE_COUNT][NOC_CLASS_COUNT];
    noc_flit_t             tile_flit_q        [TILE_COUNT][NOC_CLASS_COUNT];
    noc_flit_t             tile_flit_d        [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  local_out_valid_q  [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  local_out_valid_d  [TILE_COUNT][NOC_CLASS_COUNT];
    noc_flit_t             local_out_flit_q   [TILE_COUNT][NOC_CLASS_COUNT];
    noc_flit_t             local_out_flit_d   [TILE_COUNT][NOC_CLASS_COUNT];
    noc_dir_t              tile_route         [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  tile_local_hit     [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  tile_in_ready      [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  tile_local_ready   [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  tile_east_ready    [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  tile_west_ready    [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  tile_north_ready   [TILE_COUNT][NOC_CLASS_COUNT];
    logic                  tile_south_ready   [TILE_COUNT][NOC_CLASS_COUNT];

    function automatic noc_coord_t tile_x(
        input int unsigned idx
    );
        return noc_coord_t'(idx % GRID_W);
    endfunction

    function automatic noc_coord_t tile_y(
        input int unsigned idx
    );
        return noc_coord_t'(idx / GRID_W);
    endfunction

    genvar router_idx;
    genvar class_idx;
    generate
        for (router_idx = 0; router_idx < TILE_COUNT; router_idx++) begin : gen_router
            for (class_idx = 0; class_idx < NOC_CLASS_COUNT; class_idx++) begin : gen_class
                noc_router #(
                    .COORD_W(NOC_COORD_W)
                ) u_router (
                    .in_valid(tile_valid_q[router_idx][class_idx]),
                    .router_x(tile_x(router_idx)),
                    .router_y(tile_y(router_idx)),
                    .in_flit(tile_flit_q[router_idx][class_idx]),
                    .local_ready(tile_local_ready[router_idx][class_idx]),
                    .east_ready(tile_east_ready[router_idx][class_idx]),
                    .west_ready(tile_west_ready[router_idx][class_idx]),
                    .north_ready(tile_north_ready[router_idx][class_idx]),
                    .south_ready(tile_south_ready[router_idx][class_idx]),
                    .is_local(tile_local_hit[router_idx][class_idx]),
                    .route_dir(tile_route[router_idx][class_idx]),
                    .in_ready(tile_in_ready[router_idx][class_idx])
                );
            end
        end
    endgenerate

    always_comb begin
        for (int i = 0; i < TILE_COUNT; i++) begin
            local_in_ready[i] = !tile_valid_q[i][int'(noc_class_for_flit(local_in_flit[i]))];

            if (local_out_valid_q[i][int'(NOC_CLASS_RESP)]) begin
                local_out_valid[i] = 1'b1;
                local_out_flit[i]  = local_out_flit_q[i][int'(NOC_CLASS_RESP)];
            end else begin
                local_out_valid[i] = local_out_valid_q[i][int'(NOC_CLASS_REQ)];
                local_out_flit[i]  = local_out_flit_q[i][int'(NOC_CLASS_REQ)];
            end

            for (int c = 0; c < NOC_CLASS_COUNT; c++) begin
                tile_local_ready[i][c] = !local_out_valid_q[i][c] ||
                    ((c == int'(NOC_CLASS_RESP)) &&
                     local_out_valid_q[i][int'(NOC_CLASS_RESP)] &&
                     local_out_ready[i]) ||
                    ((c == int'(NOC_CLASS_REQ)) &&
                     !local_out_valid_q[i][int'(NOC_CLASS_RESP)] &&
                     local_out_valid_q[i][int'(NOC_CLASS_REQ)] &&
                     local_out_ready[i]);

                tile_east_ready[i][c]  = 1'b0;
                tile_west_ready[i][c]  = 1'b0;
                tile_north_ready[i][c] = 1'b0;
                tile_south_ready[i][c] = 1'b0;

                if (int'(tile_x(i)) + 1 < GRID_W) begin
                    tile_east_ready[i][c] = !tile_valid_q[i + 1][c];
                end

                if (tile_x(i) > 0) begin
                    tile_west_ready[i][c] = !tile_valid_q[i - 1][c];
                end

                if (tile_y(i) > 0) begin
                    tile_north_ready[i][c] = !tile_valid_q[i - GRID_W][c];
                end

                if (int'(tile_y(i)) + 1 < GRID_H) begin
                    tile_south_ready[i][c] = !tile_valid_q[i + GRID_W][c];
                end
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        int unsigned class_move_idx;
        int unsigned dst_idx;
        int unsigned in_class_idx;

        if (!rst_n) begin
            for (int i = 0; i < TILE_COUNT; i++) begin
                for (int c = 0; c < NOC_CLASS_COUNT; c++) begin
                    tile_valid_q[i][c]     <= 1'b0;
                    tile_flit_q[i][c]      <= '0;
                    local_out_valid_q[i][c] <= 1'b0;
                    local_out_flit_q[i][c] <= '0;
                end
            end
        end else begin
            for (int i = 0; i < TILE_COUNT; i++) begin
                for (int c = 0; c < NOC_CLASS_COUNT; c++) begin
                    tile_valid_d[i][c]      = tile_valid_q[i][c];
                    tile_flit_d[i][c]       = tile_flit_q[i][c];
                    local_out_valid_d[i][c] = local_out_valid_q[i][c];
                    local_out_flit_d[i][c]  = local_out_flit_q[i][c];
                end

                if (local_out_valid[i] && local_out_ready[i]) begin
                    if (local_out_valid_q[i][int'(NOC_CLASS_RESP)]) begin
                        local_out_valid_d[i][int'(NOC_CLASS_RESP)] = 1'b0;
                    end else begin
                        local_out_valid_d[i][int'(NOC_CLASS_REQ)] = 1'b0;
                    end
                end
            end

            for (int i = 0; i < TILE_COUNT; i++) begin
                if (local_in_valid[i] && local_in_ready[i]) begin
                    in_class_idx = int'(noc_class_for_flit(local_in_flit[i]));
                    tile_valid_d[i][in_class_idx] = 1'b1;
                    tile_flit_d[i][in_class_idx]  = local_in_flit[i];
                end
            end

            for (int class_order = 0; class_order < NOC_CLASS_COUNT; class_order++) begin
                class_move_idx = (class_order == 0) ? int'(NOC_CLASS_RESP) : int'(NOC_CLASS_REQ);

                for (int i = 0; i < TILE_COUNT; i++) begin
                    if (tile_valid_q[i][class_move_idx]) begin
                        if (tile_local_hit[i][class_move_idx]) begin
                            if (tile_local_ready[i][class_move_idx]) begin
                                local_out_valid_d[i][class_move_idx] = 1'b1;
                                local_out_flit_d[i][class_move_idx]  = tile_flit_q[i][class_move_idx];
                                tile_valid_d[i][class_move_idx]      = 1'b0;
                            end
                        end else if (tile_in_ready[i][class_move_idx]) begin
                            unique case (tile_route[i][class_move_idx])
                                NOC_DIR_EAST:  dst_idx = i + 1;
                                NOC_DIR_WEST:  dst_idx = i - 1;
                                NOC_DIR_SOUTH: dst_idx = i + GRID_W;
                                NOC_DIR_NORTH: dst_idx = i - GRID_W;
                                default:       dst_idx = i;
                            endcase

                            if (!tile_valid_d[dst_idx][class_move_idx]) begin
                                tile_valid_d[dst_idx][class_move_idx] = 1'b1;
                                tile_flit_d[dst_idx][class_move_idx]  = tile_flit_q[i][class_move_idx];
                                tile_valid_d[i][class_move_idx]       = 1'b0;
                            end
                        end
                    end
                end
            end

            for (int i = 0; i < TILE_COUNT; i++) begin
                for (int c = 0; c < NOC_CLASS_COUNT; c++) begin
                    tile_valid_q[i][c]      <= tile_valid_d[i][c];
                    tile_flit_q[i][c]       <= tile_flit_d[i][c];
                    local_out_valid_q[i][c] <= local_out_valid_d[i][c];
                    local_out_flit_q[i][c]  <= local_out_flit_d[i][c];
                end
            end
        end
    end

    always_comb begin
        for (int i = 0; i < TILE_COUNT; i++) begin
            tile_occupied[i] = 1'b0;
            for (int c = 0; c < NOC_CLASS_COUNT; c++) begin
                tile_occupied[i] |= tile_valid_q[i][c];
            end
        end
    end

endmodule
