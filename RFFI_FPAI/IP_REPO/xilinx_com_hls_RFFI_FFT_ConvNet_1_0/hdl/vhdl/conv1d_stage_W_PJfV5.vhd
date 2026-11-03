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

entity conv1d_stage_W_PJfV5_rom is 
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


architecture rtl of conv1d_stage_W_PJfV5_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "01100100", 1 => "00010000", 2 => "00000111", 3 => "11011001", 
    4 => "00100111", 5 => "11101010", 6 => "00101101", 7 => "11011111", 
    8 => "00110110", 9 => "11000011", 10 => "00010000", 11 => "11011110", 
    12 => "11100101", 13 => "10110011", 14 => "11011011", 15 => "11010101", 
    16 => "00100110", 17 => "11111001", 18 => "11101010", 19 => "00111111", 
    20 => "00010111", 21 => "10101000", 22 => "10110101", 23 => "00011101", 
    24 => "11000101", 25 => "11101010", 26 => "11000001", 27 => "11111110", 
    28 => "10101001", 29 => "00011110", 30 => "01000010", 31 => "11110001", 
    32 => "10000101", 33 => "11110010", 34 => "11101001", 35 => "00110110", 
    36 => "01010001", 37 => "11111010", 38 => "11101011", 39 => "00110111", 
    40 => "01011101", 41 => "11100010", 42 => "00011100", 43 => "11100101", 
    44 => "00011011", 45 => "10111100", 46 => "11010110", 47 => "00111110", 
    48 to 49=> "11111010", 50 => "00111001", 51 => "11101101", 52 => "00100001", 
    53 => "01000011", 54 => "00010010", 55 => "11010101", 56 => "00100100", 
    57 => "01000001", 58 => "11111111", 59 => "00010011", 60 => "10100010", 
    61 => "10000001", 62 => "01001100", 63 => "10101111", 64 => "11010110", 
    65 => "11001101", 66 => "00011010", 67 => "00111110", 68 => "01000101", 
    69 => "11001001", 70 => "11000001", 71 => "11110010", 72 => "11111100", 
    73 => "01111111", 74 => "10010011", 75 => "00000000", 76 => "11111000", 
    77 => "10010100", 78 => "01001100", 79 => "11001000", 80 => "11010010", 
    81 => "00001110", 82 => "11001001", 83 => "01010011", 84 => "00011011", 
    85 => "10110000", 86 => "10000001", 87 => "11111001", 88 => "11110110", 
    89 => "11100101", 90 => "00110010", 91 => "00011100", 92 => "10000001", 
    93 => "11110000", 94 => "11110011", 95 => "10011101" );

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

entity conv1d_stage_W_PJfV5 is
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

architecture arch of conv1d_stage_W_PJfV5 is
    component conv1d_stage_W_PJfV5_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfV5_rom_U :  component conv1d_stage_W_PJfV5_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


