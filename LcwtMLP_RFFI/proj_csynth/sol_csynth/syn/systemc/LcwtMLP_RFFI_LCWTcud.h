// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_LCWTcud_H__
#define __LcwtMLP_RFFI_LCWTcud_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_LCWTcud_ram : public sc_core::sc_module {

  static const unsigned DataWidth = 15;
  static const unsigned AddressRange = 256;
  static const unsigned AddressWidth = 8;

//latency = 1
//input_reg = 1
//output_reg = 0
sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in <sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in <sc_lv<AddressWidth> > address1;
sc_core::sc_in <sc_logic> ce1;
sc_core::sc_out <sc_lv<DataWidth> > q1;
sc_core::sc_in <sc_lv<AddressWidth> > address2;
sc_core::sc_in <sc_logic> ce2;
sc_core::sc_out <sc_lv<DataWidth> > q2;
sc_core::sc_in <sc_lv<AddressWidth> > address3;
sc_core::sc_in <sc_logic> ce3;
sc_core::sc_out <sc_lv<DataWidth> > q3;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


sc_lv<DataWidth> ram[AddressRange];


   SC_CTOR(LcwtMLP_RFFI_LCWTcud_ram) {
        ram[0] = "0b000001011010111";
        ram[1] = "0b110110100101100";
        ram[2] = "0b111011110011111";
        ram[3] = "0b000010010111011";
        ram[4] = "0b000010111010101";
        ram[5] = "0b000100100001000";
        ram[6] = "0b111101110100001";
        ram[7] = "0b111111100011110";
        ram[8] = "0b000010111111110";
        ram[9] = "0b000001111000101";
        ram[10] = "0b111100111110001";
        ram[11] = "0b111111111001101";
        ram[12] = "0b000100101000010";
        ram[13] = "0b111111010000000";
        ram[14] = "0b000010111011000";
        ram[15] = "0b111001111110010";
        ram[16] = "0b111011001100100";
        ram[17] = "0b001001100101110";
        ram[18] = "0b111011000000101";
        ram[19] = "0b111100001111001";
        ram[20] = "0b111011110001010";
        ram[21] = "0b111111100100000";
        ram[22] = "0b111011001111111";
        ram[23] = "0b111101100100110";
        ram[24] = "0b111011001111111";
        ram[25] = "0b111110011001110";
        ram[26] = "0b001001010001000";
        ram[27] = "0b000011011101110";
        ram[28] = "0b110110000000001";
        ram[29] = "0b000010100110010";
        ram[30] = "0b111011111111001";
        ram[31] = "0b111111110001010";
        ram[32] = "0b111010000100110";
        ram[33] = "0b000001011111111";
        ram[34] = "0b110010100101101";
        ram[35] = "0b110110000000111";
        ram[36] = "0b111110110001110";
        ram[37] = "0b111110001111011";
        ram[38] = "0b111101011001010";
        ram[39] = "0b111110101100010";
        ram[40] = "0b000001011000000";
        ram[41] = "0b111010110000001";
        ram[42] = "0b110101111001000";
        ram[43] = "0b101111011100001";
        ram[44] = "0b000011101111101";
        ram[45] = "0b111001010011000";
        ram[46] = "0b111100011100110";
        ram[47] = "0b000001111011000";
        ram[48] = "0b000111010100111";
        ram[49] = "0b000010100010011";
        ram[50] = "0b111011011111001";
        ram[51] = "0b000100010100100";
        ram[52] = "0b111010011110110";
        ram[53] = "0b111100001011100";
        ram[54] = "0b111011111100011";
        ram[55] = "0b000010100111101";
        ram[56] = "0b000011110011100";
        ram[57] = "0b000100111000110";
        ram[58] = "0b000010110101111";
        ram[59] = "0b001011001101100";
        ram[60] = "0b000100011100011";
        ram[61] = "0b110101000010111";
        ram[62] = "0b111111111001000";
        ram[63] = "0b000100110111010";
        ram[64] = "0b111111000100011";
        ram[65] = "0b000010111011001";
        ram[66] = "0b111011110010111";
        ram[67] = "0b000001001000010";
        ram[68] = "0b000101011110011";
        ram[69] = "0b000010100100010";
        ram[70] = "0b000001000101111";
        ram[71] = "0b000001011011100";
        ram[72] = "0b000001100110101";
        ram[73] = "0b111101100101011";
        ram[74] = "0b111100001011010";
        ram[75] = "0b000101011010101";
        ram[76] = "0b000101001101111";
        ram[77] = "0b111001110111001";
        ram[78] = "0b000100100111001";
        ram[79] = "0b111111000100100";
        ram[80] = "0b111010101111010";
        ram[81] = "0b111010000010111";
        ram[82] = "0b110111110101010";
        ram[83] = "0b111001001111010";
        ram[84] = "0b111110011110011";
        ram[85] = "0b000101010100000";
        ram[86] = "0b000100011010111";
        ram[87] = "0b000001010110010";
        ram[88] = "0b111111110101100";
        ram[89] = "0b111011011011011";
        ram[90] = "0b001001001110011";
        ram[91] = "0b000000001000000";
        ram[92] = "0b000010000101010";
        ram[93] = "0b111100011111011";
        ram[94] = "0b110110010110101";
        ram[95] = "0b111000000011100";
        ram[96] = "0b000101110000111";
        ram[97] = "0b000010111110010";
        ram[98] = "0b111111111011101";
        ram[99] = "0b000111011100001";
        ram[100] = "0b111010010001100";
        ram[101] = "0b111000001011111";
        ram[102] = "0b000100000010010";
        ram[103] = "0b000101001111110";
        ram[104] = "0b111111101100110";
        ram[105] = "0b110111101101010";
        ram[106] = "0b001100010011100";
        ram[107] = "0b111011101110001";
        ram[108] = "0b111100100110111";
        ram[109] = "0b000001011101011";
        ram[110] = "0b000101101010010";
        ram[111] = "0b000000000011100";
        ram[112] = "0b000000001101001";
        ram[113] = "0b000110010111010";
        ram[114] = "0b000010101100001";
        ram[115] = "0b110100011111001";
        ram[116] = "0b000111000110100";
        ram[117] = "0b111001010001010";
        ram[118] = "0b111110010111110";
        ram[119] = "0b111001011111000";
        ram[120] = "0b111100001101010";
        ram[121] = "0b110111000110111";
        ram[122] = "0b000000011111010";
        ram[123] = "0b000000101111100";
        ram[124] = "0b001010000001001";
        ram[125] = "0b111101100000111";
        ram[126] = "0b000001101001110";
        ram[127] = "0b000000110110011";
        ram[128] = "0b111110000101110";
        ram[129] = "0b111110101010001";
        ram[130] = "0b111111101001111";
        ram[131] = "0b111100010001110";
        ram[132] = "0b000011000100000";
        ram[133] = "0b111000110010111";
        ram[134] = "0b111101100000101";
        ram[135] = "0b000010011011110";
        ram[136] = "0b000001100110101";
        ram[137] = "0b000011101111101";
        ram[138] = "0b111101011010101";
        ram[139] = "0b111100101010101";
        ram[140] = "0b000010101011110";
        ram[141] = "0b000101111100000";
        ram[142] = "0b001100000001100";
        ram[143] = "0b111001110100100";
        ram[144] = "0b111100101101010";
        ram[145] = "0b000001100011101";
        ram[146] = "0b000101111110000";
        ram[147] = "0b000011011001000";
        ram[148] = "0b110111011101100";
        ram[149] = "0b111111101111101";
        ram[150] = "0b111110010011011";
        ram[151] = "0b000010110100010";
        ram[152] = "0b111100000000111";
        ram[153] = "0b111101011001101";
        ram[154] = "0b000000101011101";
        ram[155] = "0b000010000101110";
        ram[156] = "0b000011011100000";
        ram[157] = "0b111101011000010";
        ram[158] = "0b001001100101111";
        ram[159] = "0b000110111011011";
        ram[160] = "0b111100010101000";
        ram[161] = "0b000001100111001";
        ram[162] = "0b000001001001010";
        ram[163] = "0b111001010100101";
        ram[164] = "0b111101110101100";
        ram[165] = "0b111101110100100";
        ram[166] = "0b000010011001000";
        ram[167] = "0b110001100010011";
        ram[168] = "0b111110110011111";
        ram[169] = "0b000101110000110";
        ram[170] = "0b001010001111010";
        ram[171] = "0b111000000111000";
        ram[172] = "0b000111001000111";
        ram[173] = "0b000000000010100";
        ram[174] = "0b000001100001001";
        ram[175] = "0b000110001110100";
        ram[176] = "0b001010101110011";
        ram[177] = "0b000010011101110";
        ram[178] = "0b111100011000000";
        ram[179] = "0b111001101011100";
        ram[180] = "0b110110100010101";
        ram[181] = "0b000001001001111";
        ram[182] = "0b000000001110110";
        ram[183] = "0b000100000101000";
        ram[184] = "0b000010001101011";
        ram[185] = "0b000001011101110";
        ram[186] = "0b110111110011110";
        ram[187] = "0b000100011101100";
        ram[188] = "0b111010010100001";
        ram[189] = "0b111001101100111";
        ram[190] = "0b101011111011011";
        ram[191] = "0b111011101101001";
        ram[192] = "0b000001010101001";
        ram[193] = "0b000111000000001";
        ram[194] = "0b111001011001001";
        ram[195] = "0b111110101011000";
        ram[196] = "0b000100110010011";
        ram[197] = "0b000010100001111";
        ram[198] = "0b000010100000110";
        ram[199] = "0b111011000011011";
        ram[200] = "0b111101001010011";
        ram[201] = "0b111101010001110";
        ram[202] = "0b000001101011001";
        ram[203] = "0b111111010010000";
        ram[204] = "0b001001110011000";
        ram[205] = "0b000011111000001";
        ram[206] = "0b111111100110010";
        ram[207] = "0b000010101111111";
        ram[208] = "0b000011001011000";
        ram[209] = "0b000100010101100";
        ram[210] = "0b000101100010111";
        ram[211] = "0b111011010001110";
        ram[212] = "0b111110101110110";
        ram[213] = "0b000101000100111";
        ram[214] = "0b111001001100011";
        ram[215] = "0b111100011001011";
        ram[216] = "0b111111011100001";
        ram[217] = "0b111110000001110";
        ram[218] = "0b000010001001010";
        ram[219] = "0b111101101011110";
        ram[220] = "0b111101111000110";
        ram[221] = "0b000100001001000";
        ram[222] = "0b111101110110001";
        ram[223] = "0b000001111111000";
        ram[224] = "0b111111110010110";
        ram[225] = "0b000010101111110";
        ram[226] = "0b001001000011111";
        ram[227] = "0b001000011010100";
        ram[228] = "0b000011000101111";
        ram[229] = "0b000010100101011";
        ram[230] = "0b000011000111111";
        ram[231] = "0b000000001010110";
        ram[232] = "0b000100011011101";
        ram[233] = "0b000011100010010";
        ram[234] = "0b000000100001001";
        ram[235] = "0b000011001001001";
        ram[236] = "0b110111101011010";
        ram[237] = "0b000110111101110";
        ram[238] = "0b111110001010111";
        ram[239] = "0b000000001111110";
        ram[240] = "0b111101110100100";
        ram[241] = "0b000101000101100";
        ram[242] = "0b000111000110110";
        ram[243] = "0b000010000101000";
        ram[244] = "0b111101010110110";
        ram[245] = "0b000011011101111";
        ram[246] = "0b111111001010101";
        ram[247] = "0b111111110001101";
        ram[248] = "0b000001110110111";
        ram[249] = "0b000111111110110";
        ram[250] = "0b000010001100010";
        ram[251] = "0b000001010101110";
        ram[252] = "0b111101100000111";
        ram[253] = "0b110110011101000";
        ram[254] = "0b000111101110101";
        ram[255] = "0b111111011101001";


SC_METHOD(prc_write_0);
  sensitive<<clk.pos();


SC_METHOD(prc_write_1);
  sensitive<<clk.pos();


SC_METHOD(prc_write_2);
  sensitive<<clk.pos();


SC_METHOD(prc_write_3);
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


void prc_write_1()
{
    if (ce1.read() == sc_dt::Log_1) 
    {
            if(address1.read().is_01() && address1.read().to_uint()<AddressRange)
              q1 = ram[address1.read().to_uint()];
            else
              q1 = sc_lv<DataWidth>();
    }
}


void prc_write_2()
{
    if (ce2.read() == sc_dt::Log_1) 
    {
            if(address2.read().is_01() && address2.read().to_uint()<AddressRange)
              q2 = ram[address2.read().to_uint()];
            else
              q2 = sc_lv<DataWidth>();
    }
}


void prc_write_3()
{
    if (ce3.read() == sc_dt::Log_1) 
    {
            if(address3.read().is_01() && address3.read().to_uint()<AddressRange)
              q3 = ram[address3.read().to_uint()];
            else
              q3 = sc_lv<DataWidth>();
    }
}


}; //endmodule


