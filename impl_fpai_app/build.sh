#!/usr/bin/env bash
#
# impl_fpai_app 的构建脚本 —— 目标永远是板子（Linux aarch64）。
#
# demo 的产物是在板子上原生编的。本脚本两种主机都能编：
#   aarch64（板子上）      -> 本机构建
#   x86_64（PC / docker）  -> 交叉构建，自动带 cmake/toolchain-aarch64.cmake，
#                            需要 aarch64-linux-gnu-g++
# 交叉编译在这儿不是可选项：板端 iCraft SDK 只带 aarch64 的 cmake targets，
# x86_64 上按原生编会在 find_package 就失败（找不到 icraft-*-targets-x64.cmake）。
#
#   bash build.sh                              # 默认 ZG（30TAI）+ 自动探测
#   bash build.sh -c BY                        # 100TAI（布衣）才用 BY
#   bash build.sh -d /root/fpai_demo_app/deps -p /usr
#   bash build.sh -c ZG -j 4
#   bash build.sh --clean                      # 删掉 build/ 重来
#
# 同名环境变量也能用：DEPS_DIR / ICRAFT_PREFIX / TARGET_CHIP / JOBS / CROSS_PREFIX
#
# 编完的产物（路径与 README 一致；交叉构建时两个都是 aarch64）：
#   build/rffi_deploy         主程序
#   build/preprocess_check    离线自检，不依赖 icraft/设备

set -euo pipefail

die()  { printf '\n[ERROR] %s\n' "$*" >&2; exit 1; }
info() { printf '[build] %s\n' "$*"; }
warn() { printf '[warn]  %s\n' "$*" >&2; }

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------- 参数 ---
CHIP="${TARGET_CHIP:-ZG}"
DEPS_DIR_IN="${DEPS_DIR:-}"
ICRAFT_PREFIX_IN="${ICRAFT_PREFIX:-}"
JOBS="${JOBS:-}"
DO_CLEAN=0

usage() {
    sed -n '2,21p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
    exit 0
}

while [ $# -gt 0 ]; do
    case "$1" in
        -c|--chip)   CHIP="${2:-}";              shift 2 ;;
        -d|--deps)   DEPS_DIR_IN="${2:-}";       shift 2 ;;
        -p|--prefix) ICRAFT_PREFIX_IN="${2:-}";  shift 2 ;;
        -j|--jobs)   JOBS="${2:-}";              shift 2 ;;
        --clean)     DO_CLEAN=1;                 shift ;;
        -h|--help)   usage ;;
        *) die "认不出的参数 '$1'（用 -h 看用法）" ;;
    esac
done

CHIP="$(printf '%s' "$CHIP" | tr '[:lower:]' '[:upper:]')"
case "$CHIP" in
    BY) cfg_name="icraft-buyibackend-config.cmake" ;;
    ZG) cfg_name="icraft-zg330backend-config.cmake" ;;
    *)  die "TARGET_CHIP 只能是 BY 或 ZG，收到 '$CHIP'" ;;
esac

# ------------------------------------------------------------- 平台提醒 ---
host_arch="$(uname -m)"
info "主机 $(uname -s) $host_arch  ->  TARGET_CHIP=$CHIP"

# 目标永远是 aarch64（板子）。主机不是 aarch64 就必须交叉编译 —— 原因写在
# cmake/toolchain-aarch64.cmake 开头：iCraft 的 config 按 CMAKE_SYSTEM_PROCESSOR
# 挑 targets 文件，板端 SDK 只有 aarch64 那一套。
CROSS_PREFIX="${CROSS_PREFIX:-aarch64-linux-gnu-}"
TOOLCHAIN=""
case "$host_arch" in
    aarch64|arm64)
        info "aarch64 主机：本机构建，设备走 axi://（config 里的 sys.ip 会被忽略）" ;;
    x86_64|amd64|i386|i686)
        TOOLCHAIN="$here/cmake/toolchain-aarch64.cmake"
        [ -f "$TOOLCHAIN" ] || die \
            "缺 $TOOLCHAIN —— 交叉编译要靠它给 cmake 定架构和编译器。"
        command -v "${CROSS_PREFIX}g++" >/dev/null 2>&1 || die \
"主机是 $host_arch，要编 aarch64 程序，但 PATH 里没有 ${CROSS_PREFIX}g++。
     Debian/Ubuntu：apt-get install -y g++-aarch64-linux-gnu
     换工具链前缀：CROSS_PREFIX=aarch64-none-linux-gnu- bash build.sh
     顺便确认一下 SDK 带的是哪套 targets（板端包应该只有 aarch64）：
         ls ${ICRAFT_PREFIX_IN:-/usr}/cmake/icraft-*-targets-*.cmake"
        # PL 侧 pl_dma_io.c 是 C 源；只装 g++ 不装 gcc 会在 configure 阶段才报错。
        command -v "${CROSS_PREFIX}gcc" >/dev/null 2>&1 || die \
