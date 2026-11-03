-- ==============================================================
-- File generated on Sun Oct 18 16:53:12 +0800 2026
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity conv1d_stage_W_PJf06_rom is 
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


architecture rtl of conv1d_stage_W_PJf06_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01111111", 1 => "00001001", 2 => "10111000", 3 => "11010010", 
    4 => "00000110", 5 => "00101000", 6 => "00011010", 7 => "11101010", 
    8 => "11101100", 9 => "11111110", 10 => "11011101", 11 => "11010100", 
    12 => "00000100", 13 => "00101100", 14 => "11000011", 15 => "00101010", 
    16 => "00010000", 17 => "00101101", 18 => "10100010", 19 => "11100110", 
    20 => "00000000", 21 => "11001100", 22 => "11111000", 23 => "11010000", 
    24 => "11100001", 25 => "00100010", 26 => "00000100", 27 => "10111100", 
    28 => "11011000", 29 => "10111100", 30 => "11011101", 31 => "11110001", 
    32 => "11110111", 33 to 34=> "11110100", 35 => "11001100", 36 => "11010100", 
    37 => "10000001", 38 => "11011011", 39 => "11101111", 40 => "11110110", 
    41 => "11100001", 42 => "00101111", 43 => "11010111", 44 => "00011000", 
    45 => "01000011", 46 => "11011111", 47 => "10000001", 48 => "00110101", 
    49 => "00001101", 50 => "00000100", 51 => "00101101", 52 => "10100111", 
    53 => "00010011", 54 => "11011101", 55 => "00000001", 56 => "11110101", 
    57 => "00101110", 58 => "00010011", 59 => "11010011", 60 => "11010111", 
    61 => "00110010", 62 => "11001101", 63 => "10011000", 64 => "11011111", 
    65 => "10111001", 66 => "11000100", 67 => "00101000", 68 => "11010111", 
    69 => "10110111", 70 => "11110001", 71 => "00000001", 72 => "11100011", 
    73 => "11001110", 74 => "01001011", 75 => "11001011", 76 => "11011010", 
    77 => "11001001", 78 => "10110100", 79 => "11101011", 80 => "01111111", 
    81 => "01011010", 82 => "01110011", 83 => "10000001", 84 => "00001011", 
    85 => "10110111", 86 => "00101101", 87 => "11011100", 88 => "11101100", 
    89 => "10000001", 90 => "00110010", 91 => "10111011", 92 => "00010101", 
    93 => "11101100", 94 => "00001010", 95 => "00110100" );

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

entity conv1d_stage_W_PJf06 is
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

architecture arch of conv1d_stage_W_PJf06 is
    component conv1d_stage_W_PJf06_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf06_rom_U :  component conv1d_stage_W_PJf06_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


