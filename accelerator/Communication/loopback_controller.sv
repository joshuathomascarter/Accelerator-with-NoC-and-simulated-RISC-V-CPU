module loopback_controller #(
    parameter int DATA_WIDTH      = 32,
    parameter int WORD_COUNT_W    = 32,
    parameter int REDUCED_WIDTH   = 8
)(
    input  logic                   clk,
    input  logic                   rst_n,

    input  logic                   start,
    input  logic [WORD_COUNT_W-1:0] word_count,
    input  logic [DATA_WIDTH-1:0]   src_data,
    input  logic                   dst_full,

    output logic                   src_rd_en,
    output logic                   src_rd_ptr_reset,
    output logic                   dst_wr_en,
    output logic [DATA_WIDTH-1:0]   dst_wr_data,
    output logic                   dst_wr_ptr_reset,

    output logic                   busy,
    output logic                   done
);

    typedef enum logic [1:0] {
        LB_IDLE,
        LB_ISSUE_READ,
        LB_WRITE_WORD,
        LB_DONE
    } state_t;

    state_t state;

    logic [WORD_COUNT_W-1:0] words_remaining;
    logic [DATA_WIDTH-1:0]   reduced_word;

    result_reducer #(
        .IN_WIDTH(DATA_WIDTH),
        .OUT_WIDTH(DATA_WIDTH),
        .REDUCED_WIDTH(REDUCED_WIDTH)
    ) reducer_inst (
        .result_in(src_data),
        .reduced_out(reduced_word)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state            <= LB_IDLE;
            words_remaining  <= '0;
            src_rd_en        <= 1'b0;
            src_rd_ptr_reset <= 1'b0;
            dst_wr_en        <= 1'b0;
            dst_wr_data      <= '0;
            dst_wr_ptr_reset <= 1'b0;
            busy             <= 1'b0;
            done             <= 1'b0;
        end else begin
            src_rd_en        <= 1'b0;
            src_rd_ptr_reset <= 1'b0;
            dst_wr_en        <= 1'b0;
            dst_wr_ptr_reset <= 1'b0;
            done             <= 1'b0;

            case (state)
                LB_IDLE: begin
                    busy <= 1'b0;
                    if (start) begin
                        busy             <= 1'b1;
                        words_remaining   <= word_count;
                        src_rd_ptr_reset  <= 1'b1;
                        dst_wr_ptr_reset  <= 1'b1;
                        state             <= LB_ISSUE_READ;
                    end
                end

                LB_ISSUE_READ: begin
                    if (words_remaining != '0) begin
                        src_rd_en <= 1'b1;
                        state     <= LB_WRITE_WORD;
                    end else begin
                        state <= LB_DONE;
                    end
                end

                LB_WRITE_WORD: begin
                    if (!dst_full) begin
                        dst_wr_en   <= 1'b1;
                        dst_wr_data <= reduced_word;
                        if (words_remaining <= 1) begin
                            words_remaining <= '0;
                            state           <= LB_DONE;
                        end else begin
                            words_remaining <= words_remaining - 1'b1;
                            state           <= LB_ISSUE_READ;
                        end
                    end
                end

                LB_DONE: begin
                    busy <= 1'b0;
                    done <= 1'b1;
                    if (!start) begin
                        state <= LB_IDLE;
                    end
                end

                default: state <= LB_IDLE;
            endcase
        end
    end

endmodule
