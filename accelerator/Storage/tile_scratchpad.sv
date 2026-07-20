module tile_scratchpad #(
    parameter int M            = 2,
    parameter int N            = 2,
    parameter int DATA_WIDTH   = 8,
    parameter int RESULT_WIDTH = 32,
    parameter int PAYLOAD_W    = 32
)(
    input  logic                         clk,
    input  logic                         rst_n,
    input  logic                         clear,

    // Packed payload writes from tile-level NoC packets.
    input  logic                         weight_payload_we,
    input  logic [PAYLOAD_W-1:0]         weight_payload,
    input  logic                         activation_payload_we,
    input  logic [PAYLOAD_W-1:0]         activation_payload,

    // Optional local result holding for later tile-controller work.
    input  logic                         result_we,
    input  logic [RESULT_WIDTH-1:0]      result_data,

    // Indexed read ports for the future tile controller replay path.
    input  logic [$clog2(M*N)-1:0]       weight_rd_idx,
    output logic [DATA_WIDTH-1:0]        weight_rd_data,
    input  logic [$clog2(N)-1:0]         weight_rd_col_idx,
    output logic [M*DATA_WIDTH-1:0]      weight_col_rd_data,
    input  logic [$clog2(M*N)-1:0]       activation_rd_idx,
    output logic [DATA_WIDTH-1:0]        activation_rd_data,

    output logic [RESULT_WIDTH-1:0]      result_rd_data,
    output logic                         weights_valid,
    output logic                         activations_valid,
    output logic                         result_valid
);
    localparam int WEIGHT_COUNT = M * N;
    localparam int ACT_COUNT    = M * N;

    logic [DATA_WIDTH-1:0] weight_mem [WEIGHT_COUNT];
    logic [DATA_WIDTH-1:0] activation_mem [ACT_COUNT];
    logic [RESULT_WIDTH-1:0] result_q;

    function automatic logic [DATA_WIDTH-1:0] payload_lane(
        input logic [PAYLOAD_W-1:0] payload,
        input int unsigned lane
    );
        return payload[lane*DATA_WIDTH +: DATA_WIDTH];
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weights_valid     <= 1'b0;
            activations_valid <= 1'b0;
            result_valid      <= 1'b0;
            result_q          <= '0;

            for (int i = 0; i < WEIGHT_COUNT; i++) begin
                weight_mem[i] <= '0;
            end

            for (int i = 0; i < ACT_COUNT; i++) begin
                activation_mem[i] <= '0;
            end
        end else begin
            if (clear) begin
                weights_valid     <= 1'b0;
                activations_valid <= 1'b0;
                result_valid      <= 1'b0;
                result_q          <= '0;
            end

            if (weight_payload_we) begin
                for (int i = 0; i < WEIGHT_COUNT; i++) begin
                    weight_mem[i] <= payload_lane(weight_payload, i);
                end
                weights_valid <= 1'b1;
            end

            if (activation_payload_we) begin
                for (int i = 0; i < ACT_COUNT; i++) begin
                    activation_mem[i] <= payload_lane(activation_payload, i);
                end
                activations_valid <= 1'b1;
            end

            if (result_we) begin
                result_q     <= result_data;
                result_valid <= 1'b1;
            end
        end
    end

    always_comb begin
        weight_rd_data     = weight_mem[weight_rd_idx];
        activation_rd_data = activation_mem[activation_rd_idx];
        result_rd_data     = result_q;

        for (int row = 0; row < M; row++) begin
            weight_col_rd_data[row*DATA_WIDTH +: DATA_WIDTH] =
                weight_mem[(row*N) + int'(weight_rd_col_idx)];
        end
    end

endmodule
