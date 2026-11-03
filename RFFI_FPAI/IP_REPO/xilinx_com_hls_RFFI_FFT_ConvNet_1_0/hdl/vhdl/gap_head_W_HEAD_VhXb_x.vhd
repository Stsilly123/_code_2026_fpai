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

entity gap_head_W_HEAD_VhXb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhXb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00110111", 1 to 2=> "00111110", 3 => "11111110", 4 => "11101101", 
    5 => "01010101", 6 => "00010100", 7 => "00001010", 8 => "11010001", 
    9 => "00101000", 10 => "11110101", 11 => "00101110", 12 => "00100110", 
    13 => "11110001", 14 => "11100011", 15 => "00001010", 16 => "11001010", 
    17 => "00010001", 18 => "00011111", 19 => "01100010", 20 => "00111001", 
    21 => "00011000", 22 => "00100011", 23 => "11100010", 24 => "00110100", 
    25 => "11000110", 26 => "11101101", 27 => "11100000", 28 => "11110101", 
    29 => "00010011", 30 => "00101000", 31 => "11010110", 32 => "10101110", 
    33 => "10111010", 34 => "00100100", 35 => "00100001", 36 => "11100101", 
    37 => "00010010", 38 => "01000100", 39 => "00110010", 40 => "00110001", 
    41 => "11110100", 42 => "00000010", 43 => "00110111", 44 => "00111111", 
    45 => "10111000", 46 => "11100111", 47 => "11001110", 48 => "11010000", 
    49 => "11011100", 50 => "01010010", 51 => "10001011", 52 => "11000001", 
    53 => "00001110", 54 => "11111011", 55 => "11001000", 56 => "11000001", 
    57 => "11001101", 58 to 59=> "11101001", 60 => "11000101", 61 => "11110011", 
    62 => "11111000", 63 => "10110110", 64 => "10110100", 65 => "01010101", 
    66 => "11111101", 67 => "11001000", 68 => "11111111", 69 => "11110000", 
    70 => "00001110", 71 => "10110011", 72 => "01001001", 73 => "10111101", 
    74 => "11110101", 75 => "00111100", 76 => "00111101", 77 => "00011100", 
    78 => "00100000", 79 => "00000100", 80 => "11010110", 81 => "01000000", 
    82 => "00100011", 83 => "00010101", 84 => "00010010", 85 => "00010000", 
    86 => "11111111", 87 => "01010001", 88 => "11001010", 89 => "00111101", 
    90 => "11000110", 91 => "11011110", 92 => "11100101", 93 => "11110000", 
    94 => "00111011", 95 => "10011110", 96 => "00101001", 97 => "11000100", 
    98 => "00100101", 99 => "11110100", 100 => "00011001", 101 => "00011111", 
    102 => "10011010", 103 => "10101111", 104 => "11110110", 105 => "00000100", 
    106 => "00010111", 107 => "11101011", 108 => "10110100", 109 => "11111111", 
    110 => "01001000", 111 => "11110111", 112 => "11101110", 113 => "01010101", 
    114 => "11001111", 115 => "11111100", 116 => "10111111", 117 => "11110010", 
    118 => "01000010", 119 => "11110011", 120 => "11010010", 121 => "00101110", 
    122 => "11100100", 123 => "11010111", 124 => "01000000", 125 => "00101111", 
    126 => "00000110", 127 => "11001001", 128 => "00001100", 129 => "11110001", 
    130 => "00000110", 131 => "11100110", 132 => "11111000", 133 => "00010000", 
    134 => "01001110", 135 => "00010010", 136 => "00101110", 137 => "11101110", 
    138 => "00010011", 139 => "11111100", 140 => "01001000", 141 => "11111111", 
    142 => "00011011", 143 => "00101001", 144 => "11010001", 145 => "00001101", 
    146 => "00101000", 147 => "11101010", 148 => "11101110", 149 => "00100100" );


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

entity gap_head_W_HEAD_VhXb_x is
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

architecture arch of gap_head_W_HEAD_VhXb_x is
    component gap_head_W_HEAD_VhXb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhXb_x_rom_U :  component gap_head_W_HEAD_VhXb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


