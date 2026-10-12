module pe #(
    parameter int DATA_WIDTH   = 8,
    parameter int RESULT_WIDTH = 32
)(
    input  logic                   clk,
    input  logic                   rst_n,
    output logic                   overflow_hazard,

    input  logic                   clear,
    input  logic                   weight_load,
    input  logic [DATA_WIDTH-1:0]  weight_in,
    output logic [DATA_WIDTH-1:0]  weight_out,

    input  logic                   compute_en,
    input  logic [DATA_WIDTH-1:0]  activation_in,

    output logic [RESULT_WIDTH-1:0] result
);

    logic [DATA_WIDTH-1:0] weight_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_reg <= '0;
        end else if (clear) begin
            weight_reg <= '0;
        end else if (weight_load) begin
            weight_reg <= weight_in;
        end
    end

    assign weight_out = weight_reg;

    mac #(
        .DATA_WIDTH(DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) u_mac (
        .clk(clk),
        .rst_n(rst_n),
        .weights(weight_reg),
        .activations(activation_in),
        .clr(clear),
        .en(compute_en),
        .result(result),
        .overflow_hazard(overflow_hazard)
    );

endmodule
