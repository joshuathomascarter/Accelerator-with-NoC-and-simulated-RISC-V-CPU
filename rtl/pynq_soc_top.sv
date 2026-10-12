// Board top level: the accelerator plus the RISC-V-style CPU that can drive it.
//
// AXI-Lite map (byte offsets from the base address, 8 KB):
//   0x0000-0x003C  accelerator registers (docs/PYNQ_REGISTER_MAP.md), host path
//   0x0100         SOC_CTRL    bit0 cpu_run: 1 releases the CPU from reset and gives
//                              it the accelerator; 0 holds it in reset (host owns it)
//   0x0104         SOC_STATUS  bit0 cpu_run, bit1 sticky CPU MMIO error
//   0x0108         CPU_PC      current CPU program counter
//   0x0400-0x07FC  CPU instruction memory, 256 words (write only while cpu_run = 0)
//   0x1000-0x1FFC  CPU data memory, 1024 words (CPU byte address 0x000-0xFFC)
//
// The CPU sees its data memory at 0x0000_0000 and the accelerator at
// 0x8000_0000 (cpu/docs/CPU_MMIO_MAP.md), plus the LED register at 0x8000_001C.
module pynq_soc_top #(
    // Literal defaults: Vivado block-design module references cannot evaluate
    // package-qualified parameter defaults.
    parameter int AXI_ADDR_W = 13,
    parameter int AXI_DATA_W = 32,
    parameter int IMEM_WORDS = 256,
    parameter int DMEM_WORDS = 1024
)(
    input  logic                      s_axi_aclk,
    input  logic                      s_axi_aresetn,
    input  logic [AXI_ADDR_W-1:0]     s_axi_awaddr,
    input  logic                      s_axi_awvalid,
    output logic                      s_axi_awready,
    input  logic [AXI_DATA_W-1:0]     s_axi_wdata,
    input  logic [(AXI_DATA_W/8)-1:0] s_axi_wstrb,
    input  logic                      s_axi_wvalid,
    output logic                      s_axi_wready,
    output logic [1:0]                s_axi_bresp,
    output logic                      s_axi_bvalid,
    input  logic                      s_axi_bready,
    input  logic [AXI_ADDR_W-1:0]     s_axi_araddr,
    input  logic                      s_axi_arvalid,
    output logic                      s_axi_arready,
    output logic [AXI_DATA_W-1:0]     s_axi_rdata,
    output logic [1:0]                s_axi_rresp,
    output logic                      s_axi_rvalid,
    input  logic                      s_axi_rready,
    output logic [3:0]                leds
);
    import cpu_pkg::*;

    localparam int IMEM_AW = $clog2(IMEM_WORDS);
    localparam int DMEM_AW = $clog2(DMEM_WORDS);

    wire clk = s_axi_aclk;
    wire rst_n = s_axi_aresetn;

    // ---------------------------------------------------------------- host side
    logic host_start, host_clear, host_final_layer;
    logic [31:0] host_tile_count;
    logic host_weight_wr_en, host_act_wr_en, host_result_rd_en;
    logic [31:0] host_weight_wr_data, host_act_wr_data;
    logic [3:0] host_led;
    logic [7:0] tile_select, packet_type;
    logic [31:0] packet_payload;
    logic packet_valid;
    logic [31:0] dma_src_addr, dma_dst_addr, dma_length;
    logic ext_wr_en;
    logic [AXI_ADDR_W-1:0] ext_wr_addr, ext_rd_addr;
    logic [31:0] ext_wr_data, ext_rd_data;

    // ---------------------------------------------------------------- CPU side
    logic cpu_run_q, cpu_error_q;
    logic cpu_rst_n;
    logic [31:0] cpu_pc, cpu_next_pc, instruction, current_instruction;
    cpu_inst_t decoded_inst;
    logic [31:0] alu_result;
    logic reg_wr_en;
    logic [4:0] reg_wr_addr;
    logic [31:0] reg_wr_data;
    logic cpu_mem_rd_en, cpu_mem_wr_en, mem_misaligned;
    logic [31:0] cpu_mem_addr, cpu_mem_wr_data, cpu_mem_rd_data;
    logic mmio_region, led_addr, mmio_rd_en, mmio_wr_en;
    logic [31:0] mmio_rd_data;
    logic mmio_ready, mmio_error, mmio_hit;
    logic [3:0] cpu_led_q;

    logic cpu_start, cpu_clear, cpu_final_layer;
    logic [31:0] cpu_tile_count;
    logic cpu_weight_wr_en, cpu_act_wr_en, cpu_result_rd_en;
    logic [31:0] cpu_weight_wr_data, cpu_act_wr_data;

    // ---------------------------------------------------------------- accelerator
    logic busy, run_done, result_valid, overflow, protocol_error;
    logic [31:0] result_data, error_flags;

    // ---------------------------------------------------------------- memories
    // No reset on the arrays so Vivado maps them to distributed RAM.
    logic [31:0] imem [IMEM_WORDS];
    logic [31:0] dmem [DMEM_WORDS];

    initial begin
        for (int i = 0; i < IMEM_WORDS; i++) imem[i] = '0;
        for (int i = 0; i < DMEM_WORDS; i++) dmem[i] = '0;
    end

    wire host_imem_wr = ext_wr_en && (ext_wr_addr[12:10] == 3'b001);   // 0x0400-0x07FF
    wire host_dmem_wr = ext_wr_en && ext_wr_addr[12];                   // 0x1000-0x1FFF
    wire cpu_dmem_hit = !mmio_region && ((cpu_mem_addr >> 2) < DMEM_WORDS) && !mem_misaligned;

    // Plain always (not always_ff) because the initial block also writes the arrays.
    always @(posedge clk) begin
        if (host_imem_wr && !cpu_run_q) imem[ext_wr_addr[IMEM_AW+1:2]] <= ext_wr_data;
        if (cpu_run_q) begin
            if (cpu_mem_wr_en && cpu_dmem_hit) dmem[cpu_mem_addr[DMEM_AW+1:2]] <= cpu_mem_wr_data;
        end else if (host_dmem_wr) begin
            dmem[ext_wr_addr[DMEM_AW+1:2]] <= ext_wr_data;
        end
    end

    assign instruction = ((cpu_pc >> 2) < IMEM_WORDS) ? imem[cpu_pc[IMEM_AW+1:2]] : '0;

    // ---------------------------------------------------------------- SOC registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cpu_run_q   <= 1'b0;
            cpu_error_q <= 1'b0;
        end else begin
            if (ext_wr_en && ext_wr_addr == 13'h0100) begin
                cpu_run_q <= ext_wr_data[0];
                if (ext_wr_data[0] && !cpu_run_q) cpu_error_q <= 1'b0;
            end
            if (cpu_run_q && mmio_error) cpu_error_q <= 1'b1;
        end
    end

    always_comb begin
        ext_rd_data = '0;
        if (ext_rd_addr[12]) begin
            ext_rd_data = dmem[ext_rd_addr[DMEM_AW+1:2]];
        end else if (ext_rd_addr[12:10] == 3'b001) begin
            ext_rd_data = imem[ext_rd_addr[IMEM_AW+1:2]];
        end else begin
            unique case (ext_rd_addr)
                13'h0100: ext_rd_data = {31'd0, cpu_run_q};
                13'h0104: ext_rd_data = {30'd0, cpu_error_q, cpu_run_q};
                13'h0108: ext_rd_data = cpu_pc;
                default:  ext_rd_data = '0;
            endcase
        end
    end

    // ---------------------------------------------------------------- AXI-Lite shell
    pynq_accel_axi_lite #(.AXI_ADDR_W(AXI_ADDR_W), .AXI_DATA_W(AXI_DATA_W)) u_axi (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awaddr(s_axi_awaddr), .s_axi_awvalid(s_axi_awvalid), .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata), .s_axi_wstrb(s_axi_wstrb), .s_axi_wvalid(s_axi_wvalid), .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp), .s_axi_bvalid(s_axi_bvalid), .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr), .s_axi_arvalid(s_axi_arvalid), .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata), .s_axi_rresp(s_axi_rresp), .s_axi_rvalid(s_axi_rvalid), .s_axi_rready(s_axi_rready),
        .accel_busy(busy), .accel_done(run_done), .accel_result_valid(result_valid),
        .accel_overflow(overflow), .accel_result_data(result_data), .accel_error_flags(error_flags),
        .packet_ready(1'b0), .accel_start(host_start), .accel_clear(host_clear),
        .accel_final_layer(host_final_layer), .accel_tile_count(host_tile_count),
        .accel_weight_wr_en(host_weight_wr_en), .accel_weight_wr_data(host_weight_wr_data),
        .accel_act_wr_en(host_act_wr_en), .accel_act_wr_data(host_act_wr_data),
        .accel_result_rd_en(host_result_rd_en),
        .led_mirror(host_led), .tile_select(tile_select), .packet_type(packet_type),
        .packet_payload(packet_payload), .packet_valid(packet_valid),
        .dma_src_addr(dma_src_addr), .dma_dst_addr(dma_dst_addr), .dma_length(dma_length),
        .ext_wr_en(ext_wr_en), .ext_wr_addr(ext_wr_addr), .ext_wr_data(ext_wr_data),
        .ext_rd_addr(ext_rd_addr), .ext_rd_data(ext_rd_data)
    );

    // ---------------------------------------------------------------- CPU
    assign cpu_rst_n = rst_n && cpu_run_q;

    cpu_core #(.INSTR_WIDTH(32)) u_cpu (
        .clk(clk), .rst_n(cpu_rst_n),
        .instruction(instruction), .pc(cpu_pc), .next_pc(cpu_next_pc),
        .current_instruction(current_instruction), .decoded_inst(decoded_inst),
        .alu_result(alu_result), .dmem_rd_data(cpu_mem_rd_data),
        .reg_wr_en(reg_wr_en), .reg_wr_addr(reg_wr_addr), .reg_wr_data(reg_wr_data),
        .dmem_rd_en(cpu_mem_rd_en), .dmem_wr_en(cpu_mem_wr_en), .dmem_addr(cpu_mem_addr),
        .dmem_wr_data(cpu_mem_wr_data), .mem_misaligned(mem_misaligned)
    );

    assign mmio_region = ((cpu_mem_addr & CPU_MMIO_ACCEL_MASK) == CPU_MMIO_ACCEL_BASE);
    assign led_addr    = (cpu_mem_addr == CPU_MMIO_LED);
    assign mmio_rd_en  = cpu_mem_rd_en && mmio_region && !led_addr;   // LED is handled here,
    assign mmio_wr_en  = cpu_mem_wr_en && mmio_region && !led_addr;   // not by the bridge
    assign cpu_mem_rd_data = mmio_region ? (led_addr ? {28'd0, cpu_led_q} : mmio_rd_data)
                                         : (cpu_dmem_hit ? dmem[cpu_mem_addr[DMEM_AW+1:2]] : '0);

    always_ff @(posedge clk or negedge cpu_rst_n) begin
        if (!cpu_rst_n) begin
            cpu_led_q <= '0;
        end else if (cpu_mem_wr_en && led_addr) begin
            cpu_led_q <= cpu_mem_wr_data[3:0];
        end
    end

    cpu_mmio_bridge u_bridge (
        .clk(clk), .rst_n(cpu_rst_n),
        .cpu_rd_en(mmio_rd_en), .cpu_wr_en(mmio_wr_en), .cpu_addr(cpu_mem_addr),
        .cpu_wr_data(cpu_mem_wr_data), .cpu_rd_data(mmio_rd_data),
        .cpu_ready(mmio_ready), .cpu_error(mmio_error), .mmio_hit(mmio_hit),
        .accel_busy(busy), .accel_done(run_done), .accel_result_valid(result_valid),
        .accel_overflow(overflow), .accel_result_data(result_data), .accel_error_flags(error_flags),
        .accel_start(cpu_start), .accel_clear(cpu_clear), .accel_final_layer(cpu_final_layer),
        .accel_num_tiles(cpu_tile_count),
        .accel_weight_wr_en(cpu_weight_wr_en), .accel_weight_wr_data(cpu_weight_wr_data),
        .accel_act_wr_en(cpu_act_wr_en), .accel_act_wr_data(cpu_act_wr_data),
        .accel_result_rd_en(cpu_result_rd_en)
    );

    // ---------------------------------------------------------------- accelerator, owned by
    // the CPU while cpu_run = 1 and by the host otherwise
    accel_core u_core (
        .clk(clk), .rst_n(rst_n),
        .start         (cpu_run_q ? cpu_start          : host_start),
        .clear         (cpu_run_q ? cpu_clear          : host_clear),
        .final_layer   (cpu_run_q ? cpu_final_layer    : host_final_layer),
        .tile_count    (cpu_run_q ? cpu_tile_count     : host_tile_count),
        .weight_wr_en  (cpu_run_q ? cpu_weight_wr_en   : host_weight_wr_en),
        .weight_wr_data(cpu_run_q ? cpu_weight_wr_data : host_weight_wr_data),
        .act_wr_en     (cpu_run_q ? cpu_act_wr_en      : host_act_wr_en),
        .act_wr_data   (cpu_run_q ? cpu_act_wr_data    : host_act_wr_data),
        .result_rd_en  (cpu_run_q ? cpu_result_rd_en   : host_result_rd_en),
        .protocol_violation(!cpu_run_q && packet_valid),
        .busy(busy), .done(run_done), .result_valid(result_valid), .overflow(overflow),
        .result_data(result_data), .error_flags(error_flags), .protocol_error(protocol_error)
    );

    assign leds = cpu_run_q ? cpu_led_q
                            : (host_led | {run_done, result_valid, busy, protocol_error});
endmodule
