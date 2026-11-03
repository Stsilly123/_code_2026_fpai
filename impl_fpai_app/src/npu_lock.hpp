// ZG330 上同时只有一个 NPU。XF 和 LCWT 分类头是两个独立 Session，
// 现在又分属主线程和 PL 工作线程 —— 并发 forward（以及 forward 后的
// device.reset(1)）没有验证过，reset 还可能踩到另一个 Session 的在途结果。
// 所以给「一次完整 NPU 前向」加一把进程内的锁，两边都拿它。
//
// 锁的粒度是**整次前向**（写输入 → forward → waitForReady → reset → to(Host)），
// 不是单个算子；这样 reset 不会跨进另一个 Session。
#pragma once

#include <mutex>

namespace rffi {

inline std::mutex &npu_mutex() {
    static std::mutex m;
    return m;
}

}  // namespace rffi
