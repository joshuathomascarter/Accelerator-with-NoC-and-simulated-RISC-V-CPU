// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VTB_PYNQ_AXI_SINGLE_TILE__SYMS_H_
#define VERILATED_VTB_PYNQ_AXI_SINGLE_TILE__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vtb_pynq_axi_single_tile.h"

// INCLUDE MODULE CLASSES
#include "Vtb_pynq_axi_single_tile___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vtb_pynq_axi_single_tile__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vtb_pynq_axi_single_tile* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vtb_pynq_axi_single_tile___024root TOP;

    // CONSTRUCTORS
    Vtb_pynq_axi_single_tile__Syms(VerilatedContext* contextp, const char* namep, Vtb_pynq_axi_single_tile* modelp);
    ~Vtb_pynq_axi_single_tile__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
};

#endif  // guard
