// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCeOg_H__
#define __LcwtMLP_RFFI_PATCeOg_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCeOg_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCeOg_ram) {
        ram[0] = "0b01001111010010";
        ram[1] = "0b00011011101000";
        ram[2] = "0b00001100010111";
        ram[3] = "0b11010001001000";
        ram[4] = "0b00000100110000";
        ram[5] = "0b00001111010000";
        ram[6] = "0b00001111000010";
        ram[7] = "0b11101111010011";
        ram[8] = "0b00010101001111";
        ram[9] = "0b11001111111001";
        ram[10] = "0b00100110001100";
        ram[11] = "0b00010101001101";
        ram[12] = "0b00000100101000";
        ram[13] = "0b11011010001001";
        ram[14] = "0b10111101100010";
        ram[15] = "0b11001010101010";
        ram[16] = "0b00000111101101";
        ram[17] = "0b11001001110001";
        ram[18] = "0b00100110011110";
        ram[19] = "0b11011001100111";
        ram[20] = "0b00101100000010";
        ram[21] = "0b10110111101011";
        ram[22] = "0b11110001000001";
        ram[23] = "0b00001110100100";
        ram[24] = "0b00101111011100";
        ram[25] = "0b00100101001111";
        ram[26] = "0b11110000100110";
        ram[27] = "0b00110010101011";
        ram[28] = "0b11011111101011";
        ram[29] = "0b00001100010110";
        ram[30] = "0b01000111010001";
        ram[31] = "0b11100111011100";


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


SC_MODULE(LcwtMLP_RFFI_PATCeOg) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCeOg_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCeOg) {
meminst = new LcwtMLP_RFFI_PATCeOg_ram("LcwtMLP_RFFI_PATCeOg_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCeOg() {
    delete meminst;
}


};//endmodule
#endif
