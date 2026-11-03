// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCvdy_H__
#define __LcwtMLP_RFFI_PATCvdy_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCvdy_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCvdy_ram) {
        ram[0] = "0b110010111000000";
        ram[1] = "0b111100001101110";
        ram[2] = "0b111011011110011";
        ram[3] = "0b111010111110011";
        ram[4] = "0b110110011011110";
        ram[5] = "0b111001010001001";
        ram[6] = "0b000110100001010";
        ram[7] = "0b000111001100010";
        ram[8] = "0b110100111100111";
        ram[9] = "0b111100110000000";
        ram[10] = "0b001011001010000";
        ram[11] = "0b111001101001010";
        ram[12] = "0b111011011111101";
        ram[13] = "0b000110001001111";
        ram[14] = "0b000110011010110";
        ram[15] = "0b111100001001011";
        ram[16] = "0b110000100010111";
        ram[17] = "0b111011001010110";
        ram[18] = "0b001001000110011";
        ram[19] = "0b000001010101110";
        ram[20] = "0b111011110000011";
        ram[21] = "0b000000000011110";
        ram[22] = "0b000010011001110";
        ram[23] = "0b110010000111111";
        ram[24] = "0b111011101101100";
        ram[25] = "0b000011101111001";
        ram[26] = "0b111010010000001";
        ram[27] = "0b100011010001100";
        ram[28] = "0b000000010100011";
        ram[29] = "0b000001110001001";
        ram[30] = "0b110010101001101";
        ram[31] = "0b110111001110100";


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


SC_MODULE(LcwtMLP_RFFI_PATCvdy) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCvdy_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCvdy) {
meminst = new LcwtMLP_RFFI_PATCvdy_ram("LcwtMLP_RFFI_PATCvdy_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCvdy() {
    delete meminst;
}


};//endmodule
#endif
