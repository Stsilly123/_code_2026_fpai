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

entity gap_head_W_HEAD_VhNb_x_rom is 
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


architecture rtl of gap_head_W_HEAD_VhNb_x_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01111011", 1 => "11101111", 2 => "00010010", 3 => "00111000", 
    4 => "00011010", 5 => "00100111", 6 => "10011001", 7 => "00010111", 
    8 => "01011100", 9 => "01110011", 10 => "11100001", 11 => "01010100", 
    12 => "11010110", 13 => "01101010", 14 => "01111001", 15 => "10001110", 
    16 => "00110101", 17 => "01101100", 18 => "00100101", 19 => "00111001", 
    20 => "11110011", 21 => "01111111", 22 => "00001101", 23 => "00110011", 
    24 => "11001101", 25 => "01100100", 26 => "01011101", 27 => "11011111", 
    28 => "00100000", 29 => "10101111", 30 => "01011100", 31 => "11110100", 
    32 => "00101111", 33 => "11111001", 34 => "00111011", 35 => "01001001", 
    36 => "11001101", 37 => "10111001", 38 => "01110010", 39 => "11001100", 
    40 => "01001101", 41 => "00101100", 42 => "10111111", 43 => "11111001", 
    44 => "11101111", 45 => "00011111", 46 => "11011110", 47 => "11110110", 
    48 => "00100001", 49 => "00000011", 50 => "11011110", 51 => "00010101", 
    52 => "00010100", 53 => "11001001", 54 => "11011111", 55 => "10001011", 
    56 => "00100111", 57 => "00110101", 58 => "11100001", 59 => "11110010", 
    60 => "00000110", 61 => "00101010", 62 => "11011111", 63 => "11110010", 
    64 => "00010010", 65 => "11011111", 66 => "11011101", 67 => "00000111", 
    68 => "11011100", 69 => "00101110", 70 => "01101011", 71 => "00110111", 
    72 => "11111100", 73 => "01000011", 74 => "11001101", 75 => "00101000", 
    76 => "01010011", 77 => "11101011", 78 => "10110000", 79 => "10000001", 
    80 => "11001101", 81 => "11110101", 82 => "11111011", 83 => "10010101", 
    84 => "10100101", 85 => "11011110", 86 => "11000101", 87 => "11110001", 
    88 => "01000101", 89 => "11101100", 90 => "10000001", 91 => "11111100", 
    92 => "11110010", 93 => "11010010", 94 => "00101011", 95 => "11100011", 
    96 => "00001000", 97 => "11011010", 98 => "11110110", 99 => "01111111", 
    100 => "11011111", 101 => "00001101", 102 => "00010000", 103 => "11101101", 
    104 => "10110111", 105 => "00010111", 106 => "00000000", 107 => "11011111", 
    108 => "10101001", 109 => "11110011", 110 => "00010010", 111 => "00010000", 
    112 => "11010010", 113 => "01000100", 114 => "11110000", 115 => "11101101", 
    116 => "00110100", 117 => "11010100", 118 => "00110110", 119 => "11110010", 
    120 => "01111111", 121 => "10111010", 122 => "01001000", 123 => "00100111", 
    124 => "11010000", 125 => "01010001", 126 => "00011101", 127 => "11111110", 
    128 => "00000110", 129 => "01001111", 130 => "10011000", 131 => "11011010", 
    132 => "01001101", 133 to 134=> "00001010", 135 => "00111000", 136 => "10110011", 
    137 => "11010111", 138 => "11000101", 139 => "11111100", 140 => "11011011", 
    141 => "00100000", 142 => "01111111", 143 => "00100001", 144 => "00001100", 
    145 => "00101010", 146 => "00010110", 147 => "11010000", 148 => "00010011", 
    149 => "11001001" );


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

entity gap_head_W_HEAD_VhNb_x is
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

architecture arch of gap_head_W_HEAD_VhNb_x is
    component gap_head_W_HEAD_VhNb_x_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VhNb_x_rom_U :  component gap_head_W_HEAD_VhNb_x_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


