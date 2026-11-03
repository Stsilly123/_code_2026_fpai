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

entity gap_head_W_HEAD_VhHb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhHb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10011011", 1 => "00111111", 2 => "00000100", 3 => "00001101", 
    4 => "11000011", 5 => "10110111", 6 => "01001000", 7 => "00110111", 
    8 => "00101010", 9 => "11100100", 10 => "00110111", 11 => "01011010", 
    12 => "00010111", 13 => "00011000", 14 => "01100010", 15 => "01111111", 
    16 => "11111001", 17 => "00100011", 18 => "00001111", 19 => "00011001", 
    20 => "10111010", 21 => "01101100", 22 => "01110001", 23 => "00110010", 
    24 => "11100000", 25 => "10011110", 26 => "00111011", 27 => "00001110", 
    28 => "11100000", 29 => "11100111", 30 => "11101101", 31 => "01010011", 
    32 => "11111000", 33 => "11001111", 34 => "11010011", 35 => "11111000", 
    36 => "11110001", 37 => "11011101", 38 => "00011010", 39 => "11111011", 
    40 => "11011010", 41 => "11011110", 42 => "11011111", 43 => "01000000", 
    44 => "11011011", 45 => "11001010", 46 => "01011110", 47 => "00101111", 
    48 => "10100000", 49 => "11111110", 50 => "11000101", 51 => "01000010", 
    52 => "00101000", 53 => "11101100", 54 => "11011111", 55 => "01000010", 
    56 => "11100001", 57 => "11001001", 58 => "11001110", 59 => "11101011", 
    60 => "11110001", 61 => "11101000", 62 => "00101010", 63 => "00011111", 
    64 => "10110001", 65 => "11010100", 66 => "11111001", 67 => "00100001", 
    68 => "11111000", 69 => "01000000", 70 => "11000000", 71 => "11011110", 
    72 => "00000011", 73 => "10111011", 74 => "11101100", 75 => "00011110", 
    76 => "00011101", 77 => "00011111", 78 => "00100110", 79 => "00100001", 
    80 => "11110111", 81 => "11010110", 82 => "10100011", 83 => "00011001", 
    84 => "00010111", 85 => "11011110", 86 => "11011111", 87 => "11100001", 
    88 => "11001100", 89 => "10111101", 90 => "00010010", 91 => "00100100", 
    92 => "00011001", 93 => "11100011", 94 => "10111101", 95 => "01000110", 
    96 => "01001101", 97 => "00010000", 98 => "01010001", 99 => "01001001", 
    100 => "00101100", 101 => "11110001", 102 => "00011111", 103 => "00000101", 
    104 => "01001000", 105 => "00000000", 106 => "01000011", 107 => "10110011", 
    108 => "11010000", 109 => "11101101", 110 => "00101001", 111 => "00111010", 
    112 => "00011001", 113 => "11101101", 114 => "11111011", 115 => "00010010", 
    116 => "11000100", 117 => "11010000", 118 => "10101110", 119 => "01010110", 
    120 => "00101010", 121 to 122=> "00010001", 123 => "11000110", 124 => "11101001", 
    125 => "00101101", 126 => "00101010", 127 => "01010100", 128 => "11110101", 
    129 => "01000100", 130 => "11111011", 131 => "10110100", 132 => "11100001", 
    133 => "00010001", 134 => "11111011", 135 => "11010001", 136 => "11110011", 
    137 => "11011010", 138 => "00011111", 139 => "00100110", 140 => "11010011", 
    141 => "11111101", 142 => "11101100", 143 => "01111111", 144 => "01011000", 
    145 => "00100011", 146 => "01101101", 147 => "11100100", 148 => "11011000", 
    149 => "00001000" );


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

entity gap_head_W_HEAD_VhHb_x is
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

architecture arch of gap_head_W_HEAD_VhHb_x is
    component gap_head_W_HEAD_VhHb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhHb_x_rom_U :  component gap_head_W_HEAD_VhHb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


