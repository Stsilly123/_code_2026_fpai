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

entity conv1d_stage_W_PJgob_rom is 
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


architecture rtl of conv1d_stage_W_PJgob_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11010001", 1 => "00010100", 2 => "01001110", 3 => "00100110", 
    4 => "11101010", 5 => "00011011", 6 => "11110000", 7 to 8=> "11110100", 
    9 => "11110010", 10 => "11100101", 11 => "11000110", 12 => "00000110", 
    13 => "01111100", 14 => "01011010", 15 => "11100000", 16 => "11100101", 
    17 => "11100011", 18 => "10110010", 19 => "00000000", 20 => "01111111", 
    21 => "00101100", 22 => "01111111", 23 => "11000110", 24 => "00000110", 
    25 => "11010000", 26 => "10111001", 27 => "11011010", 28 => "00110101", 
    29 => "00001011", 30 => "01001000", 31 => "00010000", 32 => "00101100", 
    33 => "00010110", 34 => "10010011", 35 => "01001000", 36 => "10100110", 
    37 => "11010010", 38 => "01100011", 39 => "11010100", 40 => "10110100", 
    41 => "00110001", 42 => "00100110", 43 => "01011101", 44 => "01001001", 
    45 => "11000101", 46 => "00010101", 47 => "00010001", 48 => "10000100", 
    49 => "10111110", 50 => "11100011", 51 => "01011011", 52 => "00110111", 
    53 => "00001001", 54 => "10001001", 55 => "00111100", 56 => "00111101", 
    57 => "11001111", 58 => "00100010", 59 => "10111001", 60 => "00100000", 
    61 => "00000100", 62 => "01010000", 63 => "11101001", 64 => "11111101", 
    65 => "00100101", 66 => "10110001", 67 => "11010110", 68 => "00010001", 
    69 => "11100111", 70 => "11100000", 71 => "11110001", 72 => "11110111", 
    73 => "01000110", 74 => "11101011", 75 => "11010100", 76 => "11110001", 
    77 => "01111111", 78 => "00100010", 79 => "10110011", 80 => "00101010", 
    81 => "00011000", 82 => "10111011", 83 => "10100010", 84 => "10000001", 
    85 => "00010100", 86 => "00011011", 87 => "01010011", 88 => "00001001", 
    89 => "10101001", 90 => "11110001", 91 => "11000101", 92 => "00101100", 
    93 => "01010100", 94 => "11101000", 95 => "00001010" );

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

entity conv1d_stage_W_PJgob is
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

architecture arch of conv1d_stage_W_PJgob is
    component conv1d_stage_W_PJgob_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgob_rom_U :  component conv1d_stage_W_PJgob_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


