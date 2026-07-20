module uart_loopback #(
    parameter int UART_DATA_WIDTH = 8,
    parameter int RESULT_WIDTH    = 32,
    parameter int REGISTER_DEPTH  = 16,
    parameter int ADDR_W          = $clog2(REGISTER_DEPTH),
    parameter int FIFO_DEPTH      = 16,
    parameter int FIFO_ADDR_W     = 4,
    parameter int SRAM_DEPTH      = 256,
    parameter int SRAM_ADDR_W     = $clog2(SRAM_DEPTH),
    parameter int TIME_OUT_CYCLES = 5000,
    parameter int               M = 2,
    parameter int               N = 2
)(
    input  logic clk,
    input  logic rst_n,
    input  logic uart_rx_i,
    output logic uart_tx_o,

    output logic [UART_DATA_WIDTH-1:0] rx_debug_data,
    output logic                       rx_done,
    output logic                       tx_active,
    output logic                       fifo_full,
    output logic                       fifo_empty
);
    import noc_packet_pkg::*;

    localparam int GRID_W     = 2;
    localparam int GRID_H     = 2;
    localparam int TILE_COUNT = GRID_W * GRID_H;

    // ── UART RX ────────────────────────────────────────────────────────────
    logic [UART_DATA_WIDTH-1:0] rx_data;
    logic                       rx_ready;

    logic [UART_DATA_WIDTH-1:0] rx_fifo_data_out;
    logic                       rx_fifo_rd_valid;
    logic                       rx_fifo_wr_ready;
    logic                       rx_fifo_full;
    logic                       rx_fifo_empty;
    logic                       framing_err;

    assign rx_debug_data = rx_data;
    assign rx_done       = rx_ready;

    uart_rx #(.DIV_16(27)) receiver_inst (
        .clk(clk), .rst_n(rst_n),
        .rx_in(uart_rx_i),
        .data_out(rx_data),
        .rx_ready(rx_ready),
        .framing_error(framing_err)
    );

    // RX FIFO: buffer incoming bytes so decoder doesn't drop them if busy
    fifo_8bit #(
        .DATA_WIDTH(UART_DATA_WIDTH),
        .DEPTH(16),
        .ADDR_W(4)
    ) rx_fifo_inst (
        .clk(clk), .rst_n(rst_n),
        .data_in(rx_data),
        .wr_en(rx_ready), .wr_ready(rx_fifo_wr_ready), .full(rx_fifo_full),
        .data_out(rx_fifo_data_out),
        .rd_valid(rx_fifo_rd_valid), .rd_en(rx_fifo_rd_valid), .empty(rx_fifo_empty)
    );

    // ── CSR block ──────────────────────────────────────────────────────────
    logic [ADDR_W-1:0]         rf_wr_addr;
    logic [RESULT_WIDTH-1:0]   rf_wr_data;
    logic                      rf_wr_en;

    logic [ADDR_W-1:0]         rf_rd_addr_a;
    logic [RESULT_WIDTH-1:0]   rf_rd_data_a;

    logic [RESULT_WIDTH-1:0]   csr_layer_cfg;   // register 1: [31:1]=num_tiles, [0]=final_layer
    logic [31:0]               num_tiles;
    logic                      final_layer;
    logic                      core_busy;
    logic                      array_overflow_fault;
    logic                      reduction_busy;
    logic                      decoder_act_wr_en;
    logic [RESULT_WIDTH-1:0]   decoder_weight_wr_data;
    logic [RESULT_WIDTH-1:0]   decoder_act_wr_data;
    logic                      output_stream_busy;
    logic                      output_stream_done;
    logic                      output_stream_rd_en;
    logic                      output_stream_rd_ptr_reset;
    logic                      output_packer_start;
    logic [RESULT_WIDTH-1:0]   output_packer_data;
    logic                      csr_read_packer_start;
    logic [RESULT_WIDTH-1:0]   csr_read_packer_data;
    logic                      packer_start;
    logic [RESULT_WIDTH-1:0]   packer_data_in;

    csr_file #(
        .DATA_WIDTH(RESULT_WIDTH),
        .DEPTH(REGISTER_DEPTH),
        .ADDR_W(ADDR_W)
    ) csr_block (
        .clk(clk), .rst_n(rst_n),
        .wr_en(rf_wr_en), .wr_addr(rf_wr_addr), .wr_data(rf_wr_data),
        .rd_addr_a(rf_rd_addr_a), .rd_addr_b(4'd1),
        .rd_data_a(rf_rd_data_a), .rd_data_b(csr_layer_cfg),
        .num_tiles(num_tiles), .final_layer(final_layer),
        .scheduler_busy(core_busy),
        .output_ready(output_valid),
        .packer_busy(packer_busy),
        .array_overflow_hazard(array_overflow_fault),
        .error_status(error_status)
    );

    // ── Weight SRAM ────────────────────────────────────────────────────────
    logic                           weight_wr_en;
    logic [RESULT_WIDTH-1:0]        weight_wr_data;
    logic                           weight_wr_ptr_reset;
    logic                           weight_last_out;
    logic                           wght_full;

    logic [RESULT_WIDTH-1:0]        weight_rd_data;
    logic [SRAM_ADDR_W-1:0]         weight_rd_addr;
    logic                           weight_rd_en;
    logic                           wght_rd_bank_sel;
    logic                           wr_bank_sel;

    assign wght_rd_bank_sel = weight_bank_sel;
    assign wr_bank_sel = ~ weight_bank_sel;


    weight_sram #(
        .DATA_WIDTH(RESULT_WIDTH),
        .DEPTH(SRAM_DEPTH),
        .ADDR_W(SRAM_ADDR_W)
    ) weight_sram_inst (
        .clk(clk), .rst_n(rst_n),
        .wr_en(weight_wr_en), .wr_data(weight_wr_data), .wr_ptr_reset(weight_wr_ptr_reset),
        .rd_en(weight_rd_en), .rd_addr(weight_rd_addr), .rd_data(weight_rd_data),
        .last(weight_last_out), .full(wght_full), .rd_bank_sel(wght_rd_bank_sel), .wr_bank_sel(wr_bank_sel)
    );

    // ── Activation SRAM ────────────────────────────────────────────────────
    logic                           act_wr_en;
    logic [RESULT_WIDTH-1:0]        act_wr_data;
    logic                           act_wr_ptr_reset;
    logic                           act_last_out;
    logic                           act_full;

    logic [RESULT_WIDTH-1:0]        act_rd_data;
    logic [SRAM_ADDR_W-1:0]         act_rd_addr;
    logic                           act_rd_en;
    logic                           act_read_sel;
    logic                           act_wr_sel;

    assign act_read_sel = act_bank_sel;
    assign act_wr_sel = ~ act_bank_sel;

    activation_sram #(
        .DATA_WIDTH(RESULT_WIDTH),
        .DEPTH(SRAM_DEPTH),
        .ADDR_W(SRAM_ADDR_W)
    ) activation_sram_inst (
        .clk(clk), .rst_n(rst_n),
        .wr_en(act_wr_en), .wr_data(act_wr_data), .wr_ptr_reset(act_wr_ptr_reset),
        .rd_en(act_rd_en), .rd_addr(act_rd_addr), .rd_data(act_rd_data),
        .last(act_last_out), .full(act_full), .rd_bank_sel(act_read_sel), .wr_bank_sel(act_wr_sel)
    );

    // ── CHIP TOP: scheduler + NoC + 4 tiles ────────────────────────────────
    logic [TILE_COUNT-1:0]       chip_done;
    logic [TILE_COUNT-1:0]       chip_overflow_hazard;
    logic [TILE_COUNT-1:0]       tile_result_valid;
    noc_packet_t                 tile_result_packet [TILE_COUNT];
    logic [TILE_COUNT-1:0]       tile_occupied;

    // ── Output SRAM ────────────────────────────────────────────────────────
    logic                           out_wr_en;
    logic [SRAM_ADDR_W-1:0]         out_wr_addr;
    logic [RESULT_WIDTH-1:0]        out_wr_data;

    logic                           out_rd_en;
    logic [RESULT_WIDTH-1:0]        out_rd_data;
    logic                           out_rd_ptr_reset;
    logic                           out_valid;
    logic                           loopback_src_rd_en;
    logic                           loopback_src_rd_ptr_reset;
    logic                           loopback_dst_wr_en;
    logic [RESULT_WIDTH-1:0]        loopback_dst_wr_data;
    logic                           loopback_dst_wr_ptr_reset;
    logic                           loopback_done;
    logic                           loopback_start;
    logic [31:0]                    loopback_words;

    assign core_busy = weight_rd_en | act_rd_en | result_wr_en |
                       reduction_busy | output_stream_busy | loopback_start |
                       output_valid | (|tile_occupied);
    assign out_wr_en      = result_wr_en;
    assign out_wr_addr    = result_wr_addr;
    assign out_wr_data    = result_wr_data;

    output_sram #(
        .DATA_WIDTH(RESULT_WIDTH),
        .DEPTH(SRAM_DEPTH),
        .ADDR_W(SRAM_ADDR_W)
    ) output_sram_inst (
        .clk(clk), .rst_n(rst_n),
        .wr_en(out_wr_en), .wr_addr(out_wr_addr), .wr_data(out_wr_data),
        .wr_bank_sel(1'b0),
        .rd_en(out_rd_en), .rd_data(out_rd_data), .rd_ptr_reset(out_rd_ptr_reset),
        .rd_bank_sel(1'b0),
        .valid(out_valid)
    );

    // ── Command decoder (ISA front-end) ────────────────────────────────────
    logic                    packer_busy;
    logic                    decoder_done;
    logic                    decoder_weight_last;
    logic                    decoder_act_last;
    logic  [4:0]             error_status;

    cmd_decoder #(
        .DATA_WIDTH(RESULT_WIDTH),
        .ADDR_W(ADDR_W),
        .TIME_OUT_CYCLES(TIME_OUT_CYCLES)
    ) command_decoder (
        .clk(clk), .rst_n(rst_n),
        .rx_byte(rx_fifo_data_out), .rx_valid(rx_fifo_rd_valid),
        .rf_wr_en(rf_wr_en), .rf_wr_addr(rf_wr_addr), .rf_wr_data(rf_wr_data),
        .rf_rd_addr_a(rf_rd_addr_a), .rf_rd_data_a(rf_rd_data_a),
        .weight_wr_en(weight_wr_en), .weight_wr_data(decoder_weight_wr_data),
        .weight_last(decoder_weight_last),
        .act_wr_en(decoder_act_wr_en), .act_wr_data(decoder_act_wr_data),
        .act_last(decoder_act_last),
        .done(decoder_done),
        .packer_start(csr_read_packer_start),
        .packer_data(csr_read_packer_data),
        .packer_busy(packer_busy),
        .activations_full(act_full), .weights_full(wght_full), 
        .activation_write_blocked(reduction_busy || loopback_start),
        .framing_error(framing_err), .error_status(error_status)
    );

    // Connect decoder's LAST signals to SRAM write pointer resets
    assign weight_wr_ptr_reset = decoder_weight_last;
    assign act_wr_ptr_reset = decoder_act_last | loopback_dst_wr_ptr_reset;
    assign act_wr_en = (decoder_act_wr_en && !(reduction_busy || loopback_start)) | loopback_dst_wr_en;
    assign weight_wr_data = decoder_weight_wr_data;
    assign act_wr_data = (decoder_act_wr_en && !(reduction_busy || loopback_start)) ?
                         decoder_act_wr_data :
                         loopback_dst_wr_data;

    // ── Result packer (32-bit → 4×8-bit for TX) ───────────────────────────
    logic [UART_DATA_WIDTH-1:0] packed_byte;
    logic                       packer_byte_valid;
    logic                       packer_done;

    assign packer_start   = output_packer_start | csr_read_packer_start;
    assign packer_data_in  = csr_read_packer_start ? csr_read_packer_data : output_packer_data;

    result_packer #(
        .DATA_WIDTH(RESULT_WIDTH),
        .BYTE_WIDTH(UART_DATA_WIDTH)
    ) result_packer_inst (
        .clk(clk), .rst_n(rst_n),
        .start(packer_start),
        .result_in(packer_data_in),
        .byte_ready(tx_fifo_wr_ready),
        .byte_out(packed_byte),
        .byte_valid(packer_byte_valid),
        .busy(packer_busy),
        .done(packer_done)
    );

    // ── ACCELERATOR CHIP ─────────────────────────────────────────────────────

    wire                    result_wr_en;
    wire [SRAM_ADDR_W-1:0]  result_wr_addr;
    wire [RESULT_WIDTH-1:0]  result_wr_data;
    wire                    weight_bank_sel;
    wire                    act_bank_sel;
    wire                    output_valid;

    chip_top #(
        .GRID_W(GRID_W),
        .GRID_H(GRID_H),
        .M(M),
        .N(N),
        .ADDR_WIDTH(SRAM_ADDR_W),
        .DATA_WIDTH(UART_DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) u_chip_top (
        .clk(clk),
        .rst_n(rst_n),
        .num_tiles(num_tiles),
        .final_layer(final_layer),
        .act_last(decoder_act_last),
        .weight_last(decoder_weight_last),
        .weight_full(wght_full),
        .activation_full(act_full),
        .loopback_done(loopback_done),
        .weight_rd_data(weight_rd_data),
        .act_rd_data(act_rd_data),
        .weight_rd_addr(weight_rd_addr),
        .act_rd_addr(act_rd_addr),
        .weight_rd_en(weight_rd_en),
        .act_rd_en(act_rd_en),
        .weight_bank_sel(weight_bank_sel),
        .act_bank_sel(act_bank_sel),
        .loopback_start(loopback_start),
        .loopback_words(loopback_words),
        .output_valid(output_valid),
        .start(1'b0),
        .clear(1'b0),
        .compute_en(1'b0),
        .reduce_en(1'b0),
        .activation_data('0),
        .done(chip_done),
        .overflow_hazard(chip_overflow_hazard),
        .tile_result_valid(tile_result_valid),
        .tile_result_packet(tile_result_packet),
        .result_wr_en(result_wr_en),
        .result_wr_addr(result_wr_addr),
        .result_wr_data(result_wr_data),
        .tile_occupied(tile_occupied)
    );

    assign array_overflow_fault = |chip_overflow_hazard;

    loopback_controller #(
        .DATA_WIDTH(RESULT_WIDTH),
        .WORD_COUNT_W(32),
        .REDUCED_WIDTH(8)
    ) u_loopback_controller (
        .clk(clk),
        .rst_n(rst_n),
        .start(loopback_start),
        .word_count(loopback_words),
        .src_data(out_rd_data),
        .dst_full(act_full),
        .src_rd_en(loopback_src_rd_en),
        .src_rd_ptr_reset(loopback_src_rd_ptr_reset),
        .dst_wr_en(loopback_dst_wr_en),
        .dst_wr_data(loopback_dst_wr_data),
        .dst_wr_ptr_reset(loopback_dst_wr_ptr_reset),
        .busy(reduction_busy),
        .done(loopback_done)
    );

    host_readback #(
        .DATA_WIDTH(RESULT_WIDTH),
        .WORD_COUNT_W(32)
    ) u_host_readback (
        .clk(clk),
        .rst_n(rst_n),
        .start(output_valid),
        .word_count(num_tiles),
        .src_data(out_rd_data),
        .packer_busy(packer_busy),
        .packer_done(packer_done),
        .src_rd_en(output_stream_rd_en),
        .src_rd_ptr_reset(output_stream_rd_ptr_reset),
        .packer_start(output_packer_start),
        .packer_data(output_packer_data),
        .busy(output_stream_busy),
        .done(output_stream_done)
    );

    assign out_rd_en = (reduction_busy || loopback_start) ? loopback_src_rd_en : output_stream_rd_en;
    assign out_rd_ptr_reset = (reduction_busy || loopback_start) ? loopback_src_rd_ptr_reset : output_stream_rd_ptr_reset;
    


    // ── TX FIFO ────────────────────────────────────────────────────────────
    logic [UART_DATA_WIDTH-1:0] tx_fifo_data_out;
    logic                       tx_fifo_wr_ready;
    logic                       tx_fifo_rd_valid;
    logic                       tx_fifo_wr_en;
    logic                       tx_fifo_rd_en;
    logic                       tx_fifo_full;
    logic                       tx_fifo_empty;

    assign fifo_full    = tx_fifo_full;
    assign fifo_empty   = tx_fifo_empty;
    assign tx_fifo_wr_en = packer_byte_valid && tx_fifo_wr_ready;
    assign tx_fifo_rd_en = tx_fifo_rd_valid  && !tx_active;

    tx_fifo #(
        .DATA_WIDTH(UART_DATA_WIDTH),
        .DEPTH(FIFO_DEPTH),
        .ADDR_W(FIFO_ADDR_W)
    ) egress_fifo (
        .clk(clk), .rst_n(rst_n),
        .data_in(packed_byte),
        .wr_en(tx_fifo_wr_en), .wr_ready(tx_fifo_wr_ready), .full(tx_fifo_full),
        .data_out(tx_fifo_data_out),
        .rd_valid(tx_fifo_rd_valid), .rd_en(tx_fifo_rd_en), .empty(tx_fifo_empty)
    );

    // ── UART TX ────────────────────────────────────────────────────────────
    logic [UART_DATA_WIDTH-1:0] tx_data;
    logic                       tx_start;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_data  <= '0;
            tx_start <= 1'b0;
        end else begin
            tx_start <= tx_fifo_rd_en;
            if (tx_fifo_rd_en) tx_data <= tx_fifo_data_out;
        end
    end

    uart_tx #(
        .DATA_WIDTH(UART_DATA_WIDTH),
        .CLK_FREQUENCY(50_000_000),
        .DIV(434)
    ) transmitter_inst (
        .clk(clk), .rst_n(rst_n),
        .data_in(tx_data),
        .tx_start(tx_start),
        .tx_busy(tx_active),
        .tx_out(uart_tx_o)
    );

endmodule
