`timescale 1ns/1ps

// File-driven AXI-Lite testbench for pynq_accel_top.
//
// Each input line is one accelerator run:
//   <tiles> <w0> <w1> <w2> <w3> <a0> <a1> <a2> <a3>      (all hex)
// Only the first <tiles> weight/activation words are written. Each output line:
//   <r0> <r1> <r2> <r3> <compute_cycles> <run_cycles>    (results hex, cycles decimal)
// <compute_cycles> counts clocks from the internal start pulse to the result
// readback reporting done. <run_cycles> counts every clock of the run as seen by
// the AXI master, from the first CTRL.clear write to the last RESULT read.
//
// Files default to vectors.txt / results.txt in the simulator's working
// directory; override with +VEC=<input file> +OUT=<output file>.
module tb_pynq_axi_vectors;
    import pynq_accel_pkg::*;

    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [7:0] awaddr, araddr;
    logic awvalid, awready, wvalid, wready, bvalid, bready;
    logic [31:0] wdata, rdata;
    logic [3:0] wstrb;
    logic [1:0] bresp, rresp;
    logic arvalid, arready, rvalid, rready;
    logic [3:0] leds;
    longint cycle = 0;
    longint start_cycle = 0;
    longint done_cycle = 0;

    pynq_accel_top dut (
        .s_axi_aclk(clk), .s_axi_aresetn(rst_n),
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .leds(leds)
    );

    always #5 clk = ~clk;
    always @(posedge clk) begin
        cycle <= cycle + 1;
        if (dut.accel_start) start_cycle <= cycle;
        if (dut.u_core.u_chip.output_valid) done_cycle <= cycle;
    end

    task automatic axi_write(input logic [7:0] addr, input logic [31:0] data);
        begin
            @(negedge clk);
            awaddr = addr; awvalid = 1'b1;
            wdata = data; wstrb = 4'hf; wvalid = 1'b1;
            while (!(awready && wready)) @(negedge clk);
            @(negedge clk);
            awvalid = 1'b0; wvalid = 1'b0; bready = 1'b1;
            while (!bvalid) @(negedge clk);
            if (bresp != 2'b00) $fatal(1, "AXI write failed at %02h", addr);
            @(negedge clk); bready = 1'b0;
        end
    endtask

    task automatic axi_read(input logic [7:0] addr, output logic [31:0] data);
        begin
            @(negedge clk); araddr = addr; arvalid = 1'b1;
            while (!arready) @(negedge clk);
            @(negedge clk); arvalid = 1'b0; rready = 1'b1;
            while (!rvalid) @(negedge clk);
            if (rresp != 2'b00) $fatal(1, "AXI read failed at %02h", addr);
            data = rdata;
            @(negedge clk); rready = 1'b0;
        end
    endtask

    initial begin
        string vec_path, out_path;
        int fin, fout, n, runs;
        int tiles;
        logic [31:0] w [4];
        logic [31:0] a [4];
        logic [31:0] r [4];
        logic [31:0] status, error_word;
        longint t_run;
        int timeout;

        if (!$value$plusargs("VEC=%s", vec_path)) vec_path = "vectors.txt";
        if (!$value$plusargs("OUT=%s", out_path)) out_path = "results.txt";
        fin = $fopen(vec_path, "r");
        if (fin == 0) $fatal(1, "Cannot open %s", vec_path);
        fout = $fopen(out_path, "w");
        if (fout == 0) $fatal(1, "Cannot open %s", out_path);

        awaddr = '0; awvalid = 0; wdata = '0; wstrb = '0; wvalid = 0; bready = 0;
        araddr = '0; arvalid = 0; rready = 0;
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (3) @(posedge clk);

        runs = 0;
        n = $fscanf(fin, "%h %h %h %h %h %h %h %h %h\n",
                    tiles, w[0], w[1], w[2], w[3], a[0], a[1], a[2], a[3]);
        while (n == 9) begin

            t_run = cycle;
            axi_write(PYNQ_REG_CTRL, 32'h2);
            axi_write(PYNQ_REG_TILE_COUNT, tiles);
            for (int i = 0; i < tiles; i++) axi_write(PYNQ_REG_WEIGHT_DATA, w[i]);
            for (int i = 0; i < tiles; i++) axi_write(PYNQ_REG_ACT_DATA, a[i]);
            axi_write(PYNQ_REG_CTRL, 32'h5);

            timeout = 0;
            status = '0;
            while (!status[PYNQ_STATUS_DONE_BIT] && timeout < 5000) begin
                axi_read(PYNQ_REG_STATUS, status);
                timeout++;
            end
            if (!status[PYNQ_STATUS_DONE_BIT]) $fatal(1, "Run %0d timed out", runs);

            for (int i = 0; i < 4; i++) r[i] = '0;
            for (int i = 0; i < tiles; i++) axi_read(PYNQ_REG_RESULT, r[i]);
            axi_read(PYNQ_REG_ERROR, error_word);
            if (error_word != 0) $fatal(1, "Run %0d error flags %08h", runs, error_word);

            $fdisplay(fout, "%08h %08h %08h %08h %0d %0d", r[0], r[1], r[2], r[3],
                      done_cycle - start_cycle, cycle - t_run);
            runs++;
            n = $fscanf(fin, "%h %h %h %h %h %h %h %h %h\n",
                        tiles, w[0], w[1], w[2], w[3], a[0], a[1], a[2], a[3]);
        end

        $fclose(fin);
        $fclose(fout);
        $display("tb_pynq_axi_vectors: %0d runs complete", runs);
        $finish;
    end
endmodule
