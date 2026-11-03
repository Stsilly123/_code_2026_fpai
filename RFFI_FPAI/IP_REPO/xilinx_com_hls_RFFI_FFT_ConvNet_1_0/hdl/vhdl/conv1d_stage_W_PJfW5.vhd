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

entity conv1d_stage_W_PJfW5_rom is 
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


architecture rtl of conv1d_stage_W_PJfW5_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "10101010", 1 => "00100111", 2 => "00101000", 3 => "11111001", 
    4 => "00100111", 5 => "11001011", 6 => "00000100", 7 => "10100111", 
    8 => "00001111", 9 => "00000100", 10 => "11011110", 11 => "01010011", 
    12 => "11101101", 13 => "11110101", 14 => "00100111", 15 => "11111010", 
    16 => "00100000", 17 => "11111100", 18 => "01010000", 19 => "10101111", 
    20 => "10001011", 21 => "11100111", 22 => "00011011", 23 => "00011010", 
    24 => "00100000", 25 => "00011000", 26 => "00011011", 27 => "11011101", 
    28 => "01010011", 29 => "11000110", 30 => "11011101", 31 => "00011000", 
    32 => "11000110", 33 => "11001011", 34 => "11111001", 35 => "11001100", 
    36 => "11001111", 37 => "00000111", 38 => "11111111", 39 => "01000110", 
    40 => "11110010", 41 => "00011011", 42 => "11010010", 43 => "00110100", 
    44 => "11011110", 45 => "00101000", 46 => "00000010", 47 => "00000011", 
    48 => "11111100", 49 => "00101110", 50 => "10110000", 51 => "00111000", 
    52 => "01100110", 53 => "00011100", 54 => "00100101", 55 => "11000000", 
    56 => "10111100", 57 => "00000110", 58 => "00101001", 59 => "00001011", 
    60 => "00101001", 61 => "00110011", 62 => "00100100", 63 => "11011000", 
    64 => "01100011", 65 => "11111100", 66 => "00011110", 67 => "00010000", 
    68 => "11110101", 69 => "00110110", 70 => "00100001", 71 => "11100011", 
    72 => "00011000", 73 => "00010011", 74 => "10111000", 75 => "00100000", 
    76 => "00000111", 77 => "00101011", 78 => "00000110", 79 => "11011100", 
    80 => "00100010", 81 => "11111011", 82 => "11001110", 83 => "00110101", 
    84 => "11111111", 85 => "11001110", 86 => "11011001", 87 => "11111001", 
    88 => "11010101", 89 => "11101110", 90 => "11001111", 91 => "11111000", 
    92 => "00011010", 93 => "11110000", 94 => "00011111", 95 => "10010111" );

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

entity conv1d_stage_W_PJfW5 is
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

architecture arch of conv1d_stage_W_PJfW5 is
    component conv1d_stage_W_PJfW5_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJfW5_rom_U :  component conv1d_stage_W_PJfW5_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


