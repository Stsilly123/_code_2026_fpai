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

entity gap_head_W_HEAD_Vhxb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhxb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10101000", 1 => "11110100", 2 => "11110001", 3 => "11111110", 
    4 => "11011101", 5 => "00001110", 6 => "01001100", 7 => "00000011", 
    8 => "00010001", 9 => "11101000", 10 => "11110010", 11 => "00001101", 
    12 => "11010101", 13 => "00010101", 14 => "00110001", 15 => "00011000", 
    16 => "00100011", 17 => "11101111", 18 => "00000100", 19 => "11010000", 
    20 => "11011011", 21 => "11110101", 22 => "00011011", 23 => "00100000", 
    24 => "00010100", 25 => "00001101", 26 => "01110100", 27 => "00001000", 
    28 => "00100001", 29 => "11011111", 30 => "11110011", 31 => "11101101", 
    32 => "00110010", 33 => "11011111", 34 => "11010001", 35 => "11111110", 
    36 => "11101101", 37 => "11111000", 38 => "00000010", 39 => "11011011", 
    40 => "11100001", 41 => "00100011", 42 => "11101011", 43 => "00011000", 
    44 => "11000000", 45 => "11100100", 46 => "00011111", 47 => "00011110", 
    48 => "01000001", 49 => "00011010", 50 => "11001001", 51 => "01010001", 
    52 => "10011101", 53 => "11110111", 54 => "00011101", 55 => "11011110", 
    56 => "01011110", 57 => "10110101", 58 => "11010111", 59 => "00111010", 
    60 => "00101001", 61 => "00000000", 62 to 63=> "11010011", 64 => "01000011", 
    65 => "00101010", 66 => "00011000", 67 => "11000011", 68 => "00011110", 
    69 => "11100101", 70 => "00101010", 71 => "00101111", 72 => "00001011", 
    73 => "00111010", 74 => "00111001", 75 => "00010101", 76 => "11011110", 
    77 => "11010001", 78 => "01010101", 79 => "11100111", 80 => "11111100", 
    81 => "00001110", 82 => "11000100", 83 => "00100110", 84 => "00100011", 
    85 => "00010100", 86 => "00001011", 87 => "11001010", 88 => "01111101", 
    89 => "00100111", 90 => "00010101", 91 => "11000001", 92 => "00000011", 
    93 => "11011101", 94 => "00101010", 95 => "11111000", 96 => "00011001", 
    97 => "11101110", 98 => "11111100", 99 => "11100110", 100 => "11110010", 
    101 => "11001100", 102 => "00100011", 103 => "01000010", 104 => "11111101", 
    105 => "11100000", 106 => "00111000", 107 => "11101100", 108 => "11010010", 
    109 => "11100100", 110 => "10101111", 111 => "11110000", 112 => "11110010", 
    113 => "10111011", 114 => "00001111", 115 => "00010111", 116 => "00101010", 
    117 => "10100010", 118 => "11100101", 119 => "00010111", 120 => "01001010", 
    121 => "00011000", 122 => "00110011", 123 => "11101010", 124 => "00010010", 
    125 => "00100101", 126 => "11101111", 127 => "11111110", 128 => "00001100", 
    129 => "11111110", 130 => "11110100", 131 => "00100110", 132 => "11101010", 
    133 => "11101011", 134 => "11101101", 135 => "00011100", 136 => "00000101", 
    137 => "00110101", 138 => "11011110", 139 => "00000001", 140 => "10100101", 
    141 => "00001100", 142 => "11010010", 143 => "11001001", 144 => "11011000", 
    145 => "11101110", 146 => "01010010", 147 => "11010001", 148 => "11001001", 
    149 => "00011100" );


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

entity gap_head_W_HEAD_Vhxb is
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

architecture arch of gap_head_W_HEAD_Vhxb is
    component gap_head_W_HEAD_Vhxb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhxb_rom_U :  component gap_head_W_HEAD_Vhxb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


