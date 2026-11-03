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

entity conv1d_stage_1_W_fdY_rom is 
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


architecture rtl of conv1d_stage_1_W_fdY_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "1111110", 1 => "1110000", 2 => "0000110", 3 => "1011101", 
    4 => "1101111", 5 => "0010001", 6 => "1111011", 7 => "1011111", 
    8 => "1110001", 9 => "0000101", 10 => "0000001", 11 => "1110001", 
    12 => "1110011", 13 => "1110010", 14 => "0000000", 15 => "0000011", 
    16 => "0010011", 17 => "0000010", 18 => "1010000", 19 => "1110010", 
    20 => "1000011", 21 => "1111110", 22 => "1110111", 23 => "0011000", 
    24 => "0100010", 25 => "1101110", 26 => "0010111", 27 => "1111000", 
    28 => "1110001", 29 => "0001110", 30 => "1111011", 31 => "1100110", 
    32 => "1111010", 33 => "1111101", 34 => "1100011", 35 => "1111001", 
    36 => "1010111", 37 => "1100101", 38 => "0001011", 39 => "1001001", 
    40 => "1011000", 41 => "1011100", 42 => "1111111", 43 => "1110101", 
    44 => "0001101", 45 => "1111011", 46 => "0000000", 47 => "0011101" );

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

entity conv1d_stage_1_W_fdY is
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

architecture arch of conv1d_stage_1_W_fdY is
    component conv1d_stage_1_W_fdY_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_1_W_fdY_rom_U :  component conv1d_stage_1_W_fdY_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


