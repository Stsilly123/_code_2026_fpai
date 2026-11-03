// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCBew_H__
#define __LcwtMLP_RFFI_PATCBew_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCBew_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCBew_ram) {
        ram[0] = "0b00110001011100";
        ram[1] = "0b11100000000001";
        ram[2] = "0b00100111000101";
        ram[3] = "0b11000000010111";
        ram[4] = "0b00001010001110";
        ram[5] = "0b11111001100001";
        ram[6] = "0b00010011110011";
        ram[7] = "0b00110010101110";
        ram[8] = "0b00110000001001";
        ram[9] = "0b11100101111110";
        ram[10] = "0b00100011110100";
        ram[11] = "0b01001100101100";
        ram[12] = "0b00000111010001";
        ram[13] = "0b00000110001000";
        ram[14] = "0b00011110101011";
        ram[15] = "0b10110010101001";
        ram[16] = "0b00010000011010";
        ram[17] = "0b11010010011010";
        ram[18] = "0b11100011011011";
        ram[19] = "0b00111100010000";
        ram[20] = "0b00000110001010";
        ram[21] = "0b10101101001010";
        ram[22] = "0b00111100110100";
        ram[23] = "0b11101010010111";
        ram[24] = "0b00100010000010";
        ram[25] = "0b00111110101100";
        ram[26] = "0b00000010010000";
        ram[27] = "0b00010101011110";
        ram[28] = "0b11011010111110";
        ram[29] = "0b11101101011010";
        ram[30] = "0b00110001110011";
        ram[31] = "0b00011110011101";


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


SC_MODULE(LcwtMLP_RFFI_PATCBew) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCBew_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCBew) {
meminst = new LcwtMLP_RFFI_PATCBew_ram("LcwtMLP_RFFI_PATCBew_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCBew() {
    delete meminst;
}


};//endmodule
#endif
