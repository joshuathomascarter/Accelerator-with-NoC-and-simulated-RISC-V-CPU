module register_file #(
    parameter int DATA_WIDTH = 32,
    parameter int DEPTH      = 16,
    parameter int ADDR_W     = $clog2(DEPTH)
)(
    input  logic                  clk,
    input  logic                  rst_n,

    input  logic                  wr_en,
    input  logic [ADDR_W-1:0]     wr_addr,
    input  logic [DATA_WIDTH-1:0] wr_data,

    input  logic [ADDR_W-1:0]     rd_addr_a,
    input  logic [ADDR_W-1:0]     rd_addr_b,

    output logic [DATA_WIDTH-1:0] rd_data_a,
    output logic [DATA_WIDTH-1:0] rd_data_b
);

    logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];
    integer i;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= '0;
            end
        end else if (wr_en) begin
            mem[wr_addr] <= wr_data;
        end
    end

    always_comb begin
        rd_data_a = mem[rd_addr_a];
        rd_data_b = mem[rd_addr_b];
    end

endmodule
