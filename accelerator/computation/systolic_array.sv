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
    input  logic reduce_en,

    // Systolic weight preload path. One value enters each row, and the tile
    // controller selects which columns capture during the skewed preload.
    input  logic [M*DATA_WIDTH-1:0] row_weight_data,
    input  logic [N-1:0] weight_col_load,

    // Activations are broadcast to every PE. Each PE has its own compute
    // enable, so the tile can replay activation lane i into PE i only.
    input  logic [M*N-1:0] compute_en,
    input  logic [DATA_WIDTH-1:0] activation_data,

    // Status
    output logic done,
    output logic [M*N-1:0] overflow_hazard,

    // Row-major PE outputs, flattened as:
    // pe_results[idx*RESULT_WIDTH +: RESULT_WIDTH]
    output logic [M*N*RESULT_WIDTH-1:0] pe_results
);

    localparam int PE_COUNT = M * N;

    logic [PE_COUNT-1:0]     pe_weight_load;
    logic [PE_COUNT-1:0]     pe_overflow_hazard;
    logic [RESULT_WIDTH-1:0] pe_result_bus [PE_COUNT-1:0];
    logic [DATA_WIDTH-1:0]   weight_link [M-1:0][N:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else begin
            done <= reduce_en;
        end
    end

    assign overflow_hazard = pe_overflow_hazard;

    generate
        for (genvar row = 0; row < M; row = row + 1) begin : gen_row
            assign weight_link[row][0] = row_weight_data[row*DATA_WIDTH +: DATA_WIDTH];

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
                    .compute_en(compute_en[IDX]),
                    .activation_in(activation_data),
                    .result(pe_result_bus[IDX])
                );

                assign pe_results[IDX*RESULT_WIDTH +: RESULT_WIDTH] = pe_result_bus[IDX];
            end
        end
    endgenerate

endmodule
