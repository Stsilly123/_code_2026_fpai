-- ==============================================================
-- File generated on Sun Oct 18 16:53:14 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity gap_head_W_HEAD_VgPb_rom is 
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


architecture rtl of gap_head_W_HEAD_VgPb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010100", 1 => "00001001", 2 => "11111010", 3 => "00010000", 
    4 => "00010110", 5 => "11011011", 6 => "01011000", 7 => "00111110", 
    8 => "00011111", 9 => "11000010", 10 => "11011100", 11 => "11010000", 
    12 => "00100000", 13 => "00011011", 14 => "11011001", 15 => "00110001", 
    16 => "01001010", 17 => "00100100", 18 => "00000010", 19 => "11110011", 
    20 => "00100110", 21 => "00010100", 22 => "10101010", 23 => "11011011", 
    24 => "11100100", 25 => "00010101", 26 => "11101001", 27 => "11101100", 
    28 => "00010111", 29 => "00010011", 30 => "11111001", 31 => "10110101", 
    32 => "00000101", 33 => "11101110", 34 => "00010001", 35 => "11111100", 
    36 => "11101011", 37 => "00011101", 38 => "11100001", 39 => "00101000", 
    40 => "00011001", 41 => "11101101", 42 => "00101100", 43 => "00100101", 
    44 => "11000001", 45 => "11011110", 46 => "11110010", 47 => "00111111", 
    48 => "11111010", 49 => "00101011", 50 => "00011100", 51 => "00000011", 
    52 => "11001000", 53 => "00000001", 54 => "11011111", 55 => "00010100", 
    56 => "11101110", 57 => "11010100", 58 => "11110011", 59 => "11100001", 
    60 => "00000011", 61 => "11010100", 62 => "11101000", 63 => "11110010", 
    64 => "11101110", 65 => "11011101", 66 => "11010110", 67 => "00010010", 
    68 => "00001010", 69 => "00110010", 70 => "11111001", 71 => "11010101", 
    72 => "00100000", 73 => "11100101", 74 => "11101001", 75 => "00011110", 
    76 => "00100100", 77 => "00000001", 78 => "00010110", 79 => "00010111", 
    80 => "00110011", 81 => "11110111", 82 => "00001001", 83 => "11111010", 
    84 => "00101100", 85 => "00101000", 86 => "11111001", 87 => "00100000", 
    88 => "00001011", 89 => "11110100", 90 => "00101111", 91 => "00000100", 
    92 => "00000010", 93 => "00100100", 94 => "11110111", 95 => "00100000", 
    96 => "11101010", 97 => "11111100", 98 => "00100001", 99 => "00001110", 
    100 => "01011010", 101 => "10111010", 102 => "11111111", 103 => "00000010", 
    104 => "00101001", 105 => "00011101", 106 => "11110110", 107 => "11101011", 
    108 => "00011100", 109 => "11111101", 110 => "11011010", 111 => "00011011", 
    112 => "11111110", 113 => "00101010", 114 => "01100001", 115 => "11101001", 
    116 => "11100011", 117 => "11001011", 118 => "10111000", 119 => "00100000", 
    120 => "00000001", 121 => "00001011", 122 => "00101000", 123 => "00000110", 
    124 => "00001111", 125 => "11010110", 126 => "00111011", 127 => "00010001", 
    128 => "11100010", 129 => "00101110", 130 => "01010100", 131 => "11100100", 
    132 => "11010111", 133 => "00111001", 134 => "00010000", 135 => "11010010", 
    136 => "11110000", 137 => "11000100", 138 => "11110101", 139 => "00000111", 
    140 => "11111101", 141 => "11110101", 142 => "11001111", 143 => "00011010", 
    144 => "11100000", 145 => "11111101", 146 => "11010001", 147 => "00011100", 
    148 => "00001001", 149 => "00111010" );


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

entity gap_head_W_HEAD_VgPb is
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

architecture arch of gap_head_W_HEAD_VgPb is
    component gap_head_W_HEAD_VgPb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_VgPb_rom_U :  component gap_head_W_HEAD_VgPb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


