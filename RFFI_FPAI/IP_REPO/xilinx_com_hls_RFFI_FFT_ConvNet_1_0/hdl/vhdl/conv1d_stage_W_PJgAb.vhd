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

entity conv1d_stage_W_PJgAb_rom is 
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


architecture rtl of conv1d_stage_W_PJgAb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11100001", 1 => "00000101", 2 => "00001110", 3 => "00111101", 
    4 => "11110101", 5 => "00010110", 6 => "10011110", 7 => "11101001", 
    8 => "00010111", 9 => "10100010", 10 => "11011011", 11 => "00110010", 
    12 => "11001111", 13 => "00010001", 14 => "01001100", 15 => "00001110", 
    16 => "10000001", 17 => "00010000", 18 => "11110110", 19 => "00100010", 
    20 => "01000100", 21 => "11010101", 22 => "11011001", 23 => "11010101", 
    24 => "01000001", 25 => "11011000", 26 => "11111011", 27 => "11110000", 
    28 => "01000000", 29 => "00010010", 30 => "10100101", 31 => "00010100", 
    32 => "11001101", 33 => "01010110", 34 => "11000000", 35 => "00011001", 
    36 => "00001000", 37 => "11101001", 38 => "11001011", 39 => "00100000", 
    40 => "10011001", 41 => "01000100", 42 => "01001100", 43 => "00111111", 
    44 => "10100101", 45 => "10000001", 46 => "00011001", 47 => "11111110", 
    48 => "11111010", 49 => "10000001", 50 => "00010100", 51 => "10010101", 
    52 => "01000011", 53 => "00110001", 54 => "01011110", 55 => "01001101", 
    56 => "10101000", 57 => "10101010", 58 => "11101101", 59 => "11101111", 
    60 => "10100000", 61 => "00011101", 62 => "11100011", 63 => "00001001", 
    64 => "11101111", 65 => "11110100", 66 => "10111001", 67 => "11000101", 
    68 => "00010101", 69 => "00111000", 70 => "00100001", 71 => "00000010", 
    72 => "00001111", 73 => "00110110", 74 => "00001000", 75 => "10011110", 
    76 => "00011110", 77 => "01000101", 78 => "10111111", 79 => "00100011", 
    80 => "10101111", 81 => "10110010", 82 => "00110011", 83 => "00011111", 
    84 => "00010011", 85 => "00100010", 86 => "10101000", 87 => "11000010", 
    88 => "00001111", 89 => "11100000", 90 => "00100100", 91 => "10010011", 
    92 => "10111000", 93 => "11100001", 94 => "00011001", 95 => "01010011" );

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

entity conv1d_stage_W_PJgAb is
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

architecture arch of conv1d_stage_W_PJgAb is
    component conv1d_stage_W_PJgAb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgAb_rom_U :  component conv1d_stage_W_PJgAb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


