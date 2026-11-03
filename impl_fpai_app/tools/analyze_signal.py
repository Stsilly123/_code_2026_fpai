"""上位机侧：把板子切到「信号分析模式」，收这一帧的 FFT / 星座 / 专家特征。

分析模式不关心预测对不对，板端每帧回的是**信号本身**：

    raw  : 原始 IQ（I/Q 交错，256 个复点 = 星座图）
    eq   : 均衡后 IQ（均衡后的星座图）
    fft  : |FFT| 幅度，自然顺序（DC 在 0；要 fftshift 由本脚本自己做）
    feat : 专家那一路的 193 维特征（PL 专家模块的输出，Q12 反量化）
    pl/xf/ex : 三路各自的 20 类概率

用法::

    # 板子先跑 ./rffi_deploy configs/rffi_transformer.yaml
    ./transformer_4_rf/Scripts/python.exe tools/analyze_signal.py \
        --host 192.168.1.50 --n 16 --save analysis.npz

    # 不发帧、只把模式切回去
    ... --restore

`--save` 存 npz，键名与上面一致（每帧一行 / 一段）。画图由上位机自己来。
"""

from __future__ import annotations

import argparse
import socket
import struct
import sys
import time
from pathlib import Path

import numpy as np

_APP = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from send_iq import DTYPE_F32, LABEL_UNKNOWN, _HDR, encode, pick_indices  # noqa: E402

MODE_FAST, MODE_FUSION, MODE_ANALYSIS = 0, 1, 2
CMD_SET_MODE = 1

_RES = struct.Struct("<IHHIiifIHHQ")   # IqResultHeader, 40 B
_TOP = struct.Struct("<If")            # IqTopKEntry, 8 B
_CMD = struct.Struct("<Ii")            # IqCommand, 8 B
_ANA = struct.Struct("<IHH8I")         # IqAnalysisHeader, 40 B
ANA_MAGIC, ANA_VERSION = 0x41494652, 1

STATUS_OK, STATUS_ERROR, STATUS_ANALYSIS, STATUS_ACK = 0, 2, 3, 4

F_BLOCKS = (
    (1 << 0, "raw"),
    (1 << 1, "eq"),
    (1 << 2, "fft"),
    (1 << 3, "feat"),
    (1 << 4, "pl"),
    (1 << 5, "xf"),
    (1 << 6, "ex"),
)


def recv_exact(sock: socket.socket, n: int) -> bytes:
    buf = b""
    while len(buf) < n:
        chunk = sock.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("板端关闭了连接")
        buf += chunk
    return buf


def send_command(sock: socket.socket, cmd: int, arg: int, seq: int) -> dict:
    sock.sendall(_HDR.pack(0x51494652, 1, 2, 0, seq, 0, 0.0, time.time_ns())
                 + _CMD.pack(cmd, arg))
    raw = recv_exact(sock, _RES.size)
    (magic, ver, status, rseq, label, pred, prob, lat, k, _res, ts) = _RES.unpack(raw)
    if magic != 0x4F494652 or ver != 2 or rseq != seq:
        raise SystemExit(f"控制 ack 头不对：magic=0x{magic:08X} ver={ver} seq={rseq}")
    if k:
        recv_exact(sock, k * 8)
    return {"status": status, "pred": pred, "label": label, "latency_us": lat}


def read_analysis(sock: socket.socket) -> dict:
    (magic, ver, flags, n_raw, n_eq, n_fft, n_feat, n_pl, n_xf, n_ex,
     _res) = _ANA.unpack(recv_exact(sock, _ANA.size))
    if magic != ANA_MAGIC or ver != ANA_VERSION:
        raise SystemExit(f"分析块头不对：magic=0x{magic:08X} ver={ver}")
    counts = {}
    for bit, name in F_BLOCKS:
        if flags & bit:
            counts[name] = {"raw": n_raw, "eq": n_eq, "fft": n_fft, "feat": n_feat,
                            "pl": n_pl, "xf": n_xf, "ex": n_ex}[name]
        else:
            counts[name] = 0
    total = sum(counts.values())
    buf = np.frombuffer(recv_exact(sock, total * 4), dtype="<f4")
    out, off = {}, 0
    for _bit, name in F_BLOCKS:
        n = counts[name]
        out[name] = buf[off:off + n].copy()
        off += n
    out["fft_src_eq"] = bool(flags & (1 << 7))
    return out


