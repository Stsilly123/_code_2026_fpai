# 板卡侧接口文档（RFFI · rffi_deploy）

本文是写给**板端程序 `rffi_deploy`（impl_fpai_app）开发者**的接口规格，和
[host_interface.md](host_interface.md) 互为补充：

- `host_interface.md`：写给上位机开发者，重点是怎么连、怎么发、怎么收；
- 本文：写给板端开发者，重点是**收到请求后必须回什么、在现有代码的哪里改**。

上位机（Windows 软件）已经按本文的协议实现并验证完毕。板端目前只完成了
「收帧 → 解析 → 归一化 → 前向 → 打印」；**缺的是每帧推理完成后把结果帧发回上位机**。
补上这条回程，上位机才能显示预测、top-k 和板端延迟。

---

## 1. 总体约定

```
  上位机 (Windows)                          板卡 rffi_deploy (TCP 服务端)
       |  connect(板卡IP:9527)                    |
       | ---------------------------------------> | accept
       |  RFIQ 请求：32 B 头 + 载荷                 |
       | ---------------------------------------> | 收帧/校验/归一化/前向/softmax
       |  RFIO 结果：40 B 头 + k×8 B               |
       | <--------------------------------------- | 每收到一帧，回一帧
       |  RFIQ 请求 ...                             |
       | ---------------------------------------> |
       |  RFIO 结果 ...                             |
       | <--------------------------------------- |
       |  close()                                  | 回到 accept
```

| 项 | 值 |
|---|---|
| 传输 | TCP，**板子 listen**，上位机 connect |
| 默认端口 | `9527`（`configs/rffi_transformer.yaml` 的 `input.port`） |
| 并发 | 同一时刻只服务 1 个客户端 |
| 帧大小 | 请求 32 B 头 + 2048/1024 B；结果 40 B 头 + `8×k` B |
| 字节序 | **全小端**（x86 / aarch64 原生小端） |
| 请求 version | `1` |
| 结果 version | `2` |
| 一帧 | 256 个复样本（512 个标量）= 一次分类 |
| 节奏 | **一请求 → 一结果**，结果按请求顺序返回，`seq` 原样回显 |

三条必须遵守的规则：

1. **每个合法请求都要回一个结果帧**，包括推理失败的情况（用 `status=2`），
   否则上位机会一直等这一帧，`seq` 对不上。
2. **结果里的 `seq` / `label` / `timestamp_ns` 必须原样回显**。上位机靠 `seq`
   把结果和发出的帧对齐、统计丢帧和准确率。
3. **结果头的 40 B 布局一个字节都不能错**。上位机按 `magic + version + k` 校验，
   magic 错会当作字节流错位并断开重连。

---

## 2. 请求帧（上位机 → 板卡，已实现，仅作对照）

### 2.1 头（32 B，`struct "<IHHiIIfQ"`）

| 偏移 | 大小 | 类型 | 字段 | 约束 |
|---:|---:|---|---|---|
| 0 | 4 | u32 | `magic` | 必须 `0x51494652`（`RFIQ`） |
| 4 | 2 | u16 | `version` | 必须 `1` |
| 6 | 2 | u16 | `dtype` | `0`=float32，`1`=int16，`2`=控制帧（见 2.3） |
| 8 | 4 | i32 | `label` | 真值 `0..149`，未知 `-1` |
| 12 | 4 | u32 | `seq` | 发送端自增 |
| 16 | 4 | u32 | `n_complex` | 必须等于 `net.seg_len`（256） |
| 20 | 4 | f32 | `value_scale` | 仅 int16：真值 = `raw_i16 × value_scale` |
| 24 | 8 | u64 | `timestamp_ns` | 上位机时间戳，**结果里要回显** |

### 2.2 载荷

`n_complex` 个复样本，**I/Q 交错**（`I0,Q0,I1,Q1,…`），小端：

- `dtype=0`：float32，2048 B；
- `dtype=1`：int16，1024 B，按 `value_scale` 还原成 float。

载荷是**原始未归一化 IQ**，归一化由板端 `deinterleave_normalize()` 做。
这部分现有代码 `src/iq_frame.hpp` / `src/net_source.cpp` 已经正确处理，不需要改。

### 2.3 控制帧（`dtype=2`，2026-10 新增）

和 IQ 帧走同一条连接、同一个 32 B 头。`n_complex` 必须是 `0`，载荷 8 B：

| 相对偏移 | 大小 | 类型 | 字段 | 说明 |
|---:|---:|---|---|---|
| 0 | 4 | u32 | `cmd` | `1`=SetMode，`2`=QueryMode |
| 4 | 4 | i32 | `arg` | SetMode：`0`=fast，`1`=fusion，`2`=analysis；QueryMode 填 0 |

