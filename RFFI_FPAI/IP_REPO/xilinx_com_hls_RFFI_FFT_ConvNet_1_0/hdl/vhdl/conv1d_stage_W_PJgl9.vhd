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

entity conv1d_stage_W_PJgl9_rom is 
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


architecture rtl of conv1d_stage_W_PJgl9_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100101", 1 => "10000001", 2 => "10011011", 3 => "11100101", 
    4 => "00011001", 5 => "00010110", 6 => "00100101", 7 => "00100001", 
    8 => "00010110", 9 => "10100100", 10 => "11111101", 11 => "10000010", 
    12 => "01111111", 13 => "10111101", 14 => "10000001", 15 => "00011110", 
    16 => "00011100", 17 => "11101000", 18 => "11000010", 19 => "11101110", 
    20 to 21=> "10110011", 22 => "00001010", 23 => "00010001", 24 => "00011101", 
    25 => "11000111", 26 => "11110100", 27 => "11101010", 28 => "10101111", 
    29 => "11111011", 30 => "11111111", 31 => "00101010", 32 => "01010010", 
    33 => "11010001", 34 => "00000110", 35 => "11101100", 36 => "00011111", 
    37 => "00100011", 38 => "01111111", 39 => "10000100", 40 => "11011100", 
    41 => "11101111", 42 => "11110110", 43 => "11111001", 44 => "10111101", 
    45 => "00000100", 46 => "00111100", 47 => "00100101", 48 => "11111111", 
    49 => "10110111", 50 => "00111111", 51 => "10101000", 52 => "11011010", 
    53 => "10111101", 54 => "11100011", 55 => "11110000", 56 => "00010110", 
    57 => "11000111", 58 => "11010100", 59 => "10110111", 60 => "10001000", 
    61 => "11001111", 62 => "01001111", 63 => "01011010", 64 => "00010001", 
    65 => "00101100", 66 => "00010100", 67 => "11011100", 68 => "01001111", 
    69 => "00010011", 70 => "11010010", 71 => "11110101", 72 => "00011000", 
    73 to 74=> "11110101", 75 => "00101001", 76 => "00101101", 77 => "11010110", 
    78 => "00100101", 79 => "11011111", 80 => "00101111", 81 => "00101110", 
    82 => "00110000", 83 => "01000101", 84 => "00101111", 85 => "01000011", 
    86 => "00100111", 87 => "11011011", 88 => "00111001", 89 => "01111001", 
    90 => "00001010", 91 => "00001101", 92 => "00111110", 93 => "00000011", 
    94 => "00000010", 95 => "11100000" );

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

entity conv1d_stage_W_PJgl9 is
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

architecture arch of conv1d_stage_W_PJgl9 is
    component conv1d_stage_W_PJgl9_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgl9_rom_U :  component conv1d_stage_W_PJgl9_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


