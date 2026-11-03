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

entity conv1d_stage_1_W_fC2_rom is 
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


architecture rtl of conv1d_stage_1_W_fC2_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101110", 1 => "00001100", 2 => "00000010", 3 => "00000001", 
    4 => "11101111", 5 => "11100111", 6 => "00011100", 7 => "00111010", 
    8 => "11011100", 9 => "00010000", 10 => "11010010", 11 => "00101111", 
    12 => "10101110", 13 => "00011111", 14 => "00011100", 15 => "11110010", 
    16 => "00011011", 17 => "11110000", 18 => "00000100", 19 => "01000000", 
    20 => "00110101", 21 => "11011110", 22 => "11001010", 23 => "11110011", 
    24 => "11110100", 25 => "11101101", 26 => "11110010", 27 => "00000101", 
    28 => "00001011", 29 => "11001111", 30 => "00001010", 31 => "00000100", 
    32 => "00000001", 33 => "00100010", 34 => "11001010", 35 => "00000000", 
    36 => "00001011", 37 to 38=> "11110111", 39 => "11110001", 40 => "00001000", 
    41 => "11001011", 42 => "11111110", 43 => "00001011", 44 => "00100010", 
    45 => "00100100", 46 => "11111001", 47 => "00001001" );

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

entity conv1d_stage_1_W_fC2 is
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

architecture arch of conv1d_stage_1_W_fC2 is
    component conv1d_stage_1_W_fC2_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_1_W_fC2_rom_U :  component conv1d_stage_1_W_fC2_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


