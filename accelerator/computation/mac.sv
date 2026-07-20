module mac #(
    parameter int DATA_WIDTH   = 8,
    parameter int RESULT_WIDTH = 32
)(
    input logic clk,
    input logic rst_n,

    input logic [DATA_WIDTH-1:0] weights,
    input logic [DATA_WIDTH-1:0] activations,

    input logic clr,
    input logic en,

    output logic [RESULT_WIDTH-1:0] result,
    output logic overflow_hazard
);

    localparam logic signed [RESULT_WIDTH-1:0] MAX_ACC =
        {1'b0, {RESULT_WIDTH-1{1'b1}}};

    localparam logic signed [RESULT_WIDTH-1:0] MIN_ACC =
        {1'b1, {RESULT_WIDTH-1{1'b0}}};

    logic signed [RESULT_WIDTH-1:0] acc;
    logic signed [RESULT_WIDTH:0]    next_acc;

    always_comb begin
        next_acc = $signed(acc) + ($signed(weights) * $signed(activations));
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc             <= '0;
            overflow_hazard <= 1'b0;
        end else if (clr) begin
            acc             <= '0;
            overflow_hazard <= 1'b0;
        end else if (en) begin
            acc <= next_acc[RESULT_WIDTH-1:0];
            overflow_hazard <= (next_acc > $signed({1'b0, MAX_ACC})) ||
                               (next_acc < $signed({MIN_ACC[RESULT_WIDTH-1], MIN_ACC}));
        end
    end

    assign result = acc;

endmodule
