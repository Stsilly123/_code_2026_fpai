"""上位机侧：从 data_cache 抽一批真实 test 段，按 rffi_deploy 的线格式发过去。

板子做服务端，本脚本是客户端。同一份代码既能走网口（`--host`），也能只写一个
帧流文件（`--dump-frames`）给板端的 `input.mode: file` 用 —— 上板第一件事就是用
后者把网络变量摘掉。

**发的是原始未归一化的 IQ**（与 `segs.npy` 同量纲）。归一化由板子做。这一条是
本协议最容易搞错的点：发之前归一化过 = 双重归一化，不报错，只掉精度。

抽样口径与 `Transformer_Train/scripts/icraft_verify.py` 完全一致（split 内等间隔
linspace），所以主机上量到的 **62.11%** 可以直接拿来对。

用法::

    # 网口：板子先跑 ./rffi_deploy configs/rffi_transformer.yaml
    ./transformer_4_rf/Scripts/python.exe tools/send_iq.py --host 192.168.1.50 --n 256

    # 只写帧流文件（板端 input.mode: file）
    ./transformer_4_rf/Scripts/python.exe tools/send_iq.py --n 32 --dump-frames samples/frames.bin
"""

from __future__ import annotations

import argparse
import json
import socket
import struct
import sys
import time
from pathlib import Path

import numpy as np

_APP = Path(__file__).resolve().parents[1]
_TT = _APP.parent / "Transformer_Train"

MAGIC = 0x51494652
VERSION = 1
DTYPE_F32, DTYPE_I16 = 0, 1
LABEL_UNKNOWN = -1

# '<' 关掉对齐填充；字段顺序与 src/iq_frame.hpp::IqFrameHeader 逐字对应。
_HDR = struct.Struct("<IHHiIIfQ")
assert _HDR.size == 32, f"帧头 {_HDR.size} 字节，应该是 32"


def pick_indices(pool: np.ndarray, n: int) -> np.ndarray:
    """与 scripts/icraft_verify.py 同一套等间隔抽样，让两边的样本集可比。"""
    if n > pool.shape[0]:
        raise SystemExit(f"要 {n} 条，但划分里只有 {pool.shape[0]} 条")
    pick = np.linspace(0, pool.shape[0] - 1, num=n).round().astype(np.int64)
    if np.unique(pick).shape[0] != n:
        raise SystemExit("等间隔取样出现重复下标，请调整 --n")
    return pool[pick]


