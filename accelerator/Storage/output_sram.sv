module output_sram #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 256,
    parameter int ADDR_W     = $clog2(DEPTH)
)(
    input  logic                   clk,
    input  logic                   rst_n,

    // Write side: PE array result
    input  logic                   wr_en,
    input  logic                   wr_bank_sel,
    input  logic [ADDR_W-1:0]      wr_addr,
    input  logic [DATA_WIDTH-1:0]  wr_data,

    // Read side: streamed to result_packer (auto-increment)
    input  logic                   rd_en,
    input  logic                   rd_bank_sel,
    output logic [DATA_WIDTH-1:0]  rd_data,
    input  logic                   rd_ptr_reset,

    // Status
    output logic                   valid
);

    logic [ADDR_W-1:0] rd_addr;

    sram #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_W(ADDR_W)
    ) output_mem (
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

    // Auto-increment read pointer
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_addr <= '0;
            valid   <= 1'b0;
        end else begin
            if (rd_ptr_reset) begin
                rd_addr <= '0;
                valid   <= 1'b0;
            end else if (rd_en) begin
                rd_addr <= rd_addr + 1'b1;
                valid   <= 1'b1;
            end
        end
    end

endmodule
