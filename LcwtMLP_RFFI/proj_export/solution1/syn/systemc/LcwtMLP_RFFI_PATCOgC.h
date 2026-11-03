// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCOgC_H__
#define __LcwtMLP_RFFI_PATCOgC_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCOgC_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCOgC_ram) {
        ram[0] = "0b111101001100101";
        ram[1] = "0b111101100101000";
        ram[2] = "0b111111001101010";
        ram[3] = "0b001001101111000";
        ram[4] = "0b110100000010000";
        ram[5] = "0b111111110011000";
        ram[6] = "0b000101101100101";
        ram[7] = "0b001010010110000";
        ram[8] = "0b110100011000100";
        ram[9] = "0b001101111000101";
        ram[10] = "0b000011000010111";
        ram[11] = "0b111011100101101";
        ram[12] = "0b000001010111010";
        ram[13] = "0b111110010000101";
        ram[14] = "0b111110011010011";
        ram[15] = "0b110100110110101";
        ram[16] = "0b110100101001100";
        ram[17] = "0b000111100101111";
        ram[18] = "0b111001110111100";
        ram[19] = "0b111011111001011";
        ram[20] = "0b110100111011111";
        ram[21] = "0b001000100000100";
        ram[22] = "0b000010110010000";
        ram[23] = "0b111001011111011";
        ram[24] = "0b000010000110001";
        ram[25] = "0b110001010010011";
        ram[26] = "0b101111111001000";
        ram[27] = "0b110111100011001";
        ram[28] = "0b000000011011010";
        ram[29] = "0b000110011110111";
        ram[30] = "0b111110000100010";
        ram[31] = "0b001011001111011";


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


SC_MODULE(LcwtMLP_RFFI_PATCOgC) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCOgC_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCOgC) {
meminst = new LcwtMLP_RFFI_PATCOgC_ram("LcwtMLP_RFFI_PATCOgC_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCOgC() {
    delete meminst;
}


};//endmodule
#endif
