// ==============================================================
// File generated on Thu Oct 22 20:22:33 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCCeG_H__
#define __LcwtMLP_RFFI_PATCCeG_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCCeG_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCCeG_ram) {
        ram[0] = "0b110000001001000";
        ram[1] = "0b111011011101011";
        ram[2] = "0b001011110100011";
        ram[3] = "0b000000011101111";
        ram[4] = "0b110111101000001";
        ram[5] = "0b111010000010111";
        ram[6] = "0b111110001001010";
        ram[7] = "0b111111111111010";
        ram[8] = "0b110110100001111";
        ram[9] = "0b000000010000000";
        ram[10] = "0b111111001011001";
        ram[11] = "0b111010001100110";
        ram[12] = "0b000101001110110";
        ram[13] = "0b000110110110110";
        ram[14] = "0b111111110110110";
        ram[15] = "0b000111011001011";
        ram[16] = "0b111110101110110";
        ram[17] = "0b111100010010011";
        ram[18] = "0b000101101000010";
        ram[19] = "0b000111011111001";
        ram[20] = "0b110111010100000";
        ram[21] = "0b000000110011101";
        ram[22] = "0b000010110010011";
        ram[23] = "0b111101001001001";
        ram[24] = "0b010011010110100";
        ram[25] = "0b111101110101001";
        ram[26] = "0b101111011110011";
        ram[27] = "0b111011000001110";
        ram[28] = "0b000011101000110";
        ram[29] = "0b000010110000111";
        ram[30] = "0b111101010110100";
        ram[31] = "0b000010011000110";


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


SC_MODULE(LcwtMLP_RFFI_PATCCeG) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCCeG_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCCeG) {
meminst = new LcwtMLP_RFFI_PATCCeG_ram("LcwtMLP_RFFI_PATCCeG_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCCeG() {
    delete meminst;
}


};//endmodule
#endif
