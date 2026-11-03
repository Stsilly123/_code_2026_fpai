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

entity gap_head_W_HEAD_VgJb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgJb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11111011", 1 => "00100010", 2 => "10111010", 3 => "00000101", 
    4 => "11100000", 5 => "10010101", 6 => "00101100", 7 => "11111010", 
    8 => "11011101", 9 => "11110010", 10 to 11=> "11100011", 12 => "11101010", 
    13 => "00010100", 14 => "00010110", 15 => "00001000", 16 => "11011101", 
    17 => "00000101", 18 => "11111000", 19 => "11111111", 20 => "00110001", 
    21 to 22=> "11011110", 23 => "00101010", 24 => "11011100", 25 => "11101110", 
    26 => "11001110", 27 => "00110000", 28 => "10101010", 29 => "10100111", 
    30 => "11000001", 31 => "00001100", 32 => "00001010", 33 => "11101111", 
    34 => "11001011", 35 => "11101000", 36 => "00011110", 37 => "00000111", 
    38 => "11100100", 39 => "00100110", 40 => "11110111", 41 => "00000011", 
    42 => "01010000", 43 => "00000101", 44 => "11110110", 45 => "00010111", 
    46 => "11101110", 47 => "00010101", 48 => "11100111", 49 => "00110000", 
    50 => "11110001", 51 => "00001101", 52 => "11000010", 53 => "11101101", 
    54 => "00000001", 55 => "01000100", 56 => "00001101", 57 => "00110010", 
    58 => "00011011", 59 => "11011011", 60 => "11101110", 61 => "00000010", 
    62 => "10101000", 63 => "00001100", 64 => "11110101", 65 => "11110000", 
    66 => "00001110", 67 => "00010010", 68 => "11110111", 69 => "00010010", 
    70 => "00010101", 71 => "11111111", 72 => "11100010", 73 => "11100011", 
    74 => "11101100", 75 => "11110110", 76 => "00101100", 77 => "11110110", 
    78 => "00010111", 79 => "00011100", 80 => "11110111", 81 => "00100011", 
    82 => "00000011", 83 => "11011010", 84 => "11101101", 85 => "00001111", 
    86 => "11100011", 87 => "11000110", 88 => "00111110", 89 => "11110111", 
    90 => "00000101", 91 => "00010110", 92 => "00100101", 93 => "00000100", 
    94 => "11011101", 95 => "11100010", 96 => "11110001", 97 => "00001111", 
    98 => "11010110", 99 => "10111010", 100 => "01000011", 101 => "11111001", 
    102 => "00011110", 103 => "11011100", 104 => "00110010", 105 => "00010010", 
    106 => "00001011", 107 => "11101100", 108 => "00100101", 109 => "00110001", 
    110 => "00001010", 111 => "00010000", 112 => "00011110", 113 => "11011010", 
    114 => "11010000", 115 => "00000101", 116 => "00111110", 117 => "00000110", 
    118 => "00000111", 119 => "00110000", 120 => "00000101", 121 => "00011111", 
    122 => "00100101", 123 => "11011110", 124 => "00000100", 125 => "00010000", 
    126 => "11111001", 127 => "11100110", 128 => "00110111", 129 => "00100000", 
    130 => "00110000", 131 => "00011101", 132 => "11111111", 133 => "00001110", 
    134 => "11110100", 135 => "11000011", 136 => "00101011", 137 => "00100000", 
    138 => "00001110", 139 => "11110111", 140 => "00110001", 141 => "00001011", 
    142 => "11101010", 143 => "11111100", 144 => "11001110", 145 => "11111010", 
    146 => "00100010", 147 => "00010111", 148 => "00010100", 149 => "11111111" );


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

entity gap_head_W_HEAD_VgJb is
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

architecture arch of gap_head_W_HEAD_VgJb is
    component gap_head_W_HEAD_VgJb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgJb_rom_U :  component gap_head_W_HEAD_VgJb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


