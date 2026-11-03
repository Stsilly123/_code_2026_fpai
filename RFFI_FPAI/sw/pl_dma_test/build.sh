#!/bin/sh
# 用 docker 交叉编译 pl_dma_test（目标：板子上的 aarch64 Linux）
#
#   sh build.sh          首次会 build 镜像（装交叉工具链，要联网），之后很快
#   sh build.sh clean     删掉镜像重新来
#
# 产物：./pl_dma_test —— aarch64、静态链接。拷到板子上直接 chmod +x 就能跑，
#       不挑板子的 glibc 版本。

set -e
cd "$(dirname "$0")"

IMAGE=pl_dma_test_builder

# registry-1.docker.io 在本机连不通，优先用能拉到的源
pick_base() {
    for b in docker.m.daocloud.io/library/ubuntu:20.04 ubuntu:20.04 ububtu20.04:imported; do
        if docker image inspect "$b" >/dev/null 2>&1; then echo "$b"; return; fi
        if docker pull -q "$b" >/dev/null 2>&1; then echo "$b"; return; fi
    done
    echo ""
}

if [ "$1" = "clean" ]; then
    docker rmi -f "$IMAGE" 2>/dev/null || true
    rm -f pl_dma_test
    echo "已清理。"
    exit 0
fi

# 本机 fallback：2018.3 SDK 自带的 Windows 原生 aarch64 交叉编译器。
# Docker 没起（Desktop 没开、镜像被清掉）时用它，一样出静态 aarch64。
NATIVE_GCC="/d/Xilinx/SDK/2018.3/gnu/aarch64/nt/aarch64-linux/bin/aarch64-linux-gnu-gcc.exe"

if ! docker info >/dev/null 2>&1; then
    if [ -x "$NATIVE_GCC" ]; then
        echo "== docker 没在跑，改用 2018.3 SDK 的原生交叉编译器 =="
        "$NATIVE_GCC" -O2 -Wall -Wextra -Wno-unused-parameter \
            -static -o pl_dma_test pl_dma_test.c
        echo
        echo "== 完成 =="
        ls -l pl_dma_test
        exit 0
    fi
    echo "docker 没在跑，也找不到 $NATIVE_GCC"
    exit 1
fi

# Git Bash 下 $(pwd) 是 /d/xxx，docker 不认；转成 Windows 路径
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) HOSTDIR="$(cygpath -w -a "$PWD")" ;;
    *)                    HOSTDIR="$PWD" ;;
esac

echo "== 1/2 准备镜像 $IMAGE =="
if docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "   已存在，跳过（要重装用 sh build.sh clean）"
else
    BASE="$(pick_base)"
    [ -n "$BASE" ] || { echo "拉不到任何基础镜像，检查网络/代理"; exit 1; }
    echo "   基础镜像: $BASE"
    docker build --build-arg BASE="$BASE" -t "$IMAGE" .
fi

echo "== 2/2 编译 =="
MSYS_NO_PATHCONV=1 docker run --rm -v "$HOSTDIR":/src -w /src "$IMAGE" \
    aarch64-linux-gnu-gcc -O2 -Wall -Wextra -Wno-unused-parameter \
        -static -o pl_dma_test pl_dma_test.c

echo
echo "== 完成 =="
ls -l pl_dma_test
echo
echo "拷到板子上（改成你的板子地址）："
echo "  scp pl_dma_test root@<板子IP>:/root/"
echo "  ssh root@<板子IP>"
echo "  ./pl_dma_test probe        # 先跑这个，确认 0x8040_0000 / 0x8041_0000 通"
echo "  ./pl_dma_test sg2          # SG 引擎自检：清描述符区+预检 / 只挂不跑 / 写尾 / 时间线"
echo "                             #   / 逐字 diff / 跑完复扫。打出【下一步】"
echo "  ./pl_dma_test carpet       # 满屏合法描述符：量引擎实际读的是哪个地址"
echo "  ./pl_dma_test sgprobe      # 老版探针（四种挂法对照），结论判读不如 sg2 细"
echo "  ./pl_dma_test e2e          # 端到端：8192B 进 / 5472B 出，判读 TLAST；然后补收满 8 帧"
echo "                             #   （补收是为了不给下一轮留存货；--one 退回老行为）"
echo "  ./pl_dma_test frames       # 逐帧收 8 次（每次 684B），拿全 8 帧"
echo "  ./pl_dma_test irqscan      # 实测「IRQ_F2P 落到哪个 GIC SPI」（查 dts 里 61/64 对不对）"
echo
echo "# 形状二分（sg2 打出【下一步】里那两条，一次只动一个）:"
echo "  ./pl_dma_test sg2 --mm2s --xfer=1024   # 长度对上，环还是 2 格"
echo "  ./pl_dma_test sg2 --mm2s --ring=16     # 环变长，长度还是 8192"
echo
echo "sg2 / carpet 打出【下一步】之后，ILA 该抓哪根线看 doc/pl_sg_ila.md"
