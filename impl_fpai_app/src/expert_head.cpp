#include "expert_head.hpp"

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstring>
#include <vector>

#include <spdlog/spdlog.h>

#include <icraft-backends/hostbackend/backend.h>
#include <icraft-xrt/dev/host_device.h>

#include "backend.hpp"
#include "expert_norm_fp16.h"
#include "npu_lock.hpp"

namespace rffi {
namespace {

// fp16 部署件固定 C=16（见 deploy_artifacts/expert_mlp/README.md 的表格）。
// 换成 int8 C=2 那套图时，这里、expert_norm_int8.h、配置里的 clamp 三处要一起改。
static_assert(expert::kExpertSrcDim == 193, "PL 的专家特征固定 193 维");
static_assert(expert::kExpertFeatDim <= expert::kExpertSrcDim,
              "部署图吃的维数不能超过 PL 给的");
static_assert(expert::kExpertPadDim == 256, "图输入是 [1,256]");

}  // namespace

struct ExpertHead::Impl {
    icraft::xir::Network network;
    FPAIDevice fpai_device;
    icraft::xrt::Session session;
    icraft::xrt::Tensor in_tensor;
    size_t in_bytes = 0;

    std::vector<float> norm;    // pad_dim：预处理后的输入
    std::vector<float> raw_out; // num_classes

    explicit Impl(icraft::xrt::Device &dev) : fpai_device(dev.cast<FPAIDevice>()) {}
};

ExpertHead::ExpertHead() = default;

ExpertHead::~ExpertHead() { close(); }

bool ExpertHead::is_open() const { return impl_ != nullptr; }

bool ExpertHead::open(icraft::xrt::Device &device, const ExpertHeadConfig &cfg, bool profile,
                      std::string &err) {
    close();
    cfg_ = cfg;
    profile_ = profile;
    if (cfg_.json.empty() || cfg_.raw.empty()) {
        err = "专家头缺 expert_json / expert_raw";
        return false;
    }
    if (cfg_.feat_dim != expert::kExpertFeatDim || cfg_.src_dim != expert::kExpertSrcDim ||
        cfg_.pad_dim != expert::kExpertPadDim) {
        err = "专家头维度 " + std::to_string(cfg_.src_dim) + "→" +
              std::to_string(cfg_.feat_dim) + "/" + std::to_string(cfg_.pad_dim) +
              " 与部署件 193→" + std::to_string(expert::kExpertFeatDim) + "/256 不一致";
        return false;
    }
    if (cfg_.num_classes <= 0 || !(cfg_.clamp > 0.0f)) {
        err = "专家头的 num_classes / clamp 非法";
        return false;
    }

    try {
        auto impl = std::make_unique<Impl>(device);
        impl->norm.assign(static_cast<size_t>(cfg_.pad_dim), 0.0f);
        impl->raw_out.assign(static_cast<size_t>(cfg_.num_classes), 0.0f);

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
        if (in_count != static_cast<size_t>(cfg_.pad_dim)) {
            err = cfg_.json + " 输入 shape=" + dims + "，期望 " +
                  std::to_string(cfg_.pad_dim) + " 个 float";
            return false;
        }

        impl->in_bytes = in_count * sizeof(float);
        impl->in_tensor = icraft::xrt::Tensor(ins[0].tensorType().clone())
                              .mallocOn(icraft::xrt::HostDevice::MemRegion());
        impl->session = icraft::xrt::Session::Create<FPAIBackend, icraft::xrt::HostBackend>(
            impl->network, {impl->fpai_device, icraft::xrt::HostDevice::Default()});
        impl->session.apply();
        impl->session.enableTimeProfile(profile);

        spdlog::info("[EXH] 装载 {}（输入 {} = {} B，μ/σ 在 PS 侧，C={:g}）", cfg_.json, dims,
                     impl->in_bytes, cfg_.clamp);
        impl_ = std::move(impl);
        logged_ = false;
        return true;
    } catch (const std::exception &e) {
        err = cfg_.json + ": " + e.what();
        return false;
    }
}

void ExpertHead::close() {
    impl_.reset();
    logged_ = false;
}

std::string ExpertHead::describe() const {
    if (!impl_) return "专家头未打开";
    return "专家 MLP (NPU) [1," + std::to_string(cfg_.src_dim) + "→" +
           std::to_string(cfg_.feat_dim) + "→" + std::to_string(cfg_.pad_dim) + "]→" +
           std::to_string(cfg_.num_classes) + "  " + cfg_.json;
}

bool ExpertHead::forward(const float *feat, size_t n, float *logits, std::string &err) {
    if (!impl_) {
        err = "专家头未打开";
        return false;
    }
    if (feat == nullptr || logits == nullptr) {
        err = "专家头输入/输出为空";
        return false;
    }
    if (n != static_cast<size_t>(cfg_.src_dim)) {
        err = "专家头只接受 " + std::to_string(cfg_.src_dim) + " 个特征，收到 " +
              std::to_string(n);
        return false;
    }

    // ---- PS 侧：按源索引取维 + 标准化 + 钳位 + 右侧补零 ----
    // 与 Transformer_Train/scripts/export_expert_icraft.py 同一口径：
    //   f = q12[kExpertSrcIdx[k]] / 4096（调用方已做）; z = clip((f-μ)/σ, -C, C) / C
    // kExpertSrcIdx 跳过 PL 的 const 组（138..165），部署图只吃 165 维。
    const float C = cfg_.clamp;
    for (int k = 0; k < cfg_.feat_dim; ++k) {
        const float f = feat[expert::kExpertSrcIdx[k]];
        const float z = (f - expert::kExpertMu[k]) / expert::kExpertSd[k];
        impl_->norm[static_cast<size_t>(k)] = std::clamp(z, -C, C) / C;
    }
    for (int k = cfg_.feat_dim; k < cfg_.pad_dim; ++k) {
        impl_->norm[static_cast<size_t>(k)] = 0.0f;
    }

    // ---- NPU 前向（与 XF / LCWT 头共用一块 NPU，必须串行）----
    std::lock_guard<std::mutex> lock(npu_mutex());
    try {
        std::memcpy(impl_->in_tensor.data().cptr(), impl_->norm.data(), impl_->in_bytes);

        auto outs = impl_->session.forward({impl_->in_tensor});
        bool ready = !outs.empty();
        for (auto &t : outs) {
            ready = t.waitForReady(std::chrono::milliseconds(10000)) && ready;
        }
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
        if (count != static_cast<size_t>(cfg_.num_classes)) {
            err = cfg_.json + " 输出元素数 " + std::to_string(count) + "（shape=" + dims +
                  "），期望 " + std::to_string(cfg_.num_classes);
            return false;
        }

        const auto *src = reinterpret_cast<const float *>(out_host.data().cptr());
        for (int c = 0; c < cfg_.num_classes; ++c) {
            if (!std::isfinite(src[c])) {
                err = cfg_.json + " 输出含 NaN/Inf";
                return false;
            }
            logits[c] = src[c];
        }
        if (!logged_) {
            spdlog::info("[EXH] 首次输出 shape={} bits={}", dims, bits);
            logged_ = true;
        }
        return true;
    } catch (const std::exception &e) {
        err = cfg_.json + " 前向异常: " + e.what();
        return false;
    }
}

}  // namespace rffi
