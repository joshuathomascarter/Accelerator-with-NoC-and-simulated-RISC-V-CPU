module pynq_accel_top #(
    parameter int AXI_ADDR_W = pynq_accel_pkg::PYNQ_ADDR_W,
    parameter int AXI_DATA_W = pynq_accel_pkg::PYNQ_REG_W,
    parameter int GRID_W = 2,
    parameter int GRID_H = 2,
    parameter int TILE_M = 2,
    parameter int TILE_N = 2,
    parameter int MEM_ADDR_W = 8
)(
    input  logic                      s_axi_aclk,
    input  logic                      s_axi_aresetn,
    input  logic [AXI_ADDR_W-1:0]     s_axi_awaddr,
    input  logic                      s_axi_awvalid,
    output logic                      s_axi_awready,
    input  logic [AXI_DATA_W-1:0]     s_axi_wdata,
    input  logic [(AXI_DATA_W/8)-1:0] s_axi_wstrb,
    input  logic                      s_axi_wvalid,
    output logic                      s_axi_wready,
    output logic [1:0]                s_axi_bresp,
    output logic                      s_axi_bvalid,
    input  logic                      s_axi_bready,
    input  logic [AXI_ADDR_W-1:0]     s_axi_araddr,
    input  logic                      s_axi_arvalid,
    output logic                      s_axi_arready,
    output logic [AXI_DATA_W-1:0]     s_axi_rdata,
    output logic [1:0]                s_axi_rresp,
    output logic                      s_axi_rvalid,
    input  logic                      s_axi_rready,
    output logic [3:0]                leds
);
    import noc_packet_pkg::*;

    localparam int TILE_COUNT = GRID_W * GRID_H;
    localparam int COUNT_W = $clog2(TILE_COUNT + 1);
    localparam int RESULT_ADDR_W = (TILE_COUNT <= 1) ? 1 : $clog2(TILE_COUNT);

    logic accel_start, accel_clear, accel_final_layer;
    logic [31:0] accel_tile_count;
    logic weight_wr_en, act_wr_en, result_rd_en;
    logic [31:0] weight_wr_data, act_wr_data;
    logic [3:0] led_reg;
    logic [7:0] tile_select, packet_type;
    logic [31:0] packet_payload;
    logic packet_valid;
    logic [31:0] dma_src_addr, dma_dst_addr, dma_length;

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
    logic [31:0] result_data;
    logic result_valid, run_done;
    logic [RESULT_ADDR_W:0] result_count;
    logic [31:0] error_flags;
    logic tile_count_valid;

    assign tile_count_valid = (accel_tile_count > 0) && (accel_tile_count <= TILE_COUNT);
    assign weight_rd_data = weight_mem[weight_rd_addr[RESULT_ADDR_W-1:0]];
    assign act_rd_data    = act_mem[act_rd_addr[RESULT_ADDR_W-1:0]];
    assign error_flags    = {29'd0, protocol_error_q, |overflow_hazard, !tile_count_valid};
    assign leds           = led_reg | {run_done, result_valid, busy_q, protocol_error_q};

    pynq_accel_axi_lite u_axi (
        .clk(s_axi_aclk), .rst_n(s_axi_aresetn),
        .s_axi_awaddr(s_axi_awaddr), .s_axi_awvalid(s_axi_awvalid), .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata), .s_axi_wstrb(s_axi_wstrb), .s_axi_wvalid(s_axi_wvalid), .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp), .s_axi_bvalid(s_axi_bvalid), .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr), .s_axi_arvalid(s_axi_arvalid), .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata), .s_axi_rresp(s_axi_rresp), .s_axi_rvalid(s_axi_rvalid), .s_axi_rready(s_axi_rready),
        .accel_busy(busy_q), .accel_done(run_done), .accel_result_valid(result_valid),
        .accel_overflow(|overflow_hazard), .accel_result_data(result_data), .accel_error_flags(error_flags),
        .packet_ready(1'b0), .accel_start(accel_start), .accel_clear(accel_clear),
        .accel_final_layer(accel_final_layer), .accel_tile_count(accel_tile_count),
        .accel_weight_wr_en(weight_wr_en), .accel_weight_wr_data(weight_wr_data),
        .accel_act_wr_en(act_wr_en), .accel_act_wr_data(act_wr_data), .accel_result_rd_en(result_rd_en),
        .led_mirror(led_reg), .tile_select(tile_select), .packet_type(packet_type),
        .packet_payload(packet_payload), .packet_valid(packet_valid),
        .dma_src_addr(dma_src_addr), .dma_dst_addr(dma_dst_addr), .dma_length(dma_length)
    );

    chip_top #(
        .GRID_W(GRID_W), .GRID_H(GRID_H), .M(TILE_M), .N(TILE_N), .ADDR_WIDTH(MEM_ADDR_W)
    ) u_chip (
        .clk(s_axi_aclk), .rst_n(s_axi_aresetn), .num_tiles(accel_tile_count),
        .final_layer(accel_final_layer), .act_last(accel_clear), .weight_last(accel_clear),
        .weight_full(inputs_ready_q), .activation_full(inputs_ready_q), .loopback_done(1'b0),
        .weight_rd_data(weight_rd_data), .act_rd_data(act_rd_data), .weight_rd_addr(weight_rd_addr),
        .act_rd_addr(act_rd_addr), .weight_rd_en(weight_rd_en), .act_rd_en(act_rd_en),
        .weight_bank_sel(weight_bank_sel), .act_bank_sel(act_bank_sel),
        .loopback_start(loopback_start), .loopback_words(loopback_words), .output_valid(output_valid),
        .start(1'b0), .clear(accel_clear), .compute_en(1'b0), .reduce_en(1'b0),
        .activation_data({8{1'b0}}),
        .done(tile_done), .overflow_hazard(overflow_hazard), .tile_result_valid(tile_result_valid),
        .tile_result_packet(tile_result_packet), .result_wr_en(result_wr_en),
        .result_wr_addr(result_wr_addr), .result_wr_data(result_wr_data), .tile_occupied(tile_occupied)
    );

    axi_result_readback #(.DEPTH(TILE_COUNT)) u_readback (
        .clk(s_axi_aclk), .rst_n(s_axi_aresetn), .clear(accel_clear),
        .wr_en(result_wr_en), .wr_addr(result_wr_addr[RESULT_ADDR_W-1:0]), .wr_data(result_wr_data),
        .run_done(output_valid), .rd_en(result_rd_en), .rd_data(result_data),
        .result_valid(result_valid), .all_done(run_done), .result_count(result_count)
    );

    always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            weight_wr_ptr_q <= '0;
            act_wr_ptr_q    <= '0;
            weight_count_q  <= '0;
            act_count_q     <= '0;
            inputs_ready_q  <= 1'b0;
            busy_q          <= 1'b0;
            protocol_error_q <= 1'b0;
            for (int i = 0; i < TILE_COUNT; i++) begin
                weight_mem[i] <= '0;
                act_mem[i]    <= '0;
            end
        end else if (accel_clear) begin
            weight_wr_ptr_q <= '0;
            act_wr_ptr_q    <= '0;
            weight_count_q  <= '0;
            act_count_q     <= '0;
            inputs_ready_q  <= 1'b0;
            busy_q          <= 1'b0;
            protocol_error_q <= 1'b0;
        end else begin
            if (weight_wr_en) begin
                if (weight_count_q < COUNT_W'(TILE_COUNT)) begin
                    weight_mem[weight_wr_ptr_q] <= weight_wr_data;
                    weight_wr_ptr_q <= weight_wr_ptr_q + 1'b1;
                    weight_count_q <= weight_count_q + 1'b1;
                end else begin
                    protocol_error_q <= 1'b1;
                end
            end
            if (act_wr_en) begin
                if (act_count_q < COUNT_W'(TILE_COUNT)) begin
                    act_mem[act_wr_ptr_q] <= act_wr_data;
                    act_wr_ptr_q <= act_wr_ptr_q + 1'b1;
                    act_count_q <= act_count_q + 1'b1;
                end else begin
                    protocol_error_q <= 1'b1;
                end
            end
            if (packet_valid) protocol_error_q <= 1'b1;
            if (accel_start) begin
                if (tile_count_valid &&
                    (weight_count_q >= COUNT_W'(accel_tile_count)) &&
                    (act_count_q >= COUNT_W'(accel_tile_count))) begin
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
