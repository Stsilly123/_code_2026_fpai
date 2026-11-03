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

entity gap_head_W_HEAD_VgFb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgFb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001011", 1 => "00001110", 2 => "11011110", 3 => "00100101", 
    4 => "11111001", 5 => "00011011", 6 => "11100011", 7 => "11010111", 
    8 => "00100011", 9 => "00100010", 10 => "11011101", 11 => "10111111", 
    12 => "00001111", 13 => "11110111", 14 => "11001100", 15 => "00011101", 
    16 => "11000000", 17 => "00101010", 18 => "00000000", 19 => "11111110", 
    20 => "01000011", 21 => "11110100", 22 => "11100000", 23 => "11110011", 
    24 => "11100001", 25 => "00010010", 26 => "11101110", 27 => "11110001", 
    28 => "00000101", 29 => "11101100", 30 => "00111011", 31 => "11001100", 
    32 => "00010010", 33 => "01111111", 34 => "00110011", 35 => "00010101", 
    36 => "11010101", 37 => "01010000", 38 => "11001100", 39 => "11101000", 
    40 => "00111100", 41 => "00010110", 42 => "00000010", 43 => "11100011", 
    44 => "11000011", 45 => "11011001", 46 => "11110000", 47 => "11000101", 
    48 => "00111101", 49 => "11100110", 50 => "00000101", 51 => "11100001", 
    52 => "01111010", 53 => "01011000", 54 => "01010101", 55 => "01010010", 
    56 => "01011001", 57 => "11100000", 58 => "10100100", 59 => "11101001", 
    60 => "01100110", 61 => "00011111", 62 => "00011110", 63 => "11111000", 
    64 => "11100101", 65 => "10111101", 66 => "01111111", 67 => "00010010", 
    68 => "00110110", 69 => "11101010", 70 => "01111111", 71 => "11010001", 
    72 => "11100001", 73 => "11001101", 74 => "11111110", 75 => "11101010", 
    76 => "00010101", 77 => "00000111", 78 => "00000110", 79 => "00000100", 
    80 => "00000010", 81 => "00010110", 82 => "11111111", 83 => "11111001", 
    84 => "11101000", 85 => "10110010", 86 => "01111111", 87 => "11101100", 
    88 => "11100110", 89 => "00100010", 90 => "00110101", 91 => "00010100", 
    92 => "00011000", 93 => "00010100", 94 => "00010000", 95 => "01001011", 
    96 => "11010011", 97 => "00010100", 98 => "00001000", 99 => "00100101", 
    100 => "11101111", 101 => "11011000", 102 => "01001000", 103 => "11100011", 
    104 => "11100000", 105 => "01001101", 106 => "11110011", 107 => "00001110", 
    108 => "00000001", 109 => "11010111", 110 => "01100111", 111 => "00001000", 
    112 => "00000111", 113 => "11111001", 114 => "11101010", 115 => "11101001", 
    116 => "01011110", 117 => "11011101", 118 => "00000110", 119 => "11100111", 
    120 => "01001000", 121 => "11000100", 122 => "11110101", 123 => "10101011", 
    124 => "11111101", 125 => "11110111", 126 => "00010110", 127 => "10111100", 
    128 => "11110110", 129 => "11101011", 130 => "00101010", 131 => "00000000", 
    132 => "00100001", 133 => "00111000", 134 => "11000101", 135 => "11101101", 
    136 => "11001010", 137 => "00000011", 138 => "00010110", 139 => "11110110", 
    140 => "11100010", 141 => "00011011", 142 => "10111111", 143 => "00001010", 
    144 => "00010011", 145 => "11001101", 146 => "10001001", 147 => "11100100", 
    148 => "11101100", 149 => "00001111" );


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

entity gap_head_W_HEAD_VgFb is
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

architecture arch of gap_head_W_HEAD_VgFb is
    component gap_head_W_HEAD_VgFb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgFb_rom_U :  component gap_head_W_HEAD_VgFb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


