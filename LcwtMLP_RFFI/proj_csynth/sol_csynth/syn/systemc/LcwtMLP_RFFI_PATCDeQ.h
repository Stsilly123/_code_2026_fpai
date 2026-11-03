// ==============================================================
// File generated on Thu Oct 22 20:22:33 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCDeQ_H__
#define __LcwtMLP_RFFI_PATCDeQ_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCDeQ_ram : public sc_core::sc_module {

  static const unsigned DataWidth = 15;
  static const unsigned AddressRange = 32;
  static const unsigned AddressWidth = 5;

//latency = 1
//input_reg = 1
//output_reg = 0
sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in <sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


sc_lv<DataWidth> ram[AddressRange];


   SC_CTOR(LcwtMLP_RFFI_PATCDeQ_ram) {
        ram[0] = "0b000010000000001";
        ram[1] = "0b111000010101010";
        ram[2] = "0b001011010000111";
        ram[3] = "0b000001110000111";
        ram[4] = "0b111001100100011";
        ram[5] = "0b001100111111010";
        ram[6] = "0b000001000011111";
        ram[7] = "0b000100101001010";
        ram[8] = "0b000100011010111";
        ram[9] = "0b000110010001011";
        ram[10] = "0b110101111101011";
        ram[11] = "0b101111111101011";
        ram[12] = "0b111100011001001";
        ram[13] = "0b001100001100111";
        ram[14] = "0b111010111111111";
        ram[15] = "0b001010101010000";
        ram[16] = "0b000110111000111";
        ram[17] = "0b000011110000000";
        ram[18] = "0b110110100010110";
        ram[19] = "0b000000000100111";
        ram[20] = "0b000101101110111";
        ram[21] = "0b000111101100101";
        ram[22] = "0b111110011000000";
        ram[23] = "0b111011110110111";
        ram[24] = "0b001000110110111";
        ram[25] = "0b111101101011001";
        ram[26] = "0b111010101100100";
        ram[27] = "0b001001001110101";
        ram[28] = "0b000011101000110";
        ram[29] = "0b001000010101000";
        ram[30] = "0b110111001000010";
        ram[31] = "0b000101001111011";


SC_METHOD(prc_write_0);
  sensitive<<clk.pos();
   }


void prc_write_0()
{
    if (ce0.read() == sc_dt::Log_1) 
    {
            if(address0.read().is_01() && address0.read().to_uint()<AddressRange)
              q0 = ram[address0.read().to_uint()];
            else
              q0 = sc_lv<DataWidth>();
    }
}


}; //endmodule


SC_MODULE(LcwtMLP_RFFI_PATCDeQ) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCDeQ_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCDeQ) {
meminst = new LcwtMLP_RFFI_PATCDeQ_ram("LcwtMLP_RFFI_PATCDeQ_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCDeQ() {
    delete meminst;
}


};//endmodule
#endif
