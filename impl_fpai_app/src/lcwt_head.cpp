#include "lcwt_head.hpp"

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <utility>
#include <vector>

#include <spdlog/spdlog.h>

#include <icraft-backends/hostbackend/backend.h>
#include <icraft-xrt/dev/host_device.h>

#include "backend.hpp"
#include "npu_lock.hpp"

namespace rffi {
namespace {

// aux 权重文件（scripts/export_lcwt_head_icraft.py --mode ln_ps 产出）
constexpr uint32_t kAuxMagic = 0x3141484Cu;  // "LHA1"
constexpr uint32_t kAuxVersion = 1;
constexpr size_t kAuxHeaderBytes = 32;

struct HeadAux {
    int tokens = 0;
    int dim = 0;
    int n_cls = 0;
    float eps = 1e-5f;
    std::vector<float> ln_w, ln_b;    // [dim]
    std::vector<float> head_w, head_b;  // [n_cls][dim], [n_cls]
};

uint32_t read_u32(const unsigned char *p) {
    return static_cast<uint32_t>(p[0]) | (static_cast<uint32_t>(p[1]) << 8) |
           (static_cast<uint32_t>(p[2]) << 16) | (static_cast<uint32_t>(p[3]) << 24);
}

float read_f32(const unsigned char *p) {
    const uint32_t u = read_u32(p);
    float f;
    std::memcpy(&f, &u, sizeof(f));
    return f;
}

bool load_aux(const std::string &path, int tokens, int dim, int n_cls, HeadAux &aux,
              std::string &err) {
    std::ifstream f(path, std::ios::binary | std::ios::ate);
    if (!f) {
        err = "读不到 LCWT 头 aux 权重 " + path;
        return false;
    }
    const std::streamoff size = f.tellg();
    if (size < static_cast<std::streamoff>(kAuxHeaderBytes)) {
        err = path + " 太短";
        return false;
    }
    std::vector<unsigned char> buf(static_cast<size_t>(size));
    f.seekg(0);
    if (!f.read(reinterpret_cast<char *>(buf.data()), size)) {
        err = path + " 读取失败";
        return false;
    }
    const unsigned char *p = buf.data();
    if (read_u32(p) != kAuxMagic) {
        err = path + " magic 不对（不是 LHA1 权重文件）";
        return false;
    }
    if (read_u32(p + 4) != kAuxVersion) {
        err = path + " 版本不认识";
        return false;
    }
    const int ft = static_cast<int>(read_u32(p + 8));
    const int fd = static_cast<int>(read_u32(p + 12));
    const int fc = static_cast<int>(read_u32(p + 16));
    const float eps = read_f32(p + 24);
    if (ft != tokens || fd != dim || fc != n_cls) {
        err = path + " 尺寸 tokens/dim/n_cls=" + std::to_string(ft) + "/" +
              std::to_string(fd) + "/" + std::to_string(fc) + "，期望 " +
              std::to_string(tokens) + "/" + std::to_string(dim) + "/" +
              std::to_string(n_cls);
        return false;
    }
    if (!std::isfinite(eps) || eps <= 0.0f) {
        err = path + " eps 非法";
        return false;
    }
    const size_t n_float = static_cast<size_t>(dim) * 2 +
                           static_cast<size_t>(n_cls) * dim + n_cls;
    if (static_cast<size_t>(size) != kAuxHeaderBytes + n_float * sizeof(float)) {
        err = path + " 长度 " + std::to_string(static_cast<long long>(size)) +
              " B，期望 " + std::to_string(kAuxHeaderBytes + n_float * sizeof(float)) + " B";
        return false;
    }

    aux.tokens = ft;
    aux.dim = fd;
    aux.n_cls = fc;
    aux.eps = eps;
    const float *q = reinterpret_cast<const float *>(buf.data() + kAuxHeaderBytes);
    size_t off = 0;
    auto take = [&](std::vector<float> &dst, size_t n) {
        dst.assign(q + off, q + off + n);
        off += n;
    };
    take(aux.ln_w, static_cast<size_t>(dim));
    take(aux.ln_b, static_cast<size_t>(dim));
    take(aux.head_w, static_cast<size_t>(n_cls) * dim);
    take(aux.head_b, static_cast<size_t>(n_cls));
    return true;
}

}  // namespace

struct LcwtHead::Impl {
    icraft::xir::Network network;
    FPAIDevice fpai_device;
    icraft::xrt::Session session;
    icraft::xrt::Tensor in_tensor;
    size_t in_bytes = 0;

    HeadAux aux;
    // 下面三个都按 batch 分配：norm = batch×input_dim，corr/raw_out = batch×num_classes
    std::vector<float> norm;    // LN 后的 token，喂给图
    std::vector<float> corr;    // W·mean(z) 常数项
    std::vector<float> raw_out; // 图输出（加常数项之前）

