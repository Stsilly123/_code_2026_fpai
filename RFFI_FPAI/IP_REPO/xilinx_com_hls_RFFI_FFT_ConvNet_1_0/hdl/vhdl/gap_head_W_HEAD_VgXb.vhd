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

entity gap_head_W_HEAD_VgXb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgXb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00000111", 1 => "10111011", 2 => "00010111", 3 => "00100100", 
    4 => "00011001", 5 => "01101001", 6 => "11000010", 7 => "00101101", 
    8 => "01001100", 9 => "00001011", 10 => "10101100", 11 => "11101000", 
    12 => "10111101", 13 => "00101111", 14 => "01001110", 15 => "00011100", 
    16 => "00111000", 17 => "00011010", 18 => "11010100", 19 => "00101010", 
    20 => "00001010", 21 => "00000101", 22 => "00100001", 23 => "00000010", 
    24 => "00001111", 25 => "00101101", 26 => "01000010", 27 => "11100001", 
    28 => "11101010", 29 => "00000010", 30 => "11100010", 31 => "10110101", 
    32 => "11101001", 33 => "00101101", 34 => "00010100", 35 => "11011011", 
    36 => "11100110", 37 => "00000001", 38 => "10111101", 39 => "11001011", 
    40 => "00001001", 41 => "00111011", 42 => "01001100", 43 => "11000010", 
    44 => "11000011", 45 => "11010100", 46 => "01011111", 47 => "00101010", 
    48 => "00101011", 49 => "11100111", 50 => "11010010", 51 => "01001111", 
    52 => "00111010", 53 => "00101011", 54 => "01010111", 55 => "00100011", 
    56 => "01010100", 57 => "11000011", 58 => "00001110", 59 => "10111000", 
    60 => "00001010", 61 => "00010101", 62 => "11100010", 63 => "11110111", 
    64 => "01000100", 65 => "00101011", 66 => "11011101", 67 => "00110001", 
    68 => "11101001", 69 => "00010001", 70 => "01000010", 71 => "00010010", 
    72 => "11100110", 73 => "11010000", 74 => "11111111", 75 => "10011110", 
    76 => "00000000", 77 => "11100101", 78 => "01010000", 79 => "11110010", 
    80 => "10111001", 81 => "11110010", 82 => "11110101", 83 => "11001100", 
    84 => "00010111", 85 => "11000100", 86 => "00101100", 87 => "00010110", 
    88 => "11111000", 89 => "11011110", 90 => "11111010", 91 => "00001000", 
    92 => "11011011", 93 => "00110100", 94 => "00110111", 95 => "00011100", 
    96 => "00001011", 97 => "10110100", 98 to 99=> "00100110", 100 => "11001111", 
    101 => "01001010", 102 => "11101110", 103 => "01001110", 104 => "01000110", 
    105 => "11011101", 106 => "00010000", 107 => "00100011", 108 => "11100000", 
    109 => "00010010", 110 => "00000101", 111 => "00011000", 112 => "11100010", 
    113 => "11010101", 114 => "10011101", 115 => "00001111", 116 => "01111111", 
    117 => "11101010", 118 => "10100001", 119 => "00111111", 120 => "11001110", 
    121 => "11101010", 122 => "11000001", 123 => "01010100", 124 => "11011110", 
    125 => "10111010", 126 => "11001110", 127 => "00110000", 128 => "11011110", 
    129 => "11111111", 130 => "00001100", 131 => "01000010", 132 => "10110100", 
    133 => "11101011", 134 => "00000010", 135 => "00011001", 136 => "10000001", 
    137 => "00100101", 138 => "11011101", 139 => "11010011", 140 => "11011100", 
    141 => "00010011", 142 => "00110100", 143 => "00000100", 144 => "00111110", 
    145 => "00100010", 146 => "10000101", 147 => "00011110", 148 => "11001011", 
    149 => "10110011" );


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

entity gap_head_W_HEAD_VgXb is
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

architecture arch of gap_head_W_HEAD_VgXb is
    component gap_head_W_HEAD_VgXb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgXb_rom_U :  component gap_head_W_HEAD_VgXb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


