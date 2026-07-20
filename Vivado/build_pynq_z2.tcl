# Build the complete PYNQ-Z2 AXI-Lite accelerator overlay.
# Run from any directory with:
#   vivado -mode batch -source Vivado/build_pynq_z2.tcl

set script_dir [file dirname [file normalize [info script]]]
set repo_root  [file normalize [file join $script_dir ..]]
set accel_root [file join $repo_root accelerator]
set proj_dir   [file join $repo_root build vivado_pynq_z2]

file mkdir $proj_dir
create_project mini_accel_pynq_z2 $proj_dir -part xc7z020clg400-1 -force
catch { set_property board_part tul.com.tw:pynq-z2:part0:1.0 [current_project] }

set rtl_files [list \
    [file join $accel_root isa_pkg.sv] \
    [file join $accel_root Communication noc_packet.sv] \
    [file join $repo_root rtl pynq_accel_pkg.sv] \
    [file join $accel_root Communication noc_endpoint.sv] \
    [file join $accel_root Communication noc_router.sv] \
    [file join $accel_root Communication simple_grid_noc.sv] \
    [file join $accel_root Communication schedular.sv] \
    [file join $accel_root Storage sram.sv] \
    [file join $accel_root Storage tile_scratchpad.sv] \
    [file join $accel_root computation mac.sv] \
    [file join $accel_root computation pe.sv] \
    [file join $accel_root computation systolic_array.sv] \
    [file join $accel_root computation tile.sv] \
    [file join $accel_root chip_top.sv] \
    [file join $repo_root rtl pynq_accel_axi_lite.sv] \
    [file join $repo_root rtl axi_result_readback.sv] \
    [file join $repo_root rtl pynq_accel_top.sv] \
]

foreach rtl_file $rtl_files {
    if {![file exists $rtl_file]} { error "Missing RTL source: $rtl_file" }
    add_files -norecurse $rtl_file
}
set_property file_type SystemVerilog [get_files *.sv]
add_files -fileset constrs_1 [file join $script_dir pynq_z2_leds.xdc]
update_compile_order -fileset sources_1

create_bd_design mini_accel_bd
set ps [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
    -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable"} $ps
set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.000000}] $ps

set rst [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M]
set accel [create_bd_cell -type module -reference pynq_accel_top accel_0]

connect_bd_net [get_bd_pins $ps/FCLK_CLK0] [get_bd_pins $accel/s_axi_aclk] [get_bd_pins $rst/slowest_sync_clk]
connect_bd_net [get_bd_pins $ps/FCLK_RESET0_N] [get_bd_pins $rst/ext_reset_in]
connect_bd_net [get_bd_pins $rst/peripheral_aresetn] [get_bd_pins $accel/s_axi_aresetn]

apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
    -config {Master "/processing_system7_0/M_AXI_GP0" Clk_master "/processing_system7_0/FCLK_CLK0" Clk_slave "/processing_system7_0/FCLK_CLK0"} \
    [get_bd_intf_pins $accel/S_AXI]

set led_port [make_bd_pins_external [get_bd_pins $accel/leds]]
set_property name leds $led_port
assign_bd_address
set accel_seg [get_bd_addr_segs -of_objects [get_bd_addr_spaces $ps/Data] -filter {NAME =~ *accel_0*}]
if {[llength $accel_seg] != 1} { error "Could not identify accelerator AXI address segment" }
set_property offset 0x43C00000 $accel_seg
set_property range 64K $accel_seg

validate_bd_design
save_bd_design
set bd_file [get_files mini_accel_bd.bd]
generate_target all $bd_file
make_wrapper -files $bd_file -top
set wrapper [file join $proj_dir mini_accel_pynq_z2.gen sources_1 bd mini_accel_bd hdl mini_accel_bd_wrapper.v]
add_files -norecurse $wrapper
set_property top mini_accel_bd_wrapper [current_fileset]
update_compile_order -fileset sources_1

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "Implementation did not complete" }

set out_dir [file join $repo_root overlays mini_accel]
file mkdir $out_dir
file copy -force [get_property BITSTREAM.FILE [get_runs impl_1]] [file join $out_dir mini_accel.bit]
set hwh_files [glob -nocomplain [file join $proj_dir *.gen sources_1 bd mini_accel_bd hw_handoff *.hwh]]
if {[llength $hwh_files] == 0} { error "Vivado did not generate an HWH file" }
file copy -force [lindex $hwh_files 0] [file join $out_dir mini_accel.hwh]

open_run impl_1
report_utilization -file [file join $out_dir utilization.rpt]
report_timing_summary -file [file join $out_dir timing_summary.rpt]
puts "Overlay complete: $out_dir/mini_accel.bit and mini_accel.hwh"
