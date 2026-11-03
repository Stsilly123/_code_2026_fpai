// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCibs_H__
#define __LcwtMLP_RFFI_PATCibs_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCibs_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCibs_ram) {
        ram[0] = "0b00001111100011";
        ram[1] = "0b11100101111100";
        ram[2] = "0b01001001000010";
        ram[3] = "0b00010000001001";
        ram[4] = "0b00010101010101";
        ram[5] = "0b11100100101010";
        ram[6] = "0b01000101000111";
        ram[7] = "0b10101001010100";
        ram[8] = "0b11101000111101";
        ram[9] = "0b00110111101001";
        ram[10] = "0b00100010101111";
        ram[11] = "0b11000111001111";
        ram[12] = "0b00011001101001";
        ram[13] = "0b11010110000001";
        ram[14] = "0b11100101011010";
        ram[15] = "0b11111010110101";
        ram[16] = "0b11100011100001";
        ram[17] = "0b00001101101000";
        ram[18] = "0b00011111101011";
        ram[19] = "0b11001100100101";
        ram[20] = "0b00100011100111";
        ram[21] = "0b10110110010011";
        ram[22] = "0b11110110000011";
        ram[23] = "0b11100011001111";
        ram[24] = "0b00000101110110";
        ram[25] = "0b00111101101111";
        ram[26] = "0b11010100111010";
        ram[27] = "0b11101100011011";
        ram[28] = "0b00011100010110";
        ram[29] = "0b00101110110010";
        ram[30] = "0b11101011001011";
        ram[31] = "0b00111000100101";


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


SC_MODULE(LcwtMLP_RFFI_PATCibs) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCibs_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCibs) {
meminst = new LcwtMLP_RFFI_PATCibs_ram("LcwtMLP_RFFI_PATCibs_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCibs() {
    delete meminst;
}


};//endmodule
#endif
