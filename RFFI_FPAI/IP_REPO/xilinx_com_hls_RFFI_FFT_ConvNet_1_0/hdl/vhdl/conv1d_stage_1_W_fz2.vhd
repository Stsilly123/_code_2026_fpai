-- ==============================================================
-- File generated on Sun Oct 18 16:53:11 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_1_W_fz2_rom is 
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


architecture rtl of conv1d_stage_1_W_fz2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "1010001", 1 => "1110011", 2 => "1110111", 3 => "0001000", 
    4 => "1100111", 5 => "0010110", 6 => "1010001", 7 => "1100100", 
    8 => "0100000", 9 => "1111011", 10 => "1100110", 11 => "1110001", 
    12 => "0100110", 13 => "1111001", 14 => "0010010", 15 => "1111100", 
    16 => "1000001", 17 => "1101101", 18 => "0000100", 19 => "1100110", 
    20 => "1110110", 21 => "0001100", 22 => "1101011", 23 => "1110000", 
    24 => "1111110", 25 => "0100110", 26 => "0001000", 27 => "0000101", 
    28 => "0001101", 29 => "1101000", 30 => "1101111", 31 => "1011110", 
    32 => "1100101", 33 => "0110011", 34 => "0010000", 35 => "1111000", 
    36 => "1101001", 37 => "0000001", 38 => "1101010", 39 => "1010110", 
    40 => "1110101", 41 => "0011100", 42 => "0000010", 43 => "0010110", 
    44 => "0000110", 45 => "1100000", 46 => "1111000", 47 => "1110111" );

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

entity conv1d_stage_1_W_fz2 is
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

architecture arch of conv1d_stage_1_W_fz2 is
    component conv1d_stage_1_W_fz2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_1_W_fz2_rom_U :  component conv1d_stage_1_W_fz2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


