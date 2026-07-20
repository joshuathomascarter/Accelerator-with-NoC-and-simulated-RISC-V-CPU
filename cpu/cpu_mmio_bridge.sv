module cpu_mmio_bridge #(
    parameter int DATA_WIDTH = cpu_pkg::CPU_XLEN
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // CPU load/store side. The core presents byte addresses; this bridge only
    // accepts aligned 32-bit MMIO accesses.
    input  logic                  cpu_rd_en,
    input  logic                  cpu_wr_en,
    input  logic [31:0]           cpu_addr,
    input  logic [DATA_WIDTH-1:0] cpu_wr_data,
    output logic [DATA_WIDTH-1:0] cpu_rd_data,
    output logic                  cpu_ready,
    output logic                  cpu_error,
    output logic                  mmio_hit,

    // Accelerator status/result inputs.
    input  logic                  accel_busy,
    input  logic                  accel_done,
    input  logic                  accel_result_valid,
    input  logic                  accel_overflow,
    input  logic [DATA_WIDTH-1:0] accel_result_data,
    input  logic [DATA_WIDTH-1:0] accel_error_flags,

    // Accelerator control/config outputs.
    output logic                  accel_start,
    output logic                  accel_clear,
    output logic                  accel_final_layer,
    output logic [DATA_WIDTH-1:0] accel_num_tiles,

    // Payload write pulses into the accelerator-side loaders.
    output logic                  accel_weight_wr_en,
    output logic [DATA_WIDTH-1:0] accel_weight_wr_data,
    output logic                  accel_act_wr_en,
    output logic [DATA_WIDTH-1:0] accel_act_wr_data,

    // One-cycle pulse when software reads the result register.
    output logic                  accel_result_rd_en
);
    import cpu_pkg::*;

    logic access_valid;
    logic word_aligned;
    logic known_addr;
    logic [DATA_WIDTH-1:0] status_word;

    assign access_valid = cpu_rd_en || cpu_wr_en;
    assign word_aligned = (cpu_addr[1:0] == 2'b00);
    assign mmio_hit     = ((cpu_addr & CPU_MMIO_ACCEL_MASK) == CPU_MMIO_ACCEL_BASE);

    always_comb begin
        known_addr = 1'b0;

        unique case (cpu_addr)
            CPU_MMIO_ACCEL_CTRL,
            CPU_MMIO_ACCEL_STATUS,
            CPU_MMIO_ACCEL_TILE_COUNT,
            CPU_MMIO_ACCEL_WEIGHT,
            CPU_MMIO_ACCEL_ACT,
            CPU_MMIO_ACCEL_RESULT,
            CPU_MMIO_ACCEL_ERROR: begin
                known_addr = 1'b1;
            end

            default: begin
                known_addr = 1'b0;
            end
        endcase
    end

    always_comb begin
        status_word = '0;
        status_word[CPU_MMIO_STATUS_BUSY_BIT]         = accel_busy;
        status_word[CPU_MMIO_STATUS_DONE_BIT]         = accel_done;
        status_word[CPU_MMIO_STATUS_RESULT_VALID_BIT] = accel_result_valid;
        status_word[CPU_MMIO_STATUS_OVERFLOW_BIT]     = accel_overflow;
    end

    always_comb begin
        cpu_rd_data = '0;

        unique case (cpu_addr)
            CPU_MMIO_ACCEL_CTRL: begin
                cpu_rd_data[CPU_MMIO_CTRL_FINAL_LAYER_BIT] = accel_final_layer;
            end

            CPU_MMIO_ACCEL_STATUS: begin
                cpu_rd_data = status_word;
            end

            CPU_MMIO_ACCEL_TILE_COUNT: begin
                cpu_rd_data = accel_num_tiles;
            end

            CPU_MMIO_ACCEL_RESULT: begin
                cpu_rd_data = accel_result_data;
            end

            CPU_MMIO_ACCEL_ERROR: begin
                cpu_rd_data = accel_error_flags;
            end

            default: begin
                cpu_rd_data = '0;
            end
        endcase
    end

    always_comb begin
        cpu_ready = access_valid && mmio_hit;
        cpu_error = access_valid && mmio_hit && (!word_aligned || !known_addr);
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accel_start          <= 1'b0;
            accel_clear          <= 1'b0;
            accel_final_layer    <= 1'b0;
            accel_num_tiles      <= '0;
            accel_weight_wr_en   <= 1'b0;
            accel_weight_wr_data <= '0;
            accel_act_wr_en      <= 1'b0;
            accel_act_wr_data    <= '0;
            accel_result_rd_en   <= 1'b0;
        end else begin
            accel_start        <= 1'b0;
            accel_clear        <= 1'b0;
            accel_weight_wr_en <= 1'b0;
            accel_act_wr_en    <= 1'b0;
            accel_result_rd_en <= 1'b0;

            if (access_valid && mmio_hit && word_aligned && known_addr) begin
                if (cpu_wr_en) begin
                    unique case (cpu_addr)
                        CPU_MMIO_ACCEL_CTRL: begin
                            accel_start       <= cpu_wr_data[CPU_MMIO_CTRL_START_BIT];
                            accel_clear       <= cpu_wr_data[CPU_MMIO_CTRL_CLEAR_BIT];
                            accel_final_layer <= cpu_wr_data[CPU_MMIO_CTRL_FINAL_LAYER_BIT];
                        end

                        CPU_MMIO_ACCEL_TILE_COUNT: begin
                            accel_num_tiles <= cpu_wr_data;
                        end

                        CPU_MMIO_ACCEL_WEIGHT: begin
                            accel_weight_wr_en   <= 1'b1;
                            accel_weight_wr_data <= cpu_wr_data;
                        end

                        CPU_MMIO_ACCEL_ACT: begin
                            accel_act_wr_en   <= 1'b1;
                            accel_act_wr_data <= cpu_wr_data;
                        end

                        default: begin
                            // Read-only and reserved registers ignore writes.
                        end
                    endcase
                end

                if (cpu_rd_en && (cpu_addr == CPU_MMIO_ACCEL_RESULT)) begin
                    accel_result_rd_en <= 1'b1;
                end
            end
        end
    end

endmodule
