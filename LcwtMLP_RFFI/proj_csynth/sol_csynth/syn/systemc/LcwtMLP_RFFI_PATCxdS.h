// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_PATCxdS_H__
#define __LcwtMLP_RFFI_PATCxdS_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_PATCxdS_ram : public sc_core::sc_module {

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


   SC_CTOR(LcwtMLP_RFFI_PATCxdS_ram) {
        ram[0] = "0b001100001110001";
        ram[1] = "0b111110000100111";
        ram[2] = "0b110010000001111";
        ram[3] = "0b101101001010011";
        ram[4] = "0b110111110101111";
        ram[5] = "0b011010110110000";
        ram[6] = "0b000000111011000";
        ram[7] = "0b110000010101110";
        ram[8] = "0b111010000100010";
        ram[9] = "0b111110111100110";
        ram[10] = "0b001001101110110";
        ram[11] = "0b101111110101011";
        ram[12] = "0b001001110100111";
        ram[13] = "0b111101110001111";
        ram[14] = "0b110011110001010";
        ram[15] = "0b111001101000101";
        ram[16] = "0b111110001010001";
        ram[17] = "0b001000111100110";
        ram[18] = "0b001000010100010";
        ram[19] = "0b000000011010011";
        ram[20] = "0b000110111111100";
        ram[21] = "0b111010001111111";
        ram[22] = "0b000000111110010";
        ram[23] = "0b111100111010110";
        ram[24] = "0b110110111000100";
        ram[25] = "0b100010101001011";
        ram[26] = "0b000000000000110";
        ram[27] = "0b000111011101101";
        ram[28] = "0b111111101100111";
        ram[29] = "0b111000000010111";
        ram[30] = "0b001111110000001";
        ram[31] = "0b000011100001100";


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


SC_MODULE(LcwtMLP_RFFI_PATCxdS) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 32;
static const unsigned AddressWidth = 5;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_PATCxdS_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_PATCxdS) {
meminst = new LcwtMLP_RFFI_PATCxdS_ram("LcwtMLP_RFFI_PATCxdS_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_PATCxdS() {
    delete meminst;
}


};//endmodule
#endif
