-- ==============================================================
-- File generated on Sun Oct 18 16:53:15 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_Vg2b_rom is 
    generic(
             DWIDTH     : integer := 8; 
             AWIDTH     : integer := 8; 
             MEM_SIZE    : integer := 150
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of gap_head_W_HEAD_Vg2b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00011010", 1 => "11001010", 2 => "00000100", 3 => "11110010", 
    4 => "00100001", 5 => "11101101", 6 => "01011010", 7 => "01001010", 
    8 => "11101000", 9 => "00011100", 10 => "00000100", 11 => "11011010", 
    12 => "11111101", 13 => "11100001", 14 => "00010000", 15 => "00110101", 
    16 => "11111011", 17 => "11110101", 18 => "11111001", 19 => "01000100", 
    20 => "01011111", 21 => "00010010", 22 => "10111001", 23 => "11001101", 
    24 => "11111001", 25 => "00011101", 26 => "00001101", 27 => "00111100", 
    28 => "01001000", 29 => "10111101", 30 => "01111010", 31 => "11110100", 
    32 => "11011111", 33 => "00000001", 34 => "11011011", 35 => "11100100", 
    36 => "11111110", 37 => "11011010", 38 => "11000001", 39 => "00000011", 
    40 => "00010101", 41 => "11110001", 42 => "00001100", 43 => "11100110", 
    44 => "00101111", 45 => "11001100", 46 => "11110001", 47 => "00000000", 
    48 => "11000010", 49 => "11101110", 50 => "01111111", 51 => "10100110", 
    52 => "01110011", 53 => "00000100", 54 => "00001100", 55 => "00010001", 
    56 => "00111101", 57 => "11000011", 58 => "11110101", 59 => "11010001", 
    60 => "11101001", 61 => "00100000", 62 => "11000110", 63 => "11100011", 
    64 => "00110111", 65 => "00011110", 66 => "00010001", 67 => "00000101", 
    68 => "11100001", 69 => "01011010", 70 => "01100010", 71 => "00010011", 
    72 => "11101000", 73 => "11010110", 74 => "11010010", 75 => "11100001", 
    76 => "11111110", 77 => "00010111", 78 => "11111111", 79 => "01001011", 
    80 => "11100110", 81 => "00000010", 82 => "00001110", 83 => "11001011", 
    84 => "11010001", 85 => "00100011", 86 => "11111110", 87 => "10111110", 
    88 => "00111111", 89 => "00010100", 90 => "11101011", 91 => "11111101", 
    92 => "10110010", 93 => "01111111", 94 => "00000100", 95 => "00100010", 
    96 => "00001010", 97 => "11100101", 98 => "00000001", 99 => "11001011", 
    100 => "01000010", 101 => "11010010", 102 => "11110001", 103 => "11100110", 
    104 => "00100101", 105 => "00100010", 106 => "00010011", 107 => "11010010", 
    108 => "11101010", 109 => "11111000", 110 => "11101001", 111 => "00001010", 
    112 => "00100101", 113 => "01111111", 114 => "00100010", 115 => "11111010", 
    116 => "11011010", 117 => "00011111", 118 => "01110100", 119 => "00100101", 
    120 => "10100011", 121 => "11111010", 122 => "00011101", 123 => "00011110", 
    124 => "00111111", 125 => "01100101", 126 => "01001100", 127 => "11111010", 
    128 => "00010000", 129 => "11100110", 130 => "00000100", 131 => "11111101", 
    132 => "00100001", 133 => "01111111", 134 => "00000100", 135 => "11100100", 
    136 => "11101110", 137 => "00010100", 138 => "00100011", 139 => "10110111", 
    140 => "11110110", 141 => "00101001", 142 => "11111001", 143 => "10001001", 
    144 => "10111011", 145 => "11110001", 146 => "00111101", 147 => "11111011", 
    148 => "00110011", 149 => "00110100" );


begin 


memory_access_guard_0: process (addr0) 
begin
      addr0_tmp <= addr0;
--synthesis translate_off
      if (CONV_INTEGER(addr0) > mem_size-1) then
           addr0_tmp <= (others => '0');
      else 
           addr0_tmp <= addr0;
      end if;
--synthesis translate_on
end process;

p_rom_access: process (clk)  
begin 
    if (clk'event and clk = '1') then
        if (ce0 = '1') then 
            q0 <= mem(CONV_INTEGER(addr0_tmp)); 
        end if;
    end if;
end process;

end rtl;

Library IEEE;
use IEEE.std_logic_1164.all;

entity gap_head_W_HEAD_Vg2b is
    generic (
        DataWidth : INTEGER := 8;
        AddressRange : INTEGER := 150;
        AddressWidth : INTEGER := 8);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of gap_head_W_HEAD_Vg2b is
    component gap_head_W_HEAD_Vg2b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg2b_rom_U :  component gap_head_W_HEAD_Vg2b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


