module sram #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 256,
    parameter int ADDR_W     = $clog2(DEPTH)
)(
    input  logic                   clk,

    // Write port — UART side
    input  logic                   wr_en,
    input  logic                   wr_bank_sel,
    input  logic [ADDR_W-1:0]      wr_addr,
    input  logic [DATA_WIDTH-1:0]  wr_data,

    // Read port — PE side (synchronous, 1 cycle latency)
    input  logic                   rd_en,
    input  logic                   rd_bank_sel,
    input  logic [ADDR_W-1:0]      rd_addr,
    output logic [DATA_WIDTH-1:0]  rd_data
);

    logic [DATA_WIDTH-1:0] mem0 [DEPTH-1:0];
    logic [DATA_WIDTH-1:0] mem1 [DEPTH-1:0];

    always_ff @(posedge clk) begin
        if (wr_en)
            if (wr_bank_sel) mem0[wr_addr] <= wr_data;
            else             mem1[wr_addr] <= wr_data;

        if (rd_en)
            rd_data <= rd_bank_sel ? mem0[rd_addr] : mem1[rd_addr];
    end

endmodule
