// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCtde_H__
#define __LcwtMLP_RFFI_PATCtde_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCtde_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCtde_ram) {
        ram[0] = "0b00000010110011";
        ram[1] = "0b00001100001000";
        ram[2] = "0b10111111101111";
        ram[3] = "0b01000110011011";
        ram[4] = "0b11100010000001";
        ram[5] = "0b11010011000010";
        ram[6] = "0b00001101010011";
        ram[7] = "0b00011100111100";
        ram[8] = "0b11111010111110";
        ram[9] = "0b00110001011110";
        ram[10] = "0b10111111111000";
        ram[11] = "0b00011100000010";
        ram[12] = "0b10110101000010";
        ram[13] = "0b11011101110000";
        ram[14] = "0b00111011100101";
        ram[15] = "0b00000011001011";
        ram[16] = "0b11111110011011";
        ram[17] = "0b00001000010001";
        ram[18] = "0b01010100011110";
        ram[19] = "0b11000110011000";
        ram[20] = "0b11101110001000";
        ram[21] = "0b00110100011110";
        ram[22] = "0b11110000110010";
        ram[23] = "0b11110100001011";
        ram[24] = "0b01011001000101";
        ram[25] = "0b00010110100001";
        ram[26] = "0b00100001111011";
        ram[27] = "0b10111011100001";
        ram[28] = "0b11011101100101";
        ram[29] = "0b00001101000000";
        ram[30] = "0b00000000000011";
        ram[31] = "0b00111111010111";


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


SC_MODULE(LcwtMLP_RFFI_PATCtde) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCtde_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCtde) {
meminst = new LcwtMLP_RFFI_PATCtde_ram("LcwtMLP_RFFI_PATCtde_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCtde() {
    delete meminst;
}


};//endmodule
#endif
