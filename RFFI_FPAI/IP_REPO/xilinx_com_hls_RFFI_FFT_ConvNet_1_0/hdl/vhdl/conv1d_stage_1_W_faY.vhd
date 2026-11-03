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

entity conv1d_stage_1_W_faY_rom is 
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


architecture rtl of conv1d_stage_1_W_faY_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11001011", 1 => "00100000", 2 => "11011010", 3 => "00100111", 
    4 => "10101000", 5 => "00011011", 6 => "10001111", 7 => "00001111", 
    8 => "11001111", 9 => "00100011", 10 => "11111101", 11 => "11010100", 
    12 => "00010010", 13 => "00001000", 14 => "00100010", 15 => "11011000", 
    16 => "10100101", 17 => "10101001", 18 to 19=> "11111000", 20 to 21=> "11111101", 
    22 => "00011000", 23 => "01000000", 24 => "11011011", 25 => "11110100", 
    26 => "11101001", 27 => "10110011", 28 => "11100011", 29 => "11001000", 
    30 => "00110011", 31 => "00000000", 32 => "11100011", 33 => "00010010", 
    34 => "00111100", 35 => "11100010", 36 => "11111011", 37 => "11101000", 
    38 => "00101100", 39 => "11110101", 40 => "00000000", 41 => "00100100", 
    42 => "00000001", 43 => "11001110", 44 => "11101011", 45 => "11010100", 
    46 => "00010100", 47 => "00010111" );

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

entity conv1d_stage_1_W_faY is
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

architecture arch of conv1d_stage_1_W_faY is
    component conv1d_stage_1_W_faY_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_1_W_faY_rom_U :  component conv1d_stage_1_W_faY_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


