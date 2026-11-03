# 交叉编译用镜像：x86_64 的 Docker 里跑 aarch64 的交叉工具链
# （板子是 Cortex-A53 aarch64，主机是 win/amd64，所以用交叉编译器而不是 qemu）
#
# 基础镜像默认走 daocloud 镜像站——本机到 registry-1.docker.io 连不通（IPv6 路由不通），
# 换 ubuntu:20.04 的官方源也可以，见 build.sh 里的 BASE 选择。
ARG BASE=docker.m.daocloud.io/library/ubuntu:20.04
FROM ${BASE}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gcc-aarch64-linux-gnu \
        libc6-dev-arm64-cross \
        binutils-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
