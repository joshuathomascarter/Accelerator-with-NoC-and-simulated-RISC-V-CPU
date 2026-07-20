module uart_rx #(
    parameter int DIV_16 = 27  // 50 MHz / (115200 * 16)
)(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       rx_in,
    output logic [7:0] data_out,
    output logic       rx_ready,
    output logic framing_error
);

    typedef enum logic [2:0] {IDLE, START, DATA, STOP} state_t;
    state_t state;

    logic [4:0] sample_count;
    logic [2:0] bit_index;
    logic [7:0] shift_reg;
    logic [7:0] baud_count;


    // Double-flop synchroniser
    logic rx_mid, rx_sync;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_mid  <= 1'b1;
            rx_sync <= 1'b1;
        end else begin
            rx_mid  <= rx_in;
            rx_sync <= rx_mid;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            rx_ready      <= 1'b0;
            data_out      <= '0;
            sample_count  <= '0;
            bit_index     <= '0;
            shift_reg     <= '0;
            baud_count    <= '0;
            framing_error <= 1'b0;
        end else begin
            framing_error <= 1'b0;
            case (state)
                IDLE: begin
                    rx_ready     <= 1'b0;
                    baud_count   <= '0;
                    sample_count <= '0;
                    bit_index    <= '0;
                    if (!rx_sync) state <= START;  // falling edge = start bit
                end

                START: begin
                    if (baud_count == DIV_16 - 1) begin
                        baud_count <= 0;
                        if (sample_count == 7) begin  // middle of start bit
                            sample_count <= 0;
                            state <= DATA;
                        end else
                            sample_count <= sample_count + 1;
                    end else
                        baud_count <= baud_count + 1;
                end

                DATA: begin
                    if (baud_count == DIV_16 - 1) begin
                        baud_count <= 0;
                        if (sample_count == 15) begin  // middle of data bit
                            sample_count <= 0;
                            shift_reg[bit_index] <= rx_sync;
                            if (bit_index == 7) state <= STOP;
                            else                bit_index <= bit_index + 1;
                        end else
                            sample_count <= sample_count + 1;
                    end else
                        baud_count <= baud_count + 1;
                end

                STOP: begin
                    if (baud_count == DIV_16 - 1) begin
                        baud_count <= 0;
                        if (sample_count == 15) begin
                            if (rx_sync == 1'b1) begin
                                data_out <= shift_reg;
                                rx_ready <= 1'b1;
                                state    <= IDLE;
                            end else begin
                                framing_error <= 1'b1;
                                state <= IDLE;
                            end
                            sample_count <= 0;
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
            endcase
        end
    end
endmodule
