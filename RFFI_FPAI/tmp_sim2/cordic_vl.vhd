-- -----------------------------------------------------------------------------
-- cordic_vl.vhd : 直接实体例化 cordic_v6_0_14 内核的薄包装
--
-- 2018.3 的 xsim 在“Verilog 顶层 -> 生成的 cordic_sqrt/cordic_0 VHDL 包装”
-- 这条路上会报 p_xdevicefamily 没有实参（Component 例化的绑定问题），
-- 把 Component 例化改成直接 entity 例化即可。参数与生成的包装完全一致。
-- -----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cordic_v6_0_14;

entity cordic_sqrt_vl is
  port (aclk, aresetn, s_axis_cartesian_tvalid : in std_logic;
        s_axis_cartesian_tdata : in std_logic_vector(31 downto 0);
        m_axis_dout_tvalid : out std_logic;
        m_axis_dout_tdata : out std_logic_vector(23 downto 0));
end cordic_sqrt_vl;
architecture a of cordic_sqrt_vl is
begin
  u0 : entity cordic_v6_0_14.cordic_v6_0_14
    generic map (
      C_ARCHITECTURE => 2, C_CORDIC_FUNCTION => 6, C_COARSE_ROTATE => 0,
      C_DATA_FORMAT => 2, C_XDEVICEFAMILY => "zynq", C_HAS_ACLKEN => 0,
      C_HAS_ACLK => 1, C_HAS_S_AXIS_CARTESIAN => 1, C_HAS_S_AXIS_PHASE => 0,
      C_HAS_ARESETN => 1, C_INPUT_WIDTH => 32, C_ITERATIONS => 0,
      C_OUTPUT_WIDTH => 17, C_PHASE_FORMAT => 0, C_PIPELINE_MODE => -2,
      C_PRECISION => 0, C_ROUND_MODE => 3, C_SCALE_COMP => 0,
      C_THROTTLE_SCHEME => 3, C_TLAST_RESOLUTION => 0,
      C_HAS_S_AXIS_PHASE_TUSER => 0, C_HAS_S_AXIS_PHASE_TLAST => 0,
      C_S_AXIS_PHASE_TDATA_WIDTH => 32, C_S_AXIS_PHASE_TUSER_WIDTH => 1,
      C_HAS_S_AXIS_CARTESIAN_TUSER => 0, C_HAS_S_AXIS_CARTESIAN_TLAST => 0,
      C_S_AXIS_CARTESIAN_TDATA_WIDTH => 32, C_S_AXIS_CARTESIAN_TUSER_WIDTH => 1,
      C_M_AXIS_DOUT_TDATA_WIDTH => 24, C_M_AXIS_DOUT_TUSER_WIDTH => 1)
    port map (
      aclk => aclk, aclken => '1', aresetn => aresetn,
      s_axis_phase_tvalid => '0',
      s_axis_phase_tuser => std_logic_vector(to_unsigned(0, 1)),
      s_axis_phase_tlast => '0',
      s_axis_phase_tdata => std_logic_vector(to_unsigned(0, 32)),
      s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
      s_axis_cartesian_tuser => std_logic_vector(to_unsigned(0, 1)),
      s_axis_cartesian_tlast => '0',
      s_axis_cartesian_tdata => s_axis_cartesian_tdata,
      m_axis_dout_tvalid => m_axis_dout_tvalid,
      m_axis_dout_tready => '0',
      m_axis_dout_tdata => m_axis_dout_tdata);
end a;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library cordic_v6_0_14;

entity cordic_atan_vl is
  port (aclk, aresetn, s_axis_cartesian_tvalid : in std_logic;
        s_axis_cartesian_tdata : in std_logic_vector(31 downto 0);
        m_axis_dout_tvalid : out std_logic;
        m_axis_dout_tdata : out std_logic_vector(15 downto 0));
end cordic_atan_vl;
architecture a of cordic_atan_vl is
begin
  u0 : entity cordic_v6_0_14.cordic_v6_0_14
    generic map (
      C_ARCHITECTURE => 2, C_CORDIC_FUNCTION => 3, C_COARSE_ROTATE => 1,
      C_DATA_FORMAT => 0, C_XDEVICEFAMILY => "zynq", C_HAS_ACLKEN => 0,
      C_HAS_ACLK => 1, C_HAS_S_AXIS_CARTESIAN => 1, C_HAS_S_AXIS_PHASE => 0,
      C_HAS_ARESETN => 1, C_INPUT_WIDTH => 16, C_ITERATIONS => 0,
      C_OUTPUT_WIDTH => 16, C_PHASE_FORMAT => 0, C_PIPELINE_MODE => -2,
      C_PRECISION => 0, C_ROUND_MODE => 3, C_SCALE_COMP => 0,
      C_THROTTLE_SCHEME => 3, C_TLAST_RESOLUTION => 0,
      C_HAS_S_AXIS_PHASE_TUSER => 0, C_HAS_S_AXIS_PHASE_TLAST => 0,
      C_S_AXIS_PHASE_TDATA_WIDTH => 16, C_S_AXIS_PHASE_TUSER_WIDTH => 1,
      C_HAS_S_AXIS_CARTESIAN_TUSER => 0, C_HAS_S_AXIS_CARTESIAN_TLAST => 0,
      C_S_AXIS_CARTESIAN_TDATA_WIDTH => 32, C_S_AXIS_CARTESIAN_TUSER_WIDTH => 1,
      C_M_AXIS_DOUT_TDATA_WIDTH => 16, C_M_AXIS_DOUT_TUSER_WIDTH => 1)
    port map (
      aclk => aclk, aclken => '1', aresetn => aresetn,
      s_axis_phase_tvalid => '0',
      s_axis_phase_tuser => std_logic_vector(to_unsigned(0, 1)),
      s_axis_phase_tlast => '0',
      s_axis_phase_tdata => std_logic_vector(to_unsigned(0, 16)),
      s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
      s_axis_cartesian_tuser => std_logic_vector(to_unsigned(0, 1)),
      s_axis_cartesian_tlast => '0',
      s_axis_cartesian_tdata => s_axis_cartesian_tdata,
      m_axis_dout_tvalid => m_axis_dout_tvalid,
      m_axis_dout_tready => '0',
      m_axis_dout_tdata => m_axis_dout_tdata);
end a;
