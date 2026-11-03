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

entity gap_head_W_HEAD_VgZb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgZb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00110110", 1 => "11000110", 2 => "11000111", 3 => "00010110", 
    4 => "00111110", 5 => "00100110", 6 => "11000001", 7 => "10110010", 
    8 => "00001111", 9 => "00000110", 10 => "00010111", 11 => "00010100", 
    12 => "00000011", 13 => "11010001", 14 => "11100101", 15 => "11110011", 
    16 => "00010001", 17 => "00100100", 18 => "11001001", 19 => "00011101", 
    20 => "11111000", 21 => "11011010", 22 => "10101101", 23 => "11010010", 
    24 => "00000001", 25 => "00000000", 26 => "11100110", 27 => "00001110", 
    28 => "00001010", 29 => "01101000", 30 => "00000010", 31 => "11100100", 
    32 => "00000001", 33 => "00000011", 34 => "00101111", 35 => "11010111", 
    36 => "11101110", 37 => "11111101", 38 => "10110101", 39 => "00101101", 
    40 => "00010110", 41 => "00011010", 42 => "11100111", 43 => "11101010", 
    44 => "10011011", 45 => "00010010", 46 => "10101111", 47 => "00001101", 
    48 => "00011111", 49 => "01001100", 50 => "11101000", 51 => "11111011", 
    52 => "00001111", 53 => "00001011", 54 => "00010111", 55 => "10111111", 
    56 => "00001001", 57 => "11110101", 58 => "11101010", 59 to 60=> "11111000", 
    61 => "00000110", 62 => "00001001", 63 => "00100101", 64 => "00100110", 
    65 => "11100110", 66 => "00010000", 67 => "11110010", 68 => "00000001", 
    69 => "10100101", 70 => "00010110", 71 => "11011101", 72 => "01001110", 
    73 => "01000001", 74 => "11111001", 75 => "11110100", 76 => "00010111", 
    77 => "11100110", 78 => "11101001", 79 => "00010100", 80 => "11001001", 
    81 => "00010101", 82 => "01100000", 83 => "01000011", 84 => "11101110", 
    85 => "00010001", 86 => "00100010", 87 => "00110001", 88 => "00010100", 
    89 => "01000011", 90 => "00100001", 91 => "11100111", 92 => "00100101", 
    93 => "00010000", 94 => "11011110", 95 => "00101001", 96 => "11101011", 
    97 => "00101110", 98 => "00000011", 99 => "00001111", 100 => "11010000", 
    101 => "11000010", 102 => "00001001", 103 => "11100011", 104 => "00010011", 
    105 => "00000101", 106 => "11100000", 107 => "11101011", 108 => "11111010", 
    109 => "10000001", 110 => "11110110", 111 => "00011101", 112 => "00010100", 
    113 => "10111101", 114 => "00111000", 115 => "11001011", 116 => "00110111", 
    117 => "11011010", 118 => "00100011", 119 => "11110011", 120 => "00000000", 
    121 => "11011000", 122 => "11110011", 123 => "00100000", 124 => "00010011", 
    125 => "11001000", 126 => "00001100", 127 => "11001100", 128 => "11110000", 
    129 => "00000100", 130 => "00010010", 131 => "01000111", 132 => "11111011", 
    133 => "11000011", 134 => "00100000", 135 => "10110001", 136 => "11110101", 
    137 => "01000111", 138 => "00000110", 139 => "11101000", 140 => "01001110", 
    141 => "11111100", 142 => "11111101", 143 => "00110110", 144 => "00000010", 
    145 => "11101010", 146 => "01110001", 147 => "11001111", 148 => "11101001", 
    149 => "00111010" );


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

entity gap_head_W_HEAD_VgZb is
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

architecture arch of gap_head_W_HEAD_VgZb is
    component gap_head_W_HEAD_VgZb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgZb_rom_U :  component gap_head_W_HEAD_VgZb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


