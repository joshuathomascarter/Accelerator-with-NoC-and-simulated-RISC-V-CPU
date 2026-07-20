module uart_tx #(
    parameter int DATA_WIDTH    = 8,
    parameter int CLK_FREQUENCY = 50_000_000,
    parameter int DIV           = 434
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic [DATA_WIDTH-1:0]  data_in,
    input  logic                   tx_start,
    output logic                   tx_busy,
    output logic                   tx_out
);

    typedef enum logic [1:0] {IDLE, START, TRANSFER, STOP} state_t;
    state_t state;

    logic [3:0]              bit_index;
    logic [DATA_WIDTH-1:0]   shift_reg;
    logic [$clog2(DIV)-1:0]  counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            bit_index <= '0;
            shift_reg <= '0;
            counter   <= '0;
            tx_busy   <= 1'b0;
            tx_out    <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    tx_busy   <= 1'b0;
                    tx_out    <= 1'b1;
                    counter   <= '0;
                    bit_index <= '0;
                    if (tx_start) begin
                        shift_reg <= data_in;
                        tx_busy   <= 1'b1;
                        state     <= START;
                    end
                end

                START: begin
                    tx_out <= 1'b0;
                    if (counter == DIV - 1) begin
                        counter <= '0;
                        state   <= TRANSFER;
                    end else
                        counter <= counter + 1'b1;
                end

                TRANSFER: begin
                    tx_out <= shift_reg[bit_index];
                    if (counter == DIV - 1) begin
                        counter <= '0;
                        if (bit_index == DATA_WIDTH - 1) state <= STOP;
                        else                             bit_index <= bit_index + 1'b1;
                    end else
                        counter <= counter + 1'b1;
                end

                STOP: begin
                    tx_out <= 1'b1;
                    if (counter == DIV - 1) begin
                        counter <= '0;
                        tx_busy <= 1'b0;
                        state   <= IDLE;
                    end else
                        counter <= counter + 1'b1;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
