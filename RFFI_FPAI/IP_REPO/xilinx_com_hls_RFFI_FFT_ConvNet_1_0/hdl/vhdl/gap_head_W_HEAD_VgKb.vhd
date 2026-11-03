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

entity gap_head_W_HEAD_VgKb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgKb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010001", 1 => "11011010", 2 => "00100011", 3 => "00100100", 
    4 => "11111001", 5 => "00011110", 6 => "00100111", 7 => "00000000", 
    8 => "01010110", 9 => "00100110", 10 => "11101000", 11 => "00111010", 
    12 => "11101111", 13 => "10111111", 14 => "01010100", 15 => "11101011", 
    16 => "11111001", 17 => "10110001", 18 => "11111111", 19 => "00101100", 
    20 => "11101100", 21 => "01001101", 22 => "00001101", 23 => "11101000", 
    24 => "00111011", 25 => "01011010", 26 => "00011010", 27 => "00010001", 
    28 => "11010010", 29 => "01010100", 30 => "11010101", 31 => "01010000", 
    32 => "00100100", 33 => "11110101", 34 => "11111000", 35 => "00010010", 
    36 => "00000100", 37 => "00001001", 38 => "00001000", 39 => "11110100", 
    40 => "11100010", 41 => "11111000", 42 => "00001000", 43 => "11100000", 
    44 => "00011000", 45 => "11000010", 46 => "11001001", 47 => "00110000", 
    48 => "10011001", 49 => "00000111", 50 => "00000100", 51 => "00101101", 
    52 => "00001110", 53 => "00101010", 54 => "00000110", 55 => "11111101", 
    56 => "00011110", 57 => "00001110", 58 => "00000000", 59 => "00110100", 
    60 => "00000011", 61 => "10110111", 62 => "01001000", 63 => "11010111", 
    64 => "11110010", 65 => "11000011", 66 => "00001101", 67 => "00101000", 
    68 => "11110010", 69 => "11010001", 70 => "11101010", 71 => "10000001", 
    72 => "11101011", 73 => "11110001", 74 => "11111111", 75 => "00011011", 
    76 => "11111101", 77 => "00000110", 78 => "11010010", 79 => "11001011", 
    80 => "11101000", 81 => "11100011", 82 => "00000000", 83 => "10000001", 
    84 => "00100011", 85 => "10011111", 86 => "11111101", 87 => "00001000", 
    88 => "10110001", 89 => "00011000", 90 => "00010010", 91 => "00001000", 
    92 => "11100101", 93 => "11011101", 94 => "00000101", 95 => "11111100", 
    96 => "00000111", 97 => "00001011", 98 => "10110011", 99 => "00100110", 
    100 to 101=> "00010101", 102 => "00010111", 103 => "00001001", 104 => "11111101", 
    105 => "00100110", 106 => "00100011", 107 => "00011100", 108 => "00110110", 
    109 => "00101011", 110 => "11110001", 111 => "11010111", 112 => "00101101", 
    113 => "11001110", 114 => "00100110", 115 => "00010001", 116 => "00110011", 
    117 => "00100001", 118 => "10110110", 119 => "01000001", 120 => "11110000", 
    121 => "00100010", 122 => "11111110", 123 => "10000110", 124 => "00011111", 
    125 => "11100101", 126 => "00001000", 127 => "00001011", 128 => "10101001", 
    129 => "11000101", 130 => "11010110", 131 => "00001110", 132 => "11010010", 
    133 => "11101100", 134 => "11011001", 135 => "11111100", 136 => "11010110", 
    137 => "11100010", 138 => "00101010", 139 => "11010011", 140 => "00001001", 
    141 => "11101000", 142 => "11001101", 143 => "11111101", 144 => "11111011", 
    145 => "11111010", 146 => "00100100", 147 => "00010001", 148 => "10111101", 
    149 => "11000100" );


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

entity gap_head_W_HEAD_VgKb is
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

architecture arch of gap_head_W_HEAD_VgKb is
    component gap_head_W_HEAD_VgKb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgKb_rom_U :  component gap_head_W_HEAD_VgKb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


