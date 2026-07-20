module soc_real_chip_top #(
    parameter int INSTR_WIDTH = cpu_pkg::CPU_INSTR_W,
    parameter int IMEM_DEPTH  = 256,
    parameter int DMEM_DEPTH  = 256,
    parameter int GRID_W      = 2,
    parameter int GRID_H      = 2,
    parameter int ADDR_WIDTH  = 8,
    parameter int RESULT_WIDTH = 32
)(
    input  logic clk,
    input  logic rst_n,

    output logic [31:0] cpu_pc,
    output logic [31:0] cpu_mem_addr,
    output logic        cpu_mmio_error,

    output logic        chip_busy,
    output logic        chip_done,
    output logic        chip_result_valid,
    output logic [31:0] chip_result_data,
    output logic [31:0] chip_error_flags,
    output logic [31:0] accel_num_tiles
);
    import cpu_pkg::*;
    import noc_packet_pkg::*;

    localparam int TILE_COUNT = GRID_W * GRID_H;
    localparam logic [2:0] TILE_COUNT_3 = 3'(TILE_COUNT);

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
    logic                   cpu_mem_rd_en;
    logic                   cpu_mem_wr_en;
    logic                   mem_misaligned;
    logic                   dmem_rd_en;
    logic                   dmem_wr_en;
    logic                   mmio_rd_en;
    logic                   mmio_wr_en;
    logic                   mmio_addr_region;
    logic                   mmio_ready;
    logic                   cpu_mmio_hit;

    logic                   accel_start;
    logic                   accel_clear;
    logic                   accel_final_layer;
    logic                   accel_weight_wr_en;
    logic [31:0]            accel_weight_wr_data;
    logic                   accel_act_wr_en;
    logic [31:0]            accel_act_wr_data;
    logic                   accel_result_rd_en;

    logic [31:0]            weight_mem [TILE_COUNT];
    logic [31:0]            act_mem    [TILE_COUNT];
    logic [1:0]             weight_wr_idx;
    logic [1:0]             act_wr_idx;
    logic [2:0]             weight_write_count;
    logic [2:0]             act_write_count;

    logic                   chip_weight_full;
    logic                   chip_activation_full;
    logic                   chip_loopback_done;
    logic [RESULT_WIDTH-1:0] chip_weight_rd_data;
    logic [RESULT_WIDTH-1:0] chip_act_rd_data;
    logic [ADDR_WIDTH-1:0]  chip_weight_rd_addr;
    logic [ADDR_WIDTH-1:0]  chip_act_rd_addr;
    logic                   chip_weight_rd_en;
    logic                   chip_act_rd_en;
    logic                   chip_weight_bank_sel;
    logic                   chip_act_bank_sel;
    logic                   chip_loopback_start;
    logic [31:0]            chip_loopback_words;
    logic                   chip_output_valid;
    logic                   chip_done_q;
    logic                   chip_result_valid_q;
    logic [TILE_COUNT-1:0]  chip_tile_done;
    logic [TILE_COUNT-1:0]  chip_overflow_hazard;
    logic [TILE_COUNT-1:0]  chip_tile_result_valid;
    noc_packet_t            chip_tile_result_packet [TILE_COUNT];
    logic                   chip_result_wr_en;
    logic [ADDR_WIDTH-1:0]  chip_result_wr_addr;
    logic [RESULT_WIDTH-1:0] chip_result_wr_data;
    logic [TILE_COUNT-1:0]  chip_tile_occupied;

    assign mmio_addr_region = ((cpu_mem_addr & CPU_MMIO_ACCEL_MASK) == CPU_MMIO_ACCEL_BASE);
    assign dmem_rd_en       = cpu_mem_rd_en && !mmio_addr_region;
    assign dmem_wr_en       = cpu_mem_wr_en && !mmio_addr_region;
    assign mmio_rd_en       = cpu_mem_rd_en && mmio_addr_region;
    assign mmio_wr_en       = cpu_mem_wr_en && mmio_addr_region;
    assign cpu_mem_rd_data  = mmio_addr_region ? mmio_rd_data : dmem_rd_data;

    assign chip_weight_rd_data = weight_mem[chip_weight_rd_addr[1:0]];
    assign chip_act_rd_data    = act_mem[chip_act_rd_addr[1:0]];
    assign chip_error_flags    = {28'd0, chip_overflow_hazard};
    assign chip_done           = chip_done_q;
    assign chip_result_valid   = chip_result_valid_q;
    assign chip_loopback_done  = 1'b0;

    cpu_imem #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .DEPTH(IMEM_DEPTH),
        .INIT_FILE("Tests/CPU/cpu_real_chip_program.hex")
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
        .accel_busy(chip_busy),
        .accel_done(chip_done),
        .accel_result_valid(chip_result_valid),
        .accel_overflow(|chip_overflow_hazard),
        .accel_result_data(chip_result_data),
        .accel_error_flags(chip_error_flags),
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

    chip_top #(
        .GRID_W(GRID_W),
        .GRID_H(GRID_H),
        .ADDR_WIDTH(ADDR_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) u_chip (
        .clk(clk),
        .rst_n(rst_n),
        .num_tiles(accel_num_tiles),
        .final_layer(accel_final_layer),
        .act_last(1'b0),
        .weight_last(1'b0),
        .weight_full(chip_weight_full),
        .activation_full(chip_activation_full),
        .loopback_done(chip_loopback_done),
        .weight_rd_data(chip_weight_rd_data),
        .act_rd_data(chip_act_rd_data),
        .weight_rd_addr(chip_weight_rd_addr),
        .act_rd_addr(chip_act_rd_addr),
        .weight_rd_en(chip_weight_rd_en),
        .act_rd_en(chip_act_rd_en),
        .weight_bank_sel(chip_weight_bank_sel),
        .act_bank_sel(chip_act_bank_sel),
        .loopback_start(chip_loopback_start),
        .loopback_words(chip_loopback_words),
        .output_valid(chip_output_valid),
        .start(1'b0),
        .clear(accel_clear),
        .compute_en(1'b0),
        .reduce_en(1'b0),
        .activation_data('0),
        .done(chip_tile_done),
        .overflow_hazard(chip_overflow_hazard),
        .tile_result_valid(chip_tile_result_valid),
        .tile_result_packet(chip_tile_result_packet),
        .result_wr_en(chip_result_wr_en),
        .result_wr_addr(chip_result_wr_addr),
        .result_wr_data(chip_result_wr_data),
        .tile_occupied(chip_tile_occupied)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_wr_idx        <= '0;
            act_wr_idx           <= '0;
            weight_write_count   <= '0;
            act_write_count      <= '0;
            chip_weight_full     <= 1'b0;
            chip_activation_full <= 1'b0;
            chip_busy            <= 1'b0;
            chip_done_q          <= 1'b0;
            chip_result_valid_q  <= 1'b0;
            chip_result_data     <= '0;
            for (int i = 0; i < TILE_COUNT; i++) begin
                weight_mem[i] <= '0;
                act_mem[i]    <= '0;
            end
        end else begin
            if (accel_clear) begin
                weight_wr_idx        <= '0;
                act_wr_idx           <= '0;
                weight_write_count   <= '0;
                act_write_count      <= '0;
                chip_weight_full     <= 1'b0;
                chip_activation_full <= 1'b0;
                chip_busy            <= 1'b0;
                chip_done_q          <= 1'b0;
                chip_result_valid_q  <= 1'b0;
                chip_result_data     <= '0;
            end else begin
                if (accel_weight_wr_en) begin
                    weight_mem[weight_wr_idx] <= accel_weight_wr_data;
                    weight_wr_idx             <= weight_wr_idx + 1'b1;
                    if (weight_write_count < TILE_COUNT_3) begin
                        weight_write_count <= weight_write_count + 1'b1;
                    end
                end

                if (accel_act_wr_en) begin
                    act_mem[act_wr_idx] <= accel_act_wr_data;
                    act_wr_idx          <= act_wr_idx + 1'b1;
                    if (act_write_count < TILE_COUNT_3) begin
                        act_write_count <= act_write_count + 1'b1;
                    end
                end

                if (accel_start) begin
                    chip_weight_full     <= (weight_write_count >= TILE_COUNT_3);
                    chip_activation_full <= (act_write_count >= TILE_COUNT_3);
                    chip_busy            <= 1'b1;
                    chip_done_q          <= 1'b0;
                    chip_result_valid_q  <= 1'b0;
                end

                if (chip_result_wr_en) begin
                    chip_result_data <= chip_result_wr_data;
                end

                if (chip_output_valid) begin
                    chip_busy           <= 1'b0;
                    chip_done_q         <= 1'b1;
                    chip_result_valid_q <= 1'b1;
                end
            end
        end
    end

endmodule
