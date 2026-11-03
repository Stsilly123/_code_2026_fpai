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

entity gap_head_W_HEAD_Vhgb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhgb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101111", 1 => "00100110", 2 => "11101110", 3 => "00010010", 
    4 => "11101101", 5 => "11100001", 6 => "11110111", 7 => "10111011", 
    8 => "10111111", 9 => "11110100", 10 => "00111000", 11 => "11111001", 
    12 => "10110001", 13 => "00001110", 14 => "00000011", 15 => "11111100", 
    16 => "11011001", 17 => "10100011", 18 => "11010000", 19 => "10101010", 
    20 => "00110101", 21 => "11110101", 22 => "00101111", 23 => "00100100", 
    24 => "11011111", 25 => "00001111", 26 => "10100111", 27 => "11110110", 
    28 => "01011011", 29 => "11101100", 30 => "00101010", 31 => "00010000", 
    32 => "00101011", 33 => "00001101", 34 => "00110100", 35 => "00011000", 
    36 => "00001011", 37 to 38=> "11011110", 39 => "11010100", 40 => "00100010", 
    41 => "00010110", 42 => "10111000", 43 => "00110101", 44 => "11110111", 
    45 => "00000010", 46 => "01101001", 47 => "00010000", 48 => "00011001", 
    49 => "11100011", 50 => "11010011", 51 => "00001111", 52 => "00111011", 
    53 => "01000010", 54 => "00000000", 55 => "10110010", 56 => "00011010", 
    57 => "11110110", 58 => "00010000", 59 => "11000001", 60 => "00011100", 
    61 => "00011111", 62 => "00010101", 63 => "00000101", 64 => "00100010", 
    65 => "00100001", 66 => "00110101", 67 => "01001010", 68 => "00001001", 
    69 => "00010101", 70 => "00111100", 71 => "01110100", 72 => "00011100", 
    73 => "11100100", 74 => "11100010", 75 => "00001110", 76 => "10010100", 
    77 => "11011110", 78 => "11011011", 79 => "11100100", 80 => "11110011", 
    81 => "11000011", 82 => "11100110", 83 => "11111111", 84 => "11101101", 
    85 => "11100001", 86 => "01010010", 87 => "11111000", 88 => "01011111", 
    89 => "00100000", 90 => "00100001", 91 => "00110010", 92 => "10111100", 
    93 => "00010110", 94 => "11111111", 95 => "01101001", 96 => "11111110", 
    97 => "11101010", 98 => "00000000", 99 => "10100110", 100 => "11101000", 
    101 => "00000111", 102 => "11101011", 103 => "00100001", 104 => "00001110", 
    105 => "00000100", 106 => "11101000", 107 => "11011101", 108 => "00010000", 
    109 => "11011101", 110 => "11110101", 111 => "00001100", 112 => "11110111", 
    113 => "11111110", 114 => "11100110", 115 => "11110100", 116 => "00000011", 
    117 => "11011000", 118 => "00000111", 119 => "00000001", 120 => "00011111", 
    121 => "00001000", 122 => "10101111", 123 => "00000111", 124 => "00000101", 
    125 => "11010011", 126 => "11101111", 127 => "00100010", 128 => "11011111", 
    129 => "00010010", 130 => "10101110", 131 => "01011000", 132 => "00000000", 
    133 => "00100011", 134 => "00000100", 135 => "11011001", 136 => "00000000", 
    137 => "00101100", 138 => "00011100", 139 => "00010001", 140 => "11010000", 
    141 => "10101001", 142 => "11110111", 143 => "11011101", 144 => "00101001", 
    145 => "11000100", 146 => "00101010", 147 => "11111000", 148 => "00110000", 
    149 => "00010111" );


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

entity gap_head_W_HEAD_Vhgb is
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

architecture arch of gap_head_W_HEAD_Vhgb is
    component gap_head_W_HEAD_Vhgb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhgb_rom_U :  component gap_head_W_HEAD_Vhgb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


