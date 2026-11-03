// ==============================================================
// File generated on Thu Oct 22 20:22:33 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCMgi_H__
#define __LcwtMLP_RFFI_PATCMgi_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCMgi_ram : public sc_core::sc_module {

  static const unsigned DataWidth = 15;
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


   SC_CTOR(LcwtMLP_RFFI_PATCMgi_ram) {
        ram[0] = "0b010011001100100";
        ram[1] = "0b111101110101111";
        ram[2] = "0b000100100111110";
        ram[3] = "0b111001011110011";
        ram[4] = "0b001111010110111";
        ram[5] = "0b100110101100001";
        ram[6] = "0b001010101100011";
        ram[7] = "0b000110001111010";
        ram[8] = "0b001100101010101";
        ram[9] = "0b111110011010100";
        ram[10] = "0b000000111011001";
        ram[11] = "0b010100100001000";
        ram[12] = "0b000110001101100";
        ram[13] = "0b000100100101101";
        ram[14] = "0b111010000110000";
        ram[15] = "0b111100110101110";
        ram[16] = "0b110111111010100";
        ram[17] = "0b110101110010010";
        ram[18] = "0b111100100000101";
        ram[19] = "0b001000110000010";
        ram[20] = "0b100010100111001";
        ram[21] = "0b001011001110101";
        ram[22] = "0b101110110011011";
        ram[23] = "0b111001010010110";
        ram[24] = "0b010111010101101";
        ram[25] = "0b010001001100110";
        ram[26] = "0b101101101000111";
        ram[27] = "0b101111110110011";
        ram[28] = "0b111001011000111";
        ram[29] = "0b001010011110111";
        ram[30] = "0b000010100010110";
        ram[31] = "0b101101111010001";


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


SC_MODULE(LcwtMLP_RFFI_PATCMgi) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCMgi_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCMgi) {
meminst = new LcwtMLP_RFFI_PATCMgi_ram("LcwtMLP_RFFI_PATCMgi_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCMgi() {
    delete meminst;
}


};//endmodule
#endif
