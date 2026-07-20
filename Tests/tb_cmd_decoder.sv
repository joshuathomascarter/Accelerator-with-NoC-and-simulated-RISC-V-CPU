`timescale 1ns / 1ps

module tb_cmd_decoder();
    import isa_pkg::*;

    parameter int DATA_WIDTH = 32;
    parameter int ADDR_W     = 4;

    logic clk = 1'b0;
    logic rst_n;

    // Byte stream into decoder
    logic [7:0] rx_byte;
    logic       rx_valid;

    // Register file signals
    logic                   rf_wr_en;
    logic [ADDR_W-1:0]      rf_wr_addr;
    logic [DATA_WIDTH-1:0]  rf_wr_data;
    logic [ADDR_W-1:0]      rf_rd_addr_a, rf_rd_addr_b;
    logic [DATA_WIDTH-1:0]  rf_rd_data_a, rf_rd_data_b;

    // ALU signals
    logic [2:0]             alu_op;
    logic                   alu_en;
    logic [DATA_WIDTH-1:0]  alu_result;
    logic                   alu_valid, alu_zero;

    // Packer signals
    logic                   packer_start, packer_busy;
    logic [DATA_WIDTH-1:0]  packer_data;

    // Done
    logic done;

    always #10 clk = ~clk;

    // ── DUT ───────────────────────────────────────────────────────────────
    cmd_decoder #(.DATA_WIDTH(DATA_WIDTH), .ADDR_W(ADDR_W)) dut (
        .clk(clk), .rst_n(rst_n),
        .rx_byte(rx_byte), .rx_valid(rx_valid),
        .rf_wr_en(rf_wr_en), .rf_wr_addr(rf_wr_addr), .rf_wr_data(rf_wr_data),
        .rf_rd_addr_a(rf_rd_addr_a), .rf_rd_data_a(rf_rd_data_a),
        .rf_rd_addr_b(rf_rd_addr_b), .rf_rd_data_b(rf_rd_data_b),
        .alu_op(alu_op), .alu_en(alu_en),
        .alu_result(alu_result), .alu_valid(alu_valid),
        .packer_start(packer_start), .packer_data(packer_data),
        .packer_busy(packer_busy),
        .done(done)
    );

    register_file #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(16), .ADDR_W(ADDR_W)) regfile (
        .clk(clk), .rst_n(rst_n),
        .wr_en(rf_wr_en), .wr_addr(rf_wr_addr), .wr_data(rf_wr_data),
        .rd_addr_a(rf_rd_addr_a), .rd_data_a(rf_rd_data_a),
        .rd_addr_b(rf_rd_addr_b), .rd_data_b(rf_rd_data_b)
    );

    alu_unit #(.DATA_WIDTH(8), .RESULT_WIDTH(DATA_WIDTH)) alu (
        .clk(clk), .rst_n(rst_n),
        .alu_en(alu_en),
        .a(rf_rd_data_a[7:0]),
        .b(rf_rd_data_b[7:0]),
        .operation(alu_op),
        .result(alu_result),
        .zero(alu_zero),
        .valid(alu_valid)
    );

    // ── Tasks ─────────────────────────────────────────────────────────────

    // Send one byte into the decoder
    task automatic send_byte(input logic [7:0] val);
        @(posedge clk);
        rx_byte  = val;
        rx_valid = 1'b1;
        @(posedge clk);
        rx_valid = 1'b0;
    endtask

    // Build and send a 4-byte instruction header
    // Byte 0: opcode | Byte 1: {rs1,rs2} | Byte 2: {rd, pad} | Byte 3: pad
    task automatic send_instr(
        input opcode_t op,
        input logic [3:0] rs1, rs2, rd
    );
        send_byte(op);
        send_byte({rs1, rs2});
        send_byte({rd, 4'h0});
        send_byte(8'h00);
    endtask

    // WRITE rd = data  (instruction + 4 payload bytes, LSB first)
    task automatic do_write(
        input logic [3:0] rd,
        input logic [31:0] data
    );
        send_instr(OP_WRITE, 4'h0, 4'h0, rd);
        send_byte(data[7:0]);
        send_byte(data[15:8]);
        send_byte(data[23:16]);
        send_byte(data[31:24]);
        @(posedge done);   // fires same cycle as rf_wr_en
        repeat (2) @(posedge clk);  // let register file NBA propagate
    endtask

    // READ rd  (send instruction, wait for packer_start)
    task automatic do_read(input logic [3:0] rd);
        send_instr(OP_READ, 4'h0, 4'h0, rd);
        @(posedge packer_start);
        // packer_data is valid RIGHT NOW (same cycle as packer_start fires)
        // Don't wait another clock - state machine will exit ST_READ_EXEC
    endtask

    // ALU op  (send instruction, wait for done)
    task automatic do_alu(
        input opcode_t op,
        input logic [3:0] rs1, rs2, rd
    );
        send_instr(op, rs1, rs2, rd);
        @(posedge done);
        repeat (2) @(posedge clk);
    endtask

    // ── Tests ─────────────────────────────────────────────────────────────
    initial begin
        rst_n      = 1'b0;
        rx_valid   = 1'b0;
        packer_busy = 1'b0;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (4) @(posedge clk);

        // ── Test 1: WRITE ──────────────────────────────────────────────
        $display("Test 1: WRITE 0xCAFEBABE to reg3");
        $monitor("t=%0t  state=%0d  rx_valid=%b  rf_wr_en=%b  rf_wr_addr=%h  rf_wr_data=%h  done=%b",
                 $time, dut.state, rx_valid, rf_wr_en, rf_wr_addr, rf_wr_data, done);
        do_write(4'h3, 32'hCAFEBABE);
        $monitoroff;
        if (regfile.mem[3] !== 32'hCAFEBABE) begin
            $display("FAIL: reg3 = %h (expected CAFEBABE)", regfile.mem[3]);
            $finish;
        end
        $display("  PASS  reg3 = %h", regfile.mem[3]);

        // ── Test 2: READ ───────────────────────────────────────────────
        $display("Test 2: READ reg3 -> packer_data");
        do_read(4'h3);
        if (packer_data !== 32'hCAFEBABE) begin
            $display("FAIL: packer_data = %h (expected CAFEBABE)", packer_data);
            $finish;
        end
        $display("  PASS  packer_data = %h", packer_data);

        // ── Test 3: ADD  reg0 + reg1 -> reg2 ──────────────────────────
        $display("Test 3: WRITE reg0=10, reg1=25, then ADD -> reg2");
        do_write(4'h0, 32'd10);
        do_write(4'h1, 32'd25);
        do_alu(OP_ADD, 4'h0, 4'h1, 4'h2);
        if (regfile.mem[2] !== 32'd35) begin
            $display("FAIL: reg2 = %0d (expected 35)", regfile.mem[2]);
            $finish;
        end
        $display("  PASS  reg2 = %0d (10 + 25)", regfile.mem[2]);

        // ── Test 4: MUL  reg0 * reg1 -> reg4 ──────────────────────────
        $display("Test 4: MUL reg0(10) * reg1(25) -> reg4");
        do_alu(OP_MUL, 4'h0, 4'h1, 4'h4);
        if (regfile.mem[4] !== 32'd250) begin
            $display("FAIL: reg4 = %0d (expected 250)", regfile.mem[4]);
            $finish;
        end
        $display("  PASS  reg4 = %0d (10 * 25)", regfile.mem[4]);

        // ── Test 5: SUB  reg1 - reg0 -> reg5 ──────────────────────────
        $display("Test 5: SUB reg1(25) - reg0(10) -> reg5");
        do_alu(OP_SUB, 4'h1, 4'h0, 4'h5);
        if (regfile.mem[5] !== 32'd15) begin
            $display("FAIL: reg5 = %0d (expected 15)", regfile.mem[5]);
            $finish;
        end
        $display("  PASS  reg5 = %0d (25 - 10)", regfile.mem[5]);

        $display("\nAll tests PASSED");
        $finish;
    end

endmodule
