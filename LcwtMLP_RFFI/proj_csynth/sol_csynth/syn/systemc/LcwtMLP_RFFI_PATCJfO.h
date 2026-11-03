// ==============================================================
// File generated on Thu Oct 22 20:22:33 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCJfO_H__
#define __LcwtMLP_RFFI_PATCJfO_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCJfO_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCJfO_ram) {
        ram[0] = "0b000010000110110";
        ram[1] = "0b001110010010010";
        ram[2] = "0b000100001111101";
        ram[3] = "0b001000111011000";
        ram[4] = "0b111101000000101";
        ram[5] = "0b110100111000010";
        ram[6] = "0b000010010101001";
        ram[7] = "0b111111001000001";
        ram[8] = "0b101110111001010";
        ram[9] = "0b000111100011000";
        ram[10] = "0b001001101101010";
        ram[11] = "0b001011001010101";
        ram[12] = "0b000010010000110";
        ram[13] = "0b000110001000110";
        ram[14] = "0b000111110001011";
        ram[15] = "0b000000110101010";
        ram[16] = "0b110010010011101";
        ram[17] = "0b111100010101110";
        ram[18] = "0b111100100111001";
        ram[19] = "0b110111001000101";
        ram[20] = "0b000011010110000";
        ram[21] = "0b101101110101010";
        ram[22] = "0b110101001101100";
        ram[23] = "0b111010001111101";
        ram[24] = "0b000001110011011";
        ram[25] = "0b000101011111110";
        ram[26] = "0b111001110011011";
        ram[27] = "0b111011011110111";
        ram[28] = "0b000101101000011";
        ram[29] = "0b000011110000100";
        ram[30] = "0b000110000010111";
        ram[31] = "0b111000010101010";


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


SC_MODULE(LcwtMLP_RFFI_PATCJfO) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCJfO_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCJfO) {
meminst = new LcwtMLP_RFFI_PATCJfO_ram("LcwtMLP_RFFI_PATCJfO_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCJfO() {
    delete meminst;
}


};//endmodule
#endif
