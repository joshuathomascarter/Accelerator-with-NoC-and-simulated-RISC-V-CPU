module cpu_dmem #(
    parameter int DATA_WIDTH = cpu_pkg::CPU_XLEN,
    parameter int DEPTH      = 256
)(
    input  logic                  clk,
    input  logic                  rst_n,

    input  logic                  rd_en,
    input  logic                  wr_en,
    input  logic [31:0]           addr,
    input  logic [DATA_WIDTH-1:0] wr_data,
    output logic [DATA_WIDTH-1:0] rd_data
);
    localparam int ADDR_W = $clog2(DEPTH);

    logic [DATA_WIDTH-1:0] dmem [DEPTH];
    logic [ADDR_W-1:0] word_idx;
    logic in_range;

    assign word_idx = addr[ADDR_W+1:2];
    assign in_range = (addr >> 2) < DEPTH;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < DEPTH; i++) begin
                dmem[i] <= '0;
            end
        end else if (wr_en && in_range && (addr[1:0] == 2'b00)) begin
            dmem[word_idx] <= wr_data;
        end
    end

    always_comb begin
        if (rd_en && in_range && (addr[1:0] == 2'b00)) begin
            rd_data = dmem[word_idx];
        end else begin
            rd_data = '0;
        end
    end

endmodule
