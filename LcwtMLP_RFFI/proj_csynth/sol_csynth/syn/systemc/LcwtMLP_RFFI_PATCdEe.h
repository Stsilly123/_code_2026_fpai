// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCdEe_H__
#define __LcwtMLP_RFFI_PATCdEe_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCdEe_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCdEe_ram) {
        ram[0] = "0b00010110010100";
        ram[1] = "0b10101110010110";
        ram[2] = "0b00110011101101";
        ram[3] = "0b11010100111111";
        ram[4] = "0b00000101001001";
        ram[5] = "0b11011000101010";
        ram[6] = "0b11011011011001";
        ram[7] = "0b11100010000000";
        ram[8] = "0b00011010100000";
        ram[9] = "0b11110000100110";
        ram[10] = "0b00001000010101";
        ram[11] = "0b11100001000001";
        ram[12] = "0b11111010011110";
        ram[13] = "0b10101100000001";
        ram[14] = "0b00001011001110";
        ram[15] = "0b11101000101011";
        ram[16] = "0b10110011111010";
        ram[17] = "0b00100010111111";
        ram[18] = "0b01000001001000";
        ram[19] = "0b00001010010101";
        ram[20] = "0b00011000000100";
        ram[21] = "0b10111000100000";
        ram[22] = "0b00011101111001";
        ram[23] = "0b00000000110111";
        ram[24] = "0b11011011110101";
        ram[25] = "0b00100010111110";
        ram[26] = "0b11111000001001";
        ram[27] = "0b00100110001000";
        ram[28] = "0b00011010001100";
        ram[29] = "0b00000111111001";
        ram[30] = "0b11001010000011";
        ram[31] = "0b00000001001001";


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


SC_MODULE(LcwtMLP_RFFI_PATCdEe) {


static const unsigned DataWidth = 14;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCdEe_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCdEe) {
meminst = new LcwtMLP_RFFI_PATCdEe_ram("LcwtMLP_RFFI_PATCdEe_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCdEe() {
    delete meminst;
}


};//endmodule
#endif
