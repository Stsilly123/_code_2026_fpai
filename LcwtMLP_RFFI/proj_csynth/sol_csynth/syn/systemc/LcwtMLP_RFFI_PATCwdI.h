// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCwdI_H__
#define __LcwtMLP_RFFI_PATCwdI_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCwdI_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCwdI_ram) {
        ram[0] = "0b000100010100101";
        ram[1] = "0b111110110100100";
        ram[2] = "0b110111111001011";
        ram[3] = "0b110110100101101";
        ram[4] = "0b101111010101011";
        ram[5] = "0b000110110011011";
        ram[6] = "0b111110001110111";
        ram[7] = "0b000100100110001";
        ram[8] = "0b111001100001011";
        ram[9] = "0b001011000111101";
        ram[10] = "0b111001000011101";
        ram[11] = "0b110100011110001";
        ram[12] = "0b000111011001000";
        ram[13] = "0b000010000001000";
        ram[14] = "0b000000111100110";
        ram[15] = "0b111101010011001";
        ram[16] = "0b111011011111100";
        ram[17] = "0b000100001110110";
        ram[18] = "0b111001000010010";
        ram[19] = "0b111101001001001";
        ram[20] = "0b000001011001010";
        ram[21] = "0b110011100111111";
        ram[22] = "0b111110110100110";
        ram[23] = "0b000111111000101";
        ram[24] = "0b000000010011000";
        ram[25] = "0b111110101011010";
        ram[26] = "0b000110000011101";
        ram[27] = "0b000010000110001";
        ram[28] = "0b000000110110010";
        ram[29] = "0b000001111000000";
        ram[30] = "0b000110000111001";
        ram[31] = "0b000101110000101";


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


SC_MODULE(LcwtMLP_RFFI_PATCwdI) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCwdI_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCwdI) {
meminst = new LcwtMLP_RFFI_PATCwdI_ram("LcwtMLP_RFFI_PATCwdI_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCwdI() {
    delete meminst;
}


};//endmodule
#endif
