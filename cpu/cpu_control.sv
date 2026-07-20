module cpu_control (
    input logic clk,
    input logic rst_n,

    output logic pc_write,
    output logic instr_write
);


typedef enum logic [1:0] {
    CPU_STATE_RESET,
    CPU_STATE_FETCH
} cpu_state_t;

cpu_state_t state_q;
cpu_state_t state_d;

always_comb begin
    state_d = state_q;
    pc_write = 1'b0;
    instr_write = 1'b0;

    unique case (state_q) 
    CPU_STATE_RESET: begin
        state_d = CPU_STATE_FETCH;
        end

    CPU_STATE_FETCH: begin
        pc_write = 1'b1;
        instr_write =1'b1;
        state_d = CPU_STATE_FETCH;
        end

    default:begin
        state_d = CPU_STATE_RESET;
        
    end

    endcase
end



always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_q <= CPU_STATE_RESET;
    end else begin
        state_q <= state_d;
    end
end
endmodule
