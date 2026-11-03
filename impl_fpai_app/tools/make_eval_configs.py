#!/usr/bin/env python3
"""从 configs/rffi_transformer.yaml 生成四份验收预设。

改主配置后重跑一次即可；生成物只有 fusion.pl_weight / xf.fused_folds / xf.models 三处不同。

    python tools/make_eval_configs.py
"""

from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "configs" / "rffi_transformer.yaml"

OLD_WEIGHT = "  pl_weight: 0.3333333"
OLD_MODELS = (
    "  fused_folds: 0\n"
    "  models:\n"
    "    - json: ./imodel/xf20/fold2_b5_ZG.json\n"
    "      raw:  ./imodel/xf20/fold2_b5_ZG.raw\n"
)

HDR = (
    "# 验收预设：{title}\n"
    "# 运行：./rffi_deploy configs/{name}\n"
    "# 由 configs/rffi_transformer.yaml 派生，只改了 {what}；其余与部署配置一致。\n"
    "# 本文件由 tools/make_eval_configs.py 生成，别手改。\n\n"
)


def write(name: str, title: str, what: str, text: str) -> None:
    (ROOT / "configs" / name).write_text(
        HDR.format(title=title, name=name, what=what) + text, encoding="utf-8"
    )


def main() -> None:
    src = SRC.read_text(encoding="utf-8")
    if src.count(OLD_WEIGHT) != 1 or src.count(OLD_MODELS) != 1:
        raise SystemExit("主配置的 pl_weight / models 段已改动，先更新本脚本里的 OLD_* 片段")

    xf = src.replace(
        OLD_WEIGHT,
        "  # 纯 XF：返回给上位机的 pred/top-k 只由 XF 决定。\n"
        "  # 注意 PL 仍会跑 —— XF 的输入是 PL dma2 的均衡输出，不能关。\n"
        "  pl_weight: 0.0",
    )
    pl = src.replace(
        OLD_WEIGHT,
        "  # 纯 PL：返回给上位机的 pred/top-k 只由 LcwtMLP 决定。\n"
        "  # 注意 XF 仍会跑（融合权重为 1 时它的结果只是被乘 0 丢弃）。\n"
        "  pl_weight: 1.0",
    )
    fold = xf.replace(
        OLD_MODELS,
        "  # 单折验收：只装 fold2 的 batch=5 图（主配置本来就是单折）。\n"
        "  # 图输入 batch=5，shifts 必须保持 5 个；换别的折只改这两行（fold0..4）。\n" + OLD_MODELS,
    )

    # 一次性评测跑：离线帧流 + 逐帧导出（量 INT8 三路融合用）。
    dump = src
    for old, new in (
        ("  mode: tcp             # tcp | file",
         "  mode: file            # tcp | file"),
        ("  file: ./samples/frames.bin", "  file: ./samples/test_fold2_eval.bin"),
        ("  print_every: 1        # 每 N 帧打一行；1 = 全打",
         "  print_every: 500      # 每 N 帧打一行；1 = 全打"),
        ('  eval_dump: ""', "  eval_dump: ./eval_int8.bin"),
    ):
        if dump.count(old) != 1:
            raise SystemExit(f"主配置里这段不再唯一，先更新 make_eval_configs.py：{old!r}")
        dump = dump.replace(old, new)

    # dma3 专家通路的诊断：file 输入 + 每帧把 shift 0 那轮的 8192 B 专家块落盘。
    # xagree<8 时程序自己会打 [EXDBG] 逐槽明细，这份落盘是对照证据。
    diag = src
    for old, new in (
        ("  mode: tcp             # tcp | file",
         "  mode: file            # tcp | file"),
        ('  diag_dump: ""', "  diag_dump: ./expdiag"),
    ):
        if diag.count(old) != 1:
            raise SystemExit(f"主配置里这段不再唯一，先更新 make_eval_configs.py：{old!r}")
        diag = diag.replace(old, new)
    diag0 = diag.replace(
        "  tta_shifts: [-2, -1, 0, 1, 2]",
        "  # 只跑 shift 0：每轮 8 槽都是同一份输入，排除第二轮串流。\n"
        "  tta_shifts: [0]",
    ).replace("  diag_dump: ./expdiag", "  diag_dump: ./expdiag0")
    if "tta_shifts: [0]" not in diag0 or "./expdiag0" not in diag0:
        raise SystemExit("tta_shifts / diag_dump 那两行变了，先更新 make_eval_configs.py")

    write("eval_fusion.yaml", "融合（部署口径，单折 fold2）", "无（原样复制）", src)
    write(
        "eval_int8_dump.yaml",
        "INT8 三路评测导出（file 输入，12879 帧）",
        "input.mode/file/print_every/eval_dump（一次性评测用，不是部署配置）",
        dump,
    )
    write("eval_xf_only.yaml", "纯 XF（单折 fold2 × 平移 TTA）", "fusion.pl_weight: 1/3 -> 0", xf)
    write("eval_pl_only.yaml", "纯 PL（LcwtMLP int8 QAT）", "fusion.pl_weight: 1/3 -> 1", pl)
    write(
        "eval_fold2_only.yaml",
        "单折 XF（fold2）",
        "fusion.pl_weight -> 0",
        fold,
    )
    write(
        "diag_expert.yaml",
        "dma3 专家诊断（部署平移 + 专家块落盘）",
        "input.mode/file -> file + pl.diag_dump",
        diag,
    )
    write(
        "diag_expert_shift0.yaml",
        "dma3 专家诊断（只跑 shift 0）",
        "input.mode -> file、pl.diag_dump、tta_shifts -> [0]",
        diag0,
    )
    print("已生成 7 份预设到 configs/")


if __name__ == "__main__":
    main()
