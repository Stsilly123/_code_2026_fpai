// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATChbi_H__
#define __LcwtMLP_RFFI_PATChbi_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATChbi_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATChbi_ram) {
        ram[0] = "0b110110001000101";
        ram[1] = "0b101100011111101";
        ram[2] = "0b000001010011100";
        ram[3] = "0b001101011010001";
        ram[4] = "0b111101110111110";
        ram[5] = "0b111000010101101";
        ram[6] = "0b111011100111100";
        ram[7] = "0b111111010110001";
        ram[8] = "0b110110001011011";
        ram[9] = "0b111001001001110";
        ram[10] = "0b111011111001000";
        ram[11] = "0b111110100011011";
        ram[12] = "0b111001110010110";
        ram[13] = "0b111101000100010";
        ram[14] = "0b111101011101101";
        ram[15] = "0b110010110111100";
        ram[16] = "0b001001000111010";
        ram[17] = "0b110010110001111";
        ram[18] = "0b000101011000010";
        ram[19] = "0b111111100001000";
        ram[20] = "0b111110110101011";
        ram[21] = "0b010001101110110";
        ram[22] = "0b111110110010101";
        ram[23] = "0b001101110011110";
        ram[24] = "0b110111000011100";
        ram[25] = "0b010110011110100";
        ram[26] = "0b110010011100111";
        ram[27] = "0b101111101011011";
        ram[28] = "0b111110100111001";
        ram[29] = "0b000110011010110";
        ram[30] = "0b111111110100110";
        ram[31] = "0b000101110111101";


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


SC_MODULE(LcwtMLP_RFFI_PATChbi) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATChbi_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATChbi) {
meminst = new LcwtMLP_RFFI_PATChbi_ram("LcwtMLP_RFFI_PATChbi_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATChbi() {
    delete meminst;
}


};//endmodule
#endif
