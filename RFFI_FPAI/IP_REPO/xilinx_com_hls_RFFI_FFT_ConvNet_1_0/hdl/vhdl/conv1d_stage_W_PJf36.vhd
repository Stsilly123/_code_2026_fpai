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

entity conv1d_stage_W_PJf36_rom is 
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


architecture rtl of conv1d_stage_W_PJf36_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001000", 1 => "11101101", 2 => "11100010", 3 => "00001101", 
    4 => "00011100", 5 => "11100111", 6 => "11110011", 7 => "10111000", 
    8 => "11001111", 9 => "01010010", 10 => "00001110", 11 => "01011001", 
    12 => "11110010", 13 => "01010100", 14 => "10110111", 15 => "11101001", 
    16 => "00100111", 17 => "10110110", 18 => "00100011", 19 => "10110010", 
    20 => "11111111", 21 => "11101001", 22 => "11101000", 23 => "00110000", 
    24 => "11100010", 25 => "00001010", 26 => "10101111", 27 => "00011111", 
    28 => "00001111", 29 => "00001011", 30 => "01011010", 31 => "00100111", 
    32 => "01001010", 33 => "11001010", 34 => "11011001", 35 => "11110101", 
    36 => "00101010", 37 => "00111111", 38 => "10100000", 39 => "01010101", 
    40 => "01000111", 41 => "00001010", 42 => "11011010", 43 => "11110001", 
    44 => "00010101", 45 => "01010000", 46 => "00001111", 47 => "00100110", 
    48 => "11111000", 49 => "11101101", 50 => "00101001", 51 => "00111000", 
    52 => "11100011", 53 => "00011000", 54 => "00100001", 55 => "00100011", 
    56 => "11011110", 57 => "00110010", 58 => "11110010", 59 => "11111100", 
    60 => "11101100", 61 => "00101001", 62 => "00000100", 63 => "00101100", 
    64 => "00010111", 65 => "10011100", 66 => "11011111", 67 => "00011110", 
    68 => "00010010", 69 => "11110011", 70 => "00101111", 71 => "11011110", 
    72 => "00100111", 73 => "00001111", 74 => "00011101", 75 to 76=> "11111011", 
    77 => "11101001", 78 => "01000111", 79 => "00010000", 80 => "11110001", 
    81 => "11011100", 82 => "11110100", 83 => "11110000", 84 => "00101000", 
    85 => "11110001", 86 => "00101110", 87 => "00000010", 88 => "11000111", 
    89 => "00010110", 90 => "11101101", 91 => "11110010", 92 => "00110110", 
    93 => "00111101", 94 => "10110111", 95 => "01001100" );

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

entity conv1d_stage_W_PJf36 is
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

architecture arch of conv1d_stage_W_PJf36 is
    component conv1d_stage_W_PJf36_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJf36_rom_U :  component conv1d_stage_W_PJf36_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


