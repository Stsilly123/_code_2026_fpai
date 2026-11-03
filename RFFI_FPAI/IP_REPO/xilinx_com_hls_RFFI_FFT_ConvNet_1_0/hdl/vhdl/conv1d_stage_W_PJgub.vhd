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

entity conv1d_stage_W_PJgub_rom is 
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


architecture rtl of conv1d_stage_W_PJgub_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "11111001", 1 => "11001100", 2 => "11100101", 3 => "00011100", 
    4 => "00110011", 5 => "00101100", 6 => "00001110", 7 => "11101111", 
    8 to 9=> "11110000", 10 => "11011010", 11 => "11101110", 12 => "11011111", 
    13 => "11100001", 14 => "11011110", 15 => "00100001", 16 => "11111011", 
    17 => "11110010", 18 => "00111011", 19 => "00011110", 20 => "11100110", 
    21 => "11111011", 22 => "11101011", 23 => "00100110", 24 => "11110101", 
    25 => "00011010", 26 => "00000010", 27 => "11011001", 28 => "00011010", 
    29 => "11111111", 30 => "11101101", 31 => "11110001", 32 => "00001011", 
    33 => "11110001", 34 => "11100101", 35 => "00101001", 36 => "00110111", 
    37 => "11100011", 38 => "11110111", 39 => "00101011", 40 => "11010001", 
    41 => "00011000", 42 => "00111011", 43 => "11010110", 44 => "00011001", 
    45 => "11011000", 46 => "00001100", 47 => "11010101", 48 => "11100011", 
    49 => "00100010", 50 => "11100010", 51 => "11111100", 52 => "11100001", 
    53 => "00011101", 54 => "11100101", 55 => "11000001", 56 => "01111111", 
    57 => "01000010", 58 => "11101101", 59 => "00101001", 60 => "11111110", 
    61 => "11101110", 62 => "00100010", 63 => "11001001", 64 => "11110000", 
    65 => "00100001", 66 => "11100011", 67 => "11110111", 68 => "00101010", 
    69 => "00000011", 70 => "11011011", 71 => "01001000", 72 => "00010010", 
    73 => "11110111", 74 => "11101000", 75 => "00001010", 76 => "11001110", 
    77 => "00011000", 78 => "00101000", 79 => "11111011", 80 => "00000101", 
    81 => "00100111", 82 => "11011011", 83 => "11111111", 84 => "11110000", 
    85 => "11111110", 86 => "00101100", 87 => "11101000", 88 => "11010000", 
    89 => "10101110", 90 => "11111111", 91 => "11111100", 92 => "00111010", 
    93 => "11110001", 94 => "11010101", 95 => "11010011" );

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

entity conv1d_stage_W_PJgub is
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

architecture arch of conv1d_stage_W_PJgub is
    component conv1d_stage_W_PJgub_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgub_rom_U :  component conv1d_stage_W_PJgub_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


