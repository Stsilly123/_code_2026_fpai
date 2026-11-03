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

entity gap_head_W_HEAD_VhAb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhAb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10100110", 1 => "11111000", 2 => "00110100", 3 => "00001010", 
    4 => "11010110", 5 => "00000101", 6 => "11100110", 7 => "11111100", 
    8 => "00000001", 9 => "00110101", 10 => "01011001", 11 => "11001001", 
    12 => "00010001", 13 => "11011000", 14 => "00011101", 15 => "00001001", 
    16 => "11001100", 17 => "11001101", 18 => "00011100", 19 => "10000001", 
    20 => "00000001", 21 => "11111100", 22 => "01111111", 23 => "11111010", 
    24 => "10000111", 25 => "11101111", 26 => "00010110", 27 => "11110110", 
    28 => "00010100", 29 => "10101011", 30 => "00101000", 31 => "11000111", 
    32 => "00101011", 33 => "00100011", 34 => "00001111", 35 => "01100100", 
    36 => "00111100", 37 => "00111011", 38 => "11110000", 39 => "11100010", 
    40 => "01001010", 41 => "00101111", 42 => "00011111", 43 => "11010010", 
    44 => "11011110", 45 => "00111111", 46 => "11111111", 47 => "00000011", 
    48 => "11100100", 49 => "11110100", 50 => "01000010", 51 => "11111111", 
    52 => "11000000", 53 => "00101001", 54 => "01011011", 55 => "00110110", 
    56 => "11100001", 57 => "11111101", 58 => "00100000", 59 => "11100100", 
    60 => "00111010", 61 => "00010111", 62 => "01100111", 63 => "11111100", 
    64 => "10110110", 65 => "11010000", 66 => "00111001", 67 => "11101001", 
    68 => "11000100", 69 => "11010111", 70 => "11101101", 71 => "11100101", 
    72 => "11010111", 73 => "11000001", 74 => "11101011", 75 => "01000101", 
    76 => "10111100", 77 => "11111011", 78 => "01000000", 79 => "11100001", 
    80 => "00010111", 81 => "11000100", 82 => "00100101", 83 => "11111010", 
    84 => "10101111", 85 => "11100110", 86 to 87=> "01000110", 88 => "00001011", 
    89 => "00001100", 90 => "11101110", 91 => "11111100", 92 => "11000111", 
    93 => "11010000", 94 => "00100111", 95 => "11001011", 96 => "00110011", 
    97 => "00011001", 98 => "01100100", 99 => "11001110", 100 => "10111010", 
    101 => "00101001", 102 => "11110010", 103 => "00110011", 104 => "10111111", 
    105 => "00100010", 106 => "00000010", 107 => "11100111", 108 => "01010010", 
    109 => "10110001", 110 => "00011111", 111 => "11101011", 112 => "00000101", 
    113 => "01000100", 114 => "01000110", 115 => "00000011", 116 => "00011010", 
    117 => "11001111", 118 => "11010010", 119 => "11010111", 120 => "11111101", 
    121 => "11010011", 122 => "11110100", 123 => "10101010", 124 => "11111101", 
    125 => "11010111", 126 => "11001111", 127 => "00000011", 128 => "11000110", 
    129 => "11010111", 130 => "11000111", 131 => "11111000", 132 => "00011110", 
    133 => "11111110", 134 => "11101101", 135 => "00101010", 136 => "11110111", 
    137 => "00110110", 138 => "11110110", 139 => "11110011", 140 to 141=> "11101000", 
    142 => "00011100", 143 => "11111011", 144 => "01010110", 145 => "00001110", 
    146 => "11011010", 147 => "00000110", 148 => "00111110", 149 => "00000011" );


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

entity gap_head_W_HEAD_VhAb_x is
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

architecture arch of gap_head_W_HEAD_VhAb_x is
    component gap_head_W_HEAD_VhAb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhAb_x_rom_U :  component gap_head_W_HEAD_VhAb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


