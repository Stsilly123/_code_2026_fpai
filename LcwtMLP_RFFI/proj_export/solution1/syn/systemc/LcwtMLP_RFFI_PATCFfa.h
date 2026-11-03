// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCFfa_H__
#define __LcwtMLP_RFFI_PATCFfa_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCFfa_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCFfa_ram) {
        ram[0] = "0b11010111111111";
        ram[1] = "0b00100011011011";
        ram[2] = "0b11001101111101";
        ram[3] = "0b11001110011001";
        ram[4] = "0b00011110110000";
        ram[5] = "0b11110101001010";
        ram[6] = "0b11010100111000";
        ram[7] = "0b00110010111010";
        ram[8] = "0b01001011000100";
        ram[9] = "0b00001001110110";
        ram[10] = "0b00011011101010";
        ram[11] = "0b00110111100011";
        ram[12] = "0b11111100101001";
        ram[13] = "0b00101111100111";
        ram[14] = "0b11101111001000";
        ram[15] = "0b01001110001101";
        ram[16] = "0b11001011000000";
        ram[17] = "0b11001111110000";
        ram[18] = "0b00001001101011";
        ram[19] = "0b11011011100010";
        ram[20] = "0b01100100101110";
        ram[21] = "0b00110001101110";
        ram[22] = "0b00000010000001";
        ram[23] = "0b00010101100110";
        ram[24] = "0b00001100000000";
        ram[25] = "0b10010011001010";
        ram[26] = "0b00100110010110";
        ram[27] = "0b00110101010001";
        ram[28] = "0b11110000010001";
        ram[29] = "0b11110010001001";
        ram[30] = "0b00010100111100";
        ram[31] = "0b00011100111101";


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


SC_MODULE(LcwtMLP_RFFI_PATCFfa) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCFfa_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCFfa) {
meminst = new LcwtMLP_RFFI_PATCFfa_ram("LcwtMLP_RFFI_PATCFfa_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCFfa() {
    delete meminst;
}


};//endmodule
#endif
