// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_pynq_axi_single_tile.h for the primary calling header

#include "Vtb_pynq_axi_single_tile__pch.h"

void Vtb_pynq_axi_single_tile___024root___ctor_var_reset(Vtb_pynq_axi_single_tile___024root* vlSelf);

Vtb_pynq_axi_single_tile___024root::Vtb_pynq_axi_single_tile___024root(Vtb_pynq_axi_single_tile__Syms* symsp, const char* namep)
    : __VdlySched{*symsp->_vm_contextp__}
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vtb_pynq_axi_single_tile___024root___ctor_var_reset(this);
}

void Vtb_pynq_axi_single_tile___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtb_pynq_axi_single_tile___024root::~Vtb_pynq_axi_single_tile___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
