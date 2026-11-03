cmake_minimum_required(VERSION 3.16)
# C 是给 PL 侧 pl_dma_io.c 用的（只有 ENABLE_PL_CNN=ON 时才会真正编它）。
project(impl_fpai_app LANGUAGES C CXX)

# 骨架抄自 fpai_demo_app/examples/1_single_input+ai/PLin+SingleNet+HDMI/CMakeLists.txt，
# 但砍掉了 opencv / ffmpeg / OpenEXR / onnxruntime 那一整串 —— 本程序不做图像，
# 也不 include `icraft_utils.hpp`（那个头 include 了 PicPre.hpp，会把 opencv 拖进来）。
# 需要的只有 spdlog（头文件 + 自带 fmt）与 yaml-cpp。

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# 不给 CMAKE_BUILD_TYPE 时 CMake 会一个 -O 都不加，板端编出来是个没优化的二进制。
# 单配置生成器（板上的 Makefile/Ninja）才需要这个默认；多配置生成器（VS）自己管。
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "构建类型" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
endif()
message(STATUS "构建类型 = ${CMAKE_BUILD_TYPE}")

# ---------------------------------------------------------------- 芯片后端 ---
# **默认 ZG**：部署目标是 30TAI（ZG330）。100TAI 是 BY（布衣），要显式 -DTARGET_CHIP=BY。
#
# 这个开关不改变设备名 —— 设备名在 configs/rffi_transformer.yaml 的 sys.run_backend 里。
# 两处必须一致：TARGET_CHIP 和 run_backend 对不上，会编出一个「用 BY 设备名去开 ZG 板」
# 的程序，Device::Open 直接把 PS 的 AXI 总线锁死（实测）。
set(TARGET_CHIP "ZG" CACHE STRING "ZG (ZG330 / 30TAI) 或 BY (Buyi / 100TAI)")
set_property(CACHE TARGET_CHIP PROPERTY STRINGS "BY" "ZG")
string(TOUPPER "${TARGET_CHIP}" _chip)
if(_chip STREQUAL "BY")
    add_compile_definitions(USE_BUYI_BACKEND)
elseif(_chip STREQUAL "ZG")
    add_compile_definitions(USE_ZG330_BACKEND)
else()
    message(FATAL_ERROR "TARGET_CHIP 只能是 BY 或 ZG，收到 '${TARGET_CHIP}'")
endif()
message(STATUS "TARGET_CHIP = ${_chip}")

# ------------------------------------------------------------- PL 侧 CNN ---
# dma1 = LCWT 主干 token（NPU 头在 lcwt_head.cpp），dma2 = 均衡后 IQ（XF 的输入），
# dma3 = 专家特征。驱动**已拷贝**到 third_party/pl_dma_io/
#   （来自 FPAI_PL/RFFI_FPAI/sw/pl_dma_io，唯一改动是 PL_DMA_POST_MS 默认 0，
#    见该目录 SOURCE.txt），本工程只编这份拷贝，不跨工作区取源文件；FPGA 侧只读不改。
# 为什么不链预编的 libpl_dma_io.a：那份 .a 是另一套工具链编的，源码本来就是
# C99 无依赖（驱动 README 也明说「直接抄进你的工程」），编源码可以保证
# ABI/优化选项和本程序完全一致。
#
# 目标平台（板子）是 aarch64，默认开；Windows/x86 本机构建默认关，
# pl_side.cpp 走桩 —— 编译期就能发现接口问题，但不会去碰 /dev/mem。
set(_pl_side_default OFF)
if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64|armv[0-9]")
    set(_pl_side_default ON)
endif()
option(ENABLE_PL_CNN "编译 PL 侧 CNN 的 pl_dma_io 通路（aarch64 默认 ON）" ${_pl_side_default})
set(PL_DMA_IO_DIR "${CMAKE_CURRENT_SOURCE_DIR}/third_party/pl_dma_io"
    CACHE PATH "pl_dma_io 驱动目录（本工程内的拷贝）")
if(ENABLE_PL_CNN)
    if(NOT EXISTS "${PL_DMA_IO_DIR}/pl_dma_io.c")
        message(FATAL_ERROR
            "ENABLE_PL_CNN=ON，但 ${PL_DMA_IO_DIR} 下找不到 pl_dma_io.c。\n"
            "third_party/pl_dma_io/ 应包含 pl_dma_io.c/.h（从 "
            "FPAI_PL/RFFI_FPAI/sw/pl_dma_io 拷贝）；"
            "或 -DENABLE_PL_CNN=OFF 只编主干。")
    endif()
    enable_language(C)
    message(STATUS "PL CNN = ON（pl_dma_io: ${PL_DMA_IO_DIR}）")
