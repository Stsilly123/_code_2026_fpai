#!/bin/sh
# 编译 pl_dma_io（静态库）和 pl_dma_io_demo（自测程序）
#
#   sh build.sh          产 libpl_dma_io.a + pl_dma_io_demo（连着库一起编）
#   sh build.sh lib      只产 libpl_dma_io.a
#   sh build.sh src      不建库，把 demo.c 和 pl_dma_io.c 一起编（证明"源码直接
#                        拖进你自己的编译命令"也能用），产物叫 pl_dma_io_demo_src
#   sh build.sh clean    删掉本目录的编译产物
#
# 产物是 aarch64、静态链接，拷到板子上 chmod +x 就能跑，不挑 glibc 版本。
#
# 两条编译路，和 sw/pl_dma_test/build.sh 一模一样：
#   ① docker + aarch64-linux-gnu-gcc（首选；镜像复用 pl_dma_test 那个，不重拉）
#   ② Docker 没起时，退回 2018.3 SDK 自带的 Windows 原生交叉编译器

set -e
cd "$(dirname "$0")"

LIB=libpl_dma_io.a
DEMO=pl_dma_io_demo
DEMO_SRC=pl_dma_io_demo_src
CFLAGS="-O2 -Wall -Wextra -Wno-unused-parameter -static"

# 和 pl_dma_test 共用同一个工具链镜像：里面已经有 aarch64-linux-gnu-gcc，
# 再建一个一模一样的新镜像没意义（还得重新联网拉基础镜像）。
IMAGE=pl_dma_test_builder

MODE="${1:-all}"

if [ "$MODE" = "clean" ]; then
    rm -f "$LIB" "$DEMO" "$DEMO_SRC" pl_dma_io.o pl_dma_io_demo.o
    echo "已清理（工具链镜像共用 pl_dma_test 的，不动它）"
    exit 0
fi

# ── 选一条编译路 ───────────────────────────────────────────────────────────
NATIVE_BIN="/d/Xilinx/SDK/2018.3/gnu/aarch64/nt/aarch64-linux/bin"
NATIVE_GCC="$NATIVE_BIN/aarch64-linux-gnu-gcc.exe"
NATIVE_AR="$NATIVE_BIN/aarch64-linux-gnu-ar.exe"

USE_DOCKER=0
if docker info >/dev/null 2>&1; then
    USE_DOCKER=1
elif [ ! -x "$NATIVE_GCC" ]; then
    echo "docker 没在跑，也找不到 $NATIVE_GCC"
    exit 1
fi

# Git Bash 下 $(pwd) 是 /d/xxx，docker 不认；转成 Windows 路径
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) HOSTDIR="$(cygpath -w -a "$PWD")" ;;
    *)                    HOSTDIR="$PWD" ;;
esac

if [ "$USE_DOCKER" = 1 ]; then
    CC="aarch64-linux-gnu-gcc"
    AR="aarch64-linux-gnu-ar"
else
    echo "== docker 没在跑，改用 2018.3 SDK 的原生交叉编译器 =="
    CC="$NATIVE_GCC"
    AR="$NATIVE_AR"
fi

# ── 镜像 ───────────────────────────────────────────────────────────────────
# 顺手用 pl_dma_test 那份 build.sh 里同一套挑选顺序，万一镜像被清掉了也能自己建
pick_base() {
    for b in docker.m.daocloud.io/library/ubuntu:20.04 ubuntu:20.04 ububtu20.04:imported; do
        if docker image inspect "$b" >/dev/null 2>&1; then echo "$b"; return; fi
        if docker pull -q "$b" >/dev/null 2>&1; then echo "$b"; return; fi
    done
    echo ""
}

if [ "$USE_DOCKER" = 1 ] && ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    BASE="$(pick_base)"
    [ -n "$BASE" ] || { echo "拉不到任何基础镜像，检查网络/代理"; exit 1; }
    echo "== 准备镜像 $IMAGE（基础镜像 $BASE）=="
    docker build --build-arg BASE="$BASE" -t "$IMAGE" ../pl_dma_test
fi

# 一次编译调用：docker 就进容器，否则直接在本机跑
run() {
    if [ "$USE_DOCKER" = 1 ]; then
        MSYS_NO_PATHCONV=1 docker run --rm -v "$HOSTDIR":/src -w /src "$IMAGE" "$@"
    else
        "$@"
    fi
}

say() { echo "== $* =="; }

# ── 按模式干活 ─────────────────────────────────────────────────────────────
case "$MODE" in
src)
    # 不建库：两个 .c 一起编。这是给"我直接把源码放进我的工程"那种用法准备的。
    say "编译 $DEMO_SRC（demo.c + pl_dma_io.c 直接一起编，不经过 .a）"
    run "$CC" $CFLAGS -o "$DEMO_SRC" pl_dma_io_demo.c pl_dma_io.c
    ls -l "$DEMO_SRC"
    ;;

lib)
    say "编译 $LIB"
    run "$CC" $CFLAGS -c pl_dma_io.c -o pl_dma_io.o
    run "$AR" rcs "$LIB" pl_dma_io.o
    rm -f pl_dma_io.o
    ls -l "$LIB"
    ;;

all)
    say "编译 $LIB"
    run "$CC" $CFLAGS -c pl_dma_io.c -o pl_dma_io.o
    run "$AR" rcs "$LIB" pl_dma_io.o
    rm -f pl_dma_io.o
    ls -l "$LIB"

    say "编译 $DEMO 并链上 $LIB"
    run "$CC" $CFLAGS -c pl_dma_io_demo.c -o pl_dma_io_demo.o
    run "$CC" $CFLAGS -o "$DEMO" pl_dma_io_demo.o -L. -lpl_dma_io
    rm -f pl_dma_io_demo.o
    ls -l "$DEMO"
    ;;

*)
    echo "用法: sh build.sh [lib|src|clean]"
    exit 2
    ;;
esac

echo
echo "== 完成 =="
echo
echo "拷到板子上："
echo "  scp pl_dma_io_demo root@<板子IP>:/root/"
echo "  ssh root@<板子IP>"
echo "  ./pl_dma_io_demo probe      # 先跑这个"
echo "  ./pl_dma_io_demo check"
echo "  ./pl_dma_io_demo soak 20"
echo "  ./pl_dma_io_demo zerocopy"
echo
echo "自己写程序用这个库："
echo "  aarch64-linux-gnu-gcc -O2 -static -I<这里> 你的程序.c -L<这里> -lpl_dma_io -o 你的程序"
echo "（或者直接把 pl_dma_io.c + pl_dma_io.h 抄进你的工程 —— 它就是普通的 C99，没有依赖）"
