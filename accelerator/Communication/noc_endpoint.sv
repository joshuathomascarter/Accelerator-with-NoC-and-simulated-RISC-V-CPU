module noc_endpoint (
    input  logic                       packet_in_valid,
    input  noc_packet_pkg::noc_packet_t packet_in,
    output logic                       packet_in_ready,

    output logic                       flit_out_valid,
    output noc_packet_pkg::noc_flit_t  flit_out,
    input  logic                       flit_out_ready,

    input  logic                       flit_in_valid,
    input  noc_packet_pkg::noc_flit_t  flit_in,
    output logic                       flit_in_ready,

    output logic                       packet_out_valid,
    output noc_packet_pkg::noc_packet_t packet_out,
    input  logic                       packet_out_ready
);
    import noc_packet_pkg::*;

    // Today every packet fits in one head+tail flit. This module is the
    // boundary where future multi-flit packetization/reassembly belongs.
    always_comb begin
        flit_out_valid  = packet_in_valid;
        flit_out        = packet_to_flit(packet_in);
        packet_in_ready = flit_out_ready;

        packet_out_valid = flit_in_valid;
        packet_out       = flit_to_packet(flit_in);
        flit_in_ready    = packet_out_ready;
    end
endmodule