"PATH 里没有 ${CROSS_PREFIX}gcc。PL 侧 pl_dma_io.c 需要 C 编译器；
     Debian/Ubuntu：apt-get install -y gcc-aarch64-linux-gnu
     只编主干：cmake 加 -DENABLE_PL_CNN=OFF"
        info "x86_64 主机：交叉编译 aarch64，工具链 ${CROSS_PREFIX}g++/gcc"
        info "交叉构建的二进制只能拷到板子上跑，本机跑不了。" ;;
    *)
        die "不认识的主机架构 '$host_arch'：本脚本只支持 aarch64（板子上原生编）
     或 x86_64（交叉编）。" ;;
esac

# ----------------------------------------------------------- 找 cmake ---
CMAKE="${CMAKE:-}"
if [ -z "$CMAKE" ]; then
    if command -v cmake >/dev/null 2>&1; then
        CMAKE="$(command -v cmake)"
    else
        # 板子上 demo 是用 /usr/cmake 编的，所以这里也认这个位置
        for c in /usr/cmake/bin/cmake /usr/local/cmake/bin/cmake \
                 /opt/cmake/bin/cmake /usr/bin/cmake; do
            [ -x "$c" ] && { CMAKE="$c"; break; }
        done
    fi
fi
[ -n "$CMAKE" ] || die "找不到 cmake。装一个，或用 CMAKE=/path/to/cmake 指定。"
info "cmake: $CMAKE ($("$CMAKE" --version | head -n1))"

# -------------------------------------------------------------- deps ---
DEPS_DIR="$DEPS_DIR_IN"
if [ -z "$DEPS_DIR" ]; then
    # 常见摆放位置，按可能性排
    for c in "$here/../deps" "$here/../fpai_demo_app/deps" \
             "$HOME/fpai_demo_app/deps" "/root/fpai_demo_app/deps" \
             "/opt/fpai_demo_app/deps"; do
        if [ -d "$c/thirdparty/include" ]; then
            DEPS_DIR="$(cd -- "$c" && pwd)"
            break
        fi
    done
fi
[ -n "$DEPS_DIR" ] || die "找不到 deps 目录（其下要有 thirdparty/include）。用 -d <fpai_demo_app>/deps 指过去。"
[ -d "$DEPS_DIR/thirdparty/include" ] || die "DEPS_DIR='$DEPS_DIR' 下没有 thirdparty/include。"
info "deps: $DEPS_DIR"

# 目标永远是 aarch64，所以原生和交叉用的都是 deps/thirdparty/a/*.a。
# 只拷了 Windows 那套（thirdparty/lib/*.lib）时在这里拦住 —— 比链接器报
# "cannot find -lfmt" 清楚得多。
for lib in libfmt.a libyaml-cpp.a; do
    [ -f "$DEPS_DIR/thirdparty/a/$lib" ] || \
        die "缺 $DEPS_DIR/thirdparty/a/$lib —— deps 是不是只拷了 Windows 的 lib/？"
done

# ----------------------------------------------------------- iCraft SDK ---
ICRAFT_PREFIX="$ICRAFT_PREFIX_IN"
if [ -z "$ICRAFT_PREFIX" ]; then
    for c in /usr /usr/local /opt/icraft /opt/Icraft; do
        if [ -e "$c/cmake/$cfg_name" ]; then
            ICRAFT_PREFIX="$c"
            break
        fi
    done
fi
[ -n "$ICRAFT_PREFIX" ] || die \
"在 /usr /usr/local /opt/icraft 下都找不到 cmake/$cfg_name。
    板子的 iCraft SDK 装了吗？（icraft_deb/ 下那两个 .deb）
    装在别处就用 -p <prefix> 指过去。"
[ -e "$ICRAFT_PREFIX/cmake/$cfg_name" ] || die \
"ICRAFT_PREFIX='$ICRAFT_PREFIX' 下没有 cmake/$cfg_name。"
info "iCraft SDK: $ICRAFT_PREFIX"

# 把 SDK 带的 targets 列出来：iCraft 按 CMAKE_SYSTEM_PROCESSOR 从中挑一个，
# 板端包只有 aarch64 那套。这一行就是「架构对不对」的答案，省得去翻 CMake 报错。
sdk_targets=""
for t in "$ICRAFT_PREFIX"/cmake/icraft-*-targets-*.cmake; do
    [ -e "$t" ] || continue
    sdk_targets="${sdk_targets}${t##*/} "
done
info "SDK targets: ${sdk_targets:-（没找到 icraft-*-targets-*.cmake，SDK 装得不全？）}"

