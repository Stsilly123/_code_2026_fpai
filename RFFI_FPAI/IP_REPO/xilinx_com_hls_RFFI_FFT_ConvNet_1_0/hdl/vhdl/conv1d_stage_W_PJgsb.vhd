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

entity conv1d_stage_W_PJgsb_rom is 
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


architecture rtl of conv1d_stage_W_PJgsb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01111111", 1 => "00001000", 2 => "01100110", 3 => "00010010", 
    4 => "10000001", 5 => "10011010", 6 => "11100100", 7 => "10101000", 
    8 => "11101011", 9 => "00011000", 10 => "11100111", 11 => "00001011", 
    12 => "01010001", 13 => "10100111", 14 => "01000001", 15 => "00000001", 
    16 => "11111101", 17 => "11000101", 18 => "11101110", 19 => "01100110", 
    20 => "00000011", 21 => "10000101", 22 => "11110111", 23 => "00011000", 
    24 => "00001100", 25 => "00010010", 26 => "11101100", 27 => "11111010", 
    28 => "11001100", 29 => "11010011", 30 => "00011000", 31 => "01111111", 
    32 to 33=> "11110010", 34 => "00011100", 35 => "11111010", 36 => "10111100", 
    37 => "00000110", 38 => "00001101", 39 => "01011101", 40 => "10111000", 
    41 => "11111011", 42 => "11101011", 43 => "00011100", 44 => "11011010", 
    45 => "11000111", 46 => "00010001", 47 => "11010011", 48 => "10010101", 
    49 => "11011101", 50 => "11001000", 51 => "00110010", 52 => "11000010", 
    53 => "00100100", 54 => "00111101", 55 => "11100000", 56 => "01100100", 
    57 => "10101111", 58 => "00101101", 59 => "11011001", 60 => "10111110", 
    61 => "01010000", 62 => "11101110", 63 => "00011001", 64 => "01110100", 
    65 => "00001111", 66 => "00101101", 67 => "00011110", 68 => "10000001", 
    69 => "01110100", 70 => "11111001", 71 => "00111101", 72 => "00111111", 
    73 => "11011010", 74 => "11110000", 75 => "10100101", 76 => "11000100", 
    77 => "00011110", 78 => "11100010", 79 => "10111001", 80 => "10001011", 
    81 => "11011000", 82 => "01110010", 83 => "11010100", 84 => "00100000", 
    85 => "11010001", 86 => "00011000", 87 => "11111001", 88 => "01001110", 
    89 => "00000011", 90 => "11101110", 91 => "11010111", 92 => "00011101", 
    93 => "00100010", 94 => "00110011", 95 => "11011000" );

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

entity conv1d_stage_W_PJgsb is
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

architecture arch of conv1d_stage_W_PJgsb is
    component conv1d_stage_W_PJgsb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgsb_rom_U :  component conv1d_stage_W_PJgsb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


