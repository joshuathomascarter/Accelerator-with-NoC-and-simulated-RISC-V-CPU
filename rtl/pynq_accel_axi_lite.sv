module pynq_accel_axi_lite #(
    parameter int AXI_ADDR_W = pynq_accel_pkg::PYNQ_ADDR_W,
    parameter int AXI_DATA_W = pynq_accel_pkg::PYNQ_REG_W
)(
    input  logic                      clk,
    input  logic                      rst_n,

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

    input  logic                      accel_busy,
    input  logic                      accel_done,
    input  logic                      accel_result_valid,
    input  logic                      accel_overflow,
    input  logic [AXI_DATA_W-1:0]     accel_result_data,
    input  logic [AXI_DATA_W-1:0]     accel_error_flags,
    input  logic                      packet_ready,

    output logic                      accel_start,
    output logic                      accel_clear,
    output logic                      accel_final_layer,
    output logic [AXI_DATA_W-1:0]     accel_tile_count,
    output logic                      accel_weight_wr_en,
    output logic [AXI_DATA_W-1:0]     accel_weight_wr_data,
    output logic                      accel_act_wr_en,
    output logic [AXI_DATA_W-1:0]     accel_act_wr_data,
    output logic                      accel_result_rd_en,

    output logic [3:0]                led_mirror,
    output logic [7:0]                tile_select,
    output logic [7:0]                packet_type,
    output logic [AXI_DATA_W-1:0]     packet_payload,
    output logic                      packet_valid,
    output logic [AXI_DATA_W-1:0]     dma_src_addr,
    output logic [AXI_DATA_W-1:0]     dma_dst_addr,
    output logic [AXI_DATA_W-1:0]     dma_length,

    // Extension port: aligned accesses at byte offset 0x100 and above go here
    // (only reachable when AXI_ADDR_W > 8). Reads are combinational from
    // ext_rd_addr; writes are a one-cycle ext_wr_en pulse with full-word data.
    output logic                      ext_wr_en,
    output logic [AXI_ADDR_W-1:0]     ext_wr_addr,
    output logic [AXI_DATA_W-1:0]     ext_wr_data,
    output logic [AXI_ADDR_W-1:0]     ext_rd_addr,
    input  logic [AXI_DATA_W-1:0]     ext_rd_data
);
    import pynq_accel_pkg::*;

    localparam logic [1:0] AXI_RESP_OKAY   = 2'b00;
    localparam logic [1:0] AXI_RESP_SLVERR = 2'b10;

    logic                  aw_pending_q;
    logic [AXI_ADDR_W-1:0] awaddr_q;
    logic                  w_pending_q;
    logic [AXI_DATA_W-1:0] wdata_q;
    logic [(AXI_DATA_W/8)-1:0] wstrb_q;

    logic                  write_fire;
    logic                  read_fire;
    logic                  write_addr_valid;
    logic                  read_addr_valid;

    logic [AXI_DATA_W-1:0] ctrl_q;
    logic [AXI_DATA_W-1:0] led_mirror_q;
    logic [AXI_DATA_W-1:0] tile_select_q;
    logic [AXI_DATA_W-1:0] packet_type_q;
    logic [AXI_DATA_W-1:0] packet_payload_q;
    logic [AXI_DATA_W-1:0] dma_src_addr_q;
    logic [AXI_DATA_W-1:0] dma_dst_addr_q;
    logic [AXI_DATA_W-1:0] dma_length_q;

    function automatic logic [AXI_DATA_W-1:0] apply_wstrb(
        input logic [AXI_DATA_W-1:0] old_value,
        input logic [AXI_DATA_W-1:0] new_value,
        input logic [(AXI_DATA_W/8)-1:0] byte_strobe
    );
        logic [AXI_DATA_W-1:0] merged;
        begin
            merged = old_value;
            for (int b = 0; b < AXI_DATA_W/8; b++) begin
                if (byte_strobe[b]) begin
                    merged[b*8 +: 8] = new_value[b*8 +: 8];
                end
            end
            return merged;
        end
    endfunction

    function automatic logic is_ext_addr(input logic [AXI_ADDR_W-1:0] addr);
        return (AXI_ADDR_W > 8) && ((addr >> 8) != 0);
    endfunction

    function automatic logic is_known_addr(input logic [AXI_ADDR_W-1:0] addr);
        unique case (addr)
            PYNQ_REG_CTRL,
            PYNQ_REG_STATUS,
            PYNQ_REG_TILE_COUNT,
            PYNQ_REG_WEIGHT_DATA,
            PYNQ_REG_ACT_DATA,
            PYNQ_REG_RESULT,
            PYNQ_REG_ERROR,
            PYNQ_REG_LED_MIRROR,
            PYNQ_REG_TILE_SELECT,
            PYNQ_REG_PACKET_TYPE,
            PYNQ_REG_PACKET_PAYLOAD,
            PYNQ_REG_PACKET_VALID,
            PYNQ_REG_PACKET_READY,
            PYNQ_REG_DMA_SRC_ADDR,
            PYNQ_REG_DMA_DST_ADDR,
            PYNQ_REG_DMA_LENGTH: begin
                return 1'b1;
            end

            default: begin
                return 1'b0;
            end
        endcase
    endfunction

    function automatic logic [AXI_DATA_W-1:0] read_data_for_addr(
        input logic [AXI_ADDR_W-1:0] addr
    );
        logic [AXI_DATA_W-1:0] status_word;
        begin
            status_word = '0;
            status_word[PYNQ_STATUS_BUSY_BIT]         = accel_busy;
            status_word[PYNQ_STATUS_DONE_BIT]         = accel_done;
            status_word[PYNQ_STATUS_RESULT_VALID_BIT] = accel_result_valid;
            status_word[PYNQ_STATUS_OVERFLOW_BIT]     = accel_overflow;

            unique case (addr)
                PYNQ_REG_CTRL: begin
                    read_data_for_addr = ctrl_q;
                end

                PYNQ_REG_STATUS: begin
                    read_data_for_addr = status_word;
                end

                PYNQ_REG_TILE_COUNT: begin
                    read_data_for_addr = accel_tile_count;
                end

                PYNQ_REG_RESULT: begin
                    read_data_for_addr = accel_result_data;
                end

                PYNQ_REG_ERROR: begin
                    read_data_for_addr = accel_error_flags;
                end

                PYNQ_REG_LED_MIRROR: begin
                    read_data_for_addr = led_mirror_q;
                end

                PYNQ_REG_TILE_SELECT: begin
                    read_data_for_addr = tile_select_q;
                end

                PYNQ_REG_PACKET_TYPE: begin
                    read_data_for_addr = packet_type_q;
                end

                PYNQ_REG_PACKET_PAYLOAD: begin
                    read_data_for_addr = packet_payload_q;
                end

                PYNQ_REG_PACKET_READY: begin
                    read_data_for_addr = {{(AXI_DATA_W-1){1'b0}}, packet_ready};
                end

                PYNQ_REG_DMA_SRC_ADDR: begin
                    read_data_for_addr = dma_src_addr_q;
                end

                PYNQ_REG_DMA_DST_ADDR: begin
                    read_data_for_addr = dma_dst_addr_q;
                end

                PYNQ_REG_DMA_LENGTH: begin
                    read_data_for_addr = dma_length_q;
                end

                default: begin
                    read_data_for_addr = '0;
                end
            endcase
        end
    endfunction

    assign s_axi_awready = !aw_pending_q && !s_axi_bvalid;
    assign s_axi_wready  = !w_pending_q && !s_axi_bvalid;
    assign s_axi_arready = !s_axi_rvalid;

    assign write_fire = aw_pending_q && w_pending_q && !s_axi_bvalid;
    assign read_fire  = s_axi_arvalid && s_axi_arready;

    assign write_addr_valid = (awaddr_q[1:0] == 2'b00) && (is_known_addr(awaddr_q) || is_ext_addr(awaddr_q));
    assign read_addr_valid  = (s_axi_araddr[1:0] == 2'b00) &&
                              (is_known_addr(s_axi_araddr) || is_ext_addr(s_axi_araddr));
    assign ext_rd_addr      = s_axi_araddr;

    assign accel_final_layer    = ctrl_q[PYNQ_CTRL_FINAL_LAYER_BIT];
    assign led_mirror           = led_mirror_q[3:0];
    assign tile_select          = tile_select_q[7:0];
    assign packet_type          = packet_type_q[7:0];
    assign packet_payload       = packet_payload_q;
    assign dma_src_addr         = dma_src_addr_q;
    assign dma_dst_addr         = dma_dst_addr_q;
    assign dma_length           = dma_length_q;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            aw_pending_q         <= 1'b0;
            awaddr_q             <= '0;
            w_pending_q          <= 1'b0;
            wdata_q              <= '0;
            wstrb_q              <= '0;
            s_axi_bvalid         <= 1'b0;
            s_axi_bresp          <= AXI_RESP_OKAY;
            s_axi_rvalid         <= 1'b0;
            s_axi_rdata          <= '0;
            s_axi_rresp          <= AXI_RESP_OKAY;
            ctrl_q               <= '0;
            accel_tile_count     <= '0;
            accel_weight_wr_data <= '0;
            accel_act_wr_data    <= '0;
            led_mirror_q         <= '0;
            tile_select_q        <= '0;
            packet_type_q        <= '0;
            packet_payload_q     <= '0;
            dma_src_addr_q       <= '0;
            dma_dst_addr_q       <= '0;
            dma_length_q         <= '0;
            accel_start          <= 1'b0;
            accel_clear          <= 1'b0;
            accel_weight_wr_en   <= 1'b0;
            accel_act_wr_en      <= 1'b0;
            accel_result_rd_en   <= 1'b0;
            packet_valid         <= 1'b0;
            ext_wr_en            <= 1'b0;
            ext_wr_addr          <= '0;
            ext_wr_data          <= '0;
        end else begin
            ext_wr_en          <= 1'b0;
            accel_start        <= 1'b0;
            accel_clear        <= 1'b0;
            accel_weight_wr_en <= 1'b0;
            accel_act_wr_en    <= 1'b0;
            accel_result_rd_en <= 1'b0;
            packet_valid       <= 1'b0;

            if (s_axi_awvalid && s_axi_awready) begin
                aw_pending_q <= 1'b1;
                awaddr_q     <= s_axi_awaddr;
            end

            if (s_axi_wvalid && s_axi_wready) begin
                w_pending_q <= 1'b1;
                wdata_q     <= s_axi_wdata;
                wstrb_q     <= s_axi_wstrb;
            end

            if (write_fire) begin
                s_axi_bvalid <= 1'b1;
                s_axi_bresp  <= write_addr_valid ? AXI_RESP_OKAY : AXI_RESP_SLVERR;

                if (write_addr_valid) begin
                    unique case (awaddr_q)
                        PYNQ_REG_CTRL: begin
                            ctrl_q      <= apply_wstrb(ctrl_q, wdata_q, wstrb_q);
                            ctrl_q[PYNQ_CTRL_START_BIT] <= 1'b0;
                            ctrl_q[PYNQ_CTRL_CLEAR_BIT] <= 1'b0;
                            accel_start <= wdata_q[PYNQ_CTRL_START_BIT] && wstrb_q[PYNQ_CTRL_START_BIT/8];
                            accel_clear <= wdata_q[PYNQ_CTRL_CLEAR_BIT] && wstrb_q[PYNQ_CTRL_CLEAR_BIT/8];
                        end

                        PYNQ_REG_TILE_COUNT: begin
                            accel_tile_count <= apply_wstrb(accel_tile_count, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_WEIGHT_DATA: begin
                            accel_weight_wr_en   <= 1'b1;
                            accel_weight_wr_data <= apply_wstrb(accel_weight_wr_data, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_ACT_DATA: begin
                            accel_act_wr_en   <= 1'b1;
                            accel_act_wr_data <= apply_wstrb(accel_act_wr_data, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_LED_MIRROR: begin
                            led_mirror_q <= apply_wstrb(led_mirror_q, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_TILE_SELECT: begin
                            tile_select_q <= apply_wstrb(tile_select_q, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_PACKET_TYPE: begin
                            packet_type_q <= apply_wstrb(packet_type_q, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_PACKET_PAYLOAD: begin
                            packet_payload_q <= apply_wstrb(packet_payload_q, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_PACKET_VALID: begin
                            packet_valid <= wdata_q[0] && wstrb_q[0];
                        end

                        PYNQ_REG_DMA_SRC_ADDR: begin
                            dma_src_addr_q <= apply_wstrb(dma_src_addr_q, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_DMA_DST_ADDR: begin
                            dma_dst_addr_q <= apply_wstrb(dma_dst_addr_q, wdata_q, wstrb_q);
                        end

                        PYNQ_REG_DMA_LENGTH: begin
                            dma_length_q <= apply_wstrb(dma_length_q, wdata_q, wstrb_q);
                        end

                        default: begin
                            // Read-only and reserved registers ignore writes.
                        end
                    endcase
                end

                if (write_addr_valid && is_ext_addr(awaddr_q)) begin
                    ext_wr_en   <= 1'b1;
                    ext_wr_addr <= awaddr_q;
                    ext_wr_data <= wdata_q;
                end

                aw_pending_q <= 1'b0;
                w_pending_q  <= 1'b0;
            end

            if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
            end

            if (read_fire) begin
                s_axi_rvalid <= 1'b1;
                s_axi_rresp  <= read_addr_valid ? AXI_RESP_OKAY : AXI_RESP_SLVERR;
                s_axi_rdata  <= !read_addr_valid ? '0 :
                                is_ext_addr(s_axi_araddr) ? ext_rd_data : read_data_for_addr(s_axi_araddr);

                if (read_addr_valid && (s_axi_araddr == PYNQ_REG_RESULT)) begin
                    accel_result_rd_en <= 1'b1;
                end
            end

            if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
            end
        end
    end

endmodule
