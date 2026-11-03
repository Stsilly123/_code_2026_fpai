// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCncg_H__
#define __LcwtMLP_RFFI_PATCncg_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCncg_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCncg_ram) {
        ram[0] = "0b11111101110000";
        ram[1] = "0b00000001101110";
        ram[2] = "0b11001011100111";
        ram[3] = "0b11100101111111";
        ram[4] = "0b11110000101111";
        ram[5] = "0b00011111111110";
        ram[6] = "0b00010000010010";
        ram[7] = "0b11010110111111";
        ram[8] = "0b00011001001101";
        ram[9] = "0b11010001001001";
        ram[10] = "0b11011110101110";
        ram[11] = "0b10111010111100";
        ram[12] = "0b11001110011010";
        ram[13] = "0b11110101001110";
        ram[14] = "0b11100110110001";
        ram[15] = "0b11011001000110";
        ram[16] = "0b01011000010001";
        ram[17] = "0b00110000010011";
        ram[18] = "0b01100001110001";
        ram[19] = "0b00100001010000";
        ram[20] = "0b00110000111010";
        ram[21] = "0b00101101101100";
        ram[22] = "0b11101001100000";
        ram[23] = "0b11110010001110";
        ram[24] = "0b00001110000101";
        ram[25] = "0b11110001111010";
        ram[26] = "0b00011100101101";
        ram[27] = "0b00100111111001";
        ram[28] = "0b11110001110111";
        ram[29] = "0b11111111111011";
        ram[30] = "0b00100010000011";
        ram[31] = "0b11101110110101";


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


SC_MODULE(LcwtMLP_RFFI_PATCncg) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCncg_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCncg) {
meminst = new LcwtMLP_RFFI_PATCncg_ram("LcwtMLP_RFFI_PATCncg_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCncg() {
    delete meminst;
}


};//endmodule
#endif
