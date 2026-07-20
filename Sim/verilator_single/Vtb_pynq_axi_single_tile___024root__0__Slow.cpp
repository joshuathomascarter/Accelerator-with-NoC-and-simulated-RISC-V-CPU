// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_pynq_axi_single_tile.h for the primary calling header

#include "Vtb_pynq_axi_single_tile__pch.h"

void Vtb_pynq_axi_single_tile___024root___timing_ready(Vtb_pynq_axi_single_tile___024root* vlSelf);

VL_ATTR_COLD void Vtb_pynq_axi_single_tile___024root___eval_static(Vtb_pynq_axi_single_tile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___eval_static\n"); );
    Vtb_pynq_axi_single_tile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    {
        // Inlined CFunc: _eval_static__TOP
        IData/*31:0*/ __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols;
        __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0;
        IData/*31:0*/ __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols;
        __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0;
        IData/*31:0*/ __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols;
        __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0;
        IData/*31:0*/ __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols;
        __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__clk = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__rst_n = 0U;
        const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__unnamedblk1__DOT__status = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17044138353242329755ull);
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__unnamedblk1__DOT__error_word = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14961702443029941586ull);
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__unnamedblk1__DOT__timeout = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__unnamedblk3__DOT__dst_idx = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__unnamedblk3__DOT__in_class_idx = 0U;
        __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0U;
        __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0U;
        __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0U;
        __Vinline_0__eval_static__TOP_tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0U;
    }
    vlSelfRef.__VactTriggered[0U] = (4ULL | vlSelfRef.__VactTriggered[0U]);
    vlSelfRef.__Vtrigprevexpr___TOP__tb_pynq_axi_single_tile__DOT__test_case__DOT__clk__0 = 0U;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_pynq_axi_single_tile__DOT__test_case__DOT__rst_n__0 = 0U;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_pynq_axi_single_tile__DOT__passed__0 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__passed;
    Vtb_pynq_axi_single_tile___024root___timing_ready(vlSelf);
    do {
        vlSelfRef.__VactTriggeredAcc[vlSelfRef.__Vi] 
            = vlSelfRef.__VactTriggered[vlSelfRef.__Vi];
        vlSelfRef.__Vi = ((IData)(1U) + vlSelfRef.__Vi);
    } while ((0U >= vlSelfRef.__Vi));
}

