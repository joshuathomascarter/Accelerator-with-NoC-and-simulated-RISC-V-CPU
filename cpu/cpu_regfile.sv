module cpu_regfile #(
    parameter int REG_COUNT = 32,
    parameter int DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst_n,

    input logic     [$clog2(REG_COUNT) -1:0]     rd_addr_a,
    output logic    [DATA_WIDTH-1:0]          rd_data_a,

    input logic     [$clog2(REG_COUNT)-1:0]  rd_addr_b,
    output logic    [DATA_WIDTH-1:0]          rd_data_b,

    input logic                                  wr_en,
    input logic     [$clog2(REG_COUNT)-1:0]      wr_addr,
    input logic     [DATA_WIDTH-1:0]          wr_data
);

logic [DATA_WIDTH-1:0] register_file [REG_COUNT];

always_ff @(posedge clk or negedge rst_n) begin

    if (!rst_n) begin
        for (int i = 0; i < REG_COUNT; i++) begin
            register_file[i] <= '0;
        end
    end else if (wr_en && wr_addr != '0) begin
        register_file[wr_addr] <= wr_data;
    end
    
end


always_comb begin
    rd_data_a = (rd_addr_a == '0) ? '0 : register_file[rd_addr_a];
    rd_data_b = (rd_addr_b == '0) ? '0 : register_file[rd_addr_b];
end


endmodule