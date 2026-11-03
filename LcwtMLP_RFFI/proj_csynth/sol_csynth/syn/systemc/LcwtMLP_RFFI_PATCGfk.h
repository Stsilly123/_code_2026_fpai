// ==============================================================
// File generated on Thu Oct 22 20:22:33 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCGfk_H__
#define __LcwtMLP_RFFI_PATCGfk_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCGfk_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCGfk_ram) {
        ram[0] = "0b01011110101001";
        ram[1] = "0b11100110110001";
        ram[2] = "0b00000101001000";
        ram[3] = "0b11101111000110";
        ram[4] = "0b11110010000000";
        ram[5] = "0b10111110001100";
        ram[6] = "0b11110110111011";
        ram[7] = "0b11101111001110";
        ram[8] = "0b11101110000010";
        ram[9] = "0b00000001111110";
        ram[10] = "0b00001000000001";
        ram[11] = "0b00101100000001";
        ram[12] = "0b00010100100010";
        ram[13] = "0b00111101101010";
        ram[14] = "0b11011010010100";
        ram[15] = "0b00000111010000";
        ram[16] = "0b11111100101110";
        ram[17] = "0b00000001110001";
        ram[18] = "0b11110101101111";
        ram[19] = "0b00101000010111";
        ram[20] = "0b11000011100110";
        ram[21] = "0b11110110111110";
        ram[22] = "0b00001110110000";
        ram[23] = "0b01001101011111";
        ram[24] = "0b00101111100000";
        ram[25] = "0b11111010000001";
        ram[26] = "0b00010011101000";
        ram[27] = "0b00000000001100";
        ram[28] = "0b11011010101111";
        ram[29] = "0b11101000101110";
        ram[30] = "0b11101100101010";
        ram[31] = "0b11110011111101";


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


SC_MODULE(LcwtMLP_RFFI_PATCGfk) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCGfk_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCGfk) {
meminst = new LcwtMLP_RFFI_PATCGfk_ram("LcwtMLP_RFFI_PATCGfk_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCGfk() {
    delete meminst;
}


};//endmodule
#endif
