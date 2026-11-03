// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCg8j_H__
#define __LcwtMLP_RFFI_PATCg8j_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCg8j_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCg8j_ram) {
        ram[0] = "0b10101101110011";
        ram[1] = "0b11100011011111";
        ram[2] = "0b11110111010010";
        ram[3] = "0b10110011010001";
        ram[4] = "0b01001011000110";
        ram[5] = "0b11101011110111";
        ram[6] = "0b00000111000111";
        ram[7] = "0b00101000001111";
        ram[8] = "0b00001110110110";
        ram[9] = "0b11000101111110";
        ram[10] = "0b11000110011100";
        ram[11] = "0b11101011011000";
        ram[12] = "0b00100101110011";
        ram[13] = "0b00000011010000";
        ram[14] = "0b11011010011111";
        ram[15] = "0b11001110111000";
        ram[16] = "0b00000110111011";
        ram[17] = "0b11101101111111";
        ram[18] = "0b11110101011001";
        ram[19] = "0b11011101010111";
        ram[20] = "0b11011010011011";
        ram[21] = "0b11110110000011";
        ram[22] = "0b11111011011001";
        ram[23] = "0b11110010000001";
        ram[24] = "0b11111001111111";
        ram[25] = "0b11101001111010";
        ram[26] = "0b11001010011101";
        ram[27] = "0b11001100110010";
        ram[28] = "0b10100110010010";
        ram[29] = "0b01001011000001";
        ram[30] = "0b11011101100101";
        ram[31] = "0b11000101011010";


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


SC_MODULE(LcwtMLP_RFFI_PATCg8j) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCg8j_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCg8j) {
meminst = new LcwtMLP_RFFI_PATCg8j_ram("LcwtMLP_RFFI_PATCg8j_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCg8j() {
    delete meminst;
}


};//endmodule
#endif
