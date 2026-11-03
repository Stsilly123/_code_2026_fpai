// ==============================================================
// File generated on Thu Oct 22 20:22:32 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __LcwtMLP_RFFI_LCWTbkb_H__
#define __LcwtMLP_RFFI_LCWTbkb_H__


#include <systemc>
using namespace sc_core;
using namespace sc_dt;




#include <iostream>
#include <fstream>

struct LcwtMLP_RFFI_LCWTbkb_ram : public sc_core::sc_module {

  static const unsigned DataWidth = 14;
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


   SC_CTOR(LcwtMLP_RFFI_LCWTbkb_ram) {
        ram[0] = "0b00000011000101";
        ram[1] = "0b11011001100001";
        ram[2] = "0b00001010000111";
        ram[3] = "0b00110000110100";
        ram[4] = "0b00110011101101";
        ram[5] = "0b00111100110100";
        ram[6] = "0b00100011001011";
        ram[7] = "0b11010100010110";
        ram[8] = "0b11110001110010";
        ram[9] = "0b01000001011000";
        ram[10] = "0b00010011011010";
        ram[11] = "0b00011011011001";
        ram[12] = "0b00100010010110";
        ram[13] = "0b11110010110101";
        ram[14] = "0b00001010000010";
        ram[15] = "0b00101001000100";
        ram[16] = "0b10111000010010";
        ram[17] = "0b11001010010010";
        ram[18] = "0b00001010011100";
        ram[19] = "0b11110101111111";
        ram[20] = "0b00001001000111";
        ram[21] = "0b00000010011011";
        ram[22] = "0b11010011110001";
        ram[23] = "0b11010000101011";
        ram[24] = "0b00101110010001";
        ram[25] = "0b00001000110000";
        ram[26] = "0b11110101001001";
        ram[27] = "0b00101000100001";
        ram[28] = "0b00011010111111";
        ram[29] = "0b00101011110000";
        ram[30] = "0b00110101001110";
        ram[31] = "0b00010100111101";
        ram[32] = "0b00010111100110";
        ram[33] = "0b00011000100101";
        ram[34] = "0b11100111110111";
        ram[35] = "0b10100011101000";
        ram[36] = "0b00100010000110";
        ram[37] = "0b11111110001110";
        ram[38] = "0b11100011000001";
        ram[39] = "0b11110010100110";
        ram[40] = "0b11111101100001";
        ram[41] = "0b11111111000101";
        ram[42] = "0b00000001101001";
        ram[43] = "0b00010110000111";
        ram[44] = "0b11000011100100";
        ram[45] = "0b10000101000110";
        ram[46] = "0b11110010111111";
        ram[47] = "0b00110000111001";
        ram[48] = "0b10101000000011";
        ram[49] = "0b00010011101001";
        ram[50] = "0b11100100100101";
        ram[51] = "0b00000010100110";
        ram[52] = "0b00100111000101";
        ram[53] = "0b11011000001000";
        ram[54] = "0b00010101001101";
        ram[55] = "0b00100001111001";
        ram[56] = "0b11011011000101";
        ram[57] = "0b10111001111111";
        ram[58] = "0b11000111000101";
        ram[59] = "0b10101011010101";
        ram[60] = "0b10001100100001";
        ram[61] = "0b11001101111100";
        ram[62] = "0b10101000111010";
        ram[63] = "0b11000110100001";
        ram[64] = "0b11110101110110";
        ram[65] = "0b00100111110010";
        ram[66] = "0b00111101000111";
        ram[67] = "0b00011101011011";
        ram[68] = "0b11010011010010";
        ram[69] = "0b11011101000110";
        ram[70] = "0b11100000000010";
        ram[71] = "0b11101001010001";
        ram[72] = "0b11011010101011";
        ram[73] = "0b11010101011000";
        ram[74] = "0b10101100010010";
        ram[75] = "0b11001111001110";
        ram[76] = "0b00000101101000";
        ram[77] = "0b11000100111011";
        ram[78] = "0b11011000011111";
        ram[79] = "0b11011101001001";
        ram[80] = "0b11011111110011";
        ram[81] = "0b11110111100111";
        ram[82] = "0b11111011101111";
        ram[83] = "0b11100101001000";
        ram[84] = "0b11111000000010";
        ram[85] = "0b11111001111100";
        ram[86] = "0b11100001101101";
        ram[87] = "0b00010110101110";
        ram[88] = "0b11100100001000";
        ram[89] = "0b11000001001001";
        ram[90] = "0b00001010100001";
        ram[91] = "0b00110001101000";
        ram[92] = "0b00011001010101";
        ram[93] = "0b11101111110001";
        ram[94] = "0b11101101111111";
        ram[95] = "0b00100001100101";
        ram[96] = "0b11100111001110";
        ram[97] = "0b11001010001110";
        ram[98] = "0b11100011111101";
        ram[99] = "0b11111111011111";
        ram[100] = "0b11110101000010";
        ram[101] = "0b11011000001011";
        ram[102] = "0b11011010010101";
        ram[103] = "0b11101010100001";
        ram[104] = "0b01000100110010";
        ram[105] = "0b00010100001001";
        ram[106] = "0b00000110101000";
        ram[107] = "0b00011111110010";
        ram[108] = "0b11001000110100";
        ram[109] = "0b11110000101011";
        ram[110] = "0b11011100110110";
        ram[111] = "0b11101111110110";
        ram[112] = "0b10110100101000";
        ram[113] = "0b10110000100100";
        ram[114] = "0b00010001001010";
        ram[115] = "0b11001110100001";
        ram[116] = "0b11111101011111";
        ram[117] = "0b10100001110001";
        ram[118] = "0b00000010001110";
        ram[119] = "0b11011101001010";
        ram[120] = "0b11001100000100";
        ram[121] = "0b11100011011010";
        ram[122] = "0b11101100101011";
        ram[123] = "0b01000110100101";
        ram[124] = "0b11010001000000";
        ram[125] = "0b01000101110111";
        ram[126] = "0b00010110011000";
        ram[127] = "0b00010100001001";
        ram[128] = "0b00001101000011";
        ram[129] = "0b00000111000011";
        ram[130] = "0b11110100011111";
        ram[131] = "0b11101111110101";
        ram[132] = "0b11000100111000";
        ram[133] = "0b11010001101011";
        ram[134] = "0b11011001001011";
        ram[135] = "0b11110111001100";
        ram[136] = "0b00010100101111";
        ram[137] = "0b11110001011001";
        ram[138] = "0b11001010001111";
        ram[139] = "0b11000100010100";
        ram[140] = "0b11000001111110";
        ram[141] = "0b11101100110010";
        ram[142] = "0b11110110110010";
        ram[143] = "0b11110011010001";
        ram[144] = "0b11101100000000";
        ram[145] = "0b11001100010100";
        ram[146] = "0b11110111010101";
        ram[147] = "0b11101010011010";
        ram[148] = "0b11011010000101";
        ram[149] = "0b11111100011101";
        ram[150] = "0b00000100101110";
        ram[151] = "0b00110100111111";
        ram[152] = "0b11110100000011";
        ram[153] = "0b10100100001010";
        ram[154] = "0b11110010001011";
        ram[155] = "0b00000001101111";
        ram[156] = "0b01010010010110";
        ram[157] = "0b00001011000011";
        ram[158] = "0b11101111010010";
        ram[159] = "0b00100000100011";
        ram[160] = "0b11001000111001";
        ram[161] = "0b10110111001000";
        ram[162] = "0b11000000001011";
        ram[163] = "0b10010101110001";
        ram[164] = "0b11010111110110";
        ram[165] = "0b00100100100001";
        ram[166] = "0b00010101011111";
        ram[167] = "0b01001011111110";
        ram[168] = "0b00011010100111";
        ram[169] = "0b11100011100000";
        ram[170] = "0b01001000001100";
        ram[171] = "0b00111011101010";
        ram[172] = "0b11110110101001";
        ram[173] = "0b00110010110001";
        ram[174] = "0b11001100000010";
        ram[175] = "0b10100111110110";
        ram[176] = "0b00001011001011";
        ram[177] = "0b00001001100110";
        ram[178] = "0b11111001111101";
        ram[179] = "0b11001110100100";
        ram[180] = "0b11000110110001";
        ram[181] = "0b11100111011000";
        ram[182] = "0b11001100111001";
        ram[183] = "0b11011000001000";
        ram[184] = "0b00001001101010";
        ram[185] = "0b00001101011011";
        ram[186] = "0b00000100110011";
        ram[187] = "0b00111101001010";
        ram[188] = "0b11101101011111";
        ram[189] = "0b11010110011001";
        ram[190] = "0b00000110111011";
        ram[191] = "0b11110011111110";
        ram[192] = "0b11111111010011";
        ram[193] = "0b11100001111110";
        ram[194] = "0b11100010001001";
        ram[195] = "0b11011111110010";
        ram[196] = "0b00010110110101";
        ram[197] = "0b01001111100100";
        ram[198] = "0b00011100001000";
        ram[199] = "0b11011010110101";
        ram[200] = "0b11011111111110";
        ram[201] = "0b11101101101000";
        ram[202] = "0b00000110010101";
        ram[203] = "0b11011011011111";
        ram[204] = "0b00100010011100";
        ram[205] = "0b01010110111100";
        ram[206] = "0b00100010111111";
        ram[207] = "0b11000101011100";
        ram[208] = "0b00001111110000";
        ram[209] = "0b11011001111001";
        ram[210] = "0b11111011010101";
        ram[211] = "0b11111110001111";
        ram[212] = "0b11101011011101";
        ram[213] = "0b11110101001000";
        ram[214] = "0b10110100110001";
        ram[215] = "0b00000100010001";
        ram[216] = "0b00011110000011";
        ram[217] = "0b00011000001011";
        ram[218] = "0b00011110101000";
        ram[219] = "0b00100001011011";
        ram[220] = "0b11100011110101";
        ram[221] = "0b00110110000110";
        ram[222] = "0b11110010101111";
        ram[223] = "0b00000011000111";
        ram[224] = "0b00110000010000";
        ram[225] = "0b00100010110011";
        ram[226] = "0b11011011110111";
        ram[227] = "0b01000000101001";
        ram[228] = "0b00011010011100";
        ram[229] = "0b00011001011000";
        ram[230] = "0b00111100011110";
        ram[231] = "0b11110100111011";
        ram[232] = "0b11011110010100";
        ram[233] = "0b11010100001000";
        ram[234] = "0b00001010100011";
        ram[235] = "0b11001010010101";
        ram[236] = "0b01001001000011";
        ram[237] = "0b01000110000000";
        ram[238] = "0b11001100011001";
        ram[239] = "0b00010111010000";
        ram[240] = "0b11110111110111";
        ram[241] = "0b00001001111011";
        ram[242] = "0b00001111111110";
        ram[243] = "0b11111000011110";
        ram[244] = "0b01001011001100";
        ram[245] = "0b00000101011000";
        ram[246] = "0b00001110000001";
        ram[247] = "0b00111101111110";
        ram[248] = "0b11100001010010";
        ram[249] = "0b00000000100001";
        ram[250] = "0b11101110000001";
        ram[251] = "0b11101000110011";
        ram[252] = "0b00001010011010";
        ram[253] = "0b11111100110001";
        ram[254] = "0b11101000100101";
        ram[255] = "0b11101110000111";


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


SC_MODULE(LcwtMLP_RFFI_LCWTbkb) {


static const unsigned DataWidth = 14;
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


LcwtMLP_RFFI_LCWTbkb_ram* meminst;


SC_CTOR(LcwtMLP_RFFI_LCWTbkb) {
meminst = new LcwtMLP_RFFI_LCWTbkb_ram("LcwtMLP_RFFI_LCWTbkb_ram");
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
~LcwtMLP_RFFI_LCWTbkb() {
    delete meminst;
}


};//endmodule
#endif
