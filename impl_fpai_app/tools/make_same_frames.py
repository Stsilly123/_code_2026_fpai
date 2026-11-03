"""把 frames.bin 的第 0 帧复制 n 份，生成「每帧都一样」的帧流。

用途：验证 XF 的 `.to(Host)` 是不是「迟一拍」。
如果迟一拍，frame 模式下每个 fold 的 5 次读会覆盖 {上一帧的 shift2, 本帧 -2,-1,0,1}；
帧全相同时这个集合和 fold 模式完全相同 ⇒ 两种模式的 XF 输出必须逐帧一致。
不一致就说明 reset 改变的是计算本身，不是对齐。

用法::

    ./transformer_4_rf/Scripts/python.exe tools/make_same_frames.py \
        --src samples/frames.bin --dst samples/frames_same.bin --n 32
"""

from __future__ import annotations

import argparse
import struct
from pathlib import Path

_HDR = struct.Struct("<IHHiIIfQ")
assert _HDR.size == 32

MAGIC = 0x51494652


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", default="samples/frames.bin")
    ap.add_argument("--dst", default="samples/frames_same.bin")
    ap.add_argument("--n", type=int, default=32)
    a = ap.parse_args()

    raw = Path(a.src).read_bytes()
    magic, ver, dtype, label, seq, n_complex, vscale, ts = _HDR.unpack_from(raw, 0)
    if magic != MAGIC:
        raise SystemExit(f"{a.src} 不是 rffi 帧流（magic={magic:#x}）")
    payload = n_complex * 2 * (4 if dtype == 0 else 2)
    frame0 = raw[_HDR.size:_HDR.size + payload]

    out = bytearray()
    for i in range(a.n):
        out += _HDR.pack(MAGIC, ver, dtype, label, i, n_complex, vscale, ts + i)
        out += frame0
    Path(a.dst).write_bytes(out)
    print(f"{a.dst}: {a.n} 帧，每帧 {payload} B，标签 {label}")


if __name__ == "__main__":
    main()
