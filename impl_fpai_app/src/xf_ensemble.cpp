#include "xf_ensemble.hpp"

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <tuple>
#include <utility>

#include <spdlog/spdlog.h>

#include <icraft-backends/hostbackend/backend.h>
#include <icraft-xrt/dev/host_device.h>

#include "backend.hpp"
#include "npu_lock.hpp"
#include "preprocess.hpp"

namespace rffi {

namespace {

inline double ms_since(const std::chrono::steady_clock::time_point &t) {
    return std::chrono::duration<double, std::milli>(
               std::chrono::steady_clock::now() - t).count();
}

}  // namespace

struct XfEnsemble::Fold {
    icraft::xir::Network network;
    // demo 的做法：reset(1) 调在 cast<FPAIDevice>() 出来的句柄上（device_.reset(1)），
    // 不是基类 Device 上。基类句柄调 reset 在板上会让下一折 forward 卡住。
    FPAIDevice fpai_device;
    icraft::xrt::Session session;
    // 与已验证版本一致：输入张量分配在 HostDevice 内存区，逐帧 memcpy 进 data().cptr()。
    icraft::xrt::Tensor in_tensor;
    size_t in_bytes = 0;
    size_t batch = 1;                     // 图输入的静态批大小：[batch,2,seg_len]
    size_t calls = 0;                     // 首次前向打阶段日志，用于定位卡死点
    std::string path;
    bool ok = false;

