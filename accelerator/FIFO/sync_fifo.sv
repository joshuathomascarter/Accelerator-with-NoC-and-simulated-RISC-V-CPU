module fifo_8bit #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 16,
    parameter int ADDR_W     = $clog2(DEPTH)
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // Write side: producer pushes data when wr_en && wr_ready.
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic                  wr_en,
    output logic                  wr_ready,
    output logic                  full,

    // Read side: consumer pops data when rd_valid && rd_en.
    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  rd_valid,
    input  logic                  rd_en,
    output logic                  empty
);

    logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];
    logic [ADDR_W:0] wr_ptr;
    logic [ADDR_W:0] rd_ptr;

    logic do_read;
    logic do_write;

    assign empty    = (wr_ptr == rd_ptr);
    assign full     = (wr_ptr[ADDR_W] != rd_ptr[ADDR_W]) &&
                      (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);

    assign rd_valid = !empty;
    assign wr_ready = !full || do_read;

    assign do_read  = rd_en && rd_valid;
    assign do_write = wr_en && wr_ready;

    // First-word fall-through: when rd_valid is high, data_out is the current
    // front item. The item is only consumed when the reader asserts rd_en.
    assign data_out = mem[rd_ptr[ADDR_W-1:0]];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            if (do_write) begin
                mem[wr_ptr[ADDR_W-1:0]] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end

            if (do_read) begin
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

endmodule
