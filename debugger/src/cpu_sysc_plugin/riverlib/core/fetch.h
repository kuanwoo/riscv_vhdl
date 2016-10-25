/**
 * @file
 * @copyright  Copyright 2016 GNSS Sensor Ltd. All right reserved.
 * @author     Sergey Khabarov - sergeykhbr@gmail.com
 * @brief      CPU Fetch Instruction stage.
 */

#ifndef __DEBUGGER_RIVERLIB_FETCH_H__
#define __DEBUGGER_RIVERLIB_FETCH_H__

#include <systemc.h>
#include "../river_cfg.h"

namespace debugger {

SC_MODULE(InstrFetch) {
    sc_in<bool> i_clk;
    sc_in<bool> i_nrst;
    sc_out<bool> o_mem_addr_valid;
    sc_in<bool> i_mem_addr_ready;
    sc_out<sc_uint<AXI_ADDR_WIDTH>> o_mem_addr;
    sc_in<bool> i_mem_data_valid;
    sc_in<sc_uint<AXI_ADDR_WIDTH>> i_mem_data_addr;
    sc_in<sc_uint<32>> i_mem_data;
    sc_in<bool> i_jump_valid;
    sc_in<sc_uint<AXI_ADDR_WIDTH>> i_jump_pc;

    sc_out<bool> o_f_valid;
    sc_out<sc_uint<AXI_ADDR_WIDTH>> o_f_pc;
    sc_out<sc_uint<32>> o_f_instr;


    void comb();
    void registers();

    SC_HAS_PROCESS(InstrFetch);

    InstrFetch(sc_module_name name_, sc_trace_file *vcd=0);

private:
    struct RegistersType {
        sc_signal<bool> mem_addr_valid;
        sc_signal<bool> mem_addr_valid_z;
        sc_signal<bool> f_valid;
        sc_signal<sc_uint<AXI_ADDR_WIDTH>> pc;
        sc_signal<sc_uint<AXI_ADDR_WIDTH>> addr_req;
        sc_signal<sc_uint<32>> instr;

        sc_signal<bool> post_jump_valid;
        sc_signal<sc_uint<AXI_ADDR_WIDTH>> post_jump_pc;
    } v, r;
};


}  // namespace debugger

#endif  // __DEBUGGER_RIVERLIB_FETCH_H__
