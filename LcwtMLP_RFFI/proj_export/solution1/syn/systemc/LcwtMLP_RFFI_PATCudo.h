// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCudo_H__
#define __LcwtMLP_RFFI_PATCudo_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCudo_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCudo_ram) {
        ram[0] = "0b11010101010001";
        ram[1] = "0b11101111100101";
        ram[2] = "0b00111010011110";
        ram[3] = "0b00001110011011";
        ram[4] = "0b00000101000010";
        ram[5] = "0b11110111101001";
        ram[6] = "0b10110101011111";
        ram[7] = "0b11010111011010";
        ram[8] = "0b00011010100100";
        ram[9] = "0b00101010110110";
        ram[10] = "0b00011111000100";
        ram[11] = "0b00001101010111";
        ram[12] = "0b11001110111010";
        ram[13] = "0b01001100001110";
        ram[14] = "0b00001000100101";
        ram[15] = "0b00011100010101";
        ram[16] = "0b00000100101001";
        ram[17] = "0b10111011011101";
        ram[18] = "0b11110011111011";
        ram[19] = "0b11111001000101";
        ram[20] = "0b11101001011000";
        ram[21] = "0b01000111111011";
        ram[22] = "0b11111011110101";
        ram[23] = "0b11111111100001";
        ram[24] = "0b00011011101001";
        ram[25] = "0b11101010100110";
        ram[26] = "0b00010110100101";
        ram[27] = "0b00000111000101";
        ram[28] = "0b00000110011101";
        ram[29] = "0b00011010111000";
        ram[30] = "0b00011000101010";
        ram[31] = "0b11011001010101";


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


SC_MODULE(LcwtMLP_RFFI_PATCudo) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCudo_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCudo) {
meminst = new LcwtMLP_RFFI_PATCudo_ram("LcwtMLP_RFFI_PATCudo_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCudo() {
    delete meminst;
}


};//endmodule
#endif
