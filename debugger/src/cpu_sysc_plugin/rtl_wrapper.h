/**
 * @file
 * @copyright  Copyright 2016 GNSS Sensor Ltd. All right reserved.
 * @author     Sergey Khabarov - sergeykhbr@gmail.com
 * @brief      SystemC CPU wrapper. To interact with the SoC simulator. */

#ifndef __DEBUGGER_RTL_WRAPPER_H__
#define __DEBUGGER_RTL_WRAPPER_H__

#include "async_tqueue.h"
#include "coreservices/imemop.h"
#include "coreservices/icpugen.h"
#include "coreservices/icpuriscv.h"
#include "coreservices/iclklistener.h"
#include "riverlib/river_cfg.h"
#include <systemc.h>
#include "api_utils.h"

namespace debugger {

class RtlWrapper : public sc_module,
                   public ICpuGeneric,
                   public ICpuRiscV {
public:
    sc_clock o_clk;
    sc_out<bool> o_nrst;
    // Timer:
    sc_in<sc_uint<RISCV_ARCH>> i_time;
    // Memory interface:
    sc_out<bool> o_req_mem_ready;
    sc_in<bool> i_req_mem_valid;
    sc_in<bool> i_req_mem_write;
    sc_in<sc_uint<BUS_ADDR_WIDTH>> i_req_mem_addr;
    sc_in<sc_uint<BUS_DATA_BYTES>> i_req_mem_strob;
    sc_in<sc_uint<BUS_DATA_WIDTH>> i_req_mem_data;
    sc_out<bool> o_resp_mem_data_valid;
    sc_out<sc_uint<BUS_DATA_WIDTH>> o_resp_mem_data;
    /** Interrupt line from external interrupts controller. */
    sc_out<bool> o_interrupt;
    // Debug interface
    sc_out<bool> o_dport_valid;                          // Debug access from DSU is valid
    sc_out<bool> o_dport_write;                          // Write value
    sc_out<sc_uint<2>> o_dport_region;                   // Registers region ID: 0=CSR; 1=IREGS; 2=Control
    sc_out<sc_uint<12>> o_dport_addr;                    // Register index
    sc_out<sc_uint<RISCV_ARCH>> o_dport_wdata;           // Write value
    sc_in<bool> i_dport_ready;                           // Response is ready
    sc_in<sc_uint<RISCV_ARCH>> i_dport_rdata;            // Response value


    struct RegistersType {
        sc_signal<sc_uint<BUS_DATA_WIDTH>> resp_mem_data;
        sc_signal<bool> resp_mem_data_valid;
        sc_signal<sc_uint<3>> wait_state_cnt;
        sc_signal<sc_bv<5>> nrst;
        sc_signal<bool> interrupt;
        // Debug port latches:
        sc_signal<bool> dport_valid;
        sc_signal<bool> dport_write;
        sc_signal<sc_uint<2>> dport_region;
        sc_signal<sc_uint<12>> dport_addr;
        sc_signal<sc_uint<RISCV_ARCH>> dport_wdata;
    } r, v;
    bool w_nrst;
    bool w_interrupt;

    void clk_gen();
    void comb();
    void registers();
    void clk_negedge_proc();

    SC_HAS_PROCESS(RtlWrapper);

    RtlWrapper(IFace *parent, sc_module_name name);
    virtual ~RtlWrapper();

public:
    void generateRef(bool v) { generate_ref_ = v; }
    void generateVCD(sc_trace_file *i_vcd, sc_trace_file *o_vcd);
    void setBus(IMemoryOperation *v) { ibus_ = v; }
    /** Default time resolution 1 picosecond. */
    void setClockHz(double hz);
   
    /** ICpuGeneric interface */
    virtual void registerStepCallback(IClockListener *cb, uint64_t t);
    virtual void raiseSignal(int idx);
    virtual void lowerSignal(int idx);
    virtual void nb_transport_debug_port(DebugPortTransactionType *trans,
                                        IDbgNbResponse *cb);

private:
    IFace *getInterface(const char *name) { return iparent_; }
    uint64_t mask2offset(uint8_t mask);
    uint32_t mask2size(uint8_t mask);       // nask with removed offset

private:
    IMemoryOperation *ibus_;
    IFace *iparent_;    // pointer on parent module object (used for logging)
    int clockCycles_;   // default in [ps]
    ClockAsyncTQueueType step_queue_;
    uint64_t step_cnt_z;
    bool generate_ref_;

    sc_uint<32> t_trans_idx_up;
    sc_uint<32> t_trans_idx_down;

    struct DebugPortType {
        event_def valid;
        DebugPortTransactionType *trans;
        IDbgNbResponse *cb;
        unsigned trans_idx_up;
        unsigned trans_idx_down;
        unsigned idx_missmatch;
    } dport_;
};

}  // namespace debugger

#endif  // __DEBUGGER_RTL_WRAPPER_H__
