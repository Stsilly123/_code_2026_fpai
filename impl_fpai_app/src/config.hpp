// YAML 配置 -> 结构体。体例照 demo（`configs/ZG/sdicamera+yolov5+hdmi.yaml`），
// 程序从 argv[1] 拿配置路径，配置里的路径都是 **CWD 相对**（demo 也是这个约定，
// 所以要从 impl_fpai_app/ 目录下运行）。
//
// 新数据通路（2026-10-20）：
//   PL dma1（LCWT 小模型） + dma2（均衡后 IQ） -> XF 五折集成 -> 概率融合。
#pragma once

#include <cmath>
#include <cstdint>
#include <fstream>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

#include <yaml-cpp/yaml.h>

#include "iq_frame.hpp"
#include "pl_side.hpp"
#include "xf_types.hpp"

namespace rffi {

struct SysConfig {
    std::string run_backend = "zg330";         // zg330（本板）| buyi（100TAI）
    std::string ip = "127.0.0.1";              // 仅 x86 走 socket:// 时用
    std::string npu_addr = "0x40000000";
    std::string dma_addr = "0x80000000";
    bool mmu_mode = true;                      // 仅 buyi 分支使用
    bool profile = false;
};

struct InputConfig {
    std::string mode = "tcp";                  // tcp | file
    std::string bind_addr = "0.0.0.0";
    int port = 9527;
    std::string file;                          // mode=file 时的帧流路径
    int topk = 5;
    int print_every = 1;
    // 无信号判定：载荷（原始未归一化）的 std 低于它 → 回 status=NoSignal。
    // 0 = 关闭（默认）。阈值必须拿真实空采数据定，别拍脑袋。
    float signal_min_std = 0.0f;
    bool skip_nosignal = false;
    int idle_warn_ms = 0;
    // 逐帧评测导出（一次性对拍用）：非空时每帧写一段定长二进制记录
    // （XF 概率 / PL 概率 / 193 维专家特征 + seq/label/可用标志）。
    // 只写文件，不参与任何推理；测延迟时留空。
    std::string eval_dump;
};

struct AppConfig {
    SysConfig sys;
    XfConfig xf;                               // XF 五折（从 dma2 的均衡 IQ 推理）
    InputConfig input;
    // 启动时的运行模式（上位机可以用控制帧随时切；见 RunMode）。
    RunMode mode = RunMode::Fusion;
    PlConfig pl;                               // LcwtMLP（dma1）+ eq 接收（dma2）
    float pl_weight = 1.0f / 3.0f;             // 两路融合权重 w：XF 得 1-w
    // 三路融合（XF + PL + 专家）在 log 概率空间加权。0.6/0.2/0.2 来自
    // Transformer_Train/scripts/fuse_int8_3way_20cls.py（XF 单折 INT8 + PL + EX）。
    // 专家不可用时自动退回上面那个两路权重。
    float w3_xf = 0.6f;
    float w3_pl = 0.2f;
    float w3_ex = 0.2f;
};

// 读不到就抛，别静默用默认值 —— 配置写错时默认值会伪装成「能跑」。
template <typename T>
T req(const YAML::Node &n, const char *key, const char *where) {
    if (!n[key] || !n[key].IsScalar()) {
        throw std::runtime_error(std::string("配置缺字段 ") + where + "." + key);
    }
    return n[key].as<T>();
}

// 0x80400000 这种地址可以用带引号/不带引号的字符串写，按 base=0 解析。
inline uint64_t parse_addr(const YAML::Node &n, const char *key, const char *where) {
    const std::string s = n[key].as<std::string>();
    try {
        size_t pos = 0;
        const unsigned long long v = std::stoull(s, &pos, 0);
        if (pos != s.size()) throw std::invalid_argument("trailing");
        return static_cast<uint64_t>(v);
    } catch (const std::exception &) {
        throw std::runtime_error(std::string("配置里 ") + where + "." + key +
                                 " 不是合法地址: " + s);
    }
}

inline RunMode parse_run_mode(const std::string &s, const char *where) {
    if (s == "fast") return RunMode::Fast;
    if (s == "fusion" || s == "aggregate") return RunMode::Fusion;
    if (s == "analysis" || s == "analyze") return RunMode::Analysis;
    throw std::runtime_error(std::string("配置里 ") + where +
                             ".mode 只能是 fast / fusion / analysis，收到 " + s);
}

inline std::vector<int> int_list(const YAML::Node &n, const char *key, const char *where) {
    std::vector<int> v;
    if (!n[key]) return v;
    if (!n[key].IsSequence()) {
        throw std::runtime_error(std::string("配置里 ") + where + "." + key + " 必须是列表");
    }
    for (const auto &e : n[key]) v.push_back(e.as<int>());
    return v;
}

inline void parse_xf(AppConfig &c, const YAML::Node &xf) {
    if (xf["enable"]) c.xf.enable = xf["enable"].as<bool>();
    if (xf["required"]) c.xf.required = xf["required"].as<bool>();
    c.xf.names = req<std::string>(xf, "names", "xf");
    if (xf["seg_len"]) c.xf.seg_len = xf["seg_len"].as<int>();
    if (xf["num_classes"]) c.xf.num_classes = xf["num_classes"].as<int>();
    if (xf["double_forward"]) c.xf.double_forward = xf["double_forward"].as<bool>();
    if (xf["reset_mode"]) c.xf.reset_mode = xf["reset_mode"].as<std::string>();
    if (xf["require_all"]) c.xf.require_all = xf["require_all"].as<bool>();
    if (xf["fused_folds"]) c.xf.fused_folds = xf["fused_folds"].as<int>();
    if (c.xf.reset_mode != "off" && c.xf.reset_mode != "frame" &&
        c.xf.reset_mode != "fold") {
        throw std::runtime_error("xf.reset_mode 只能是 off / frame / fold，收到 " +
                                 c.xf.reset_mode);
    }
    const auto shifts = int_list(xf, "shifts", "xf");
    if (!shifts.empty()) c.xf.shifts = shifts;

    if (!xf["models"] || !xf["models"].IsSequence() || xf["models"].size() == 0) {
        throw std::runtime_error("配置缺字段 xf.models（或列表为空）");
    }
    for (const auto &m : xf["models"]) {
        XfModelPath p;
        p.json = req<std::string>(m, "json", "xf.models[]");
        p.raw = req<std::string>(m, "raw", "xf.models[]");
        c.xf.models.push_back(std::move(p));
    }

    if (c.xf.models.size() > 8) {
        throw std::runtime_error("xf.models 最多 8 折（当前 " +
                                 std::to_string(c.xf.models.size()) + "）");
    }
    if (c.xf.fused_folds < 0) {
        throw std::runtime_error("xf.fused_folds 不能为负");
    }
    if (c.xf.fused_folds > 0 && c.xf.models.size() != 1) {
        throw std::runtime_error("xf.fused_folds>0 时 xf.models 只能有 1 项（合成图）");
    }
    if (c.xf.seg_len <= 0 || c.xf.num_classes <= 0) {
        throw std::runtime_error("xf.seg_len / xf.num_classes 必须为正");
    }
    if (c.xf.shifts.empty()) c.xf.shifts = {0};
    if (c.xf.shifts.size() > 32) {
        throw std::runtime_error("xf.shifts 最多 32 个");
    }
    for (int s : c.xf.shifts) {
        if (s <= -c.xf.seg_len || s >= c.xf.seg_len) {
            throw std::runtime_error("xf.shifts 里的 " + std::to_string(s) +
                                     " 超出 (-seg_len, seg_len)");
        }
    }
}

inline void parse_pl(AppConfig &c, const YAML::Node &pl) {
    if (pl["enable"]) c.pl.enable = pl["enable"].as<bool>();
    if (pl["required"]) c.pl.required = pl["required"].as<bool>();
    if (pl["fallback_to_xf"]) c.pl.fallback_to_xf = pl["fallback_to_xf"].as<bool>();
    if (pl["udmabuf"]) c.pl.udmabuf = pl["udmabuf"].as<std::string>();
    if (pl["dma0_base"]) c.pl.dma0_base = parse_addr(pl, "dma0_base", "pl");
    if (pl["dma1_base"]) c.pl.dma1_base = parse_addr(pl, "dma1_base", "pl");
    if (pl["dma2_base"]) c.pl.dma2_base = parse_addr(pl, "dma2_base", "pl");
    if (pl["dma3_base"]) c.pl.dma3_base = parse_addr(pl, "dma3_base", "pl");
    if (pl["timeout_ms"]) c.pl.timeout_ms = pl["timeout_ms"].as<int>();
    if (pl["total_timeout_ms"]) c.pl.total_timeout_ms = pl["total_timeout_ms"].as<int>();
    if (pl["eq_enable"]) c.pl.eq_enable = pl["eq_enable"].as<bool>();
    if (pl["expert_enable"]) c.pl.expert_enable = pl["expert_enable"].as<bool>();
    if (pl["head_json"]) c.pl.head_json = pl["head_json"].as<std::string>();
    if (pl["head_raw"]) c.pl.head_raw = pl["head_raw"].as<std::string>();
    if (pl["head_aux"]) c.pl.head_aux = pl["head_aux"].as<std::string>();
    if (pl["expert_json"]) c.pl.expert_json = pl["expert_json"].as<std::string>();
    if (pl["expert_raw"]) c.pl.expert_raw = pl["expert_raw"].as<std::string>();
    if (pl["expert_clamp"]) c.pl.expert_clamp = pl["expert_clamp"].as<float>();
    if (pl["token_divisor"]) c.pl.token_divisor = pl["token_divisor"].as<float>();
    if (pl["head_batch"]) c.pl.head_batch = pl["head_batch"].as<int>();
    if (pl["min_agree_frames"]) c.pl.min_agree_frames = pl["min_agree_frames"].as<int>();
    if (pl["min_eq_agree_frames"]) {
        c.pl.min_eq_agree_frames = pl["min_eq_agree_frames"].as<int>();
    }
    if (pl["overlap_xf"]) c.pl.overlap_xf = pl["overlap_xf"].as<bool>();
    if (pl["cross_frame"]) c.pl.cross_frame = pl["cross_frame"].as<bool>();
    if (pl["weights_hash"]) c.pl.weights_hash = pl["weights_hash"].as<std::string>();
    if (pl["diag_dump"]) c.pl.diag_dump = pl["diag_dump"].as<std::string>();

    const auto shifts = int_list(pl, "tta_shifts", "pl");
    if (!shifts.empty()) c.pl.tta_shifts = shifts;

    if (!std::isfinite(c.pl.token_divisor) || c.pl.token_divisor <= 0.0f) {
        throw std::runtime_error("pl.token_divisor 必须是正有限数");
    }
    if (c.pl.enable && (c.pl.head_json.empty() || c.pl.head_raw.empty() ||
                        c.pl.head_aux.empty())) {
        throw std::runtime_error("pl.enable=true 时必须给 pl.head_json / pl.head_raw / "
                                 "pl.head_aux（PL 已裁掉 head；LN 在 PS 侧算，"
                                 "logits 由 NPU 的 LCWT 头出）");
    }
    if (c.pl.enable && c.pl.expert_enable &&
        (c.pl.expert_json.empty() || c.pl.expert_raw.empty())) {
        throw std::runtime_error("pl.expert_enable=true 时必须给 pl.expert_json / "
                                 "pl.expert_raw（专家 MLP 在 NPU 上跑）");
    }
    if (!std::isfinite(c.pl.expert_clamp) || c.pl.expert_clamp <= 0.0f) {
        throw std::runtime_error("pl.expert_clamp 必须是正有限数（fp16 图用 16，int8 图用 2）");
    }
    if (c.pl.head_batch < 1) {
        throw std::runtime_error("pl.head_batch 必须 >= 1（部署图 [5,608] 时写 5）");
    }
    if (c.pl.min_agree_frames < 0 || c.pl.min_agree_frames > 8) {
        throw std::runtime_error("pl.min_agree_frames 必须在 0..8 之间");
    }
    if (c.pl.min_eq_agree_frames < 0 || c.pl.min_eq_agree_frames > 8) {
        throw std::runtime_error("pl.min_eq_agree_frames 必须在 0..8 之间");
    }
    if (c.pl.timeout_ms <= 0 || c.pl.total_timeout_ms <= 0) {
        throw std::runtime_error("pl.timeout_ms / pl.total_timeout_ms 必须为正");
    }
    if (c.pl.eq_enable) {
        if (c.pl.tta_shifts.empty()) c.pl.tta_shifts = {0};
        int zeros = 0;
        for (int s : c.pl.tta_shifts) {
            if (s == 0) ++zeros;
        }
        if (zeros != 1) {
            throw std::runtime_error("pl.eq_enable=true 时 pl.tta_shifts 必须恰好包含一个 0");
        }
    }
}

inline AppConfig load_config(const std::string &path) {
    YAML::Node root;
    try {
        root = YAML::LoadFile(path);
    } catch (const YAML::BadFile &e) {
        throw std::runtime_error("读不到配置文件 " + path + ": " + e.what());
    }

    AppConfig c;
    const YAML::Node sys = root["sys"];
    const YAML::Node xf = root["xf"];
    const YAML::Node inp = root["input"];
    if (!sys || !xf || !inp) {
        throw std::runtime_error("配置必须有 sys / xf / input 三节");
    }

    c.sys.run_backend = req<std::string>(sys, "run_backend", "sys");
    if (sys["ip"]) c.sys.ip = sys["ip"].as<std::string>();
    if (sys["npu_addr"]) c.sys.npu_addr = sys["npu_addr"].as<std::string>();
    if (sys["dma_addr"]) c.sys.dma_addr = sys["dma_addr"].as<std::string>();
    if (sys["mmuMode"]) c.sys.mmu_mode = sys["mmuMode"].as<bool>();
    if (sys["profile"]) c.sys.profile = sys["profile"].as<bool>();

    parse_xf(c, xf);

    c.input.mode = req<std::string>(inp, "mode", "input");
    if (c.input.mode != "tcp" && c.input.mode != "file") {
        throw std::runtime_error("input.mode 只能是 tcp 或 file，收到 " + c.input.mode);
    }
    if (inp["bind"]) c.input.bind_addr = inp["bind"].as<std::string>();
    if (inp["port"]) c.input.port = inp["port"].as<int>();
    if (inp["file"]) c.input.file = inp["file"].as<std::string>();
    if (inp["topk"]) c.input.topk = inp["topk"].as<int>();
    if (inp["print_every"]) c.input.print_every = inp["print_every"].as<int>();
    if (inp["signal_min_std"]) c.input.signal_min_std = inp["signal_min_std"].as<float>();
    if (inp["skip_nosignal"]) c.input.skip_nosignal = inp["skip_nosignal"].as<bool>();
    if (inp["idle_warn_ms"]) c.input.idle_warn_ms = inp["idle_warn_ms"].as<int>();
    if (inp["eval_dump"]) c.input.eval_dump = inp["eval_dump"].as<std::string>();

    if (c.input.mode == "file" && c.input.file.empty()) {
        throw std::runtime_error("input.mode=file 时必须给 input.file");
    }
    if (c.input.topk <= 0 || c.input.topk > c.xf.num_classes) {
        throw std::runtime_error("input.topk 必须在 1..num_classes 之间");
    }

    // ---- 运行模式（缺省 fusion；上位机的控制帧可以随时改）----
    if (root["runtime"] && root["runtime"]["mode"]) {
        c.mode = parse_run_mode(root["runtime"]["mode"].as<std::string>(), "runtime");
    }

    // ---- PL 侧（缺省整个 pl: 节 = 关闭）----
    if (root["pl"]) parse_pl(c, root["pl"]);

    // ---- 融合权重 ----
    if (root["fusion"]) {
        const YAML::Node f = root["fusion"];
        if (f["pl_weight"]) c.pl_weight = f["pl_weight"].as<float>();
        if (f["w3_xf"]) c.w3_xf = f["w3_xf"].as<float>();
        if (f["w3_pl"]) c.w3_pl = f["w3_pl"].as<float>();
        if (f["w3_ex"]) c.w3_ex = f["w3_ex"].as<float>();
    }
    if (!std::isfinite(c.pl_weight) || c.pl_weight < 0.0f || c.pl_weight > 1.0f) {
        throw std::runtime_error("fusion.pl_weight 必须在 0..1 之间");
    }
    for (float w : {c.w3_xf, c.w3_pl, c.w3_ex}) {
        if (!std::isfinite(w) || w < 0.0f) {
            throw std::runtime_error("fusion.w3_xf / w3_pl / w3_ex 必须是 0..1 的有限数");
        }
    }
    if (!(c.w3_xf + c.w3_pl + c.w3_ex > 0.0f)) {
        throw std::runtime_error("fusion.w3_xf + w3_pl + w3_ex 必须为正");
    }

    // ---- 交叉校验 ----
    if (!c.xf.enable && !c.pl.enable) {
        throw std::runtime_error("xf.enable 和 pl.enable 不能同时为 false");
    }
    if (c.pl.enable) {
        // PL 头固定 20 类、256 点；融合按同一个 n 读两路概率，不能各说各话。
        if (c.xf.num_classes != 20) {
            throw std::runtime_error("PL 固定 20 类，xf.num_classes 必须是 20（当前 " +
                                     std::to_string(c.xf.num_classes) + "）");
        }
        if (c.xf.seg_len != 256) {
            throw std::runtime_error("PL 固定 256 点/帧，xf.seg_len 必须是 256（当前 " +
                                     std::to_string(c.xf.seg_len) + "）");
        }
        for (int s : c.pl.tta_shifts) {
            if (s <= -c.xf.seg_len || s >= c.xf.seg_len) {
                throw std::runtime_error("pl.tta_shifts 里的 " + std::to_string(s) +
                                         " 超出 (-seg_len, seg_len)");
            }
        }
    }
    if (c.xf.enable) {
        if (!c.pl.enable) {
            throw std::runtime_error(
                "xf.enable=true 需要 pl.enable=true —— XF 的输入是 dma2 的均衡输出");
        }
        if (!c.pl.eq_enable) {
            throw std::runtime_error(
                "xf.enable=true 需要 pl.eq_enable=true —— XF 的输入是 dma2 的均衡输出");
        }
    }
    if (c.mode == RunMode::Fast && !c.xf.enable) {
        throw std::runtime_error("runtime.mode=fast 需要 xf.enable=true（快速模式只跑 XF）");
    }
    return c;
}

// 类别名：第 k 行 == 类别 k。来源是 data_cache_20cls*/meta.npz 的 class_names，
// 由 tools/export_class_names.py 导出。缺文件不算错误，退回打印裸下标。
inline std::vector<std::string> load_class_names(const std::string &path) {
    std::vector<std::string> names;
    std::ifstream f(path);
    if (!f) return names;
    std::string line;
    while (std::getline(f, line)) {
        while (!line.empty() && (line.back() == '\r' || line.back() == '\n' || line.back() == ' ')) {
            line.pop_back();
        }
        if (!line.empty()) names.push_back(line);
    }
    return names;
}

}  // namespace rffi
