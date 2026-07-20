// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_pynq_axi_single_tile__pch.h"

//============================================================
// Constructors

Vtb_pynq_axi_single_tile::Vtb_pynq_axi_single_tile(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtb_pynq_axi_single_tile__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vtb_pynq_axi_single_tile::Vtb_pynq_axi_single_tile(const char* _vcname__)
    : Vtb_pynq_axi_single_tile(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtb_pynq_axi_single_tile::~Vtb_pynq_axi_single_tile() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtb_pynq_axi_single_tile___024root___eval_debug_assertions(Vtb_pynq_axi_single_tile___024root* vlSelf);
#endif  // VL_DEBUG
void Vtb_pynq_axi_single_tile___024root___eval_static(Vtb_pynq_axi_single_tile___024root* vlSelf);
void Vtb_pynq_axi_single_tile___024root___eval_initial(Vtb_pynq_axi_single_tile___024root* vlSelf);
void Vtb_pynq_axi_single_tile___024root___eval_settle(Vtb_pynq_axi_single_tile___024root* vlSelf);
void Vtb_pynq_axi_single_tile___024root___eval(Vtb_pynq_axi_single_tile___024root* vlSelf);

void Vtb_pynq_axi_single_tile::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtb_pynq_axi_single_tile::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtb_pynq_axi_single_tile___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtb_pynq_axi_single_tile___024root___eval_static(&(vlSymsp->TOP));
        Vtb_pynq_axi_single_tile___024root___eval_initial(&(vlSymsp->TOP));
        Vtb_pynq_axi_single_tile___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtb_pynq_axi_single_tile___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtb_pynq_axi_single_tile::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty() && !contextp()->gotFinish(); }

uint64_t Vtb_pynq_axi_single_tile::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vtb_pynq_axi_single_tile::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtb_pynq_axi_single_tile___024root___eval_final(Vtb_pynq_axi_single_tile___024root* vlSelf);

VL_ATTR_COLD void Vtb_pynq_axi_single_tile::final() {
    contextp()->executingFinal(true);
    Vtb_pynq_axi_single_tile___024root___eval_final(&(vlSymsp->TOP));
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtb_pynq_axi_single_tile::hierName() const { return vlSymsp->name(); }
const char* Vtb_pynq_axi_single_tile::modelName() const { return "Vtb_pynq_axi_single_tile"; }
unsigned Vtb_pynq_axi_single_tile::threads() const { return 1; }
void Vtb_pynq_axi_single_tile::prepareClone() const { contextp()->prepareClone(); }
void Vtb_pynq_axi_single_tile::atClone() const {
    contextp()->threadPoolpOnClone();
}