def load_names(path: Path) -> list[str]:
    if not path.exists():
        return []
    return [ln.strip() for ln in path.read_text(encoding="utf-8").splitlines() if ln.strip()]


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    ap = argparse.ArgumentParser(description="切到分析模式，收 FFT/星座/专家特征")
    ap.add_argument("--host", required=True)
    ap.add_argument("--port", type=int, default=9527)
    ap.add_argument("--split", default="test")
    ap.add_argument("--n", type=int, default=16, help="分析多少帧（默认 16）")
    ap.add_argument("--segs", default=str(_APP.parent / "Transformer_Train/data_cache_20cls/segs.npy"))
    ap.add_argument("--split-npz", default=str(_APP.parent / "Transformer_Train/data_cache_20cls/split.npz"))
    ap.add_argument("--meta", default=str(_APP.parent / "Transformer_Train/data_cache_20cls/meta.npz"))
    ap.add_argument("--names", default=str(_APP / "names/class_names_20.txt"))
    ap.add_argument("--save", default=None, help="把每帧结果存成 npz")
    ap.add_argument("--restore", action="store_true",
                    help="只把板子切回聚合模式，不发帧")
    args = ap.parse_args()

    names = load_names(Path(args.names))

    def name_of(i: int) -> str:
        return names[i] if 0 <= i < len(names) else str(i)

    with socket.create_connection((args.host, args.port), timeout=10.0) as sock:
        seq = int(time.time()) & 0x7FFFFFFF
        ack = send_command(sock, CMD_SET_MODE, MODE_FUSION if args.restore else MODE_ANALYSIS, seq)
        if ack["status"] == STATUS_ACK:
            print(f"板端模式 -> {'fusion' if args.restore else 'analysis'}")
        else:
            raise SystemExit(f"切模式被拒（status={ack['status']}, pred={ack['pred']}）")
        if args.restore:
            return

        split = np.load(args.split_npz)
        if args.split not in split:
            raise SystemExit(f"split.npz 里没有 '{args.split}'")
        idx = pick_indices(np.asarray(split[args.split], dtype=np.int64), args.n)
        meta = np.load(args.meta, allow_pickle=True)
        labels = meta["labels"][idx].astype(np.int64)
        segs = np.load(args.segs, mmap_mode="r")

        chunks: list[dict] = []
        t0 = time.time()
        for i in range(args.n):
            seg = np.asarray(segs[int(idx[i])], dtype=np.float32)
            sock.sendall(encode(seg, seq=10000 + i, label=LABEL_UNKNOWN, dtype=DTYPE_F32,
                                scale=0.0))
            raw = recv_exact(sock, _RES.size)
            (magic, ver, status, _rseq, _label, pred, prob, lat, k,
             _res, _ts) = _RES.unpack(raw)
            if magic != 0x4F494652 or ver != 2:
                raise SystemExit(f"第 {i} 帧结果头不对：magic=0x{magic:08X} ver={ver}")
            top = [_TOP.unpack(recv_exact(sock, _TOP.size)) for _ in range(k)]
            rec = {"status": status, "latency_us": lat, "top": np.array(top, dtype="f4"),
                   "label": int(labels[i])}
            if status == STATUS_ANALYSIS:
                rec.update(read_analysis(sock))
            chunks.append(rec)
            top1 = f"{name_of(int(top[0][0]))} {top[0][1]:.3f}" if top else "-"
            print(f"  {i + 1:>3}/{args.n}  status={status}  ex_top1={top1}  "
                  f"{lat / 1000.0:.2f} ms")
        dt = time.time() - t0

        # 第一帧的详细内容：星座 / 频谱 / 专家特征各自长什么样。
        first = chunks[0]
        if first["status"] == STATUS_ANALYSIS:
            print("\n第一帧：")
            if len(first.get("top", [])):
                tops = [f"{name_of(int(c))} {p:.3f}" for c, p in first["top"]]
                print("  专家 top-k: " + "  ".join(tops))
            for key, tag in (("xf", "XF"), ("pl", "PL")):
                v = first.get(key, np.array([]))
                if v.size:
                    print(f"  {tag} top1  : {name_of(int(v.argmax()))} {v.max():.3f}")
            for key in ("raw", "eq"):
                v = first.get(key, np.array([]))
                if v.size:
                    iq = v.reshape(-1, 2)
                    rms = float(np.sqrt((iq ** 2).sum(1).mean()))
                    print(f"  {key:>3} 星座 : {iq.shape[0]} 点，平均幅度 {rms:.3f}")
            f = first.get("fft", np.array([]))
            if f.size:
                src = "均衡后" if first.get("fft_src_eq") else "原始"
                bins = np.fft.fftshift(f)
                fr = np.fft.fftshift(np.fft.fftfreq(f.size))
                pk = int(np.argmax(bins))
                print(f"  FFT      : {f.size} 点（{src} IQ），峰值在 {fr[pk]:+.3f} 归一化频率"
                      f"（第 {pk} 个 fftshift 后 bin）")
            ft = first.get("feat", np.array([]))
            if ft.size:
                print(f"  专家特征 : {ft.size} 维，前 8 维 "
                      f"{np.array2string(ft[:8], precision=4)}")
        else:
            print(f"\n第一帧 status={first['status']}（不是分析结果；板端可能没切成功）")

        ok = sum(1 for c in chunks if c["status"] == STATUS_ANALYSIS)
        print(f"\n共 {args.n} 帧，分析块 {ok} 帧，用时 {dt:.1f}s（{dt / max(1, args.n) * 1000:.0f} ms/帧）")

        if args.save:
            out = {"seq": np.arange(args.n), "label": np.array([c["label"] for c in chunks]),
                   "status": np.array([c["status"] for c in chunks]),
                   "latency_us": np.array([c["latency_us"] for c in chunks])}
            for key, _bit in F_BLOCKS:
                arrs = [c[key] for c in chunks if key in c]
                if len(arrs) == len(chunks) and arrs and arrs[0].size:
                    out[key] = np.stack(arrs)
            tops = [c["top"] for c in chunks]
            if tops and all(t.shape == tops[0].shape for t in tops):
                out["top"] = np.stack(tops)
            np.savez_compressed(args.save, **out)
            print(f"结果写到 {args.save}")

        # 收尾切回聚合模式，免得下次连上来还是分析模式。
        try:
            send_command(sock, CMD_SET_MODE, MODE_FUSION, seq + 1)
            print("板端模式已切回 fusion")
        except (OSError, ConnectionError) as e:
            print(f"切回 fusion 失败（不影响本次结果）：{e}")


if __name__ == "__main__":
    main()
