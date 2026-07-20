module soc_top #(
    parameter int INSTR_WIDTH = cpu_pkg::CPU_INSTR_W,
    parameter int IMEM_DEPTH  = 256,
    parameter int DMEM_DEPTH  = 256,
    parameter bit USE_INTERNAL_ACCEL_MODEL = 1'b0,
    parameter int ACCEL_MODEL_LATENCY = 4
)(
    input  logic clk,
    input  logic rst_n,

    // Accelerator-side status/result inputs. In the full system these come
    // from chip_top; in the June 9 testbench they are driven directly.
    input  logic                  accel_busy_i,
    input  logic                  accel_done_i,
    input  logic                  accel_result_valid_i,
    input  logic                  accel_overflow_i,
    input  logic [31:0]           accel_result_data_i,
    input  logic [31:0]           accel_error_flags_i,

    // Accelerator-facing control/data outputs from the MMIO bridge.
    output logic                  accel_start,
    output logic                  accel_clear,
    output logic                  accel_final_layer,
    output logic [31:0]           accel_num_tiles,
    output logic                  accel_weight_wr_en,
    output logic [31:0]           accel_weight_wr_data,
    output logic                  accel_act_wr_en,
    output logic [31:0]           accel_act_wr_data,
    output logic                  accel_result_rd_en,

    // Bring-up visibility.
    output logic [31:0]           cpu_pc,
    output logic [31:0]           cpu_mem_addr,
    output logic                  cpu_mem_rd_en,
    output logic                  cpu_mem_wr_en,
    output logic                  cpu_mmio_hit,
    output logic                  cpu_mmio_error
);
    import cpu_pkg::*;

    logic [INSTR_WIDTH-1:0] instruction;
    logic [31:0]            cpu_next_pc;
    logic [INSTR_WIDTH-1:0] current_instruction;
    cpu_inst_t              decoded_inst;
    logic [31:0]            alu_result;
    logic [31:0]            cpu_mem_wr_data;
    logic [31:0]            cpu_mem_rd_data;
    logic [31:0]            dmem_rd_data;
    logic [31:0]            mmio_rd_data;
    logic                   reg_wr_en;
    logic [4:0]             reg_wr_addr;
    logic [31:0]            reg_wr_data;
    logic                   mem_misaligned;
    logic                   dmem_rd_en;
    logic                   dmem_wr_en;
    logic                   mmio_rd_en;
    logic                   mmio_wr_en;
    logic                   mmio_addr_region;
    logic                   mmio_ready;
    logic                   model_busy;
    logic                   model_done;
    logic                   model_result_valid;
    logic                   model_overflow;
    logic [31:0]            model_result_data;
    logic [31:0]            model_error_flags;
    logic [31:0]            selected_accel_result_data;
    logic [31:0]            selected_accel_error_flags;
    logic [7:0]             accel_model_counter;

    assign mmio_addr_region = ((cpu_mem_addr & CPU_MMIO_ACCEL_MASK) == CPU_MMIO_ACCEL_BASE);
    assign dmem_rd_en       = cpu_mem_rd_en && !mmio_addr_region;
    assign dmem_wr_en       = cpu_mem_wr_en && !mmio_addr_region;
    assign mmio_rd_en       = cpu_mem_rd_en && mmio_addr_region;
    assign mmio_wr_en       = cpu_mem_wr_en && mmio_addr_region;
    assign cpu_mem_rd_data  = mmio_addr_region ? mmio_rd_data : dmem_rd_data;
    assign selected_accel_result_data = USE_INTERNAL_ACCEL_MODEL ?
        model_result_data : accel_result_data_i;
    assign selected_accel_error_flags = USE_INTERNAL_ACCEL_MODEL ?
        model_error_flags : accel_error_flags_i;

    cpu_imem #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .DEPTH(IMEM_DEPTH),
        .INIT_FILE("Tests/CPU/cpu_mmio_program.hex")
    ) u_imem (
        .pc(cpu_pc),
        .instruction(instruction)
    );

    cpu_core #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .DMEM_DEPTH(DMEM_DEPTH)
    ) u_cpu (
        .clk(clk),
        .rst_n(rst_n),
        .instruction(instruction),
        .pc(cpu_pc),
        .next_pc(cpu_next_pc),
        .current_instruction(current_instruction),
        .decoded_inst(decoded_inst),
        .alu_result(alu_result),
        .dmem_rd_data(cpu_mem_rd_data),
        .reg_wr_en(reg_wr_en),
        .reg_wr_addr(reg_wr_addr),
        .reg_wr_data(reg_wr_data),
        .dmem_rd_en(cpu_mem_rd_en),
        .dmem_wr_en(cpu_mem_wr_en),
        .dmem_addr(cpu_mem_addr),
        .dmem_wr_data(cpu_mem_wr_data),
        .mem_misaligned(mem_misaligned)
    );

    cpu_dmem #(
        .DATA_WIDTH(CPU_XLEN),
        .DEPTH(DMEM_DEPTH)
    ) u_dmem (
        .clk(clk),
        .rst_n(rst_n),
        .rd_en(dmem_rd_en),
        .wr_en(dmem_wr_en),
        .addr(cpu_mem_addr),
        .wr_data(cpu_mem_wr_data),
        .rd_data(dmem_rd_data)
    );

    cpu_mmio_bridge u_mmio_bridge (
        .clk(clk),
        .rst_n(rst_n),
        .cpu_rd_en(mmio_rd_en),
        .cpu_wr_en(mmio_wr_en),
        .cpu_addr(cpu_mem_addr),
        .cpu_wr_data(cpu_mem_wr_data),
        .cpu_rd_data(mmio_rd_data),
        .cpu_ready(mmio_ready),
        .cpu_error(cpu_mmio_error),
        .mmio_hit(cpu_mmio_hit),
        .accel_busy(USE_INTERNAL_ACCEL_MODEL ? model_busy : accel_busy_i),
        .accel_done(USE_INTERNAL_ACCEL_MODEL ? model_done : accel_done_i),
        .accel_result_valid(USE_INTERNAL_ACCEL_MODEL ? model_result_valid : accel_result_valid_i),
        .accel_overflow(USE_INTERNAL_ACCEL_MODEL ? model_overflow : accel_overflow_i),
        .accel_result_data(selected_accel_result_data),
        .accel_error_flags(selected_accel_error_flags),
        .accel_start(accel_start),
        .accel_clear(accel_clear),
        .accel_final_layer(accel_final_layer),
        .accel_num_tiles(accel_num_tiles),
        .accel_weight_wr_en(accel_weight_wr_en),
        .accel_weight_wr_data(accel_weight_wr_data),
        .accel_act_wr_en(accel_act_wr_en),
        .accel_act_wr_data(accel_act_wr_data),
        .accel_result_rd_en(accel_result_rd_en)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            model_busy         <= 1'b0;
            model_done         <= 1'b0;
            model_result_valid <= 1'b0;
            model_overflow     <= 1'b0;
            model_result_data  <= '0;
            model_error_flags  <= '0;
            accel_model_counter <= '0;
        end else if (USE_INTERNAL_ACCEL_MODEL) begin
            if (accel_clear) begin
                model_busy         <= 1'b0;
                model_done         <= 1'b0;
                model_result_valid <= 1'b0;
                model_overflow     <= 1'b0;
                model_result_data  <= '0;
                model_error_flags  <= '0;
                accel_model_counter <= '0;
            end else if (accel_start) begin
                model_busy         <= 1'b1;
                model_done         <= 1'b0;
                model_result_valid <= 1'b0;
                model_overflow     <= 1'b0;
                model_error_flags  <= '0;
                accel_model_counter <= ACCEL_MODEL_LATENCY[7:0];
            end else if (model_busy) begin
                if (accel_model_counter == 8'd0) begin
                    model_busy         <= 1'b0;
                    model_done         <= 1'b1;
                    model_result_valid <= 1'b1;
                    model_result_data  <= 32'hACCE_0000 | accel_num_tiles[15:0];
                end else begin
                    accel_model_counter <= accel_model_counter - 1'b1;
                end
            end else if (accel_result_rd_en) begin
                model_done         <= 1'b0;
                model_result_valid <= 1'b0;
            end
        end
    end

endmodule
