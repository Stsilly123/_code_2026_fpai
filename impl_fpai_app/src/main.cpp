// RFFI 20 类在 FPAI（ZG330）上的部署程序（PS 侧）。
//
//   网口收原始 IQ 帧
//     ├─ PL dma0/dma1：LCWT 主干 -> 16×38 token（int16 Q4）
//     │                -> NPU 的 LCWT 头（LN/fc1/GELU/fc2/残差/GAP/Linear）-> 20 类 logits
//     ├─ PL dma2     ：均衡后 IQ（int16 Q10） -> XF 单折 × 平移 TTA（NPU）
//     └─ PL dma3     ：专家特征 193 维（int32 Q12），随帧收下供后续融合
//   两路在 log 概率空间融合（默认 w=1/3），softmax top-k -> 控制台 + 回帧。
//
// 体例照 fpai_demo_app 的 `examples/1_single_input+ai/PLin+SingleNet+HDMI`：
// argv[1] 是 YAML 配置路径，配置里的路径相对 CWD。不引 actor / BufferManager /
// 多线程 / HDMI —— RFFI 是分类不是视频流，一个主循环就够。
//
// XF 图的关键事实（从 `_ZG` 产物读出）：
//   * 输入 float32 [批次,2,256]，输出 float32 [批次,20]；float->int8 的 Cast 在图内；
//     批次按图自动识别：1 = 每次前向一个平移，5 = 5 个平移一次前向（见 xf_ensemble.hpp）；
//   * 图外必须自己做 PerSampleNorm（见 preprocess.hpp）和圆周平移 TTA。

#include <algorithm>
#include <atomic>
#include <cerrno>
#include <chrono>
#include <csignal>
#include <cstdio>
#include <cstring>
#include <memory>
#include <numeric>
#include <string>
#include <thread>
#include <utility>
#include <vector>

// fmt 走 spdlog 自带的那份，**不要写 `<fmt/format.h>`**（见旧版 README 的说明）。
// 每帧那行输出必须是裸消息，tools/check_roundtrip.py 用 `^seq ` 匹配。
#include <spdlog/fmt/fmt.h>
#include <spdlog/spdlog.h>

#include <icraft-xir/core/network.h>
#include <icraft-xrt/core/device.h>
#include <icraft-xrt/core/session.h>
#include <icraft-xrt/dev/host_device.h>
#include <icraft-backends/hostbackend/backend.h>

#include "backend.hpp"
#include "config.hpp"
#include "fusion.hpp"
#include "net_source.hpp"
#include "pl_side.hpp"
#include "postprocess.hpp"
#include "preprocess.hpp"
#include "spectrum.hpp"
#include "xf_ensemble.hpp"

using namespace rffi;

static constexpr const char *kLogP = "[APP]";

static void on_sigint(int) { g_stop.store(true); }

// 设备 URL 按架构自动选：板上 aarch64 走 AXI，PC 上走 socket 连板子。
static std::string device_url(const SysConfig &s) {
#if defined(_WIN32) || defined(__x86_64__) || defined(_M_X64) || defined(__i386__) || \
    defined(_M_IX86)
    if (s.run_backend == "buyi") {
        return "socket://ql100aiu@" + s.ip + ":9981?npu=" + s.npu_addr + "&dma=" + s.dma_addr;
    }
    if (s.run_backend == "zg330") return "socket://zg330aiu@" + s.ip + ":9981";
#elif defined(__aarch64__) || defined(_M_ARM64)
    if (s.run_backend == "buyi") {
        return "axi://ql100aiu?npu=" + s.npu_addr + "&dma=" + s.dma_addr;
    }
    if (s.run_backend == "zg330") {
        return "axi://zg330aiu?npu=" + s.npu_addr + "&dma=" + s.dma_addr;
    }
#else
#error "未知架构"
#endif
    throw std::runtime_error("run_backend 只支持 buyi / zg330，收到 " + s.run_backend);
}

static const char *name_of(const std::vector<std::string> &names, int idx) {
    return (idx >= 0 && idx < static_cast<int>(names.size())) ? names[static_cast<size_t>(idx)].c_str()
                                                              : "?";
}

// 逐帧评测导出（input.eval_dump）。定长记录，numpy 可以直接 fromfile 读：
//   文件头 16 B：magic "RFEV" | version=1 | ncls | nexp
//   每帧记录：u32 seq | i32 label | u32 flags | u32 pad
//             | f32 xf[ncls] | f32 pl[ncls] | f32 ex[nexp]
// flags：bit0 = XF 可用，bit1 = PL 可用，bit2 = eq 可用，bit3 = 专家特征可用；
// 不可用的分支写全 0。**只写文件，不进任何推理路径**，关掉时零开销。
class EvalDump {
public:
    ~EvalDump() {
        if (f_) std::fclose(f_);
    }

    bool open(const std::string &path, uint32_t ncls, uint32_t nexp, std::string &err) {
        f_ = std::fopen(path.c_str(), "wb");
        if (!f_) {
            err = std::strerror(errno);
            return false;
        }
        std::setvbuf(f_, nullptr, _IOFBF, 1u << 20);
        ncls_ = ncls;
        nexp_ = nexp;
        const uint32_t hdr[4] = {0x56454652u, 1u, ncls, nexp};  // "RFEV"
        if (std::fwrite(hdr, sizeof(hdr), 1, f_) != 1) {
            err = "写文件头失败";
            return false;
        }
        return true;
    }

    bool active() const { return f_ != nullptr; }

    // xf/pl/ex 为 nullptr 表示该分支不可用（flag 由调用方给）。
    void write(uint32_t seq, int32_t label, uint32_t flags, const float *xf, const float *pl,
               const float *ex) {
        if (!f_) return;
        const size_t nf = 4 + 2 * ncls_ + nexp_;
        if (rec_.size() != nf) rec_.assign(nf, 0.0f);
        uint32_t head[4] = {seq, static_cast<uint32_t>(label), flags, 0u};
        std::memcpy(rec_.data(), head, sizeof(head));
        float *p = rec_.data() + 4;
        if (xf) std::memcpy(p, xf, ncls_ * sizeof(float));
        p += ncls_;
        if (pl) std::memcpy(p, pl, ncls_ * sizeof(float));
        p += ncls_;
        if (ex) std::memcpy(p, ex, nexp_ * sizeof(float));
        if (std::fwrite(rec_.data(), sizeof(float), rec_.size(), f_) != rec_.size()) ++errors_;
    }

