// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCocq_H__
#define __LcwtMLP_RFFI_PATCocq_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCocq_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCocq_ram) {
        ram[0] = "0b001000011110101";
        ram[1] = "0b001100110011100";
        ram[2] = "0b111011101010011";
        ram[3] = "0b001010010000110";
        ram[4] = "0b111000011010011";
        ram[5] = "0b001010011101111";
        ram[6] = "0b110110101001110";
        ram[7] = "0b000111111110001";
        ram[8] = "0b000101000110100";
        ram[9] = "0b001000001011010";
        ram[10] = "0b111000010001101";
        ram[11] = "0b010011100011101";
        ram[12] = "0b001011000110011";
        ram[13] = "0b001101010100000";
        ram[14] = "0b111111011010111";
        ram[15] = "0b000110101000010";
        ram[16] = "0b001110011010111";
        ram[17] = "0b111110100001010";
        ram[18] = "0b111011001111011";
        ram[19] = "0b110100110010100";
        ram[20] = "0b000101111110100";
        ram[21] = "0b110100111001101";
        ram[22] = "0b111010110101010";
        ram[23] = "0b001000100011111";
        ram[24] = "0b000110001000000";
        ram[25] = "0b000000111010011";
        ram[26] = "0b111100111011011";
        ram[27] = "0b001001111011010";
        ram[28] = "0b111101010010100";
        ram[29] = "0b111101001110111";
        ram[30] = "0b001010010111101";
        ram[31] = "0b000111010010001";


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


SC_MODULE(LcwtMLP_RFFI_PATCocq) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCocq_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCocq) {
meminst = new LcwtMLP_RFFI_PATCocq_ram("LcwtMLP_RFFI_PATCocq_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCocq() {
    delete meminst;
}


};//endmodule
#endif
