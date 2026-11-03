// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCmb6_H__
#define __LcwtMLP_RFFI_PATCmb6_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCmb6_ram : public sc_core::sc_module {

  static const unsigned DataWidth = 14;
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


   SC_CTOR(LcwtMLP_RFFI_PATCmb6_ram) {
        ram[0] = "0b11011101010111";
        ram[1] = "0b00000110100101";
        ram[2] = "0b00000011011010";
        ram[3] = "0b11001001011100";
        ram[4] = "0b00000000111010";
        ram[5] = "0b11010100011111";
        ram[6] = "0b00101010110101";
        ram[7] = "0b11110101100110";
        ram[8] = "0b11110110001001";
        ram[9] = "0b00010000011000";
        ram[10] = "0b11111101000110";
        ram[11] = "0b00000100101110";
        ram[12] = "0b00010100110011";
        ram[13] = "0b11000111001000";
        ram[14] = "0b11110010110001";
        ram[15] = "0b11111101010100";
        ram[16] = "0b11010011011011";
        ram[17] = "0b11111100000010";
        ram[18] = "0b11100110100101";
        ram[19] = "0b01000011111000";
        ram[20] = "0b00011011001101";
        ram[21] = "0b10011010101011";
        ram[22] = "0b00011101110111";
        ram[23] = "0b11101001010100";
        ram[24] = "0b10111110000011";
        ram[25] = "0b01101001001001";
        ram[26] = "0b10111100110100";
        ram[27] = "0b11101001110010";
        ram[28] = "0b00011101100011";
        ram[29] = "0b00010000001011";
        ram[30] = "0b10110010000110";
        ram[31] = "0b11010111101101";


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


SC_MODULE(LcwtMLP_RFFI_PATCmb6) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCmb6_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCmb6) {
meminst = new LcwtMLP_RFFI_PATCmb6_ram("LcwtMLP_RFFI_PATCmb6_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCmb6() {
    delete meminst;
}


};//endmodule
#endif
