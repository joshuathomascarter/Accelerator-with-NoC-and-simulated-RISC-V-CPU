module scheduler #(
    parameter int M            = 2,
    parameter int N            = 2,
    parameter int GRID_W       = 2,
    parameter int GRID_H       = 2,
    parameter int ADDR_WIDTH   = 8,
    parameter int RESULT_WIDTH = 32
)(
    input  logic clk,
    input  logic rst_n,

    // Layer configuration
    input  logic [31:0] num_tiles,
    input  logic        final_layer,

    // Stream / fill status from the command-side SRAM loaders
    input  logic act_last,
    input  logic weight_last,
    input  logic weight_full,
    input  logic activation_full,

    // Data returned by the SRAMs selected below
    input  logic [RESULT_WIDTH-1:0] weight_rd_data,
    input  logic [RESULT_WIDTH-1:0] act_rd_data,

    // Tile completion/status packets returning from the mesh
    input  logic                     status_valid,
    input  noc_packet_pkg::noc_packet_t status_packet,
    output logic                     status_ready,

    // Tile command packet stream into the mesh
    output logic                     cmd_valid,
    output noc_packet_pkg::noc_packet_t cmd_packet,
    input  logic                     cmd_ready,

    // Legacy single-array status inputs, kept as compatibility hooks
    input  logic array_done,
    input  logic loopback_done,
    input  logic [M*N*RESULT_WIDTH-1:0] array_results,

    // SRAM read side
    output logic [ADDR_WIDTH-1:0] weight_rd_addr,
    output logic [ADDR_WIDTH-1:0] act_rd_addr,
    output logic                  weight_rd_en,
    output logic                  act_rd_en,
    output logic                  weight_bank_sel,
    output logic                  act_bank_sel,

    // Legacy direct systolic array control, held inactive in tile-traffic mode
    output logic array_clear,
    output logic array_start,
    output logic array_weight_load,
    output logic array_compute_en,
    output logic array_reduce_en,

    // Result writeback is handled by chip_top result packet capture now
    output logic                  result_wr_en,
    output logic [ADDR_WIDTH-1:0] result_wr_addr,
    output logic [RESULT_WIDTH-1:0] result_wr_data,

    // Optional loopback for non-final layers
    output logic                  loopback_start,
    output logic [31:0]           loopback_words,

    // Status
    output logic output_valid
);
    import noc_packet_pkg::*;

    typedef enum logic [3:0] {
        IDLE,
        SEND_CLEAR,
        LOAD_WEIGHTS,
        SEND_START,
        LOAD_ACTS,
        SEND_REDUCE,
        WAIT_TILE_DONE,
        NEXT_TILE,
        REDUCE_LOOPBACK,
        RELOAD_ACT,
        OUTPUT_RESULT,
        DONE
    } state_t;

    localparam int PE_COUNT  = M * N;
    localparam int ACT_ELEMS = N;

    state_t state;

    logic [31:0] tile_cnt;
    logic [31:0] amount_of_tiles;
    logic [31:0] result_count_q;
    logic        current_bank;

    function automatic noc_coord_t tile_x_for(input logic [31:0] tile_id);
        return noc_coord_t'(tile_id % GRID_W);
    endfunction

    function automatic noc_coord_t tile_y_for(input logic [31:0] tile_id);
        return noc_coord_t'(tile_id / GRID_W);
    endfunction

    function automatic noc_packet_t make_cmd_packet(
        input logic [31:0] tile_id,
        input noc_type_t pkt_type,
        input noc_payload_t payload
    );
        begin
            make_cmd_packet.src_x        = '0;
            make_cmd_packet.src_y        = '0;
            make_cmd_packet.dst_x        = tile_x_for(tile_id);
            make_cmd_packet.dst_y        = tile_y_for(tile_id);
            make_cmd_packet.payload_type = pkt_type;
            make_cmd_packet.payload      = payload;
        end
    endfunction

    function automatic logic is_expected_done(input noc_packet_t pkt);
        return (pkt.payload_type == NOC_PKT_DONE) &&
               (pkt.src_x == tile_x_for(tile_cnt)) &&
               (pkt.src_y == tile_y_for(tile_cnt));
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state             <= IDLE;
            tile_cnt          <= '0;
            amount_of_tiles   <= '0;
            result_count_q    <= '0;
            current_bank      <= 1'b0;
            weight_rd_addr    <= '0;
            act_rd_addr       <= '0;
            weight_rd_en      <= 1'b0;
            act_rd_en         <= 1'b0;
            weight_bank_sel   <= 1'b0;
            act_bank_sel      <= 1'b0;
            array_clear       <= 1'b0;
            array_start       <= 1'b0;
            array_weight_load <= 1'b0;
            array_compute_en  <= 1'b0;
            array_reduce_en   <= 1'b0;
            result_wr_en      <= 1'b0;
            result_wr_addr    <= '0;
            result_wr_data    <= '0;
            loopback_start    <= 1'b0;
            loopback_words    <= '0;
            output_valid      <= 1'b0;
            cmd_valid         <= 1'b0;
            cmd_packet        <= '0;
            status_ready      <= 1'b0;
        end else begin
            weight_rd_en      <= 1'b0;
            act_rd_en         <= 1'b0;
            array_clear       <= 1'b0;
            array_start       <= 1'b0;
            array_weight_load <= 1'b0;
            array_compute_en  <= 1'b0;
            array_reduce_en   <= 1'b0;
            result_wr_en      <= 1'b0;
            loopback_start    <= 1'b0;
            output_valid      <= 1'b0;
            cmd_valid         <= 1'b0;
            cmd_packet        <= '0;
            status_ready      <= 1'b0;

            case (state)
                IDLE: begin
                    if (weight_full && activation_full) begin
                        amount_of_tiles <= num_tiles;
                        tile_cnt        <= '0;
                        result_count_q  <= '0;
                        state           <= SEND_CLEAR;
                    end
                end

                SEND_CLEAR: begin
                    cmd_valid  <= 1'b1;
                    cmd_packet <= make_cmd_packet(tile_cnt, NOC_PKT_CLEAR, '0);

                    if (cmd_ready) begin
                        state           <= LOAD_WEIGHTS;
                    end
                end

                LOAD_WEIGHTS: begin
                    weight_bank_sel <= current_bank;
                    weight_rd_en    <= 1'b1;
                    weight_rd_addr  <= ADDR_WIDTH'(tile_cnt);
                    cmd_valid       <= 1'b1;
                    cmd_packet      <= make_cmd_packet(tile_cnt, NOC_PKT_WEIGHT,
                                                       noc_payload_t'(weight_rd_data));

                    if (cmd_ready) begin
                        state <= SEND_START;
                    end
                end

                SEND_START: begin
                    cmd_valid  <= 1'b1;
                    cmd_packet <= make_cmd_packet(tile_cnt, NOC_PKT_START, '0);

                    if (cmd_ready) begin
                        state <= LOAD_ACTS;
                    end
                end

                LOAD_ACTS: begin
                    act_bank_sel <= current_bank;
                    act_rd_en    <= 1'b1;
                    act_rd_addr  <= ADDR_WIDTH'(tile_cnt);
                    cmd_valid    <= 1'b1;
                    cmd_packet   <= make_cmd_packet(tile_cnt, NOC_PKT_COMPUTE,
                                                    noc_payload_t'(act_rd_data));
                    
                    if (cmd_ready) begin
                        state <= SEND_REDUCE;
                    end
                end

                SEND_REDUCE: begin
                    cmd_valid  <= 1'b1;
                    cmd_packet <= make_cmd_packet(tile_cnt, NOC_PKT_REDUCE, '0);

                    if (cmd_ready) begin
                        state <= WAIT_TILE_DONE;
                    end
                end

                WAIT_TILE_DONE: begin
                    if (status_valid && is_expected_done(status_packet)) begin
                        status_ready   <= 1'b1;
                        result_count_q <= result_count_q + 1'b1;
                        state          <= NEXT_TILE;
                    end
                end

                NEXT_TILE: begin
                    if (tile_cnt + 1 < amount_of_tiles) begin
                        tile_cnt <= tile_cnt + 1'b1;
                        state    <= SEND_CLEAR;
                    end else if (final_layer) begin
                        state <= OUTPUT_RESULT;
                    end else begin
                        loopback_words <= result_count_q;
                        state          <= REDUCE_LOOPBACK;
                    end
                end

                REDUCE_LOOPBACK: begin
                    loopback_start <= 1'b1;
                    if (loopback_done) begin
                        current_bank <= ~current_bank;
                        state        <= RELOAD_ACT;
                    end
                end

                RELOAD_ACT: begin
                    if (weight_full && activation_full) begin
                        tile_cnt        <= '0;
                        result_count_q  <= '0;
                        state           <= SEND_CLEAR;
                    end
                end

                OUTPUT_RESULT: begin
                    output_valid <= 1'b1;
                    state        <= DONE;
                end

                DONE: begin
                    if (act_last || weight_last) begin
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
