// ==============================================================
// File generated on Thu Oct 22 20:22:33 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCHfu_H__
#define __LcwtMLP_RFFI_PATCHfu_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCHfu_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCHfu_ram) {
        ram[0] = "0b101111110010110";
        ram[1] = "0b000001001000111";
        ram[2] = "0b110111000100001";
        ram[3] = "0b000010011110000";
        ram[4] = "0b000010001000101";
        ram[5] = "0b110000001110100";
        ram[6] = "0b110110001111110";
        ram[7] = "0b000110001111010";
        ram[8] = "0b111111110000110";
        ram[9] = "0b101101000100011";
        ram[10] = "0b000001101010001";
        ram[11] = "0b010100001000010";
        ram[12] = "0b110111010111101";
        ram[13] = "0b110111011001110";
        ram[14] = "0b000111111000011";
        ram[15] = "0b001011011000000";
        ram[16] = "0b000010010110011";
        ram[17] = "0b101101101010101";
        ram[18] = "0b101110100110011";
        ram[19] = "0b000001101000011";
        ram[20] = "0b000111100011100";
        ram[21] = "0b110000001010101";
        ram[22] = "0b111110100111101";
        ram[23] = "0b000100000000101";
        ram[24] = "0b101100010111001";
        ram[25] = "0b110100111000001";
        ram[26] = "0b111110100000100";
        ram[27] = "0b111010010000111";
        ram[28] = "0b110100110110001";
        ram[29] = "0b000110010110111";
        ram[30] = "0b001110101000001";
        ram[31] = "0b110100010101101";


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


SC_MODULE(LcwtMLP_RFFI_PATCHfu) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCHfu_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCHfu) {
meminst = new LcwtMLP_RFFI_PATCHfu_ram("LcwtMLP_RFFI_PATCHfu_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCHfu() {
    delete meminst;
}


};//endmodule
#endif
