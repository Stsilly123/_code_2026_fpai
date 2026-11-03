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

entity conv1d_stage_2_W_cZC_rom is 
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


architecture rtl of conv1d_stage_2_W_cZC_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11110111", 1 => "11001010", 2 => "10001111", 3 => "10111010", 
    4 => "11101101", 5 => "00001110", 6 => "11101001", 7 => "01000100", 
    8 => "00000101", 9 => "00001110", 10 => "10110111", 11 => "11101110", 
    12 => "11000000", 13 => "00000101", 14 => "00001010", 15 => "10101110", 
    16 => "00000111", 17 => "10110000", 18 => "11111011", 19 => "11111010", 
    20 => "00101110", 21 => "11010110", 22 => "11100101", 23 => "00001010", 
    24 => "11100001", 25 => "11011100", 26 => "11010000", 27 => "11101111", 
    28 => "11111001", 29 => "11101011", 30 => "11001011", 31 => "11100010", 
    32 => "11010110", 33 => "00011111", 34 => "00000000", 35 => "11101100", 
    36 => "10111100", 37 => "00110011", 38 => "11010101", 39 => "01011001", 
    40 => "11010010", 41 => "00110110", 42 => "11001000", 43 => "11011000", 
    44 to 45=> "11100101", 46 => "00111000", 47 => "00010000" );

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

entity conv1d_stage_2_W_cZC is
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

architecture arch of conv1d_stage_2_W_cZC is
    component conv1d_stage_2_W_cZC_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_2_W_cZC_rom_U :  component conv1d_stage_2_W_cZC_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


