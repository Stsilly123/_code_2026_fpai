#!/bin/bash
# 回放板上用法：32 次调用 × 8 份相同帧。向量在 tmp_board/（tools/gen 出来的）
set -e
ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
WD=${1:-$ROOT/tmp_board_sim}
VIVADO=/d/Xilinx/Vivado/2018.3
export PATH=$VIVADO/bin:$PATH
IP=$ROOT/RFFI_FPAI.srcs/sources_1/ip
rm -rf "$WD"; mkdir -p "$WD"; cd "$WD"
cp "$ROOT"/SRC/pl_ai/expert/*.v "$ROOT"/SRC/pl_ai/expert/*.vhd "$ROOT"/SRC/pl_ai/expert/*.vh .
cp "$ROOT"/SRC/pl_ai/tb/tb_expert_board.v .
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
xvlog -sv -i . ef_*.v expert_feat_rffi.v tb_expert_board.v > xvlog_v.log 2>&1
xvlog "$VIVADO/data/verilog/src/glbl.v" > xvlog_glbl.log 2>&1
xvlog log2_lut_rom.v blk_mem_gen_v8_4.v > xvlog_ip.log 2>&1
xvhdl --work xil_defaultlib xfft_256.vhd cordic_0.vhd > xvhdl.log 2>&1
xelab $LIB -s board work.tb_expert_board work.glbl > elab.log 2>&1
xsim board -R > board.log 2>&1
echo "==== BOARD ===="
grep -E "call |EXPERT BOARD|TIMEOUT|FAIL" board.log | head -50
