module cmd_decoder
    import isa_pkg::*;
#(
    parameter int DATA_WIDTH      = 32,
    parameter int ADDR_W          = 4,
    parameter int TIME_OUT_CYCLES = 5000
)(
    input  logic                   clk,
    input  logic                   rst_n,

    // Byte stream from uart_rx
    input  logic [7:0]             rx_byte,
    input  logic                   rx_valid,

    // Register file — write port (CSR only)
    output logic                   rf_wr_en,
    output logic [ADDR_W-1:0]      rf_wr_addr,
    output logic [DATA_WIDTH-1:0]  rf_wr_data,

    // Register file — read port A (CSR read)
    output logic [ADDR_W-1:0]      rf_rd_addr_a,
    input  logic [DATA_WIDTH-1:0]  rf_rd_data_a,

    // Weight SRAM — write side (auto-increment)
    output logic                   weight_wr_en,
    output logic [DATA_WIDTH-1:0]  weight_wr_data,
    output logic                   weight_last,

    // Activation SRAM — write side (auto-increment)
    output logic                   act_wr_en,
    output logic [DATA_WIDTH-1:0]  act_wr_data,
    output logic                   act_last,

    // One-cycle pulse when any command finishes
    output logic                   done,

    // UART readback for CSR reads
    output logic                   packer_start,
    output logic [DATA_WIDTH-1:0]  packer_data,
    input  logic                   packer_busy,
    
    // SRAM Full Status
    input logic weights_full,
    input logic activations_full,
    input logic activation_write_blocked,
    // UART Framing Error Status
    input logic framing_error,

    // CSR Status
    output logic [4:0] error_status
);

    typedef enum logic [9:0] {
        ST_FETCH_B0         = 10'b0000000001,  // wait for opcode byte
        ST_FETCH_B1         = 10'b0000000010,  // wait for operand byte 1
        ST_FETCH_B2         = 10'b0000000100,  // wait for operand byte 2
        ST_FETCH_B3         = 10'b0000001000,  // wait for operand byte 3 — instruction complete
        ST_DATA0            = 10'b0000010000,  // receive data byte 0 (LSB)
        ST_DATA1            = 10'b0000100000,  // receive data byte 1
        ST_DATA2            = 10'b0001000000,  // receive data byte 2
        ST_DATA3            = 10'b0010000000,  // receive data byte 3 (MSB) → route by opcode
        ST_WRITE_EXEC       = 10'b0100000000,  // pulse rf_wr_en for CSR write
        ST_READ_EXEC        = 10'b1000000000   // pulse packer_start for CSR read
    } state_t;

    state_t state;
    instr_t instr;
    logic [31:0]          instr_shift;
    logic [DATA_WIDTH-1:0] write_data;

    logic [$clog2(TIME_OUT_CYCLES) -1:0] timeout_cnt;
    logic [4:0] err_reg;

    assign error_status = err_reg;

    // Write address always comes from rd field
    assign rf_wr_addr  = instr.rd;
    assign rf_rd_addr_a = instr.rd;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state              <= ST_FETCH_B0;
            instr              <= '0;
            instr_shift        <= '0;
            write_data         <= '0;
            rf_wr_en           <= 1'b0;
            rf_wr_data         <= '0;
            weight_wr_en       <= 1'b0;
            weight_wr_data     <= '0;
            weight_last        <= 1'b0;
            act_wr_en          <= 1'b0;
            act_wr_data        <= '0;
            act_last           <= 1'b0;
            done               <= 1'b0;
            packer_start       <= 1'b0;
            packer_data        <= '0;
            err_reg            <= '0;
            timeout_cnt        <= '0;
        end else begin
            // Default: deassert all one-cycle pulses
            rf_wr_en           <= 1'b0;
            weight_wr_en       <= 1'b0;
            weight_last        <= 1'b0;
            act_wr_en          <= 1'b0;
            act_last           <= 1'b0;
            done               <= 1'b0;
            packer_start       <= 1'b0;
            timeout_cnt        <= timeout_cnt + 1'b1;

            if (framing_error) err_reg[4] <= 1'b1;

            case (state)
                // ── Instruction fetch (4 bytes, MSB first) ────────────────
                ST_FETCH_B0: if(timeout_cnt >= TIME_OUT_CYCLES) begin
                    err_reg[1] <= 1'b1;
                    state <= ST_FETCH_B0;
                    timeout_cnt <= '0;
            end else if (rx_valid) begin
                    instr_shift[31:24] <= rx_byte;
                    timeout_cnt <= '0;
                    state <= ST_FETCH_B1;
                end

                ST_FETCH_B1: if(timeout_cnt >= TIME_OUT_CYCLES) begin
                    err_reg[1] <= 1'b1;
                    state <= ST_FETCH_B0;
                    timeout_cnt <= '0;
                end else if (rx_valid) begin
                    instr_shift[23:16] <= rx_byte;
                    timeout_cnt <= '0;
                    state <= ST_FETCH_B2;
                end

                ST_FETCH_B2: if(timeout_cnt >= TIME_OUT_CYCLES) begin
                    err_reg[1] <= 1'b1;
                    state <= ST_FETCH_B0;
                    timeout_cnt <= '0; 
                end else if (rx_valid) begin
                    instr_shift[15:8] <= rx_byte;
                    timeout_cnt <= '0;
                    state <= ST_FETCH_B3;
                end

                ST_FETCH_B3: if(timeout_cnt >= TIME_OUT_CYCLES) begin
                    err_reg[1] <= 1'b1;
                    state <= ST_FETCH_B0;
                    timeout_cnt <= '0;
                end else if (rx_valid) begin
                    // Assemble the complete instruction
                    timeout_cnt <= '0;
                    instr <= instr_t'({instr_shift[31:8], rx_byte});

                    // Decode opcode (from the already-captured high byte)
                    case (opcode_t'(instr_shift[31:24]))
                        OP_WRITE_CSR:        state <= ST_DATA0;
                        OP_WRITE_WEIGHT:     state <= ST_DATA0;
                        OP_WRITE_ACTIVATION: state <= ST_DATA0;
                        OP_LAST_WEIGHT:      begin
                            weight_last <= 1'b1;
                            state <= ST_FETCH_B0;
                        end
                        OP_LAST_ACTIVATION:  begin
                            act_last <= 1'b1;
                            state <= ST_FETCH_B0;
                        end
                        OP_READ_CSR:     state <= ST_READ_EXEC;
                        default: begin            
                            state <= ST_FETCH_B0;
                            err_reg[0] <= 1'b1;
                        end
                    endcase
                end

                // ── Data receive: 4 bytes (used by WRITE_CSR, WRITE_WEIGHT, WRITE_ACTIVATION) ────
                ST_DATA0:if(timeout_cnt >= TIME_OUT_CYCLES) begin
                    err_reg[1] <= 1'b1;
                    state <= ST_FETCH_B0;
                    timeout_cnt <= '0;
                end else if (rx_valid) begin
                    write_data[7:0] <= rx_byte;
                    timeout_cnt <= '0;
                    state <= ST_DATA1;
                end

                ST_DATA1: if(timeout_cnt >= TIME_OUT_CYCLES) begin
                    err_reg[1] <= 1'b1;
                    state <= ST_FETCH_B0;
                    timeout_cnt <= '0;
                end else if (rx_valid) begin
                    write_data[15:8] <= rx_byte;
                    timeout_cnt <= '0;
                    state <= ST_DATA2;
                end

                ST_DATA2:if(timeout_cnt >= TIME_OUT_CYCLES) begin
                    err_reg[1] <= 1'b1;
                    state <= ST_FETCH_B0;
                    timeout_cnt <= '0; 
                end else if (rx_valid) begin
                    write_data[23:16] <= rx_byte;
                    timeout_cnt <= '0;
                    state <= ST_DATA3;
                end

                ST_DATA3: if(timeout_cnt >= TIME_OUT_CYCLES) begin
                    err_reg[1] <= 1'b1;
                    state <= ST_FETCH_B0;
                    timeout_cnt <= '0;
                end else if (rx_valid) begin
                    write_data[31:24] <= rx_byte;
                    timeout_cnt <= '0;

                    // Route by opcode
                    case (instr.opcode)
                        OP_WRITE_CSR: begin
                            state <= ST_WRITE_EXEC;
                        end
                        OP_WRITE_WEIGHT: begin
                            if (!weights_full) begin
                                weight_wr_en   <= 1'b1;
                                weight_wr_data <= write_data;
                                done           <= 1'b1;
                            end else begin
                                err_reg[2] <= 1'b1;
                            end
                            state <= ST_FETCH_B0;
                        end

                        OP_WRITE_ACTIVATION: begin
                            if (activation_write_blocked) begin
                                err_reg[2] <= 1'b1;
                            end else if (!activations_full) begin
                                act_wr_en   <= 1'b1;
                                act_wr_data <= write_data;
                                done        <= 1'b1;
                            end else begin
                                err_reg[2] <= 1'b1;
                            end
                            state <= ST_FETCH_B0;
                        end

                        default: begin
                            err_reg[0] <= 1'b1;
                            state <= ST_FETCH_B0;
                        end
                    endcase
                end

                // ── CSR write: pulse rf_wr_en ────────────────────────────
                ST_WRITE_EXEC: begin
                    if (instr.rd == 4'hF) begin
                        err_reg <= 5'b0;
                    end else begin
                        rf_wr_en   <= 1'b1;
                        rf_wr_data <= write_data;
                    end
                    done  <= 1'b1;
                    state <= ST_FETCH_B0;
                end

                // ── CSR readback: pulse packer_start when the UART path is free ───
                ST_READ_EXEC: begin
                    if (!packer_busy) begin
                        packer_start <= 1'b1;
                        packer_data  <= rf_rd_data_a;
                        done         <= 1'b1;
                        state        <= ST_FETCH_B0;
                    end
                end

            endcase
        end
    end

endmodule
