// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCkbM_H__
#define __LcwtMLP_RFFI_PATCkbM_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCkbM_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCkbM_ram) {
        ram[0] = "0b111011000110000";
        ram[1] = "0b111110100110101";
        ram[2] = "0b000010011001110";
        ram[3] = "0b111011101000100";
        ram[4] = "0b001000001100011";
        ram[5] = "0b110011110111111";
        ram[6] = "0b000101010011001";
        ram[7] = "0b000101100010011";
        ram[8] = "0b000110011110010";
        ram[9] = "0b111001011110111";
        ram[10] = "0b000011110101011";
        ram[11] = "0b001010010100100";
        ram[12] = "0b111000101001011";
        ram[13] = "0b111010011110110";
        ram[14] = "0b000001011100101";
        ram[15] = "0b001000000111110";
        ram[16] = "0b000011100010011";
        ram[17] = "0b111000100100100";
        ram[18] = "0b000101001100011";
        ram[19] = "0b110110100100100";
        ram[20] = "0b001000010000110";
        ram[21] = "0b000000111100000";
        ram[22] = "0b000100100010001";
        ram[23] = "0b111100101110010";
        ram[24] = "0b001010100100011";
        ram[25] = "0b000000001000101";
        ram[26] = "0b110011010010010";
        ram[27] = "0b101101000110010";
        ram[28] = "0b000111000110110";
        ram[29] = "0b000010110000000";
        ram[30] = "0b111001100100101";
        ram[31] = "0b000010011011010";


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


SC_MODULE(LcwtMLP_RFFI_PATCkbM) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCkbM_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCkbM) {
meminst = new LcwtMLP_RFFI_PATCkbM_ram("LcwtMLP_RFFI_PATCkbM_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCkbM() {
    delete meminst;
}


};//endmodule
#endif
