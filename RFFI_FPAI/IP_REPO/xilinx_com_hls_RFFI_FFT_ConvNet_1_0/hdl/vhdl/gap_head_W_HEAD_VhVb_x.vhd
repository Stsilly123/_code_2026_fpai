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

entity gap_head_W_HEAD_VhVb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhVb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00011110", 1 to 2=> "11111101", 3 => "00100011", 4 => "11101100", 
    5 => "10111111", 6 => "11111111", 7 => "11011011", 8 => "00110011", 
    9 => "00100001", 10 => "11011110", 11 => "11111101", 12 => "00100001", 
    13 => "11110010", 14 => "00000100", 15 => "00001000", 16 => "00100001", 
    17 => "11111011", 18 => "11101111", 19 => "00001111", 20 => "11101000", 
    21 => "00010010", 22 => "11101111", 23 => "11101110", 24 => "11010101", 
    25 => "11011010", 26 => "11110001", 27 => "11111001", 28 => "11011010", 
    29 => "11101011", 30 => "11110001", 31 => "00000010", 32 => "00100010", 
    33 => "00000100", 34 => "00010111", 35 => "11111110", 36 => "00000000", 
    37 => "11111001", 38 => "11000010", 39 => "00000001", 40 => "11110010", 
    41 => "11111100", 42 => "00101110", 43 => "11111001", 44 => "11101010", 
    45 => "11110000", 46 => "11111001", 47 => "00101110", 48 => "10110000", 
    49 => "11011101", 50 => "00000100", 51 => "00111000", 52 to 53=> "00101001", 
    54 => "11001101", 55 => "00101101", 56 => "11100100", 57 => "00011100", 
    58 => "00110001", 59 => "00011100", 60 => "11100010", 61 => "00010100", 
    62 => "11100010", 63 => "01011101", 64 => "11001101", 65 to 66=> "00001100", 
    67 => "11101111", 68 => "00001110", 69 => "11011001", 70 => "00001000", 
    71 => "11101000", 72 => "01010101", 73 => "00110011", 74 => "00011010", 
    75 => "00010111", 76 => "00000100", 77 => "00101101", 78 => "00000000", 
    79 => "00011011", 80 to 81=> "00000111", 82 => "11101010", 83 => "01001111", 
    84 => "11100010", 85 => "00111111", 86 => "00000100", 87 => "11110001", 
    88 => "11011001", 89 => "11110011", 90 => "00010111", 91 => "11111000", 
    92 => "11011101", 93 => "00010101", 94 => "11101000", 95 => "00011110", 
    96 => "00011010", 97 => "11101010", 98 => "11011000", 99 => "00010100", 
    100 => "11101000", 101 => "00000110", 102 => "11111111", 103 => "11111000", 
    104 => "11100001", 105 => "00010010", 106 => "00001100", 107 => "00111010", 
    108 => "11101010", 109 => "00101010", 110 => "00100001", 111 => "11110111", 
    112 => "00110001", 113 => "10010100", 114 => "00110110", 115 => "11110101", 
    116 => "11101101", 117 => "00011010", 118 => "11111001", 119 => "11101110", 
    120 => "00011100", 121 => "00011000", 122 => "11100100", 123 => "10111010", 
    124 => "11001010", 125 => "11101110", 126 => "00100110", 127 => "11100000", 
    128 => "00011100", 129 => "11111001", 130 => "00001101", 131 to 132=> "11111001", 
    133 => "00000011", 134 => "11100010", 135 => "11111110", 136 => "11111001", 
    137 => "11000000", 138 => "11101010", 139 => "11110010", 140 => "11011000", 
    141 => "11101110", 142 => "11100001", 143 => "00010100", 144 => "00001100", 
    145 => "00100010", 146 => "11011100", 147 => "00101101", 148 => "11110001", 
    149 => "11110111" );


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

entity gap_head_W_HEAD_VhVb_x is
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

architecture arch of gap_head_W_HEAD_VhVb_x is
    component gap_head_W_HEAD_VhVb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhVb_x_rom_U :  component gap_head_W_HEAD_VhVb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