    long long errors() const { return errors_; }

private:
    std::FILE *f_ = nullptr;
    uint32_t ncls_ = 0, nexp_ = 0;
    std::vector<float> rec_;
    long long errors_ = 0;
};

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fmt::print(stderr, "用法: {} <config yaml>\n", argv[0]);
        return 1;
    }
    std::signal(SIGINT, on_sigint);
    std::signal(SIGTERM, on_sigint);

    AppConfig cfg;
    try {
        cfg = load_config(argv[1]);
    } catch (const std::exception &e) {
        fmt::print(stderr, "配置错误: {}\n", e.what());
        return 1;
    }

    const int ncls = cfg.xf.num_classes;
    const auto names = load_class_names(cfg.xf.names);
    if (names.empty()) {
        spdlog::warn("{} 读不到类别名 {}，只打裸下标", kLogP, cfg.xf.names);
    } else if (static_cast<int>(names.size()) != ncls) {
        spdlog::warn("{} 类别名 {} 行，配置说 {} 类", kLogP, names.size(), ncls);
    }

    std::unique_ptr<FrameSource> src;
    auto stage = [](const char *tag, const std::string &what) {
        spdlog::info("{} {} {}", kLogP, tag, what);
        spdlog::default_logger()->flush();  // 板端挂住时最后一行就是卡点
    };

    try {
        // ---------------- 设备 ----------------
        auto url = device_url(cfg.sys);
        stage("[1/6]", "打开设备 " + url);
        auto device = icraft::xrt::Device::Open(url);
        auto fpai_device = device.cast<FPAIDevice>();
        stage("[2/6]", "Device::Open() 返回");
#if defined(USE_BUYI_BACKEND)
        fpai_device.mmuModeSwitch(cfg.sys.mmu_mode);
        stage("[2/6]", std::string("mmuModeSwitch(") + (cfg.sys.mmu_mode ? "true" : "false") + ")");
#else
        (void)fpai_device;
#endif

        // ---------------- XF（NPU） ----------------
        std::unique_ptr<XfEnsemble> xf;
        if (cfg.xf.enable) {
            stage("[3/6]", cfg.xf.fused_folds > 0
                                ? "装载 XF fused 图（" + std::to_string(cfg.xf.fused_folds) +
                                      " 折 × " + std::to_string(cfg.xf.shifts.size()) +
                                      " 平移，一次前向）"
                                : "装载 XF 分折图（" + std::to_string(cfg.xf.models.size()) +
                                      " 个 _ZG 图 × " + std::to_string(cfg.xf.shifts.size()) +
                                      " 平移）");
            xf = std::make_unique<XfEnsemble>(cfg.xf);
            std::string xerr;
            if (!xf->open(device, cfg.sys.profile, xerr)) {
                if (cfg.xf.required) throw std::runtime_error("XF 装载失败: " + xerr);
                spdlog::error("{} XF 装载失败，本次只跑 PL: {}", kLogP, xerr);
                xf.reset();
            } else {
                spdlog::info("{} XF 已就绪：{}", kLogP, xf->describe());
            }
        }

        // ---------------- PL：token(NPU 头) + dma2 均衡输出 + dma3 专家特征 ----------------
        std::unique_ptr<PlSide> pl;
        if (cfg.pl.enable) {
            stage("[4/6]", "打开 PL DMA（dma1=token, dma2=eq, dma3=expert）+ LCWT 头");
            pl = std::make_unique<PlSide>(cfg.pl);
            std::string perr;
            if (!pl->open(device, perr)) {
                if (cfg.pl.required || cfg.xf.enable) {
                    throw std::runtime_error("PL DMA 打开失败: " + perr);
                }
                spdlog::error("{} PL DMA 打开失败: {}", kLogP, perr);
                pl.reset();
            } else {
                spdlog::info("{} PL 已就绪：{}", kLogP, pl->describe());
                if (cfg.pl.eq_enable && !cfg.xf.enable) {
                    spdlog::warn("{} xf.enable=false：eq 照收，但本程序不会用它", kLogP);
                }
            }
        }
        if (cfg.xf.enable && !pl) {
            throw std::runtime_error("XF 需要 dma2 的均衡输出，但 PL DMA 没打开");
        }

        // ---------------- 数据源 ----------------
        if (cfg.input.mode == "tcp") {
            src = std::make_unique<TcpFrameSource>(cfg.input.bind_addr, cfg.input.port,
                                                   cfg.xf.seg_len);
        } else {
            src = std::make_unique<FileFrameSource>(cfg.input.file, cfg.xf.seg_len);
        }
        stage("[5/6]", std::string("数据源 ") + src->describe());

        // ---------------- 主循环 ----------------
        //
        // 跨帧流水（pl.cross_frame 且 XF 在时）：
        //     [PL(N) 整轮] ∥ [──── XF(N-1) ────] → 出 N-1 的结果 → ...
        // PL 走 PL DMA、XF 走 NPU，两套硬件互不等待。稳态每帧周期 = max(PL, XF)，
        // PL 那 ~3.7 ms 整个藏住。代价是单个结果的「收到→出结果」多一帧流水延迟，
        // 所以日志同时打周期（ms）和延迟（lat）。cross_frame=false 退回旧路径。
        const bool pipe = pl && xf && cfg.pl.cross_frame;

        struct PipeFrame {
            std::vector<float> raw;
            IqFrameHeader hdr{};
            NormStats stats{};
            RunMode mode = RunMode::Fusion;  // 收帧那一刻的运行模式（由控制帧改）
            bool no_signal = false;
            std::chrono::steady_clock::time_point t_recv{};
            PlResult pr;              // 流水模式下由工作线程填，join 后才完整
            bool pl_done = false;     // 本帧整轮 PL 是否已经跑完（流水调度用）
        };

        // ---- 运行模式（上位机控制帧可随时切）----
        RunMode runtime_mode = cfg.mode;
        spdlog::info("{} 运行模式 {}（上位机可用控制帧切换：fast / fusion / analysis）",
                     kLogP, run_mode_name(runtime_mode));

        // 快速模式只跑 XF：PL 只保留 eq 那一趟，头和 TTA 都关。
        auto pl_opts_for = [](RunMode m) {
            PlWorkOpts o;
            if (m == RunMode::Fast) {
                o.head = false;
                o.expert_head = false;
                o.tta = false;
            }
            return o;
        };

        long long seen = 0, labeled = 0, nosignal = 0;
        long long fused_eval = 0, correct_fused = 0;
        long long fusion_labeled = 0;           // 聚合模式下带真值的帧（分母）
        long long fast_labeled = 0, correct_fast = 0;  // 快速模式
        long long ana_n = 0;                    // 分析模式帧数（不计准确率）
        long long cmds_ok = 0, cmds_bad = 0;    // 控制帧
        long long xf_eval = 0, correct_xf = 0;
        long long pl_eval = 0, correct_pl = 0;
        long long ex_eval = 0, correct_ex = 0;
        long long fused3_eval = 0, correct_fused3 = 0;
        long long fused3_n = 0, fused2_n = 0;   // 走三路 / 退回两路的帧数
        long long xf_ok_n = 0, xf_fail = 0, eq_fail = 0, exp_fail = 0;

        // 逐帧评测导出（一次性对拍用）。空字符串 = 完全关闭。
        EvalDump eval_dump;
        if (!cfg.input.eval_dump.empty()) {
            std::string err;
            if (!eval_dump.open(cfg.input.eval_dump, static_cast<uint32_t>(ncls), 193u, err)) {
                throw std::runtime_error("打不开 input.eval_dump " + cfg.input.eval_dump +
                                         ": " + err);
            }
            spdlog::info("{} 逐帧评测导出 -> {}", kLogP, cfg.input.eval_dump);
        }
        long long pl_ok_n = 0, pl_fail = 0, both_fail = 0;
        double xf_ms_sum = 0.0, pl_ms_sum = 0.0;
        long long xf_ms_n = 0, pl_ms_n = 0;

        constexpr size_t kLatCap = 4096;
        std::vector<double> lat_ring(kLatCap, 0.0);
        size_t lat_n = 0, lat_pos = 0;
        auto lat_push = [&](double v) {
            lat_ring[lat_pos] = v;
            lat_pos = (lat_pos + 1) % kLatCap;
            if (lat_n < kLatCap) ++lat_n;
        };
        // 帧周期（吞吐）进 lat_ring；真延迟（收到→出结果）单独累计。
        double lat_sum = 0.0;
        long long lat_num = 0;

        const size_t seg_len = static_cast<size_t>(cfg.xf.seg_len);
        const bool no_signal_gate = cfg.input.signal_min_std > 0.0f;
        auto last_frame_tp = std::chrono::steady_clock::now();
        bool idle_warned = false;
        bool first = true;

        auto skip_frame = [&](const PipeFrame &f) {
            return f.no_signal && cfg.input.skip_nosignal;
        };

        // 控制帧应答：status=CommandAck（接受）/ Error（拒绝），pred=当前模式。
        auto ack_command = [&](const IqFrameHeader &h, const IqCommand &c, bool ok,
                               RunMode cur) {
            IqResultHeader rh{};
            rh.magic = kResultMagic;
            rh.version = kResultVersion;
            rh.status = static_cast<uint16_t>(ok ? ResultStatus::CommandAck
                                                 : ResultStatus::Error);
            rh.seq = h.seq;
            rh.label = static_cast<int32_t>(c.cmd);
            rh.pred = ok ? static_cast<int32_t>(cur) : -1;
            rh.prob = 0.0f;
            rh.k = 0;
            rh.timestamp_ns = h.timestamp_ns;
            src->send_result(rh, {});
        };

        auto handle_command = [&](const IqFrameHeader &h) {
            const IqCommand c = src->last_command();
            const int id = static_cast<int>(c.cmd);
            if (id == static_cast<int>(CommandId::QueryMode)) {
                ++cmds_ok;
                spdlog::info("{} 上位机查询模式 -> {}", kLogP, run_mode_name(runtime_mode));
                ack_command(h, c, true, runtime_mode);
                return;
            }
            if (id == static_cast<int>(CommandId::SetMode)) {
                if (c.arg < 0 || c.arg > 2) {
                    ++cmds_bad;
                    spdlog::warn("{} 上位机给的模式 {} 不认识", kLogP, c.arg);
                    ack_command(h, c, false, runtime_mode);
                    return;
                }
                const auto m = static_cast<RunMode>(c.arg);
                if (m == RunMode::Fast && !xf) {
                    ++cmds_bad;
                    spdlog::warn("{} 快速模式要求 XF 可用（本进程 XF 没打开）", kLogP);
                    ack_command(h, c, false, runtime_mode);
                    return;
                }
                runtime_mode = m;
                ++cmds_ok;
                spdlog::info("{} 上位机切换到 {} 模式", kLogP, run_mode_name(m));
                ack_command(h, c, true, runtime_mode);
                return;
            }
            ++cmds_bad;
            spdlog::warn("{} 未知控制命令 {}（arg={}）", kLogP, c.cmd, c.arg);
            ack_command(h, c, false, runtime_mode);
        };

        // 取一帧。返回 false = 数据源结束（once=true 时也包括「这一轮没拿到」）。
        // 无信号判定在这里做完，和帧一起带走。
        // once=true 只给预取用：拿不到就立刻返回，绝不在这里循环等帧 ——
        // 预取发生在「本帧结果还没发出去」的时刻，循环等帧会把结果扣住。
        auto fetch = [&](PipeFrame &f, bool once = false) -> bool {
            for (;;) {
                const auto st = src->next_frame(f.raw, f.hdr);
                if (st == FrameStatus::End) return false;
                if (st == FrameStatus::Command) {
                    // 控制帧不是 IQ，不产结果；回 ack 后接着取下一帧。
                    // 预取里收到命令就收手：ack 已经发出去了，别再阻塞等下一帧。
                    handle_command(f.hdr);
                    if (once) return false;
                    continue;
                }
                if (st == FrameStatus::Retry) {
                    if (once) return false;
                    if (cfg.input.idle_warn_ms > 0 && !idle_warned) {
                        const auto idle_ms = std::chrono::duration_cast<std::chrono::milliseconds>(
                                                 std::chrono::steady_clock::now() - last_frame_tp)
                                                 .count();
                        if (idle_ms >= cfg.input.idle_warn_ms) {
                            spdlog::warn("{} 空闲 {} ms 未收到帧", kLogP, idle_ms);
                            idle_warned = true;
                        }
                    }
                    continue;
                }
                last_frame_tp = std::chrono::steady_clock::now();
                if (idle_warned) {
                    spdlog::info("{} 恢复收帧", kLogP);
                    idle_warned = false;
                }
                f.t_recv = last_frame_tp;
                f.stats = norm_stats(f.raw.data(), seg_len);
                if (first) {
                    spdlog::info("{} 首帧均值 {:.6f} 标准差 {:.6f}", kLogP, f.stats.mean,
                                 f.stats.stddev);
                    first = false;
                }
                f.no_signal =
                    no_signal_gate &&
                    (f.stats.stddev < static_cast<double>(cfg.input.signal_min_std));
                f.mode = runtime_mode;
                return true;
            }
        };

        // 一次 PL 推理 + 失败后整轮重发一次。
        // 板上实测的失败不是 DMA 超时，是这一轮的 8 个复制槽里至少 4 个不是按
        // 本帧输入算出来的（"最少 0 帧与中位数相同"）。**重发前必须先把三个
        // 输出口排空** —— 不排空直接重发，上一轮的尾帧混进新一轮，重发出来的
        // 8 槽还是一致不起来（r1/r3 那两次连挂就是这么来的）。
        auto pl_infer = [&](PipeFrame &f) {
            const PlWorkOpts opts = pl_opts_for(f.mode);
            f.pr = pl->infer(f.raw.data(), seg_len, opts);
            if (f.pr.ok) return;
            const std::string first = f.pr.error.empty() ? f.pr.eq_error : f.pr.error;
            pl->drain_all();
            f.pr = pl->infer(f.raw.data(), seg_len, opts);
            if (f.pr.ok) {
                std::fprintf(stderr, "[PL] 排空后重发一次通过（原错误：%s）\n",
                             first.c_str());
            } else {
                std::fprintf(stderr, "[PL] 排空后重发仍失败：%s -> %s\n", first.c_str(),
                             f.pr.error.empty() ? f.pr.eq_error.c_str()
                                                : f.pr.error.c_str());
            }
        };

        // 整轮 PL（A 出 eq + shift 0，B 出其余平移）。跳过帧也标 pl_done，
        // 免得流水调度以为它还欠一趟。
        auto run_pl = [&](PipeFrame &f) {
            f.pl_done = true;
            if (!pl || skip_frame(f)) return;
            pl_infer(f);
        };

        auto account_pl = [&](PipeFrame &f) {
            if (!pl || skip_frame(f)) return;
            // 每帧三路一致数（干净时 dout 8 / eq 7~8 / 专家 8）。全打出来，
            // 一次跑完就能看到分布，以及"排空重发"到底救回了多少帧。
            std::fprintf(stderr, "[AGREE] seq=%u dout=%d eq=%d exp=%d ok=%d\n",
                         f.hdr.seq, f.pr.frames_agree, f.pr.eq_frames_agree,
                         f.pr.expert_frames_agree, f.pr.ok ? 1 : 0);
            if (f.pr.ok) {
                ++pl_ok_n;
                pl_ms_sum += f.pr.infer_ms;
                ++pl_ms_n;
            } else {
                ++pl_fail;
                if (f.pr.eq_error.empty() && f.pr.error.empty()) f.pr.error = "未知错误";
                if (pl_fail <= 5 || pl_fail % 100 == 0) {
                    spdlog::warn("{} PL 推理失败（第 {} 次）: {}", kLogP, pl_fail,
                                 f.pr.error.empty() ? f.pr.eq_error : f.pr.error);
                }
            }
            if (!f.pr.eq_ok) {
                ++eq_fail;
                if (eq_fail <= 5 || eq_fail % 100 == 0) {
                    spdlog::warn("{} 均衡输出不可用（第 {} 次）: {}", kLogP, eq_fail,
                                 f.pr.eq_error.empty() ? "未收到" : f.pr.eq_error);
                }
            }
            if (cfg.pl.expert_enable && !f.pr.expert_ok) {
                ++exp_fail;
                if (exp_fail <= 5 || exp_fail % 100 == 0) {
                    spdlog::warn("{} 专家特征不可用（第 {} 次）: {}", kLogP, exp_fail,
                                 f.pr.expert_error.empty() ? "未收到" : f.pr.expert_error);
                }
            }
        };

        // 统一回帧出口：正常 / 无信号 / 出错都走这里。
        // status != Ok 时 pred=-1、prob=0、k=0。
        auto send_result_frame = [&](const IqFrameHeader &h, ResultStatus st, uint32_t lat_us,
                                     const std::vector<IqTopKEntry> &entries,
                                     const std::vector<uint8_t> *extra = nullptr) {
            IqResultHeader rh{};
            rh.magic = kResultMagic;
            rh.version = kResultVersion;
            rh.status = static_cast<uint16_t>(st);
            rh.seq = h.seq;
            rh.label = h.label;
            rh.timestamp_ns = h.timestamp_ns;
            rh.latency_us = lat_us;
            rh.reserved = 0;
            rh.pred = entries.empty() ? -1 : static_cast<int32_t>(entries.front().class_idx);
            rh.prob = entries.empty() ? 0.0f : entries.front().prob;
            rh.k = static_cast<uint16_t>(entries.size());
            src->send_result(rh, entries, extra);
        };

        // 分析模式的附加块：把这帧信号本身交给上位机 —— 原始 IQ（星座）、
        // 均衡后 IQ（均衡后星座）、频谱幅度、专家 193 维特征、三路概率。
        // 段顺序固定：raw → eq → fft → feat → pl → xf → ex，长度看头里的 n_*。
        auto build_analysis = [&](const PipeFrame &f, const XfResult &xr, bool xf_usable,
                                  bool pl_usable, bool ex_usable,
                                  const std::vector<float> &ex_probs,
                                  const std::vector<float> &mag) {
            IqAnalysisHeader ah{};
            ah.magic = kAnalysisMagic;
            ah.version = kAnalysisVersion;
            ah.n_raw = static_cast<uint32_t>(f.raw.size());
            ah.n_eq = f.pr.eq_ok ? static_cast<uint32_t>(f.pr.eq.size()) : 0u;
            ah.n_fft = static_cast<uint32_t>(mag.size());
            ah.n_feat = f.pr.expert_ok ? static_cast<uint32_t>(f.pr.expert.size()) : 0u;
            ah.n_pl = pl_usable ? static_cast<uint32_t>(ncls) : 0u;
            ah.n_xf = xf_usable ? static_cast<uint32_t>(ncls) : 0u;
            ah.n_ex = ex_usable ? static_cast<uint32_t>(ncls) : 0u;
            ah.reserved = 0;
            ah.flags = 0;
            if (ah.n_raw) ah.flags |= kAnaRaw;
            if (ah.n_eq) ah.flags |= kAnaEq;
            if (ah.n_fft) ah.flags |= kAnaFft;
            if (ah.n_feat) ah.flags |= kAnaFeat;
            if (ah.n_pl) ah.flags |= kAnaPl;
            if (ah.n_xf) ah.flags |= kAnaXf;
            if (ah.n_ex) ah.flags |= kAnaEx;
            if (ah.n_eq) ah.flags |= kAnaFftSrcEq;

            std::vector<float> fl;
            fl.reserve(analysis_floats(ah));
            auto put = [&](const float *p, size_t n) { fl.insert(fl.end(), p, p + n); };
            if (ah.n_raw) put(f.raw.data(), ah.n_raw);
            if (ah.n_eq) put(f.pr.eq.data(), ah.n_eq);
            if (ah.n_fft) put(mag.data(), mag.size());
            if (ah.n_feat) put(f.pr.expert.data(), ah.n_feat);
            if (ah.n_pl) put(f.pr.probs.data(), ah.n_pl);
            if (ah.n_xf) put(xr.probs.data(), ah.n_xf);
            if (ah.n_ex) put(ex_probs.data(), ah.n_ex);

            std::vector<uint8_t> out(sizeof(ah) + fl.size() * sizeof(float));
            std::memcpy(out.data(), &ah, sizeof(ah));
            if (!fl.empty()) {
                std::memcpy(out.data() + sizeof(ah), fl.data(), fl.size() * sizeof(float));
            }
            return out;
        };

        // 出一帧结果：融合 / 单路 / 失败，外加计数、回帧和那行打印。
        // cycle_ms = 距上一帧出结果的间隔（吞吐），lat_ms = 本帧收到→出结果。
        auto finish_frame = [&](PipeFrame &f, const XfResult &xr, double lat_ms, double cycle_ms) {
            ++seen;
            const bool has_label = f.hdr.label >= 0;

            if (skip_frame(f)) {
                ++nosignal;
                send_result_frame(f.hdr, ResultStatus::NoSignal, 0, {});
                if (seen % std::max(1, cfg.input.print_every) == 0) {
                    fmt::print("seq {:>7}  no-signal  std={:.6f}\n", f.hdr.seq, f.stats.stddev);
                }
                return;
            }
            if (has_label) ++labeled;
            // 每帧按收帧时的模式归档：聚合/快速各自算准确率，分析模式不计预测。
            const RunMode mode = f.mode;
            if (mode == RunMode::Analysis) {
                ++ana_n;
            } else if (has_label) {
                if (mode == RunMode::Fusion) {
                    ++fusion_labeled;
                } else {
                    ++fast_labeled;
                }
            }

            lat_push(cycle_ms);
            lat_sum += lat_ms;
            ++lat_num;

            const bool pl_usable = f.pr.ok && f.pr.probs.size() == static_cast<size_t>(ncls);
            const bool xf_usable = xr.ok && xr.probs.size() == static_cast<size_t>(ncls);

            if (eval_dump.active()) {
                const bool ex_ok = f.pr.expert_ok && f.pr.expert.size() == 193u;
                uint32_t flags = (xf_usable ? 1u : 0u) | (pl_usable ? 2u : 0u) |
                                 (f.pr.eq_ok ? 4u : 0u) | (ex_ok ? 8u : 0u);
                eval_dump.write(f.hdr.seq, f.hdr.label, flags,
                                xf_usable ? xr.probs.data() : nullptr,
                                pl_usable ? f.pr.probs.data() : nullptr,
                                ex_ok ? f.pr.expert.data() : nullptr);
            }

            // 专家 MLP 的 logits → 概率（第三路）。头前向失败就只有两路。
            const bool ex_usable = f.pr.expert_head_ok &&
                                   f.pr.expert_logits.size() == static_cast<size_t>(ncls);
            std::vector<float> ex_probs =
                ex_usable ? softmax_probs(f.pr.expert_logits.data(), ncls)
                          : std::vector<float>{};

            // 单模型准确率独立统计：即使最后因严格模式不采用，也能看到各路的表现。
            const auto xf_top = xf_usable
                                    ? topk_from_probs(xr.probs.data(), ncls, 1)
                                    : std::vector<TopKItem>{};
            const auto pl_top = pl_usable
                                    ? topk_from_probs(f.pr.probs.data(), ncls, 1)
                                    : std::vector<TopKItem>{};
            const auto ex_top = ex_usable ? topk_from_probs(ex_probs.data(), ncls, 1)
                                          : std::vector<TopKItem>{};
            if (has_label) {
                if (!xf_top.empty()) {
                    ++xf_eval;
                    if (xf_top.front().index == f.hdr.label) ++correct_xf;
                }
                if (!pl_top.empty()) {
                    ++pl_eval;
                    if (pl_top.front().index == f.hdr.label) ++correct_pl;
                }
                if (!ex_top.empty()) {
                    ++ex_eval;
                    if (ex_top.front().index == f.hdr.label) ++correct_ex;
                }
            }

            std::vector<TopKItem> deployed_top;
            const char *src_tag = "none";
            bool have = false;
            bool used3 = false;   // 本帧是否真的走了三路
            if (mode == RunMode::Fast) {
                // 快速模式 = 只跑 transformer：不融合，也不悄悄退回 PL。
                if (xf_usable) {
                    deployed_top = topk_from_probs(xr.probs.data(), ncls, cfg.input.topk);
                    src_tag = "xf-fast";
                    have = !deployed_top.empty();
                }
            } else if (mode == RunMode::Analysis) {
                // 分析模式不看融合结果：回帧给专家那一路；专家没有就退 PL、再退 XF。
                if (ex_usable) {
                    deployed_top = topk_from_probs(ex_probs.data(), ncls, cfg.input.topk);
                    src_tag = "ana-ex";
                } else if (pl_usable) {
                    deployed_top = topk_from_probs(f.pr.probs.data(), ncls, cfg.input.topk);
                    src_tag = "ana-pl";
                } else if (xf_usable) {
                    deployed_top = topk_from_probs(xr.probs.data(), ncls, cfg.input.topk);
                    src_tag = "ana-xf";
                }
                have = !deployed_top.empty();
            } else if (pl_usable && !cfg.pl.fallback_to_xf && !xf_usable) {
                // 明确要求 PL 参与时，PL 失败就报错，不悄悄退回 XF。
                src_tag = "pl-fail";
            } else if (xf_usable && pl_usable && ex_usable) {
                // 三路：XF + PL + 专家，log 概率加权（默认 0.6/0.2/0.2）。
                deployed_top = fuse3_log_prob_topk(xr.probs.data(), f.pr.probs.data(),
                                                   ex_probs.data(), ncls, cfg.input.topk,
                                                   cfg.w3_xf, cfg.w3_pl, cfg.w3_ex);
                src_tag = "fusion3";
                have = !deployed_top.empty();
                used3 = true;
                ++fused3_n;
            } else if (xf_usable && pl_usable) {
                deployed_top = fuse_log_prob_topk(xr.probs.data(), f.pr.probs.data(), ncls,
                                                  cfg.input.topk, cfg.pl_weight);
                src_tag = "fusion";
                have = !deployed_top.empty();
                ++fused2_n;
            } else if (xf_usable) {
                deployed_top = topk_from_probs(xr.probs.data(), ncls, cfg.input.topk);
                src_tag = "xf";
                have = !deployed_top.empty();
            } else if (pl_usable) {
                deployed_top = topk_from_probs(f.pr.probs.data(), ncls, cfg.input.topk);
                src_tag = "pl";
                have = !deployed_top.empty();
            }

            if (!have) {
                ++both_fail;
                if (both_fail <= 5 || both_fail % 100 == 0) {
                    spdlog::error("{} 第 {} 帧没有可用结果（PL ok={} XF ok={}）", kLogP, seen,
                                  f.pr.ok, xr.ok);
                }
                send_result_frame(f.hdr, ResultStatus::Error, static_cast<uint32_t>(lat_ms * 1000.0),
                                  {});
                return;
            }

            const int pred = deployed_top.front().index;
            const bool is_correct = has_label && (pred == f.hdr.label);
            if (has_label) {
                if (mode == RunMode::Fusion) {
                    ++fused_eval;
                    if (is_correct) ++correct_fused;
                    // 三路那部分单独记一份，和"最终准确率"区分开。
                    if (used3) {
                        ++fused3_eval;
                        if (is_correct) ++correct_fused3;
                    }
                } else if (mode == RunMode::Fast && is_correct) {
                    ++correct_fast;
                }
            }
            if (f.no_signal) ++nosignal;

            if (seen == 1) {
                // 首帧诊断：两边概率头 + eq 量纲。eq 的 mean/std 应和原始 IQ 同档（±30），
                // 如果变成 ±1e-3 或 ±30000，就是 Q10 缩放接错了。
                if (xf_usable) {
                    std::string h;
                    for (int i = 0; i < std::min(ncls, 6); ++i) h += fmt::format(" {:.4f}", xr.probs[i]);
                    spdlog::info("{} 首帧 XF 概率:{}", kLogP, h);
                }
                if (pl_usable) {
                    std::string h;
                    for (int i = 0; i < std::min(ncls, 6); ++i) h += fmt::format(" {:.4f}", f.pr.probs[i]);
                    spdlog::info("{} 首帧 PL 概率:{}（8 帧一致 {}，量化饱和 {}）", kLogP, h,
                                 f.pr.frames_agree, f.pr.clipped);
                }
                if (f.pr.eq_ok) {
                    const auto eqst = norm_stats(f.pr.eq.data(), seg_len);
                    spdlog::info("{} 首帧均衡 IQ 均值 {:.6f} 标准差 {:.6f}（8 帧一致 {}）", kLogP,
                                 eqst.mean, eqst.stddev, f.pr.eq_frames_agree);
                }
                if (f.pr.expert_ok) {
                    // 193 维：0..127 FFT、128..137 小波、138..165 常数、
                    // 166..177 累积量、178..186 CFO、187..192 功率。
                    std::string h;
                    for (size_t i = 0; i < f.pr.expert.size() && i < 8; ++i) {
                        h += fmt::format(" {:.4f}", f.pr.expert[i]);
                    }
                    spdlog::info("{} 首帧专家特征 {} 维，前 8 维:{}（8 帧一致 {}，帧号 {}）",
                                 kLogP, f.pr.expert.size(), h, f.pr.expert_frames_agree,
                                 f.pr.expert_frame);
                } else if (cfg.pl.expert_enable) {
                    spdlog::warn("{} 首帧专家特征不可用: {}", kLogP,
                                 f.pr.expert_error.empty() ? "未收到" : f.pr.expert_error);
                }
            }

            // 分析模式：频谱（有 eq 用 eq，没有就用原始 IQ），回帧和打印共用一份。
            std::vector<float> ana_mag;
            std::vector<uint8_t> ana_blob;
            if (mode == RunMode::Analysis) {
                const float *src_iq = (f.pr.eq_ok && f.pr.eq.size() == 2 * seg_len)
                                          ? f.pr.eq.data()
                                          : f.raw.data();
                fft_magnitude(src_iq, seg_len, ana_mag);
                ana_blob = build_analysis(f, xr, xf_usable, pl_usable, ex_usable, ex_probs,
                                          ana_mag);
            }

            // ---- 回帧（status != Ok 时不清空 top-k 以外的东西）----
            {
                std::vector<IqTopKEntry> entries;
                if (!f.no_signal) {
                    entries.reserve(deployed_top.size());
                    for (const auto &t : deployed_top) {
                        entries.push_back({static_cast<uint32_t>(t.index),
                                           static_cast<float>(t.prob)});
                    }
                }
                const uint32_t lat_us = static_cast<uint32_t>(lat_ms * 1000.0);
                if (mode == RunMode::Analysis && !f.no_signal) {
                    send_result_frame(f.hdr, ResultStatus::Analysis, lat_us, entries,
                                      &ana_blob);
                } else {
                    send_result_frame(f.hdr,
                                      f.no_signal ? ResultStatus::NoSignal : ResultStatus::Ok,
                                      lat_us, entries);
                }
            }

            if (seen % std::max(1, cfg.input.print_every) == 0) {
                // 流水模式下 ms 是帧周期，lat 才是本帧的端到端延迟。
                const std::string lat_tag =
                    pipe ? fmt::format("  lat {:.2f} ms", lat_ms) : std::string();
                if (mode == RunMode::Analysis) {
                    // 分析模式：不打命中/未命中，只打信号本身和三路诊断。
                    std::string s;
                    if (!ex_top.empty()) {
                        s += fmt::format("  ex={} {:.3f}",
                                         name_of(names, ex_top.front().index),
                                         ex_top.front().prob);
                    } else {
                        s += "  ex=?";
                    }
                    if (!xf_top.empty()) {
                        s += fmt::format("  xf={} {:.3f}", name_of(names, xf_top.front().index),
                                         xf_top.front().prob);
                    }
                    if (!pl_top.empty()) {
                        s += fmt::format("  pl={} {:.3f}", name_of(names, pl_top.front().index),
                                         pl_top.front().prob);
                    }
                    double eqsd = 0.0;
                    if (f.pr.eq_ok && f.pr.eq.size() == 2 * seg_len) {
                        eqsd = norm_stats(f.pr.eq.data(), seg_len).stddev;
                    }
                    size_t pk = 0;
                    for (size_t i = 1; i < ana_mag.size(); ++i) {
                        if (ana_mag[i] > ana_mag[pk]) pk = i;
                    }
                    fmt::print(
                        "seq {:>7}  [analysis]{}  |  {:7.2f} ms{}  eqstd={:.3f}  "
                        "fftpk={}/{}  feat={}\n",
                        f.hdr.seq, s, cycle_ms, lat_tag, eqsd, pk, ana_mag.size(),
                        f.pr.expert.size());
                } else {
                    std::string rest;
                    for (size_t i = 1; i < deployed_top.size(); ++i) {
                        const int c = deployed_top[i].index;
                        rest +=
                            fmt::format("  {} {:.3f}", name_of(names, c), deployed_top[i].prob);
                    }
                    const std::string truth =
                        (f.hdr.label >= 0)
                            ? fmt::format("  [gt {} {}]", f.hdr.label,
                                          name_of(names, f.hdr.label))
                            : std::string();
                    std::string diag;
                    if (!xf_top.empty()) {
                        diag += fmt::format("  [xf {} {:.3f}",
                                            name_of(names, xf_top.front().index),
                                            xf_top.front().prob);
                        if (xr.contributions != xr.expected) {
                            diag += fmt::format(" {}/{}", xr.contributions, xr.expected);
                        }
                        diag += "]";
                    } else {
                        diag += "  [XF 无输出]";
                    }
                    // 快速模式不跑 PL 头 / 专家，别假装它们"无输出"。
                    if (mode == RunMode::Fusion) {
                        if (!pl_top.empty()) {
                            diag += fmt::format("  [pl {} {:.3f}]",
                                                name_of(names, pl_top.front().index),
                                                pl_top.front().prob);
                        } else {
                            diag += "  [PL 无输出]";
                        }
                    }
                    fmt::print(
                        "seq {:>7}  top1 = {:<6} p={:.3f}{}  {:7.2f} ms{}  [{}]{}{}{}\n",
                        f.hdr.seq, name_of(names, pred), deployed_top.front().prob, rest,
                        cycle_ms, lat_tag, src_tag,
                        (f.hdr.label >= 0) ? (is_correct ? "  [hit]" : "  [MISS]") : "",
                        truth, diag);
                }
            }
        };

        stage("[6/6]", "进入主循环");
        if (pipe) {
            spdlog::info("{} PL 跨帧流水：PL(下一帧) ∥ XF(本帧)；日志 ms=帧周期，lat=收到→出结果",
                         kLogP);
        }

        PipeFrame cur;
        bool have_cur = fetch(cur);
        if (have_cur && pipe) {
            // 首帧没有上一帧的 XF 可重叠，同步跑一次整轮 PL（A+B）。
            // 非流水路径的 PL 在下面的循环里做，这里不能重复跑。
            run_pl(cur);
        }

        std::chrono::steady_clock::time_point prev_emit_tp{};
        bool has_prev_emit = false;

        while (have_cur) {
            PipeFrame nxt;
            bool have_next = false;
            std::thread pl_t;
            // 无论从哪条路退出（异常/提前 break）都必须 join，否则 terminate。
            struct JoinGuard {
                std::thread &t;
                ~JoinGuard() {
                    if (t.joinable()) t.join();
                }
            } pl_join{pl_t};
            XfResult xr;

            if (pipe) {
                // cur.pr 在上一轮（或启动时）已跑完。
                if (!cur.pl_done) {
                    // 上一轮没能预取（下一帧还没到），本帧的 PL 现在做。
                    // 这时不能再起下一帧的 PL —— 同一个 PL 对象只能给一个线程用。
                    run_pl(cur);
                } else if (src->next_frame_ready()) {
                    // 下一帧整帧已经在缓冲里，才提前取：PL(下一帧) ∥ XF(本帧)。
                    // 不 ready 就先出本帧结果，出完再阻塞收帧 —— 上位机若是
                    // 「发一帧等一帧」，板子等帧、上位机等结果会互等死锁。
                    have_next = fetch(nxt, /*once=*/true);
                    if (have_next && !skip_frame(nxt)) {
                        try {
                            pl_t = std::thread([&pl_infer, &nxt] {
                                pl_infer(nxt);
                                nxt.pl_done = true;
                            });
                        } catch (const std::exception &e) {
                            spdlog::warn("{} 起 PL 流水线程失败，本帧退回同步: {}", kLogP, e.what());
                            run_pl(nxt);
                        }
                    } else if (have_next) {
                        nxt.pl_done = true;  // 无信号帧不做 PL
                    }
                }
                account_pl(cur);

                // ---- XF：吃 cur 的均衡 IQ ----
                if (!skip_frame(cur) && cur.pr.eq_ok && cur.pr.eq.size() == 2 * seg_len) {
                    xr = xf->infer(cur.pr.eq.data(), seg_len);
                    if (xr.ok) {
                        ++xf_ok_n;
                        xf_ms_sum += xr.infer_ms;
                        ++xf_ms_n;
                    } else {
                        ++xf_fail;
                        if (xf_fail <= 5 || xf_fail % 100 == 0) {
                            spdlog::warn("{} XF 推理失败（第 {} 次）: {}", kLogP, xf_fail, xr.error);
                        }
                    }
                }

                // 等 PL 收尾：它写的是 nxt.pr，不 join 不能动 nxt。
                if (pl_t.joinable()) pl_t.join();
            } else {
                // ---- 老路径：本帧 PL 现在做，A 在主线程、B 可选并行 ----
                PlTtaState pl_st;
                if (pl && !skip_frame(cur)) {
                    const char *pl_mode = "串行";
                    const PlWorkOpts opts = pl_opts_for(cur.mode);
                    if (xf && cfg.pl.overlap_xf) {
                        cur.pr = pl->infer_a(cur.raw.data(), seg_len, pl_st, opts);
                        if (pl_st.do_b) {
                            pl_mode = "并行";
                            try {
                                pl_t = std::thread(
                                    [p = pl.get(), &pl_st, &cur] { p->infer_b(pl_st, cur.pr); });
                            } catch (const std::exception &e) {
                                spdlog::warn("{} 起 PL 并行线程失败，退回串行: {}", kLogP, e.what());
                                pl->infer_b(pl_st, cur.pr);
                                pl_mode = "串行";
                            }
                        }
                    } else {
                        cur.pr = pl->infer(cur.raw.data(), seg_len, opts);
                    }
                    // 首帧打一次选路，部署时一眼能看出跑的是哪条。
                    static bool mode_logged = false;
                    if (!mode_logged) {
                        spdlog::info("{} PL 两轮：{}（overlap_xf={}）", kLogP, pl_mode,
                                     cfg.pl.overlap_xf ? "true" : "false");
                        mode_logged = true;
                    }
                }

                // ---- XF：吃 dma2 的均衡 IQ ----
                if (xf && !skip_frame(cur) && cur.pr.eq_ok && cur.pr.eq.size() == 2 * seg_len) {
                    xr = xf->infer(cur.pr.eq.data(), seg_len);
                    if (xr.ok) {
                        ++xf_ok_n;
                        xf_ms_sum += xr.infer_ms;
                        ++xf_ms_n;
                    } else {
                        ++xf_fail;
                        if (xf_fail <= 5 || xf_fail % 100 == 0) {
                            spdlog::warn("{} XF 推理失败（第 {} 次）: {}", kLogP, xf_fail, xr.error);
                        }
                    }
                }

                // XF 跑完，等 PL 第二轮收尾；之后 cur.pr 才完整。
                if (pl_t.joinable()) pl_t.join();
                account_pl(cur);
                cur.pl_done = true;
            }

            // ---- 出本帧结果 ----
            const auto t_out = std::chrono::steady_clock::now();
            const double lat_ms = std::chrono::duration<double, std::milli>(t_out - cur.t_recv).count();
            const double cycle_ms =
                has_prev_emit
                    ? std::chrono::duration<double, std::milli>(t_out - prev_emit_tp).count()
                    : lat_ms;
            prev_emit_tp = t_out;
            has_prev_emit = true;

            finish_frame(cur, xr, lat_ms, cycle_ms);

            // 没有预取到（或压根没预取）就在这儿阻塞收下一帧：结果已经发出去了，
            // 「发一帧等一帧」的上位机不会互等。
            if (!have_next) have_next = fetch(nxt);
            if (!have_next) break;
            cur = std::move(nxt);
        }
        // ---------------- 汇总 ----------------
        if (lat_n > 0) {
            std::vector<double> sorted(lat_ring.begin(), lat_ring.begin() + static_cast<long>(lat_n));
            std::sort(sorted.begin(), sorted.end());
            const double sum = std::accumulate(sorted.begin(), sorted.end(), 0.0);
            fmt::print("\n帧数 {}  周期 平均 {:.2f} ms  p50 {:.2f} ms  p95 {:.2f} ms（最近 {} 帧）\n",
                       seen, sum / static_cast<double>(sorted.size()), sorted[sorted.size() / 2],
                       sorted[sorted.size() * 95 / 100], lat_n);
        }
        if (pipe && lat_num > 0) {
            fmt::print("单帧延迟（收到→出结果）平均 {:.2f} ms（比周期多一帧流水）\n",
                       lat_sum / static_cast<double>(lat_num));
        }
        if (nosignal > 0) fmt::print("无信号帧 {}\n", nosignal);
        if (xf_ms_n > 0) {
            fmt::print("XF 推理成功 {} 帧  平均 {:.2f} ms / 帧；失败 {} 次\n", xf_ms_n,
                       xf_ms_sum / static_cast<double>(xf_ms_n), xf_fail);
        }
        if (pl_ms_n > 0) {
            fmt::print("PL 推理成功 {} 帧  平均 {:.2f} ms / 帧；失败 {} 次，eq 不可用 {} 次，"
                       "专家不可用 {} 次\n",
                       pl_ms_n, pl_ms_sum / static_cast<double>(pl_ms_n), pl_fail, eq_fail,
                       exp_fail);
        }
        if (both_fail > 0) fmt::print("无可用结果 {} 帧\n", both_fail);
        if (labeled > 0) {
            fmt::print("有真值 {}/{} 帧\n", labeled, seen);
            if (xf_eval > 0) {
                fmt::print("  XF(一折) top1 = {:.2f}%  ({} 帧可评)\n",
                           100.0 * static_cast<double>(correct_xf) /
                               static_cast<double>(xf_eval),
                           xf_eval);
            }
            if (pl_eval > 0) {
                fmt::print("  PL   top1 = {:.2f}%  ({} 帧可评)\n",
                           100.0 * static_cast<double>(correct_pl) /
                               static_cast<double>(pl_eval),
                           pl_eval);
            }
            if (ex_eval > 0) {
                fmt::print("  EX   top1 = {:.2f}%  ({} 帧可评，专家 MLP 单模)\n",
                           100.0 * static_cast<double>(correct_ex) /
                               static_cast<double>(ex_eval),
                           ex_eval);
            }
            // 最终准确率 = 部署口径（只统计聚合模式的帧）：默认三路
            // (XF+PL+EX)；专家不可用的帧退回两路；无可用结果的帧按错计。
            if (fusion_labeled > 0) {
                fmt::print("  最终 top1 = {:.2f}%  (聚合 {} 帧；三路 {} 帧 / 两路 {} 帧 / "
                           "无可用结果 {} 帧按错计)\n",
                           100.0 * static_cast<double>(correct_fused) /
                               static_cast<double>(fusion_labeled),
                           fusion_labeled, fused3_n, fused2_n, both_fail);
            }
            if (fused3_eval > 0) {
                fmt::print("  三路 top1 = {:.2f}%  ({} 帧；权重 {:.2f}/{:.2f}/{:.2f})\n",
                           100.0 * static_cast<double>(correct_fused3) /
                               static_cast<double>(fused3_eval),
                           fused3_eval, cfg.w3_xf, cfg.w3_pl, cfg.w3_ex);
            }
            if (fast_labeled > 0) {
                fmt::print("  快速 top1 = {:.2f}%  ({} 帧，只跑 XF)\n",
                           100.0 * static_cast<double>(correct_fast) /
                               static_cast<double>(fast_labeled),
                           fast_labeled);
            }
        } else {
            fmt::print("帧数 {}（上位机没带真值，没算准确率）\n", seen);
        }
        if (ana_n > 0) {
            fmt::print("分析模式 {} 帧（不计预测准确率，信号数据随回帧发给上位机）\n", ana_n);
        }
        if (cmds_ok + cmds_bad > 0) {
            fmt::print("控制命令 接受 {} / 拒绝 {}\n", cmds_ok, cmds_bad);
        }
        if (eval_dump.active()) {
            fmt::print("评测导出 -> {}{}\n", cfg.input.eval_dump,
                       eval_dump.errors() > 0
                           ? fmt::format("（写失败 {} 次）", eval_dump.errors())
                           : std::string());
        }
        if (auto *t = dynamic_cast<TcpFrameSource *>(src.get())) {
            fmt::print("非法帧 {}  控制帧 {}  断连 {} 次\n", t->bad_frames(), t->commands(),
                       t->disconnects());
        } else if (auto *f = dynamic_cast<FileFrameSource *>(src.get())) {
            fmt::print("非法帧 {}\n", f->bad_frames());
        }

        // 先收 PL 的 DMA，再关 iCraft 设备；顺序反过来会多留一帧残留输出。
        if (pl) pl->close();
        xf.reset();
        icraft::xrt::Device::Close(device);
    } catch (const std::exception &e) {
        fmt::print(stderr, "\n错误: {}\n", e.what());
        return 1;
    }
    return 0;
}
