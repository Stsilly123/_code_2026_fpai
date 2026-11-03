-- ==============================================================
-- File generated on Sun Oct 18 16:53:16 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_Vhhb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhhb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10001001", 1 => "00010000", 2 => "00110111", 3 => "11011100", 
    4 => "01000011", 5 => "01111111", 6 => "01010110", 7 => "01001000", 
    8 => "00001101", 9 => "10000001", 10 => "00110000", 11 => "01001111", 
    12 => "01001000", 13 => "11110000", 14 => "01000000", 15 => "11111111", 
    16 => "01000101", 17 => "11100111", 18 => "11000101", 19 => "11100001", 
    20 => "11000001", 21 => "00000001", 22 => "00101010", 23 => "11010101", 
    24 => "00010000", 25 => "11100011", 26 => "00011011", 27 => "11101111", 
    28 => "00111110", 29 => "00101110", 30 => "00110000", 31 => "11001110", 
    32 => "11101110", 33 => "11000010", 34 => "11001001", 35 => "00101111", 
    36 => "11111110", 37 => "00010001", 38 => "11110111", 39 => "00011100", 
    40 => "11000111", 41 => "11111111", 42 => "01000010", 43 => "01000110", 
    44 => "11100111", 45 => "11100011", 46 => "01001001", 47 => "00110101", 
    48 => "11011100", 49 => "11110001", 50 => "00001010", 51 => "00001101", 
    52 => "00000010", 53 => "11001001", 54 => "11110101", 55 => "00101010", 
    56 => "11100100", 57 => "11101001", 58 => "11011001", 59 => "11100011", 
    60 => "11100100", 61 => "00011000", 62 => "00110001", 63 => "11110100", 
    64 => "10100011", 65 => "11100110", 66 => "11011010", 67 => "10100110", 
    68 => "00010100", 69 => "11010101", 70 => "00110011", 71 => "00000001", 
    72 => "11101010", 73 => "11011011", 74 => "11010111", 75 => "01010010", 
    76 => "11111100", 77 => "01111111", 78 to 79=> "11110000", 80 => "11111111", 
    81 => "00001010", 82 => "10111010", 83 => "00000011", 84 => "11111001", 
    85 => "00000000", 86 => "11110111", 87 => "00000100", 88 => "10100011", 
    89 => "00000111", 90 => "11000111", 91 => "11100011", 92 => "00111000", 
    93 => "10111010", 94 => "11111010", 95 => "10111101", 96 => "01111111", 
    97 => "10110011", 98 => "11111110", 99 => "01000001", 100 => "01000110", 
    101 => "00100111", 102 => "00011100", 103 => "00100000", 104 => "11000111", 
    105 => "11000011", 106 => "01111011", 107 => "00010111", 108 => "00110011", 
    109 => "00001101", 110 => "00011101", 111 => "11011111", 112 => "11100001", 
    113 => "11000110", 114 => "01010101", 115 => "11101101", 116 => "11011010", 
    117 => "11110100", 118 => "00001001", 119 => "01110110", 120 => "11011001", 
    121 => "00011000", 122 => "11110000", 123 => "00101010", 124 => "01001011", 
    125 => "00001011", 126 => "11001101", 127 => "00001110", 128 => "11010000", 
    129 => "11100111", 130 => "00111000", 131 => "10100010", 132 => "01000001", 
    133 => "11101100", 134 => "00111111", 135 => "01011100", 136 => "11011011", 
    137 => "11110101", 138 => "11111001", 139 => "01000000", 140 => "11111101", 
    141 => "00000110", 142 => "00111011", 143 => "00001000", 144 => "10110110", 
    145 => "01111111", 146 => "00111010", 147 => "00000011", 148 => "01000100", 
    149 => "00100101" );


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

entity gap_head_W_HEAD_Vhhb is
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

architecture arch of gap_head_W_HEAD_Vhhb is
    component gap_head_W_HEAD_Vhhb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhhb_rom_U :  component gap_head_W_HEAD_Vhhb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