else()
    message(STATUS "PL CNN = OFF（pl_side.cpp 走桩，不碰 /dev/mem）")
endif()

# ------------------------------------------------------------------ 依赖 ---
# fpai_demo_app 的 deps 目录（含 thirdparty/）。demo 用的是相对路径 ../../../deps，
# 但本工程和 demo 不在同一个盘，抄不过来，所以改成可覆盖的缓存变量。
set(DEPS_DIR "D:/FPGA_PR/Fmql_env/20260916/fpai_demo_app/fpai_demo_app/deps"
    CACHE PATH "fpai_demo_app 的 deps 目录（其下有 thirdparty/）")
if(NOT EXISTS "${DEPS_DIR}/thirdparty/include")
    message(FATAL_ERROR
        "DEPS_DIR='${DEPS_DIR}' 下找不到 thirdparty/include。\n"
        "用 -DDEPS_DIR=<fpai_demo_app>/deps 指过去。")
endif()
message(STATUS "DEPS_DIR = ${DEPS_DIR}")

if(WIN32)
    # icraft 的 cmake 包配置在安装根下的 cmake/，find_package 要靠 CMAKE_PREFIX_PATH 找。
    # 没装在标准位置时可以用 -DICRAFT_ROOT=... 覆盖。
    set(ICRAFT_ROOT "C:/Icraft/CLI v3.36.1" CACHE PATH "iCraft CLI 安装根（含 cmake/ 与 lib/）")
    list(APPEND CMAKE_PREFIX_PATH "${ICRAFT_ROOT}")
endif()

# ------------------------------------------------------ iCraft SDK 的架构 ---
# iCraft 的 *-config.cmake **不看编译器，只看 CMAKE_SYSTEM_PROCESSOR** 来挑
# targets 文件（每个包的 config 都是同一套 if，见 icraft-utils-config.cmake:28-40）：
#
#   UNIX  + aarch64|arm64|armv[0-9]  ->  icraft-*-targets-aarch64.cmake
#   UNIX  + 其它（x86_64）            ->  icraft-*-targets-x64.cmake
#   WIN32                            ->  icraft-*-targets-win.cmake
#
# 板端 SDK（icraft_deb/*_onchip.deb）只带 aarch64 那一套，所以在 x86_64 主机上
# 原生 cmake 一定失败：
#   include could not find requested file: /usr/cmake/icraft-utils-targets-x64.cmake
# 修法不是改这里，是交叉编译：-DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-aarch64.cmake
# （cmake/toolchain-aarch64.cmake 里写了为什么不硬 SET(CMAKE_SYSTEM_PROCESSOR)。
# build.sh 在 x86_64 主机会自动带上这个 toolchain。）
#
# 下面这段只做两件事：把 SDK 的 cmake/ 找出来、架构对不上时把话说明白 —— 而不是
# 让 find_package 抛一句看不出因果的 include 错误。
find_path(ICRAFT_CMAKE_DIR icraft-utils-config.cmake
    HINTS ${ICRAFT_ROOT} ${CMAKE_PREFIX_PATH} ENV ICRAFT_ROOT ENV ICRAFT_PREFIX
    PATH_SUFFIXES cmake)
# 允许传 SDK 安装根（-DICRAFT_CMAKE_DIR=/usr）而不只是 cmake/ 目录
if(ICRAFT_CMAKE_DIR AND NOT EXISTS "${ICRAFT_CMAKE_DIR}/icraft-utils-config.cmake"
   AND EXISTS "${ICRAFT_CMAKE_DIR}/cmake/icraft-utils-config.cmake")
    set(ICRAFT_CMAKE_DIR "${ICRAFT_CMAKE_DIR}/cmake")
endif()

if(NOT ICRAFT_CMAKE_DIR)
    message(FATAL_ERROR
        "找不到 icraft-utils-config.cmake，find_package(Icraft-*) 无从谈起。\n"
        "已经找过：CMAKE_PREFIX_PATH、ICRAFT_ROOT、ICRAFT_PREFIX 环境变量（各加 cmake/ 后缀）。\n"
        "用 -DICRAFT_CMAKE_DIR=<SDK 根或 cmake 目录> 指过去，例如 -DICRAFT_CMAKE_DIR=/usr。")
endif()
message(STATUS "iCraft SDK cmake = ${ICRAFT_CMAKE_DIR}")

file(GLOB _icraft_target_sets RELATIVE "${ICRAFT_CMAKE_DIR}"
     "${ICRAFT_CMAKE_DIR}/icraft-utils-targets-*.cmake")
if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64|armv[0-9]")
    set(_icraft_arch aarch64)
