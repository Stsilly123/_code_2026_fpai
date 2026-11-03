-- ==============================================================
-- File generated on Sun Oct 18 16:53:13 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_M_PJ_V_rom is 
    generic(
             DWIDTH     : integer := 17; 
             AWIDTH     : integer := 7; 
             MEM_SIZE    : integer := 96
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of conv1d_stage_M_PJ_V_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01001110010101001", 1 => "01011100000000100", 
    2 => "01000100101011100", 3 => "01100111011100100", 
    4 => "01011100001011010", 5 => "01100001111011111", 
    6 => "01100001100101001", 7 => "01001001111001000", 
    8 => "01100011111011100", 9 => "01100000001110111", 
    10 => "01000111101101100", 11 => "00111111011001100", 
    12 => "01011100110100111", 13 => "01010100100011000", 
    14 => "01010110110011000", 15 => "01110011010000001", 
    16 => "01001110011000101", 17 => "00101100001111100", 
    18 => "01001110000111010", 19 => "01001001011100010", 
    20 => "01001001111011010", 21 => "01001110100001010", 
    22 => "01010011100011101", 23 => "01001110110010110", 
    24 => "01011001101111111", 25 => "01101000001001110", 
    26 => "01001111110001000", 27 => "01011010011101110", 
    28 => "01001000100100100", 29 => "01100111111111110", 
    30 => "01010000110010110", 31 => "01011110011101110", 
    32 => "01000110001101010", 33 => "01011111010011010", 
    34 => "01000101000000101", 35 => "01011001000100000", 
    36 => "01000111100011000", 37 => "01001010101100010", 
    38 => "01010110110000001", 39 => "01001000111101100", 
    40 => "01000010010100110", 41 => "01101101110100110", 
    42 => "01010100001111000", 43 => "01100110001011101", 
    44 => "01001110000011100", 45 => "01100010010010011", 
    46 => "01001011011000001", 47 => "01001001001110000", 
    48 => "01001110011101011", 49 => "01100000100100101", 
    50 => "01100001010100011", 51 => "01000011101011000", 
    52 => "01001100101100110", 53 => "01110101101000101", 
    54 => "01000111011101110", 55 => "01000111111000101", 
    56 => "01000011100100100", 57 => "00111010100101101", 
    58 => "01100000101110111", 59 => "01000100111011011", 
    60 => "00111111100011001", 61 => "01011111011000110", 
    62 => "01010001001100011", 63 => "01011010111110011", 
    64 => "01010100100001011", 65 => "01001000000110001", 
    66 => "01011110001101001", 67 => "01010101100010101", 
    68 => "00111101000110100", 69 => "01100110011101101", 
    70 => "10000111100011001", 71 => "01110000000100101", 
    72 => "01000110000111001", 73 => "01100010101101100", 
    74 => "01001001001011010", 75 => "01111111100001110", 
    76 => "01011101011110001", 77 => "01100011100111110", 
    78 => "01000101110111111", 79 => "01010011111011101", 
    80 => "01111100010000100", 81 => "01010001100000110", 
    82 => "01011001100011100", 83 => "01010110011000110", 
    84 => "10000010111111000", 85 => "01001010101000101", 
    86 => "01001100101100010", 87 => "01101101101110000", 
    88 => "01010110100101100", 89 => "01000000000110001", 
    90 => "01110110101100010", 91 => "01010110101100111", 
    92 => "01110001011001011", 93 => "01011000110010001", 
    94 => "01100111011000111", 95 => "01001011101011101" );


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

entity conv1d_stage_M_PJ_V is
    generic (
        DataWidth : INTEGER := 17;
        AddressRange : INTEGER := 96;
        AddressWidth : INTEGER := 7);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_M_PJ_V is
    component conv1d_stage_M_PJ_V_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_M_PJ_V_rom_U :  component conv1d_stage_M_PJ_V_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


