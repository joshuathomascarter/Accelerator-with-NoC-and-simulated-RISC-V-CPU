`timescale 1ns / 1ps

module tb_systolic_array;
    parameter int M = 2;
    parameter int N = 2;
    parameter int DATA_WIDTH = 8;
    parameter int RESULT_WIDTH = 32;
    parameter int CLK_PERIOD = 20;

    logic clk = 1'b0;
    logic rst_n;

    logic start;
    logic clear;
    logic [M*N-1:0] compute_en;
    logic reduce_en;

    logic [M*DATA_WIDTH-1:0] row_weight_data;
    logic [N-1:0] weight_col_load;
    logic [DATA_WIDTH-1:0] activation_data;
    logic done;
    logic [M*N-1:0] overflow_hazard;
    logic [M*N*RESULT_WIDTH-1:0] pe_results;

    systolic_array #(
        .M(M),
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .clear(clear),
        .compute_en(compute_en),
        .reduce_en(reduce_en),
        .row_weight_data(row_weight_data),
        .weight_col_load(weight_col_load),
        .activation_data(activation_data),
        .done(done),
        .overflow_hazard(overflow_hazard),
        .pe_results(pe_results)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    task automatic pulse_clear();
        begin
            @(negedge clk);
            clear = 1'b1;
            @(posedge clk);
            @(negedge clk);
            clear = 1'b0;
        end
    endtask

    task automatic preload_weights_2x2(
        input logic [DATA_WIDTH-1:0] w00,
        input logic [DATA_WIDTH-1:0] w01,
        input logic [DATA_WIDTH-1:0] w10,
        input logic [DATA_WIDTH-1:0] w11
    );
        begin
            @(negedge clk);
            row_weight_data[0*DATA_WIDTH +: DATA_WIDTH] = w01;
            row_weight_data[1*DATA_WIDTH +: DATA_WIDTH] = w11;
            weight_col_load = 2'b01;
            @(posedge clk);

            @(negedge clk);
            row_weight_data[0*DATA_WIDTH +: DATA_WIDTH] = w00;
            row_weight_data[1*DATA_WIDTH +: DATA_WIDTH] = w10;
            weight_col_load = 2'b11;
            @(posedge clk);

            @(negedge clk);
            weight_col_load = '0;
            row_weight_data = '0;
        end
    endtask

    // Present one activation for one cycle to the PEs selected by pe_mask.
    task automatic compute_lane(input logic [M*N-1:0] pe_mask, input logic [DATA_WIDTH-1:0] value);
        begin
            @(negedge clk);
            activation_data = value;
            compute_en      = pe_mask;
            @(posedge clk);
            @(negedge clk);
            compute_en = '0;
        end
    endtask

    initial begin
        rst_n          = 1'b0;
        start          = 1'b0;
        clear          = 1'b0;
        row_weight_data = '0;
        weight_col_load = '0;
        compute_en     = '0;
        reduce_en      = 1'b0;
        activation_data = '0;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        $display("Clearing array");
        pulse_clear();
        @(posedge clk);

        $display("Preloading weights with intentional row/column skew");
        preload_weights_2x2(8'd1, 8'd2, 8'd3, 8'd4);

        if (dut.gen_row[0].gen_col[0].u_pe.weight_reg !== 8'd1 ||
            dut.gen_row[0].gen_col[1].u_pe.weight_reg !== 8'd2 ||
            dut.gen_row[1].gen_col[0].u_pe.weight_reg !== 8'd3 ||
            dut.gen_row[1].gen_col[1].u_pe.weight_reg !== 8'd4) begin
            $fatal(1, "Skewed preload did not place weights into expected PEs");
        end

        // Lane i drives PE i only: activations 5, -3, 7, 2 against weights 1..4.
        $display("Replaying one activation per PE");
        compute_lane(4'b0001, 8'd5);
        compute_lane(4'b0010, -8'sd3);
        compute_lane(4'b0100, 8'd7);
        compute_lane(4'b1000, 8'd2);

        @(negedge clk);
        reduce_en = 1'b1;
        @(posedge clk);
        #1;
        if (!done) $fatal(1, "done did not follow reduce_en");
        @(negedge clk);
        reduce_en = 1'b0;

        for (int i = 0; i < M*N; i++) begin
            $display("pe_results[%0d]=%0d", i, $signed(pe_results[i*RESULT_WIDTH +: RESULT_WIDTH]));
        end
        if ($signed(pe_results[0*RESULT_WIDTH +: RESULT_WIDTH]) !== 5 ||
            $signed(pe_results[1*RESULT_WIDTH +: RESULT_WIDTH]) !== -6 ||
            $signed(pe_results[2*RESULT_WIDTH +: RESULT_WIDTH]) !== 21 ||
            $signed(pe_results[3*RESULT_WIDTH +: RESULT_WIDTH]) !== 8) begin
            $fatal(1, "PE accumulators do not match weight*activation per lane");
        end
        if (overflow_hazard !== '0) $fatal(1, "Unexpected overflow hazard");

        $display("Systolic array test passed");
        $finish;
    end
endmodule
