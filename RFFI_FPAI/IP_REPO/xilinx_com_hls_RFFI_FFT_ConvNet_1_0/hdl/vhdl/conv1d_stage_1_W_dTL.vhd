-- ==============================================================
-- File generated on Sun Oct 18 16:53:07 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_1_W_dTL_rom is 
    generic(
             DWIDTH     : integer := 7; 
             AWIDTH     : integer := 6; 
             MEM_SIZE    : integer := 48
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of conv1d_stage_1_W_dTL_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "1111110", 1 => "0001111", 2 => "0010010", 3 => "0011010", 
    4 => "0010011", 5 => "0011000", 6 => "0010000", 7 => "0100011", 
    8 => "0001111", 9 => "1111111", 10 => "1110000", 11 => "0001100", 
    12 => "1011011", 13 => "1110001", 14 => "0000010", 15 => "0010100", 
    16 => "0000011", 17 => "0010101", 18 => "0000011", 19 => "0110000", 
    20 => "0001101", 21 => "1111110", 22 => "0000001", 23 => "0001100", 
    24 => "1111011", 25 => "0000011", 26 => "1111110", 27 => "0001001", 
    28 => "0010101", 29 => "0010111", 30 => "0100000", 31 => "0000110", 
    32 => "0011011", 33 => "1111110", 34 => "1110001", 35 => "0001010", 
    36 => "1111010", 37 => "0000000", 38 => "0100111", 39 => "0000111", 
    40 => "0101010", 41 => "0000111", 42 => "0011011", 43 => "0010010", 
    44 => "0001001", 45 => "1111110", 46 => "0010101", 47 => "0001001" );

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

entity conv1d_stage_1_W_dTL is
    generic (
        DataWidth : INTEGER := 7;
        AddressRange : INTEGER := 48;
        AddressWidth : INTEGER := 6);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_1_W_dTL is
    component conv1d_stage_1_W_dTL_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_1_W_dTL_rom_U :  component conv1d_stage_1_W_dTL_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