板端处理完命令后回一帧结果头：**`status=4`（CommandAck）表示接受，`2`（Error）表示
拒绝**；`pred` = 当前模式，`label` = 回显的命令号，`seq`/`timestamp_ns` 原样回显，
`k=0`，后面不跟任何条目。控制帧**不产生分类结果**。

| 模式 | 板端跑什么 | 回帧 status |
|---|---|---|
| `0` fast | 只跑 transformer（XF）；PL 只取均衡 IQ，不跑 LCWT 头 / TTA 第二轮 / 专家 MLP | `0` Ok |
| `1` fusion | XF + PL + 专家三路融合（默认） | `0` Ok |
| `2` analysis | 三路都跑但**不看预测**，回信号本身（FFT/星座/专家特征） | `3` Analysis |

分析模式的回帧在 top-k 之后跟一块 `IqAnalysis`（40 B 头 + 若干段 float32），
布局见 `src/iq_frame.hpp` 的 `IqAnalysisHeader` 和 README 的「三·四」一节。

---

## 3. 结果帧（板卡 → 上位机，**待实现**）

### 3.1 结构

```
┌───────────── 40 B 定长头 ─────────────┬──── k × 8 B ────┐
│ magic/version/status/seq/label/...    │ top-k 条目       │
└───────────────────────────────────────┴──────────────────┘
```

### 3.2 头（40 B，`struct "<IHHIiifIHHQ"`，`#pragma pack(1)`）

| 偏移 | 大小 | 类型 | 字段 | 取值 / 含义 |
|---:|---:|---|---|---|
| 0 | 4 | u32 | `magic` | 恒为 `0x4F494652`（`RFIO`） |
| 4 | 2 | u16 | `version` | 恒为 `2` |
| 6 | 2 | u16 | `status` | `0`=Ok，`1`=NoSignal，`2`=Error |
| 8 | 4 | u32 | `seq` | **原样回显请求的 `seq`** |
| 12 | 4 | i32 | `label` | **原样回显请求的 `label`** |
| 16 | 4 | i32 | `pred` | top-1 类别下标 `0..149`；`status≠0` 时填 `-1` |
| 20 | 4 | f32 | `prob` | top-1 的 softmax 概率；`status≠0` 时填 `0` |
| 24 | 4 | u32 | `latency_us` | 本帧板端耗时，**微秒**（见 §5.3） |
| 28 | 2 | u16 | `k` | 后面跟几条 top-k，通常 = `input.topk`（5） |
| 30 | 2 | u16 | `reserved` | 填 `0` |
| 32 | 8 | u64 | `timestamp_ns` | **原样回显请求的 `timestamp_ns`** |

### 3.3 top-k 条目（每条 8 B，`struct "<If"`）

| 相对偏移 | 大小 | 类型 | 字段 |
|---:|---:|---|---|
| 0 | 4 | u32 | `class_idx`，`0..149` |
| 4 | 4 | f32 | `prob`，该类的 softmax 概率 |

约束：

- 按概率**降序**排列，第一条必须等于头里的 `pred/prob`；
- 条数严格等于头里的 `k`，整帧字节数 = `40 + 8×k`；
- `k` 不能超过 `input.topk`，也不能超过 `num_classes`；
- 概率用 **float32**，不是 double、不是 int8 量化值。

### 3.4 状态码

| status | 场景 | pred | prob | k | 上位机行为 |
|---|---|---|---|---|---|
| `0` Ok | 正常分类 | `0..149` | softmax top-1 | topk | 显示预测、top-5、计入命中率 |
| `1` NoSignal | 判为无信号（可选功能，见 §5.2） | `-1` | `0` | `0` | 显示「板端判为无信号」，不计命中率 |
| `2` Error | 本帧处理失败（前向异常、输出不是 32bit 等）；也是控制帧被拒的应答 | `-1` | `0` | `0` | 显示错误；连接可继续 |
| `3` Analysis | 分析模式（见 2.3），`k` 条是专家 top-k，后面跟分析块 | `0..19` | 专家 top-1 | topk | 显示信号/频谱/专家特征，不计命中率 |
| `4` CommandAck | 控制帧被接受，`pred` = 当前模式，`label` = 命令号 | `0..2` | `0` | `0` | 更新界面上的模式开关 |

> 没有实现无信号判定时，**永远发 `status=0`** 即可，不要凭空发 `1`。

### 3.5 类别名

