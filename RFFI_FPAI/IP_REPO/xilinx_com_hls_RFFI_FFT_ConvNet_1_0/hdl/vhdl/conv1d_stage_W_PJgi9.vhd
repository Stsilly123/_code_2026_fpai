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

entity conv1d_stage_W_PJgi9_rom is 
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


architecture rtl of conv1d_stage_W_PJgi9_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001110", 1 => "11110110", 2 => "10101101", 3 => "00010010", 
    4 => "00101001", 5 => "00000100", 6 => "00100110", 7 => "11111101", 
    8 => "00001001", 9 => "00011100", 10 => "10111110", 11 => "01010000", 
    12 => "00110010", 13 => "11101000", 14 => "00001010", 15 => "00100010", 
    16 => "11010100", 17 => "00101001", 18 => "01000011", 19 => "00100000", 
    20 => "00010011", 21 => "00100001", 22 => "11101000", 23 => "10000111", 
    24 => "00000101", 25 => "01010100", 26 => "11010100", 27 => "11101100", 
    28 => "01010110", 29 => "01001100", 30 => "11011000", 31 => "11100011", 
    32 => "11110010", 33 => "00100001", 34 => "11101010", 35 => "01010001", 
    36 => "01000101", 37 => "00001010", 38 => "00000100", 39 => "11110010", 
    40 => "11010011", 41 => "00000101", 42 to 43=> "11101011", 44 => "11111001", 
    45 => "11000010", 46 => "00010001", 47 => "11000100", 48 => "11011000", 
    49 => "00000010", 50 => "01011010", 51 => "11000011", 52 => "11100111", 
    53 => "11111101", 54 => "00111110", 55 => "11110101", 56 => "11110010", 
    57 => "00110101", 58 => "11011010", 59 => "11000100", 60 => "10100001", 
    61 => "11100100", 62 => "00001011", 63 => "11111000", 64 => "00001011", 
    65 => "00010001", 66 => "00100110", 67 => "11011000", 68 => "00100111", 
    69 => "00100101", 70 => "11001011", 71 => "10100101", 72 => "11010000", 
    73 => "10001111", 74 => "10111001", 75 => "01111111", 76 => "11101110", 
    77 => "11011110", 78 => "00011111", 79 => "11011010", 80 => "00001011", 
    81 => "00111000", 82 => "11101111", 83 => "01000010", 84 => "00000011", 
    85 => "11010101", 86 => "11100000", 87 => "00010011", 88 => "00101010", 
    89 => "11110101", 90 => "00010111", 91 => "11100000", 92 => "00000001", 
    93 => "00110110", 94 => "00101100", 95 => "11001010" );

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

entity conv1d_stage_W_PJgi9 is
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

architecture arch of conv1d_stage_W_PJgi9 is
    component conv1d_stage_W_PJgi9_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgi9_rom_U :  component conv1d_stage_W_PJgi9_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


