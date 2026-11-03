// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCIfE_H__
#define __LcwtMLP_RFFI_PATCIfE_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCIfE_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCIfE_ram) {
        ram[0] = "0b000000000101100";
        ram[1] = "0b000000101100101";
        ram[2] = "0b010001110100100";
        ram[3] = "0b000001101011101";
        ram[4] = "0b000010100100010";
        ram[5] = "0b000000101001110";
        ram[6] = "0b001010010001001";
        ram[7] = "0b001000111100000";
        ram[8] = "0b100100111011110";
        ram[9] = "0b110110001001111";
        ram[10] = "0b001110101110111";
        ram[11] = "0b111100000111000";
        ram[12] = "0b110000101010100";
        ram[13] = "0b111010010000110";
        ram[14] = "0b000001011000011";
        ram[15] = "0b000001101001010";
        ram[16] = "0b111001101010101";
        ram[17] = "0b111111111101100";
        ram[18] = "0b000100001111000";
        ram[19] = "0b001111101101111";
        ram[20] = "0b111010001111011";
        ram[21] = "0b101011100010110";
        ram[22] = "0b001010110010110";
        ram[23] = "0b110100100000001";
        ram[24] = "0b111000111101111";
        ram[25] = "0b001111011100100";
        ram[26] = "0b000100010000110";
        ram[27] = "0b111111101110001";
        ram[28] = "0b000001110101000";
        ram[29] = "0b000001110110001";
        ram[30] = "0b110111011000011";
        ram[31] = "0b110111010101000";


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


SC_MODULE(LcwtMLP_RFFI_PATCIfE) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCIfE_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCIfE) {
meminst = new LcwtMLP_RFFI_PATCIfE_ram("LcwtMLP_RFFI_PATCIfE_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCIfE() {
    delete meminst;
}


};//endmodule
#endif
