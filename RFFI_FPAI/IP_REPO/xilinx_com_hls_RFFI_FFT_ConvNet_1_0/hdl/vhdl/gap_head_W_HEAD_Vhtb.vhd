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

entity gap_head_W_HEAD_Vhtb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhtb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010110", 1 => "10110100", 2 => "10101011", 3 => "11110011", 
    4 => "10101010", 5 => "00000010", 6 => "01100010", 7 => "01111111", 
    8 => "00000100", 9 => "10111100", 10 => "11101100", 11 => "11110101", 
    12 => "11010101", 13 => "00100110", 14 => "01000110", 15 => "11110010", 
    16 => "01001011", 17 => "00001111", 18 => "11110000", 19 => "11100100", 
    20 => "01100010", 21 => "11101101", 22 => "11100010", 23 => "00100101", 
    24 => "11101111", 25 => "00110110", 26 => "01010100", 27 => "01000101", 
    28 => "00100110", 29 => "11111100", 30 => "00111011", 31 => "00000011", 
    32 => "11110100", 33 => "00110110", 34 => "00011000", 35 => "10110011", 
    36 => "11101100", 37 => "11111010", 38 => "11011111", 39 => "11110111", 
    40 => "11000100", 41 => "00100100", 42 => "11101110", 43 => "11100110", 
    44 => "11101001", 45 => "11011111", 46 => "01001011", 47 => "00011111", 
    48 => "01010111", 49 => "00000011", 50 => "11101101", 51 => "11110100", 
    52 => "00110110", 53 => "00000111", 54 => "00011100", 55 => "00001100", 
    56 => "11101101", 57 => "00101011", 58 => "11111001", 59 => "11100111", 
    60 => "00010111", 61 => "00001101", 62 => "00001010", 63 => "11111000", 
    64 => "01001010", 65 => "11100011", 66 => "11101100", 67 => "11111010", 
    68 => "00001101", 69 => "00011010", 70 => "01011100", 71 => "11111011", 
    72 => "11011100", 73 => "11100110", 74 => "11110111", 75 => "10010111", 
    76 => "00001100", 77 => "11011101", 78 => "10110010", 79 => "00001101", 
    80 => "11111010", 81 => "11110100", 82 => "11111001", 83 => "11110010", 
    84 => "00010010", 85 => "11011010", 86 => "01000000", 87 => "11110001", 
    88 => "00000111", 89 => "11001000", 90 => "00100010", 91 => "00001011", 
    92 => "11010011", 93 => "00000010", 94 => "11110011", 95 => "00001101", 
    96 => "00010100", 97 => "00111001", 98 => "11101001", 99 => "00101100", 
    100 => "11110101", 101 => "11101010", 102 => "00001100", 103 => "10111010", 
    104 => "11101111", 105 => "11001110", 106 => "00000000", 107 => "00000101", 
    108 => "00110110", 109 => "11010111", 110 => "11011101", 111 => "11110000", 
    112 => "11111101", 113 => "11100100", 114 => "11100110", 115 => "11111011", 
    116 => "00010100", 117 => "11100110", 118 => "11001010", 119 => "01001010", 
    120 => "11001000", 121 => "11011011", 122 => "00010001", 123 => "00011101", 
    124 => "11111110", 125 => "11111010", 126 => "00111000", 127 => "00111010", 
    128 => "11011111", 129 => "11101000", 130 => "01011101", 131 => "01010100", 
    132 => "00010100", 133 => "11101011", 134 => "00011101", 135 => "11010111", 
    136 => "11000011", 137 => "01100110", 138 => "00100001", 139 => "11111110", 
    140 => "11111010", 141 => "11100100", 142 => "11011001", 143 => "00100101", 
    144 => "00000010", 145 => "00100010", 146 => "00001000", 147 => "00001100", 
    148 => "00001011", 149 => "11101000" );


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

entity gap_head_W_HEAD_Vhtb is
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

architecture arch of gap_head_W_HEAD_Vhtb is
    component gap_head_W_HEAD_Vhtb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhtb_rom_U :  component gap_head_W_HEAD_Vhtb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


