"""对拍：板子上的 argmax vs PyTorch fp32 —— 判「部署链是通的」的唯一硬证据。

板子的控制台日志就是输入。解析出每帧的 top1，和 PyTorch 在同一批 idx 上的 argmax 比：

    ./transformer_4_rf/Scripts/python.exe tools/send_iq.py --host <板子IP> --n 256 \
        | tee samples/board.log
    ./transformer_4_rf/Scripts/python.exe tools/check_roundtrip.py --board-log samples/board.log

三个读数的判读（主机上已实测，见 Transformer_Train/icraft_work/README.md）：

| 读数 | 期望 | 差了说明 |
|---|---|---|
| 板子 top1 vs PyTorch top1 | 62.11% vs 62.50% | 定点量化本身的代价，正常 |
| argmax 一致率 | **≈ 87.50%** | 掉到随机水平（≈1%）⇒ 预处理/布局/字节序错了 |
| 余弦相似度 | ≈ 0.98 | —— |

**期望的不是 100%。** 主机上 INT8 与 fp32 的 argmax 一致率本来就只有 87.5%，
所以板子对到 ~87% 才算对；对到 100% 反而要怀疑是不是拿了同一份结果在比。
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

import numpy as np

_APP = Path(__file__).resolve().parents[1]
_TT = _APP.parent / "Transformer_Train"

# 匹配 main.cpp 里那行：seq {:>7}  top1 = {名字}  p={概率} ...
_LINE = re.compile(r"^seq\s+(\d+)\s+top1\s*=\s*(\S+)\s+p=([0-9.]+)")
_SUMMARY = re.compile(r"top1\s*=\s*([0-9.]+)%")

# 主机实测锚点
_ANCHOR_ACC_TORCH = 62.50
_ANCHOR_ACC_INT8 = 62.11
_ANCHOR_AGREE = 87.50


def parse_board_log(path: Path) -> tuple[dict[int, int], float | None]:
    names = [ln.strip() for ln in (Path(_APP) / "names" / "class_names.txt")
             .read_text(encoding="utf-8").splitlines() if ln.strip()]
    if not names:
        raise SystemExit("先用 tools/export_class_names.py 生成 names/class_names.txt")
    name2idx = {n: i for i, n in enumerate(names)}

    preds: dict[int, int] = {}
    board_acc: float | None = None
    unknown: list[str] = []
    for raw in path.read_text(encoding="utf-8", errors="replace").splitlines():
        m = _LINE.match(raw.strip())
        if m:
            seq, nm = int(m.group(1)), m.group(2)
            if nm in name2idx:
                preds[seq] = name2idx[nm]
            else:
                unknown.append(nm)
            continue
        s = _SUMMARY.search(raw)
        if s and "top1" in raw:
            board_acc = float(s.group(1))
    if unknown:
        print(f"警告：日志里有 {len(unknown)} 行的类别名认不出来，例如 {unknown[:3]}")
    return preds, board_acc


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    ap = argparse.ArgumentParser(description="板子 argmax vs PyTorch fp32")
    ap.add_argument("--board-log", required=True)
    ap.add_argument("--manifest", default=str(_APP / "samples" / "manifest.json"))
    ap.add_argument("--transformer-train", default=str(_TT))
    ap.add_argument("--config", default="configs/exp_wide_ls.yaml")
    ap.add_argument("--ckpt", default=None)
    args = ap.parse_args()

    tt = Path(args.transformer_train).resolve()
    sys.path.insert(0, str(tt))

    import torch  # noqa: E402

    from src.data.dataset import IQDataset, build_norm  # noqa: E402
    from src.data.manifest import DatasetMeta  # noqa: E402
    from src.models.factory import build_model, load_state  # noqa: E402
    from src.utils.common import load_config  # noqa: E402

    man = json.loads(Path(args.manifest).read_text(encoding="utf-8"))
    idx = np.asarray(man["idx"], dtype=np.int64)
    labels = np.asarray(man["labels"], dtype=np.int64)

    preds, board_acc = parse_board_log(Path(args.board_log))
    if not preds:
        raise SystemExit(f"{args.board_log} 里没解析出任何 top1 行 —— 板子跑了吗？")

    # 按 seq 对齐到 idx 的顺序（send_iq.py 用 i 当 seq，所以 seq k 就是 idx[k]）
    seqs = sorted(preds)
    missing = [i for i in range(len(idx)) if i not in preds]
    if missing:
        print(f"警告：清单里有 {len(missing)} 帧板子没打印，例如 seq {missing[:5]}")
    keep = np.asarray([s for s in seqs if s < len(idx)], dtype=np.int64)
    board_pred = np.asarray([preds[int(s)] for s in keep], dtype=np.int64)
    idx_k = idx[keep]
    y_k = labels[keep]

    cfg = load_config(str(tt / args.config))
    cache = tt / cfg["data"]["cache_dir"]
    meta = DatasetMeta.load(cache / "meta.npz")
    ckpt = Path(args.ckpt) if args.ckpt else tt / "checkpoints" / cfg["project"]["name"] / "best.pt"

    ds = IQDataset(segs_path=cache / "segs.npy", labels=meta.labels[idx_k], indices=idx_k,
                   norm=build_norm(str(cfg["data"].get("normalize", "per_sample"))),
                   in_channels=int(cfg["model"].get("in_channels", 2)))
    X = torch.stack([ds[i][0] for i in range(len(ds))])

    model = build_model(cfg, num_classes=int(meta.num_classes), seg_len=int(meta.seg_len))
    load_state(model, torch.load(ckpt, map_location="cpu", weights_only=False)["model"])
    model.eval()
    with torch.no_grad():
        ref = model(X).numpy()

    torch_pred = ref.argmax(1)
    acc_board = float((board_pred == y_k).mean()) * 100
    acc_torch = float((torch_pred == y_k).mean()) * 100
    agree = float((board_pred == torch_pred).mean()) * 100

    print(f"样本 {len(keep)} 条（{args.config}，logits 来自 {ckpt.name}）")
    print()
    print(f"{'':<26}{'top1':>10}{'  (主机锚点)':>14}")
    print(f"{'PyTorch fp32':<26}{acc_torch:9.2f}%{_ANCHOR_ACC_TORCH:13.2f}%")
    print(f"{'板子（INT8 硬件）':<26}{acc_board:9.2f}%{_ANCHOR_ACC_INT8:13.2f}%")
    print(f"{'Δ':<26}{acc_board - acc_torch:+9.2f}")
    if board_acc is not None:
        print(f"{'（板子自报的 top1）':<26}{board_acc:9.2f}%")
    print()
    print(f"{'argmax 一致率（板子 vs fp32）':<26}{agree:9.2f}%{_ANCHOR_AGREE:13.2f}%")

    if agree < 30.0:
        print()
        print("一致率塌到随机水平附近 —— 不是量化误差，是链路错了。按顺序查：")
        print("  1. 预处理：tools/check_preprocess.py（反交错 / 通道优先 / eps）")
        print("  2. 载荷是不是发之前就被归一化过（双重归一化）")
        print("  3. 字节序：协议要求小端，int16 别用网络序")
        print("  4. 类别名与类别下标的对应（names/class_names.txt 和 meta.npz 同源吗）")
        raise SystemExit(1)
    print("\n链路通。")


if __name__ == "__main__":
    main()
