module systolic_array #(
    parameter int M            = 2,
    parameter int N            = 2,
    parameter int DATA_WIDTH   = 8,
    parameter int RESULT_WIDTH = 32
)(
    input  logic clk,
    input  logic rst_n,

    // Array control
    input  logic start,
    input  logic clear,
    input  logic compute_en,
    input  logic reduce_en,

    // Systolic weight preload path. One value enters each row, and the tile
    // controller selects which columns capture during the skewed preload.
    input  logic [M*DATA_WIDTH-1:0] row_weight_data,
    input  logic [N-1:0] weight_col_load,
    input  logic [DATA_WIDTH-1:0] activation_data,

    // Status
    output logic done,
    output logic [M*N-1:0] overflow_hazard,

    // Row-major PE outputs, flattened as:
    // pe_results[idx*RESULT_WIDTH +: RESULT_WIDTH]
output logic [M*N*RESULT_WIDTH-1:0] pe_results
);

    localparam int PE_COUNT = M * N;

    logic [PE_COUNT-1:0]             pe_weight_load;
    logic [PE_COUNT-1:0]             pe_overflow_hazard;
    logic [RESULT_WIDTH-1:0]         pe_result_bus [PE_COUNT-1:0];
    logic [DATA_WIDTH-1:0]           weight_link [M-1:0][N:0];

    // Weight and activation pipeline links.
    // Each row receives one streamed weight at the left edge and shifts it
    // across the row. Activations use the same left-edge stream and also
    // shift across the row.
    logic [DATA_WIDTH-1:0] act_link [M-1:0][N:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done       <= 1'b0;
        end else begin
            done <= 1'b0;

            if (reduce_en) begin
                done <= 1'b1;
            end
        end
    end

    assign overflow_hazard = pe_overflow_hazard;

    generate
        for (genvar row = 0; row < M; row = row + 1) begin : gen_row
            assign act_link[row][0] = activation_data;

            for (genvar col = 0; col < N; col = col + 1) begin : gen_col
                localparam int IDX = row * N + col;

                assign pe_weight_load[IDX] = weight_col_load[col];

                pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .RESULT_WIDTH(RESULT_WIDTH)
                ) u_pe (
                    .clk(clk),
                    .rst_n(rst_n),
                    .overflow_hazard(pe_overflow_hazard[IDX]),
                    .clear(clear),
                    .weight_load(pe_weight_load[IDX]),
                    .weight_in(weight_link[row][col]),
                    .weight_out(weight_link[row][col+1]),
                    .compute_en(compute_en),
                    .activation_in(act_link[row][col]),
                    .activation_out(act_link[row][col+1]),
                    .result(pe_result_bus[IDX])
                );

                assign pe_results[IDX*RESULT_WIDTH +: RESULT_WIDTH] = pe_result_bus[IDX];
            end
        end
    endgenerate

    generate
        for (genvar row = 0; row < M; row = row + 1) begin : gen_weight_in
            assign weight_link[row][0] =
                row_weight_data[row*DATA_WIDTH +: DATA_WIDTH];
        end
    endgenerate

endmodule