SC_MODULE(LcwtMLP_RFFI_LCWTcud) {


static const unsigned DataWidth = 15;
static const unsigned AddressRange = 256;
static const unsigned AddressWidth = 8;

sc_core::sc_in <sc_lv<AddressWidth> > address0;
sc_core::sc_in<sc_logic> ce0;
sc_core::sc_out <sc_lv<DataWidth> > q0;
sc_core::sc_in <sc_lv<AddressWidth> > address1;
sc_core::sc_in<sc_logic> ce1;
sc_core::sc_out <sc_lv<DataWidth> > q1;
sc_core::sc_in <sc_lv<AddressWidth> > address2;
sc_core::sc_in<sc_logic> ce2;
sc_core::sc_out <sc_lv<DataWidth> > q2;
sc_core::sc_in <sc_lv<AddressWidth> > address3;
sc_core::sc_in<sc_logic> ce3;
sc_core::sc_out <sc_lv<DataWidth> > q3;
sc_core::sc_in<sc_logic> reset;
sc_core::sc_in<bool> clk;


LcwtMLP_RFFI_LCWTcud_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_LCWTcud) {
meminst = new LcwtMLP_RFFI_LCWTcud_ram("LcwtMLP_RFFI_LCWTcud_ram");
meminst->address0(address0);
meminst->ce0(ce0);
meminst->q0(q0);

meminst->address1(address1);
meminst->ce1(ce1);
meminst->q1(q1);

meminst->address2(address2);
meminst->ce2(ce2);
meminst->q2(q2);

meminst->address3(address3);
meminst->ce3(ce3);
meminst->q3(q3);

meminst->reset(reset);
meminst->clk(clk);
}
~LcwtMLP_RFFI_LCWTcud() {
    delete meminst;
}


};//endmodule
#endif
