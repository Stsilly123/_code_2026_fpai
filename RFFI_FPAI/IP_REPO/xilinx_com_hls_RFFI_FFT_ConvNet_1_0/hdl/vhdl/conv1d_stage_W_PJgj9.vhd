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

entity conv1d_stage_W_PJgj9_rom is 
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


architecture rtl of conv1d_stage_W_PJgj9_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00000101", 1 => "00100000", 2 => "01100011", 3 => "00100100", 
    4 => "11010001", 5 => "11100101", 6 => "10111111", 7 => "10100101", 
    8 => "01111111", 9 => "11011000", 10 => "01010000", 11 => "11100101", 
    12 => "00100001", 13 => "00101110", 14 => "10110101", 15 => "11000101", 
    16 => "11111000", 17 => "11000011", 18 => "00110110", 19 => "00000011", 
    20 => "10011010", 21 => "00110111", 22 => "00011100", 23 => "01110010", 
    24 => "00011001", 25 => "01010110", 26 => "01111111", 27 => "11111001", 
    28 => "00001000", 29 => "11111011", 30 => "10000010", 31 => "11000011", 
    32 => "01110100", 33 => "01100110", 34 => "00101101", 35 => "01001100", 
    36 => "11101011", 37 => "01000111", 38 => "11100110", 39 => "00101100", 
    40 => "00010101", 41 => "11001100", 42 => "11010100", 43 => "00010010", 
    44 => "01001101", 45 => "11100111", 46 => "11010111", 47 => "01101110", 
    48 => "10110011", 49 => "01001010", 50 => "11111111", 51 => "00111001", 
    52 => "10000001", 53 => "00011000", 54 => "00001101", 55 => "00110100", 
    56 => "01011110", 57 => "11001010", 58 => "10000001", 59 => "01001010", 
    60 => "00011000", 61 => "00001011", 62 => "00100111", 63 => "00011101", 
    64 => "00001111", 65 => "11101100", 66 => "11111001", 67 => "00101101", 
    68 => "11000001", 69 => "11111111", 70 => "11111001", 71 => "10111101", 
    72 => "11000111", 73 => "10010110", 74 => "10100001", 75 => "01010001", 
    76 => "10111011", 77 => "11111100", 78 => "11011111", 79 => "11111001", 
    80 => "00011010", 81 => "01000110", 82 => "00010111", 83 => "00000111", 
    84 => "11100010", 85 => "11111011", 86 => "10011010", 87 => "00111100", 
    88 => "00100001", 89 => "11101101", 90 => "00011111", 91 to 92=> "00010001", 
    93 => "00011101", 94 => "11110011", 95 => "11110001" );

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

entity conv1d_stage_W_PJgj9 is
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

architecture arch of conv1d_stage_W_PJgj9 is
    component conv1d_stage_W_PJgj9_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgj9_rom_U :  component conv1d_stage_W_PJgj9_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


