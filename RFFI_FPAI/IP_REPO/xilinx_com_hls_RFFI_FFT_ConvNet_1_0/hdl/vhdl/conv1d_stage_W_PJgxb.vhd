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

entity conv1d_stage_W_PJgxb_rom is 
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


architecture rtl of conv1d_stage_W_PJgxb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11101100", 1 => "11111010", 2 => "00010101", 3 => "11100111", 
    4 => "00000011", 5 => "11000011", 6 => "00001101", 7 => "11111011", 
    8 => "11011000", 9 => "00111111", 10 => "10000001", 11 => "00011001", 
    12 => "01010101", 13 => "00010101", 14 => "11101011", 15 => "00101000", 
    16 => "00001010", 17 => "01101001", 18 => "00011100", 19 => "00001101", 
    20 => "11111111", 21 => "00111100", 22 => "00101100", 23 => "11111000", 
    24 => "11000011", 25 => "00001001", 26 => "11000000", 27 => "11001000", 
    28 => "01000110", 29 => "00011111", 30 => "10110111", 31 => "11010111", 
    32 => "11110101", 33 => "11001110", 34 => "00001101", 35 => "00001010", 
    36 => "00100110", 37 => "00110001", 38 => "11010101", 39 => "01001011", 
    40 => "11110110", 41 => "00010101", 42 => "00010110", 43 => "00100000", 
    44 => "01000010", 45 => "11011010", 46 => "00110110", 47 => "00001111", 
    48 => "01010100", 49 => "00100100", 50 => "00001011", 51 => "10100001", 
    52 => "00001011", 53 => "00011101", 54 => "00011000", 55 => "11101011", 
    56 => "00100010", 57 => "00100100", 58 => "00110101", 59 => "10100100", 
    60 => "01000000", 61 => "01001010", 62 => "00100000", 63 => "00000111", 
    64 => "00001111", 65 => "11111111", 66 => "00001100", 67 => "00101110", 
    68 => "10001111", 69 => "11101101", 70 => "11110111", 71 => "11011011", 
    72 => "11111101", 73 => "00101000", 74 => "00110100", 75 => "11010100", 
    76 => "00101111", 77 => "11100000", 78 => "00101010", 79 => "00000001", 
    80 => "11010111", 81 => "11010000", 82 => "00101010", 83 => "11100110", 
    84 => "11010000", 85 => "00010001", 86 => "00100000", 87 => "00000101", 
    88 => "00010111", 89 => "11000101", 90 => "00001000", 91 => "00100010", 
    92 => "00101011", 93 => "11111100", 94 => "11101001", 95 => "01111110" );

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

entity conv1d_stage_W_PJgxb is
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

architecture arch of conv1d_stage_W_PJgxb is
    component conv1d_stage_W_PJgxb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgxb_rom_U :  component conv1d_stage_W_PJgxb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


