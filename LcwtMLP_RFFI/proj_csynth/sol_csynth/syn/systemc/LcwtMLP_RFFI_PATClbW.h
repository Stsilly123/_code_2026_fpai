// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATClbW_H__
#define __LcwtMLP_RFFI_PATClbW_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATClbW_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATClbW_ram) {
        ram[0] = "0b11101111111111";
        ram[1] = "0b00000111101110";
        ram[2] = "0b10101100000001";
        ram[3] = "0b11110111100011";
        ram[4] = "0b11100010101110";
        ram[5] = "0b00001011001010";
        ram[6] = "0b11011100000111";
        ram[7] = "0b00010111111001";
        ram[8] = "0b00000001111011";
        ram[9] = "0b00011010011010";
        ram[10] = "0b11110000001010";
        ram[11] = "0b11100010111100";
        ram[12] = "0b11110101000001";
        ram[13] = "0b00000011011000";
        ram[14] = "0b00100100111111";
        ram[15] = "0b00111111000011";
        ram[16] = "0b00111001111000";
        ram[17] = "0b11101001001101";
        ram[18] = "0b00000101000001";
        ram[19] = "0b00100110000110";
        ram[20] = "0b01000001111110";
        ram[21] = "0b00000011111010";
        ram[22] = "0b11111010100111";
        ram[23] = "0b11111101110001";
        ram[24] = "0b11111101101110";
        ram[25] = "0b00010100101010";
        ram[26] = "0b00000010000000";
        ram[27] = "0b00101010000011";
        ram[28] = "0b10101101010011";
        ram[29] = "0b11101111000100";
        ram[30] = "0b00001110010110";
        ram[31] = "0b00001110000001";


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


SC_MODULE(LcwtMLP_RFFI_PATClbW) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATClbW_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATClbW) {
meminst = new LcwtMLP_RFFI_PATClbW_ram("LcwtMLP_RFFI_PATClbW_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATClbW() {
    delete meminst;
}


};//endmodule
#endif
