#!/bin/bash
# -----------------------------------------------------------------------------
# sim_expert.sh : 干净目录里跑两个 xsim 测试（E2E + 压力）
#
#   xsim 的 work 库一旦被并发/中断弄脏，xvlog 会挂住，所以每次都换一个新目录。
#   DUT 直接例化 cordic_0，仿真模型用 IP 自己的 cordic_0/sim/cordic_0.vhd
#   （2018.3 xsim 从 Verilog 例化生成的 VHDL 包装会报 p_xdevicefamily）。
#
#   用法：bash SRC/pl_ai/tools/sim_expert.sh [工作目录]
# -----------------------------------------------------------------------------
set -e
ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
WD=${1:-/tmp/expert_sim}
VIVADO=/d/Xilinx/Vivado/2018.3
export PATH=$VIVADO/bin:$PATH
IP=$ROOT/RFFI_FPAI.srcs/sources_1/ip

rm -rf "$WD"
mkdir -p "$WD"
cd "$WD"

cp "$ROOT"/SRC/pl_ai/expert/*.v "$ROOT"/SRC/pl_ai/expert/*.vhd "$ROOT"/SRC/pl_ai/expert/*.vh .
cp "$ROOT"/SRC/pl_ai/tb/tb_expert_feat.v "$ROOT"/SRC/pl_ai/tb/tb_expert_feat_stress.v "$ROOT"/SRC/pl_ai/tb/tb_expert_calls.v .
cp "$ROOT"/SRC/pl_ai/tb/vector/expert_in.hex "$ROOT"/SRC/pl_ai/tb/vector/expert_gold.hex .
cp -r "$ROOT"/SRC/pl_ai/tb/vector/synthetic .
cp "$IP"/xfft_256/sim/xfft_256.vhd .
cp "$IP"/cordic_0/sim/cordic_0.vhd .
cp "$IP"/log2_lut_rom/sim/log2_lut_rom.v .
cp "$IP"/log2_lut_rom/simulation/blk_mem_gen_v8_4.v .
cp "$IP"/log2_lut_rom/log2_lut_rom.mif .

LIB="-L xbip_utils_v3_0_9 -L axi_utils_v2_0_5 -L c_reg_fd_v12_0_5 \
     -L xbip_dsp48_wrapper_v3_0_4 -L xbip_pipe_v3_0_5 -L xbip_dsp48_addsub_v3_0_5 \
     -L xbip_addsub_v3_0_5 -L c_addsub_v12_0_12 -L c_mux_bit_v12_0_5 \
     -L c_shift_ram_v12_0_12 -L xbip_bram18k_v3_0_5 -L mult_gen_v12_0_14 \
     -L cmpy_v6_0_16 -L cordic_v6_0_14 -L floating_point_v7_0_15 -L xfft_v9_1_1 \
     -L xil_defaultlib -L work -L xilinx_vip -L unisims_ver -L unimacro_ver \
     -L secureip -L xpm"

xvlog -sv -i . ef_*.v expert_feat_rffi.v \
      tb_expert_feat.v tb_expert_feat_stress.v tb_expert_calls.v > xvlog_v.log 2>&1
# DSP48E1 原语引用 glbl.GSR；2018.3 的 xelab 不会自动带进来
xvlog "$VIVADO/data/verilog/src/glbl.v" > xvlog_glbl.log 2>&1
xvlog log2_lut_rom.v blk_mem_gen_v8_4.v > xvlog_ip.log 2>&1
xvhdl --work xil_defaultlib xfft_256.vhd cordic_0.vhd > xvhdl.log 2>&1

xelab $LIB -s top    work.tb_expert_feat        work.glbl > elab_top.log 2>&1
xsim top -R > e2e.log 2>&1
xelab $LIB -s stress work.tb_expert_feat_stress work.glbl > elab_stress.log 2>&1
xsim stress -R > stress.log 2>&1
xelab $LIB -s calls  work.tb_expert_calls       work.glbl > elab_calls.log 2>&1
xsim calls -R > calls.log 2>&1

echo "==== E2E ===="
tail -5 e2e.log
echo "==== STRESS ===="
tail -5 stress.log
echo "==== CALLS ===="
tail -20 calls.log
