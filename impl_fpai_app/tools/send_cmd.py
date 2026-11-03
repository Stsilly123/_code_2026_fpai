"""给板端的 rffi_deploy 发一条控制帧（切模式 / 查询模式）。

板子做服务端，本脚本连上去、发一帧 dtype=2 的控制帧、读回 ack 就断开。
和 IQ 帧走同一个端口、同一套头；控制帧的 n_complex=0，载荷是 8 B 的 {cmd, arg}。

用法::

    # 切到快速模式（只跑 transformer）
    ./transformer_4_rf/Scripts/python.exe tools/send_cmd.py --host 192.168.1.50 --mode fast

    # 切到信号分析模式
    ... --mode analysis

    # 只查当前模式
    ... --query

板端 ack：status=4（CommandAck）表示接受，pred=当前模式；status=2 表示拒绝
（未知命令 / 模式不能跑，比如 XF 没打开时切 fast）。
"""

from __future__ import annotations

import argparse
import socket
import struct
import sys
import time

MAGIC = 0x51494652
VERSION = 1
DTYPE_CMD = 2
CMD_SET_MODE, CMD_QUERY_MODE = 1, 2

MODE_NAMES = {0: "fast", 1: "fusion", 2: "analysis"}
MODE_IDS = {v: k for k, v in MODE_NAMES.items()}

STATUS_NAMES = {0: "Ok", 1: "NoSignal", 2: "Error", 3: "Analysis", 4: "CommandAck"}

# 与 src/iq_frame.hpp 逐字节对应
_HDR = struct.Struct("<IHHiIIfQ")     # IqFrameHeader, 32 B
_CMD = struct.Struct("<Ii")           # IqCommand, 8 B
_RES = struct.Struct("<IHHIiifIHHQ")  # IqResultHeader, 40 B
assert _HDR.size == 32 and _CMD.size == 8 and _RES.size == 40


def recv_exact(sock: socket.socket, n: int) -> bytes:
    buf = b""
    while len(buf) < n:
        chunk = sock.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("板端关闭了连接")
        buf += chunk
    return buf


def send_command(host: str, port: int, cmd: int, arg: int, seq: int) -> dict:
    pkt = _HDR.pack(MAGIC, VERSION, DTYPE_CMD, 0, seq, 0, 0.0, time.time_ns())
    pkt += _CMD.pack(cmd, arg)
    with socket.create_connection((host, port), timeout=5.0) as s:
        s.sendall(pkt)
        raw = recv_exact(s, _RES.size)
        (magic, ver, status, rseq, label, pred, prob, lat, k, _res, ts) = _RES.unpack(raw)
        if k != 0:
            recv_exact(s, k * 8)  # 命令 ack 不该带条目，带了就吃掉
    if magic != 0x4F494652 or ver != 2 or rseq != seq:
        raise SystemExit(f"ack 头不对：magic=0x{magic:08X} ver={ver} seq={rseq}（期望 {seq}）")
    return {"status": status, "pred": pred, "label": label, "latency_us": lat, "ts": ts}


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    ap = argparse.ArgumentParser(description="给 rffi_deploy 发控制帧")
    ap.add_argument("--host", required=True, help="板子 IP")
    ap.add_argument("--port", type=int, default=9527)
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--mode", choices=sorted(MODE_IDS), help="切换到该模式")
    g.add_argument("--query", action="store_true", help="只查询当前模式（默认）")
    args = ap.parse_args()

    if args.mode:
        cmd, arg = CMD_SET_MODE, MODE_IDS[args.mode]
        what = f"切换 -> {args.mode}"
    else:
        cmd, arg = CMD_QUERY_MODE, 0
        what = "查询模式"

    r = send_command(args.host, args.port, cmd, arg, seq=int(time.time()) & 0xFFFFFFFF)
    st = STATUS_NAMES.get(r["status"], f"?({r['status']})")
    if r["status"] == 4:
        print(f"{what}：板端接受，当前模式 = {MODE_NAMES.get(r['pred'], r['pred'])}")
    elif r["status"] == 2:
        raise SystemExit(f"{what}：板端拒绝（命令号 {r['label']}）")
    else:
        raise SystemExit(f"{what}：板端回了 status={st}，不是控制 ack")


if __name__ == "__main__":
    main()
