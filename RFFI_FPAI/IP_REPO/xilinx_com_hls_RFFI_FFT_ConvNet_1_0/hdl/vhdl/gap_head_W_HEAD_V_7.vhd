-- ==============================================================
-- File generated on Sun Oct 18 16:53:14 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_V_7_rom is 
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


architecture rtl of gap_head_W_HEAD_V_7_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110010", 1 => "00011110", 2 => "11101111", 3 => "11010001", 
    4 => "01100111", 5 => "01011111", 6 => "00100001", 7 => "01011100", 
    8 => "11110000", 9 => "11101011", 10 => "01000011", 11 => "00010011", 
    12 => "00101110", 13 => "00100001", 14 => "11111010", 15 => "01011010", 
    16 => "00010010", 17 => "00001110", 18 => "00110001", 19 => "11010011", 
    20 => "11010110", 21 => "11111001", 22 => "11010100", 23 => "11001010", 
    24 => "10000001", 25 => "00100011", 26 => "01000100", 27 => "11100111", 
    28 => "00000100", 29 => "10001100", 30 => "11100110", 31 => "00001001", 
    32 => "11101001", 33 => "11110100", 34 => "00001111", 35 => "11011100", 
    36 => "11110010", 37 => "11010010", 38 => "01000111", 39 => "11011111", 
    40 => "11101110", 41 => "00011100", 42 => "11010011", 43 => "01001111", 
    44 => "11100000", 45 => "00110110", 46 => "00101100", 47 => "11111000", 
    48 => "11000101", 49 => "10100101", 50 => "01001101", 51 => "11011101", 
    52 => "00101001", 53 => "11011000", 54 => "11100000", 55 => "11110000", 
    56 => "11000001", 57 => "01100110", 58 => "11101101", 59 => "00001001", 
    60 => "11110111", 61 => "11111011", 62 => "11000010", 63 => "00101000", 
    64 => "11011111", 65 => "00101001", 66 => "11000100", 67 => "11010111", 
    68 => "00011011", 69 => "11110011", 70 => "11000100", 71 => "00000000", 
    72 => "10110101", 73 => "00000010", 74 => "11110011", 75 => "10110010", 
    76 => "00010101", 77 => "00010011", 78 => "11110111", 79 => "00010001", 
    80 => "11101100", 81 => "00000011", 82 => "00100101", 83 => "00100011", 
    84 => "10000011", 85 => "11111001", 86 => "11100110", 87 => "11001101", 
    88 => "11011110", 89 => "00011001", 90 => "00001000", 91 => "00110011", 
    92 => "00001101", 93 => "00011011", 94 => "11111110", 95 => "00000011", 
    96 => "11111010", 97 => "11111011", 98 => "01111111", 99 => "00010000", 
    100 => "01001010", 101 => "00101110", 102 => "00011110", 103 => "00010000", 
    104 => "10101111", 105 => "11101110", 106 => "11000101", 107 => "11110110", 
    108 => "00011101", 109 => "11001010", 110 => "11101101", 111 => "11111111", 
    112 => "11010011", 113 => "00010011", 114 => "00010110", 115 => "11000111", 
    116 => "11100001", 117 => "00001101", 118 => "11101111", 119 => "11111111", 
    120 => "11111010", 121 => "11101111", 122 => "00101111", 123 => "00111101", 
    124 => "00001000", 125 => "11110111", 126 => "11111001", 127 => "00011101", 
    128 => "11010110", 129 => "01000101", 130 => "01111111", 131 => "11111000", 
    132 => "00010101", 133 => "00101110", 134 => "11111110", 135 => "00011100", 
    136 => "11010101", 137 => "11010000", 138 => "11100101", 139 => "01001101", 
    140 => "11011010", 141 => "11110111", 142 => "11110101", 143 => "01010000", 
    144 => "00110001", 145 => "00100001", 146 => "11001101", 147 => "11100010", 
    148 to 149=> "01011101" );


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

entity gap_head_W_HEAD_V_7 is
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

architecture arch of gap_head_W_HEAD_V_7 is
    component gap_head_W_HEAD_V_7_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_V_7_rom_U :  component gap_head_W_HEAD_V_7_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