    explicit Impl(icraft::xrt::Device &dev) : fpai_device(dev.cast<FPAIDevice>()) {}
};

LcwtHead::LcwtHead() = default;

LcwtHead::~LcwtHead() { close(); }

bool LcwtHead::is_open() const { return impl_ != nullptr; }

bool LcwtHead::open(icraft::xrt::Device &device, const LcwtHeadConfig &cfg, bool profile,
                    std::string &err) {
    close();
    cfg_ = cfg;
    profile_ = profile;
    if (cfg_.json.empty() || cfg_.raw.empty()) {
        err = "LCWT 头缺 head_json / head_raw";
        return false;
    }
    if (cfg_.aux.empty()) {
        err = "LCWT 头缺 head_aux（LN 拆到 PS 后必须有权重）";
        return false;
    }
    if (cfg_.input_dim <= 0 || cfg_.num_classes <= 0 || cfg_.tokens <= 0 ||
        cfg_.dim <= 0 || cfg_.tokens * cfg_.dim != cfg_.input_dim ||
        cfg_.batch <= 0) {
        err = "LCWT 头的 input_dim / num_classes / tokens×dim / batch 不一致";
        return false;
    }

    try {
        auto impl = std::make_unique<Impl>(device);
        if (!load_aux(cfg_.aux, cfg_.tokens, cfg_.dim, cfg_.num_classes, impl->aux, err)) {
            return false;
        }
        const size_t B = static_cast<size_t>(cfg_.batch);
        impl->norm.resize(B * static_cast<size_t>(cfg_.input_dim));
        impl->corr.resize(B * static_cast<size_t>(cfg_.num_classes));
        impl->raw_out.resize(B * static_cast<size_t>(cfg_.num_classes));

        impl->network = icraft::xir::Network::CreateFromJsonFile(cfg_.json);
        impl->network.lazyLoadParamsFromFile(cfg_.raw);

        const auto &ins = impl->network.inputs();
        if (ins.size() != 1) {
            err = cfg_.json + " 应有 1 个输入，实际 " + std::to_string(ins.size());
            return false;
        }
        size_t in_count = 1;
        std::string dims;
        for (auto d : ins[0].tensorType()->shape) {
            in_count *= static_cast<size_t>(d);
            dims += std::to_string(static_cast<long long>(d)) + "x";
        }
        const size_t want_in =
            static_cast<size_t>(cfg_.batch) * static_cast<size_t>(cfg_.input_dim);
        if (in_count != want_in) {
            err = cfg_.json + " 输入 shape=" + dims + "（" + std::to_string(in_count) +
                  " 个 float），期望 " + std::to_string(cfg_.batch) + "×" +
                  std::to_string(cfg_.input_dim) + " = " + std::to_string(want_in) +
                  " —— pl.head_batch 和图不配套";
            return false;
        }

        impl->in_bytes = in_count * sizeof(float);
        impl->in_tensor = icraft::xrt::Tensor(ins[0].tensorType().clone())
                              .mallocOn(icraft::xrt::HostDevice::MemRegion());
        impl->session = icraft::xrt::Session::Create<FPAIBackend, icraft::xrt::HostBackend>(
            impl->network, {impl->fpai_device, icraft::xrt::HostDevice::Default()});
        impl->session.apply();
        impl->session.enableTimeProfile(profile);

        spdlog::info("[LCWT] 装载 {}（输入 {} = {} B，LN 在 PS 侧）", cfg_.json, dims,
                     impl->in_bytes);
        impl_ = std::move(impl);
        logged_ = false;
        return true;
    } catch (const std::exception &e) {
        err = cfg_.json + ": " + e.what();
        return false;
    }
}

void LcwtHead::close() {
    impl_.reset();
    logged_ = false;
}

std::string LcwtHead::describe() const {
    if (!impl_) return "LCWT 头未打开";
    return "LCWT 头 (PS-LN + NPU) [" + std::to_string(cfg_.batch) + "," +
           std::to_string(cfg_.input_dim) + "]→[" + std::to_string(cfg_.batch) + "," +
           std::to_string(cfg_.num_classes) + "]  " + cfg_.json;
}

bool LcwtHead::forward(const float *tok, size_t n, float *logits, std::string &err) {
    if (n != static_cast<size_t>(cfg_.input_dim)) {
        err = "LCWT 头只接受 " + std::to_string(cfg_.input_dim) + " 个 token，收到 " +
              std::to_string(n);
        return false;
    }
    return forward_batch(tok, 1, logits, err);
}

bool LcwtHead::forward_batch(const float *toks, int rows, float *logits,
                             std::string &err) {
    if (!impl_) {
        err = "LCWT 头未打开";
        return false;
    }
    if (toks == nullptr || logits == nullptr) {
        err = "LCWT 头输入/输出为空";
        return false;
    }
    const int B = cfg_.batch;
    if (rows <= 0 || rows > B) {
        err = "LCWT 头一次最多 " + std::to_string(B) + " 行，收到 " +
              std::to_string(rows);
        return false;
    }

    const int T = cfg_.tokens;
    const int D = cfg_.dim;
    const int C = cfg_.num_classes;
    const int IN = cfg_.input_dim;
    const HeadAux &aux = impl_->aux;

    // ---- PS 侧：LayerNorm(z)，以及常数项 W·mean_t(z) ----
    // 与 scripts/make_lcwt_head_calib.py --ln 同一口径（最后一维，总体方差）。
    // 不足 B 的行补第 0 行：图要求固定 batch，多算的行结果直接丢掉。
    std::vector<float> mean_z(static_cast<size_t>(D), 0.0f);
    for (int r = 0; r < B; ++r) {
        const float *tok = toks + static_cast<size_t>(r < rows ? r : 0) * IN;
        std::fill(mean_z.begin(), mean_z.end(), 0.0f);
        for (int t = 0; t < T; ++t) {
            const float *z = tok + static_cast<size_t>(t) * D;
            float mu = 0.0f;
            for (int d = 0; d < D; ++d) mu += z[d];
            mu /= static_cast<float>(D);
            float var = 0.0f;
            for (int d = 0; d < D; ++d) {
                const float v = z[d] - mu;
                var += v * v;
            }
            var /= static_cast<float>(D);
            const float inv = 1.0f / std::sqrt(var + aux.eps);
            float *dst = impl_->norm.data() + static_cast<size_t>(r) * IN +
                         static_cast<size_t>(t) * D;
            for (int d = 0; d < D; ++d) {
                dst[d] = (z[d] - mu) * inv * aux.ln_w[d] + aux.ln_b[d];
                mean_z[d] += z[d];
            }
        }
        const float inv_t = 1.0f / static_cast<float>(T);
        for (int d = 0; d < D; ++d) mean_z[d] *= inv_t;
        float *corr = impl_->corr.data() + static_cast<size_t>(r) * C;
        for (int c = 0; c < C; ++c) {
            const float *row = aux.head_w.data() + static_cast<size_t>(c) * D;
            float acc = 0.0f;
            for (int d = 0; d < D; ++d) acc += row[d] * mean_z[d];
            corr[c] = acc;  // 注意：不加 head bias，图里已经带过一次
        }
    }

    // ---- NPU：head(mean δ) ----
    // XF 和本头共用一块 NPU：整次前向（含 reset）必须串行。
    std::lock_guard<std::mutex> lock(npu_mutex());
    try {
        std::memcpy(impl_->in_tensor.data().cptr(), impl_->norm.data(), impl_->in_bytes);

        auto outs = impl_->session.forward({impl_->in_tensor});
        bool ready = !outs.empty();
        for (auto &t : outs) {
            ready = t.waitForReady(std::chrono::milliseconds(10000)) && ready;
        }

        // 与 XF / demo 相同的读法：waitForReady → reset(1) → to(Host)。
        // reset(1) 用来消掉「读到上一次输入结果」的迟一拍。
        impl_->fpai_device.reset(1);
        if (!ready) {
            err = cfg_.json + " forward 输出未就绪（空或 waitForReady 超时）";
            return false;
        }

        auto out_host = outs[0].to(icraft::xrt::HostDevice::MemRegion());
        const int bits = out_host.dtype()->element_dtype.getStorageType().bits();
        if (bits != 32) {
            err = cfg_.json + " 输出不是 32bit（" + std::to_string(bits) +
                  " bit）—— 图尾少了 Cast 到 float32";
            return false;
        }
        size_t count = 1;
        std::string dims;
        for (auto d : out_host.dtype()->shape) {
            count *= static_cast<size_t>(d);
            dims += std::to_string(static_cast<long long>(d)) + "x";
        }
        const size_t want_out = static_cast<size_t>(B) * static_cast<size_t>(C);
        if (count != want_out) {
            err = cfg_.json + " 输出元素数 " + std::to_string(count) + "（shape=" + dims +
                  "），期望 " + std::to_string(B) + "×" + std::to_string(C) +
                  " = " + std::to_string(want_out);
            return false;
        }

        const auto *src = reinterpret_cast<const float *>(out_host.data().cptr());
        for (int r = 0; r < rows; ++r) {
            float *dst = logits + static_cast<size_t>(r) * C;
            const float *cs = impl_->corr.data() + static_cast<size_t>(r) * C;
            for (int c = 0; c < C; ++c) {
                const float v = src[static_cast<size_t>(r) * C + c];
                if (!std::isfinite(v)) {
                    err = cfg_.json + " 输出含 NaN/Inf";
                    return false;
                }
                dst[c] = v + cs[c];
            }
        }
        if (!logged_) {
            spdlog::info("[LCWT] 首次输出 shape={} bits={}（batch={}，已加 PS 常数项）",
                         dims, bits, B);
            logged_ = true;
        }
        return true;
    } catch (const std::exception &e) {
        err = cfg_.json + " 前向异常: " + e.what();
        return false;
    }
}

}  // namespace rffi
