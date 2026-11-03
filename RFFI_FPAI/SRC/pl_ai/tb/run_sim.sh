#!/usr/bin/env bash
# L-STF 均衡器仿真（Vivado 2018.3 xsim）
#   ./run_sim.sh          # 两个都跑
#   ./run_sim.sh unit     # 只跑 lstf_eq 单元 TB
#   ./run_sim.sh top      # 只跑顶层（Signal_process 里例化 lstf_eq）
#
# 需要 eq_in.hex / eq_gold.hex / eq_case.hex（在 tools/ 下用
#   python gen_lstf_eq_vectors.py 重新生成，默认就写在 tb/ 目录）
set -e

XV=${XV:-/d/Xilinx/Vivado/2018.3/bin}
HERE=$(cd "$(dirname "$0")" && pwd)
PL=$(dirname "$HERE")
WORK=${WORK:-/tmp/xsim_eq}

for f in eq_in.hex eq_gold.hex eq_case.hex; do
    [ -f "$HERE/$f" ] || { echo "缺少 $HERE/$f，先跑 tools/gen_lstf_eq_vectors.py"; exit 1; }
done

run_unit() {
    local D="$WORK/unit"
    mkdir -p "$D"
    cp -f "$HERE"/eq_*.hex "$D"/
    cd "$D"
    "$XV/xvlog" -i "$PL" "$PL/lstf_eq.v" "$HERE/tb_lstf_eq.v"
    "$XV/xelab" tb_lstf_eq -s eq
    "$XV/xsim" eq -R
}

run_top() {
    local D="$WORK/top"
    mkdir -p "$D"
    cp -f "$HERE"/eq_*.hex "$D"/
    cd "$D"
    # -d LSTF_EQ_SIM：把 fifo_generator / LcwtMLP IP 换成空桩（它们没有行为模型）
    "$XV/xvlog" -d LSTF_EQ_SIM -i "$PL" \
        "$PL/lstf_eq.v" "$PL/stream_buf.v" "$PL/Signal_process.v" "$HERE/tb_lstf_eq_top.v"
    "$XV/xelab" tb_lstf_eq_top -s top
    "$XV/xsim" top -R
}

case "${1:-all}" in
    unit) run_unit ;;
    top)  run_top ;;
    all)  run_unit; run_top ;;
    *)    echo "用法: $0 [unit|top|all]"; exit 1 ;;
esac
