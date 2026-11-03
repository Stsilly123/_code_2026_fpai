"""读板端逐帧导出（input.eval_dump），量 INT8 下三路融合到底多少。

板端每帧写一段定长记录：seq / label / 可用标志 + XF 概率 20 + PL 概率 20 +
专家特征 193。本脚本：
  1) 直接报板端 INT8 的单路 / 两路 / 三路准确率；
  2) 用导出的 193 维特征在 PC 上跑专家 MLP（训练侧 checkpoint，fp32；
     现行 checkpoint 只吃其中 165 维，跳过 const 组）；
  3) 用同一批样本的训练侧 fp32 cache 做对照（fold2 XF / PL / EX），
     直接给出「INT8 - fp32」的融合差；
  4) 顺带核专家特征：板端 dump 的 193 维和训练侧 cache 的逐维相关。

用法::

    python tools/fuse_board_eval.py --dump eval_int8.bin \\
        --manifest samples/manifest.json

权重口径与训练侧一致：两路 w_pl=1/3；三路 (XF 0.6, PL 0.2, EX 0.2)。
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import numpy as np

_APP = Path(__file__).resolve().parents[1]
_TT = _APP.parent / "Transformer_Train"

# 训练侧参考（同一批 12879 条 test）
REF_XF = _TT / "outputs/diag/xf_folds_val_test_tta.npz"
REF_PL = _TT / "outputs/diag/pl_base_tta_pool.npz"
REF_EX = _TT / "outputs/diag/expert_logits_rtl_noconst_20cls.npz"
REF_FEAT = _TT / "outputs/diag/expert_feats_probe_20cls.npz"
CKPT = _TT / "checkpoints/expert_mlp_rtl_noconst_20cls.pt"
FEAT_KEYS = ("fft", "wavelet", "const", "cumulant", "cfo", "power")

# PL 的 193 维布局；checkpoint 的 groups 是它的子集（现行版本去掉 const）
FULL_LAYOUT = (("fft", 128), ("wavelet", 10), ("const", 28),
               ("cumulant", 12), ("cfo", 9), ("power", 6))

FLAG_XF, FLAG_PL, FLAG_EQ, FLAG_EX = 1, 2, 4, 8


def read_dump(path: str):
    with open(path, "rb") as f:
        hdr = np.fromfile(f, dtype="<u4", count=4)
        if hdr.size != 4 or hdr[0] != 0x56454652:
            raise SystemExit(f"{path} 不是 eval_dump 文件（magic={hdr[:1]}）")
        _, ver, ncls, nexp = (int(x) for x in hdr)
        if ver != 1:
            raise SystemExit(f"不认识的导出版本 {ver}")
        rec = 4 + 2 * ncls + nexp
        a = np.fromfile(f, dtype="<u4", count=-1)
    if a.size % rec:
        raise SystemExit(f"记录长度不整：{a.size} 个字，不是 {rec} 的整数倍")
    a = a.reshape(-1, rec)
    return {
        "seq": a[:, 0].astype(np.int64),
        "label": a[:, 1].view(np.int32).astype(np.int64),
        "flags": a[:, 2],
        "xf": a[:, 4:4 + ncls].view(np.float32),
        "pl": a[:, 4 + ncls:4 + 2 * ncls].view(np.float32),
        "ex": a[:, 4 + 2 * ncls:].view(np.float32),
        "ncls": ncls,
        "nexp": nexp,
    }


def logp(p: np.ndarray) -> np.ndarray:
    l = np.log(np.maximum(p.astype(np.float64), 1e-12))
    l -= l.max(1, keepdims=True)
    return l - np.log(np.exp(l).sum(1, keepdims=True))


def acc(lp: np.ndarray, y: np.ndarray) -> float:
    return float((lp.argmax(1) == y).mean())


def expert_logp_from_feats(feats: np.ndarray) -> np.ndarray:
    """训练侧 checkpoint（fp32 MLP）+ 它的 mu/sd；输入是 PL 的 193 维物理特征。"""
    import torch
    from torch import nn

    ck = torch.load(str(CKPT), map_location="cpu", weights_only=False)
    sd = ck["state_dict"]

    # 按 checkpoint 的 groups 从 193 维里取子集（现行版本是 165 维，跳过 const）
    off, cols = 0, []
    for name, w in FULL_LAYOUT:
        if name in ck["groups"]:
            cols.append(np.arange(off, off + w))
        off += w
    feats = feats[:, np.concatenate(cols)]

    hidden = int(ck.get("hidden", 256))
    n_cls = int(ck.get("n_cls", 20))
    model = nn.Sequential(
        nn.Linear(feats.shape[1], hidden), nn.GELU(),
        nn.Linear(hidden, hidden // 2), nn.GELU(),
        nn.Linear(hidden // 2, n_cls),
    )
    if sd and all(k.startswith("net.") for k in sd):
        sd = {k[len("net."):]: v for k, v in sd.items()}
    model.load_state_dict(sd)
    model.eval()
    xn = ((feats.astype(np.float64) - ck["mu"]) / ck["sd"]).astype(np.float32)
    with torch.no_grad():
        logits = model(torch.from_numpy(xn)).numpy()
    logits -= logits.max(1, keepdims=True)
    p = np.exp(logits)
    p /= p.sum(1, keepdims=True)
    return logp(p)


def reference(idx: np.ndarray, y: np.ndarray):
    """训练侧 fp32 参考，按 idx 对齐到板端这条样本序列。"""
    out = {}
    try:
        z = np.load(REF_XF)
        zidx = z["idx_test"]
        fold = 2  # 板端跑的就是 fold2_b5_ZG
        pos = {int(v): i for i, v in enumerate(zidx)}
        rows = [pos[int(v)] for v in idx]
        out["xf"] = logp(z["probs_test"][fold][rows])
    except Exception as e:  # noqa: BLE001
        print(f"  [warn] fp32 XF 参考不可用: {e}")
    try:
        z = np.load(REF_PL)
        pos = {int(v): i for i, v in enumerate(z["test_idx"])}
        out["pl"] = logp(np.exp(z["test_z"][[pos[int(v)] for v in idx]]))
    except Exception as e:  # noqa: BLE001
        print(f"  [warn] fp32 PL 参考不可用: {e}")
    try:
        z = np.load(REF_EX)
        pos = {int(v): i for i, v in enumerate(z["test_idx"])}
        out["ex"] = z["test_logp"][[pos[int(v)] for v in idx]].astype(np.float64)
    except Exception as e:  # noqa: BLE001
        print(f"  [warn] fp32 EX 参考不可用: {e}")
    return out


def report(name: str, lp_xf, lp_pl, lp_ex, y: np.ndarray, mask: np.ndarray | None = None):
    """在 mask（三路都可用）上算单路 / 两路 / 三路。"""
    if mask is not None:
        y = y[mask]
        lp_xf = lp_xf[mask]
        lp_pl = lp_pl[mask]
        lp_ex = None if lp_ex is None else lp_ex[mask]
    a_xf, a_pl = acc(lp_xf, y), acc(lp_pl, y)
    a_2 = acc((1.0 - 1.0 / 3.0) * lp_xf + (1.0 / 3.0) * lp_pl, y)
    line = (f"{name}: n={len(y)}  XF={a_xf:.4f}  PL={a_pl:.4f}  "
            f"两路 w=1/3 = {a_2:.4f} ({a_2 - max(a_xf, a_pl):+.4f} vs 单路最好)")
    if lp_ex is not None:
        a_ex = acc(lp_ex, y)
        a_3 = acc(0.6 * lp_xf + 0.2 * lp_pl + 0.2 * lp_ex, y)
        line += (f"  EX={a_ex:.4f}  三路 0.6/0.2/0.2 = {a_3:.4f}"
                 f"（专家边际 {a_3 - a_2:+.4f}，三路−单折XFsolo {a_3 - a_xf:+.4f}）")
    print(line)
    return a_2


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    ap = argparse.ArgumentParser()
    ap.add_argument("--dump", required=True)
    ap.add_argument("--manifest", default=str(_APP / "samples" / "manifest.json"))
    ap.add_argument("--no-ref", action="store_true", help="不算训练侧 fp32 对照")
    args = ap.parse_args()

    d = read_dump(args.dump)
    n = len(d["label"])
    man = json.loads(Path(args.manifest).read_text(encoding="utf-8"))
    idx = np.asarray(man["idx"], dtype=np.int64)
    if idx.shape[0] != n:
        raise SystemExit(f"帧数不对：dump {n} 帧，manifest {idx.shape[0]} 条")
    if not np.array_equal(np.asarray(man["labels"], dtype=np.int64), d["label"]):
        raise SystemExit("manifest 标签和 dump 里的 label 不一致（帧流和 manifest 不是同一次）")
    y = d["label"]
    nxf = int((d["flags"] & FLAG_XF).astype(bool).sum())
    npl = int((d["flags"] & FLAG_PL).astype(bool).sum())
    nex = int((d["flags"] & FLAG_EX).astype(bool).sum())
    neq = int((d["flags"] & FLAG_EQ).astype(bool).sum())
    print(f"板端导出 {n} 帧：XF 可用 {nxf}  PL 可用 {npl}  eq 可用 {neq}  专家可用 {nex}")

    ok_xf = (d["flags"] & FLAG_XF).astype(bool)
    ok_pl = (d["flags"] & FLAG_PL).astype(bool)
    ok_ex = (d["flags"] & FLAG_EX).astype(bool)
    lp_xf = logp(np.where(ok_xf[:, None], d["xf"], 1e-12))
    lp_pl = logp(np.where(ok_pl[:, None], d["pl"], 1e-12))
    lp_ex = expert_logp_from_feats(np.where(ok_ex[:, None], d["ex"], 0.0))

    all_ok = ok_xf & ok_pl & ok_ex
    print()
    print("== 板端 INT8（专家 MLP 在 PC 上用训练侧 fp32 权重跑）==")
    report("全部帧(缺分支按错计)", lp_xf, lp_pl, lp_ex, y, None)
    report("三路齐全帧", lp_xf, lp_pl, lp_ex, y, all_ok)

    if args.no_ref:
        return
    print()
    print("== 训练侧 fp32 对照（同一批样本）==")
    ref = reference(idx, y)
    if {"xf", "pl", "ex"} <= ref.keys():
        report("fp32", ref["xf"], ref["pl"], ref["ex"], y, all_ok)
        # 逐样本比较两路融合的对错
        a_i8 = (0.6 * lp_xf + 0.2 * lp_pl + 0.2 * lp_ex)[all_ok].argmax(1)
        a_fp = (0.6 * ref["xf"] + 0.2 * ref["pl"] + 0.2 * ref["ex"])[all_ok].argmax(1)
        yy = y[all_ok]
        print(f"  三路 argmax 一致率 {np.mean(a_i8 == a_fp):.4f}"
              f"  INT8 对/fp32 错 {np.sum((a_i8 == yy) & (a_fp != yy))}"
              f"  INT8 错/fp32 对 {np.sum((a_i8 != yy) & (a_fp == yy))}")

    # 专家特征通道自检：板端 dump 的 193 维 vs 训练侧 cache
    try:
        fz = np.load(REF_FEAT)
        ref_feat = np.concatenate([fz[k] for k in FEAT_KEYS], 1)
        rows = idx[ok_ex]
        a = d["ex"][ok_ex].astype(np.float64)
        b = ref_feat[rows].astype(np.float64)
        r = np.array([np.corrcoef(a[:, j], b[:, j])[0, 1] for j in range(a.shape[1])])
        r = np.nan_to_num(r)
        print()
        print(f"专家特征 vs 训练侧 cache（{len(rows)} 帧，193 维）："
              f"逐维相关 中位数 {np.median(r):.4f}  p10 {np.percentile(r, 10):.4f}  "
              f"r>0.99 的维度 {int((r > 0.99).sum())}/193")
        bad = np.where(r < 0.9)[0]
        if bad.size:
            print(f"  相关系数 <0.9 的维度：{bad[:20].tolist()}"
                  f"{' …' if bad.size > 20 else ''}")
        print(f"  前 8 维（板端 / cache）: "
              + "  ".join(f"{a[0, j]:.4g}/{b[0, j]:.4g}" for j in range(8)))
    except Exception as e:  # noqa: BLE001
        print(f"[warn] 专家特征自检跳过: {e}")


if __name__ == "__main__":
    main()
