// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCEe0_H__
#define __LcwtMLP_RFFI_PATCEe0_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCEe0_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCEe0_ram) {
        ram[0] = "0b00010100100100";
        ram[1] = "0b11101110000010";
        ram[2] = "0b00111001001000";
        ram[3] = "0b00001001101111";
        ram[4] = "0b11111110101001";
        ram[5] = "0b00010010101011";
        ram[6] = "0b11001100000100";
        ram[7] = "0b00101011000011";
        ram[8] = "0b00111101010010";
        ram[9] = "0b00001101010101";
        ram[10] = "0b00110100100111";
        ram[11] = "0b11000101101010";
        ram[12] = "0b00000000100000";
        ram[13] = "0b11001011011011";
        ram[14] = "0b01001000011010";
        ram[15] = "0b11110100001100";
        ram[16] = "0b00000110101111";
        ram[17] = "0b10011010101001";
        ram[18] = "0b11111001011110";
        ram[19] = "0b11000010111011";
        ram[20] = "0b00101110001000";
        ram[21] = "0b00000111111010";
        ram[22] = "0b00011111100110";
        ram[23] = "0b00001000110100";
        ram[24] = "0b00011011000101";
        ram[25] = "0b11110010101001";
        ram[26] = "0b11111110001001";
        ram[27] = "0b11010011011010";
        ram[28] = "0b11111010101111";
        ram[29] = "0b11000010000010";
        ram[30] = "0b11011000010001";
        ram[31] = "0b11111001110111";


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


SC_MODULE(LcwtMLP_RFFI_PATCEe0) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCEe0_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCEe0) {
meminst = new LcwtMLP_RFFI_PATCEe0_ram("LcwtMLP_RFFI_PATCEe0_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCEe0() {
    delete meminst;
}


};//endmodule
#endif
