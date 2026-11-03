# 上位机接口说明（RFFI 部署程序）

本文是写给**上位机（PC / 数据采集端）开发者**的接口规格。板端程序是 `rffi_deploy`，
它做 **TCP 服务端**：你连上去、逐帧发 IQ，它逐帧回推理结果。

- 目标板：ZG330（30TAI），aarch64
- 默认端口：**9527**（`configs/rffi_transformer.yaml` 的 `input.port`）
- 一帧 = **256 个复样本**（512 个标量），对应一次分类
- 字节序：**全小端**（x86 / aarch64 都是原生小端，直接 `pack` 即可）
- 方向：**一帧请求 → 一帧结果**，按 `seq` 对齐，顺序一致

```
 上位机                                   板子 (rffi_deploy)
   |  connect(板子IP:9527)                    |
   | ---------------------------------------> | accept
   |  请求帧: 32B 头 + 载荷                    |
   | ---------------------------------------> | 解帧 → 归一化 → NPU 前向
   |  结果帧: 40B 头 + k×8B                    | → softmax top-k
   | <--------------------------------------- |
   |  请求帧 ...                               |
   | ---------------------------------------> |
   |  结果帧 ...                               |
   | <--------------------------------------- |
   |  close()                                  | 回到 accept 等下一个客户端
```

---

## 目录

