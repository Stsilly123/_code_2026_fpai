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

entity conv1d_stage_2_W_cXB_rom is 
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


architecture rtl of conv1d_stage_2_W_cXB_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00010011", 1 => "00001101", 2 => "00010101", 3 => "00001011", 
    4 => "11011011", 5 => "00001001", 6 => "00000100", 7 => "00110110", 
    8 => "00001011", 9 => "11101011", 10 => "10111100", 11 => "11100000", 
    12 => "11110001", 13 => "00000100", 14 => "00001100", 15 => "11101101", 
    16 => "00000010", 17 => "00010011", 18 => "00000010", 19 => "11100101", 
    20 => "00100101", 21 => "11110100", 22 => "11110001", 23 => "00000110", 
    24 => "00000111", 25 => "11101011", 26 => "00101101", 27 => "11011011", 
    28 => "11111101", 29 => "11010011", 30 => "00011101", 31 => "00001110", 
    32 => "11100110", 33 => "10100010", 34 => "11101110", 35 => "11101010", 
    36 => "00010011", 37 => "11111100", 38 => "11110110", 39 => "11010010", 
    40 => "00011101", 41 => "11111011", 42 => "00101101", 43 => "00011011", 
    44 => "11100011", 45 => "00011010", 46 => "10100001", 47 => "00110000" );

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

entity conv1d_stage_2_W_cXB is
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

architecture arch of conv1d_stage_2_W_cXB is
    component conv1d_stage_2_W_cXB_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_2_W_cXB_rom_U :  component conv1d_stage_2_W_cXB_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


