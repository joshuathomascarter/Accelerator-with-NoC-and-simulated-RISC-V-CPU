`timescale 1ns/1ps

// Command-file AXI-Lite master for pynq_soc_top. Python (mini_accel.cpu_host)
// writes the commands, so the same sequence can drive this simulation or the
// real board over JTAG. One command per line, values in hex:
//   W <addr> <data>          write a word
//   R <addr>                 read a word        -> "R <addr> <data>"
//   P <addr> <mask> <value>  poll until (read & mask) == value -> "P <cycles waited>"
//   C                        print the clock count -> "C <cycles>"
// Files default to cmds.txt / results.txt; override with +CMDS= / +OUT=.
module tb_pynq_soc_cmds;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [12:0] awaddr, araddr;
    logic awvalid, awready, wvalid, wready, bvalid, bready;
    logic [31:0] wdata, rdata;
    logic [3:0] wstrb;
    logic [1:0] bresp, rresp;
    logic arvalid, arready, rvalid, rready;
    logic [3:0] leds;
    longint cycle = 0;

    pynq_soc_top dut (
        .s_axi_aclk(clk), .s_axi_aresetn(rst_n),
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .leds(leds)
    );

    always #5 clk = ~clk;
    always @(posedge clk) cycle <= cycle + 1;

    task automatic axi_write(input logic [12:0] addr, input logic [31:0] data);
        begin
            @(negedge clk);
            awaddr = addr; awvalid = 1'b1;
            wdata = data; wstrb = 4'hf; wvalid = 1'b1;
            while (!(awready && wready)) @(negedge clk);
            @(negedge clk);
            awvalid = 1'b0; wvalid = 1'b0; bready = 1'b1;
            while (!bvalid) @(negedge clk);
            if (bresp != 2'b00) $fatal(1, "AXI write failed at %04h", addr);
            @(negedge clk); bready = 1'b0;
        end
    endtask

    task automatic axi_read(input logic [12:0] addr, output logic [31:0] data);
        begin
            @(negedge clk); araddr = addr; arvalid = 1'b1;
            while (!arready) @(negedge clk);
            @(negedge clk); arvalid = 1'b0; rready = 1'b1;
            while (!rvalid) @(negedge clk);
            if (rresp != 2'b00) $fatal(1, "AXI read failed at %04h", addr);
            data = rdata;
            @(negedge clk); rready = 1'b0;
        end
    endtask

    initial begin
        string cmd_path, out_path, op;
        int fin, fout, n, lines;
        logic [31:0] a, d, mask, value, rd;
        longint t0;

        if (!$value$plusargs("CMDS=%s", cmd_path)) cmd_path = "cmds.txt";
        if (!$value$plusargs("OUT=%s", out_path)) out_path = "results.txt";
        fin = $fopen(cmd_path, "r");
        if (fin == 0) $fatal(1, "Cannot open %s", cmd_path);
        fout = $fopen(out_path, "w");

        awaddr = '0; awvalid = 0; wdata = '0; wstrb = '0; wvalid = 0; bready = 0;
        araddr = '0; arvalid = 0; rready = 0;
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (3) @(posedge clk);

        lines = 0;
        n = $fscanf(fin, "%s", op);
        while (n == 1) begin
            if (op == "W") begin
                void'($fscanf(fin, "%h %h", a, d));
                axi_write(a[12:0], d);
            end else if (op == "R") begin
                void'($fscanf(fin, "%h", a));
                axi_read(a[12:0], rd);
                $fdisplay(fout, "R %04h %08h", a[12:0], rd);
            end else if (op == "P") begin
                void'($fscanf(fin, "%h %h %h", a, mask, value));
                t0 = cycle;
                axi_read(a[12:0], rd);
                while ((rd & mask) != value) begin
                    if (cycle - t0 > 5_000_000) $fatal(1, "Poll of %04h timed out", a[12:0]);
                    axi_read(a[12:0], rd);
                end
                $fdisplay(fout, "P %0d", cycle - t0);
            end else if (op == "C") begin
                $fdisplay(fout, "C %0d", cycle);
            end else begin
                $fatal(1, "Unknown command %s", op);
            end
            lines++;
            n = $fscanf(fin, "%s", op);
        end

        $fclose(fin);
        $fclose(fout);
        $display("tb_pynq_soc_cmds: %0d commands complete", lines);
        $finish;
    end
endmodule
