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

entity gap_head_W_HEAD_VgHb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgHb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00000110", 1 => "00101011", 2 to 3=> "00011001", 4 => "00010000", 
    5 => "00100001", 6 => "11100011", 7 => "11101101", 8 => "00001001", 
    9 => "00000000", 10 => "11000001", 11 => "11101001", 12 => "11111010", 
    13 => "01010100", 14 => "00100010", 15 => "00000010", 16 => "11111000", 
    17 => "11111010", 18 => "11110001", 19 => "00001101", 20 => "11000001", 
    21 => "11011101", 22 => "01010011", 23 => "01001101", 24 => "11111000", 
    25 => "11001101", 26 => "11011001", 27 => "11000010", 28 => "00101000", 
    29 => "00010010", 30 => "11100011", 31 => "11001111", 32 => "00001110", 
    33 => "11111011", 34 => "00010101", 35 => "11110011", 36 => "00011001", 
    37 => "00000010", 38 => "11101101", 39 => "00000000", 40 => "00000011", 
    41 => "11010000", 42 => "00110100", 43 => "01101000", 44 => "00011011", 
    45 => "00100010", 46 => "01100010", 47 => "00000100", 48 => "11011011", 
    49 => "11001001", 50 => "11001101", 51 => "00100110", 52 => "00001100", 
    53 => "11011111", 54 => "10111101", 55 => "11100001", 56 => "11100101", 
    57 => "11011010", 58 => "00110000", 59 => "00100010", 60 => "11110001", 
    61 => "11111001", 62 => "00000100", 63 => "00011101", 64 => "00011001", 
    65 => "00100001", 66 => "11010100", 67 => "11101000", 68 => "00000010", 
    69 => "11010101", 70 => "00011000", 71 => "00100011", 72 => "00101001", 
    73 => "00100000", 74 => "11101110", 75 => "00001011", 76 => "10100100", 
    77 => "11110111", 78 => "01001011", 79 => "00001010", 80 => "00010100", 
    81 => "00001000", 82 => "11101011", 83 => "00110100", 84 => "00011000", 
    85 => "01011101", 86 => "11101010", 87 => "00010011", 88 => "00100100", 
    89 => "00100001", 90 => "11100001", 91 => "01001101", 92 => "00001010", 
    93 => "11101011", 94 => "11111110", 95 => "11000111", 96 => "00001110", 
    97 => "00000000", 98 => "00101100", 99 => "11100011", 100 => "00011000", 
    101 => "01001110", 102 => "11111110", 103 => "11011001", 104 => "11001010", 
    105 => "11010001", 106 => "11111001", 107 => "00010100", 108 => "11101010", 
    109 => "00101010", 110 => "00111001", 111 => "11110110", 112 => "00000000", 
    113 => "11100100", 114 => "11111001", 115 => "00001000", 116 => "11010001", 
    117 => "00101011", 118 => "00011010", 119 => "00100000", 120 => "00010101", 
    121 => "00101010", 122 => "11110010", 123 => "11101111", 124 => "10101110", 
    125 => "11101000", 126 => "11010111", 127 => "00110000", 128 => "00101010", 
    129 => "01000000", 130 => "11011010", 131 => "11011011", 132 => "11010011", 
    133 => "11111110", 134 => "00000001", 135 => "00001000", 136 => "00101100", 
    137 => "11000100", 138 => "11011000", 139 => "00101000", 140 => "00000111", 
    141 => "00000011", 142 => "00010010", 143 => "11101100", 144 => "00001101", 
    145 => "11110011", 146 => "11010101", 147 => "00010001", 148 => "11010101", 
    149 => "11000111" );


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

entity gap_head_W_HEAD_VgHb is
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

architecture arch of gap_head_W_HEAD_VgHb is
    component gap_head_W_HEAD_VgHb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgHb_rom_U :  component gap_head_W_HEAD_VgHb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


