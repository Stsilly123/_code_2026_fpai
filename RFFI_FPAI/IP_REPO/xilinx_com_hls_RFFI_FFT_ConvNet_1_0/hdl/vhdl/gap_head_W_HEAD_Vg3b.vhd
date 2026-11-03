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

entity gap_head_W_HEAD_Vg3b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vg3b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010110", 1 => "11100100", 2 => "00110001", 3 => "11011001", 
    4 => "11100010", 5 => "11011011", 6 => "11001111", 7 => "11101101", 
    8 => "01011001", 9 => "00010000", 10 => "10101110", 11 => "00110011", 
    12 => "00000001", 13 => "00101110", 14 => "00001010", 15 => "11110011", 
    16 => "00100101", 17 => "11011110", 18 => "10111000", 19 => "00001110", 
    20 => "10110000", 21 => "00100111", 22 => "00011101", 23 => "00001001", 
    24 => "11010110", 25 => "00000000", 26 => "00110011", 27 => "10111010", 
    28 => "11101110", 29 => "11011110", 30 => "01111111", 31 => "00011101", 
    32 => "11101101", 33 => "01001011", 34 => "11110000", 35 => "00000011", 
    36 => "11000100", 37 => "00000100", 38 => "11011001", 39 => "00100011", 
    40 => "00011110", 41 => "11010111", 42 => "10100011", 43 => "10011001", 
    44 => "00001110", 45 => "00000010", 46 => "00101000", 47 => "11010001", 
    48 => "10110000", 49 => "11001110", 50 => "11000011", 51 => "01011010", 
    52 => "00000011", 53 => "11011100", 54 => "10111110", 55 => "00000010", 
    56 => "01010111", 57 => "11100100", 58 => "11011010", 59 => "11010100", 
    60 => "00101111", 61 => "00101100", 62 => "11101001", 63 => "01000111", 
    64 => "00111010", 65 => "11000000", 66 => "01001011", 67 => "00010101", 
    68 => "00111010", 69 => "01001010", 70 => "00100110", 71 => "11011000", 
    72 => "00010011", 73 => "11101100", 74 => "11110000", 75 => "00111100", 
    76 => "11101000", 77 => "00100101", 78 => "00000010", 79 => "00101100", 
    80 => "00001011", 81 => "00011001", 82 => "10111001", 83 => "01111111", 
    84 => "11000101", 85 => "01000100", 86 => "11010011", 87 => "00010011", 
    88 => "11000101", 89 => "00000000", 90 => "00111011", 91 => "11101010", 
    92 => "11110001", 93 => "00110010", 94 => "00011010", 95 => "00000000", 
    96 => "00000100", 97 => "00111001", 98 => "11110001", 99 => "11111101", 
    100 => "00110110", 101 => "00001000", 102 => "00101100", 103 => "00110110", 
    104 => "11100010", 105 => "10111001", 106 => "01000010", 107 => "00111001", 
    108 => "00001100", 109 => "11001101", 110 => "11000100", 111 => "10100110", 
    112 => "11100011", 113 => "00101000", 114 => "00111000", 115 => "11100101", 
    116 => "10001101", 117 => "00010100", 118 => "11100001", 119 => "00100000", 
    120 => "10111011", 121 => "11111100", 122 => "11110001", 123 => "11111001", 
    124 => "11111111", 125 => "00110010", 126 => "00010100", 127 => "00000001", 
    128 => "11011100", 129 => "01001111", 130 => "00001100", 131 => "11010101", 
    132 => "00010101", 133 => "00011011", 134 => "00011000", 135 => "00100111", 
    136 => "11101000", 137 => "00011011", 138 => "11011101", 139 => "11011001", 
    140 => "11010111", 141 => "11110010", 142 => "01001011", 143 => "10110000", 
    144 => "01000100", 145 => "00100010", 146 => "11000011", 147 => "10110001", 
    148 => "01100011", 149 => "10101101" );


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

entity gap_head_W_HEAD_Vg3b is
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

architecture arch of gap_head_W_HEAD_Vg3b is
    component gap_head_W_HEAD_Vg3b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vg3b_rom_U :  component gap_head_W_HEAD_Vg3b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


