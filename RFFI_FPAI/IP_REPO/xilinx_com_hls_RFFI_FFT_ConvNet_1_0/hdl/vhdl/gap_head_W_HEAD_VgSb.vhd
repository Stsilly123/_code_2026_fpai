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

entity gap_head_W_HEAD_VgSb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgSb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10110000", 1 => "00010001", 2 => "00000111", 3 => "11110111", 
    4 => "00001100", 5 => "00000011", 6 => "11110010", 7 => "11011001", 
    8 => "00011010", 9 => "10001001", 10 => "00000111", 11 => "11100111", 
    12 => "11010110", 13 => "11011000", 14 => "11100001", 15 => "00011100", 
    16 => "11111001", 17 => "11011010", 18 => "11011110", 19 => "11000010", 
    20 => "00010110", 21 => "00001100", 22 => "11111010", 23 => "00100000", 
    24 => "00010001", 25 => "00100000", 26 => "11000100", 27 => "11101110", 
    28 => "01000101", 29 => "11111100", 30 => "00100010", 31 => "00100110", 
    32 => "11011001", 33 => "11110000", 34 => "11110101", 35 => "11010000", 
    36 => "00001001", 37 => "00011111", 38 => "10100010", 39 => "00010001", 
    40 => "11101010", 41 => "11011000", 42 => "11100100", 43 => "11011111", 
    44 => "01000111", 45 => "11011110", 46 => "01000000", 47 => "11010110", 
    48 => "01101000", 49 => "00001110", 50 => "11011000", 51 => "11101001", 
    52 => "00101001", 53 => "10110010", 54 => "00011110", 55 => "10011011", 
    56 => "01011001", 57 => "00110011", 58 => "00010101", 59 to 60=> "01010101", 
    61 => "11100010", 62 => "01010001", 63 => "00101101", 64 => "00100001", 
    65 => "00000011", 66 => "11011111", 67 => "11010111", 68 => "00111101", 
    69 => "00001010", 70 => "00100000", 71 => "00111100", 72 => "00111111", 
    73 => "00010010", 74 => "00010100", 75 => "11101011", 76 => "10111101", 
    77 => "11100101", 78 => "11001111", 79 => "11110001", 80 => "00001101", 
    81 => "00000000", 82 => "00100100", 83 => "00011110", 84 => "11101000", 
    85 => "11010011", 86 => "11111111", 87 => "00111011", 88 => "00011001", 
    89 => "00100101", 90 => "00011011", 91 => "11110000", 92 => "00011000", 
    93 => "11011110", 94 => "11111101", 95 => "11110111", 96 => "00000100", 
    97 => "00000111", 98 => "11110110", 99 => "00011001", 100 => "00010001", 
    101 => "00001000", 102 => "11111101", 103 => "10010100", 104 => "11100100", 
    105 => "11000110", 106 => "11101010", 107 => "00111001", 108 => "11101111", 
    109 => "11111011", 110 => "00010111", 111 => "00101011", 112 => "00001110", 
    113 => "00000011", 114 => "11111101", 115 => "11111111", 116 => "11000100", 
    117 => "00110001", 118 => "01010000", 119 => "00001010", 120 => "11110011", 
    121 => "11101001", 122 => "11101110", 123 => "11011100", 124 => "11010110", 
    125 => "11111100", 126 => "11001011", 127 => "00001110", 128 => "00100000", 
    129 => "00001001", 130 => "11101111", 131 => "00011010", 132 => "00011100", 
    133 => "11110100", 134 => "00011010", 135 => "00010101", 136 => "00101101", 
    137 => "00001011", 138 => "00010111", 139 => "00001001", 140 => "00001101", 
    141 => "11111001", 142 => "01010010", 143 => "11101100", 144 => "00010101", 
    145 => "11110000", 146 => "11100101", 147 => "00001000", 148 => "10011000", 
    149 => "11100011" );


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

entity gap_head_W_HEAD_VgSb is
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

architecture arch of gap_head_W_HEAD_VgSb is
    component gap_head_W_HEAD_VgSb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgSb_rom_U :  component gap_head_W_HEAD_VgSb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


