-- ==============================================================
-- File generated on Sun Oct 18 16:53:17 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_VhKb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhKb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01000100", 1 => "00100010", 2 => "11010010", 3 => "11100111", 
    4 => "10110110", 5 => "11111111", 6 => "00100010", 7 => "00011110", 
    8 => "11011010", 9 => "11011000", 10 => "11101111", 11 => "11011110", 
    12 => "11100111", 13 => "00110011", 14 => "00000000", 15 => "00000110", 
    16 => "11111101", 17 => "00111011", 18 => "00100111", 19 => "00110010", 
    20 => "01010010", 21 => "00001101", 22 => "11010111", 23 => "00101111", 
    24 => "00101100", 25 => "00010011", 26 => "11111111", 27 => "00101001", 
    28 => "11011111", 29 => "01001110", 30 => "11110110", 31 => "11111001", 
    32 => "11100010", 33 => "00010011", 34 => "11101100", 35 => "11001110", 
    36 => "00011111", 37 => "11010000", 38 => "00110111", 39 => "11110010", 
    40 => "11101001", 41 => "00001001", 42 => "00001100", 43 => "11001111", 
    44 => "00100110", 45 => "11110010", 46 => "11100001", 47 => "11101001", 
    48 => "00100100", 49 => "00101100", 50 => "11001100", 51 => "00010000", 
    52 => "10111100", 53 => "11111111", 54 => "00000110", 55 => "00100111", 
    56 => "00111010", 57 => "10111101", 58 => "01001101", 59 => "11001101", 
    60 => "00100110", 61 => "11101001", 62 => "00001010", 63 => "11110101", 
    64 => "01000111", 65 => "11000101", 66 => "00000100", 67 => "00011100", 
    68 => "00001001", 69 => "00000010", 70 => "00100000", 71 => "11101110", 
    72 => "11011110", 73 => "11110110", 74 => "11111111", 75 => "11100100", 
    76 => "11111101", 77 => "10111011", 78 => "11111110", 79 => "00000001", 
    80 => "00010110", 81 => "11001001", 82 => "00100101", 83 => "11111000", 
    84 => "01111011", 85 => "11001110", 86 => "00001000", 87 => "00000001", 
    88 => "00001110", 89 => "11110110", 90 => "00011101", 91 => "11100111", 
    92 => "11111000", 93 => "11101111", 94 => "11011011", 95 => "00010000", 
    96 => "11001101", 97 => "11110101", 98 => "11101100", 99 => "11010111", 
    100 => "11011111", 101 => "00000111", 102 => "00100101", 103 => "00000011", 
    104 => "00111111", 105 => "11101001", 106 => "11010001", 107 => "11100010", 
    108 => "00010100", 109 => "00000000", 110 => "10110000", 111 => "00010111", 
    112 => "00010001", 113 => "11111111", 114 => "10110010", 115 => "00001101", 
    116 => "11111110", 117 => "11110010", 118 => "10101111", 119 => "00010110", 
    120 => "11011000", 121 => "00101010", 122 => "00100110", 123 => "11110111", 
    124 => "00001100", 125 => "11111100", 126 => "11100111", 127 => "00001001", 
    128 => "00011000", 129 => "00100010", 130 => "00000000", 131 => "00101010", 
    132 => "11011111", 133 => "00001001", 134 => "00110100", 135 => "11010111", 
    136 => "10111101", 137 => "01001000", 138 => "00001010", 139 => "11111000", 
    140 => "00001111", 141 => "00001011", 142 => "00100010", 143 => "00010101", 
    144 => "00011110", 145 => "11011101", 146 => "01011000", 147 => "00101001", 
    148 => "11001110", 149 => "11100100" );


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

entity gap_head_W_HEAD_VhKb_x is
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

architecture arch of gap_head_W_HEAD_VhKb_x is
    component gap_head_W_HEAD_VhKb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhKb_x_rom_U :  component gap_head_W_HEAD_VhKb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


