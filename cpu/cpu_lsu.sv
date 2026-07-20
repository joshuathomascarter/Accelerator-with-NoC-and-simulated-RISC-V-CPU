module cpu_lsu (
    input  cpu_pkg::cpu_inst_t           decoded_inst,
    input  logic [cpu_pkg::CPU_XLEN-1:0] address,
    input  logic [cpu_pkg::CPU_XLEN-1:0] store_data,
    input  logic [cpu_pkg::CPU_XLEN-1:0] dmem_rd_data,

    output logic                         dmem_rd_en,
    output logic                         dmem_wr_en,
    output logic [cpu_pkg::CPU_XLEN-1:0] dmem_addr,
    output logic [cpu_pkg::CPU_XLEN-1:0] dmem_wr_data,
    output logic [cpu_pkg::CPU_XLEN-1:0] load_data,
    output logic                         misaligned
);
    import cpu_pkg::*;

    always_comb begin
        dmem_rd_en   = 1'b0;
        dmem_wr_en   = 1'b0;
        dmem_addr    = address;
        dmem_wr_data = store_data;
        load_data    = dmem_rd_data;
        misaligned   = 1'b0;

        unique case (decoded_inst)
            CPU_INST_LW: begin
                dmem_rd_en = 1'b1;
                misaligned = |address[1:0];
            end

            CPU_INST_SW: begin
                dmem_wr_en = 1'b1;
                misaligned = |address[1:0];
            end

            default: begin
                dmem_rd_en = 1'b0;
                dmem_wr_en = 1'b0;
            end
        endcase

        if (misaligned) begin
            dmem_rd_en = 1'b0;
            dmem_wr_en = 1'b0;
        end
    end

endmodule
