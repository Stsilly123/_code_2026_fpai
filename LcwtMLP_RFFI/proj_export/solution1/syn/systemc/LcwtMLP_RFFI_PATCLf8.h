// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCLf8_H__
#define __LcwtMLP_RFFI_PATCLf8_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCLf8_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCLf8_ram) {
        ram[0] = "0b000100100110100";
        ram[1] = "0b111010100010011";
        ram[2] = "0b101001100000111";
        ram[3] = "0b000000011000110";
        ram[4] = "0b111010010001001";
        ram[5] = "0b110101111111100";
        ram[6] = "0b111010000101001";
        ram[7] = "0b111011100010011";
        ram[8] = "0b111101100011011";
        ram[9] = "0b110111011101100";
        ram[10] = "0b110001101000110";
        ram[11] = "0b110101100100011";
        ram[12] = "0b110101110111000";
        ram[13] = "0b111001011011110";
        ram[14] = "0b111100111001010";
        ram[15] = "0b111000110011111";
        ram[16] = "0b001001010011111";
        ram[17] = "0b000000001000011";
        ram[18] = "0b000001011101101";
        ram[19] = "0b000011010011001";
        ram[20] = "0b111101100110000";
        ram[21] = "0b000100100000010";
        ram[22] = "0b000010101101100";
        ram[23] = "0b111101100110101";
        ram[24] = "0b101101000000001";
        ram[25] = "0b111001111111100";
        ram[26] = "0b010011101000101";
        ram[27] = "0b000100110101001";
        ram[28] = "0b111001001010010";
        ram[29] = "0b000000001010111";
        ram[30] = "0b000111101001000";
        ram[31] = "0b001010110010001";


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


SC_MODULE(LcwtMLP_RFFI_PATCLf8) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCLf8_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCLf8) {
meminst = new LcwtMLP_RFFI_PATCLf8_ram("LcwtMLP_RFFI_PATCLf8_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCLf8() {
    delete meminst;
}


};//endmodule
#endif