结果里**只发下标**。上位机自己按 `class_names.txt` 的行号（0 起）显示名字。
板端不要发字符串，也不要在结果里塞额外字段——多出来的字节会被上位机当成下一帧的头。

---

## 4. 板端实现步骤（对着现有代码改）

现有代码已经算出了 `softmax_topk()` 的结果 `top`（`std::vector<TopKItem>`），
只差把它打包发回去。建议按下面三步改，改动集中在 3 个文件，不动推理链路。

### 4.1 新增 `src/result_frame.hpp`

```cpp
// RFIO 结果帧的线格式。与上位机 host_interface.md 的 "结果帧" 一节逐字节对应。
#pragma once

#include <cstddef>
#include <cstdint>

namespace rffi {

constexpr uint32_t kResultMagic   = 0x4F494652u;  // 字节 'R''F''I''O'
constexpr uint16_t kResultVersion = 2u;

enum class ResultStatus : uint16_t {
    Ok       = 0,
    NoSignal = 1,
    Error    = 2,
};

#pragma pack(push, 1)

struct ResultHeader {
    uint32_t magic;         // kResultMagic
    uint16_t version;       // kResultVersion
    uint16_t status;        // ResultStatus
    uint32_t seq;           // 回显请求
    int32_t  label;         // 回显请求
    int32_t  pred;          // top-1 下标；status != Ok 时为 -1
    float    prob;          // top-1 概率；status != Ok 时为 0
    uint32_t latency_us;    // 板端本帧耗时（微秒）
    uint16_t k;             // 后面的条目数
    uint16_t reserved;      // 0
    uint64_t timestamp_ns;  // 回显请求
};

struct TopKEntry {
    uint32_t class_idx;
    float    prob;
};

#pragma pack(pop)

static_assert(sizeof(ResultHeader) == 40, "ResultHeader 必须是 40 字节");
static_assert(sizeof(TopKEntry) == 8, "TopKEntry 必须是 8 字节");

inline size_t result_frame_bytes(uint16_t k) {
    return sizeof(ResultHeader) + static_cast<size_t>(k) * sizeof(TopKEntry);
}

}  // namespace rffi
```

### 4.2 给 `TcpFrameSource` 加发送能力

`src/net_source.hpp`（`public:` 区域）：

```cpp
    // 发一帧 RFIO 结果。成功返回 true；连接已断返回 false（内部会 drop_client）。
    bool send_result(const ResultHeader &h, const std::vector<TopKItem> &top);

private:
    bool send_all(const void *buf, size_t n);
```

`src/net_source.cpp`：

```cpp
#include "result_frame.hpp"
#include "postprocess.hpp"   // TopKItem

bool TcpFrameSource::send_all(const void *buf, size_t n) {
    if (client_fd_ < 0) return false;
    const char *p = static_cast<const char *>(buf);
    size_t sent = 0;
    while (sent < n) {
#if defined(_WIN32)
        const int k = ::send(static_cast<SOCKET>(client_fd_), p + sent,
                             static_cast<int>(n - sent), 0);
#else
        // MSG_NOSIGNAL：对端已关闭时不要用 SIGPIPE 把进程打死
        const ssize_t k = ::send(client_fd_, p + sent, n - sent, MSG_NOSIGNAL);
#endif
        if (k <= 0) {
            drop_client();           // 连接坏了，下一帧回到 accept()
            return false;
        }
        sent += static_cast<size_t>(k);
    }
    return true;
}

bool TcpFrameSource::send_result(const ResultHeader &h,
                                 const std::vector<TopKItem> &top) {
    if (client_fd_ < 0) return false;
    if (h.k > top.size()) return false;

    std::vector<char> buf;
    buf.reserve(result_frame_bytes(h.k));
    const char *hp = reinterpret_cast<const char *>(&h);
    buf.insert(buf.end(), hp, hp + sizeof(h));
    for (uint16_t i = 0; i < h.k; ++i) {
        TopKEntry e{static_cast<uint32_t>(top[i].index), top[i].prob};
        const char *ep = reinterpret_cast<const char *>(&e);
        buf.insert(buf.end(), ep, ep + sizeof(e));
    }
    // 头 + top-k 一次 sendall，避免和别的写交错
    return send_all(buf.data(), buf.size());
}
```

> Linux/aarch64 上，`send()` 到已关闭的 socket 会触发 `SIGPIPE` 直接杀进程。
> 用上面的 `MSG_NOSIGNAL`；或者在 `main()` 里加 `std::signal(SIGPIPE, SIG_IGN);`
> （Windows 没有这个信号，需 `#if !defined(_WIN32)`）。

### 4.3 在主循环里回帧

`src/main.cpp` 的 `for (;;)` 内：

