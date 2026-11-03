// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCAem_H__
#define __LcwtMLP_RFFI_PATCAem_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCAem_ram : public sc_core::sc_module {

  static const unsigned DataWidth = 16;
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


   SC_CTOR(LcwtMLP_RFFI_PATCAem_ram) {
        ram[0] = "0b0100111100000100";
        ram[1] = "0b1111001001101010";
        ram[2] = "0b1111011101100110";
        ram[3] = "0b1101011000000110";
        ram[4] = "0b0000111001111010";
        ram[5] = "0b0011010100111001";
        ram[6] = "0b0000010100010101";
        ram[7] = "0b0000111111010101";
        ram[8] = "0b0000100010111011";
        ram[9] = "0b0001100000010111";
        ram[10] = "0b0001001110101001";
        ram[11] = "0b1110011100111001";
        ram[12] = "0b1110110010001010";
        ram[13] = "0b1111011010001011";
        ram[14] = "0b0010101111100001";
        ram[15] = "0b1111101101111001";
        ram[16] = "0b1111010101100100";
        ram[17] = "0b0010000001010010";
        ram[18] = "0b0001000010111101";
        ram[19] = "0b1110111000100001";
        ram[20] = "0b1100000111001101";
        ram[21] = "0b0100011000101111";
        ram[22] = "0b0000011000000111";
        ram[23] = "0b1101101100110001";
        ram[24] = "0b1011011100111110";
        ram[25] = "0b0010000110100001";
        ram[26] = "0b0001111000110110";
        ram[27] = "0b1110100001010001";
        ram[28] = "0b0010010011001001";
        ram[29] = "0b0000100101110100";
        ram[30] = "0b1111000111101011";
        ram[31] = "0b1110101011110111";


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


SC_MODULE(LcwtMLP_RFFI_PATCAem) {


static const unsigned DataWidth = 16;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCAem_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCAem) {
meminst = new LcwtMLP_RFFI_PATCAem_ram("LcwtMLP_RFFI_PATCAem_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCAem() {
    delete meminst;
}


};//endmodule
#endif
