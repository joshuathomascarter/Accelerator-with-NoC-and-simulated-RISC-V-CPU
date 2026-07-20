module activation_sram #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 256,
    parameter int ADDR_W     = $clog2(DEPTH)
)(
    input  logic                   clk,
    input  logic                   rst_n,

    // Write side: streamed from cmd_decoder
    input  logic                   wr_en,
    input  logic                   wr_bank_sel,
    input  logic [DATA_WIDTH-1:0]  wr_data,
    input  logic                   wr_ptr_reset,

    // Read side: PE array (explicit address)
    input  logic                   rd_en,
    input  logic                   rd_bank_sel,
    input  logic [ADDR_W-1:0]      rd_addr,
    output logic [DATA_WIDTH-1:0]  rd_data,

    // Status
    output logic                   last,
    output logic                    full
);

    logic [ADDR_W-1:0] wr_addr;

    sram #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_W(ADDR_W)
    ) activation_mem (
        .clk(clk),
        .wr_en(wr_en),
        .wr_bank_sel(wr_bank_sel),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_bank_sel(rd_bank_sel),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

    assign full = (wr_addr == ADDR_W'(DEPTH - 1));

    // Auto-increment write pointer
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_addr <= '0;
            last    <= 1'b0;
        end else begin
            last <= 1'b0;  // Default: deassert
            if (wr_ptr_reset) begin
                wr_addr <= '0;
            end else if (wr_en) begin
                wr_addr <= wr_addr + 1'b1;
            end
        end
    end

endmodule
