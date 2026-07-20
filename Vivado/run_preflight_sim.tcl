# Run both board-facing AXI simulations with Vivado XSIM.
# Usage: vivado -mode batch -source Vivado/run_preflight_sim.tcl

set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ..]]
cd $repo_root
file mkdir [file join Sim xsim]

set sources [list \
    accelerator/Communication/noc_packet.sv rtl/pynq_accel_pkg.sv \
    accelerator/Communication/noc_endpoint.sv accelerator/Communication/noc_router.sv \
    accelerator/Communication/simple_grid_noc.sv accelerator/Communication/schedular.sv \
    accelerator/Storage/sram.sv accelerator/Storage/tile_scratchpad.sv \
    accelerator/computation/mac.sv accelerator/computation/pe.sv \
    accelerator/computation/systolic_array.sv accelerator/computation/tile.sv \
    accelerator/chip_top.sv rtl/pynq_accel_axi_lite.sv rtl/axi_result_readback.sv \
    rtl/pynq_accel_top.sv Tests/pynq_axi_e2e_case.sv \
    Tests/tb_pynq_axi_single_tile.sv Tests/tb_pynq_axi_four_tiles.sv \
]

exec xvlog -sv {*}$sources
foreach top {tb_pynq_axi_single_tile tb_pynq_axi_four_tiles} {
    set snapshot ${top}_snapshot
    exec xelab $top -s $snapshot -debug typical
    exec xsim $snapshot -runall
    puts "PASS: $top"
}
puts "All PYNQ AXI preflight simulations passed"
