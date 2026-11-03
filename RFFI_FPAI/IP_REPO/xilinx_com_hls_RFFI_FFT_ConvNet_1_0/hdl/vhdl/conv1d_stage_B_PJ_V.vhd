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

entity conv1d_stage_B_PJ_V_rom is 
    generic(
             DWIDTH     : integer := 12; 
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


architecture rtl of conv1d_stage_B_PJ_V_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "111000110111", 1 => "000000011110", 2 => "010001111010", 
    3 => "000110011000", 4 => "111000000111", 5 => "110110000111", 
    6 => "111111111111", 7 => "111111110001", 8 => "111100101101", 
    9 => "111110011001", 10 => "001010001001", 11 => "000001111011", 
    12 => "000010100001", 13 => "001010100011", 14 => "110001101000", 
    15 => "111100100000", 16 => "111001110100", 17 => "111111000001", 
    18 => "000111001111", 19 => "001000101110", 20 => "010000010001", 
    21 => "111111010101", 22 => "111101010101", 23 => "111000100011", 
    24 => "000010001100", 25 => "110111011000", 26 => "111111100110", 
    27 => "000011101010", 28 => "000000001110", 29 => "110111111010", 
    30 => "001011101100", 31 => "111001000000", 32 => "110001011100", 
    33 => "001001110100", 34 => "111101111111", 35 => "111001000010", 
    36 => "001000111100", 37 => "000110100010", 38 => "111101110100", 
    39 => "111010111101", 40 => "010001110011", 41 => "000100110100", 
    42 => "110011111011", 43 => "000011110100", 44 => "111010111110", 
    45 => "111111001101", 46 => "000000000110", 47 => "001110111001", 
    48 => "111100110111", 49 => "110111011110", 50 => "001001111000", 
    51 => "110101010000", 52 => "001011100101", 53 => "111100011010", 
    54 => "000010000011", 55 => "000111000110", 56 => "000100000001", 
    57 => "111101000110", 58 => "000010010101", 59 => "000100111101", 
    60 => "001001100100", 61 => "111101011100", 62 => "110010110100", 
    63 => "001000100110", 64 => "110100110001", 65 => "000111100101", 
    66 => "000110101101", 67 => "000100100111", 68 => "111100100010", 
    69 => "111110001100", 70 => "000000011000", 71 => "111001011001", 
    72 => "110000001110", 73 => "111101101010", 74 => "111101111100", 
    75 => "001100000100", 76 => "111111000100", 77 => "000011000100", 
    78 => "110101100010", 79 => "000001100100", 80 => "111001111011", 
    81 => "111101001001", 82 => "110111101111", 83 => "001011000000", 
    84 => "111100110111", 85 => "110110010111", 86 => "111001000001", 
    87 => "111100111100", 88 => "000011000011", 89 => "111010010110", 
    90 => "000010010110", 91 => "000111101101", 92 => "111011101110", 
    93 => "111001000111", 94 => "000000110000", 95 => "000110000010" );


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

entity conv1d_stage_B_PJ_V is
    generic (
        DataWidth : INTEGER := 12;
        AddressRange : INTEGER := 96;
        AddressWidth : INTEGER := 7);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_B_PJ_V is
    component conv1d_stage_B_PJ_V_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_B_PJ_V_rom_U :  component conv1d_stage_B_PJ_V_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


