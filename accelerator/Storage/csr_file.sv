module csr_file #(
    parameter int DATA_WIDTH = 32,
    parameter int DEPTH      = 16,
    parameter int ADDR_W     = $clog2(DEPTH)
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // Host/decoder write path
    input  logic                  wr_en,
    input  logic [ADDR_W-1:0]     wr_addr,
    input  logic [DATA_WIDTH-1:0] wr_data,

    // Host/decoder read path
    input  logic [ADDR_W-1:0]     rd_addr_a,
    input  logic [ADDR_W-1:0]     rd_addr_b,
    output logic [DATA_WIDTH-1:0] rd_data_a,
    output logic [DATA_WIDTH-1:0] rd_data_b,

    // Decoded configuration for the rest of the accelerator
    output logic [31:0]           num_tiles,
    output logic                  final_layer,

    // Live status inputs to expose through CSR reads
    input  logic                  scheduler_busy,
    input  logic                  output_ready,
    input  logic                  packer_busy,
    input  logic                  array_overflow_hazard,
    input  logic [4:0]            error_status
);

    localparam logic [ADDR_W-1:0] CSR_LAYER_CFG = 4'd1;
    localparam logic [ADDR_W-1:0] CSR_STATUS    = 4'd2;
    localparam logic [ADDR_W-1:0] CSR_ERROR     = 4'd3;

    logic [DATA_WIDTH-1:0] rf_rd_data_a;
    logic [DATA_WIDTH-1:0] rf_rd_data_b;

    register_file #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_W(ADDR_W)
    ) regfile (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_addr_a(rd_addr_a),
        .rd_addr_b(rd_addr_b),
        .rd_data_a(rf_rd_data_a),
        .rd_data_b(rf_rd_data_b)
    );

    assign num_tiles   = {1'b0, rf_rd_data_b[31:1]};
    assign final_layer = rf_rd_data_b[0];

    always_comb begin
        rd_data_a = rf_rd_data_a;
        rd_data_b = rf_rd_data_b;

        // Register 1 is the layer configuration word:
        // [31:1] = num_tiles, [0] = final_layer.
        if (rd_addr_a == CSR_LAYER_CFG) rd_data_a = rf_rd_data_a;
        if (rd_addr_b == CSR_LAYER_CFG) rd_data_b = rf_rd_data_b;

        // Register 2 is live status from the scheduler / packer path:
        // [3] array_overflow_hazard, [2] scheduler_busy, [1] output_ready, [0] packer_busy.
        if (rd_addr_a == CSR_STATUS)
            rd_data_a = {28'b0, array_overflow_hazard, scheduler_busy, output_ready, packer_busy};
        if (rd_addr_b == CSR_STATUS)
            rd_data_b = {28'b0, array_overflow_hazard, scheduler_busy, output_ready, packer_busy};

        // Register 3 is the current error bitmap.
        if (rd_addr_a == CSR_ERROR)
            rd_data_a = {27'b0, error_status};
        if (rd_addr_b == CSR_ERROR)
            rd_data_b = {27'b0, error_status};
    end

endmodule
