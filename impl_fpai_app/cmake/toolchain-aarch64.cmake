# 交叉编译到板子（Linux aarch64）的 toolchain 文件。用 build.sh 会自动带上；
# 手写 cmake 时加 -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-aarch64.cmake。
#
# 为什么非得有这个文件：iCraft 的 *-config.cmake 不看你用什么编译器，只按
# CMAKE_SYSTEM_PROCESSOR 挑 targets 文件（icraft-utils-config.cmake:28-40）：
#
#   UNIX  + aarch64|arm64|armv[0-9]  ->  icraft-*-targets-aarch64.cmake
#   UNIX  + 其它（x86_64）            ->  icraft-*-targets-x64.cmake
#   WIN32                            ->  icraft-*-targets-win.cmake
#
# 板端 SDK（icraft_deb/*_onchip.deb）只带 aarch64 那一套。所以在 x86_64 主机上
# 直接 `cmake -S . -B build`，find_package 会去找一个不存在的
# icraft-utils-targets-x64.cmake，报：
#
#   CMake Error at /usr/cmake/icraft-utils-config.cmake:32 (include):
#     include could not find requested file: /usr/cmake/icraft-utils-targets-x64.cmake
#
# demo 的对付办法是在 CMakeLists 的 UNIX 分支里硬写 SET(CMAKE_SYSTEM_PROCESSOR
# aarch64)（examples/1_single_input+ai/PLin+SingleNet+HDMI/CMakeLists.txt:110），
# 但那行在 project() 之后才执行 —— 骗得过 config 文件，改不动编译器：编出来还是
# x86 目标文件，链 arm64 的 libfmt.a/libyaml-cpp.a/icraft 时会撞 "file format not
# recognized"/"incompatible"。toolchain 文件在 project() 之前生效，架构和编译器
# 一起对上，这才是对的位置。

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# 工具链前缀可以覆盖：Debian/Ubuntu 的包叫 aarch64-linux-gnu-，Yocto 的 SDK 可能
# 是 aarch64-none-linux-gnu- 或 aarch64-poky-linux-。
# 优先级：-DCROSS_PREFIX=... → 环境变量 CROSS_PREFIX → 默认 aarch64-linux-gnu-。
# 注意别写成「先 set 普通变量再 set(... CACHE)」：CMP0126 在 3.16 下是 OLD，
# 那句 cache set 会把普通变量删掉，值就丢了。所以先算好再一次性进 cache。
if(DEFINED ENV{CROSS_PREFIX})
    set(_icraft_cross_default "$ENV{CROSS_PREFIX}")
else()
    set(_icraft_cross_default "aarch64-linux-gnu-")
endif()
set(CROSS_PREFIX "${_icraft_cross_default}" CACHE STRING "交叉工具链前缀（默认 aarch64-linux-gnu-）")

set(CMAKE_C_COMPILER   "${CROSS_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${CROSS_PREFIX}g++")

# find_program 只在主机上找（cmake/ninja 这些是主机的），别去 sysroot 里翻。
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# 注意：LIBRARY/INCLUDE/PACKAGE 三个模式**故意不动**（保持默认 ANY）。
# 设成 ONLY 会让 find_package 只在 sysroot 里找，而 iCraft 的 config 在
# /usr/cmake 下、deps 的 .a 在 ${DEPS_DIR}/thirdparty/a 下，都不在 sysroot 里，
# 一设 ONLY 反而全部找不到。要防的是「抓到主机的 x86 库」，而这件事由交叉 gcc
# 默认的搜索路径（/usr/<prefix>/lib）挡住了，用不着 ONLY。
