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

entity conv1d_stage_W_PJgnb_rom is 
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


architecture rtl of conv1d_stage_W_PJgnb_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00001111", 1 => "11010010", 2 => "11101100", 3 => "11100101", 
    4 => "11100001", 5 => "00100100", 6 => "00101001", 7 => "00001001", 
    8 => "00010001", 9 => "00100001", 10 => "11010000", 11 => "11110010", 
    12 => "00000101", 13 => "00001011", 14 => "00100011", 15 to 16=> "00101001", 
    17 => "11010110", 18 => "11111001", 19 => "11101111", 20 => "11110011", 
    21 => "11100110", 22 => "00000001", 23 => "11111001", 24 => "00001110", 
    25 => "11111110", 26 => "11110001", 27 => "11001101", 28 => "11101000", 
    29 => "00101100", 30 => "00001110", 31 => "00000100", 32 => "01001000", 
    33 => "11110000", 34 => "00101110", 35 => "00001111", 36 => "11100001", 
    37 => "00100001", 38 => "00111010", 39 => "11110100", 40 => "00000001", 
    41 => "00010011", 42 => "00000100", 43 => "00001111", 44 => "11111101", 
    45 => "00100001", 46 => "11110111", 47 => "00001011", 48 => "00101001", 
    49 => "00100011", 50 => "11111101", 51 => "00000001", 52 => "00011111", 
    53 => "11010101", 54 => "11111001", 55 => "11111110", 56 => "11100101", 
    57 => "00101001", 58 => "11100001", 59 => "01011111", 60 => "10110111", 
    61 => "11100011", 62 => "11010111", 63 => "00011010", 64 => "00100011", 
    65 => "11110101", 66 => "00011011", 67 => "11110001", 68 => "11110100", 
    69 => "11111011", 70 => "11110011", 71 => "00001000", 72 => "00000110", 
    73 => "00100110", 74 => "00100001", 75 => "11010000", 76 => "00011101", 
    77 => "11101100", 78 => "00001001", 79 => "11011011", 80 => "00001110", 
    81 => "00000110", 82 => "00011010", 83 => "11011100", 84 => "00000000", 
    85 => "01000001", 86 => "10110000", 87 => "00101000", 88 => "00001100", 
    89 => "10110111", 90 => "00011100", 91 => "11101011", 92 => "11111010", 
    93 => "11011110", 94 => "01001110", 95 => "01001001" );

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

entity conv1d_stage_W_PJgnb is
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

architecture arch of conv1d_stage_W_PJgnb is
    component conv1d_stage_W_PJgnb_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    conv1d_stage_W_PJgnb_rom_U :  component conv1d_stage_W_PJgnb_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


