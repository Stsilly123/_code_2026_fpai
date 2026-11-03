// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCqcK_H__
#define __LcwtMLP_RFFI_PATCqcK_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCqcK_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCqcK_ram) {
        ram[0] = "0b00000011010001";
        ram[1] = "0b11101101110110";
        ram[2] = "0b00000001001100";
        ram[3] = "0b11100001010111";
        ram[4] = "0b01011001111010";
        ram[5] = "0b00101100011010";
        ram[6] = "0b11111001110111";
        ram[7] = "0b00001001010101";
        ram[8] = "0b11110001100110";
        ram[9] = "0b10100010001110";
        ram[10] = "0b11011111011010";
        ram[11] = "0b00100010010101";
        ram[12] = "0b00100000110000";
        ram[13] = "0b00001010001011";
        ram[14] = "0b00000101100111";
        ram[15] = "0b01001000100011";
        ram[16] = "0b11101110110101";
        ram[17] = "0b11011011100011";
        ram[18] = "0b11111110010011";
        ram[19] = "0b11000101010110";
        ram[20] = "0b00010001001000";
        ram[21] = "0b11101111100000";
        ram[22] = "0b11101111000011";
        ram[23] = "0b00001000010101";
        ram[24] = "0b00010011010101";
        ram[25] = "0b10111111111111";
        ram[26] = "0b11000111110110";
        ram[27] = "0b10111010111110";
        ram[28] = "0b11100111101010";
        ram[29] = "0b00010101100000";
        ram[30] = "0b00101011100111";
        ram[31] = "0b11000100111110";


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


SC_MODULE(LcwtMLP_RFFI_PATCqcK) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCqcK_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCqcK) {
meminst = new LcwtMLP_RFFI_PATCqcK_ram("LcwtMLP_RFFI_PATCqcK_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCqcK() {
    delete meminst;
}


};//endmodule
#endif
