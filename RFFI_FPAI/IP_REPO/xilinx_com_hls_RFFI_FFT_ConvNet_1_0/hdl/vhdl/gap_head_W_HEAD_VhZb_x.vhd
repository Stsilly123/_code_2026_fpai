-- ==============================================================
-- File generated on Sun Oct 18 16:53:18 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_VhZb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhZb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00100111", 1 => "11101011", 2 => "00010101", 3 => "11101101", 
    4 => "11001110", 5 => "00001101", 6 => "10111100", 7 => "00110011", 
    8 to 9=> "11110000", 10 => "10111011", 11 => "11001100", 12 => "11110000", 
    13 => "00100101", 14 => "01000010", 15 => "00000011", 16 => "00110100", 
    17 => "00011101", 18 => "00010110", 19 => "00111111", 20 => "00011001", 
    21 => "11111001", 22 => "00000000", 23 => "00110000", 24 => "00100100", 
    25 => "11010101", 26 => "00101101", 27 => "11111100", 28 => "11101001", 
    29 => "00101011", 30 => "11101001", 31 => "11110100", 32 => "00000010", 
    33 => "11100010", 34 => "00001010", 35 => "11101001", 36 => "00010011", 
    37 => "11111011", 38 => "00000011", 39 => "01010100", 40 => "11111101", 
    41 => "00110110", 42 => "10111111", 43 => "00110101", 44 => "00011000", 
    45 => "10111000", 46 => "01001111", 47 => "00011011", 48 => "00000111", 
    49 => "00111000", 50 => "11101011", 51 => "00101000", 52 => "11100101", 
    53 => "11101001", 54 => "00010010", 55 => "11100000", 56 => "00111011", 
    57 => "00101101", 58 => "00111011", 59 => "00010110", 60 => "00001010", 
    61 => "11101000", 62 => "11001011", 63 => "11110000", 64 => "01011100", 
    65 => "00000110", 66 => "11110010", 67 => "11100001", 68 => "00010010", 
    69 => "11111001", 70 => "00100011", 71 => "11011011", 72 => "00001010", 
    73 => "10110100", 74 => "11011110", 75 => "00100011", 76 => "11000000", 
    77 => "11101111", 78 => "00111001", 79 => "11100000", 80 => "11001000", 
    81 => "11111010", 82 => "00000001", 83 => "11111000", 84 => "00010010", 
    85 => "11011111", 86 => "11111101", 87 => "11011000", 88 => "00111101", 
    89 => "00010011", 90 => "11110101", 91 => "11111101", 92 => "10100101", 
    93 => "11010011", 94 => "11111101", 95 => "10101000", 96 => "00001011", 
    97 => "00011110", 98 => "11101100", 99 => "11010100", 100 => "00001001", 
    101 => "00100010", 102 => "01000010", 103 => "11101111", 104 => "00000010", 
    105 => "00010000", 106 => "00011111", 107 => "00110101", 108 => "00100110", 
    109 => "11110111", 110 => "11101000", 111 => "11101010", 112 => "00001101", 
    113 => "11101111", 114 => "01001001", 115 => "00010101", 116 => "11010001", 
    117 => "11111110", 118 => "10101111", 119 => "00100011", 120 => "00001111", 
    121 => "11110000", 122 => "00010010", 123 => "11111110", 124 => "11010000", 
    125 => "00001011", 126 => "00011110", 127 => "00101111", 128 => "00001000", 
    129 => "00100100", 130 => "10111001", 131 => "00100010", 132 => "11101010", 
    133 => "11111001", 134 => "00011011", 135 => "00000000", 136 => "11010110", 
    137 => "00101101", 138 => "11100001", 139 => "11101110", 140 => "11010100", 
    141 => "11110001", 142 => "00101110", 143 => "11101011", 144 => "11001111", 
    145 => "00000110", 146 => "00000001", 147 => "00100101", 148 => "10100001", 
    149 => "01001101" );


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

entity gap_head_W_HEAD_VhZb_x is
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

architecture arch of gap_head_W_HEAD_VhZb_x is
    component gap_head_W_HEAD_VhZb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhZb_x_rom_U :  component gap_head_W_HEAD_VhZb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


