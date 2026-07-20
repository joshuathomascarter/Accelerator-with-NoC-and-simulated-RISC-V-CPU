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
    logic compute_en;
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

    task automatic run_compute(input int cycles, input logic [DATA_WIDTH-1:0] value);
        int i;
        begin
            @(negedge clk);
            activation_data = value;
            compute_en      = 1'b1;
            for (i = 0; i < cycles; i = i + 1) begin
                @(posedge clk);
            end
            @(negedge clk);
            compute_en = 1'b0;
        end
    endtask

    initial begin
        rst_n          = 1'b0;
        start          = 1'b0;
        clear          = 1'b0;
        row_weight_data = '0;
        weight_col_load = '0;
        compute_en     = 1'b0;
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

        $display("Starting compute with activation=1 for 4 cycles");
        @(negedge clk);
        start = 1'b1;
        @(posedge clk);
        @(negedge clk);
        start = 1'b0;
        run_compute(4, 8'd1);

        @(negedge clk);
        reduce_en = 1'b1;
        @(posedge clk);
        @(negedge clk);
        reduce_en = 1'b0;
        @(posedge clk);

        $display("internal pe00 weight=%0d act_in=%0d act_out=%0d",
            dut.gen_row[0].gen_col[0].u_pe.weight_reg,
            dut.gen_row[0].gen_col[0].u_pe.activation_in,
            dut.gen_row[0].gen_col[0].u_pe.activation_out);
        $display("internal pe01 weight=%0d act_in=%0d act_out=%0d",
            dut.gen_row[0].gen_col[1].u_pe.weight_reg,
            dut.gen_row[0].gen_col[1].u_pe.activation_in,
            dut.gen_row[0].gen_col[1].u_pe.activation_out);
        $display("internal pe00 result=%0d", dut.gen_row[0].gen_col[0].u_pe.result);
        $display("internal pe01 result=%0d", dut.gen_row[0].gen_col[1].u_pe.result);
        $display("internal pe10 result=%0d", dut.gen_row[1].gen_col[0].u_pe.result);
        $display("internal pe11 result=%0d", dut.gen_row[1].gen_col[1].u_pe.result);
        $display("done=%b", done);
        $display("overflow_hazard=%b", overflow_hazard);
        $display("pe_results[0]=%0d", pe_results[0*RESULT_WIDTH +: RESULT_WIDTH]);
        $display("pe_results[1]=%0d", pe_results[1*RESULT_WIDTH +: RESULT_WIDTH]);
        $display("pe_results[2]=%0d", pe_results[2*RESULT_WIDTH +: RESULT_WIDTH]);
        $display("pe_results[3]=%0d", pe_results[3*RESULT_WIDTH +: RESULT_WIDTH]);

        $finish;
    end
endmodule
