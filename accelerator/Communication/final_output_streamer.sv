module final_output_streamer #(
    parameter int DATA_WIDTH      = 32,
    parameter int WORD_COUNT_W    = 32,
    parameter int REDUCED_WIDTH   = 8
)(
    input  logic                    clk,
    input  logic                    rst_n,

    input  logic                    start,
    input  logic [WORD_COUNT_W-1:0] word_count,
    input  logic [DATA_WIDTH-1:0]   src_data,

    input  logic                    packer_busy,

    output logic                    src_rd_en,
    output logic                    src_rd_ptr_reset,
    output logic                    packer_start,
    output logic [DATA_WIDTH-1:0]   packer_data,

    output logic                    busy,
    output logic                    done
);

    typedef enum logic [1:0] {
        FO_IDLE,
        FO_ISSUE_READ,
        FO_START_PACK,
        FO_WAIT_PACK
    } state_t;

    state_t state;
    logic [WORD_COUNT_W-1:0] words_remaining;

    assign packer_data = src_data;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state            <= FO_IDLE;
            words_remaining  <= '0;
            src_rd_en        <= 1'b0;
            src_rd_ptr_reset <= 1'b0;
            packer_start     <= 1'b0;
            busy             <= 1'b0;
            done             <= 1'b0;
        end else begin
            src_rd_en        <= 1'b0;
            src_rd_ptr_reset <= 1'b0;
            packer_start     <= 1'b0;
            done             <= 1'b0;

            case (state)
                FO_IDLE: begin
                    busy <= 1'b0;
                    if (start) begin
                        busy             <= 1'b1;
                        words_remaining  <= word_count;
                        src_rd_ptr_reset <= 1'b1;
                        state            <= FO_ISSUE_READ;
                    end
                end

                FO_ISSUE_READ: begin
                    if (words_remaining != '0) begin
                        src_rd_en <= 1'b1;
                        state     <= FO_START_PACK;
                    end else begin
                        state <= FO_IDLE;
                        busy  <= 1'b0;
                        done  <= 1'b1;
                    end
                end

                FO_START_PACK: begin
                    if (!packer_busy) begin
                        packer_start <= 1'b1;
                        state        <= FO_WAIT_PACK;
                    end
                end

                FO_WAIT_PACK: begin
                    if (!packer_busy && !packer_start) begin
                        if (words_remaining <= 1) begin
                            words_remaining <= '0;
                            busy            <= 1'b0;
                            done            <= 1'b1;
                            state           <= FO_IDLE;
                        end else begin
                            words_remaining <= words_remaining - 1'b1;
                            state           <= FO_ISSUE_READ;
                        end
                    end
                end

                default: state <= FO_IDLE;
            endcase
        end
    end

endmodule
