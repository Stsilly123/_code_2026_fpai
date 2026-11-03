-- ==============================================================
-- File generated on Sun Oct 18 16:53:05 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_2_W_cCy_rom is 
    generic(
             DWIDTH     : integer := 8; 
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


architecture rtl of conv1d_stage_2_W_cCy_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11111000", 1 => "11000110", 2 => "00000000", 3 => "11111100", 
    4 => "00010001", 5 => "11011111", 6 => "11101000", 7 => "11011001", 
    8 => "00000110", 9 => "11110011", 10 => "11100111", 11 => "00000000", 
    12 => "00000101", 13 => "10000001", 14 => "11111110", 15 => "11101011", 
    16 => "11111111", 17 to 18=> "00000001", 19 => "10101110", 20 => "10010011", 
    21 => "00000111", 22 => "00010001", 23 => "11111001", 24 => "11101111", 
    25 => "11101100", 26 => "11000011", 27 => "11000110", 28 => "00010010", 
    29 => "00001110", 30 => "11101010", 31 => "11110110", 32 => "00010000", 
    33 => "10110110", 34 => "11110000", 35 => "00000110", 36 => "11100111", 
    37 => "11111000", 38 => "11110011", 39 => "11011110", 40 => "10111111", 
    41 => "11111111", 42 => "11111101", 43 => "00001010", 44 => "11000011", 
    45 => "11111110", 46 => "11000110", 47 => "00000110" );

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

entity conv1d_stage_2_W_cCy is
    generic (
        DataWidth : INTEGER := 8;
        AddressRange : INTEGER := 48;
        AddressWidth : INTEGER := 6);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_2_W_cCy is
    component conv1d_stage_2_W_cCy_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_2_W_cCy_rom_U :  component conv1d_stage_2_W_cCy_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


