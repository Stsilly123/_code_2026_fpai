// iCraft 后端的编译期选择。main.cpp 与 xf_ensemble.cpp 共用，避免两处各写一份
// #if 链后走岔。
#pragma once

#if defined(USE_BUYI_BACKEND)
#include <icraft-backends/buyibackend/buyibackend.h>
#include <icraft-xrt/dev/buyi_device.h>
using FPAIDevice = icraft::xrt::BuyiDevice;
using FPAIBackend = icraft::xrt::BuyiBackend;
#elif defined(USE_ZG330_BACKEND)
// 本板 = 30TAI = ZG330。编译产物必须是 `_ZG.json/.raw`（@zhuget 算子）。
#include <icraft-backends/zg330backend/zg330backend.h>
#include <icraft-xrt/dev/zg330_device.h>
using FPAIDevice = icraft::xrt::ZG330Device;
using FPAIBackend = icraft::xrt::zg330::ZG330Backend;
#else
#error "必须定义 USE_BUYI_BACKEND 或 USE_ZG330_BACKEND（CMake 的 TARGET_CHIP）"
#endif
