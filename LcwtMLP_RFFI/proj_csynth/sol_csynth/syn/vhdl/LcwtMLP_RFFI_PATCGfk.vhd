-- ==============================================================
-- File generated on Thu Oct 22 20:22:33 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity LcwtMLP_RFFI_PATCGfk_rom is 
    generic(
             DWIDTH     : integer := 14; 
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


architecture rtl of LcwtMLP_RFFI_PATCGfk_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01011110101001", 1 => "11100110110001", 2 => "00000101001000", 
    3 => "11101111000110", 4 => "11110010000000", 5 => "10111110001100", 
    6 => "11110110111011", 7 => "11101111001110", 8 => "11101110000010", 
    9 => "00000001111110", 10 => "00001000000001", 11 => "00101100000001", 
    12 => "00010100100010", 13 => "00111101101010", 14 => "11011010010100", 
    15 => "00000111010000", 16 => "11111100101110", 17 => "00000001110001", 
    18 => "11110101101111", 19 => "00101000010111", 20 => "11000011100110", 
    21 => "11110110111110", 22 => "00001110110000", 23 => "01001101011111", 
    24 => "00101111100000", 25 => "11111010000001", 26 => "00010011101000", 
    27 => "00000000001100", 28 => "11011010101111", 29 => "11101000101110", 
    30 => "11101100101010", 31 => "11110011111101" );

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

entity LcwtMLP_RFFI_PATCGfk is
    generic (
        DataWidth : INTEGER := 14;
        AddressRange : INTEGER := 32;
        AddressWidth : INTEGER := 5);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of LcwtMLP_RFFI_PATCGfk is
    component LcwtMLP_RFFI_PATCGfk_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    LcwtMLP_RFFI_PATCGfk_rom_U :  component LcwtMLP_RFFI_PATCGfk_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


