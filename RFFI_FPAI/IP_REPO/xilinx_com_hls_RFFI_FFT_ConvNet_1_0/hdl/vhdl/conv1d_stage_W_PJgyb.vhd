-- ==============================================================
-- File generated on Sun Oct 18 16:53:13 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_W_PJgyb_rom is 
    generic(
             DWIDTH     : integer := 8; 
             AWIDTH     : integer := 7; 
             MEM_SIZE    : integer := 96
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of conv1d_stage_W_PJgyb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101110", 1 => "10101110", 2 => "01010000", 3 => "11110011", 
    4 => "00011000", 5 => "00001101", 6 => "00000100", 7 => "11111011", 
    8 => "11011011", 9 => "11010011", 10 => "11111001", 11 => "10111001", 
    12 => "11011001", 13 => "01111111", 14 => "00000000", 15 => "11011001", 
    16 => "01010011", 17 => "01111111", 18 => "11011000", 19 => "11111001", 
    20 => "00101001", 21 => "01001111", 22 => "01110110", 23 => "10110110", 
    24 => "10101011", 25 => "01111111", 26 => "01110011", 27 => "01010000", 
    28 => "11110000", 29 => "11011001", 30 => "10100110", 31 => "11000101", 
    32 => "10011001", 33 => "00001111", 34 => "00111000", 35 to 36=> "10000001", 
    37 => "00010011", 38 => "00001100", 39 => "00001001", 40 => "11100011", 
    41 => "00101111", 42 => "00111100", 43 => "10000001", 44 => "11010010", 
    45 => "11001110", 46 => "11010111", 47 => "10011011", 48 => "11101000", 
    49 => "01100101", 50 => "00001111", 51 => "11010010", 52 => "11110011", 
    53 => "10111100", 54 => "10110101", 55 => "10011110", 56 => "00001101", 
    57 => "11100001", 58 => "11010110", 59 => "00101101", 60 => "11100010", 
    61 => "10110100", 62 => "11110011", 63 => "11011101", 64 => "00110100", 
    65 => "11111110", 66 => "10000001", 67 => "11101111", 68 => "00010001", 
    69 => "00110110", 70 => "01111111", 71 => "11110111", 72 => "00101011", 
    73 => "01011010", 74 => "11000100", 75 => "11110100", 76 => "01100100", 
    77 => "11110100", 78 => "01100000", 79 => "01101001", 80 => "00111101", 
    81 => "00001000", 82 => "11100100", 83 => "00100010", 84 => "01000101", 
    85 => "01111111", 86 => "00011011", 87 => "11001001", 88 => "10111000", 
    89 => "01001011", 90 => "00110100", 91 => "11011110", 92 => "00000110", 
    93 => "00011000", 94 => "11101000", 95 => "00011010" );

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

entity conv1d_stage_W_PJgyb is
    generic (
        DataWidth : INTEGER := 8;
        AddressRange : INTEGER := 96;
        AddressWidth : INTEGER := 7);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of conv1d_stage_W_PJgyb is
    component conv1d_stage_W_PJgyb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgyb_rom_U :  component conv1d_stage_W_PJgyb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


