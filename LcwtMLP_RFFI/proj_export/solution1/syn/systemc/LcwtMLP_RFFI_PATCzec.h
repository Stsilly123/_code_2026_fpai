// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCzec_H__
#define __LcwtMLP_RFFI_PATCzec_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCzec_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCzec_ram) {
        ram[0] = "0b000011101011010";
        ram[1] = "0b000110101101010";
        ram[2] = "0b000000000100010";
        ram[3] = "0b001101101001100";
        ram[4] = "0b111001111000110";
        ram[5] = "0b000001001011001";
        ram[6] = "0b001101001010011";
        ram[7] = "0b111001010110010";
        ram[8] = "0b101001011010100";
        ram[9] = "0b001010110111010";
        ram[10] = "0b011010101111001";
        ram[11] = "0b111100110111001";
        ram[12] = "0b111100111110001";
        ram[13] = "0b000011010000100";
        ram[14] = "0b111110001010000";
        ram[15] = "0b100111001111000";
        ram[16] = "0b101110000100111";
        ram[17] = "0b001100111011010";
        ram[18] = "0b010100101001110";
        ram[19] = "0b101111010100001";
        ram[20] = "0b010001110111111";
        ram[21] = "0b111101011011101";
        ram[22] = "0b000001010111001";
        ram[23] = "0b110111110101111";
        ram[24] = "0b001011010001101";
        ram[25] = "0b000111100010001";
        ram[26] = "0b000011001100101";
        ram[27] = "0b000111001011000";
        ram[28] = "0b001101001101000";
        ram[29] = "0b111010011101001";
        ram[30] = "0b111011000110101";
        ram[31] = "0b000101011000111";


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


SC_MODULE(LcwtMLP_RFFI_PATCzec) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCzec_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCzec) {
meminst = new LcwtMLP_RFFI_PATCzec_ram("LcwtMLP_RFFI_PATCzec_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCzec() {
    delete meminst;
}


};//endmodule
#endif