def encode(seg: np.ndarray, seq: int, label: int, dtype: int, scale: float) -> bytes:
    """seg: (256, 2) float32，末维 (I,Q)。

    线上按 I,Q 交错发 —— (256,2) 的 C 序展平天然就是这个顺序。
    """
    n = seg.shape[0]
    if dtype == DTYPE_F32:
        payload = np.ascontiguousarray(seg, dtype="<f4").tobytes()
        vscale = 0.0
    else:
        q = np.rint(seg.astype(np.float64) / scale)
        q = np.clip(q, -32768, 32767).astype("<i2")
        payload = np.ascontiguousarray(q).tobytes()
        vscale = float(scale)
    hdr = _HDR.pack(MAGIC, VERSION, dtype, label, seq, n, vscale,
                    time.time_ns())
    return hdr + payload


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    ap = argparse.ArgumentParser(description="按 rffi_deploy 线格式发送 IQ 帧")
    ap.add_argument("--split", default="test", help="train | val | test（默认 test）")
    ap.add_argument("--n", type=int, default=256, help="发多少帧")
    ap.add_argument("--host", default=None, help="板子 IP；不给就只写/只统计不发")
    ap.add_argument("--port", type=int, default=9527)
    ap.add_argument("--dtype", choices=["f32", "i16"], default="f32",
                    help="f32 精确（2048B/帧）；i16 更小（1024B/帧），靠 value_scale 还原")
    ap.add_argument("--scale", type=float, default=1.0 / 1024,
                    help="i16 的还原系数：真值 = raw * scale")
    ap.add_argument("--pace", type=float, default=0.0, help="每帧间隔秒数，0=全速")
    ap.add_argument("--dump-frames", default=None,
                    help="把这批帧写成一个帧流文件（不连网），供板端 input.mode=file")
    ap.add_argument("--idx-from", default=None,
                    help="直接发 npz 里给的行下标（PATH:KEY，如 .../expert_logits_*.npz:test_idx），"
                         "覆盖 --split/--n —— 这样板端跑的就是训练侧报数用的那一批样本")
    ap.add_argument("--no-label", action="store_true",
                    help="label 一律填 -1（模拟真实接收机；板端就不统计准确率）")
    # 默认必须是 20 类 cache：PL/XF 都是 20 类，拿 150 类 cache 的标签去比
    # 只会得到 0%（旧的 samples/frames.bin 就是这么来的）。
    ap.add_argument("--segs", default=str(_TT / "data_cache_20cls" / "segs.npy"))
    ap.add_argument("--split-npz", default=str(_TT / "data_cache_20cls" / "split.npz"))
    ap.add_argument("--meta", default=str(_TT / "data_cache_20cls" / "meta.npz"))
    ap.add_argument("--manifest", default=str(_APP / "samples" / "manifest.json"),
                    help="记下这次发的 idx/label，供 check_roundtrip.py 对拍")
    args = ap.parse_args()

    segs_path = Path(args.segs)
    for p in (segs_path, Path(args.split_npz), Path(args.meta)):
        if not p.exists():
            raise SystemExit(f"找不到 {p}")

    if args.idx_from:
        # 只取行下标，不关心它是哪个 cache 的哪一段 —— 调用方保证下标对本 cache 有效。
        npz_path, _, key = args.idx_from.rpartition(":")
        if not npz_path or not key:
            raise SystemExit("--idx-from 要写成 PATH:KEY")
        idx = np.asarray(np.load(npz_path)[key], dtype=np.int64)
        if idx.ndim != 1:
            raise SystemExit(f"--idx-from 的 {key} 必须是 1 维，收到 {idx.shape}")
        if idx.min() < 0 or idx.max() >= np.load(args.meta, allow_pickle=True)["labels"].shape[0]:
            raise SystemExit(f"--idx-from 的下标越界（本 cache 只有 "
                             f"{np.load(args.meta, allow_pickle=True)['labels'].shape[0]} 条）")
        args.n = int(idx.shape[0])
        print(f"样本集来自 {npz_path}:{key}，共 {args.n} 条")
    else:
        split = np.load(args.split_npz)
        if args.split not in split:
            raise SystemExit(f"split.npz 里没有 '{args.split}'，只有 {sorted(split)}")
        idx = pick_indices(np.asarray(split[args.split], dtype=np.int64), args.n)
    labels = np.load(args.meta, allow_pickle=True)["labels"][idx].astype(np.int64)

    # mmap：只读抽中的那几行，不把 2 GB 全拉进内存。
    segs = np.load(segs_path, mmap_mode="r")
    dtype = DTYPE_F32 if args.dtype == "f32" else DTYPE_I16

    how = f"按 {args.idx_from} 取" if args.idx_from else f"{args.split} 等间隔抽"
    print(f"{how} {args.n} 条样本 -> {'i16' if dtype else 'f32'}")
    print(f"  首个下标 {int(idx[0])}  首个标签 {int(labels[0])}"
          f"（类别名见 names/class_names.txt）")

    out = None
    sock = None
    try:
        if args.dump_frames:
            out = open(args.dump_frames, "wb")
            print(f"  写帧流 {args.dump_frames}")
        elif args.host:
            sock = socket.create_connection((args.host, args.port), timeout=10.0)
            print(f"  连上 {args.host}:{args.port}")
        else:
            print("  既没给 --host 也没给 --dump-frames：只做抽样统计，不发")

        t0 = time.time()
        for i in range(args.n):
            seg = np.asarray(segs[int(idx[i])], dtype=np.float32)
            if seg.shape != (256, 2):
                raise SystemExit(f"第 {i} 条 segs 形状 {seg.shape}，期望 (256, 2)")
            if i == 0:
                # 这行是给板端自检对表的：两边打印的 mean/std 必须一样。
                print(f"  首帧校验 mean={seg.mean():.6f} std={seg.std():.6f}")
            label = LABEL_UNKNOWN if args.no_label else int(labels[i])
            pkt = encode(seg, i, label, dtype, args.scale)
            if out is not None:
                out.write(pkt)
            elif sock is not None:
                sock.sendall(pkt)
            else:
                # 不发也要把编码跑一遍，至少验证形状/字节数
                assert len(pkt) == 32 + 256 * 2 * (4 if dtype == DTYPE_F32 else 2)
            if args.pace > 0:
                time.sleep(args.pace)
            if (i + 1) % 64 == 0 or i + 1 == args.n:
                print(f"  {i + 1}/{args.n}  ({time.time() - t0:.1f}s)")

        if sock is not None:
            # 半关写侧，让板子的 recv 干净地返回，好走完汇总那一段。
            try:
                sock.shutdown(socket.SHUT_WR)
            except OSError:
                pass
    finally:
        if out is not None:
            out.close()
        if sock is not None:
            sock.close()

    if args.manifest:
        mp = Path(args.manifest)
        mp.parent.mkdir(parents=True, exist_ok=True)
        mp.write_text(json.dumps({
            "split": args.split, "n": args.n, "dtype": args.dtype, "scale": args.scale,
            "segs": str(segs_path), "labels_unknown": bool(args.no_label),
            "idx_from": args.idx_from,
            "idx": [int(x) for x in idx],
            "labels": [int(x) for x in labels],
        }, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"写到 {mp}")


if __name__ == "__main__":
    main()
