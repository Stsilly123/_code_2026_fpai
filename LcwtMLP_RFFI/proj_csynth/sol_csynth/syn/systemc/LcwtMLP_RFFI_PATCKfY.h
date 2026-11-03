// ==============================================================
// File generated on Thu Oct 22 20:22:33 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCKfY_H__
#define __LcwtMLP_RFFI_PATCKfY_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCKfY_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCKfY_ram) {
        ram[0] = "0b110110010111000";
        ram[1] = "0b110100100100011";
        ram[2] = "0b111100111001110";
        ram[3] = "0b000111110000101";
        ram[4] = "0b001000101110111";
        ram[5] = "0b000101110011110";
        ram[6] = "0b000000110110001";
        ram[7] = "0b000001001110110";
        ram[8] = "0b100001111111111";
        ram[9] = "0b100101001111111";
        ram[10] = "0b011010011101000";
        ram[11] = "0b000110010111100";
        ram[12] = "0b110111100011011";
        ram[13] = "0b111010111111001";
        ram[14] = "0b000110111101111";
        ram[15] = "0b111101011000111";
        ram[16] = "0b001111001101101";
        ram[17] = "0b111100111000000";
        ram[18] = "0b001011010101011";
        ram[19] = "0b111111010101100";
        ram[20] = "0b001000110000011";
        ram[21] = "0b110101001001100";
        ram[22] = "0b001000100000111";
        ram[23] = "0b001010001100011";
        ram[24] = "0b111011000110000";
        ram[25] = "0b111110000100100";
        ram[26] = "0b111001111000010";
        ram[27] = "0b001011000011101";
        ram[28] = "0b001110011111010";
        ram[29] = "0b000101101011011";
        ram[30] = "0b000101011101000";
        ram[31] = "0b111001001001111";


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


SC_MODULE(LcwtMLP_RFFI_PATCKfY) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCKfY_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCKfY) {
meminst = new LcwtMLP_RFFI_PATCKfY_ram("LcwtMLP_RFFI_PATCKfY_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCKfY() {
    delete meminst;
}


};//endmodule
#endif
