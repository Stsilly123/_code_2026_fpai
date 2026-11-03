-- ==============================================================
-- File generated on Sun Oct 18 16:53:06 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_2_W_c7D_rom is 
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


architecture rtl of conv1d_stage_2_W_c7D_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "0001101", 1 => "1110101", 2 => "1111000", 3 => "1111100", 
    4 => "0001001", 5 => "0001000", 6 => "0000100", 7 => "1111000", 
    8 => "1101011", 9 => "1111001", 10 => "0101111", 11 => "0010011", 
    12 => "1101001", 13 => "1101101", 14 => "0000100", 15 => "1101111", 
    16 => "0000001", 17 => "1101010", 18 => "0000011", 19 => "1111010", 
    20 => "0010110", 21 to 22=> "0000100", 23 => "0011110", 24 => "0000010", 
    25 => "0000001", 26 => "1111001", 27 => "0001110", 28 => "1110010", 
    29 => "0010110", 30 => "1111001", 31 => "0001001", 32 => "1101010", 
    33 => "0011100", 34 => "1110110", 35 => "1111100", 36 => "1001000", 
    37 => "0010111", 38 => "1111100", 39 => "1101010", 40 => "1101001", 
    41 => "0101111", 42 => "1010100", 43 => "1110101", 44 => "0000000", 
    45 => "0001000", 46 => "0000111", 47 => "1010110" );

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

entity conv1d_stage_2_W_c7D is
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

architecture arch of conv1d_stage_2_W_c7D is
    component conv1d_stage_2_W_c7D_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_2_W_c7D_rom_U :  component conv1d_stage_2_W_c7D_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


