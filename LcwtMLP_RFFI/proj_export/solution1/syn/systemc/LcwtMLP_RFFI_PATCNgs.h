// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCNgs_H__
#define __LcwtMLP_RFFI_PATCNgs_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCNgs_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCNgs_ram) {
        ram[0] = "0b111011010011101";
        ram[1] = "0b001101001110001";
        ram[2] = "0b000110100011101";
        ram[3] = "0b000010010100100";
        ram[4] = "0b100110100011000";
        ram[5] = "0b011000010111111";
        ram[6] = "0b110011001111111";
        ram[7] = "0b110110010001000";
        ram[8] = "0b101100101011101";
        ram[9] = "0b001111101100001";
        ram[10] = "0b110110000101110";
        ram[11] = "0b101011101110111";
        ram[12] = "0b001111001101111";
        ram[13] = "0b001001100100100";
        ram[14] = "0b100111101100101";
        ram[15] = "0b000001011010100";
        ram[16] = "0b111010001010001";
        ram[17] = "0b000011000111000";
        ram[18] = "0b010001111111111";
        ram[19] = "0b010011000010001";
        ram[20] = "0b110001101010000";
        ram[21] = "0b000100010110110";
        ram[22] = "0b111001010101101";
        ram[23] = "0b111001010011001";
        ram[24] = "0b001111011010000";
        ram[25] = "0b101110010111000";
        ram[26] = "0b110011110001110";
        ram[27] = "0b001010001100000";
        ram[28] = "0b111010111100010";
        ram[29] = "0b101110100011111";
        ram[30] = "0b111001111010000";
        ram[31] = "0b001001100100101";


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


SC_MODULE(LcwtMLP_RFFI_PATCNgs) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCNgs_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCNgs) {
meminst = new LcwtMLP_RFFI_PATCNgs_ram("LcwtMLP_RFFI_PATCNgs_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCNgs() {
    delete meminst;
}


};//endmodule
#endif
