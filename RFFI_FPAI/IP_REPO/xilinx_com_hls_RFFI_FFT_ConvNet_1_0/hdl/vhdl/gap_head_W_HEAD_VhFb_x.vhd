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

entity gap_head_W_HEAD_VhFb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhFb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10101000", 1 => "00011000", 2 => "00000110", 3 => "00101110", 
    4 => "00100101", 5 => "10101001", 6 => "00001011", 7 => "10101110", 
    8 to 9=> "11101010", 10 => "11100100", 11 => "10110001", 12 => "10101000", 
    13 => "11101110", 14 => "00000110", 15 => "11100101", 16 => "10010110", 
    17 => "11011110", 18 => "11000000", 19 => "10100001", 20 => "00011001", 
    21 => "11000000", 22 => "11100000", 23 => "00100000", 24 => "11100001", 
    25 => "00100101", 26 => "11000000", 27 => "11100101", 28 => "00011001", 
    29 => "00000100", 30 => "11011010", 31 => "00100001", 32 => "00000001", 
    33 => "00000011", 34 => "00000100", 35 => "00000011", 36 => "00111001", 
    37 => "00001111", 38 => "10001111", 39 => "00100011", 40 => "01000100", 
    41 => "11111011", 42 => "11101011", 43 => "11110001", 44 => "11101111", 
    45 => "00011110", 46 => "01100000", 47 => "11000011", 48 => "01011101", 
    49 => "00011011", 50 => "10100101", 51 => "00000000", 52 => "00101111", 
    53 => "11000011", 54 => "10011100", 55 => "10110110", 56 => "00010001", 
    57 => "01000001", 58 => "00010001", 59 => "11111011", 60 => "01000011", 
    61 => "10000001", 62 => "00001110", 63 => "11111010", 64 => "01000011", 
    65 => "00110100", 66 => "10111101", 67 => "01111111", 68 => "00111111", 
    69 => "11000011", 70 => "00001011", 71 => "11111000", 72 => "00011111", 
    73 => "00000100", 74 => "11111100", 75 => "11001011", 76 => "11001000", 
    77 => "11100000", 78 => "11101000", 79 => "10101110", 80 => "00110000", 
    81 => "00000001", 82 => "00110010", 83 => "00011110", 84 => "11100100", 
    85 => "00101111", 86 => "11010101", 87 => "00110011", 88 => "11101101", 
    89 => "00000011", 90 => "00101011", 91 => "11111000", 92 => "00011101", 
    93 => "11100101", 94 => "00001011", 95 => "10101101", 96 => "10100100", 
    97 => "10111011", 98 => "11100101", 99 => "10011110", 100 => "01101101", 
    101 => "00001101", 102 => "00011001", 103 => "11110010", 104 => "00000101", 
    105 => "11111001", 106 => "11011010", 107 => "11010111", 108 => "00111111", 
    109 => "00000001", 110 => "11111101", 111 => "11010101", 112 => "00001100", 
    113 => "11111001", 114 => "11001011", 115 => "00000110", 116 => "00011000", 
    117 => "01011010", 118 => "10110101", 119 => "00111111", 120 => "11100001", 
    121 => "00001001", 122 => "00000010", 123 => "11011001", 124 => "00100001", 
    125 => "11101110", 126 => "10110010", 127 => "01000000", 128 => "00100000", 
    129 => "00110110", 130 => "00110111", 131 => "10111110", 132 => "00000111", 
    133 => "00100110", 134 => "00000011", 135 => "00001010", 136 => "01101001", 
    137 => "11110101", 138 => "00000111", 139 => "00001111", 140 => "01000110", 
    141 => "00100000", 142 => "00101111", 143 => "10110001", 144 => "00010000", 
    145 => "10100010", 146 => "10101011", 147 => "00001001", 148 => "00111011", 
    149 => "00011010" );


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

entity gap_head_W_HEAD_VhFb_x is
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

architecture arch of gap_head_W_HEAD_VhFb_x is
    component gap_head_W_HEAD_VhFb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhFb_x_rom_U :  component gap_head_W_HEAD_VhFb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


