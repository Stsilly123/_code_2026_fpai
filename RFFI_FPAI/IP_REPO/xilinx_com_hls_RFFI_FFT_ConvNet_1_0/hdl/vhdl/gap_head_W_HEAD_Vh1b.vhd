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

entity gap_head_W_HEAD_Vh1b_rom is 
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


architecture rtl of gap_head_W_HEAD_Vh1b_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100101", 1 => "11101010", 2 => "11101100", 3 => "11100111", 
    4 => "00111000", 5 => "00011011", 6 => "00001011", 7 => "00011001", 
    8 => "11110011", 9 => "11110001", 10 => "10111100", 11 => "11101100", 
    12 => "00111000", 13 => "00110110", 14 => "00010100", 15 => "11010110", 
    16 => "00010001", 17 => "11010011", 18 => "00001110", 19 => "11101101", 
    20 => "00100111", 21 => "11010010", 22 => "00000011", 23 => "11111101", 
    24 => "11101101", 25 => "00110001", 26 => "00101011", 27 => "11010110", 
    28 => "11111110", 29 => "00010100", 30 => "00010000", 31 => "10010110", 
    32 => "00100000", 33 => "00101101", 34 => "11011001", 35 => "00101010", 
    36 => "00001111", 37 => "00000010", 38 => "00110010", 39 => "11001111", 
    40 => "00100011", 41 => "00101111", 42 => "00100110", 43 => "00001111", 
    44 => "11111001", 45 => "01010001", 46 => "11110001", 47 => "00011100", 
    48 => "11110110", 49 => "11100011", 50 => "00000011", 51 => "01001000", 
    52 => "11001110", 53 => "10110100", 54 => "11010000", 55 => "11111001", 
    56 => "00110011", 57 => "10011111", 58 => "00101101", 59 => "00001010", 
    60 => "11011111", 61 => "11010011", 62 => "00010001", 63 => "00011000", 
    64 => "00101110", 65 => "00000010", 66 => "11110110", 67 => "11101010", 
    68 => "11100001", 69 => "11011101", 70 => "01001110", 71 => "00001001", 
    72 => "11101011", 73 => "00011010", 74 => "00001000", 75 => "00101111", 
    76 => "00000101", 77 => "00011101", 78 => "11101100", 79 => "11001110", 
    80 => "00000101", 81 => "00110001", 82 => "11111011", 83 => "00001011", 
    84 => "11100000", 85 => "00100111", 86 => "11101100", 87 => "11101110", 
    88 => "00010100", 89 => "01110101", 90 => "11101110", 91 => "11101101", 
    92 => "00010000", 93 => "11010110", 94 => "00001111", 95 => "10100010", 
    96 => "00010000", 97 => "10001011", 98 => "11100100", 99 => "10110001", 
    100 => "11110100", 101 => "11011101", 102 => "00100000", 103 => "00010110", 
    104 => "11000100", 105 => "11111111", 106 => "00010100", 107 => "11100110", 
    108 => "00110001", 109 => "00000111", 110 => "11100110", 111 => "11010000", 
    112 => "00100011", 113 => "11111101", 114 => "11101110", 115 => "00100001", 
    116 => "01011101", 117 => "00001101", 118 => "00100100", 119 => "00101101", 
    120 => "01010000", 121 => "11111111", 122 => "00011100", 123 => "00000001", 
    124 => "00001110", 125 => "00001000", 126 => "11000000", 127 => "11110001", 
    128 => "00100010", 129 => "00110011", 130 => "00101000", 131 => "00101110", 
    132 => "00001011", 133 => "00011110", 134 => "11001100", 135 => "00000011", 
    136 => "11111111", 137 => "00000111", 138 => "11010110", 139 => "11111101", 
    140 => "00011110", 141 => "11011111", 142 => "11110111", 143 => "11110001", 
    144 => "11101111", 145 => "11111101", 146 => "11001000", 147 => "11111111", 
    148 => "00100101", 149 => "00000000" );


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

entity gap_head_W_HEAD_Vh1b is
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

architecture arch of gap_head_W_HEAD_Vh1b is
    component gap_head_W_HEAD_Vh1b_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vh1b_rom_U :  component gap_head_W_HEAD_Vh1b_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


