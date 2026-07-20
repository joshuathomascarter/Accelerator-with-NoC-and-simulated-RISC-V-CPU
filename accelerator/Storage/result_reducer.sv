module result_reducer #(
    parameter int IN_WIDTH      = 32,
    parameter int OUT_WIDTH     = 32,
    parameter int REDUCED_WIDTH = 8
)(
    input  logic [IN_WIDTH-1:0]  result_in,
    output logic [OUT_WIDTH-1:0] reduced_out
);

    // Cheapest possible quantizer for now: keep the low byte and zero-extend.
    // This gives us an 8-bit activation representation without changing the
    // current 32-bit SRAM plumbing yet.
    assign reduced_out = {{(OUT_WIDTH-REDUCED_WIDTH){1'b0}}, result_in[REDUCED_WIDTH-1:0]};

endmodule
