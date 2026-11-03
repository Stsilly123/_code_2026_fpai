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

entity gap_head_W_HEAD_Vhpb_rom is 
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


architecture rtl of gap_head_W_HEAD_Vhpb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00011111", 1 => "11011010", 2 => "00000101", 3 => "00100111", 
    4 => "10110101", 5 => "10011000", 6 => "11001110", 7 => "11100110", 
    8 => "00010001", 9 => "11100101", 10 => "11100110", 11 => "00010110", 
    12 => "11110100", 13 => "00010000", 14 => "11110110", 15 => "00010011", 
    16 => "00010101", 17 => "00000101", 18 => "00000010", 19 => "00001100", 
    20 => "01111111", 21 => "00110100", 22 => "11111101", 23 => "00011000", 
    24 => "00110011", 25 => "00001011", 26 => "10101110", 27 => "11101010", 
    28 => "00011101", 29 => "00110100", 30 => "00010101", 31 => "00011111", 
    32 => "00011000", 33 => "11101001", 34 => "00001010", 35 => "11101111", 
    36 => "00000111", 37 => "11111000", 38 => "11000100", 39 => "11010000", 
    40 => "00001000", 41 => "00001010", 42 => "11101011", 43 => "11000011", 
    44 => "01001000", 45 => "11101111", 46 => "00000010", 47 => "11101010", 
    48 => "00100101", 49 => "00010010", 50 => "00100010", 51 => "00011110", 
    52 => "11111000", 53 => "00010001", 54 => "11110011", 55 => "10111001", 
    56 => "00000010", 57 => "00101101", 58 => "00101000", 59 => "01000011", 
    60 => "00100110", 61 => "10110001", 62 => "00010100", 63 to 64=> "00000111", 
    65 => "00101010", 66 => "11000110", 67 => "00011111", 68 to 69=> "11111011", 
    70 => "11110100", 71 => "00101011", 72 => "00001011", 73 => "00010011", 
    74 => "00000111", 75 => "00001111", 76 => "00000011", 77 => "11000100", 
    78 => "00000100", 79 => "00000101", 80 => "00000111", 81 => "11111000", 
    82 => "00001011", 83 => "11000110", 84 => "00010011", 85 => "11110100", 
    86 => "10110001", 87 => "11010100", 88 => "01011100", 89 => "00110101", 
    90 => "11110011", 91 => "11010100", 92 => "00000011", 93 => "00000000", 
    94 => "11111001", 95 => "00011100", 96 => "11001011", 97 => "00110111", 
    98 => "00010010", 99 => "00000111", 100 => "11001001", 101 => "10110111", 
    102 => "11010010", 103 => "10101100", 104 => "00100101", 105 => "00000010", 
    106 => "11100001", 107 => "11010110", 108 => "00001110", 109 => "11011011", 
    110 => "00100010", 111 => "00000101", 112 => "00011100", 113 => "00110001", 
    114 => "00100000", 115 => "00011100", 116 => "11001100", 117 => "00000101", 
    118 => "11110001", 119 => "11100100", 120 => "00101010", 121 => "11011110", 
    122 => "00010010", 123 => "11101110", 124 => "11000001", 125 => "11100001", 
    126 => "01001000", 127 => "00011001", 128 => "00010100", 129 => "11100101", 
    130 => "10111000", 131 => "00010000", 132 => "11111111", 133 => "11101100", 
    134 => "11100001", 135 => "11101110", 136 => "00110000", 137 => "11010011", 
    138 => "00010101", 139 => "11100010", 140 => "11101000", 141 => "11101010", 
    142 => "11111100", 143 => "00000011", 144 => "00101000", 145 => "11001001", 
    146 => "11010000", 147 => "11101101", 148 => "11110000", 149 => "00010011" );


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

entity gap_head_W_HEAD_Vhpb is
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

architecture arch of gap_head_W_HEAD_Vhpb is
    component gap_head_W_HEAD_Vhpb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    gap_head_W_HEAD_Vhpb_rom_U :  component gap_head_W_HEAD_Vhpb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


