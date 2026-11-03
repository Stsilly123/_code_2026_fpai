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

entity gap_head_W_HEAD_VgQb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgQb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11000011", 1 => "11111010", 2 => "00011100", 3 => "00010100", 
    4 => "00011100", 5 => "00000010", 6 => "11001110", 7 => "00000010", 
    8 => "00100010", 9 => "11100111", 10 => "00011101", 11 => "01010110", 
    12 => "11010001", 13 => "11111111", 14 => "00100011", 15 => "00010111", 
    16 => "11111001", 17 => "11110111", 18 => "00000010", 19 => "11100101", 
    20 => "00011101", 21 => "01000111", 22 => "00101111", 23 => "11110011", 
    24 => "11110001", 25 => "00110011", 26 => "00000010", 27 => "11101111", 
    28 => "00001100", 29 => "11100001", 30 => "00001010", 31 => "01000000", 
    32 => "11101010", 33 => "00000101", 34 => "00000011", 35 => "11101101", 
    36 => "11111101", 37 => "00001011", 38 => "11111011", 39 => "00010101", 
    40 => "11010110", 41 => "00001010", 42 => "11101101", 43 => "11101011", 
    44 => "00001100", 45 => "11110011", 46 => "00000010", 47 => "11011010", 
    48 => "11110001", 49 => "11101000", 50 => "00011010", 51 => "00001010", 
    52 => "00001000", 53 => "11010011", 54 => "01000101", 55 => "00000111", 
    56 => "00010001", 57 => "00000011", 58 => "11111100", 59 => "00101110", 
    60 => "00011010", 61 => "00000101", 62 => "11101100", 63 => "11001000", 
    64 => "00000011", 65 => "00001010", 66 => "11011011", 67 => "11100001", 
    68 => "11010110", 69 => "00010001", 70 => "11111101", 71 => "00000111", 
    72 => "11001101", 73 => "11101010", 74 => "11110010", 75 => "11001101", 
    76 => "00010001", 77 => "11101100", 78 => "11101110", 79 => "00010001", 
    80 => "11111100", 81 => "11011011", 82 => "11001110", 83 => "11110001", 
    84 => "10011011", 85 => "11111111", 86 => "00000011", 87 => "00010010", 
    88 => "11111111", 89 => "11100101", 90 => "00001100", 91 => "00010000", 
    92 => "11101100", 93 => "00101101", 94 => "11101101", 95 => "00001101", 
    96 => "11100111", 97 => "00101100", 98 => "00100001", 99 => "00111111", 
    100 => "00011100", 101 => "00001110", 102 => "00010101", 103 => "00011000", 
    104 => "00100111", 105 => "11001010", 106 => "11101011", 107 => "11111000", 
    108 => "11011101", 109 => "11010001", 110 => "00000000", 111 => "00000111", 
    112 => "11011100", 113 => "11111000", 114 => "00001101", 115 => "11011111", 
    116 => "00011111", 117 => "11110011", 118 => "11111001", 119 => "00010101", 
    120 => "10100011", 121 => "11101000", 122 => "11100001", 123 => "00011000", 
    124 => "00110100", 125 => "00000000", 126 => "00111001", 127 => "00000000", 
    128 => "10101101", 129 => "11111111", 130 => "00000110", 131 => "00011000", 
    132 => "00011011", 133 => "00000001", 134 => "00100111", 135 => "00000101", 
    136 => "11111001", 137 => "00001110", 138 => "11011111", 139 => "00010010", 
    140 => "11101110", 141 => "11110011", 142 => "11111000", 143 => "00001010", 
    144 => "11100111", 145 => "00011010", 146 => "11100011", 147 => "11011001", 
    148 => "01001110", 149 => "00011101" );


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

entity gap_head_W_HEAD_VgQb is
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

architecture arch of gap_head_W_HEAD_VgQb is
    component gap_head_W_HEAD_VgQb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgQb_rom_U :  component gap_head_W_HEAD_VgQb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


