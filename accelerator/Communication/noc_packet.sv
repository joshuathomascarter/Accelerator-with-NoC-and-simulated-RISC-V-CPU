package noc_packet_pkg;
    // The first mesh is a 2x2 grid, so 2 bits is enough for coordinates.
    localparam int NOC_COORD_W   = 2;
    localparam int NOC_TYPE_W    = 4;
    localparam int NOC_PAYLOAD_W = 32;
    localparam int NOC_PACKET_W  = (4 * NOC_COORD_W) + NOC_TYPE_W + NOC_PAYLOAD_W;
    localparam int NOC_FLIT_W    = NOC_PACKET_W + 2;

    // Keep these explicit as well as documenting the constants above. Some
    // Icarus builds lose package-local parameter bindings when a typedef is
    // used in a function declared inside another module.
    typedef logic [1:0]  noc_coord_t;
    typedef logic [3:0]  noc_type_t;
    typedef logic [31:0] noc_payload_t;
    typedef logic                     noc_class_t;

    localparam int NOC_CLASS_COUNT = 2;
    localparam noc_class_t NOC_CLASS_REQ  = 1'b0;
    localparam noc_class_t NOC_CLASS_RESP = 1'b1;

    localparam noc_type_t NOC_PKT_START   = 4'h1;
    localparam noc_type_t NOC_PKT_CLEAR   = 4'h2;
    localparam noc_type_t NOC_PKT_WEIGHT  = 4'h3;
    localparam noc_type_t NOC_PKT_COMPUTE = 4'h4;
    localparam noc_type_t NOC_PKT_REDUCE  = 4'h5;
    localparam noc_type_t NOC_PKT_RESULT  = 4'hE;
    localparam noc_type_t NOC_PKT_DONE    = 4'hF;

    typedef struct packed {
        noc_coord_t   src_x;
        noc_coord_t   src_y;
        noc_coord_t   dst_x;
        noc_coord_t   dst_y;
        noc_type_t    payload_type;
        noc_payload_t payload;
    } noc_packet_t;

    typedef struct packed {
        logic         head;
        logic         tail;
        noc_coord_t   src_x;
        noc_coord_t   src_y;
        noc_coord_t   dst_x;
        noc_coord_t   dst_y;
        noc_type_t    payload_type;
        noc_payload_t payload;
    } noc_flit_t;

    typedef enum logic [2:0] {
        NOC_DIR_LOCAL = 3'd0,
        NOC_DIR_EAST  = 3'd1,
        NOC_DIR_WEST  = 3'd2,
        NOC_DIR_NORTH = 3'd3,
        NOC_DIR_SOUTH = 3'd4,
        NOC_DIR_DROP  = 3'd5
    } noc_dir_t;

    // XY routing: move along X first, then Y.
    // X is the column dimension and Y is the row dimension.
    function automatic noc_dir_t route_xy(
        input noc_coord_t cur_x,
        input noc_coord_t cur_y,
        input noc_packet_t pkt
    );
        if (pkt.dst_x < cur_x) begin
            return NOC_DIR_WEST;
        end else if (pkt.dst_x > cur_x) begin
            return NOC_DIR_EAST;
        end else if (pkt.dst_y < cur_y) begin
            return NOC_DIR_NORTH;
        end else if (pkt.dst_y > cur_y) begin
            return NOC_DIR_SOUTH;
        end else begin
            return NOC_DIR_LOCAL;
        end
    endfunction

    function automatic logic is_local_dest(
        input noc_coord_t cur_x,
        input noc_coord_t cur_y,
        input noc_packet_t pkt
    );
        return (pkt.dst_x == cur_x) && (pkt.dst_y == cur_y);
    endfunction

    function automatic noc_flit_t packet_to_flit(
        input noc_packet_t pkt
        );
        packet_to_flit.head         = 1'b1;
        packet_to_flit.tail         = 1'b1;
        packet_to_flit.src_x        = pkt.src_x;
        packet_to_flit.src_y        = pkt.src_y;
        packet_to_flit.dst_x        = pkt.dst_x;
        packet_to_flit.dst_y        = pkt.dst_y;
        packet_to_flit.payload_type = pkt.payload_type;
        packet_to_flit.payload      = pkt.payload;
    endfunction

    function automatic noc_packet_t flit_to_packet(
        input noc_flit_t flit
        );
        flit_to_packet.src_x        = flit.src_x;
        flit_to_packet.src_y        = flit.src_y;
        flit_to_packet.dst_x        = flit.dst_x;
        flit_to_packet.dst_y        = flit.dst_y;
        flit_to_packet.payload_type = flit.payload_type;
        flit_to_packet.payload      = flit.payload;
    endfunction

    function automatic noc_dir_t route_xy_flit(
        input noc_coord_t cur_x,
        input noc_coord_t cur_y,
        input noc_flit_t flit
    );
        if (flit.dst_x < cur_x) begin
            return NOC_DIR_WEST;
        end else if (flit.dst_x > cur_x) begin
            return NOC_DIR_EAST;
        end else if (flit.dst_y < cur_y) begin
            return NOC_DIR_NORTH;
        end else if (flit.dst_y > cur_y) begin
            return NOC_DIR_SOUTH;
        end else begin
            return NOC_DIR_LOCAL;
        end
    endfunction

    function automatic noc_class_t noc_class_for_type(
        input noc_type_t payload_type
    );
        if (payload_type == NOC_PKT_RESULT || payload_type == NOC_PKT_DONE) begin
            return NOC_CLASS_RESP;
        end else begin
            return NOC_CLASS_REQ;
        end
    endfunction

    function automatic noc_class_t noc_class_for_flit(
        input noc_flit_t flit
    );
        return noc_class_for_type(flit.payload_type);
    endfunction
endpackage
