#!/bin/bash
# -----------------------------------------------------------------------------
# sim_race.sh : 现象 B 竞态复现（tb_expert_race）
#   激励：连续供数（1 字 / 4 拍），每次调用 = 8 份相同帧，相邻调用不同；
#   判据：每个输出帧必须精确匹配 32 份 golden 中的一份，且不得有
#         「S_ZN 期间写正在读的槽」事件。
#   用法：bash SRC/pl_ai/tools/sim_race.sh [工作目录] [TB 名]
#         TB 名默认 tb_expert_race；验收 TB 用 tb_expert_accept。
# -----------------------------------------------------------------------------
set -e
ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
WD=${1:-/tmp/expert_race}
TB=${2:-tb_expert_race}
VIVADO=/d/Xilinx/Vivado/2018.3
export PATH=$VIVADO/bin:$PATH
IP=$ROOT/RFFI_FPAI.srcs/sources_1/ip

rm -rf "$WD"
mkdir -p "$WD"
cd "$WD"

cp "$ROOT"/SRC/pl_ai/expert/*.v "$ROOT"/SRC/pl_ai/expert/*.vhd "$ROOT"/SRC/pl_ai/expert/*.vh .
cp "$ROOT"/SRC/pl_ai/tb/$TB.v .
cp "$ROOT"/tmp_board/expert_in_rep.hex "$ROOT"/tmp_board/gold_rep.hex .
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

xvlog -sv -i . ef_*.v expert_feat_rffi.v $TB.v > xvlog_v.log 2>&1
xvlog "$VIVADO/data/verilog/src/glbl.v" > xvlog_glbl.log 2>&1
xvlog log2_lut_rom.v blk_mem_gen_v8_4.v > xvlog_ip.log 2>&1
xvhdl --work xil_defaultlib xfft_256.vhd cordic_0.vhd > xvhdl.log 2>&1
xelab $LIB -s race work.$TB work.glbl > elab.log 2>&1
xsim race -R > race.log 2>&1

grep -E "COLLISION|CORRUPT|SHIFTED|不一致|EXPERT RACE|EXPERT ACCEPT|RESULT|TIMEOUT|^----" race.log | head -60
