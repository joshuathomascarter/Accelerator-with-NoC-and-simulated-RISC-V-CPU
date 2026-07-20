module axi_result_readback #(
    parameter int DATA_W = 32,
    parameter int DEPTH  = 4,
    parameter int ADDR_W = (DEPTH <= 1) ? 1 : $clog2(DEPTH)
)(
    input  logic              clk,
    input  logic              rst_n,
    input  logic              clear,
    input  logic              wr_en,
    input  logic [ADDR_W-1:0] wr_addr,
    input  logic [DATA_W-1:0] wr_data,
    input  logic              run_done,
    input  logic              rd_en,
    output logic [DATA_W-1:0] rd_data,
    output logic              result_valid,
    output logic              all_done,
    output logic [ADDR_W:0]   result_count
);
    logic [DATA_W-1:0] mem [0:DEPTH-1];
    logic [ADDR_W-1:0] rd_ptr_q;

    assign rd_data      = mem[rd_ptr_q];
    assign result_valid = (result_count != '0);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_q     <= '0;
            result_count <= '0;
            all_done     <= 1'b0;
            for (int i = 0; i < DEPTH; i++) begin
                mem[i] <= '0;
            end
        end else if (clear) begin
            rd_ptr_q     <= '0;
            result_count <= '0;
            all_done     <= 1'b0;
        end else begin
            if (wr_en && ({1'b0, wr_addr} < (ADDR_W+1)'(DEPTH))) begin
                mem[wr_addr] <= wr_data;
                if (result_count < (ADDR_W+1)'(DEPTH)) begin
                    result_count <= result_count + 1'b1;
                end
            end

            if (rd_en && result_valid) begin
                rd_ptr_q <= rd_ptr_q + 1'b1;
                if (!(wr_en && ({1'b0, wr_addr} < (ADDR_W+1)'(DEPTH)))) begin
                    result_count <= result_count - 1'b1;
                end
            end

            if (run_done) begin
                all_done <= 1'b1;
            end
        end
    end
endmodule
