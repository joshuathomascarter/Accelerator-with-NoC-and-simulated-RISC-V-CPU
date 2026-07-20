param([string]$Iverilog = "iverilog", [string]$Vvp = "vvp")

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$build = Join-Path $root "Sim/build"
New-Item -ItemType Directory -Force -Path $build | Out-Null

$rtl = @(
    "accelerator/Communication/noc_packet.sv",
    "rtl/pynq_accel_pkg.sv",
    "accelerator/Communication/noc_endpoint.sv",
    "accelerator/Communication/noc_router.sv",
    "accelerator/Communication/simple_grid_noc.sv",
    "accelerator/Communication/schedular.sv",
    "accelerator/Storage/sram.sv",
    "accelerator/Storage/tile_scratchpad.sv",
    "accelerator/computation/mac.sv",
    "accelerator/computation/pe.sv",
    "accelerator/computation/systolic_array.sv",
    "accelerator/computation/tile.sv",
    "accelerator/chip_top.sv",
    "rtl/pynq_accel_axi_lite.sv",
    "rtl/axi_result_readback.sv",
    "rtl/pynq_accel_top.sv",
    "Tests/pynq_axi_e2e_case.sv"
)

Push-Location $root
try {
    foreach ($case in @("single_tile", "four_tiles")) {
        $top = "tb_pynq_axi_$case"
        $out = Join-Path $build "$top.vvp"
        & $Iverilog -g2012 -s $top -o $out @rtl "Tests/$top.sv"
        if ($LASTEXITCODE -ne 0) { throw "Compilation failed for $top" }
        & $Vvp $out
        if ($LASTEXITCODE -ne 0) { throw "Simulation failed for $top" }
    }
} finally {
    Pop-Location
}
