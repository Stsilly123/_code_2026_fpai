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

entity conv1d_stage_1_M_fK3_rom is 
    generic(
             DWIDTH     : integer := 17; 
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


architecture rtl of conv1d_stage_1_M_fK3_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00111000011101100", 1 => "01001010011011101", 
    2 => "00110110010101110", 3 => "01000100000101111", 
    4 => "00101001010100000", 5 => "00101010001110000", 
    6 => "00100110010111010", 7 => "00110110111011000", 
    8 => "00110000101101110", 9 => "00100110011100000", 
    10 => "01000000101101101", 11 => "01000110011001000", 
    12 => "00100111101110111", 13 => "00111011011000110", 
    14 => "01001000011111100", 15 => "10000110111101101", 
    16 => "00111101011010000", 17 => "01000101001100011", 
    18 => "00101001110010110", 19 => "00111100000110101", 
    20 => "00101010000101111", 21 => "01010101101101000", 
    22 => "00101100000100111", 23 => "00111011101011010", 
    24 => "01001001111001001", 25 => "00101111100000001", 
    26 => "01000100001001111", 27 => "00110000101000001", 
    28 => "01000101011111110", 29 => "00110001111011000", 
    30 => "00110000110101110", 31 => "01010101000001001", 
    32 => "01001010111001101", 33 => "01010110111011000", 
    34 => "01001010101110101", 35 => "01001101101011111", 
    36 => "00111000000011011", 37 => "01010100101001000", 
    38 => "00111010001101010", 39 => "00101000011110101", 
    40 => "00110001101000010", 41 => "00110100000011001", 
    42 => "01000100100011010", 43 => "00111000100110011", 
    44 => "01001001101111111", 45 => "00011100101001100", 
    46 => "00111111111010011", 47 => "00110010100111110" );

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

entity conv1d_stage_1_M_fK3 is
    generic (
        DataWidth : INTEGER := 17;
        AddressRange : INTEGER := 48;
        AddressWidth : INTEGER := 6);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_1_M_fK3 is
    component conv1d_stage_1_M_fK3_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_1_M_fK3_rom_U :  component conv1d_stage_1_M_fK3_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


