// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCfYi_H__
#define __LcwtMLP_RFFI_PATCfYi_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCfYi_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCfYi_ram) {
        ram[0] = "0b000001100110001";
        ram[1] = "0b111111111010100";
        ram[2] = "0b000010001000101";
        ram[3] = "0b001011111010111";
        ram[4] = "0b000111011000010";
        ram[5] = "0b110110011110100";
        ram[6] = "0b000110000111100";
        ram[7] = "0b000010011001000";
        ram[8] = "0b010010110100011";
        ram[9] = "0b000000110110111";
        ram[10] = "0b111011111100110";
        ram[11] = "0b001110100001001";
        ram[12] = "0b111100010111110";
        ram[13] = "0b111111000001000";
        ram[14] = "0b111001010100111";
        ram[15] = "0b000011010001011";
        ram[16] = "0b111110001110101";
        ram[17] = "0b111110110001011";
        ram[18] = "0b111000101011110";
        ram[19] = "0b111110000010011";
        ram[20] = "0b111001011111011";
        ram[21] = "0b000111101010000";
        ram[22] = "0b110111010111001";
        ram[23] = "0b000011010011110";
        ram[24] = "0b000101011001010";
        ram[25] = "0b000011001111110";
        ram[26] = "0b110011101110000";
        ram[27] = "0b111100000110011";
        ram[28] = "0b111111101101011";
        ram[29] = "0b001011110101111";
        ram[30] = "0b001011100010010";
        ram[31] = "0b000010000010010";


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


SC_MODULE(LcwtMLP_RFFI_PATCfYi) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCfYi_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCfYi) {
meminst = new LcwtMLP_RFFI_PATCfYi_ram("LcwtMLP_RFFI_PATCfYi_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCfYi() {
    delete meminst;
}


};//endmodule
#endif
