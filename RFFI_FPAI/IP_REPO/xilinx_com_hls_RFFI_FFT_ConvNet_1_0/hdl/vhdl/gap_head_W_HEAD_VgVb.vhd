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

entity gap_head_W_HEAD_VgVb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgVb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11111001", 1 => "00001011", 2 => "11101100", 3 => "11001100", 
    4 => "00011101", 5 => "00111010", 6 => "00101001", 7 => "00001100", 
    8 => "11100000", 9 => "10110011", 10 => "00000010", 11 => "11100110", 
    12 => "00011001", 13 => "01000001", 14 => "00001100", 15 => "00000101", 
    16 => "11111010", 17 => "11111111", 18 => "00101100", 19 => "11101100", 
    20 => "00011110", 21 => "00001011", 22 => "11111101", 23 => "00001100", 
    24 => "00010110", 25 => "00110000", 26 => "11101110", 27 => "00001111", 
    28 => "00101011", 29 => "11011010", 30 => "00101100", 31 => "11110000", 
    32 => "11010100", 33 => "00100001", 34 => "11011011", 35 => "11101110", 
    36 => "11100100", 37 => "11011011", 38 => "00110111", 39 => "00100000", 
    40 => "00000011", 41 => "00011101", 42 => "00100111", 43 => "10111110", 
    44 => "00001000", 45 => "11100111", 46 => "00001011", 47 => "11010101", 
    48 => "00100001", 49 => "00010001", 50 => "11111001", 51 => "11100111", 
    52 => "00001010", 53 => "11000011", 54 => "00011001", 55 => "00000000", 
    56 => "01111111", 57 => "11011101", 58 => "00001100", 59 => "00100111", 
    60 => "00110111", 61 => "00000110", 62 => "11101111", 63 => "00101011", 
    64 => "01010011", 65 => "00111111", 66 => "00010000", 67 => "11110110", 
    68 => "00000001", 69 => "01001101", 70 => "01011111", 71 => "01001111", 
    72 => "00000000", 73 => "00001000", 74 => "11110001", 75 => "11110000", 
    76 => "11111000", 77 => "00000100", 78 => "00011000", 79 => "11011110", 
    80 => "11100111", 81 => "00110000", 82 => "00000011", 83 => "00100110", 
    84 => "00000000", 85 => "01010000", 86 => "11110100", 87 => "11101000", 
    88 => "11101100", 89 => "00101010", 90 => "11011000", 91 => "00111010", 
    92 => "11100110", 93 => "11110001", 94 => "11101111", 95 => "11101000", 
    96 => "11100101", 97 => "11110111", 98 => "00010100", 99 => "10110010", 
    100 => "00001011", 101 => "00000100", 102 => "00100101", 103 => "11011000", 
    104 => "11110100", 105 => "11100110", 106 => "11110000", 107 => "11011101", 
    108 => "11001011", 109 => "00100100", 110 => "11100101", 111 => "11011011", 
    112 => "11011000", 113 => "00101010", 114 => "11000010", 115 => "01000010", 
    116 => "00100010", 117 => "00001110", 118 => "00001010", 119 => "00111100", 
    120 => "00001111", 121 => "11111101", 122 => "11110000", 123 => "11000111", 
    124 => "00101100", 125 => "00010110", 126 => "11111111", 127 => "11100000", 
    128 => "00110101", 129 => "00101101", 130 => "00000001", 131 => "10110010", 
    132 => "00000000", 133 => "01000101", 134 => "00111001", 135 => "11110100", 
    136 => "11010100", 137 => "00101100", 138 => "00011010", 139 => "11100111", 
    140 => "11111001", 141 => "11111110", 142 => "00001110", 143 => "00010100", 
    144 => "00001110", 145 => "00000001", 146 => "00000111", 147 => "11101000", 
    148 => "10101011", 149 => "11000011" );


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

entity gap_head_W_HEAD_VgVb is
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

architecture arch of gap_head_W_HEAD_VgVb is
    component gap_head_W_HEAD_VgVb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgVb_rom_U :  component gap_head_W_HEAD_VgVb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


