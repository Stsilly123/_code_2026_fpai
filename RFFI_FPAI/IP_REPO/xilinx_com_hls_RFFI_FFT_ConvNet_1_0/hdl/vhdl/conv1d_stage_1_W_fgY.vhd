-- ==============================================================
-- File generated on Sun Oct 18 16:53:10 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_1_W_fgY_rom is 
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


architecture rtl of conv1d_stage_1_W_fgY_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110000", 1 => "11001100", 2 => "00101010", 3 => "00011110", 
    4 => "11100001", 5 => "11001000", 6 => "01011000", 7 => "00000010", 
    8 => "10011101", 9 => "11001110", 10 => "11111010", 11 => "11101101", 
    12 => "11000110", 13 => "00010111", 14 => "00011110", 15 => "00001011", 
    16 => "11100000", 17 => "11101100", 18 => "00001001", 19 => "00000101", 
    20 => "00011011", 21 => "11110111", 22 => "00010111", 23 => "11010001", 
    24 => "11111101", 25 => "11111110", 26 => "00000100", 27 => "00001001", 
    28 => "00100011", 29 => "11101011", 30 => "11110111", 31 => "00001111", 
    32 => "00100001", 33 => "00000110", 34 => "11011111", 35 => "00010000", 
    36 => "11111010", 37 => "00001000", 38 => "11111010", 39 => "00011001", 
    40 => "00000101", 41 => "11000011", 42 => "11101101", 43 => "11111001", 
    44 => "00010111", 45 => "01000010", 46 => "11001011", 47 => "00000101" );

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

entity conv1d_stage_1_W_fgY is
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

architecture arch of conv1d_stage_1_W_fgY is
    component conv1d_stage_1_W_fgY_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_1_W_fgY_rom_U :  component conv1d_stage_1_W_fgY_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


