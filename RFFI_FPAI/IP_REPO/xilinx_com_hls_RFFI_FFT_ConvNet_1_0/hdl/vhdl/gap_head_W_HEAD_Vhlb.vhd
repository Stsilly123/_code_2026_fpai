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

entity gap_head_W_HEAD_Vhlb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhlb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100011", 1 => "00101011", 2 => "11111111", 3 => "10101011", 
    4 => "01101100", 5 => "10110000", 6 => "00110100", 7 => "00110110", 
    8 => "10111110", 9 => "00010101", 10 => "00001100", 11 => "00101011", 
    12 => "00000011", 13 => "00010110", 14 => "11110100", 15 => "00001111", 
    16 => "00101001", 17 => "00000011", 18 => "00011001", 19 => "11100100", 
    20 => "10101110", 21 => "10001101", 22 => "00001000", 23 => "00100010", 
    24 => "00011100", 25 => "10110110", 26 => "00100000", 27 => "00110010", 
    28 => "10110100", 29 => "01111011", 30 => "10100101", 31 => "11100101", 
    32 => "00001011", 33 => "11101111", 34 => "10111011", 35 => "11101000", 
    36 => "00000101", 37 => "11011010", 38 => "00100101", 39 => "00010101", 
    40 => "00011010", 41 => "01101000", 42 => "11010110", 43 => "11110010", 
    44 => "11011001", 45 => "01001000", 46 => "01000011", 47 => "00001010", 
    48 => "11101001", 49 => "01101000", 50 => "00001101", 51 => "00010010", 
    52 => "10100011", 53 => "11100110", 54 to 55=> "00101100", 56 => "11110011", 
    57 => "00001001", 58 => "11100111", 59 => "00000001", 60 => "11101010", 
    61 => "00000011", 62 => "11000111", 63 => "11110010", 64 => "10011110", 
    65 => "11001101", 66 => "00000111", 67 => "11101000", 68 => "11101001", 
    69 => "11111010", 70 => "11110101", 71 => "11001111", 72 => "10101100", 
    73 => "11101010", 74 => "00000010", 75 => "00010011", 76 => "11100100", 
    77 => "11110000", 78 => "11110111", 79 => "00000001", 80 => "00001101", 
    81 => "11010010", 82 => "00000000", 83 => "11110011", 84 => "01010010", 
    85 => "10110010", 86 => "00110100", 87 => "11111100", 88 => "11101011", 
    89 => "11001101", 90 => "00110010", 91 => "00000111", 92 => "00010100", 
    93 => "00000011", 94 => "11010101", 95 => "00010101", 96 => "01000110", 
    97 => "11111000", 98 => "11101011", 99 => "10101011", 100 => "00011000", 
    101 => "11110011", 102 => "00010100", 103 => "01101110", 104 => "11111101", 
    105 => "00001011", 106 => "00100000", 107 => "11000111", 108 => "00000011", 
    109 => "01000011", 110 => "00011111", 111 => "00001000", 112 => "11011101", 
    113 => "00110110", 114 => "10110110", 115 => "11110011", 116 => "11000110", 
    117 => "11100000", 118 => "11001001", 119 => "00001010", 120 => "00100010", 
    121 => "11011010", 122 => "00011001", 123 => "01100001", 124 => "01000101", 
    125 => "00010111", 126 => "10000001", 127 => "00001101", 128 => "00110111", 
    129 => "00000001", 130 => "00100011", 131 => "00110001", 132 => "01001000", 
    133 => "00011010", 134 => "11111111", 135 => "00111000", 136 => "11110101", 
    137 => "11001001", 138 => "11110110", 139 => "00101111", 140 => "11001010", 
    141 => "00011111", 142 => "11011111", 143 => "11101101", 144 => "11101001", 
    145 => "00111000", 146 => "01000100", 147 => "00110000", 148 => "00100001", 
    149 => "00101110" );


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

entity gap_head_W_HEAD_Vhlb is
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

architecture arch of gap_head_W_HEAD_Vhlb is
    component gap_head_W_HEAD_Vhlb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhlb_rom_U :  component gap_head_W_HEAD_Vhlb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


