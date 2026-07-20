// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtb_pynq_axi_single_tile__pch.h"

Vtb_pynq_axi_single_tile__Syms::Vtb_pynq_axi_single_tile__Syms(VerilatedContext* contextp, const char* namep, Vtb_pynq_axi_single_tile* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup top module instance
    , TOP{this, namep}
{
    // Check resources
    Verilated::stackCheck(2487);
    // Setup sub module instances
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}

Vtb_pynq_axi_single_tile__Syms::~Vtb_pynq_axi_single_tile__Syms() {
    // Tear down scopes
    // Tear down sub module instances
}
