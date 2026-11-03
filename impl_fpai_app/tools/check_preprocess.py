"""离线核对 `src/preprocess.hpp` —— **不需要板子**。

三条独立路径过同一批数据，然后对答案：

    send_iq.py   抽 segs[idx] -> 编码成帧流 frames.bin
    preprocess_check  （C++）解帧 -> deinterleave_normalize -> out.raw
    check_preprocess.py  IQDataset（训练时真正用的那条路）-> ref

只要 C++ 的反交错顺序或 PerSampleNorm 写错一点（比如漏了 +1e-6、I/Q 没转置成通道
优先、mean 按通道分开算），这里就会炸。这几种错**都不会报错**，只会让上板后的
准确率莫名下降，所以值得在碰板子之前先把它钉死。

用法::

    ./transformer_4_rf/Scripts/python.exe tools/send_iq.py --n 32 --dump-frames samples/frames.bin
    ./build/preprocess_check samples/frames.bin samples/preprocess.raw
    ./transformer_4_rf/Scripts/python.exe tools/check_preprocess.py \\
        --frames samples/frames.bin --raw samples/preprocess.raw
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import numpy as np

_APP = Path(__file__).resolve().parents[1]
_TT = _APP.parent / "Transformer_Train"

# 判定阈值。归一化后是 O(1) 量级，两条路的差别只该来自求和顺序（float32 vs double
# 累加），量级 ~1e-7。而量化步长是 0.0337 —— 差到 1e-5 就说明不只是舍入。
_TOL = 1e-5


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    ap = argparse.ArgumentParser(description="核对 C++ 预处理与 IQDataset 是否一致")
    ap.add_argument("--frames", default=str(_APP / "samples" / "frames.bin"))
    ap.add_argument("--raw", default=str(_APP / "samples" / "preprocess.raw"),
                    help="preprocess_check 的输出")
    ap.add_argument("--manifest", default=str(_APP / "samples" / "manifest.json"),
                    help="send_iq.py 写的清单（要里面的 idx）")
    ap.add_argument("--transformer-train", default=str(_TT))
    ap.add_argument("--config", default="configs/exp_wide_ls.yaml")
    ap.add_argument("--tol", type=float, default=_TOL)
    args = ap.parse_args()

    tt = Path(args.transformer_train).resolve()
    if not (tt / args.config).exists():
        raise SystemExit(f"找不到 {tt / args.config}，用 --transformer-train 指过去")
    sys.path.insert(0, str(tt))

    from src.data.dataset import IQDataset, build_norm  # noqa: E402
    from src.data.manifest import DatasetMeta  # noqa: E402
    from src.utils.common import load_config  # noqa: E402

    for p in (Path(args.frames), Path(args.raw), Path(args.manifest)):
        if not p.exists():
            raise SystemExit(f"找不到 {p}")

    cfg = load_config(str(tt / args.config))
    # cfg 里的 cache_dir 是相对 Transformer_Train 的
    cache = tt / cfg["data"]["cache_dir"]
    meta = DatasetMeta.load(cache / "meta.npz")
    idx = np.asarray(json.loads(Path(args.manifest).read_text(encoding="utf-8"))["idx"],
                     dtype=np.int64)

    in_channels = int(cfg["model"].get("in_channels", 2))
    seg_len = int(meta.seg_len)
    # augment 缺省：核对的必须是推理期输入，不是训练期分布。
    ds = IQDataset(segs_path=cache / "segs.npy", labels=meta.labels[idx], indices=idx,
                   norm=build_norm(str(cfg["data"].get("normalize", "per_sample"))),
                   in_channels=in_channels)
    ref = np.stack([ds[i][0].numpy() for i in range(len(ds))])  # (N, 2, seg_len)

    got = np.fromfile(args.raw, dtype=np.float32)
    per_frame = in_channels * seg_len
    if got.size % per_frame != 0:
        raise SystemExit(f"{args.raw} 有 {got.size} 个 float，不是 {per_frame} 的整数倍")
    got = got.reshape(-1, per_frame)

    print(f"参考 {ref.shape}（IQDataset，训练时真正喂给模型的）")
    print(f"实测 {got.shape}（{args.raw}）")
    if got.shape[0] != ref.shape[0]:
        raise SystemExit(f"帧数对不上：C++ 出 {got.shape[0]} 帧，清单里 {ref.shape[0]} 帧")

    a = ref.reshape(got.shape[0], -1).astype(np.float64)
    b = got.astype(np.float64)
    diff = np.abs(a - b)
    print()
    print(f"最大绝对差 {diff.max():.3e}")
    print(f"平均绝对差 {diff.mean():.3e}")
    print(f"逐位相同 {100.0 * (diff == 0).mean():.2f}%")

    # 顺手报一下均值/标准差是否也对得上 —— 这两个数板子启动时会打印，
    # 拿来对表最直观。
    print()
    print(f"{'':>8}{'mean':>14}{'std':>14}")
    print(f"{'IQDataset':>8}{a.mean():14.6f}{a.std():14.6f}")
    print(f"{'C++':>8}{b.mean():14.6f}{b.std():14.6f}")

    if diff.max() > args.tol:
        print()
        print(f"不一致（阈值 {args.tol:.0e}）。先查这三处：")
        print("  1. 反交错方向：载荷是 I0,Q0,I1,Q1…，模型要 [I×256, Q×256]")
        print("  2. mean/std 是整段 512 个值共用一个标量，不是逐通道")
        print("  3. eps：dataset.py 是 1e-6，加减号/量级都不能动")
        raise SystemExit(1)
    print(f"\n一致（阈值 {args.tol:.0e}）")


if __name__ == "__main__":
    main()
