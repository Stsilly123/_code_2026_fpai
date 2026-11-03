-- ==============================================================
-- File generated on Thu Oct 22 20:26:04 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity LcwtMLP_RFFI_PATCrcU_rom is 
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


architecture rtl of LcwtMLP_RFFI_PATCrcU_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "111111100001001", 1 => "000110111001010", 2 => "110101110110001", 
    3 => "111101000000001", 4 => "110000101111000", 5 => "000111100001110", 
    6 => "000000010011010", 7 => "001100000000111", 8 => "000001110001001", 
    9 => "111001100011010", 10 => "110111001100000", 11 => "111100000010011", 
    12 => "000010001100110", 13 => "000110101100011", 14 => "010000011001001", 
    15 => "001000001010000", 16 => "111111000001110", 17 => "010001001010000", 
    18 => "111010101101000", 19 => "111111111001000", 20 => "000100001000111", 
    21 => "000010111101110", 22 => "000010011010101", 23 => "111110001001101", 
    24 => "111111000110011", 25 => "000011011111110", 26 => "000011001000110", 
    27 => "111101101000100", 28 => "000011110011000", 29 => "000011001100100", 
    30 => "111111101110101", 31 => "000010001101101" );

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

entity LcwtMLP_RFFI_PATCrcU is
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

architecture arch of LcwtMLP_RFFI_PATCrcU is
    component LcwtMLP_RFFI_PATCrcU_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    LcwtMLP_RFFI_PATCrcU_rom_U :  component LcwtMLP_RFFI_PATCrcU_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


