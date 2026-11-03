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

entity gap_head_W_HEAD_VhQb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhQb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101110", 1 => "00100101", 2 => "11011010", 3 => "11101001", 
    4 => "00100011", 5 => "11101110", 6 => "00110011", 7 => "11011010", 
    8 => "11000110", 9 => "11100101", 10 => "11100100", 11 => "11111011", 
    12 => "00000111", 13 => "11011011", 14 => "10111100", 15 => "11011011", 
    16 => "11100111", 17 => "11010110", 18 => "11111100", 19 => "00100001", 
    20 => "00111010", 21 => "11000100", 22 => "00000110", 23 => "11010111", 
    24 => "00000010", 25 => "11101101", 26 => "11110110", 27 => "00001111", 
    28 => "11100110", 29 => "11100111", 30 => "00000110", 31 => "00110110", 
    32 => "11100111", 33 => "00001001", 34 => "11001111", 35 => "00010110", 
    36 => "11011011", 37 => "00011100", 38 => "11011110", 39 => "11110110", 
    40 => "00010100", 41 => "01000111", 42 => "11000111", 43 => "11011111", 
    44 => "11101011", 45 => "11001010", 46 => "11111001", 47 => "11111011", 
    48 => "11111001", 49 => "11100000", 50 => "00110101", 51 => "11101111", 
    52 => "00011110", 53 => "01111111", 54 to 55=> "00101011", 56 => "11100011", 
    57 => "00000100", 58 => "11001110", 59 => "11101000", 60 => "11101011", 
    61 => "00110100", 62 => "11110001", 63 => "11101000", 64 => "11010101", 
    65 => "11110111", 66 => "01100100", 67 => "00101010", 68 => "00010100", 
    69 => "11100111", 70 => "00110101", 71 => "11000001", 72 => "11111111", 
    73 => "11100001", 74 => "11100010", 75 => "01011010", 76 => "11001001", 
    77 => "00010010", 78 => "11101111", 79 => "11110110", 80 => "11111110", 
    81 => "00000010", 82 => "11011110", 83 => "00010100", 84 => "00001001", 
    85 => "11101111", 86 => "00110110", 87 => "00000000", 88 => "10111110", 
    89 => "11111000", 90 => "00111101", 91 => "11111010", 92 => "11110101", 
    93 => "01001100", 94 => "01010100", 95 => "00100101", 96 => "00000101", 
    97 => "00010000", 98 => "11111000", 99 => "10011001", 100 => "11111001", 
    101 => "11100101", 102 => "00100010", 103 => "01110110", 104 => "11111101", 
    105 => "00101110", 106 => "00100111", 107 => "11111100", 108 => "11100011", 
    109 => "00010111", 110 => "01011001", 111 => "11110011", 112 => "00000001", 
    113 => "11101100", 114 => "10101001", 115 => "11111011", 116 => "11100010", 
    117 => "11111001", 118 => "00010000", 119 => "11110011", 120 => "00001011", 
    121 => "00000100", 122 => "11001010", 123 => "00010100", 124 => "00101101", 
    125 => "11110010", 126 => "11101111", 127 => "11100101", 128 to 129=> "11011100", 
    130 => "00001101", 131 => "00111010", 132 => "00101100", 133 => "00110001", 
    134 => "00010000", 135 => "11111111", 136 => "00010100", 137 => "11010000", 
    138 => "00011000", 139 => "00000110", 140 => "11011101", 141 => "00110110", 
    142 => "00110000", 143 => "11010111", 144 => "11100100", 145 => "11101101", 
    146 => "00011000", 147 => "11111000", 148 => "01001100", 149 => "00111001" );


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

entity gap_head_W_HEAD_VhQb_x is
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

architecture arch of gap_head_W_HEAD_VhQb_x is
    component gap_head_W_HEAD_VhQb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhQb_x_rom_U :  component gap_head_W_HEAD_VhQb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


