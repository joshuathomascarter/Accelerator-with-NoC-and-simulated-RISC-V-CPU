module result_packer #(
    parameter int DATA_WIDTH = 32,
    parameter int BYTE_WIDTH = 8
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     start,
    input  logic [DATA_WIDTH-1:0]    result_in,
    input  logic                     byte_ready,
    output logic [BYTE_WIDTH-1:0]     byte_out,
    output logic                     byte_valid,
    output logic                     busy,
    output logic                     done
);

    localparam int BYTE_COUNT = DATA_WIDTH / BYTE_WIDTH;
    localparam int IDX_W = (BYTE_COUNT <= 1) ? 1 : $clog2(BYTE_COUNT);

    logic [DATA_WIDTH-1:0]    result_hold;
    logic [IDX_W-1:0]         byte_index;
    logic                     load_pending;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_hold <= '0;
            byte_index   <= '0;
            byte_out     <= '0;
            byte_valid   <= 1'b0;
            busy         <= 1'b0;
            done         <= 1'b0;
            load_pending <= 1'b0;
        end else begin
            done <= 1'b0;

            if (start && !busy) begin
                load_pending <= 1'b1;
                busy         <= 1'b1;
                byte_valid   <= 1'b0;
            end else if (load_pending) begin
                result_hold  <= result_in;
                byte_index    <= '0;
                byte_out      <= result_in[BYTE_WIDTH-1:0];
                byte_valid    <= 1'b1;
                load_pending  <= 1'b0;
            end else if (busy) begin
                if (byte_valid && byte_ready) begin
                    if (byte_index == BYTE_COUNT-1) begin
                        byte_valid <= 1'b0;
                        busy       <= 1'b0;
                        done       <= 1'b1;
                    end else begin
                        byte_index <= byte_index + 1'b1;
                        byte_out   <= result_hold[(byte_index + 1'b1)*BYTE_WIDTH +: BYTE_WIDTH];
                        byte_valid <= 1'b1;
                    end
                end
            end
        end
    end

endmodule
