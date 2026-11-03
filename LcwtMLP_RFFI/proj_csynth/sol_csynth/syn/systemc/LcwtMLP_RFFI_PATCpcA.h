// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCpcA_H__
#define __LcwtMLP_RFFI_PATCpcA_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCpcA_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCpcA_ram) {
        ram[0] = "0b010110011100000";
        ram[1] = "0b001011001101010";
        ram[2] = "0b001101111000000";
        ram[3] = "0b111010111011010";
        ram[4] = "0b010011111100001";
        ram[5] = "0b001011000111101";
        ram[6] = "0b000110001101001";
        ram[7] = "0b001101111001111";
        ram[8] = "0b001011010110101";
        ram[9] = "0b000111010000000";
        ram[10] = "0b000000011011111";
        ram[11] = "0b000010100011010";
        ram[12] = "0b111111001000001";
        ram[13] = "0b110010100001110";
        ram[14] = "0b110111110100011";
        ram[15] = "0b001111111111000";
        ram[16] = "0b001101000111111";
        ram[17] = "0b001001110110111";
        ram[18] = "0b000000010111111";
        ram[19] = "0b001100100001111";
        ram[20] = "0b000011010101101";
        ram[21] = "0b110000011101010";
        ram[22] = "0b001001001001000";
        ram[23] = "0b001011101001001";
        ram[24] = "0b111101000000111";
        ram[25] = "0b000001100010111";
        ram[26] = "0b010111011100001";
        ram[27] = "0b011010100100010";
        ram[28] = "0b000111001011101";
        ram[29] = "0b000001001011101";
        ram[30] = "0b000101100011001";
        ram[31] = "0b111100001000101";


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


SC_MODULE(LcwtMLP_RFFI_PATCpcA) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCpcA_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCpcA) {
meminst = new LcwtMLP_RFFI_PATCpcA_ram("LcwtMLP_RFFI_PATCpcA_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCpcA() {
    delete meminst;
}


};//endmodule
#endif
