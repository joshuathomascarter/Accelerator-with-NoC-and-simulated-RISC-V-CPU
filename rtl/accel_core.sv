// The accelerator behind a simple register-level interface: one-cycle command
// pulses in, status and results out. Driven either by the AXI-Lite register
// shell (pynq_accel_axi_lite) or by the CPU's MMIO bridge (cpu_mmio_bridge);
// both use the same register semantics (docs/PYNQ_REGISTER_MAP.md).
module accel_core #(
    parameter int GRID_W = 2,
    parameter int GRID_H = 2,
    parameter int TILE_M = 2,
    parameter int TILE_N = 2,
    parameter int MEM_ADDR_W = 8
)(
    input  logic        clk,
    input  logic        rst_n,

    input  logic        start,
    input  logic        clear,
    input  logic        final_layer,
    input  logic [31:0] tile_count,
    input  logic        weight_wr_en,
    input  logic [31:0] weight_wr_data,
    input  logic        act_wr_en,
    input  logic [31:0] act_wr_data,
    input  logic        result_rd_en,
    input  logic        protocol_violation,   // e.g. unsupported direct-packet write

    output logic        busy,
    output logic        done,
    output logic        result_valid,
    output logic        overflow,
    output logic [31:0] result_data,
    output logic [31:0] error_flags,
    output logic        protocol_error
);
    import noc_packet_pkg::*;

    localparam int TILE_COUNT = GRID_W * GRID_H;
    localparam int COUNT_W = $clog2(TILE_COUNT + 1);
    localparam int RESULT_ADDR_W = (TILE_COUNT <= 1) ? 1 : $clog2(TILE_COUNT);

    logic [31:0] weight_mem [0:TILE_COUNT-1];
    logic [31:0] act_mem [0:TILE_COUNT-1];
    logic [RESULT_ADDR_W-1:0] weight_wr_ptr_q, act_wr_ptr_q;
    logic [COUNT_W-1:0] weight_count_q, act_count_q;
    logic inputs_ready_q, busy_q;
    logic protocol_error_q;

    logic [MEM_ADDR_W-1:0] weight_rd_addr, act_rd_addr;
    logic weight_rd_en, act_rd_en, weight_bank_sel, act_bank_sel;
    logic [31:0] weight_rd_data, act_rd_data;
    logic loopback_start, output_valid;
    logic [31:0] loopback_words;
    logic [TILE_COUNT-1:0] tile_done, overflow_hazard, tile_result_valid;
    noc_packet_t tile_result_packet [TILE_COUNT];
    logic result_wr_en;
    logic [MEM_ADDR_W-1:0] result_wr_addr;
    logic [31:0] result_wr_data;
    logic [TILE_COUNT-1:0] tile_occupied;
    logic [RESULT_ADDR_W:0] result_count;
    logic tile_count_valid;

    assign tile_count_valid = (tile_count > 0) && (tile_count <= TILE_COUNT);
    assign weight_rd_data   = weight_mem[weight_rd_addr[RESULT_ADDR_W-1:0]];
    assign act_rd_data      = act_mem[act_rd_addr[RESULT_ADDR_W-1:0]];
    assign error_flags      = {29'd0, protocol_error_q, |overflow_hazard, !tile_count_valid};
    assign overflow         = |overflow_hazard;
    assign busy             = busy_q;
    assign protocol_error   = protocol_error_q;

    chip_top #(
        .GRID_W(GRID_W), .GRID_H(GRID_H), .M(TILE_M), .N(TILE_N), .ADDR_WIDTH(MEM_ADDR_W)
    ) u_chip (
        .clk(clk), .rst_n(rst_n), .num_tiles(tile_count),
        .final_layer(final_layer), .act_last(clear), .weight_last(clear),
        .weight_full(inputs_ready_q), .activation_full(inputs_ready_q), .loopback_done(1'b0),
        .weight_rd_data(weight_rd_data), .act_rd_data(act_rd_data), .weight_rd_addr(weight_rd_addr),
        .act_rd_addr(act_rd_addr), .weight_rd_en(weight_rd_en), .act_rd_en(act_rd_en),
        .weight_bank_sel(weight_bank_sel), .act_bank_sel(act_bank_sel),
        .loopback_start(loopback_start), .loopback_words(loopback_words), .output_valid(output_valid),
        .start(1'b0), .clear(clear), .compute_en(1'b0), .reduce_en(1'b0),
        .activation_data({8{1'b0}}),
        .done(tile_done), .overflow_hazard(overflow_hazard), .tile_result_valid(tile_result_valid),
        .tile_result_packet(tile_result_packet), .result_wr_en(result_wr_en),
        .result_wr_addr(result_wr_addr), .result_wr_data(result_wr_data), .tile_occupied(tile_occupied)
    );

    axi_result_readback #(.DEPTH(TILE_COUNT)) u_readback (
        .clk(clk), .rst_n(rst_n), .clear(clear),
        .wr_en(result_wr_en), .wr_addr(result_wr_addr[RESULT_ADDR_W-1:0]), .wr_data(result_wr_data),
        .run_done(output_valid), .rd_en(result_rd_en), .rd_data(result_data),
        .result_valid(result_valid), .all_done(done), .result_count(result_count)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_wr_ptr_q  <= '0;
            act_wr_ptr_q     <= '0;
            weight_count_q   <= '0;
            act_count_q      <= '0;
            inputs_ready_q   <= 1'b0;
            busy_q           <= 1'b0;
            protocol_error_q <= 1'b0;
            for (int i = 0; i < TILE_COUNT; i++) begin
                weight_mem[i] <= '0;
                act_mem[i]    <= '0;
            end
        end else if (clear) begin
            weight_wr_ptr_q  <= '0;
            act_wr_ptr_q     <= '0;
            weight_count_q   <= '0;
            act_count_q      <= '0;
            inputs_ready_q   <= 1'b0;
            busy_q           <= 1'b0;
            protocol_error_q <= 1'b0;
        end else begin
            if (weight_wr_en) begin
                if (weight_count_q < COUNT_W'(TILE_COUNT)) begin
                    weight_mem[weight_wr_ptr_q] <= weight_wr_data;
                    weight_wr_ptr_q <= weight_wr_ptr_q + 1'b1;
                    weight_count_q  <= weight_count_q + 1'b1;
                end else begin
                    protocol_error_q <= 1'b1;
                end
            end
            if (act_wr_en) begin
                if (act_count_q < COUNT_W'(TILE_COUNT)) begin
                    act_mem[act_wr_ptr_q] <= act_wr_data;
                    act_wr_ptr_q <= act_wr_ptr_q + 1'b1;
                    act_count_q  <= act_count_q + 1'b1;
                end else begin
                    protocol_error_q <= 1'b1;
                end
            end
            if (protocol_violation) protocol_error_q <= 1'b1;
            if (start) begin
                if (tile_count_valid &&
                    (weight_count_q >= COUNT_W'(tile_count)) &&
                    (act_count_q >= COUNT_W'(tile_count))) begin
                    inputs_ready_q <= 1'b1;
                    busy_q <= 1'b1;
                end else begin
                    protocol_error_q <= 1'b1;
                end
            end
            if (output_valid) begin
                busy_q <= 1'b0;
                inputs_ready_q <= 1'b0;
            end
        end
    end
endmodule