elseif(WIN32)
    set(_icraft_arch win)
else()
    set(_icraft_arch x64)
endif()
if(NOT EXISTS "${ICRAFT_CMAKE_DIR}/icraft-utils-targets-${_icraft_arch}.cmake")
    string(REPLACE ";" " " _icraft_target_sets_txt "${_icraft_target_sets}")
    message(FATAL_ERROR
        "iCraft SDK 里没有 icraft-utils-targets-${_icraft_arch}.cmake，find_package 必失败。\n"
        "  CMAKE_SYSTEM_PROCESSOR = '${CMAKE_SYSTEM_PROCESSOR}'   <- SDK 按它挑 targets\n"
        "  SDK 实际带的 targets   = ${_icraft_target_sets_txt}\n"
        "按这套 SDK 只有两种可能：\n"
        "  1) 只有 aarch64（板端 SDK），而主机是 x86_64 -> 必须交叉编译：\n"
        "       bash build.sh            # 自动带 cmake/toolchain-aarch64.cmake\n"
        "  2) 只有 win（/usr 里装的是 Windows 版 CLI）-> 板端 SDK 没装，装\n"
        "       icraft_deb/Icraft_*_onchip.deb 再编。")
endif()

find_package(Icraft-BuyiBackend REQUIRED)
find_package(Icraft-HostBackend REQUIRED)
if(_chip STREQUAL "ZG")
    find_package(icraft-zg330backend REQUIRED)
endif()

if(WIN32)
    add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/permissive->")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/wd4244>")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
    link_directories(${DEPS_DIR}/thirdparty/lib)
    link_libraries(fmt yaml-cpp ws2_32)
else()
    link_directories(${DEPS_DIR}/thirdparty/a)
    # spdlog 自带 bundled fmt（thirdparty/include/spdlog/fmt/bundled），但本程序也直接用
    # fmt::print，所以仍然显式链 fmt。
    link_libraries(fmt yaml-cpp pthread dl zlib)
endif()

# ------------------------------------------------------------------ 目标 ---
add_executable(rffi_deploy
    src/main.cpp
    src/net_source.cpp
    src/pl_side.cpp
    src/lcwt_head.cpp
    src/expert_head.cpp
    src/xf_ensemble.cpp
)

# 注意：**没有** ${DEPS_DIR}/thirdparty/include/fmt —— 那个目录不存在（deps 里只有
# fmt.lib / libfmt.a，没有 fmt/ 头）。源码里因此写 `<spdlog/fmt/fmt.h>` 而不是
# `<fmt/format.h>`，否则会静默落到 icraft 安装目录自带的 fmt 上（隐式 include 路径）。
# demo 的 CMakeLists 里也有这一行，是同一个不存在的路径，照抄过来只会掩盖问题。
target_include_directories(rffi_deploy PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${DEPS_DIR}/thirdparty/include
    ${DEPS_DIR}/thirdparty/include/spdlog
)

if(_chip STREQUAL "BY")
    set(_icraft_backends Icraft::HostBackend Icraft::BuyiBackend)
else()
    set(_icraft_backends Icraft::HostBackend Icraft::ZG330Backend)
endif()

target_link_libraries(rffi_deploy PRIVATE ${_icraft_backends})

# PL 侧 DMA 驱动。源文件路径在 FPAI_PL 下，属于**只读引用**（不往那边写任何东西）。
if(ENABLE_PL_CNN)
    target_sources(rffi_deploy PRIVATE ${PL_DMA_IO_DIR}/pl_dma_io.c)
    target_include_directories(rffi_deploy PRIVATE ${PL_DMA_IO_DIR})
    target_compile_definitions(rffi_deploy PRIVATE IMPL_HAS_PL_DMA=1)
else()
    target_compile_definitions(rffi_deploy PRIVATE IMPL_HAS_PL_DMA=0)
endif()

# 离线自检预处理（反交错 + PerSampleNorm）。**不依赖 icraft、不依赖设备**，
# 所以在 PC 上就能跑 —— 用来把「预处理写错」和「板子跑不通」分离开。
add_executable(preprocess_check tools/preprocess_check.cpp)
target_include_directories(preprocess_check PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Windows 上 yaml-cpp 是动态库，得和 exe 放一起才跑得起来。
if(WIN32 AND EXISTS "${DEPS_DIR}/thirdparty/dll/yaml-cpp.dll")
    add_custom_command(TARGET rffi_deploy POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "${DEPS_DIR}/thirdparty/dll/yaml-cpp.dll"
                "$<TARGET_FILE_DIR:rffi_deploy>"
        COMMENT "拷贝 yaml-cpp.dll 到输出目录")
endif()
