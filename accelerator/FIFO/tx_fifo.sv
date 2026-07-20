module tx_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 16,
    parameter int ADDR_W     = $clog2(DEPTH)
)(
    input  logic                  clk,
    input  logic                  rst_n,

    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic                  wr_en,
    output logic                  wr_ready,
    output logic                  full,

    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  rd_valid,
    input  logic                  rd_en,
    output logic                  empty
);

    fifo_8bit #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_W(ADDR_W)
    ) fifo_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .wr_en(wr_en),
        .wr_ready(wr_ready),
        .full(full),
        .data_out(data_out),
        .rd_valid(rd_valid),
        .rd_en(rd_en),
        .empty(empty)
    );

endmodule
