module cpu_imem #(
    parameter int INSTR_WIDTH = 32,
    parameter int DEPTH = 256,
    parameter string INIT_FILE = ""
)(
    input  logic [31:0] pc,
    output logic [INSTR_WIDTH-1:0] instruction
);

    localparam int ADDR_W = $clog2(DEPTH);

    logic [INSTR_WIDTH-1:0] imem [DEPTH];

    initial begin
        for (int i = 0; i < DEPTH; i++) begin
            imem[i] = '0;
        end

        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, imem);
        end
    end

    always_comb begin
        if ((pc >> 2) < DEPTH) begin
            instruction = imem[pc[ADDR_W+1:2]];
        end else begin
            instruction = '0; // or illegal instruction
        end
    end

endmodule