```cpp
const auto st = src->next_frame(raw, hdr);
if (st == FrameStatus::End) break;
if (st == FrameStatus::Retry) continue;

// 从「整帧收完」开始计时；不把网络等待算进板端延迟
const auto t_frame = std::chrono::steady_clock::now();
```

推理、`softmax_topk()` 之后（拿得到 `top` 和 `pred` 的位置）：

```cpp
ResultHeader rh{};
rh.magic        = kResultMagic;
rh.version      = kResultVersion;
rh.status       = static_cast<uint16_t>(ResultStatus::Ok);
rh.seq          = hdr.seq;
rh.label        = hdr.label;
rh.pred         = pred;
rh.prob         = top.front().prob;
rh.reserved     = 0;
rh.timestamp_ns = hdr.timestamp_ns;
rh.k            = static_cast<uint16_t>(
    std::min<size_t>(top.size(), cfg.input.topk));
rh.latency_us   = static_cast<uint32_t>(
    std::chrono::duration_cast<std::chrono::microseconds>(
        std::chrono::steady_clock::now() - t_frame).count());

// file 模式没有客户端，直接跳过
if (auto *tcp = dynamic_cast<TcpFrameSource *>(src.get())) {
    if (!tcp->send_result(rh, top)) {
        // 连接已断；不要 break 进程，回到 accept 等下一个客户端
        spdlog::warn("{} 结果帧发送失败，连接已断开", kLogP);
    }
}
```

失败路径也要回帧（例如 `outs.empty()`、输出不是 32 bit）：

```cpp
ResultHeader rh{};
rh.magic = kResultMagic;
rh.version = kResultVersion;
rh.status = static_cast<uint16_t>(ResultStatus::Error);
rh.seq = hdr.seq;
rh.label = hdr.label;
rh.pred = -1;
rh.prob = 0.0f;
rh.k = 0;
rh.reserved = 0;
rh.timestamp_ns = hdr.timestamp_ns;
rh.latency_us = static_cast<uint32_t>(
    std::chrono::duration_cast<std::chrono::microseconds>(
        std::chrono::steady_clock::now() - t_frame).count());
if (auto *tcp = dynamic_cast<TcpFrameSource *>(src.get())) tcp->send_result(rh, {});
```

如果希望这一帧之后继续服务，就**不要** `break`；只有设备/会话级错误才退出进程。

---

## 5. 行为细节

### 5.1 顺序与流水线

- 板端单线程「收一帧、算一帧、回一帧」即可，0.9 ms/帧远快于上位机的 20~60 fps。
- 上位机可能不等结果就连发多帧（流水线）。板端按接收顺序处理并回帧，
  `seq` 自然对齐；**不要**为了并发打乱返回顺序。
- 不要为每帧创建线程；`session.forward()` 不是线程安全的，而且多线程不会更快。

### 5.2 NoSignal（可选）

现有配置没有这一项。如果要做：

```yaml
input:
  signal_min_std: 0.0     # >0 才启用；对 raw 的 512 个标量求 std
  skip_nosignal: false    # true = 无信号帧不跑前向，直接回 status=1
```

实现建议：

```cpp
const auto s = norm_stats(raw.data(), seg_len);   // 已有函数，见 preprocess.hpp
if (cfg.input.signal_min_std > 0.0 && s.stddev < cfg.input.signal_min_std) {
    // 回 status=1, pred=-1, prob=0, k=0；
    // skip_nosignal=true 时跳过 forward
}
```

阈值必须用真实空采数据标定。没标定就保持 `0`，不要随便开。

### 5.3 延迟怎么算

`latency_us` = **整帧收完 → 结果发出前** 的耗时，单位微秒。包含归一化、
`forward()`、softmax top-k，不包含等上一帧或等网络的时间。

上位机直接把它显示在 top-k 卡片上，并用它和端到端延迟对照。

### 5.4 概率与排序

- `prob` 必须是 softmax 后的概率（对 20 类融合 log 概率做 max-subtraction softmax）。
- 现有 `softmax_topk()` 已满足，直接使用 `top` 即可。
- 不要发 logits，不要发 int8 量化值；上位机不做反量化。
- `k` 与条目数必须一致，且条目按概率降序。

---

## 6. 联调与验收

### 6.1 最小回环测试（Python，独立于上位机）

