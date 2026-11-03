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

entity gap_head_W_HEAD_VhDb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhDb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010011", 1 => "11100000", 2 => "00011111", 3 to 4=> "00011110", 
    5 => "11100011", 6 => "11101100", 7 => "00010001", 8 => "11011011", 
    9 => "11011000", 10 => "00001010", 11 => "10111101", 12 => "11100001", 
    13 => "00011100", 14 => "01010000", 15 => "11111010", 16 to 17=> "11100101", 
    18 => "00001001", 19 => "11011110", 20 => "00110100", 21 => "11110111", 
    22 => "00011101", 23 => "01100100", 24 => "11110000", 25 => "00010000", 
    26 => "00001101", 27 => "00011000", 28 => "00000101", 29 => "11010001", 
    30 => "00001011", 31 => "11111100", 32 => "00001000", 33 => "00011100", 
    34 => "11110001", 35 => "00011110", 36 => "11101100", 37 => "11101001", 
    38 => "11111100", 39 => "01000101", 40 => "11100110", 41 => "01000111", 
    42 => "01001011", 43 => "00010011", 44 => "11101110", 45 => "11110100", 
    46 => "00011011", 47 => "11111110", 48 => "00011010", 49 => "01101110", 
    50 => "11101101", 51 => "00000110", 52 => "00110100", 53 => "00100100", 
    54 => "00111110", 55 => "00100101", 56 => "00101110", 57 => "11100001", 
    58 => "11110111", 59 => "11011110", 60 => "00000001", 61 => "11111110", 
    62 => "00001101", 63 => "11111001", 64 => "01110011", 65 => "00100001", 
    66 => "11110111", 67 => "00110011", 68 => "00010000", 69 => "00110010", 
    70 => "00000100", 71 => "00011100", 72 => "11101000", 73 => "00011010", 
    74 => "11111000", 75 => "11101001", 76 => "11011110", 77 => "11111111", 
    78 => "10111001", 79 => "11110101", 80 => "00110011", 81 => "00101000", 
    82 => "11011100", 83 => "00000001", 84 => "11001010", 85 => "00100111", 
    86 => "11101001", 87 => "11010010", 88 => "11110010", 89 => "11100110", 
    90 => "00001000", 91 => "00100111", 92 => "00001100", 93 => "00001010", 
    94 => "11011000", 95 => "00011111", 96 => "11111011", 97 => "11110110", 
    98 => "11101001", 99 => "00000000", 100 => "11010100", 101 => "11101000", 
    102 => "00001111", 103 => "00011000", 104 => "01001010", 105 => "00010001", 
    106 => "00000100", 107 => "11100011", 108 => "11101100", 109 => "00001001", 
    110 => "11100100", 111 => "00011001", 112 => "11110100", 113 => "00000010", 
    114 => "11001011", 115 => "00000100", 116 => "00011110", 117 => "11101110", 
    118 => "10111111", 119 => "01000001", 120 => "00001100", 121 => "00001101", 
    122 => "00100001", 123 => "01010001", 124 => "11111110", 125 => "11110100", 
    126 => "11010111", 127 => "00110100", 128 => "11011110", 129 => "00100001", 
    130 => "10111101", 131 => "00101000", 132 => "00001100", 133 => "11100011", 
    134 => "00110101", 135 => "00000001", 136 => "00011001", 137 => "00101010", 
    138 => "11110001", 139 => "11110111", 140 => "11001100", 141 => "00011111", 
    142 => "00001011", 143 => "11110111", 144 => "11110001", 145 => "11101001", 
    146 => "00000011", 147 => "11100111", 148 => "11111001", 149 => "11101110" );


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

entity gap_head_W_HEAD_VhDb_x is
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

architecture arch of gap_head_W_HEAD_VhDb_x is
    component gap_head_W_HEAD_VhDb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhDb_x_rom_U :  component gap_head_W_HEAD_VhDb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


