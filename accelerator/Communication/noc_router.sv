module noc_router #(
    parameter int COORD_W = noc_packet_pkg::NOC_COORD_W
)(
    input  logic                         in_valid,
    input  noc_packet_pkg::noc_coord_t    router_x,
    input  noc_packet_pkg::noc_coord_t    router_y,
    input  noc_packet_pkg::noc_flit_t     in_flit,

    input  logic                         local_ready,
    input  logic                         east_ready,
    input  logic                         west_ready,
    input  logic                         north_ready,
    input  logic                         south_ready,

    output logic                         is_local,
    output noc_packet_pkg::noc_dir_t      route_dir,
    output logic                         in_ready
);
    import noc_packet_pkg::*;

    always_comb begin
        route_dir = NOC_DIR_DROP;
        is_local  = 1'b0;
        in_ready  = 1'b0;

        if (in_valid) begin
            route_dir = route_xy_flit(router_x, router_y, in_flit);
            is_local  = (route_dir == NOC_DIR_LOCAL);

            unique case (route_dir)
                NOC_DIR_LOCAL: in_ready = local_ready;
                NOC_DIR_EAST:  in_ready = east_ready;
                NOC_DIR_WEST:  in_ready = west_ready;
                NOC_DIR_NORTH: in_ready = north_ready;
                NOC_DIR_SOUTH: in_ready = south_ready;
                default:       in_ready = 1'b0;
            endcase
        end
    end
endmodule
