// XF（均衡 Transformer）集成的纯数据类型，不依赖 iCraft 头。
//
// 放在这里是为了让 config.hpp 能解析配置、让 preprocess_check 之类的离线工具
// 也能 include，而不用把整个 iCraft SDK 拖进来。
#pragma once

#include <string>
#include <vector>

namespace rffi {

struct XfModelPath {
    std::string json;
    std::string raw;
};

struct XfConfig {
    bool enable = true;
    bool required = true;                 // 打不开就退出（true）还是退回 PL（false）
    std::vector<XfModelPath> models;      // 五折 = 5 个 _ZG.json/.raw
    std::string names;                    // 类别名文件（第 k 行 = 类别 k）
    int seg_len = 256;                    // 与图输入 [1,2,256] 对齐
    int num_classes = 20;
    // 圆周平移 TTA。与 Transformer_Train/scripts/collect_xf_folds_tta.py 的 SHIFTS 一致。
    std::vector<int> shifts{-2, -1, 0, 1, 2};
    // 板上实测 session.forward() 「迟一拍」：write 后第一次 forward 算的是上一次
    // write 的数据。true 时每个输入连打两枪、取第二枪（耗时 ×2）。reset_mode
    // 非 off 时不需要它。
    bool double_forward = false;
    // device.reset(1) 的时机（demo 在 waitForReady 之后、读输出之前调）：
    //   fold  —— 每次前向后都 reset，最贴 demo 的单次推理写法；
    //   frame —— 25 次前向全部做完后 reset 一次；
    //   off   —— 不 reset。
    std::string reset_mode = "fold";
    // 折 × 平移 次前向必须全部成功才认这一帧的 XF 结果。false 时按成功次数平均。
    bool require_all = true;
    // >0 = 五折合成的一张图：models 只能有 1 项，图输入 batch 必须是
    // fused_folds * shifts.size()，行序 fold 主序（row = fold * S + shift）。
    // 一帧只调一次 forward。0 = 老口径：一个模型一折，按图 batch 选路。
    int fused_folds = 0;
};

struct XfResult {
    bool ok = false;
    std::string error;
    std::vector<float> probs;             // num_classes 个概率（折 × 平移平均）
    double infer_ms = 0.0;
    int contributions = 0;                // 成功的前向次数（折 × 平移）
    int expected = 0;
    int folds_ok = 0;                     // 五折里有多少折的所有平移都成功
    int shifts_ok = 0;                    // 平移里有多少个所有折都成功
    // 单折视角（诊断用）：每折只平均它自己的平移（不是五折平均）。
    // 大小 = folds_ok 的分母；某折一次都没成功时 argmax 记 -1。
    std::vector<int> fold_argmax;         // 每折 top1 类别下标
    std::vector<float> fold_prob;         // 每折 top1 概率（该折各平移平均后）
};

}  // namespace rffi
