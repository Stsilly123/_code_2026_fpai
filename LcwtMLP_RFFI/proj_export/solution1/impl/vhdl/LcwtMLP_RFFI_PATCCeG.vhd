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

entity LcwtMLP_RFFI_PATCCeG_rom is 
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


architecture rtl of LcwtMLP_RFFI_PATCCeG_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "110000001001000", 1 => "111011011101011", 2 => "001011110100011", 
    3 => "000000011101111", 4 => "110111101000001", 5 => "111010000010111", 
    6 => "111110001001010", 7 => "111111111111010", 8 => "110110100001111", 
    9 => "000000010000000", 10 => "111111001011001", 11 => "111010001100110", 
    12 => "000101001110110", 13 => "000110110110110", 14 => "111111110110110", 
    15 => "000111011001011", 16 => "111110101110110", 17 => "111100010010011", 
    18 => "000101101000010", 19 => "000111011111001", 20 => "110111010100000", 
    21 => "000000110011101", 22 => "000010110010011", 23 => "111101001001001", 
    24 => "010011010110100", 25 => "111101110101001", 26 => "101111011110011", 
    27 => "111011000001110", 28 => "000011101000110", 29 => "000010110000111", 
    30 => "111101010110100", 31 => "000010011000110" );

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

entity LcwtMLP_RFFI_PATCCeG is
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

architecture arch of LcwtMLP_RFFI_PATCCeG is
    component LcwtMLP_RFFI_PATCCeG_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    LcwtMLP_RFFI_PATCCeG_rom_U :  component LcwtMLP_RFFI_PATCCeG_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


