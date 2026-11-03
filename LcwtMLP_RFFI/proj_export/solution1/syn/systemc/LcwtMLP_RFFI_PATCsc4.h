// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCsc4_H__
#define __LcwtMLP_RFFI_PATCsc4_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCsc4_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCsc4_ram) {
        ram[0] = "0b111010111100100";
        ram[1] = "0b000000000011110";
        ram[2] = "0b000000001001011";
        ram[3] = "0b111111001100001";
        ram[4] = "0b000100100001100";
        ram[5] = "0b000001000011100";
        ram[6] = "0b000100100010010";
        ram[7] = "0b001000001100111";
        ram[8] = "0b010001100010110";
        ram[9] = "0b111001111100001";
        ram[10] = "0b000100011110001";
        ram[11] = "0b000101110011010";
        ram[12] = "0b000000000100000";
        ram[13] = "0b111011001110000";
        ram[14] = "0b111000100110100";
        ram[15] = "0b111111000001000";
        ram[16] = "0b000110110101001";
        ram[17] = "0b111110001010111";
        ram[18] = "0b110111011001011";
        ram[19] = "0b000010110111010";
        ram[20] = "0b111111001000001";
        ram[21] = "0b000011101000111";
        ram[22] = "0b000011100000001";
        ram[23] = "0b000111110001111";
        ram[24] = "0b000001101011100";
        ram[25] = "0b001001110011111";
        ram[26] = "0b111101111010100";
        ram[27] = "0b001000111011001";
        ram[28] = "0b110100001101010";
        ram[29] = "0b000010001100100";
        ram[30] = "0b000000100000100";
        ram[31] = "0b000001000101010";


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


SC_MODULE(LcwtMLP_RFFI_PATCsc4) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCsc4_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCsc4) {
meminst = new LcwtMLP_RFFI_PATCsc4_ram("LcwtMLP_RFFI_PATCsc4_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCsc4() {
    delete meminst;
}


};//endmodule
#endif
