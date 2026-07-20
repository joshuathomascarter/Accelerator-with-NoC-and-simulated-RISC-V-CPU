`timescale 1ns/1ps
module tb_pynq_axi_four_tiles;
    logic passed;
    pynq_axi_e2e_case #(.RUN_TILES(4)) test_case(.passed(passed));
    initial begin
        wait (passed);
        #20 $finish;
    end
endmodule