VL_ATTR_COLD void Vtb_pynq_axi_single_tile___024root___eval_final(Vtb_pynq_axi_single_tile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___eval_final\n"); );
    Vtb_pynq_axi_single_tile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_pynq_axi_single_tile___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtb_pynq_axi_single_tile___024root___eval_phase__stl(Vtb_pynq_axi_single_tile___024root* vlSelf);

VL_ATTR_COLD void Vtb_pynq_axi_single_tile___024root___eval_settle(Vtb_pynq_axi_single_tile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___eval_settle\n"); );
    Vtb_pynq_axi_single_tile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vtb_pynq_axi_single_tile___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("Tests\\tb_pynq_axi_single_tile.sv", 2, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 10000 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vtb_pynq_axi_single_tile___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD bool Vtb_pynq_axi_single_tile___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_pynq_axi_single_tile___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vtb_pynq_axi_single_tile___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vtb_pynq_axi_single_tile___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___trigger_anySet__stl\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

VL_ATTR_COLD void Vtb_pynq_axi_single_tile___024root___stl_sequent__TOP__0(Vtb_pynq_axi_single_tile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___stl_sequent__TOP__0\n"); );
    Vtb_pynq_axi_single_tile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit;
    CData/*7:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__activation_data_req;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__activation_data_req = 0;
    SData/*15:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__row_weight_data_req;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__row_weight_data_req = 0;
    IData/*31:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0;
    CData/*7:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__activation_data_req;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__activation_data_req = 0;
    SData/*15:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__row_weight_data_req;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__row_weight_data_req = 0;
    IData/*31:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0;
    CData/*7:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__activation_data_req;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__activation_data_req = 0;
    SData/*15:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__row_weight_data_req;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__row_weight_data_req = 0;
    IData/*31:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0;
    CData/*7:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__activation_data_req;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__activation_data_req = 0;
    SData/*15:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__row_weight_data_req;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__row_weight_data_req = 0;
    IData/*31:0*/ tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0;
    CData/*0:0*/ __Vfunc_noc_class_for_flit__10__Vfuncout;
    __Vfunc_noc_class_for_flit__10__Vfuncout = 0;
    QData/*45:0*/ __Vfunc_noc_class_for_flit__10__flit;
    __Vfunc_noc_class_for_flit__10__flit = 0;
    CData/*0:0*/ __Vfunc_noc_class_for_type__11__Vfuncout;
    __Vfunc_noc_class_for_type__11__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_noc_class_for_type__11__payload_type;
    __Vfunc_noc_class_for_type__11__payload_type = 0;
    CData/*2:0*/ __VdfgRegularize_h6e95ff9d_0_5;
    __VdfgRegularize_h6e95ff9d_0_5 = 0;
    CData/*2:0*/ __VdfgRegularize_h6e95ff9d_0_6;
    __VdfgRegularize_h6e95ff9d_0_6 = 0;
    CData/*2:0*/ __VdfgRegularize_h6e95ff9d_0_7;
    __VdfgRegularize_h6e95ff9d_0_7 = 0;
    CData/*2:0*/ __VdfgRegularize_h6e95ff9d_0_8;
    __VdfgRegularize_h6e95ff9d_0_8 = 0;
    CData/*2:0*/ __VdfgRegularize_h6e95ff9d_0_9;
    __VdfgRegularize_h6e95ff9d_0_9 = 0;
    CData/*2:0*/ __VdfgRegularize_h6e95ff9d_0_10;
    __VdfgRegularize_h6e95ff9d_0_10 = 0;
    CData/*2:0*/ __VdfgRegularize_h6e95ff9d_0_11;
    __VdfgRegularize_h6e95ff9d_0_11 = 0;
    CData/*2:0*/ __VdfgRegularize_h6e95ff9d_0_12;
    __VdfgRegularize_h6e95ff9d_0_12 = 0;
    // Body
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__read_addr_valid 
        = ((~ (IData)((0U != (0xc3U & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__araddr))))) 
           & (0U == (3U & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__araddr))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__tile_count_valid 
        = ((0U < vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_tile_count) 
           & (4U >= vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_tile_count));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_valid 
        = (((((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[3U]) 
              << 1U) | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[2U]) 
            << 2U) | (((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[1U]) 
                       << 1U) | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[0U]));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__write_addr_valid 
        = ((~ (IData)((0U != (0xc3U & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__awaddr_q))))) 
           & (0U == (3U & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__awaddr_q))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__awready 
        = (1U & (~ ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__bvalid) 
                    | (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__aw_pending_q))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__wready 
        = (1U & (~ ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__bvalid) 
                    | (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__w_pending_q))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__read_fire 
        = ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__rvalid)) 
           & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__arvalid));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__write_fire 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__aw_pending_q) 
           & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__bvalid)) 
              & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__w_pending_q)));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__weight_col_load_req = 0U;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0U;
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unpack_weight_active_q) {
        tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols 
            = ((IData)(1U) - (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__weight_preload_col_q));
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__weight_col_load_req 
            = ((VL_LTES_III(32, 1U, tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols) 
                << 1U) | VL_LTES_III(32, 0U, tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols));
    }
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__weight_col_load_req = 0U;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0U;
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unpack_weight_active_q) {
        tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols 
            = ((IData)(1U) - (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__weight_preload_col_q));
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__weight_col_load_req 
            = ((VL_LTES_III(32, 1U, tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols) 
                << 1U) | VL_LTES_III(32, 0U, tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols));
    }
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__weight_col_load_req = 0U;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0U;
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unpack_weight_active_q) {
        tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols 
            = ((IData)(1U) - (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__weight_preload_col_q));
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__weight_col_load_req 
            = ((VL_LTES_III(32, 1U, tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols) 
                << 1U) | VL_LTES_III(32, 0U, tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols));
    }
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__weight_col_load_req = 0U;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols = 0U;
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unpack_weight_active_q) {
        tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols 
            = ((IData)(1U) - (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__weight_preload_col_q));
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__weight_col_load_req 
            = ((VL_LTES_III(32, 1U, tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols) 
                << 1U) | VL_LTES_III(32, 0U, tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unnamedblk1__DOT__loaded_cols));
    }
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[0U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__tx_valid_q;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__tx_valid_q;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__tx_valid_q;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[3U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__tx_valid_q;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[0U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__tx_packet_q;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__tx_packet_q;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__tx_packet_q;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[3U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__tx_packet_q;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT____Vcellinp__u_axi__accel_overflow 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard) 
           | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard) 
              | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard) 
                 | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard) 
                    | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard) 
                       | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard) 
                          | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard) 
                             | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard) 
                                | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard) 
                                   | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard) 
                                      | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard) 
                                         | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard) 
                                            | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard) 
                                               | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard) 
                                                  | ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard) 
                                                     | (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard))))))))))))))));
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__row_weight_data_req 
        = ((((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem
                     [(3U & ((IData)(2U) + (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__weight_preload_col_q)))]) 
             << 8U) | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem
            [vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__weight_preload_col_q]) 
           & (- (IData)((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unpack_weight_active_q))));
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__row_weight_data_req 
        = ((((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem
                     [(3U & ((IData)(2U) + (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__weight_preload_col_q)))]) 
             << 8U) | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem
            [vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__weight_preload_col_q]) 
           & (- (IData)((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unpack_weight_active_q))));
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__row_weight_data_req 
        = ((((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem
                     [(3U & ((IData)(2U) + (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__weight_preload_col_q)))]) 
             << 8U) | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem
            [vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__weight_preload_col_q]) 
           & (- (IData)((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unpack_weight_active_q))));
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__row_weight_data_req 
        = ((((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem
                     [(3U & ((IData)(2U) + (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__weight_preload_col_q)))]) 
             << 8U) | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem
            [vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__weight_preload_col_q]) 
           & (- (IData)((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unpack_weight_active_q))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out;
    __VdfgRegularize_h6e95ff9d_0_5 = ((1U > (3U & (IData)(
                                                          (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[3U][1U] 
                                                           >> 0x00000026U))))
                                       ? 2U : ((1U 
                                                < (3U 
                                                   & (IData)(
                                                             (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[3U][1U] 
                                                              >> 0x00000026U))))
                                                ? 1U
                                                : (
                                                   (1U 
                                                    > 
                                                    (3U 
                                                     & (IData)(
                                                               (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[3U][1U] 
                                                                >> 0x00000024U))))
                                                    ? 3U
                                                    : 
                                                   (4U 
                                                    & (- (IData)(
                                                                 (1U 
                                                                  < 
                                                                  (3U 
                                                                   & (IData)(
                                                                             (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[3U][1U] 
                                                                              >> 0x00000024U))))))))));
    __VdfgRegularize_h6e95ff9d_0_6 = ((1U > (3U & (IData)(
                                                          (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[3U][0U] 
                                                           >> 0x00000026U))))
                                       ? 2U : ((1U 
                                                < (3U 
                                                   & (IData)(
                                                             (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[3U][0U] 
                                                              >> 0x00000026U))))
                                                ? 1U
                                                : (
                                                   (1U 
                                                    > 
                                                    (3U 
                                                     & (IData)(
                                                               (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[3U][0U] 
                                                                >> 0x00000024U))))
                                                    ? 3U
                                                    : 
                                                   (4U 
                                                    & (- (IData)(
                                                                 (1U 
                                                                  < 
                                                                  (3U 
                                                                   & (IData)(
                                                                             (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[3U][0U] 
                                                                              >> 0x00000024U))))))))));
    __VdfgRegularize_h6e95ff9d_0_7 = ((0U < (3U & (IData)(
                                                          (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[2U][1U] 
                                                           >> 0x00000026U))))
                                       ? 1U : ((1U 
                                                > (3U 
                                                   & (IData)(
                                                             (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[2U][1U] 
                                                              >> 0x00000024U))))
                                                ? 3U
                                                : (4U 
                                                   & (- (IData)(
                                                                (1U 
                                                                 < 
                                                                 (3U 
                                                                  & (IData)(
                                                                            (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[2U][1U] 
                                                                             >> 0x00000024U)))))))));
    __VdfgRegularize_h6e95ff9d_0_8 = ((0U < (3U & (IData)(
                                                          (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[2U][0U] 
                                                           >> 0x00000026U))))
                                       ? 1U : ((1U 
                                                > (3U 
                                                   & (IData)(
                                                             (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[2U][0U] 
                                                              >> 0x00000024U))))
                                                ? 3U
                                                : (4U 
                                                   & (- (IData)(
                                                                (1U 
                                                                 < 
                                                                 (3U 
                                                                  & (IData)(
                                                                            (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[2U][0U] 
                                                                             >> 0x00000024U)))))))));
    __VdfgRegularize_h6e95ff9d_0_9 = ((1U > (3U & (IData)(
                                                          (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[1U][1U] 
                                                           >> 0x00000026U))))
                                       ? 2U : ((1U 
                                                < (3U 
                                                   & (IData)(
                                                             (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[1U][1U] 
                                                              >> 0x00000026U))))
                                                ? 1U
                                                : (4U 
                                                   & (- (IData)(
                                                                (0U 
                                                                 < 
                                                                 (3U 
                                                                  & (IData)(
                                                                            (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[1U][1U] 
                                                                             >> 0x00000024U)))))))));
    __VdfgRegularize_h6e95ff9d_0_10 = ((1U > (3U & (IData)(
                                                           (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[1U][0U] 
                                                            >> 0x00000026U))))
                                        ? 2U : ((1U 
                                                 < 
                                                 (3U 
                                                  & (IData)(
                                                            (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[1U][0U] 
                                                             >> 0x00000026U))))
                                                 ? 1U
                                                 : 
                                                (4U 
                                                 & (- (IData)(
                                                              (0U 
                                                               < 
                                                               (3U 
                                                                & (IData)(
                                                                          (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[1U][0U] 
                                                                           >> 0x00000024U)))))))));
    __VdfgRegularize_h6e95ff9d_0_11 = ((0U < (3U & (IData)(
                                                           (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[0U][1U] 
                                                            >> 0x00000026U))))
                                        ? 1U : (4U 
                                                & (- (IData)(
                                                             (0U 
                                                              < 
                                                              (3U 
                                                               & (IData)(
                                                                         (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[0U][1U] 
                                                                          >> 0x00000024U))))))));
    __VdfgRegularize_h6e95ff9d_0_12 = ((0U < (3U & (IData)(
                                                           (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[0U][0U] 
                                                            >> 0x00000026U))))
                                        ? 1U : (4U 
                                                & (- (IData)(
                                                             (0U 
                                                              < 
                                                              (3U 
                                                               & (IData)(
                                                                         (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[0U][0U] 
                                                                          >> 0x00000024U))))))));
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__activation_data_req 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unpack_compute_active_q)
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__activation_mem
           [vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__activation_lane_q]
            : 0U);
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__activation_data_req 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unpack_compute_active_q)
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__activation_mem
           [vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__activation_lane_q]
            : 0U);
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__activation_data_req 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unpack_compute_active_q)
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__activation_mem
           [vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__activation_lane_q]
            : 0U);
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__activation_data_req 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unpack_compute_active_q)
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__activation_mem
           [vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__activation_lane_q]
            : 0U);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[0U] 
        = (0x0000300000000000ULL | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in[0U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[1U] 
        = (0x0000300000000000ULL | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in[1U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[2U] 
        = (0x0000300000000000ULL | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in[2U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[3U] 
        = (0x0000300000000000ULL | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in[3U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[0U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[0U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[1U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[1U][0U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U][0U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[1U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[1U][1U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U][1U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[2U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[2U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[3U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[3U][0U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U][0U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[3U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[3U][1U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U][1U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[0U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[0U][0U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U][0U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[0U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[0U][1U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U][1U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[1U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[1U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[2U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[2U][0U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U][0U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[2U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[2U][1U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U][1U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[3U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[3U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[0U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[0U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[1U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[1U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[2U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[2U][0U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U][0U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[2U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[2U][1U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U][1U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[3U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[3U][0U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U][0U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[3U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[3U][1U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U][1U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[0U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[0U][0U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U][0U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[0U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[0U][1U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U][1U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[1U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[1U][0U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U][0U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[1U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[1U][1U] 
        = (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U][1U])));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[2U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[2U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[3U][0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[3U][1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[0U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[0U][1U]
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[0U][1U]
            : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[0U][0U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[1U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[1U][1U]
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[1U][1U]
            : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[1U][0U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[2U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[2U][1U]
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[2U][1U]
            : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[2U][0U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[3U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[3U][1U]
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[3U][1U]
            : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[3U][0U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid 
        = ((0x0eU & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid)) 
           | (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[0U][1U] 
              || vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[0U][0U]));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid 
        = ((0x0dU & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid)) 
           | ((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[1U][1U] 
               || vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[1U][0U]) 
              << 1U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid 
        = ((0x0bU & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid)) 
           | ((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[2U][1U] 
               || vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[2U][0U]) 
              << 2U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid 
        = ((7U & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid)) 
           | ((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[3U][1U] 
               || vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[3U][0U]) 
              << 3U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[2U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[3U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[0U] 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_valid) 
           || vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[0U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[1U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[2U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[3U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[3U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[0U] = 0ULL;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[1U] = 0ULL;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[2U] = 0ULL;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[3U] = 0ULL;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[0U] 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_valid)
            ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_packet
            : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[0U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[1U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[2U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[3U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[3U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][0U] 
        = (0x000000ffU & (IData)(tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__row_weight_data_req));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][0U] 
        = (0x000000ffU & ((IData)(tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__row_weight_data_req) 
                          >> 8U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][0U] 
        = (0x000000ffU & (IData)(tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__row_weight_data_req));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][0U] 
        = (0x000000ffU & ((IData)(tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__row_weight_data_req) 
                          >> 8U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][0U] 
        = (0x000000ffU & (IData)(tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__row_weight_data_req));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][0U] 
        = (0x000000ffU & ((IData)(tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__row_weight_data_req) 
                          >> 8U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[0U][0U] 
        = (0x000000ffU & (IData)(tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__row_weight_data_req));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[1U][0U] 
        = (0x000000ffU & ((IData)(tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__row_weight_data_req) 
                          >> 8U));
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U][1U]) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[3U][1U] 
            = __VdfgRegularize_h6e95ff9d_0_5;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[3U][1U] 
            = (0U == (IData)(__VdfgRegularize_h6e95ff9d_0_5));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[3U][1U] = 5U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[3U][1U] = 0U;
    }
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U][0U]) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[3U][0U] 
            = __VdfgRegularize_h6e95ff9d_0_6;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[3U][0U] 
            = (0U == (IData)(__VdfgRegularize_h6e95ff9d_0_6));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[3U][0U] = 5U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[3U][0U] = 0U;
    }
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U][1U]) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[2U][1U] 
            = __VdfgRegularize_h6e95ff9d_0_7;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[2U][1U] 
            = (0U == (IData)(__VdfgRegularize_h6e95ff9d_0_7));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[2U][1U] = 5U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[2U][1U] = 0U;
    }
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U][0U]) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[2U][0U] 
            = __VdfgRegularize_h6e95ff9d_0_8;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[2U][0U] 
            = (0U == (IData)(__VdfgRegularize_h6e95ff9d_0_8));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[2U][0U] = 5U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[2U][0U] = 0U;
    }
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U][1U]) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[1U][1U] 
            = __VdfgRegularize_h6e95ff9d_0_9;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[1U][1U] 
            = (0U == (IData)(__VdfgRegularize_h6e95ff9d_0_9));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[1U][1U] = 5U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[1U][1U] = 0U;
    }
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U][0U]) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[1U][0U] 
            = __VdfgRegularize_h6e95ff9d_0_10;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[1U][0U] 
            = (0U == (IData)(__VdfgRegularize_h6e95ff9d_0_10));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[1U][0U] = 5U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[1U][0U] = 0U;
    }
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U][1U]) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[0U][1U] 
            = __VdfgRegularize_h6e95ff9d_0_11;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[0U][1U] 
            = (0U == (IData)(__VdfgRegularize_h6e95ff9d_0_11));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[0U][1U] = 5U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[0U][1U] = 0U;
    }
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U][0U]) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[0U][0U] 
            = __VdfgRegularize_h6e95ff9d_0_12;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[0U][0U] 
            = (0U == (IData)(__VdfgRegularize_h6e95ff9d_0_12));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[0U][0U] = 5U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[0U][0U] = 0U;
    }
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][0U] 
        = tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__activation_data_req;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][0U] 
        = tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__activation_data_req;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][0U] 
        = tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__activation_data_req;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][0U] 
        = tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__activation_data_req;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][0U] 
        = tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__activation_data_req;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][0U] 
        = tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__activation_data_req;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][0U] 
        = tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__activation_data_req;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][0U] 
        = tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__activation_data_req;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[0U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[0U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[1U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[2U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[3U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[3U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[0U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[1U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[2U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[3U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[3U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[0U] 
        = (1U & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[1U] 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid) 
                 >> 1U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[2U] 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid) 
                 >> 2U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[3U] 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid) 
                 >> 3U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][1U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][0U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][1U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][0U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][1U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][0U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][1U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][0U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][1U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][0U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][1U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][0U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][1U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[1U][0U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][1U])))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc 
        = (0x00000001ffffffffULL & (VL_EXTENDS_QI(33,32, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc) 
                                    + VL_MULS_QQQ(33, 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg))), 
                                                  (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,8, vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[0U][0U])))));
    __Vfunc_noc_class_for_flit__10__flit = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[0U];
    __Vfunc_noc_class_for_type__11__payload_type = 
        (0x0000000fU & (IData)((__Vfunc_noc_class_for_flit__10__flit 
                                >> 0x00000020U)));
    __Vfunc_noc_class_for_type__11__Vfuncout = ((0x0eU 
                                                 == (IData)(__Vfunc_noc_class_for_type__11__payload_type)) 
                                                | (0x0fU 
                                                   == (IData)(__Vfunc_noc_class_for_type__11__payload_type)));
    __Vfunc_noc_class_for_flit__10__Vfuncout = __Vfunc_noc_class_for_type__11__Vfuncout;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit 
        = __Vfunc_noc_class_for_flit__10__Vfuncout;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready 
        = ((0x0eU & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready)) 
           | (1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U]
                              [tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit]))));
    __Vfunc_noc_class_for_flit__10__flit = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[1U];
    __Vfunc_noc_class_for_type__11__payload_type = 
        (0x0000000fU & (IData)((__Vfunc_noc_class_for_flit__10__flit 
                                >> 0x00000020U)));
    __Vfunc_noc_class_for_type__11__Vfuncout = ((0x0eU 
                                                 == (IData)(__Vfunc_noc_class_for_type__11__payload_type)) 
                                                | (0x0fU 
                                                   == (IData)(__Vfunc_noc_class_for_type__11__payload_type)));
    __Vfunc_noc_class_for_flit__10__Vfuncout = __Vfunc_noc_class_for_type__11__Vfuncout;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit 
        = __Vfunc_noc_class_for_flit__10__Vfuncout;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready 
        = ((0x0dU & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready)) 
           | (2U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U]
                               [tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit])) 
                    << 1U)));
    __Vfunc_noc_class_for_flit__10__flit = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[2U];
    __Vfunc_noc_class_for_type__11__payload_type = 
        (0x0000000fU & (IData)((__Vfunc_noc_class_for_flit__10__flit 
                                >> 0x00000020U)));
    __Vfunc_noc_class_for_type__11__Vfuncout = ((0x0eU 
                                                 == (IData)(__Vfunc_noc_class_for_type__11__payload_type)) 
                                                | (0x0fU 
                                                   == (IData)(__Vfunc_noc_class_for_type__11__payload_type)));
    __Vfunc_noc_class_for_flit__10__Vfuncout = __Vfunc_noc_class_for_type__11__Vfuncout;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit 
        = __Vfunc_noc_class_for_flit__10__Vfuncout;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready 
        = ((0x0bU & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready)) 
           | (4U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U]
                               [tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit])) 
                    << 2U)));
    __Vfunc_noc_class_for_flit__10__flit = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[3U];
    __Vfunc_noc_class_for_type__11__payload_type = 
        (0x0000000fU & (IData)((__Vfunc_noc_class_for_flit__10__flit 
                                >> 0x00000020U)));
    __Vfunc_noc_class_for_type__11__Vfuncout = ((0x0eU 
                                                 == (IData)(__Vfunc_noc_class_for_type__11__payload_type)) 
                                                | (0x0fU 
                                                   == (IData)(__Vfunc_noc_class_for_type__11__payload_type)));
    __Vfunc_noc_class_for_flit__10__Vfuncout = __Vfunc_noc_class_for_type__11__Vfuncout;
    tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit 
        = __Vfunc_noc_class_for_flit__10__Vfuncout;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready 
        = ((7U & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready)) 
           | (8U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U]
                               [tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT____VlemCall_0__noc_class_for_flit])) 
                    << 3U)));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_status_valid 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid) 
           & ((0x0eU != (0x0000000fU & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                                >> 0x00000020U)))) 
              & (0x0fU == (0x0000000fU & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                                  >> 0x00000020U))))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out[0U] 
        = (0x00000fffffffffffULL & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out[1U] 
        = (0x00000fffffffffffULL & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[1U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out[2U] 
        = (0x00000fffffffffffULL & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[2U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out[3U] 
        = (0x00000fffffffffffULL & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[3U]);
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[2U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[3U] = 0U;
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[0U]) {
        if ((0x0eU != (0x0000000fU & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                              >> 0x00000020U))))) {
            if ((0x0fU != (0x0000000fU & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                                  >> 0x00000020U))))) {
                vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[0U] = 1U;
            }
        }
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[1U] 
            = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[1U];
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[2U] 
            = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[2U];
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[3U] 
            = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[3U];
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[0U] = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[1U] = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[2U] = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[3U] = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[0U] 
            = ((0x0eU == (0x0000000fU & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                                 >> 0x00000020U)))) 
               || ((0x0fU == (0x0000000fU & (IData)(
                                                    (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                                     >> 0x00000020U))))
                    ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_status_ready)
                    : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_ready[0U]));
    } else {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[1U] 
            = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[1U];
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[2U] 
            = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[2U];
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[3U] 
            = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[3U];
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[0U] = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[1U] = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[2U] = 0U;
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[3U] = 0U;
    }
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_ready[1U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_ready[2U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[3U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_ready[3U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_ready 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_valid) 
           & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[0U])) 
              | (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready)));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[0U] 
        = (1U & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[1U] 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready) 
                 >> 1U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[2U] 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready) 
                 >> 2U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[3U] 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready) 
                 >> 3U));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[0U] = 0ULL;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[1U] = 0ULL;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[2U] = 0ULL;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[3U] = 0ULL;
    if (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[0U]) {
        if ((0x0eU != (0x0000000fU & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                              >> 0x00000020U))))) {
            if ((0x0fU != (0x0000000fU & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                                  >> 0x00000020U))))) {
                vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[0U] 
                    = (0x00000fffffffffffULL & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U]);
            }
        }
    }
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[1U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out[1U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[2U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out[2U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[3U] 
        = vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out[3U];
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__result_capture_fire 
        = ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid) 
           & ((0x0eU == (0x0000000fU & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[0U] 
                                                >> 0x00000020U)))) 
              & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[0U]));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready 
        = (((((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[3U]) 
              << 1U) | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[2U]) 
            << 2U) | (((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[1U]) 
                       << 1U) | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[0U]));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[0U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[1U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[2U] = 0U;
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[3U] = 0U;
    if ((1U & (~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_valid)))) {
        vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[0U] 
            = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[0U])) 
                     | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[0U]));
    }
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[1U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[1U])) 
                 | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[1U]));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[2U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[2U])) 
                 | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[2U]));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[3U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[3U])) 
                 | vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[3U]));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__inject_fire 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[3U] 
           & ((1U == (3U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[3U] 
                                    >> 0x00000026U)))) 
              & (1U == (3U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[3U] 
                                      >> 0x00000024U))))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__inject_fire 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[2U] 
           & ((0U == (3U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[2U] 
                                    >> 0x00000026U)))) 
              & (1U == (3U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[2U] 
                                      >> 0x00000024U))))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__inject_fire 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[1U] 
           & ((1U == (3U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[1U] 
                                    >> 0x00000026U)))) 
              & (0U == (3U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[1U] 
                                      >> 0x00000024U))))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__inject_fire 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[0U] 
           & ((0U == (3U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[0U] 
                                    >> 0x00000026U)))) 
              & (0U == (3U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[0U] 
                                      >> 0x00000024U))))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[0U][0U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[0U][0U])) 
                 | (((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[0U][1U])) 
                     & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[0U][0U]) 
                    & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[0U][1U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[0U][1U])) 
                 | (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[0U][1U] 
                    & (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[1U][0U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[1U][0U])) 
                 | (((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[1U][1U])) 
                     & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[1U][0U]) 
                    & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready) 
                       >> 1U))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[1U][1U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[1U][1U])) 
                 | (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[1U][1U] 
                    & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready) 
                       >> 1U))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[2U][0U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[2U][0U])) 
                 | (((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[2U][1U])) 
                     & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[2U][0U]) 
                    & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready) 
                       >> 2U))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[2U][1U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[2U][1U])) 
                 | (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[2U][1U] 
                    & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready) 
                       >> 2U))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[3U][0U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[3U][0U])) 
                 | (((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[3U][1U])) 
                     & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[3U][0U]) 
                    & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready) 
                       >> 3U))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[3U][1U] 
        = (1U & ((~ (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[3U][1U])) 
                 | (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[3U][1U] 
                    & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready) 
                       >> 3U))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__clear_req 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__inject_fire)
                  ? ((1U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[3U] 
                                    >> 0x00000023U)))
                      ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)
                      : ((1U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[3U] 
                                        >> 0x00000022U)))
                          ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)
                          : ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear) 
                             | ((~ (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[3U] 
                                            >> 0x00000020U))) 
                                & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[3U] 
                                           >> 0x00000021U))))))
                  : (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__clear_req 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__inject_fire)
                  ? ((1U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[2U] 
                                    >> 0x00000023U)))
                      ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)
                      : ((1U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[2U] 
                                        >> 0x00000022U)))
                          ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)
                          : ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear) 
                             | ((~ (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[2U] 
                                            >> 0x00000020U))) 
                                & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[2U] 
                                           >> 0x00000021U))))))
                  : (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__clear_req 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__inject_fire)
                  ? ((1U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[1U] 
                                    >> 0x00000023U)))
                      ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)
                      : ((1U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[1U] 
                                        >> 0x00000022U)))
                          ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)
                          : ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear) 
                             | ((~ (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[1U] 
                                            >> 0x00000020U))) 
                                & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[1U] 
                                           >> 0x00000021U))))))
                  : (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__clear_req 
        = (1U & ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__inject_fire)
                  ? ((1U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[0U] 
                                    >> 0x00000023U)))
                      ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)
                      : ((1U & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[0U] 
                                        >> 0x00000022U)))
                          ? (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)
                          : ((IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear) 
                             | ((~ (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[0U] 
                                            >> 0x00000020U))) 
                                & (IData)((vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[0U] 
                                           >> 0x00000021U))))))
                  : (IData)(vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear)));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[0U][0U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U][0U] 
           & ((4U & (IData)(__VdfgRegularize_h6e95ff9d_0_12))
               ? (IData)(((0U == (3U & (IData)(__VdfgRegularize_h6e95ff9d_0_12))) 
                          & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[0U][0U]))
               : ((2U & (IData)(__VdfgRegularize_h6e95ff9d_0_12))
                   ? ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_12))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[0U][0U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[0U][0U])
                   : ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_12))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[0U][0U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[0U][0U]))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[0U][1U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[0U][1U] 
           & ((4U & (IData)(__VdfgRegularize_h6e95ff9d_0_11))
               ? (IData)(((0U == (3U & (IData)(__VdfgRegularize_h6e95ff9d_0_11))) 
                          & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[0U][1U]))
               : ((2U & (IData)(__VdfgRegularize_h6e95ff9d_0_11))
                   ? ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_11))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[0U][1U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[0U][1U])
                   : ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_11))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[0U][1U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[0U][1U]))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[1U][0U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U][0U] 
           & ((4U & (IData)(__VdfgRegularize_h6e95ff9d_0_10))
               ? (IData)(((0U == (3U & (IData)(__VdfgRegularize_h6e95ff9d_0_10))) 
                          & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[1U][0U]))
               : ((2U & (IData)(__VdfgRegularize_h6e95ff9d_0_10))
                   ? ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_10))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[1U][0U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[1U][0U])
                   : ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_10))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[1U][0U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[1U][0U]))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[1U][1U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[1U][1U] 
           & ((4U & (IData)(__VdfgRegularize_h6e95ff9d_0_9))
               ? (IData)(((0U == (3U & (IData)(__VdfgRegularize_h6e95ff9d_0_9))) 
                          & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[1U][1U]))
               : ((2U & (IData)(__VdfgRegularize_h6e95ff9d_0_9))
                   ? ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_9))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[1U][1U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[1U][1U])
                   : ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_9))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[1U][1U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[1U][1U]))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[2U][0U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U][0U] 
           & ((4U & (IData)(__VdfgRegularize_h6e95ff9d_0_8))
               ? (IData)(((0U == (3U & (IData)(__VdfgRegularize_h6e95ff9d_0_8))) 
                          & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[2U][0U]))
               : ((2U & (IData)(__VdfgRegularize_h6e95ff9d_0_8))
                   ? ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_8))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[2U][0U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[2U][0U])
                   : ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_8))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[2U][0U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[2U][0U]))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[2U][1U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[2U][1U] 
           & ((4U & (IData)(__VdfgRegularize_h6e95ff9d_0_7))
               ? (IData)(((0U == (3U & (IData)(__VdfgRegularize_h6e95ff9d_0_7))) 
                          & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[2U][1U]))
               : ((2U & (IData)(__VdfgRegularize_h6e95ff9d_0_7))
                   ? ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_7))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[2U][1U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[2U][1U])
                   : ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_7))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[2U][1U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[2U][1U]))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[3U][0U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U][0U] 
           & ((4U & (IData)(__VdfgRegularize_h6e95ff9d_0_6))
               ? (IData)(((0U == (3U & (IData)(__VdfgRegularize_h6e95ff9d_0_6))) 
                          & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[3U][0U]))
               : ((2U & (IData)(__VdfgRegularize_h6e95ff9d_0_6))
                   ? ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_6))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[3U][0U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[3U][0U])
                   : ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_6))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[3U][0U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[3U][0U]))));
    vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[3U][1U] 
        = (vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[3U][1U] 
           & ((4U & (IData)(__VdfgRegularize_h6e95ff9d_0_5))
               ? (IData)(((0U == (3U & (IData)(__VdfgRegularize_h6e95ff9d_0_5))) 
                          & vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[3U][1U]))
               : ((2U & (IData)(__VdfgRegularize_h6e95ff9d_0_5))
                   ? ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_5))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[3U][1U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[3U][1U])
                   : ((1U & (IData)(__VdfgRegularize_h6e95ff9d_0_5))
                       ? vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[3U][1U]
                       : vlSelfRef.tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[3U][1U]))));
}

