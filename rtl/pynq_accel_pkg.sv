package pynq_accel_pkg;

    localparam int PYNQ_REG_W = 32;
    localparam int PYNQ_ADDR_W = 8;

    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_CTRL           = 8'h00;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_STATUS         = 8'h04;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_TILE_COUNT     = 8'h08;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_WEIGHT_DATA    = 8'h0C;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_ACT_DATA       = 8'h10;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_RESULT         = 8'h14;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_ERROR          = 8'h18;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_LED_MIRROR     = 8'h1C;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_TILE_SELECT    = 8'h20;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_PACKET_TYPE    = 8'h24;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_PACKET_PAYLOAD = 8'h28;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_PACKET_VALID   = 8'h2C;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_PACKET_READY   = 8'h30;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_DMA_SRC_ADDR   = 8'h34;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_DMA_DST_ADDR   = 8'h38;
    localparam logic [PYNQ_ADDR_W-1:0] PYNQ_REG_DMA_LENGTH     = 8'h3C;

    localparam int PYNQ_CTRL_START_BIT       = 0;
    localparam int PYNQ_CTRL_CLEAR_BIT       = 1;
    localparam int PYNQ_CTRL_FINAL_LAYER_BIT = 2;

    localparam int PYNQ_STATUS_BUSY_BIT         = 0;
    localparam int PYNQ_STATUS_DONE_BIT         = 1;
    localparam int PYNQ_STATUS_RESULT_VALID_BIT = 2;
    localparam int PYNQ_STATUS_OVERFLOW_BIT     = 3;

    typedef struct packed {
        logic start;
        logic clear;
        logic final_layer;
    } pynq_ctrl_bits_t;

    typedef struct packed {
        logic overflow;
        logic result_valid;
        logic done;
        logic busy;
    } pynq_status_bits_t;

endpackage