# -------------------------------------------------------------- 预检 ---
# 这三样不在就编不出能跑的东西，但 CMake 不会替我们查（它们是运行期才读的）。
missing=0
# 本板是 ZG330（30TAI），要的是 _ZG 的产物。BY 那份（_BY）是 @buyit 算子，
# ZG330 上跑不了 —— 有文件也没用。
for f in imodel/xf20/fused_b25_ZG.json imodel/xf20/fused_b25_ZG.raw \
         imodel/lcwt_head/lcwt_head_20cls_lnps_b5_ZG.json \
         imodel/lcwt_head/lcwt_head_20cls_lnps_b5_ZG.raw \
         imodel/lcwt_head/lcwt_head_20cls_aux.bin \
         imodel/expert/expert_mlp_165_fp16_ZG.json \
         imodel/expert/expert_mlp_165_fp16_ZG.raw; do
    if [ ! -f "$here/$f" ]; then
        warn "缺 $f —— 配置里 xf.models / pl.head_* / pl.expert_* 指向它。"
        warn "  必须是 ZG330 的最终 _ZG 产物，不是 quantized 阶段图。"
        missing=1
    fi
done
[ -f "$here/configs/rffi_transformer.yaml" ] || { warn "缺 configs/rffi_transformer.yaml"; missing=1; }
if [ ! -f "$here/names/class_names_20.txt" ]; then
    warn "缺 names/class_names_20.txt —— 程序只会打裸下标，不影响 argmax。"
    warn "在 PC 上跑 tools/export_class_names.py 生成后拷过来。"
fi
[ "$missing" -eq 0 ] || warn "先补齐上面缺的文件，否则编出来也跑不起来。"

# -------------------------------------------------------------- 配置 ---
JOBS="${JOBS:-$( (command -v nproc >/dev/null 2>&1 && nproc) || echo 2 )}"
build="$here/build"
[ "$DO_CLEAN" -eq 1 ] && { info "清掉 $build"; rm -rf "$build"; }

prefix_path="$ICRAFT_PREFIX"
[ -n "${CMAKE_PREFIX_PATH:-}" ] && prefix_path="$ICRAFT_PREFIX;${CMAKE_PREFIX_PATH}"

# 上次「没带 toolchain」配出来的 build/ 里存的是主机 x86 的编译器，那份缓存会让
# 交叉编译继续用错编译器。对不上就把 build/ 删掉重配（只删 build/，别的不动）。
if [ -f "$build/CMakeCache.txt" ] && [ -n "$TOOLCHAIN" ]; then
    cached_cc="$(sed -n 's/^CMAKE_CXX_COMPILER:FILEPATH=//p' "$build/CMakeCache.txt" | head -n1)"
    case "$cached_cc" in
        *aarch64*) : ;;
        *)
            info "build/ 里的编译器是 '$cached_cc'（不是交叉编译器）—— 先删掉 build/"
            rm -rf "$build" ;;
    esac
fi

cmake_args=(-S "$here" -B "$build"
    -DCMAKE_BUILD_TYPE=Release
    -DTARGET_CHIP="$CHIP"
    -DDEPS_DIR="$DEPS_DIR"
    -DCMAKE_PREFIX_PATH="$prefix_path")
# 交叉编译时把 toolchain 和前缀都显式传下去（toolchain 里的 cache 值会记住上一次的，
# 换了 CROSS_PREFIX 不传 -D 的话会继续用旧前缀）。
[ -n "$TOOLCHAIN" ] && cmake_args+=("-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN" "-DCROSS_PREFIX=$CROSS_PREFIX")

info "配置 -> $build"
# 把展开后的命令打出来：配置失败时，这一行能省一次来回问「你到底传了什么」。
info "  $CMAKE ${cmake_args[*]}"
"$CMAKE" "${cmake_args[@]}"

# -------------------------------------------------------------- 编译 ---
info "编译（-j$JOBS）"
"$CMAKE" --build "$build" -j "$JOBS"

# -------------------------------------------------------------- 收尾 ---
[ -x "$build/rffi_deploy" ]      || die "编完了但没找到 build/rffi_deploy。"
[ -x "$build/preprocess_check" ] || warn "没找到 build/preprocess_check（离线自检用）。"

if [ -n "$TOOLCHAIN" ]; then
    target_note="aarch64 交叉构建 —— 拷到板子上跑，本机跑不了"
else
    target_note="aarch64 本机构建"
fi

cat <<EOF

============================================================
编好了：$build/rffi_deploy（$target_note）

下一步（见 README「上板步骤」，按顺序别跳）：

  1) 离线帧流,绕开网络 —— 先把 configs 里的 input.mode 改成 file
       cd "$here" && ./build/rffi_deploy configs/rffi_transformer.yaml

  2) 网口端到端 —— input.mode 改回 tcp，板子起服务端
       cd "$here" && ./build/rffi_deploy configs/rffi_transformer.yaml
     然后 PC 上：
       python tools/send_iq.py --host <板子IP> --n 256 | tee samples/board.log

  3) 对拍（判链路是否正确的硬证据）—— 主机 test 参考：
       XF 五折×平移 82.2% / PL 无 TTA 71.2% / 融合 w=1/3 83.0%；
       板端最终 _ZG 五折 INT8 是 82.81%，融合 83.20%。偏差 >2 点再查
       字节序、Q10/Q8 缩放和归一化；别拿 quantized 阶段图当部署精度。

注意：配置里的路径都是 CWD 相对，所以要 cd 到 $here 再跑。
============================================================
EOF
