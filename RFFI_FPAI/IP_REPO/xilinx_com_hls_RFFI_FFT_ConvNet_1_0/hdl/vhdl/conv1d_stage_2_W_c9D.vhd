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

entity conv1d_stage_2_W_c9D_rom is 
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


architecture rtl of conv1d_stage_2_W_c9D_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00100110", 1 => "11101011", 2 => "00011010", 3 => "11110011", 
    4 => "00000111", 5 to 6=> "11101000", 7 => "00100111", 8 => "11011111", 
    9 => "00010001", 10 => "11111000", 11 => "00100100", 12 => "11111010", 
    13 => "00001001", 14 => "00011000", 15 => "00000100", 16 => "11010101", 
    17 => "11000010", 18 => "11111110", 19 => "00010010", 20 => "00001100", 
    21 => "11110101", 22 => "11111010", 23 => "00000000", 24 => "00010111", 
    25 => "11110010", 26 => "00010010", 27 => "11111111", 28 => "11111010", 
    29 => "11011011", 30 => "11110110", 31 => "11011101", 32 => "11111100", 
    33 => "00010100", 34 => "00100010", 35 => "11111010", 36 => "11111001", 
    37 => "00101110", 38 => "11110110", 39 => "00010110", 40 => "11010010", 
    41 => "00000100", 42 => "10111011", 43 => "00010101", 44 => "00011101", 
    45 => "11110001", 46 => "00001101", 47 => "11010011" );

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

entity conv1d_stage_2_W_c9D is
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

architecture arch of conv1d_stage_2_W_c9D is
    component conv1d_stage_2_W_c9D_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_2_W_c9D_rom_U :  component conv1d_stage_2_W_c9D_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


