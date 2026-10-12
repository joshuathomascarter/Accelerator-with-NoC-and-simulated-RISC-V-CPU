module pynq_accel_top #(
    // Literal defaults: Vivado block-design module references cannot evaluate
    // package-qualified parameter defaults. Keep in sync with pynq_accel_pkg.
    parameter int AXI_ADDR_W = 8,
    parameter int AXI_DATA_W = 32,
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
    logic accel_start, accel_clear, accel_final_layer;
    logic [31:0] accel_tile_count;
    logic weight_wr_en, act_wr_en, result_rd_en;
    logic [31:0] weight_wr_data, act_wr_data;
    logic [3:0] led_reg;
    logic [7:0] tile_select, packet_type;
    logic [31:0] packet_payload;
    logic packet_valid;
    logic [31:0] dma_src_addr, dma_dst_addr, dma_length;
    logic busy, run_done, result_valid, overflow, protocol_error;
    logic [31:0] result_data, error_flags;

    assign leds = led_reg | {run_done, result_valid, busy, protocol_error};

    pynq_accel_axi_lite #(.AXI_ADDR_W(AXI_ADDR_W), .AXI_DATA_W(AXI_DATA_W)) u_axi (
        .clk(s_axi_aclk), .rst_n(s_axi_aresetn),
        .s_axi_awaddr(s_axi_awaddr), .s_axi_awvalid(s_axi_awvalid), .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata), .s_axi_wstrb(s_axi_wstrb), .s_axi_wvalid(s_axi_wvalid), .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp), .s_axi_bvalid(s_axi_bvalid), .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr), .s_axi_arvalid(s_axi_arvalid), .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata), .s_axi_rresp(s_axi_rresp), .s_axi_rvalid(s_axi_rvalid), .s_axi_rready(s_axi_rready),
        .accel_busy(busy), .accel_done(run_done), .accel_result_valid(result_valid),
        .accel_overflow(overflow), .accel_result_data(result_data), .accel_error_flags(error_flags),
        .packet_ready(1'b0), .accel_start(accel_start), .accel_clear(accel_clear),
        .accel_final_layer(accel_final_layer), .accel_tile_count(accel_tile_count),
        .accel_weight_wr_en(weight_wr_en), .accel_weight_wr_data(weight_wr_data),
        .accel_act_wr_en(act_wr_en), .accel_act_wr_data(act_wr_data), .accel_result_rd_en(result_rd_en),
        .led_mirror(led_reg), .tile_select(tile_select), .packet_type(packet_type),
        .packet_payload(packet_payload), .packet_valid(packet_valid),
        .dma_src_addr(dma_src_addr), .dma_dst_addr(dma_dst_addr), .dma_length(dma_length),
        .ext_wr_en(), .ext_wr_addr(), .ext_wr_data(), .ext_rd_addr(), .ext_rd_data('0)
    );

    accel_core #(
        .GRID_W(GRID_W), .GRID_H(GRID_H), .TILE_M(TILE_M), .TILE_N(TILE_N), .MEM_ADDR_W(MEM_ADDR_W)
    ) u_core (
        .clk(s_axi_aclk), .rst_n(s_axi_aresetn),
        .start(accel_start), .clear(accel_clear), .final_layer(accel_final_layer),
        .tile_count(accel_tile_count),
        .weight_wr_en(weight_wr_en), .weight_wr_data(weight_wr_data),
        .act_wr_en(act_wr_en), .act_wr_data(act_wr_data),
        .result_rd_en(result_rd_en), .protocol_violation(packet_valid),
        .busy(busy), .done(run_done), .result_valid(result_valid), .overflow(overflow),
        .result_data(result_data), .error_flags(error_flags), .protocol_error(protocol_error)
    );
endmodule
