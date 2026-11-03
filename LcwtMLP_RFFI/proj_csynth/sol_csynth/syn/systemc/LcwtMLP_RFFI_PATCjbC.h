// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCjbC_H__
#define __LcwtMLP_RFFI_PATCjbC_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCjbC_ram : public sc_core::sc_module {

  static const unsigned DataWidth = 14;
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


   SC_CTOR(LcwtMLP_RFFI_PATCjbC_ram) {
        ram[0] = "0b11111101011110";
        ram[1] = "0b11110101111000";
        ram[2] = "0b00001001110000";
        ram[3] = "0b00001000100110";
        ram[4] = "0b00010000011100";
        ram[5] = "0b00011101011000";
        ram[6] = "0b11000100010111";
        ram[7] = "0b00000101111001";
        ram[8] = "0b11100010010110";
        ram[9] = "0b01101110111110";
        ram[10] = "0b00111011100010";
        ram[11] = "0b11101100101110";
        ram[12] = "0b00101101010110";
        ram[13] = "0b00000001101001";
        ram[14] = "0b11001000101110";
        ram[15] = "0b11110101011110";
        ram[16] = "0b11100001110001";
        ram[17] = "0b11111000111100";
        ram[18] = "0b11101010001110";
        ram[19] = "0b11101110100011";
        ram[20] = "0b00001110001000";
        ram[21] = "0b00100111011011";
        ram[22] = "0b00011010100010";
        ram[23] = "0b00000010000011";
        ram[24] = "0b00101110001111";
        ram[25] = "0b00010100101111";
        ram[26] = "0b00111110010001";
        ram[27] = "0b00011000100100";
        ram[28] = "0b00010101011011";
        ram[29] = "0b11111000001110";
        ram[30] = "0b11100010011110";
        ram[31] = "0b00000011101010";


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


SC_MODULE(LcwtMLP_RFFI_PATCjbC) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCjbC_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCjbC) {
meminst = new LcwtMLP_RFFI_PATCjbC_ram("LcwtMLP_RFFI_PATCjbC_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCjbC() {
    delete meminst;
}


};//endmodule
#endif