    Fold(const XfModelPath &m, icraft::xrt::Device &dev, int seg_len, bool profile,
         std::string &err)
        : fpai_device(dev.cast<FPAIDevice>()), path(m.json) {
        try {
            network = icraft::xir::Network::CreateFromJsonFile(m.json);
            network.lazyLoadParamsFromFile(m.raw);

            const auto &ins = network.inputs();
            if (ins.size() != 1) {
                err = path + " 应有 1 个输入，实际 " + std::to_string(ins.size());
                return;
            }
            const auto shape = ins[0].tensorType()->shape;
            if (shape.size() != 3 || static_cast<long long>(shape[0]) < 1 ||
                static_cast<long long>(shape[1]) != 2 ||
                static_cast<long long>(shape[2]) != seg_len) {
                std::string dims;
                for (auto d : shape) dims += std::to_string(static_cast<long long>(d)) + "x";
                err = path + " 输入 shape=" + dims + "，期望 [批次,2," +
                      std::to_string(seg_len) + "]";
                return;
            }
            batch = static_cast<size_t>(shape[0]);

            in_bytes = batch * static_cast<size_t>(seg_len) * 2 * sizeof(float);
            in_tensor = icraft::xrt::Tensor(network.inputs()[0].tensorType().clone())
                            .mallocOn(icraft::xrt::HostDevice::MemRegion());

            session = icraft::xrt::Session::Create<FPAIBackend, icraft::xrt::HostBackend>(
                network, {fpai_device, icraft::xrt::HostDevice::Default()});
            session.apply();
            session.enableTimeProfile(profile);
            ok = true;
        } catch (const std::exception &e) {
            err = path + ": " + e.what();
        }
    }
};

XfEnsemble::XfEnsemble(XfConfig cfg) : cfg_(std::move(cfg)) {}

XfEnsemble::~XfEnsemble() { close(); }

bool XfEnsemble::open(icraft::xrt::Device &device, bool profile, std::string &err) {
    if (!cfg_.enable) {
        err = "XF 未启用";
        return false;
    }
    if (cfg_.models.empty()) {
        err = "xf.models 为空";
        return false;
    }
    if (cfg_.seg_len <= 0 || cfg_.num_classes <= 0) {
        err = "xf.seg_len / xf.num_classes 必须为正";
        return false;
    }
    if (cfg_.shifts.empty()) cfg_.shifts = {0};

    close();
    for (const auto &m : cfg_.models) {
        std::string ferr;
        auto f = std::make_unique<Fold>(m, device, cfg_.seg_len, profile, ferr);
        if (!f->ok) {
            err = ferr;
            close();
            return false;
        }
        spdlog::info("[XF] 装载 {}（输入 {}×[2,{}] = {} B）", f->path, f->batch,
                     cfg_.seg_len, f->in_bytes);
        folds_.push_back(std::move(f));
    }

    model_batch_ = folds_.front()->batch;
    for (const auto &f : folds_) {
        if (f->batch != model_batch_) {
            err = "五折的输入批大小不一致（" + std::to_string(model_batch_) + " vs " +
                  std::to_string(f->batch) + "），不能混用";
            close();
            return false;
        }
    }
    fused_ = cfg_.fused_folds > 0;
    n_folds_ = folds_.size();
    if (fused_) {
        // 五折在一张图里：输入 batch = 折数 × 平移数，行序 fold 主序。
        if (folds_.size() != 1) {
            err = "xf.fused_folds>0 时只能装载 1 个模型，实际 " +
                  std::to_string(folds_.size()) + " 个";
            close();
            return false;
        }
        n_folds_ = static_cast<size_t>(cfg_.fused_folds);
        const size_t want = n_folds_ * cfg_.shifts.size();
        if (model_batch_ != want) {
            err = "fused 图输入 batch=" + std::to_string(model_batch_) + "，但 " +
                  std::to_string(n_folds_) + " 折 × " +
                  std::to_string(cfg_.shifts.size()) + " 平移 = " +
                  std::to_string(want) + "；两者必须相等";
            close();
            return false;
        }
    } else if (model_batch_ > 1 && model_batch_ != static_cast<size_t>(cfg_.shifts.size())) {
        err = "图输入 batch=" + std::to_string(model_batch_) + "，但 xf.shifts 有 " +
              std::to_string(cfg_.shifts.size()) + " 个平移；两者必须相等";
        close();
        return false;
    }

    norm_buf_.assign(static_cast<size_t>(cfg_.seg_len) * 2, 0.0f);
    shifted_.assign(static_cast<size_t>(cfg_.seg_len) * 2, 0.0f);
    batch_buf_.assign(model_batch_ * static_cast<size_t>(cfg_.seg_len) * 2, 0.0f);
    profile_ = profile;
    profile_printed_ = false;
    return true;
}

void XfEnsemble::close() {
    folds_.clear();
    logged_ = false;
    model_batch_ = 1;
    n_folds_ = 1;
    fused_ = false;
}

std::string XfEnsemble::describe() const {
    std::string s = std::to_string(n_folds_) + " 折 × " +
                    std::to_string(cfg_.shifts.empty() ? 1 : cfg_.shifts.size()) + " 平移";
    if (fused_) {
        s += "（fused 一张图，batch=" + std::to_string(model_batch_) + "，一次前向）";
    } else if (model_batch_ > 1) {
        s += "（batch=" + std::to_string(model_batch_) + " 一次前向）";
    }
    s += cfg_.double_forward ? "  双前向(迟一拍补偿)" : "  单前向";
    s += "  reset=" + cfg_.reset_mode;
    s += cfg_.require_all ? "  全部成功才采用" : "  按成功次数平均";
    return s;
}

bool XfEnsemble::forward_fold(Fold &f, float *probs, int batch, std::string &err) {
    // ZG330 只有一个 NPU；LCWT 头在 PL 工作线程上也会 forward + reset。
    // 整次前向持锁，避免两个 Session 的 reset 互相踩（见 npu_lock.hpp）。
    std::lock_guard<std::mutex> npu_lock_guard(npu_mutex());

    // 首次调用逐阶段打日志：卡死时最后一行就是卡住的位置。
    const bool trace = (f.calls++ == 0);
    ++t_calls_;
    if (trace) spdlog::info("[XF] {} 第 1 次前向：forward 前", f.path);

    std::vector<icraft::xrt::Tensor> outs;
    auto run = [&]() {
        const auto ts = std::chrono::steady_clock::now();
        outs = f.session.forward({f.in_tensor});
        bool ready = !outs.empty();
        for (auto &t : outs) {
            ready = t.waitForReady(std::chrono::milliseconds(10000)) && ready;
        }
        t_fwd_ += ms_since(ts);
        return ready;
    };

    if (cfg_.double_forward) {
        // 第一次算的是上一次 write 的数据（板上实测），丢弃。
        std::vector<icraft::xrt::Tensor> discard;
        if (!run()) {
            err = f.path + " 预前向输出未就绪";
            return false;
        }
        discard = std::move(outs);
    }

    if (trace) spdlog::info("[XF] {} 开始 forward（含 waitForReady）", f.path);
    const bool ready = run();
    if (trace) spdlog::info("[XF] {} forward+wait 完成 ready={}", f.path, ready);
    if (!ready) {
        // 失败也 reset，别把半截状态留给下一折。
        if (cfg_.reset_mode == "fold") {
            const auto ts = std::chrono::steady_clock::now();
            f.fpai_device.reset(1);
            t_reset_ += ms_since(ts);
        }
        err = f.path + " forward 输出未就绪（空或 waitForReady 超时）";
        return false;
    }

    // demo 的读输出顺序（yolov5_npu_actor.hpp / postprocesses.hpp）：
    //   forward -> waitForReady -> fpai_device.reset(1) -> .to(Host) -> 读。
    if (cfg_.reset_mode == "fold") {
        const auto ts = std::chrono::steady_clock::now();
        f.fpai_device.reset(1);
        t_reset_ += ms_since(ts);
        if (trace) spdlog::info("[XF] {} reset(1) 完成", f.path);
    }

    const auto ts_to = std::chrono::steady_clock::now();
    auto out_host = outs[0].to(icraft::xrt::HostDevice::MemRegion());
    t_to_ += ms_since(ts_to);
    if (trace) spdlog::info("[XF] {} .to(Host) 完成", f.path);
    const int bits = out_host.dtype()->element_dtype.getStorageType().bits();
    if (bits != 32) {
        err = f.path + " 输出不是 32bit（" + std::to_string(bits) +
              " bit）—— 图尾少了 Cast 到 float32";
        return false;
    }

    size_t count = 1;
    std::string dims;
    for (auto d : out_host.dtype()->shape) {
        count *= static_cast<size_t>(d);
        dims += std::to_string(static_cast<long long>(d)) + "x";
    }
    const size_t expect = static_cast<size_t>(batch) * static_cast<size_t>(cfg_.num_classes);
    if (count != expect) {
        err = f.path + " 输出元素数 " + std::to_string(count) + "（shape=" + dims +
              "），期望 " + std::to_string(batch) + "×" +
              std::to_string(cfg_.num_classes);
        return false;
    }

    if (!logged_) {
        spdlog::info("[XF] 首次输出 shape={} bits={}", dims, bits);
        logged_ = true;
    }

    const auto *logits = reinterpret_cast<const float *>(out_host.data().cptr());
    for (int s = 0; s < batch; ++s) {
        const float *one = logits + static_cast<size_t>(s) * cfg_.num_classes;
        float *out = probs + static_cast<size_t>(s) * cfg_.num_classes;
        float m = one[0];
        for (int c = 1; c < cfg_.num_classes; ++c) m = std::max(m, one[c]);
        bool finite = true;
        for (int c = 0; c < cfg_.num_classes; ++c) finite = finite && std::isfinite(one[c]);
        if (!finite) {
            // 打前 8 个原始 32bit 码：NaN(0x7fc00000) 与未初始化 DDR 垃圾一眼可分。
            std::string tail;
            for (int c = 0; c < std::min(cfg_.num_classes, 8); ++c) {
                uint32_t u = 0;
                std::memcpy(&u, &one[c], sizeof(u));
                char b[16];
                std::snprintf(b, sizeof(b), " %08x", u);
                tail += b;
            }
            spdlog::warn("[XF] {} 输出非有限（第 {} 个），前 8 个码值:{}", f.path, s, tail);
            err = f.path + " 输出含 NaN/Inf";
            return false;
        }

        double sum = 0.0;
        for (int c = 0; c < cfg_.num_classes; ++c) {
            const double e = std::exp(static_cast<double>(one[c] - m));
            out[c] = static_cast<float>(e);
            sum += e;
        }
        if (!(sum > 0.0)) {
            err = f.path + " 输出无法归一化";
            return false;
        }
        for (int c = 0; c < cfg_.num_classes; ++c) {
            out[c] = static_cast<float>(static_cast<double>(out[c]) / sum);
        }
    }
    return true;
}

XfResult XfEnsemble::infer(const float *iq, size_t n_complex) {
    const auto t0 = std::chrono::steady_clock::now();
    XfResult r;

    if (folds_.empty()) {
        r.error = "XF 未打开";
        return r;
    }
    if (n_complex != static_cast<size_t>(cfg_.seg_len)) {
        r.error = "XF 只支持 " + std::to_string(cfg_.seg_len) + " 个复点/帧，收到 " +
                  std::to_string(n_complex);
        return r;
    }

    // 图外 PerSampleNorm + 交错 -> 通道优先。之后每个 shift 都从这份干净数据上 roll。
    deinterleave_normalize(iq, static_cast<size_t>(cfg_.seg_len), norm_buf_.data());

    const int n = cfg_.seg_len;
    std::vector<int> shifts = cfg_.shifts;
    if (shifts.empty()) shifts.push_back(0);
    const size_t n_folds = n_folds_;
    r.expected = static_cast<int>(n_folds * shifts.size());

    std::vector<double> acc(static_cast<size_t>(cfg_.num_classes), 0.0);
    // 单折统计：每折只平均它自己的平移，用来在现场单独看某一折的准确率。
    std::vector<std::vector<double>> fold_acc(
        n_folds, std::vector<double>(static_cast<size_t>(cfg_.num_classes), 0.0));
    std::vector<int> fold_cnt(n_folds, 0);
    std::vector<int> fold_good(n_folds, 0);
    double contributions = 0.0;
    std::vector<float> probs(static_cast<size_t>(model_batch_) * cfg_.num_classes, 0.0f);

    // torch.roll(x, shift, dims=-1)：out[k] = in[(k - shift) mod N]。
    auto fill_shift = [&](float *dst, int shift) {
        for (int k = 0; k < n; ++k) {
            int src = (k - shift) % n;
            if (src < 0) src += n;
            dst[k] = norm_buf_[static_cast<size_t>(src)];
            dst[n + k] = norm_buf_[static_cast<size_t>(n + src)];
        }
    };

    if (fused_) {
        // 五折在一张图里：行序 fold 主序（row = fold * S + shift），一帧一次前向。
        const size_t S = shifts.size();
        for (size_t fi = 0; fi < n_folds; ++fi) {
            for (size_t s = 0; s < S; ++s) {
                fill_shift(batch_buf_.data() +
                               (fi * S + s) * 2 * static_cast<size_t>(n),
                           shifts[s]);
            }
        }
        std::vector<int> shift_good(S, 0);
        auto &f = *folds_[0];
        const auto ts_cpy = std::chrono::steady_clock::now();
        std::memcpy(f.in_tensor.data().cptr(), batch_buf_.data(), f.in_bytes);
        t_cpy_ += ms_since(ts_cpy);
        std::string ferr;
        if (!forward_fold(f, probs.data(), static_cast<int>(model_batch_), ferr)) {
            r.error = ferr;
        } else {
            for (size_t fi = 0; fi < n_folds; ++fi) {
                for (size_t s = 0; s < S; ++s) {
                    const size_t row = (fi * S + s) * static_cast<size_t>(cfg_.num_classes);
                    for (int c = 0; c < cfg_.num_classes; ++c) {
                        const float p = probs[row + static_cast<size_t>(c)];
                        acc[static_cast<size_t>(c)] += p;
                        fold_acc[fi][static_cast<size_t>(c)] += p;
                    }
                    ++fold_cnt[fi];
                    ++shift_good[s];
                    ++fold_good[fi];
                    contributions += 1.0;
                    ++r.contributions;
                }
            }
        }
        for (int g : shift_good) {
            if (g == static_cast<int>(n_folds)) ++r.shifts_ok;
        }
    } else if (model_batch_ > 1) {
        // 图输入 batch = 平移数：全部平移一次喂进去，每折只调一次 forward。
        // 槽位顺序与 shifts 一致；open() 已保证 model_batch_ == shifts.size()。
        for (size_t s = 0; s < shifts.size(); ++s) {
            fill_shift(batch_buf_.data() + s * 2 * static_cast<size_t>(n), shifts[s]);
        }
        std::vector<int> shift_good(shifts.size(), 0);
        for (size_t fi = 0; fi < n_folds; ++fi) {
            auto &f = *folds_[fi];
            const auto ts_cpy = std::chrono::steady_clock::now();
            std::memcpy(f.in_tensor.data().cptr(), batch_buf_.data(), f.in_bytes);
            t_cpy_ += ms_since(ts_cpy);
            std::string ferr;
            if (!forward_fold(f, probs.data(), static_cast<int>(model_batch_), ferr)) {
                if (r.error.empty()) r.error = ferr;
                continue;
            }
            for (size_t s = 0; s < shifts.size(); ++s) {
                for (int c = 0; c < cfg_.num_classes; ++c) {
                    const float p = probs[s * cfg_.num_classes + static_cast<size_t>(c)];
                    acc[static_cast<size_t>(c)] += p;
                    fold_acc[fi][static_cast<size_t>(c)] += p;
                }
                ++fold_cnt[fi];
                ++shift_good[s];
                ++fold_good[fi];
                contributions += 1.0;
                ++r.contributions;
            }
        }
        for (int g : shift_good) {
            if (g == static_cast<int>(n_folds)) ++r.shifts_ok;
        }
    } else {
        for (int shift : shifts) {
            fill_shift(shifted_.data(), shift);

            int shift_good = 0;
            for (size_t fi = 0; fi < n_folds; ++fi) {
                auto &f = *folds_[fi];
                const auto ts_cpy = std::chrono::steady_clock::now();
                std::memcpy(f.in_tensor.data().cptr(), shifted_.data(), f.in_bytes);
                t_cpy_ += ms_since(ts_cpy);
                std::string ferr;
                if (!forward_fold(f, probs.data(), 1, ferr)) {
                    if (r.error.empty()) r.error = ferr;
                    continue;
                }
                for (int c = 0; c < cfg_.num_classes; ++c) {
                    acc[static_cast<size_t>(c)] += probs[static_cast<size_t>(c)];
                    fold_acc[fi][static_cast<size_t>(c)] += probs[static_cast<size_t>(c)];
                }
                ++fold_cnt[fi];
                ++shift_good;
                ++fold_good[fi];
                contributions += 1.0;
                ++r.contributions;
            }
            if (shift_good == static_cast<int>(n_folds)) ++r.shifts_ok;
        }
    }

    // frame 模式：25 次前向做完后统一 reset 一次（等价于 demo 的「一次推理一次 reset」）。
    if (cfg_.reset_mode == "frame" && !folds_.empty()) {
        const auto ts = std::chrono::steady_clock::now();
        folds_.front()->fpai_device.reset(1);
        t_reset_ += ms_since(ts);
    }

    // 分段时间账：每 32 帧打一次「每次前向」的均值，用来判断钱花在哪。
    if (++t_frames_ % 32 == 0 && t_calls_ > 0) {
        const double n = static_cast<double>(t_calls_);
        spdlog::info("[XF-T] 每次前向 fwd={:.3f} reset={:.3f} toHost={:.3f} "
                     "memcpy={:.4f} ms（{} 次）",
                     t_fwd_ / n, t_reset_ / n, t_to_ / n, t_cpy_ / n, t_calls_);
        t_fwd_ = t_reset_ = t_to_ = t_cpy_ = 0.0;
        t_calls_ = 0;
    }

    // sys.profile=true：第一帧后把各算子时间合计打出来。每项依次是
    // 墙上时间 / 数据搬运 / 硬件计算 / 其他（单位由 SDK 定，看它们之间的比例，
    // 再除以本帧实测的 fwd 总和就能换算成 ms）。
    if (profile_ && !profile_printed_) {
        double wall = 0.0, cpy = 0.0, hw = 0.0, oth = 0.0;
        size_t n_ops = 0;
        for (auto &f : folds_) {
            for (const auto &kv : f->session.timeProfileResults()) {
                wall += std::get<0>(kv.second);
                cpy += std::get<1>(kv.second);
                hw += std::get<2>(kv.second);
                oth += std::get<3>(kv.second);
                ++n_ops;
            }
        }
        if (n_ops > 0) {
            spdlog::info("[XF-P] {} 折共 {} 个算子：wall={:.6f} copy={:.6f} "
                         "hw={:.6f} other={:.6f}",
                         folds_.size(), n_ops, wall, cpy, hw, oth);
            profile_printed_ = true;
        }
    }

    if (contributions <= 0.0) {
        if (r.error.empty()) r.error = "XF 所有前向都失败";
        return r;
    }

    // 单折结果：只平均这一折自己的平移（五折平均的是 r.probs）。
    r.fold_argmax.assign(n_folds, -1);
    r.fold_prob.assign(n_folds, 0.0f);
    for (size_t fi = 0; fi < n_folds; ++fi) {
        if (fold_cnt[fi] == 0) continue;
        int best = 0;
        for (int c = 1; c < cfg_.num_classes; ++c) {
            if (fold_acc[fi][static_cast<size_t>(c)] >
                fold_acc[fi][static_cast<size_t>(best)]) {
                best = c;
            }
        }
        double sum = 0.0;
        for (int c = 0; c < cfg_.num_classes; ++c) {
            sum += fold_acc[fi][static_cast<size_t>(c)];
        }
        r.fold_argmax[fi] = best;
        // 平均后仍按概率归一（每折的平移次数相同，直接 best/sum 即可）。
        r.fold_prob[fi] = (sum > 0.0)
                              ? static_cast<float>(
                                    fold_acc[fi][static_cast<size_t>(best)] / sum)
                              : 0.0f;
    }

    r.folds_ok = 0;
    for (int g : fold_good) {
        if (g == static_cast<int>(shifts.size())) ++r.folds_ok;
    }
    r.probs.assign(static_cast<size_t>(cfg_.num_classes), 0.0f);
    for (int c = 0; c < cfg_.num_classes; ++c) {
        r.probs[static_cast<size_t>(c)] =
            static_cast<float>(acc[static_cast<size_t>(c)] / contributions);
    }
    r.ok = cfg_.require_all ? (r.contributions == r.expected) : true;
    if (!r.ok && r.error.empty()) {
        r.error = "XF 只成功 " + std::to_string(r.contributions) + "/" +
                  std::to_string(r.expected) + " 次前向";
    }
    r.infer_ms = std::chrono::duration<double, std::milli>(
                     std::chrono::steady_clock::now() - t0)
                     .count();
    return r;
}

}  // namespace rffi
