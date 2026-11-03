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

entity conv1d_stage_2_M_dfE_rom is 
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


architecture rtl of conv1d_stage_2_M_dfE_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01011100101001111", 1 => "00111001011110110", 
    2 => "00101001000111100", 3 => "01011110000001110", 
    4 => "01001101011010010", 5 => "01010011000100110", 
    6 => "01110101000100111", 7 => "01000011100001001", 
    8 => "00110110111010010", 9 => "01100001110010000", 
    10 => "00110011010000011", 11 => "00110110101101001", 
    12 => "01001001101001111", 13 => "00100011001100011", 
    14 => "01000011010000011", 15 => "01000101001111000", 
    16 => "00110000111110010", 17 => "00110011110000000", 
    18 => "10000001010100100", 19 => "01011011010011000", 
    20 => "00111011111000110", 21 => "01010010100100010", 
    22 => "00100001110010011", 23 => "00101010000000001", 
    24 => "01010110011011101", 25 => "01101001101110010", 
    26 => "00100101001100000", 27 => "00101010000100101", 
    28 => "01100011101001001", 29 => "01000010001110110", 
    30 => "01000110000111110", 31 => "01000111000101001", 
    32 => "00111010100001111", 33 => "00100110110111111", 
    34 => "11000100101010001", 35 => "10010011011100010", 
    36 => "00110000010001111", 37 => "01001100101110011", 
    38 => "01110111100110011", 39 => "00010000101001011", 
    40 => "00100110011010000", 41 => "00101100010100010", 
    42 => "00101000100001101", 43 => "01000100101011101", 
    44 => "00111010010110101", 45 => "01010001001000111", 
    46 => "00110011011000001", 47 => "00011101010110011" );

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

entity conv1d_stage_2_M_dfE is
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

architecture arch of conv1d_stage_2_M_dfE is
    component conv1d_stage_2_M_dfE_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_2_M_dfE_rom_U :  component conv1d_stage_2_M_dfE_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