VL_ATTR_COLD bool Vtb_pynq_axi_single_tile___024root___eval_phase__stl(Vtb_pynq_axi_single_tile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___eval_phase__stl\n"); );
    Vtb_pynq_axi_single_tile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__stl
        vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                          & vlSelfRef.__VstlTriggered[0U]) 
                                         | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_pynq_axi_single_tile___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vtb_pynq_axi_single_tile___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        {
            // Inlined CFunc: _eval_stl
            if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
                Vtb_pynq_axi_single_tile___024root___stl_sequent__TOP__0(vlSelf);
            }
        }
    }
    return (__VstlExecute);
}

bool Vtb_pynq_axi_single_tile___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_pynq_axi_single_tile___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vtb_pynq_axi_single_tile___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge tb_pynq_axi_single_tile.test_case.clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @(negedge tb_pynq_axi_single_tile.test_case.rst_n)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 2U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 2 is active: @( tb_pynq_axi_single_tile.passed)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 3U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 3 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
    if ((1U & (IData)((triggers[0U] >> 4U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 4 is active: @(negedge tb_pynq_axi_single_tile.test_case.clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_pynq_axi_single_tile___024root___ctor_var_reset(Vtb_pynq_axi_single_tile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_pynq_axi_single_tile___024root___ctor_var_reset\n"); );
    Vtb_pynq_axi_single_tile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->tb_pynq_axi_single_tile__DOT__passed = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5489824238647208064ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__awaddr = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 15201509098748914766ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__araddr = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 7995756007845750553ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__awvalid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16214342509167623769ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__awready = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9410046993794614712ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__wvalid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 849508778470257566ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__wready = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5892723944018002608ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__bvalid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6784621166376693064ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__bready = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3608059051000778900ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__wdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 15471482493521173348ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__rdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 12189853349445509485ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__wstrb = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 16640307612369332827ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__bresp = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 8129161984740228849ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__rresp = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 10678636920765468885ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__arvalid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2940794275113426001ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__rvalid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4895799745848010733ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__rready = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17920136098875360750ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_start = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 208332534257572477ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_clear = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10969149282306796155ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__accel_tile_count = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14995224488475969389ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__weight_wr_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16691819298226485068ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__act_wr_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1477066570993299184ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__result_rd_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5480683403680551685ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__weight_wr_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 18215065362486909441ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__act_wr_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 908527139609519352ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__packet_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17260720589794667573ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__weight_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7868546274465235309ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__act_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 13145959287714102620ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__weight_wr_ptr_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 2849103264245383566ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__act_wr_ptr_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 12062890685452313010ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__weight_count_q = VL_SCOPED_RAND_RESET_I(3, __VscopeHash, 177420550275310650ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__act_count_q = VL_SCOPED_RAND_RESET_I(3, __VscopeHash, 192935285262888663ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__inputs_ready_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17434835117912450685ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__busy_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2981501924711573302ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__protocol_error_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14257975305326887701ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__weight_rd_addr = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 16223304546572957798ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__act_rd_addr = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 11009753597123277894ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__output_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17440265581934573332ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__run_done = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10567005244797340084ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__result_count = VL_SCOPED_RAND_RESET_I(3, __VscopeHash, 3239373643708183803ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__tile_count_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5842424157045041150ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT____Vcellinp__u_axi__accel_overflow = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11652372975503664721ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_packet = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 13917134159109182164ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_cmd_ready = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13396552480775295723ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_status_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13604382704280516363ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__sched_status_ready = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13061456263114816698ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_valid[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16401706045115252615ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_packet[__Vi0] = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 16895153009629708706ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_inject_ready[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13117591640218963601ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_valid[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9441138099852470158ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_packet[__Vi0] = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 1129393093639966772ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__tile_deliver_ready[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13801714451310835690ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_valid[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14452314435876586988ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in[__Vi0] = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 17468476278092804063ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_in_ready[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3521564088640927420ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_valid[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17330161784321408111ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_src_packet[__Vi0] = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 3432687494208619360ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_valid[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14877373714775404259ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out[__Vi0] = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 1057801502636105049ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__ep_packet_out_ready[__Vi0] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15532952067305221612ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_valid = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 5261306426951914561ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_flit[__Vi0] = VL_SCOPED_RAND_RESET_Q(46, __VscopeHash, 6845156125316052630ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_in_ready = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 2951239747847882664ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_valid = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 17040589720118261781ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_flit[__Vi0] = VL_SCOPED_RAND_RESET_Q(46, __VscopeHash, 12255801861277393779ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__noc_local_out_ready = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 7448787427675629480ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__result_capture_fire = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17569261168674889357ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__result_wr_addr_q = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 6849800274158311635ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellout__u_noc_grid__local_out_flit[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT____Vcellinp__u_noc_grid__local_in_flit[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_q[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1489949295553120027ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_valid_d[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15874718606016617849ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_q[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_Q(46, __VscopeHash, 8498351874873293634ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_flit_d[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_Q(46, __VscopeHash, 3082812640007513363ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_q[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3441932974654715677ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_valid_d[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11443415797063952296ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_q[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_Q(46, __VscopeHash, 12772479291474345646ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__local_out_flit_d[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_Q(46, __VscopeHash, 8628703229676572436ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_route[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(3, __VscopeHash, 7546510666926661490ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_hit[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 232243911796453677ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_in_ready[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1425259259940669458ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_local_ready[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15731908906637703231ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_east_ready[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7714552167274852034ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_west_ready[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13424805810253352992ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_north_ready[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7864573365110406561ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 2; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_noc_grid__DOT__tile_south_ready[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 821161540425470166ull);
        }
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__clear_req = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8381913311460069365ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__inject_fire = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1529311832472135993ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__last_src_valid_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10420905254137710834ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__last_src_x_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 2303896619412352167ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__last_src_y_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 510992220253554406ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__done_seen_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1287043898780616696ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__tx_valid_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17092248967036493648ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__tx_packet_q = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 8004766783059184249ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__tx_done_pending_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1676606783746543089ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unpack_weight_active_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10093558327163959210ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__unpack_compute_active_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12815990056266718107ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__activation_lane_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 10542566901712742909ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__weight_preload_col_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16679258546040492790ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__weight_col_load_req = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 17047167351967864904ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__done_i = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16437104420958201508ull);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 3; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 306422954390326034ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 3; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 7005483611363642916ull);
        }
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 14267999576107856120ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 2827731097297103014ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 3275120343347559752ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 16095962915530980808ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 5460070629020575397ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 323855352421060736ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 769694082807955936ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 11641360156036177694ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 9298403936675655267ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 1615029584547188973ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 960286703349331792ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 11880505471459850565ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 2333691758053665954ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__3__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__activation_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 11579852727892185977ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__clear_req = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12244525124064801828ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__inject_fire = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 810879669156920514ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__last_src_valid_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11323933470680661199ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__last_src_x_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 11805455448870115395ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__last_src_y_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 3430420741905724778ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__done_seen_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12169106933438378380ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__tx_valid_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3444261677182413802ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__tx_packet_q = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 17173864316167893135ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__tx_done_pending_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8417500439393297593ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unpack_weight_active_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9134914012064651378ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__unpack_compute_active_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7186992126122741231ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__activation_lane_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 4163845562128433762ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__weight_preload_col_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12016726660274375108ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__weight_col_load_req = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 1780848168537565473ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__done_i = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2468614750341655809ull);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 3; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 9971439734748263086ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 3; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 17962345249136737702ull);
        }
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 17509049485686254437ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14564339744575551587ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 5689547398604734102ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 13156790911755872780ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 9552775832056905029ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 195829546465727615ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 6443114805588155312ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 40952453244159270ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 6806635509702038037ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 17943760253874831928ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7869793390057902621ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 16338339334546458499ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 2522501862048301456ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__2__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__activation_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 13890822527871634704ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__clear_req = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12940049301267153886ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__inject_fire = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11783171187425679806ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__last_src_valid_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3210110964717944616ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__last_src_x_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 9602775072781943716ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__last_src_y_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 9932327833686320812ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__done_seen_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2451626847223165494ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__tx_valid_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6895547303489809883ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__tx_packet_q = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 8294072541563655781ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__tx_done_pending_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2844385931360044909ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unpack_weight_active_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10657962377743984517ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__unpack_compute_active_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5615843231982484296ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__activation_lane_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 9804812142438899867ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__weight_preload_col_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14030744890140945012ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__weight_col_load_req = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 17550689508447230177ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__done_i = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7815868645417069368ull);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 3; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 8210486868035861872ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 3; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 4746628406976100115ull);
        }
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 10798432453691834929ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17548962895829958850ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 17658784034693213064ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 16691214276491309014ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4887231297376308246ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 5823323437856223842ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 14188500633764197227ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17343613027443063385ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 16427953958514002262ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 16934812268053341794ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 12211321552130691134ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 6643366862095327176ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 4645377203811673633ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__1__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__activation_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 5031075219873504416ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__clear_req = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 802086723834584371ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__inject_fire = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7044536887592178660ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__last_src_valid_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7744830197132067992ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__last_src_x_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 4075324591776289734ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__last_src_y_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 9153957882513604885ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__done_seen_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10094026085855478933ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__tx_valid_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2771974151087771791ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__tx_packet_q = VL_SCOPED_RAND_RESET_Q(44, __VscopeHash, 8755848025978508580ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__tx_done_pending_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11115733915897676135ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unpack_weight_active_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17894782389186715888ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__unpack_compute_active_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 623020823544692840ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__activation_lane_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 6913576364901260086ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__weight_preload_col_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15598106994002613114ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__weight_col_load_req = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 14129284756504446900ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__done_i = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14202567401756595851ull);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 3; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__weight_link[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 15090145006677661876ull);
        }
    }
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        for (int __Vi1 = 0; __Vi1 < 3; ++__Vi1) {
            vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__act_link[__Vi0][__Vi1] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 11721358750919561165ull);
        }
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__activation_out = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT____Vcellout__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__overflow_hazard = 0;
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 3665064984844659264ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 8303065846251772984ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 12839749397351653497ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 10269682607276371818ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3964006903563681524ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__1__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 10562935608131077730ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 13861218644025160866ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17423176720790169023ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__1__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 2757864343733059601ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__weight_reg = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 12411871774432995548ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__acc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 11670469349591596586ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_systolic_array__DOT__gen_row__BRA__0__KET____DOT__gen_col__BRA__0__KET____DOT__u_pe__DOT__u_mac__DOT__next_acc = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 15581569106267341081ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__weight_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 11064304145081776656ull);
    }
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__gen_tiles__BRA__0__KET____DOT__u_tile__DOT__u_tile_scratchpad__DOT__activation_mem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 14864582203322047267ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_scheduler__DOT__state = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 13057985097214403313ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_scheduler__DOT__tile_cnt = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 835198719534055575ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_scheduler__DOT__amount_of_tiles = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 5848603723853815752ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_chip__DOT__u_scheduler__DOT__result_count_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 12796236213009961309ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_readback__DOT__mem[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 1416584014174386592ull);
    }
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_readback__DOT__rd_ptr_q = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 17776945053927464334ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__aw_pending_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13041053633739904777ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__awaddr_q = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 1019395910341064706ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__w_pending_q = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2825193250582978718ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__wdata_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14174844538262139973ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__wstrb_q = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 10499697321014646370ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__write_fire = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8336038540533568286ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__read_fire = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3111590080012231899ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__write_addr_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6661084684693271954ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__read_addr_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16737754297770205145ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__ctrl_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 10149513598771411916ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__led_mirror_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 15452483271150494346ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__tile_select_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 8345966643694260725ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__packet_type_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4055809602267915953ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__packet_payload_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 1895524821623745081ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__dma_src_addr_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 8402703375455165009ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__dma_dst_addr_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 11846290833859159426ull);
    vlSelf->tb_pynq_axi_single_tile__DOT__test_case__DOT__dut__DOT__u_axi__DOT__dma_length_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 15282054646620382614ull);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggeredAcc[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__tb_pynq_axi_single_tile__DOT__test_case__DOT__clk__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb_pynq_axi_single_tile__DOT__test_case__DOT__rst_n__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb_pynq_axi_single_tile__DOT__passed__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    vlSelf->__Vi = 0;
}
