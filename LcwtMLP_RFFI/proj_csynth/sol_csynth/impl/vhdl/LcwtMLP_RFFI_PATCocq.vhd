-- ==============================================================
-- File generated on Thu Oct 22 20:22:32 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity LcwtMLP_RFFI_PATCocq_rom is 
    generic(
             DWIDTH     : integer := 15; 
             AWIDTH     : integer := 5; 
             MEM_SIZE    : integer := 32
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of LcwtMLP_RFFI_PATCocq_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "001000011110101", 1 => "001100110011100", 2 => "111011101010011", 
    3 => "001010010000110", 4 => "111000011010011", 5 => "001010011101111", 
    6 => "110110101001110", 7 => "000111111110001", 8 => "000101000110100", 
    9 => "001000001011010", 10 => "111000010001101", 11 => "010011100011101", 
    12 => "001011000110011", 13 => "001101010100000", 14 => "111111011010111", 
    15 => "000110101000010", 16 => "001110011010111", 17 => "111110100001010", 
    18 => "111011001111011", 19 => "110100110010100", 20 => "000101111110100", 
    21 => "110100111001101", 22 => "111010110101010", 23 => "001000100011111", 
    24 => "000110001000000", 25 => "000000111010011", 26 => "111100111011011", 
    27 => "001001111011010", 28 => "111101010010100", 29 => "111101001110111", 
    30 => "001010010111101", 31 => "000111010010001" );

attribute syn_rom_style : string;
attribute syn_rom_style of mem : signal is "select_rom";
attribute ROM_STYLE : string;
attribute ROM_STYLE of mem : signal is "distributed";

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

entity LcwtMLP_RFFI_PATCocq is
    generic (
        DataWidth : INTEGER := 15;
        AddressRange : INTEGER := 32;
        AddressWidth : INTEGER := 5);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of LcwtMLP_RFFI_PATCocq is
    component LcwtMLP_RFFI_PATCocq_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    LcwtMLP_RFFI_PATCocq_rom_U :  component LcwtMLP_RFFI_PATCocq_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