```python
import socket, struct
import numpy as np

REQ = struct.Struct("<IHHiIIfQ")     # 32 B
RES = struct.Struct("<IHHIiifIHHQ")  # 40 B
TOP = struct.Struct("<If")           # 8 B

def recv_exact(s, n):
    buf = b""
    while len(buf) < n:
        chunk = s.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("board closed")
        buf += chunk
    return buf

iq = np.load("testset_host/test_iq_float32.npy", mmap_mode="r")[0]  # (256,2)
payload = np.ascontiguousarray(iq, dtype="<f4").tobytes()
seq, label, ts = 123, 7, 1700000000000000000

with socket.create_connection(("192.168.1.100", 9527), timeout=5) as s:
    s.settimeout(2.0)
    s.sendall(REQ.pack(0x51494652, 1, 0, label, seq, 256, 0.0, ts) + payload)
    m, ver, status, rseq, rlabel, pred, prob, lat, k, _, rts = \
        RES.unpack(recv_exact(s, RES.size))
    entries = [TOP.unpack(recv_exact(s, TOP.size)) for _ in range(k)]

assert m == 0x4F494652 and ver == 2
assert status == 0
assert rseq == seq and rlabel == label and rts == ts
assert 0 <= pred < 150 and 0.0 <= prob <= 1.0
assert lat > 0 and k > 0 and len(entries) == k
assert all(0 <= c < 150 and 0.0 <= p <= 1.0 for c, p in entries)
assert entries[0][0] == pred and abs(entries[0][1] - prob) < 1e-6
assert all(entries[i][1] >= entries[i + 1][1] for i in range(k - 1))
print("OK", pred, prob, lat, "us", entries)
```

### 6.2 用上位机联调

1. 板上运行 `./build/rffi_deploy configs/rffi_transformer.yaml`，看到
   `[PSIN] 等上位机连接 tcp://0.0.0.0:9527`。
2. Windows 上位机：测试方式选「板卡实测」，测试数据选 `testset_host`，
   当前发射机选任意一个，载荷先选 `float32 原始`，点「连接板卡」→「开始」。
3. 预期：右侧出现板端 top-k，卡片显示「板端 x.xx ms」，命中率按 `label` 累计。
4. 再切 `int16 · 16 bit` 复测：上位机使用 testset 的逐帧 scale，结果应与
   float32 一致（差异只可能来自模型量化，不来自传输）。

### 6.3 验收清单

- [ ] 每发一帧，恰好收到一帧结果，`40 + 8×k` 字节
- [ ] `magic=0x4F494652`、`version=2`、`k ∈ [0, input.topk]`
- [ ] `seq` / `label` / `timestamp_ns` 逐帧回显正确
- [ ] `pred ∈ [0,149]`，`prob` 是 softmax 概率，top-k 降序
- [ ] `latency_us > 0` 且量级合理（约 900 µs）
- [ ] 连续 1000 帧无断连、无内存增长、延迟不漂移
- [ ] 上位机断开后，板端回到 `accept()`；重连后继续正常出结果
- [ ] file 模式（无客户端）行为不变
- [ ] 推理失败帧回 `status=2`，进程不退出

### 6.4 常见问题

| 现象 | 先查 |
|---|---|
| 上位机显示已发送，但没有 top-k | 板端没发结果；`send_result` 是否被调用、`client_fd_` 是否为 -1 |
| 上位机报 magic 不对 / 一直重连 | 结果头布局错：字段顺序、40 字节、`#pragma pack(1)` |
| 第一帧后就断连 | 板端 `send()` 失败（`SIGPIPE` 或长度错），看板端日志 |
| top-k 顺序不对 | 没有按概率降序传；`softmax_topk` 的输出本身就是降序 |
| top-k 概率全是 0.0067 | 输入是常数 → 检查 int16 `value_scale` 或载荷字节数 |
| 结果和请求错位 | `seq` 没回显，或一帧没回结果导致后续错位 |
| 延迟越跑越大 | 板端不是在「收一帧回一帧」，或上位机发得比板端快导致排队 |

---

## 7. 版本与兼容

| 方向 | version | 变更 |
|---|---:|---|
| 请求 RFIQ | `1` | 32 B 头 + f32/int16 载荷 |
| 请求控制帧 | `1` | 同一个 32 B 头，`dtype=2`、`n_complex=0`、8 B `{cmd,arg}` |
| 结果 RFIO | `2` | 40 B 头 + `k×8 B` top-k；`status=3` 时再加分析块 |

- 两方向版本独立：板端校验请求 `version==1`；上位机校验结果 `version==2`。
- `reserved` 保持 0；未来新增字段只能占用保留位或提升版本号。
- 修改任何字段都必须同步改三个地方：`iq_frame.hpp` / `result_frame.hpp`、
  本文与 `host_interface.md`、上位机的 `rffi_host/hostproto.py`
  （其中有 `static_assert` 等价的长度断言和单元测试）。