1. [传输层约定](#1-传输层约定)
2. [请求帧（上位机 → 板子）](#2-请求帧上位机--板子)
3. [结果帧（板子 → 上位机）](#3-结果帧板子--上位机)
4. [状态码与错误处理](#4-状态码与错误处理)
5. [上位机实现要点](#5-上位机实现要点)
6. [Python 参考实现](#6-python-参考实现)
7. [C / C++ 结构体](#7-c--c-结构体)
8. [板端配置项对本接口的影响](#8-板端配置项对本接口的影响)
9. [联调排查清单](#9-联调排查清单)
10. [版本与变更](#10-版本与变更)

---

## 1. 传输层约定

| 项 | 值 |
|---|---|
| 协议 | TCP，板子 listen，上位机 connect |
| 端口 | 9527（可配） |
| 并发 | **同一时刻只接受 1 个客户端** |
| 帧同步 | 靠**定长头 + 头里的长度字段**，没有「找 magic」的重同步 |
| 处理速度 | 约 **0.9 ms/帧**（≈1100 帧/秒） |

三条硬规定：

1. **不要一次 `recv` 就当收全了。** TCP 是字节流，头和载荷都可能分段到达，必须循环补齐。
2. **不要发未分帧的裸字节流。** 板子按 32 B 头解析，对不上就断开连接。
3. **发速率超过 1100 帧/秒不会丢帧**，但会在 socket 缓冲里排队，表现为延迟增长。

---

## 2. 请求帧（上位机 → 板子）

### 2.1 帧结构

```
┌──────────── 32 B 定长头 ────────────┬──────────── 载荷 ────────────┐
│ magic/version/dtype/label/seq/...   │ n_complex 个复样本（I,Q 交错）│
└─────────────────────────────────────┴──────────────────────────────┘
```

### 2.2 头字段（`pack` 格式：`<IHHiIIfQ`，共 32 B）

| 偏移 | 大小 | 类型 | 字段 | 取值 / 约束 |
|---|---|---|---|---|
| 0 | 4 | `u32` | `magic` | 必须 `0x51494652`（内存里的字节序列是 `R F I Q`） |
| 4 | 2 | `u16` | `version` | 必须 `1` |
| 6 | 2 | `u16` | `dtype` | `0` = float32，`1` = int16 |
| 8 | 4 | `i32` | `label` | 真值类别 `0..149`；不知道就填 **`-1`** |
| 12 | 4 | `u32` | `seq` | 你自增，板子原样回显；用于对帧、对丢帧 |
| 16 | 4 | `u32` | `n_complex` | **必须 `256`**（= 板端 `net.seg_len`），否则连接被断开 |
| 20 | 4 | `f32` | `value_scale` | 仅 `dtype=1` 时用：真实值 = `raw_i16 * value_scale`；`dtype=0` 忽略（填 0） |
| 24 | 8 | `u64` | `timestamp_ns` | 随便填（无符号），板子原样回显，便于和你自己的流水对齐 |

### 2.3 载荷

`n_complex × 2` 个标量，**复样本按 `I0, Q0, I1, Q1, …` 交错**（不是通道优先）：

| `dtype` | 每标量 | 一帧载荷 | 说明 |
|---|---|---|---|
| `0` float32 | 4 B | **2048 B** | 板子直接 `memcpy`，不做换算 |
| `1` int16 | 2 B | **1024 B** | 板子按 `raw * value_scale` 还原成 float |

**三条写错不报错、只掉精度的约定：**

1. **发原始、未归一化的 IQ。** 量纲和训练数据 `data_cache/segs.npy` 一致（±30 那一档）。
   归一化（PerSampleNorm）**由板子做**——你发之前归一化过，就是双重归一化，静默掉精度。
2. **交错顺序必须是 `I,Q`。** 板子负责转成模型要的通道优先 `[I×256, Q×256]`。
3. **小端。** 发 int16 时不要用网络字节序（big-endian）打包。

> `value_scale` 填 0 又用 `dtype=1` ⇒ 整帧被还原成 0 ⇒ 板子会判为「无信号」（若开了判定）。

---

## 3. 结果帧（板子 → 上位机）

### 3.1 帧结构

```
┌──────────── 40 B 定长头 ────────────┬── k × 8 B ──┐
│ magic/status/seq/label/pred/...     │ top-k 条目   │
└─────────────────────────────────────┴──────────────┘
```

### 3.2 头字段（`pack` 格式：`<IHHIiifIHHQ`，共 40 B）

| 偏移 | 大小 | 类型 | 字段 | 说明 |
|---|---|---|---|---|
| 0 | 4 | `u32` | `magic` | 恒为 `0x4F494652`（字节 `R F I O`）——和请求的 `RFIQ` 区分 |
| 4 | 2 | `u16` | `version` | `2` |
| 6 | 2 | `u16` | `status` | `0`=Ok，`1`=NoSignal，`2`=Error（见 §4） |
| 8 | 4 | `u32` | `seq` | 回显请求帧的 `seq` |
| 12 | 4 | `i32` | `label` | 回显请求帧的 `label` |
| 16 | 4 | `i32` | `pred` | top-1 类别下标 `0..149`；`status != 0` 时为 **`-1`** |
| 20 | 4 | `f32` | `prob` | top-1 概率（softmax 后）；`status != 0` 时为 `0` |
| 24 | 4 | `u32` | `latency_us` | 本帧端到端耗时，**微秒** |
| 28 | 2 | `u16` | `k` | 后面跟几条 top-k 条目（`0 .. input.topk`，默认 5） |
| 30 | 2 | `u16` | `reserved` | `0`，留着对齐 |
| 32 | 8 | `u64` | `timestamp_ns` | 回显请求帧的 `timestamp_ns` |

### 3.3 top-k 条目（每条 8 B，`pack` 格式 `<If`）

| 偏移 | 大小 | 类型 | 字段 |
|---|---|---|---|
| 0 | 4 | `u32` | `class_idx` 类别下标 `0..149` |
| 4 | 4 | `f32` | `prob` 该类别概率 |

按概率**降序**排列，共 `k` 条。

### 3.4 关于类别名

结果里**只发下标，不发名字**。名字请上位机自己读 `names/class_names.txt`：
**类别下标 `i` 对应文件第 `i+1` 行**（文件行号从 1 数，下标从 0 数，别差一）。

```
names/class_names.txt
1-1
1-10
1-11
...
9-7
```

共 150 行。名字是「发射机-序列」这种编号，**不是** `0..149`。

> 板子只把下标发给你，是为了（a）每帧少传 20 字节，（b）两边名字表不会不同步。
> 名字表变了（换模型/换数据）只改这文件，协议不用动。

---

## 4. 状态码与错误处理

| `status` | 含义 | `pred` / `prob` | `k` | 上位机该怎么处理 |
|---|---|---|---|---|
| `0` Ok | 正常分类 | 有效 | `topk` | 正常用 |
| `1` NoSignal | 判为无信号（只有开了 `signal_min_std` 才会出现） | **`-1` / `0`** | **`0`** | 当作「这一帧没有目标信号」，不要计入识别结果 |
| `2` Error | 本帧处理失败（前向异常、输出不是 32bit 等） | **`-1` / `0`** | **`0`** | 记日志；连接可继续，下一帧照常收发 |

**连接级异常**（不是 `status`，而是 socket 层）：

| 现象 | 板子侧原因 | 你该做的 |
|---|---|---|
| 连接被断开 | 帧头非法（magic/version/dtype/n_complex 不对）、或载荷短读 | 修好帧格式后**重连**；板子不做重同步 |
| `recv` 返回 0 | 板子进程退出 / 重启 | 重连（板子回到 `accept`） |
| 长时间无结果 | 你没发帧 / 板子忙 | 看你在 `input.idle_warn_ms` 下板端日志有没有 `空闲 N ms 未收到帧` |

> 板子**永远不会主动发**结果帧：一定是「你发一帧 → 它回一帧」。所以上位机可以
> 用「发一收一」的串行模型，也可以流水线多帧（结果仍按发帧顺序返回）。

---

## 5. 上位机实现要点

1. **必须循环 recv 补齐**：先读 40 B 头，解出 `k`，再读 `8*k` B。不要假设一次 `recv` 收全。
2. **`magic` 一定要校验**（`0x4F494652`）。校验失败说明字节流已经错位，最稳的处置是断开重连，
   不要尝试在流里搜索 magic。
3. **`seq` 一定要用**：它是唯一能判断「有没有丢帧 / 结果属于哪一帧」的字段。
4. **超时要有**：连接超时、单帧结果超时都设上（建议 1~2 s），否则板子一挂你就永远 `recv` 卡住。
5. **`label` 填 `-1` 是允许的**：真实接收机一般拿不到真值。填了板子会顺带算准确率并打在日志里。
6. **重连要能重连**：板端断连后自动回到 `accept()`，你 `connect` 一次就能继续。

---

## 6. Python 参考实现

```python
import socket
import struct

REQ_MAGIC = 0x51494652          # 'RFIQ'
RES_MAGIC = 0x4F494652          # 'RFIO'
REQ_VER   = 1

REQ = struct.Struct("<IHHiIIfQ")     # 32 B 请求头
RES = struct.Struct("<IHHIiifIHHQ")  # 40 B 结果头
TOP = struct.Struct("<If")           # 8 B  top-k 条目

SEG_LEN     = 256   # 复样本数，必须和板端一致
NUM_CLASSES = 150


def recv_exact(sock: socket.socket, n: int) -> bytes:
    """TCP 是字节流：必须循环补齐 n 字节。"""
    buf = b""
    while len(buf) < n:
        chunk = sock.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("板子关闭了连接")
        buf += chunk
    return buf


def send_frame(sock: socket.socket, iq, seq: int, label: int = -1,
               dtype: int = 0, value_scale: float = 0.0,
               timestamp_ns: int = 0) -> None:
    """
    iq: 长度 2*SEG_LEN 的序列，交错 (I0,Q0,I1,Q1,...)，**原始未归一化**。
    dtype=0: float32（一帧 2048 B）；dtype=1: int16（1024 B，真值 = raw*value_scale）
    """
    assert len(iq) == 2 * SEG_LEN, f"iq 长度必须是 {2*SEG_LEN}"
    head = REQ.pack(REQ_MAGIC, REQ_VER, dtype, label, seq, SEG_LEN,
                    value_scale, timestamp_ns)
    if dtype == 0:
        payload = struct.pack(f"<{2*SEG_LEN}f", *[float(x) for x in iq])
    elif dtype == 1:
        payload = struct.pack(f"<{2*SEG_LEN}h", *[int(x) for x in iq])
    else:
        raise ValueError("dtype 只能是 0(f32) 或 1(int16)")
    sock.sendall(head + payload)


def recv_result(sock: socket.socket) -> dict:
    m, ver, status, seq, label, pred, prob, lat_us, k, _res, ts = \
        RES.unpack(recv_exact(sock, RES.size))
    if m != RES_MAGIC:
        raise ValueError(f"结果 magic 不对：{m:#x}（字节流已错位，建议重连）")
    top = [TOP.unpack(recv_exact(sock, TOP.size)) for _ in range(k)]
    return dict(version=ver, status=status, seq=seq, label=label, pred=pred,
                prob=prob, latency_us=lat_us, top=top, timestamp_ns=ts)


# ---------------- 用法 ----------------
def run(ip: str, segs):
    names = [ln.strip() for ln in open("names/class_names.txt", encoding="utf-8")
             if ln.strip()]

    with socket.create_connection((ip, 9527), timeout=5) as s:
        s.settimeout(2.0)                      # 单帧结果超时
        for seq, seg in enumerate(segs):
            send_frame(s, seg, seq=seq, label=-1)
            r = recv_result(s)
            if r["status"] == 0:
                print(f"seq {r['seq']:>6}  {names[r['pred']]:<6} p={r['prob']:.3f}  "
                      f"{r['latency_us']} us")
            elif r["status"] == 1:
                print(f"seq {r['seq']:>6}  no-signal")
            else:
                print(f"seq {r['seq']:>6}  error")


# 最小连通性测试：发一帧，读一条结果
def ping(ip: str, iq):
    with socket.create_connection((ip, 9527), timeout=5) as s:
        s.settimeout(2.0)
        send_frame(s, iq, seq=0, label=-1)
        print(recv_result(s))
```

---

## 7. C / C++ 结构体

```c
#include <stdint.h>

#pragma pack(push, 1)

/* 请求头：32 B，小端 */
typedef struct {
    uint32_t magic;        /* 0x51494652 */
    uint16_t version;      /* 1 */
    uint16_t dtype;        /* 0=f32, 1=int16 */
    int32_t  label;        /* 0..149 或 -1 */
    uint32_t seq;
    uint32_t n_complex;    /* 256 */
    float    value_scale;  /* 仅 int16 用 */
    uint64_t timestamp_ns;
} rf_req_header;

/* 结果头：40 B，小端 */
typedef struct {
    uint32_t magic;        /* 0x4F494652 */
    uint16_t version;      /* 2 */
    uint16_t status;       /* 0=Ok 1=NoSignal 2=Error */
    uint32_t seq;
    int32_t  label;
    int32_t  pred;         /* -1 表示无效 */
    float    prob;
    uint32_t latency_us;
    uint16_t k;
    uint16_t reserved;
    uint64_t timestamp_ns;
} rf_res_header;

/* top-k 条目：8 B */
typedef struct {
    uint32_t class_idx;
    float    prob;
} rf_topk_entry;

#pragma pack(pop)

_Static_assert(sizeof(rf_req_header) == 32, "req header 必须 32 字节");
_Static_assert(sizeof(rf_res_header) == 40, "res header 必须 40 字节");
```

---

## 8. 板端配置项对本接口的影响

板端配置在 `configs/rffi_transformer.yaml`，你这边只关心下面几项（改完重启板端程序生效）：

| 配置项 | 默认 | 对上位机的影响 |
|---|---|---|
| `input.port` | `9527` | 连接端口 |
| `input.bind` | `0.0.0.0` | 板子监听地址 |
| `net.seg_len` | `256` | 决定 `n_complex` 的合法值（改这个必须同时换模型） |
| `input.topk` | `5` | 结果里 `k` 的默认条数 |
| `input.signal_min_std` | `0.0` | `>0` 才会出现 `status=1`。阈值需按真实空采数据定 |
| `input.skip_nosignal` | `false` | `true` 时无信号帧不跑前向；结果一律 `k=0` |
| `input.idle_warn_ms` | `0` | 只影响板端日志，不影响协议 |
| `pl.enable` | `true` | 打开后 `pred/prob/top-k` 是**主干 + PL 融合**的结果；关掉则是纯主干。协议字节完全不变 |
| `pl.fallback_to_trunk` | `true` | `true` 时单帧 PL 失败仍回 `status=0`（用主干结果）；`false` 时该帧回 `status=2` |

> **`seg_len` / `num_classes` 与模型绑死**：换模型才改，改完 `n_complex` 和 `pred` 的取值范围可能变，
> 上位机不用改代码（`pred` 是下标，名字表跟着换即可）。
>
> **融合对协议透明**：上位机看到的仍是 150 类中的 top-k，只是概率来自两个模型的
> log-pool。想区分某帧是不是拿 PL 融合的，看板端日志的 `[trunk ... | pl ...]`
> 或 `[PL 回退]`；协议里没有这个标志位（需要的话再加 version）。

---

## 9. 联调排查清单

| 现象 | 先查什么 |
|---|---|
| 连不上 | 板子上 `ss -ltnp \| grep 9527`；板端是否打印了 `数据源 tcp://0.0.0.0:9527` |
| 连上就被断开 | 帧头：`magic=0x51494652`、`version=1`、`dtype∈{0,1}`、`n_complex=256`；板端日志会打 `帧头非法：...` |
| 结果 magic 不对 / 解析错位 | 你读结果的字节数算错了：一定是 `40 + 8*k`，且 `k` 来自**刚读到的那个头** |
| 结果全是 `prob≈0.0067`（≈1/150） | 输入是常数（全 0 或全 1）——检查 `value_scale`、载荷字节数、float/int 混用 |
| `status=1` 频繁出现 | `signal_min_std` 太高；或你发的确实是空采 |
| 延迟越来越高 | 发得比板子快（>1100 帧/秒），在 socket 里排队了 |
| 板子日志看不到对应帧 | 板端 `input.mode` 是不是还在 `file`（应该改 `tcp`） |

板端每帧会在控制台打一行（便于和你的 `seq` 对照）：

```
seq      12  top1 = 18-14  p=0.855  ...  0.46 ms  [hit]  [gt 58 18-14]
```

---

## 10. 版本与变更

| 版本 | 日期 | 变更 |
|---|---|---|
| `version=1`（请求） | 2026-10 | 定长 32 B 头 + 载荷；`dtype` 支持 f32/int16 |
| `version=2`（结果） | 2026-10 | 新增回程：40 B 头 + `k` 个 top-k 条目，`status` 区分 Ok/NoSignal/Error |

兼容性策略：**两个方向的 `version` 各自独立**。板子校验请求的 `version` 必须为 `1`；
上位机请校验结果的 `version == 2`，并在不匹配时报错而不是猜。
