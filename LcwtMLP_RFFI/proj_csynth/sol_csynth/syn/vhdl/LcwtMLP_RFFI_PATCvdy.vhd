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

entity LcwtMLP_RFFI_PATCvdy_rom is 
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


architecture rtl of LcwtMLP_RFFI_PATCvdy_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "110010111000000", 1 => "111100001101110", 2 => "111011011110011", 
    3 => "111010111110011", 4 => "110110011011110", 5 => "111001010001001", 
    6 => "000110100001010", 7 => "000111001100010", 8 => "110100111100111", 
    9 => "111100110000000", 10 => "001011001010000", 11 => "111001101001010", 
    12 => "111011011111101", 13 => "000110001001111", 14 => "000110011010110", 
    15 => "111100001001011", 16 => "110000100010111", 17 => "111011001010110", 
    18 => "001001000110011", 19 => "000001010101110", 20 => "111011110000011", 
    21 => "000000000011110", 22 => "000010011001110", 23 => "110010000111111", 
    24 => "111011101101100", 25 => "000011101111001", 26 => "111010010000001", 
    27 => "100011010001100", 28 => "000000010100011", 29 => "000001110001001", 
    30 => "110010101001101", 31 => "110111001110100" );

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

entity LcwtMLP_RFFI_PATCvdy is
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

architecture arch of LcwtMLP_RFFI_PATCvdy is
    component LcwtMLP_RFFI_PATCvdy_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    LcwtMLP_RFFI_PATCvdy_rom_U :  component LcwtMLP_RFFI_PATCvdy_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


