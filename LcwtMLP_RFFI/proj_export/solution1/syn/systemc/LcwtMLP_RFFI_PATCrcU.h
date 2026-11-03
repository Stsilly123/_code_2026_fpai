// ==============================================================
// File generated on Thu Oct 22 20:26:04 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCrcU_H__
#define __LcwtMLP_RFFI_PATCrcU_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCrcU_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCrcU_ram) {
        ram[0] = "0b111111100001001";
        ram[1] = "0b000110111001010";
        ram[2] = "0b110101110110001";
        ram[3] = "0b111101000000001";
        ram[4] = "0b110000101111000";
        ram[5] = "0b000111100001110";
        ram[6] = "0b000000010011010";
        ram[7] = "0b001100000000111";
        ram[8] = "0b000001110001001";
        ram[9] = "0b111001100011010";
        ram[10] = "0b110111001100000";
        ram[11] = "0b111100000010011";
        ram[12] = "0b000010001100110";
        ram[13] = "0b000110101100011";
        ram[14] = "0b010000011001001";
        ram[15] = "0b001000001010000";
        ram[16] = "0b111111000001110";
        ram[17] = "0b010001001010000";
        ram[18] = "0b111010101101000";
        ram[19] = "0b111111111001000";
        ram[20] = "0b000100001000111";
        ram[21] = "0b000010111101110";
        ram[22] = "0b000010011010101";
        ram[23] = "0b111110001001101";
        ram[24] = "0b111111000110011";
        ram[25] = "0b000011011111110";
        ram[26] = "0b000011001000110";
        ram[27] = "0b111101101000100";
        ram[28] = "0b000011110011000";
        ram[29] = "0b000011001100100";
        ram[30] = "0b111111101110101";
        ram[31] = "0b000010001101101";


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


SC_MODULE(LcwtMLP_RFFI_PATCrcU) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCrcU_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCrcU) {
meminst = new LcwtMLP_RFFI_PATCrcU_ram("LcwtMLP_RFFI_PATCrcU_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCrcU() {
    delete meminst;
}


};//endmodule
#endif
