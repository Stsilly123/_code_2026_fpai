# -*- coding: utf-8 -*-
"""
生成 Signal_process 各模块的时序图（Visio 风格 SVG）。

用 2018.3 工程源码里的实际计数/契约，不引入额外依赖：
    python gen_timing_svgs.py
输出全部 SVG，可直接用 Visio「插入 > 图片」或浏览器打开。
"""
import os

# ── Visio 默认主题色 ────────────────────────────────────────────────────
INK    = "#1F3864"   # 深蓝（文字/边框）
BLUE   = "#2E75B6"   # 蓝（波形）
BUS    = "#DEEBF7"   # 浅蓝（总线填充）
BLUE2  = "#BDD7EE"
GREEN  = "#548235"
GREEN2 = "#C6E0B4"
ORANGE = "#C55A11"
ORANGE2= "#F8CBAD"
YELLOW = "#BF9000"
YELLOW2= "#FFE699"
GRAY   = "#7F7F7F"
LGRAY  = "#F2F2F2"
GRID   = "#E7E6E6"
RED    = "#C00000"
PURPLE2= "#D9D2E9"
PURPLE = "#7030A0"

FONT = "Microsoft YaHei,Segoe UI,sans-serif"

X0, X1 = 240, 1200          # 波形区
LBL_W  = 216
ROW_H  = 40
ROW_STEP = 50


def esc(s):
    return (str(s).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))


class Doc:
    def __init__(self, w, h, title, sub, footer, title_size=19, sub_size=10.5):
        self.w, self.h = w, h
        self.e = []
        self.footer = footer
        # 标题条
        self.R(24, 16, w - 48, 50, "#FFFFFF", "#BFBFBF", 1)
        self.R(24, 16, w - 48, 50, INK, "none", 0)
        self.T(40, 48, title, title_size, "#FFFFFF", "start", "600")
        self.T(w - 40, 45, sub, sub_size, "#DEEBF7", "end")

    # ── 基本图元 ────────────────────────────────────────────────────────
    def add(self, s):
        self.e.append(s)

    def R(self, x, y, w, h, fill="none", stroke="none", sw=1, rx=0, dash=None, op=None):
        a = ' x="%.1f" y="%.1f" width="%.1f" height="%.1f"' % (x, y, w, h)
        a += ' fill="%s"' % fill
        if stroke != "none":
            a += ' stroke="%s" stroke-width="%s"' % (stroke, sw)
        if rx:
            a += ' rx="%s"' % rx
        if dash:
            a += ' stroke-dasharray="%s"' % dash
        if op is not None:
            a += ' fill-opacity="%s"' % op
        self.add("<rect%s/>" % a)

    def L(self, x1, y1, x2, y2, stroke=BLUE, sw=2, dash=None, marker=False):
        a = ' x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f"' % (x1, y1, x2, y2)
        a += ' stroke="%s" stroke-width="%s"' % (stroke, sw)
        if dash:
            a += ' stroke-dasharray="%s"' % dash
        if marker:
            a += ' marker-end="url(#arrow)"'
        self.add("<line%s/>" % a)

    def T(self, x, y, s, size=12.5, fill=INK, anchor="start", weight="400", style="normal"):
        a = ' x="%.1f" y="%.1f" font-family="%s" font-size="%s" fill="%s"' % (x, y, FONT, size, fill)
        a += ' text-anchor="%s" font-weight="%s" font-style="%s"' % (anchor, weight, style)
        self.add("<text%s>%s</text>" % (a, esc(s)))

    def PG(self, pts, fill="none", stroke=BLUE, sw=1.5, dash=None):
        p = " ".join("%.1f,%.1f" % q for q in pts)
        a = ' points="%s" fill="%s" stroke="%s" stroke-width="%s"' % (p, fill, stroke, sw)
        if dash:
            a += ' stroke-dasharray="%s"' % dash
        self.add("<polygon%s/>" % a)

    def PATH(self, d, stroke=BLUE, fill="none", sw=2, dash=None):
        a = ' d="%s" fill="%s" stroke="%s" stroke-width="%s"' % (d, fill, stroke, sw)
        if dash:
            a += ' stroke-dasharray="%s"' % dash
        self.add("<path%s/>" % a)

    # ── 行 ──────────────────────────────────────────────────────────────
    def row(self, y, name, sub=None, h=ROW_H):
        self.R(24, y - h / 2, LBL_W, h, LGRAY, "#D9D9D9", 1)
        self.T(34, y - 1, name, 12)
        if sub:
            self.T(34, y + 15, sub, 9.2, GRAY)
        self.R(X0, y - h / 2, X1 - X0, h, "#FBFCFE", "none")
        self.L(X0, y + h / 2, X1, y + h / 2, GRID, 1)

    def band(self, y, x0, x1, level, color=BLUE, sw=1.8, fill_high=None):
        hi = y - 13
        lo = y + 11
        yy = hi if level else lo
        self.L(x0, yy, x1, yy, color, sw)
        if level:
            self.R(x0, hi, x1 - x0, 4, color, "none")

    def clock_band(self, y, x0, x1, period_px=11.0):
        """200 MHz 时钟：压缩轴上画成连续方波带。"""
        if period_px < 5:
            self.R(x0, y - 16, x1 - x0, 32, "#F2F7FC", BLUE2, 1)
            self.PATH("M %.1f %.1f L %.1f %.1f" % (x0, y, x1, y), BLUE, sw=1,
                      dash="2,6")
            self.T((x0 + x1) / 2, y + 4, "200 MHz 连续（5 ns/拍）", 10, BLUE, "middle")
            return
        d = ["M %.1f %.1f" % (x0, y + 11)]
        x = x0
        hi = True
        while x < x1:
            nx = min(x + period_px / 2.0, x1)
            yy = y - 15 if hi else y + 11
            d.append("L %.1f %.1f" % (x, yy))
            d.append("L %.1f %.1f" % (nx, yy))
            x = nx
            hi = not hi
        self.PATH(" ".join(d), BLUE, sw=2)

    def bus(self, y, x0, x1, label, fill=BUS, stroke=BLUE, size=10.2, color=INK):
        if x1 - x0 < 1:
            return
        hh = 13
        if x1 - x0 < 16:
            self.R(x0, y - hh, max(2, x1 - x0), 2 * hh, fill, stroke, 1)
            return
        self.PG([(x0 + 4, y - hh), (x1 - 4, y - hh), (x1, y),
                 (x1 - 4, y + hh), (x0 + 4, y + hh), (x0, y)],
                fill, stroke, 1.2)
        if label:
            self.T((x0 + x1) / 2, y + 3.5, label, size, color, "middle")

    def phase_band(self, ytop, ybot, x0, x1, label, fill, fill_op=0.45, top=True):
        self.R(x0, ytop, x1 - x0, ybot - ytop, fill, "none", 0, 0, None, fill_op)
        if label:
            self.T((x0 + x1) / 2, (ytop + 6) if top else (ybot - 6), label, 9.5, INK, "middle")

    def callout(self, x, y, w, lines, target=None, color=YELLOW2, edge=YELLOW):
        h = 18 + 15 * len(lines)
        self.R(x + 2, y + 2, w, h, "#FFFFFF", "#D9D9D9", 1, 4)
        self.R(x, y, w, h, color, edge, 1.2, 4)
        for i, s in enumerate(lines):
            self.T(x + 9, y + 16 + 15 * i, s, 9.8, INK)
        if target:
            tx, ty = target
            sx = x + (w if tx > x + w else 0)
            sy = y + h / 2
            self.L(sx, sy, tx, ty, edge, 1, "4,3", True)
        return h

    def note(self, x, y, w, lines, fill="#F2F2F2", edge="#BFBFBF", size=9.6):
        h = 14 + 14.5 * len(lines)
        self.R(x, y, w, h, fill, edge, 1, 3)
        for i, s in enumerate(lines):
            self.T(x + 8, y + 14 + 14.5 * i, s, size, "#404040")
        return h

    # ── 坐标轴 ──────────────────────────────────────────────────────────
    def axis(self, y, xf, ticks, fmt_main, fmt_sub=None, title=None, tick_len=5,
             x0=X0, x1=X1, size=9.6):
        self.L(x0, y, x1, y, INK, 1.4)
        for t in ticks:
            x = xf(t)
            self.L(x, y - tick_len, x, y + tick_len, INK, 1)
            self.T(x, y + 18, fmt_main(t), size, INK, "middle")
            if fmt_sub:
                self.T(x, y + 31, fmt_sub(t), size - 1.0, GRAY, "middle")
        if title:
            self.T(x1, y + (45 if fmt_sub else 31), title, size, GRAY, "end")

    def finish(self, path):
        head = ('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" '
                'viewBox="0 0 %d %d">\n' % (self.w, self.h, self.w, self.h))
        defs = (
            '<defs>\n'
            '<marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" '
            'markerHeight="7" orient="auto-start-reverse">'
            '<path d="M0,0 L10,5 L0,10 z" fill="#BF9000"/></marker>\n'
            '<pattern id="hatch" width="7" height="7" patternUnits="userSpaceOnUse" '
            'patternTransform="rotate(45)">'
            '<line x1="0" y1="0" x2="0" y2="7" stroke="#A6A6A6" stroke-width="1.6"/>'
            '</pattern>\n'
            '</defs>\n'
        )
        foot = ('<text x="24" y="%d" font-family="%s" font-size="9" fill="#A6A6A6">%s</text>\n'
                % (self.h - 10, FONT, esc(self.footer)))
        with open(path, "w", encoding="utf-8") as f:
            f.write(head + defs + "\n".join(self.e) + "\n" + foot + "</svg>\n")


def scale(c0, c1, x0=X0, x1=X1):
    return lambda c: x0 + (c - c0) * (x1 - x0) / float(c1 - c0)


def tick_list(c0, c1, step):
    v = []
    t = c0
    while t <= c1 + 1e-9:
        v.append(int(round(t)))
        t += step
    return v


# ══════════════════════════════════════════════════════════════════════════
#  00  顶层：一轮 8 帧
# ══════════════════════════════════════════════════════════════════════════
def svg_system(path):
    d = Doc(1240, 925, "Signal_process 整链路时序（一轮 8 帧）",
            "200 MHz 单时钟域 · 一轮 = 8 帧 = 812.8 µs（101.6 µs/帧）",
            "数据来源：SRC/pl_ai/Signal_process.v、lstf_eq.v、expert/expert_feat_rffi.v、"
            "HLS IP 交付说明；时长为标称/实测值，HLS 为随数据变化的区间。")
    y = 120
    rows = []
    names = [
        ("clk_pll_i", "200 MHz，全链路同域"),
        ("MM2S → s_axis", "64 bit · 1024 beat = 8192 B/轮"),
        ("输入 FIFO avail_words", "8 帧 · 2048 字"),
        ("u_lcwt ap_start / ap_idle", "HLS：单次调用处理 8 帧"),
        ("u_lcwt dout_TVALID", "8 × 304 拍 = 9728 B"),
        ("u_expert busy", "8 × ≈94.4 µs"),
        ("u_expert m_tvalid", "8 × 256 字 = 8192 B"),
        ("u_lstf_eq busy", "8 × ≈55 µs"),
        ("u_lstf_eq m_tvalid", "8 × 256 字 = 8192 B"),
        ("dma1 S2MM（dout）", "1216 B/帧"),
        ("dma2 S2MM（eq）", "1024 B/帧"),
        ("dma3 S2MM（expert）", "1024 B/帧"),
    ]
    for name, sub in names:
        rows.append(y)
        d.row(y, name, sub)
        y += ROW_STEP
    ytop, ybot = rows[0] - 26, rows[-1] + 26

    # 时间轴：0..812.8 µs
    c0, c1 = 0, 812.8
    X = scale(c0, c1)
    ticks = [0, 101.6, 203.2, 304.8, 406.4, 508.0, 609.6, 711.2, 812.8]
    for t in ticks:
        d.L(X(t), ytop, X(t), ybot, "#EDEDED", 1)
        lab = "结束" if t >= 812.8 else ("F%d" % round(t / 101.6))
        d.T(X(t), ytop - 8, lab, 9.5, GRAY, "middle")

    # 帧预算虚线
    for i in range(1, 8):
        d.L(X(i * 101.6), ytop, X(i * 101.6), ybot, "#BFBFBF", 1.2, "4,4")

    # clk
    d.clock_band(rows[0], X0, X1, 7)

    # 输入 0..10.24 µs
    xin0, xin1 = X(0.4), X(10.64)
    d.band(rows[1], xin0, xin1, 1)
    seg = (xin1 - xin0) / 8.0
    for i in range(8):
        d.bus(rows[1], xin0 + i * seg + 1, xin0 + (i + 1) * seg - 1, "F%d" % i, BUS, BLUE, 9)
    d.L(X(0.4), rows[1] - 18, X(0.4), rows[1] + 16, BLUE, 1)
    d.T(X(10.9), rows[1] + 4, "≈10.2 µs 传输完成", 9.2, BLUE)

    # avail_words：0→2048，处理中下降
    xa = [X(0.4), X(2.0), X(10.64), X(812.8)]
    d.PATH("M %.1f %.1f L %.1f %.1f L %.1f %.1f L %.1f %.1f"
           % (xa[0], rows[2] + 11, xa[1], rows[2] - 13, xa[2], rows[2] - 13,
              xa[3], rows[2] + 11), BLUE, sw=2)
    d.L(X0, rows[2] - 13, xin1, rows[2] - 13, "#A6A6A6", 1, "3,3")

    # HLS ap_start / ap_idle：一次调用
    d.band(rows[3], X0, X1, 0, ORANGE)
    # ap_idle 低 1.6..~672（取上限画淡带）
    d.R(X(1.6), rows[3] - 13, X(672) - X(1.6), 24, "#FFF2CC", ORANGE, 1, 0, None, 0.55)
    d.T((X(1.6) + X(672)) / 2, rows[3] + 4, "ap_idle = 0（单次 34,081 ~ 134,433 拍）", 9.4, ORANGE, "middle")
    d.R(X(1.6), rows[3] - 15, 8, 26, ORANGE2, ORANGE, 1.2)   # pulse（画在淡带之上）

    # HLS dout：8 个窄脉冲（数据相关，画在 21..672 区间）
    d.band(rows[4], X0, X1, 0)
    for i in range(8):
        xx = X(40 + i * 75)
        d.R(xx, rows[4] - 15, 6, 26, BLUE2, BLUE, 1)
        d.L(xx, rows[4] - 20, xx, rows[4] + 25, BLUE, 1.2, "2,3")
    d.T((X(40) + X(600)) / 2, rows[4] + 28,
        "8 × 304 拍（1216 B/帧），TLAST 位于第 303 拍；输出时刻随数据变化",
        9.4, BLUE, "middle")

    # expert busy：8 段 94.4 µs
    d.band(rows[5], X0, X(1.4), 0)
    for i in range(8):
        a = X(1.4 + i * 94.4)
        b = X(1.4 + (i + 1) * 94.4)
        d.R(a, rows[5] - 15, b - a - 2, 26, GREEN2, GREEN, 1.2)
        d.T((a + b) / 2, rows[5] + 4, "F%d" % i, 9.2, GREEN, "middle")
    d.band(rows[5], X(1.4 + 8 * 94.4), X1, 0)

    # expert 输出：每帧结束后 256 字
    d.band(rows[6], X0, X1, 0)
    for i in range(8):
        x = X(1.4 + (i + 1) * 94.4)
        d.R(x, rows[6] - 15, 5, 26, ORANGE2, ORANGE, 1)
        d.L(x, rows[6] - 22, x, rows[6] + 22, ORANGE, 1.2, "2,3")
    d.T(X(300), rows[6] + 28, "每帧 256 字（1024 B），TLAST 位于第 255 字；双 bank 交替输出",
        9.4, ORANGE, "middle")

    # eq busy：8 段 55 µs
    d.band(rows[7], X0, X(1.4), 0)
    for i in range(8):
        a = X(1.4 + i * 55.0)
        b = X(1.4 + (i + 1) * 55.0)
        d.R(a, rows[7] - 15, b - a - 2, 26, PURPLE2, PURPLE, 1.2)
        d.T((a + b) / 2, rows[7] + 4, "F%d" % i, 9.2, PURPLE, "middle")
    d.band(rows[7], X(1.4 + 8 * 55.0), X1, 0)

    d.band(rows[8], X0, X1, 0)
    for i in range(8):
        x = X(1.4 + (i + 1) * 55.0)
        d.R(x, rows[8] - 15, 5, 26, PURPLE2, PURPLE, 1)
        d.L(x, rows[8] - 22, x, rows[8] + 22, PURPLE, 1.2, "2,3")
    d.T(X(300), rows[8] + 28, "每帧 256 字（1024 B），TLAST 位于第 255 字",
        9.4, PURPLE, "middle")

    # S2MM three lanes
    for k, (row, color, label) in enumerate([
            (rows[9], BLUE, "dout 1216 B"),
            (rows[10], PURPLE, "eq 1024 B"),
            (rows[11], ORANGE, "expert 1024 B")]):
        d.band(row, X0, X1, 0, color)
        if k == 0:
            xs = [X(1.4 + (i + 1) * 75) for i in range(8)]
        elif k == 1:
            xs = [X(1.4 + (i + 1) * 55.0) for i in range(8)]
        else:
            xs = [X(1.4 + (i + 1) * 94.4) for i in range(8)]
        for x in xs:
            d.R(x, row - 15, 4, 26, color, color, 1)
        d.T(X(600), row + 4, label, 9.0, color)

    axis_y = rows[-1] + 34
    d.axis(axis_y, X, ticks,
           lambda t: ("%g" % t) if t < 1000 else "%.0f" % t,
           None, "µs")
    d.T(X1, axis_y + 58, "竖虚线：101.6 µs/帧的实时预算边界", 9.4, GRAY, "end")

    # 底部说明面板
    py = axis_y + 74
    d.R(24, py, 1176, 120, "#FFFFFF", "#BFBFBF", 1)
    cols = [
        ("输入与分帧", [
            "PS 经单个 MM2S 描述符写入 8192 B = 1024 beat，约 10.2 µs；",
            "stream_buf 以 256 字计数强制分帧，DMA 的 tlast 不参与分帧；",
            "8 帧写入输入环/FIFO，三路模块从同一数据流中独立读取。",
        ]),
        ("三路并行", [
            "HLS：单次 ap_start 处理 8 帧，dout 8×304 拍 = 9728 B；",
            "expert：8 × 94.4 µs，双 bank 交替输出；",
            "eq：8 × 55 µs，结果经输出 FIFO 逐字输出。",
        ]),
        ("预算分析", [
            "帧周期 101.6 µs（20,320 拍），一轮 812.8 µs；",
            "最慢通路为 expert：8 × 94.4 = 755 µs，余量 58 µs；",
            "dout 1216 B/帧；eq/expert 各 1024 B/帧。",
        ]),
    ]
    cw = 384
    for i, (title, lines) in enumerate(cols):
        x = 40 + i * cw
        d.T(x, py + 24, title, 11.5, INK, "start", "600")
        for j, s in enumerate(lines):
            d.T(x, py + 46 + j * 17, s, 9.6, "#404040")
        if i:
            d.L(24 + i * cw - 8, py + 12, 24 + i * cw - 8, py + 106, "#D9D9D9", 1)

    d.finish(path)


# ══════════════════════════════════════════════════════════════════════════
#  01  stream_buf
# ══════════════════════════════════════════════════════════════════════════
def svg_stream_buf(path):
    d = Doc(1240, 840, "stream_buf 时序：64 bit AXIS → 33 bit 字，256 字分帧",
            "1 beat → 2 字，s_tready 隔拍有效（pending）· 128 beat = 256 字 = 1 帧",
            "数据来源：SRC/pl_ai/stream_buf.v（s_tready/pending/wr_low/wr_high/padding）。")
    c0, c1 = 0, 16
    X = scale(c0, c1)
    ticks = [0, 2, 4, 6, 8, 10, 12, 14, 16]
    y = 120
    rows = []
    for name, sub in [
            ("clk", "200 MHz"),
            ("s_tvalid", "上游 beat 有效"),
            ("s_tready", "= ~full & ~pending & ~padding"),
            ("s_tdata[63:0]", "B0..B3 = 128 beat/帧"),
            ("pending", "高半字待写入"),
            ("data_valid", "FIFO 写使能"),
            ("data_o[32:0]", "{last,Q,I}"),
            ("wcnt[7:0]", "帧内字数 0..255"),
            ("din_full", "FIFO 满，停止写入")]:
        rows.append(y)
        d.row(y, name, sub)
        y += ROW_STEP
    ytop, ybot = rows[0] - 26, rows[-1] + 26
    for t in ticks:
        d.L(X(t), ytop, X(t), ybot, GRID, 1)

    # clk
    d.clock_band(rows[0], X0, X1, (X1 - X0) / 16.0)

    # TVALID 全高
    d.band(rows[1], X0, X(12), 1)
    d.T(X(13.2), rows[1] + 4, "上游 TVALID 持续有效", 9.2, BLUE)

    # TREADY：0,2,4,6 高；1,3,5,7 低
    segs = []
    for i in range(8):
        d.band(rows[2], X(2 * i), X(2 * i + 1), 1)
        d.band(rows[2], X(2 * i + 1), X(2 * i + 2), 0)
    for i in range(1, 17):
        d.L(X(i), rows[2] - 13, X(i), rows[2] + 11, BLUE, 1.2)
    d.T(X(9), rows[2] + 30, "每隔一拍接收一次：pending 期间写入高半字", 9.4, BLUE)

    # s_tdata：B0..B3 两个周期
    for i in range(4):
        d.bus(rows[3], X(2 * i) + 2, X(2 * i + 2) - 2, "B%d" % i, BUS, BLUE, 10.5)
    d.T(X(9), rows[3] + 4, "64 bit = {Q1,I1,Q0,I0}", 9.2, GRAY)

    # pending
    for i in range(4):
        d.band(rows[4], X(2 * i), X(2 * i + 1), 0)
        d.band(rows[4], X(2 * i + 1), X(2 * i + 2), 1)
    for i in range(1, 9):
        d.L(X(i), rows[4] - 13, X(i), rows[4] + 11, BLUE, 1.2)

    # data_valid：每拍都写一个字
    d.band(rows[5], X0, X(8), 1)
    d.T(X(9), rows[5] + 4, "每拍写入 1 字，连续无空闲", 9.2, BLUE)

    # data_o：W0..W7
    for i in range(8):
        lab = ("W%d" % i) if (X(1) - X(0)) >= 30 else ""
        d.bus(rows[6], X(i) + 1, X(i + 1) - 1, lab, BUS, BLUE, 9)
    d.T(X(9), rows[6] + 4, "W0={Q0,I0}  W1={Q1,I1} …", 9.2, GRAY)

    # wcnt
    for i in range(8):
        d.bus(rows[7], X(i) + 6, X(i + 1) - 6, str(i), "#FFFFFF", "#A6A6A6", 9)
    d.T(X(9), rows[7] + 4, "每字递增 1，计满 256 归零", 9.2, GRAY)

    # din_full：12..14 高，展示反压
    d.band(rows[8], X0, X(12), 0)
    d.band(rows[8], X(12), X(14), 1, ORANGE)
    d.band(rows[8], X(14), X1, 0, ORANGE)
    for t in (12, 14):
        d.L(X(t), rows[8] - 13, X(t), rows[8] + 11, ORANGE, 1.8)
    d.T(X(12.2), rows[8] - 20, "full=1 时 s_tready 立即置 0，数据保持", 9.2, ORANGE)

    # 帧边界小面板
    py = rows[-1] + 96
    d.R(24, py - 26, 1176, 196, "#FFFFFF", "#BFBFBF", 1)
    d.T(38, py - 6, "帧边界（wcnt 254 → 255 → 0）与 tlast 异常处理", 12.5, INK, "start", "600")
    X2 = scale(250, 258, 240, 748)
    t2 = [250, 252, 254, 256, 258]
    ys = py + 26
    for nm, sub in [("wcnt", "第 256 字强制分帧"),
                    ("data_o[32] = last", "仅在第 255 字有效"),
                    ("s_tready", "补零阶段为 0")]:
        d.R(24, ys - 16, 216, 32, LGRAY, "#D9D9D9", 1)
        d.T(34, ys - 2, nm, 10.5)
        d.T(34, ys + 11, sub, 8.6, GRAY)
        ys += 34
    # wcnt bus 254,255,0,1
    vals = [("254", 250, 254), ("255", 254, 255), ("0", 255, 256), ("1", 256, 258)]
    for lab, a, b in vals:
        d.bus(py + 26, X2(a) + 3, X2(b) - 3, lab, BUS, BLUE, 9.5)
    # last pulses
    for a, b, lv in [(250, 255, 0), (255, 256, 1), (256, 258, 0)]:
        d.band(py + 60, X2(a), X2(b), lv, GREEN)
    for a, b, lv in [(250, 254, 1), (254, 256, 0), (256, 258, 1)]:
        d.band(py + 94, X2(a), X2(b), lv, ORANGE)
    d.L(X2(255), py + 12, X2(255), py + 108, "#BFBFBF", 1, "3,3")
    d.L(X2(256), py + 12, X2(256), py + 108, "#BFBFBF", 1, "3,3")
    for t in (255, 256):
        d.L(X2(t), py + 60 - 13, X2(t), py + 60 + 11, GREEN, 1.6)
    for t in (254, 256):
        d.L(X2(t), py + 94 - 13, X2(t), py + 94 + 11, ORANGE, 1.6)
    d.axis(py + 108, X2, t2, lambda t: str(t), None, "字", x1=748)
    d.note(772, py + 2, 424, [
        "s_tlast 提前（不足 256 字）：",
        "  本帧剩余字补零，padding 期间 s_tready=0",
        "s_tlast 迟到或缺席：",
        "  忽略该信号，仍按第 256 字分帧并顺延",
        "帧边界始终落在 beat 的高半字上",
    ], "#FFF2CC", YELLOW)

    d.axis(rows[-1] + 34, X, ticks, lambda t: str(t), None, "时钟周期（cycle）")
    d.finish(path)


# ══════════════════════════════════════════════════════════════════════════
#  02  LcwtMLP_RFFI (HLS)
# ══════════════════════════════════════════════════════════════════════════
def svg_hls(path):
    d = Doc(1240, 780, "LcwtMLP_RFFI（HLS）时序：单次 ap_start 处理 8 帧",
            "输入 8×256 拍 · 输出 8×304 拍（TLAST@303）· 34,081 ~ 134,433 拍/次",
            "数据来源：IP交付说明.md、IP改动说明_20261022.md、Signal_process.v 的 ap_start 逻辑。")
    c0, c1 = 0, 140000
    X = scale(c0, c1)
    ticks = [0, 20000, 40000, 60000, 80000, 100000, 120000, 140000]
    y = 120
    rows = []
    for name, sub in [
            ("clk", "200 MHz"),
            ("ap_start", "avail_words ≥ 256 时脉冲"),
            ("ap_idle", "块级握手，无 AXI-Lite"),
            ("din_TVALID / din_V_V", "8 帧 × 256 拍"),
            ("dout_TVALID", "8 帧 × 304 拍"),
            ("dout_TLAST", "仅每帧第 303 拍"),
            ("ap_done", "34,081 ~ 134,433 拍")]:
        rows.append(y)
        d.row(y, name, sub)
        y += ROW_STEP
    ytop, ybot = rows[0] - 26, rows[-1] + 26
    for t in ticks:
        d.L(X(t), ytop, X(t), ybot, GRID, 1)

    d.clock_band(rows[0], X0, X1, 3)

    # ap_start 脉冲
    d.band(rows[1], X0, X(1200), 0, ORANGE)
    d.R(X(1200), rows[1] - 15, 10, 26, ORANGE2, ORANGE, 1.2)
    d.band(rows[1], X(1210), X1, 0, ORANGE)
    d.T(X(4000), rows[1] + 4, "单拍脉冲（ip_idle_r 延迟一拍，避免组合反馈）", 9.2, ORANGE)

    # ap_idle：0..done
    d.band(rows[2], X0, X(1200), 1)
    d.band(rows[2], X(1200), X(134433), 0, ORANGE)
    d.band(rows[2], X(134433), X1, 1, ORANGE)
    d.L(X(1200), rows[2] - 13, X(1200), rows[2] + 11, ORANGE, 1.8)
    d.L(X(134433), rows[2] - 13, X(134433), rows[2] + 11, ORANGE, 1.8)
    d.T(X(3200), rows[2] - 2, "ap_idle = 0：8 帧处理区间", 9.4, ORANGE)

    # din 8 帧（ap_start 之后开始读）
    din_a, din_b = 1300, 1300 + 2048 * 2
    d.band(rows[3], X0, X(din_a), 0)
    seg = (X(din_b) - X(din_a)) / 8.0
    for i in range(8):
        d.bus(rows[3], X(din_a) + i * seg + 1, X(din_a) + (i + 1) * seg - 1,
              "F%d" % i, BUS, BLUE, 9)
    d.T(X(21000), rows[3] + 30, "共 2048 拍 = 8 帧，按帧顺序；每帧最后一拍 last=1",
        9.2, BLUE)

    # dout：数据相关窗口
    d.R(X(34081), rows[4] - 16, X(134433) - X(34081), 28,
        "url(#hatch)", "#A6A6A6", 1, 0, None, 0.35)
    d.band(rows[4], X0, X(34081), 0, BLUE)
    for i in range(8):
        xx = X(34081 + i * 12000)
        d.R(xx, rows[4] - 15, 7, 26, BLUE2, BLUE, 1.1)
    d.band(rows[4], X(134433), X1, 0, BLUE)
    d.T(X(70000), rows[4] + 30,
        "8 × 304 拍（每拍 4 B，共 9728 B）；起始时刻随流水数据变化",
        9.2, BLUE, "middle")

    # TLAST
    d.band(rows[5], X0, X1, 0, GREEN)
    for i in range(8):
        xx = X(34081 + i * 12000 + 1200)
        d.R(xx, rows[5] - 15, 5, 26, GREEN, GREEN, 1)
        d.L(xx, rows[5] - 20, xx, rows[5] + 14, GREEN, 1, "2,3")
    d.T(X(70000), rows[5] + 30, "TLAST 仅出现在 b=303（第 304 拍），共 8 个", 9.2, GREEN, "middle")

    # ap_done：两次可能的完成时刻 + 区间标注
    d.band(rows[6], X0, X(34081), 0, GREEN)
    d.band(rows[6], X(34081), X(134433), 0, GREEN)
    d.band(rows[6], X(134433), X1, 0, GREEN)
    for t0 in (34081, 134433):
        d.R(X(t0), rows[6] - 13, max(4, X(t0 + 30) - X(t0)), 24, GREEN, GREEN, 1)
    d.R(X(34081), rows[6] - 34, X(134433) - X(34081), 5, YELLOW2, YELLOW, 1)
    d.L(X(34081), rows[6] - 34, X(34081), rows[6] - 13, YELLOW, 1, "2,2")
    d.L(X(134433), rows[6] - 34, X(134433), rows[6] - 13, YELLOW, 1, "2,2")

    # 输出契约小面板
    py = rows[-1] + 110
    d.R(24, py - 26, 1176, 220, "#FFFFFF", "#BFBFBF", 1)
    d.T(38, py - 6, "单帧输出格式（304 拍 = 1216 B = 16 token × 38 dim × int16）", 12.5, INK, "start", "600")
    X2 = scale(0, 320, 240, 820)
    t2 = [0, 64, 128, 192, 256, 304]
    ys = py + 22
    for nm, sub in [("dout_TVALID", "连续 304 拍"),
                    ("dout_TDATA", "beat 0..303"),
                    ("dout_TLAST", "b=303"),
                    ("dout_TKEEP", "恒 0xF")]:
        d.R(24, ys - 15, 216, 30, LGRAY, "#D9D9D9", 1)
        d.T(34, ys - 1, nm, 10.5)
        d.T(34, ys + 12, sub, 8.6, GRAY)
        ys += 34
    d.band(py + 22, X2(0), X2(304), 1, BLUE)
    d.bus(py + 56, X2(0) + 2, X2(304) - 2, "304 × 32 bit（2 × int16 Q4）", BUS, BLUE, 10)
    d.band(py + 90, X2(0), X2(303), 0, GREEN)
    d.R(X2(303), py + 77, max(4, X2(304) - X2(303)), 24, GREEN, GREEN, 1)
    d.T(X2(303) + 10, py + 78, "TLAST", 9.5, GREEN)
    d.band(py + 124, X2(0), X2(304), 1, BLUE)
    for t in t2:
        d.L(X2(t), py + 8, X2(t), py + 140, GRID, 1)
    d.axis(py + 140, X2, t2, lambda t: str(t), None, "拍/帧", x1=820)
    d.note(848, py + 2, 348, [
        "调用：单次 ap_start 处理 8 帧；",
        "  每帧折合 4,260 ~ 16,804 拍",
        "  （21.3 ~ 84.0 µs），均小于 101.6 µs。",
        "输出：8 × 304 = 2432 拍 / 次。",
        "S2MM 每次按 1216 B 挂载一帧；",
        "若长度仍设为 684，将在第 171 拍截断。",
    ], "#FFF2CC", YELLOW)

    d.axis(rows[-1] + 34, X, ticks,
           lambda t: "%dk" % (t // 1000),
           lambda t: "%.1f" % (t * 5e-6), "拍 / µs")
    d.finish(path)


# ══════════════════════════════════════════════════════════════════════════
#  03  expert_feat_rffi
# ══════════════════════════════════════════════════════════════════════════
def svg_expert(path):
    d = Doc(1240, 1070, "expert_feat_rffi 时序：一帧（256 样点 → 256 字特征）",
            "≈18,877 拍 ≈ 94.4 µs，低于 20,320 拍（101.6 µs）· 8 帧输入环 + 双 bank 输出",
            "数据来源：SRC/pl_ai/expert/expert_feat_rffi.v 的 FSM 与输出引擎、expert/README.md。")
    c0, c1 = 0, 20320
    X = scale(c0, c1)
    ticks = [0, 2000, 4000, 6000, 8000, 10000, 12000, 14000, 16000, 18000, 20000]
    y = 120
    rows = []
    for name, sub in [
            ("clk", "200 MHz"),
            ("din_valid / din", "33 bit {last,Q,I}"),
            ("wr_done", "第 255 字写满"),
            ("nfull[3:0]", "输入环排队帧数（深 8）"),
            ("FSM state", "单帧特征流水（编号见下方色带）"),
            ("busy", "= (state != IDLE) || out_active"),
            ("feat_valid[bank]", "双 bank 交替"),
            ("m_tvalid", "AXIS 输出"),
            ("m_tdata[31:0]", "特征字"),
            ("m_tlast", "第 255 字")]:
        rows.append(y)
        d.row(y, name, sub)
        y += ROW_STEP
    ytop, ybot = rows[0] - 26, rows[-1] + 26
    for t in ticks:
        d.L(X(t), ytop, X(t), ybot, GRID, 1)

    d.clock_band(rows[0], X0, X1, 3)

    # 输入：F0 在前 256 拍，F1 示意后续帧继续入环
    d.band(rows[1], X0, X(256), 1, BLUE)
    d.bus(rows[1], X(0), X(256), "F0 · 256 字", BUS, BLUE, 10)
    d.band(rows[1], X(7000), X(7256), 1, BLUE)
    d.bus(rows[1], X(7000), X(7256), "F1", BUS, BLUE, 10)
    d.T(X(7700), rows[1] + 4, "处理期间输入环继续接收帧", 9.2, BLUE)

    # wr_done
    d.band(rows[2], X0, X1, 0, GREEN)
    for t in (256, 7256):
        d.R(X(t) - 2, rows[2] - 15, 5, 26, GREEN, GREEN, 1)

    # nfull
    d.PATH("M %.1f %.1f L %.1f %.1f L %.1f %.1f L %.1f %.1f L %.1f %.1f"
           % (X(0), rows[3] + 11, X(256), rows[3] + 11, X(256), rows[3] - 13,
              X(400), rows[3] - 13, X(400), rows[3] + 11), BLUE, sw=2)
    d.T(X(500), rows[3] + 4, "1 → 0（S_IDLE 状态取帧）", 9.2, BLUE)

    # FSM 阶段：编号色带
    stages = [
        ("ZN", 990, BLUE2), ("LNRMS", 47, BLUE2), ("FFT", 6314, GREEN2),
        ("DWT_I", 750, GREEN2), ("DWTF_I", 40, GREEN2), ("DWT_Q", 750, GREEN2),
        ("DWTF_Q", 40, GREEN2), ("HIST", 700, YELLOW2), ("CUM", 3900, YELLOW2),
        ("CFO", 4300, ORANGE2), ("POW", 790, ORANGE2), ("PACK", 256, PURPLE2),
    ]
    x = X(0)
    yb = rows[4]
    for idx, (nm, cyc, col) in enumerate(stages):
        w = (X1 - X0) * cyc / float(c1)
        d.R(x, yb - 18, w, 36, col, GRAY, 0.8)
        if w >= 19:
            d.T(x + w / 2, yb + 4, str(idx + 1), 8.6, INK, "middle")
        x += w
    # 预算线 / 处理结束线
    d.L(X(20320), ytop, X(20320), ybot, "#BFBFBF", 1.2, "4,4")
    d.L(X(18877), ytop, X(18877), ybot, RED, 1.3, "4,3")
    d.T(X(18877) - 6, ytop - 8, "处理结束（18,877 拍）", 9.0, RED, "end")

    # busy
    d.band(rows[5], X0, X(18877), 1, GREEN)
    d.band(rows[5], X(18877), X1, 0, GREEN)
    d.L(X(18877), rows[5] - 13, X(18877), rows[5] + 11, GREEN, 1.8)

    # feat_valid / 输出
    t_out = 18877
    d.band(rows[6], X0, X(t_out), 0, PURPLE)
    d.R(X(t_out), rows[6] - 13, X(t_out + 256) - X(t_out), 24, PURPLE2, PURPLE, 1)
    d.T(X(t_out) - 4, rows[6] - 18, "bank0 有效", 8.6, PURPLE, "end")

    d.band(rows[7], X0, X(t_out), 0, ORANGE)
    d.band(rows[7], X(t_out), X(t_out + 256), 1, ORANGE)
    d.band(rows[7], X(t_out + 256), X1, 0, ORANGE)
    d.L(X(t_out), rows[7] - 13, X(t_out), rows[7] + 11, ORANGE, 1.8)
    d.L(X(t_out + 256), rows[7] - 13, X(t_out + 256), rows[7] + 11, ORANGE, 1.8)
    d.T(X(t_out) - 6, rows[7] - 18, "256 拍连续输出", 8.6, ORANGE, "end")

    d.bus(rows[8], X(t_out) + 1, X(t_out + 256) - 1, "", BUS, ORANGE, 9)

    d.band(rows[9], X0, X1, 0, GREEN)
    d.L(X(19132), rows[9] - 14, X(19132), rows[9] + 12, GREEN, 2)
    d.T(X(19128), rows[9] - 18, "TLAST（单拍脉冲）", 8.6, GREEN, "end")

    axis_y = rows[-1] + 34
    d.axis(axis_y, X, ticks,
           lambda t: ("%gk" % (t / 1000.0)) if t >= 1000 else str(t),
           lambda t: "%.2f" % (t * 5e-6), "拍 / µs")

    # ── 面板 A：状态色带图例 ──────────────────────────────────────────
    pa = axis_y + 66
    d.R(24, pa, 1176, 110, "#FFFFFF", "#BFBFBF", 1)
    d.T(38, pa + 20, "FSM 状态序列（编号对应上方色带；各段拍数为计算值，总量 ≈18,877 拍）",
        11.0, INK, "start", "600")
    cols = 6
    cw = 190
    for i, (nm, cyc, col) in enumerate(stages):
        r_, c_ = divmod(i, cols)
        xx = 40 + c_ * cw
        yy = pa + 40 + r_ * 32
        d.R(xx, yy, 15, 15, col, GRAY, 0.8)
        d.T(xx + 5.5, yy + 11.5, str(i + 1), 8.0, INK, "middle")
        d.T(xx + 22, yy + 12, "%s  %s" % (nm, ("%gk" % (cyc / 1000.0)) if cyc >= 1000 else cyc),
            9.4, "#404040")

    # ── 面板 B：输出 AXIS 放大 + 字格式 ──────────────────────────────
    pb = pa + 130
    d.R(24, pb, 1176, 240, "#FFFFFF", "#BFBFBF", 1)
    d.T(38, pb + 20, "输出 AXIS 字级时序（256 拍 = 1024 B/帧）与特征字布局", 11.0, INK, "start", "600")
    X2 = scale(0, 256, 240, 900)
    t2 = [0, 64, 128, 192, 256]
    layout = [
        (0, 128, "FFT log 幅度", "#DEEBF7"),
        (128, 138, "DWT 能量", "#C6E0B4"),
        (138, 166, "直方图/方位矩", "#FFE699"),
        (166, 178, "累积量", "#F8CBAD"),
        (178, 187, "CFO", "#D9D2E9"),
        (187, 193, "功率", "#B4C6E7"),
        (193, 197, "帧头", "#D9D9D9"),
        (197, 256, "补零", "#FFFFFF"),
    ]
    yl = pb + 40
    for a, b, lab, col in layout:
        d.R(X2(a), yl, max(1, X2(b) - X2(a)), 20, col, GRAY, 0.8)
    d.T(38, yl + 14, "字地址", 9.0, GRAY)
    for i, (a, b, lab, col) in enumerate(layout):
        r_, c_ = divmod(i, 4)
        xx = 240 + c_ * 168
        yy = yl + 38 + r_ * 17
        d.R(xx, yy - 8, 9, 9, col, GRAY, 0.8)
        d.T(xx + 14, yy, "%s %d..%d" % (lab, a, b - 1), 8.0, "#404040")

    ys0 = yl + 80
    for j, (nm, sub) in enumerate([("m_tvalid", "每字占 1 拍"),
                                   ("m_tdata", "字 0..255"),
                                   ("m_tlast", "第 255 字")]):
        yy = ys0 + j * 32
        d.R(24, yy - 15, 216, 30, LGRAY, "#D9D9D9", 1)
        d.T(34, yy - 1, nm, 10.5)
        d.T(34, yy + 12, sub, 8.6, GRAY)
        d.L(240, yy + 15, 900, yy + 15, GRID, 1)
    d.band(ys0 + 11, X2(0), X2(256), 0, ORANGE)
    for fn in range(256):
        xx = X2(fn)
        d.L(xx, ys0, xx, ys0 + 11, ORANGE, 1.0)
    d.bus(ys0 + 32, X2(0) + 2, X2(256) - 2, "256 × 32 bit", BUS, ORANGE, 9.5)
    d.band(ys0 + 64, X2(0), X2(255), 0, GREEN)
    d.L(X2(255), ys0 + 50, X2(255), ys0 + 64, GREEN, 2)
    d.T(X2(255) - 6, ys0 + 46, "TLAST", 8.6, GREEN, "end")
    for t in t2:
        d.L(X2(t), yl + 26, X2(t), ys0 + 78, GRID, 1)
    d.axis(ys0 + 82, X2, t2, lambda t: str(t), None, "拍/帧", x1=900)

    d.note(930, pb + 34, 260, [
        "帧头 193..196：魔数 / 版本 /",
        "帧号 / Q 格式（=12）。",
        "PACK 完成即置 feat_valid；",
        "输出与下一帧处理重叠。",
    ], "#FFF2CC", YELLOW, 9.0)

    d.finish(path)


# ══════════════════════════════════════════════════════════════════════════
#  04  lstf_eq
# ══════════════════════════════════════════════════════════════════════════
def svg_lstf_eq(path):
    d = Doc(1240, 1100, "lstf_eq（MMSE 均衡）时序：一帧（256 样点 → 256 字）",
            "标称 ≈11k 拍（55 µs），上限 14,202 拍（71 µs），均低于预算 20,320 拍 · 单复数 MAC + 迭代 CORDIC",
            "数据来源：SRC/pl_ai/lstf_eq.v 的 FSM/计数器、输出 FIFO；最差 setup 路径见 impl_1 时序报告。")
    c0, c1 = 0, 20320
    X = scale(c0, c1)
    ticks = [0, 2000, 4000, 6000, 8000, 10000, 12000, 14000, 16000, 18000, 20000]
    y = 120
    rows = []
    for name, sub in [
            ("clk", "200 MHz"),
            ("din 捕获（hls_wr）", "256 字/帧，8 槽环"),
            ("frames_avail", "排队帧数"),
            ("FSM state", "串行复用数据通路（编号见下方色带）"),
            ("busy", "= (state != IDLE)"),
            ("m_tvalid", "AXIS 输出"),
            ("m_tdata[31:0]", "{Q,I} Q4 int16"),
            ("m_tlast", "第 255 字"),
            ("stat_theta", "atan2 结果（CFO 角）"),
            ("stat_gate", "门控判决")]:
        rows.append(y)
        d.row(y, name, sub)
        y += ROW_STEP
    ytop, ybot = rows[0] - 26, rows[-1] + 26
    for t in ticks:
        d.L(X(t), ytop, X(t), ybot, GRID, 1)

    d.clock_band(rows[0], X0, X1, 3)

    # 输入
    d.band(rows[1], X0, X(256), 1, BLUE)
    d.bus(rows[1], X(0), X(256), "F0 · 256 字", BUS, BLUE, 10)
    d.band(rows[1], X(9000), X(9256), 1, BLUE)
    d.bus(rows[1], X(9000), X(9256), "F1", BUS, BLUE, 10)
    d.T(X(9400), rows[1] + 4, "帧接收与处理解耦（环满时产生背压）", 9.2, BLUE)

    # frames_avail
    d.PATH("M %.1f %.1f L %.1f %.1f L %.1f %.1f L %.1f %.1f"
           % (X(0), rows[2] + 11, X(256), rows[2] - 13, X(400), rows[2] - 13,
              X(400), rows[2] + 11), BLUE, sw=2)
    d.T(X(470), rows[2] + 4, "1 → 0（S_IDLE 状态取帧）", 9.2, BLUE)

    # FSM 阶段（按 RTL 计数取上限；扫描类随数据变化）
    stages = [
        ("ET", 204, BLUE2), ("R1", 544, BLUE2), ("ATAN", 76, GREEN2),
        ("ROT", 21, GREEN2), ("PB", 45, GREEN2), ("DFT+对齐", 3504, YELLOW2),
        ("GATE", 2, "#F2F2F2"), ("NORM", 600, YELLOW2), ("INTERP", 1, "#F2F2F2"),
        ("PW", 60, ORANGE2), ("PWEPS", 1, "#F2F2F2"), ("RECIP", 1800, ORANGE2),
        ("IDFT", 1200, PURPLE2), ("FIR", 6144, "#B4C6E7"),
    ]
    total = sum(s[1] for s in stages)          # 14,202 上限
    yb = rows[3]
    x = X(0)
    for idx, (nm, cyc, col) in enumerate(stages):
        w = (X1 - X0) * cyc / float(c1)
        d.R(x, yb - 18, w, 36, col, GRAY, 0.8)
        if w >= 19:
            d.T(x + w / 2, yb + 4, str(idx + 1), 8.6, INK, "middle")
        x += w
    d.T(x + 8, yb + 4, "IDLE", 8.4, GRAY)
    # 预算线 / 上限线
    d.L(X(20320), ytop, X(20320), ybot, "#BFBFBF", 1.2, "4,4")
    d.L(X(total), ytop, X(total), ybot, RED, 1.3, "4,3")
    d.T(X(total) - 6, ytop - 8, "上限 %d 拍（71 µs）" % total, 9.0, RED, "end")

    # busy
    d.band(rows[4], X0, X(total), 1, GREEN)
    d.band(rows[4], X(total), X1, 0, GREEN)
    d.L(X(total), rows[4] - 13, X(total), rows[4] + 11, GREEN, 1.8)

    # 输出：FIR 期间每 24 拍推一个字
    t_fir0 = total - 6144
    d.band(rows[5], X0, X(t_fir0), 0, PURPLE)
    d.band(rows[5], X(t_fir0), X(total), 1, PURPLE)
    d.L(X(t_fir0), rows[5] - 13, X(t_fir0), rows[5] + 11, PURPLE, 1.8)
    d.L(X(total), rows[5] - 13, X(total), rows[5] + 11, PURPLE, 1.8)
    d.T(X(t_fir0) - 6, rows[5] - 18, "FIR 期间每 24 拍输出 1 字", 8.6, PURPLE, "end")

    d.bus(rows[6], X(t_fir0) + 2, X(total) - 2, "", BUS, PURPLE, 9)
    d.T(X(total) - 6, rows[6] - 18, "256 字 = 1024 B", 8.8, PURPLE, "end")

    t_last = t_fir0 + 255 * 24
    d.band(rows[7], X0, X1, 0, GREEN)
    d.L(X(t_last), rows[7] - 14, X(t_last), rows[7] + 12, GREEN, 2)
    d.T(X(t_last) - 6, rows[7] - 18, "TLAST（fn == 255，单拍脉冲）", 8.6, GREEN, "end")

    # stat_theta / stat_gate
    t_theta = 204 + 544 + 76                    # ATAN 结束
    t_gate = t_theta + 21 + 45 + 3504 + 2       # GATE 结束
    d.band(rows[8], X0, X(t_theta), 0, ORANGE)
    d.band(rows[8], X(t_theta), X(total), 1, ORANGE)
    d.L(X(t_theta), rows[8] - 13, X(t_theta), rows[8] + 11, ORANGE, 1.8)
    d.T(X(t_theta) + 8, rows[8] + 4, "ATAN 后有效", 8.8, ORANGE)
    d.band(rows[9], X0, X(t_gate), 0, BLUE)
    d.band(rows[9], X(t_gate), X(total), 1, BLUE)
    d.L(X(t_gate), rows[9] - 13, X(t_gate), rows[9] + 11, BLUE, 1.8)
    d.T(X(t_gate) + 8, rows[9] + 4, "GATE 后有效", 8.8, BLUE)

    axis_y = rows[-1] + 34
    d.axis(axis_y, X, ticks,
           lambda t: ("%gk" % (t / 1000.0)) if t >= 1000 else str(t),
           lambda t: "%.2f" % (t * 5e-6), "拍 / µs")

    # ── 面板 A：状态色带图例 ──────────────────────────────────────────
    pa = axis_y + 66
    d.R(24, pa, 1176, 100, "#FFFFFF", "#BFBFBF", 1)
    d.T(38, pa + 20, "FSM 状态序列（编号对应上方色带；每段取 RTL 计数上限，标称合计 ≈11k 拍）",
        11.0, INK, "start", "600")
    cols = 7
    cw = 166
    for i, (nm, cyc, col) in enumerate(stages):
        r_, c_ = divmod(i, cols)
        xx = 40 + c_ * cw
        yy = pa + 40 + r_ * 32
        d.R(xx, yy, 15, 15, col, GRAY, 0.8)
        d.T(xx + 5.5, yy + 11.5, str(i + 1), 8.0, INK, "middle")
        d.T(xx + 22, yy + 12, "%s  %s" % (nm, cyc), 9.2, "#404040")

    # ── 面板 B：输出 AXIS 放大 ──────────────────────────────────────
    pb = pa + 130
    d.R(24, pb, 1176, 190, "#FFFFFF", "#BFBFBF", 1)
    d.T(38, pb + 20, "输出 AXIS 字级时序（字 0..255，字间空闲 23 拍）", 11.0, INK, "start", "600")
    X2 = scale(0, 256, 240, 900)
    t2 = [0, 64, 128, 192, 256]
    yl = pb + 36
    for j, (nm, sub) in enumerate([("m_tvalid", "每 24 拍 1 拍高"),
                                   ("m_tdata", "字 0..255"),
                                   ("m_tlast", "第 255 字")]):
        yy = yl + 18 + j * 34
        d.R(24, yy - 15, 216, 30, LGRAY, "#D9D9D9", 1)
        d.T(34, yy - 1, nm, 10.5)
        d.T(34, yy + 12, sub, 8.6, GRAY)
        d.L(240, yy + 15, 900, yy + 15, GRID, 1)
    # tvalid 梳齿：每个字 1 拍高、间距 1 字
    d.L(X2(0), yl + 29, X2(256), yl + 29, ORANGE, 1.4)
    for fn in range(256):
        xx = X2(fn)
        d.L(xx, yl + 18, xx, yl + 29, ORANGE, 1.0)
    d.bus(yl + 52, X2(0) + 2, X2(256) - 2, "字 0..255，每个为 {Q[15:0], I[15:0]} Q4", BUS, ORANGE, 9.0)
    d.band(yl + 86, X2(0), X2(255), 0, GREEN)
    d.L(X2(255), yl + 72, X2(255), yl + 86, GREEN, 2)
    d.T(X2(255) - 6, yl + 68, "TLAST", 8.6, GREEN, "end")
    for t in t2:
        d.L(X2(t), yl - 4, X2(t), yl + 100, GRID, 1)
    d.axis(yl + 104, X2, t2, lambda t: str(t), None, "字序号", x1=900)

    d.note(920, pb + 30, 270, [
        "最差建立时间路径：rr_reg[0] → |rr|/|ri|",
        "+ 56 bit msb 扫描 → scan_v_reg[33]，",
        "4.865 ns、19 级（13×CARRY4），",
        "全设计余量 +0.008 ns。",
        "次差的 9 条路径均位于复数 MAC：",
        "h20p_re_reg[1] → pr0__0/PCIN[0..17]，",
        "3.687 ns。",
        "ATAN：18 迭代 CORDIC；NORM/RECIP/",
        "IDFT 共用 1 个 56 bit 桶形移位器。",
    ], "#FFF2CC", YELLOW, 8.8)

    # ── 面板 C：口径与旁路 ────────────────────────────────────────────
    pc = pb + 210
    d.R(24, pc, 1176, 66, "#F2F2F2", "#BFBFBF", 1)
    d.T(38, pc + 20, "说明：各段取 RTL 计数上限，合计 14,202 拍（71 µs）；取扫描与牛顿迭代平均长度时约 11k 拍（55 µs），均小于 20,320 拍。",
        9.8, "#404040")
    d.T(38, pc + 40, "门控失败或全零帧进入 ST_BYP：按输入顺序旁路 256 字（每拍最多 1 字），跳过 DFT / 倒数 / FIR，stat_gate=0。",
        9.8, "#404040")

    d.finish(path)


# ══════════════════════════════════════════════════════════════════════════
#  05  上下位机通信帧结构（图 2-6）
# ══════════════════════════════════════════════════════════════════════════
def svg_frame(path):
    d = Doc(1240, 804,
            "上下位机通信帧结构（TCP 服务端 :9527）",
            "请求与结果复用同一连接 · 请求 32 B 头 + IQ 负载 · 结果 40 B 头 + k×8 B 条目 · 控制命令 dtype=2 零负载",
            "说明：字段均为小端序；magic = 0x52464649（'RFFI'）；dtype：1 = IQ 数据，2 = 控制命令；top-k 条目按置信度降序。",
            title_size=23, sub_size=12.5)

    HX0, HX1 = 80, 1160

    def fbar(x0, x1, y, h, total, fields):
        xf = scale(0, total, x0, x1)
        t = 0
        for name, sz, col in fields:
            a, b = xf(t), xf(t + sz)
            d.R(a, y, b - a - 1.5, h, col, "#808080", 0.8)
            w = b - a
            if w >= 70:
                d.T((a + b) / 2, y + h / 2 - 3, name, 12.5, INK, "middle")
                d.T((a + b) / 2, y + h / 2 + 13, "%d B" % sz, 10.5, GRAY, "middle")
            elif w >= 44:
                d.T((a + b) / 2, y + h / 2 - 3, name, 10.8, INK, "middle")
                d.T((a + b) / 2, y + h / 2 + 11, "%d B" % sz, 9.6, GRAY, "middle")
            else:
                d.T((a + b) / 2, y + h / 2 + 4, "%dB" % sz, 10.0, INK, "middle")
            t += sz
        return xf

    def ruler(xf, y, fields):
        ticks, s = [0], 0
        for _, sz, _ in fields:
            s += sz
            ticks.append(s)
        d.axis(y, xf, ticks, lambda t: str(t), None, None, x0=HX0, x1=HX1, size=11.5)

    # ── (a) 请求帧 ──────────────────────────────────────────────────────
    d.T(38, 92, "(a) 请求帧（上位机 → 板卡）", 15.0, INK, "start", "600")
    req = [("magic", 4, BLUE2), ("version", 2, GREEN2), ("dtype", 2, YELLOW2),
           ("label", 4, ORANGE2), ("seq", 4, PURPLE2), ("n_complex", 4, "#BDD7EE"),
           ("value_scale", 4, GREEN2), ("timestamp_ns", 8, "#D6DCE4")]
    xf1 = fbar(HX0, HX1, 104, 46, 32, req)
    ruler(xf1, 168, req)
    d.T(28, 186, "字节偏移", 10.2, GRAY)

    # IQ 负载
    d.T(HX0, 214, "0x20", 10.5, GRAY)
    d.T(HX1, 214, "0x20 + 4·n_complex", 10.5, GRAY, "end")
    d.R(HX0, 220, HX1 - HX0, 46, "url(#hatch)", "#A6A6A6", 1)
    d.T((HX0 + HX1) / 2, 248,
        "IQ 负载：n_complex 个复样点 × 4 B（保留原始量纲，归一化由板端完成）",
        12.5, INK, "middle")

    # 复样点交错
    for i in range(4):
        for j, nm in enumerate(("I%d" % i, "Q%d" % i)):
            x = HX0 + (2 * i + j) * 60
            d.R(x, 284, 58, 32, BUS if j == 0 else "#FCE4D6", "#808080", 0.8)
            d.T(x + 29, 305, nm, 12.0, INK, "middle")
    d.T(HX0 + 8 * 60 + 4, 305, "…", 13, GRAY)
    d.T(HX0 + 604, 305, "每个复样点 4 B：I、Q 各 int16，按 I0, Q0, I1, Q1, … 交错",
        11.0, GRAY)

    # ── (b) 结果帧 ──────────────────────────────────────────────────────
    d.T(38, 358, "(b) 结果帧（板卡 → 上位机）", 15.0, INK, "start", "600")
    res = [("magic", 4, BLUE2), ("version", 2, GREEN2), ("status", 2, ORANGE2),
           ("seq", 4, PURPLE2), ("label", 4, "#E4DFEC"), ("n_result", 2, "#FFF2CC"),
           ("top-1", 2, YELLOW2), ("confidence", 4, GREEN2),
           ("latency_us", 4, ORANGE2), ("reserved", 4, "#F2F2F2"),
           ("timestamp_ns", 8, "#D6DCE4")]
    xf2 = fbar(HX0, HX1, 368, 46, 40, res)
    ruler(xf2, 432, res)
    d.T(28, 450, "字节偏移", 10.2, GRAY)

    # top-k 条目
    d.T(HX0, 470, "0x28", 10.5, GRAY)
    d.T(HX1, 470, "0x28 + 8·k", 10.5, GRAY, "end")
    d.R(HX0, 476, HX1 - HX0, 46, "url(#hatch)", "#A6A6A6", 1)
    d.T((HX0 + HX1) / 2, 504,
        "top-k 列表：k 个条目 × 8 B（k = n_result，按置信度降序）", 12.5, INK, "middle")

    d.T(HX0, 552, "单个条目 8 B", 11.0, GRAY)
    entry = [("class_id", 2, ORANGE2), ("保留", 2, "#F2F2F2"),
             ("score（float32）", 4, GREEN2)]
    fbar(HX0, HX0 + 360, 558, 40, 8, entry)
    d.T(HX0 + 380, 582, "类别编号 uint16 + 保留 2 B + 置信度 float32", 11.5, GRAY)

    # ── (c) 控制命令与应答 ──────────────────────────────────────────────
    d.T(38, 632, "(c) 控制命令与应答（插入数据流，不携带 IQ 负载）", 15.0, INK, "start", "600")
    d.R(60, 650, 470, 74, "#FFFFFF", "#808080", 1)
    d.T(76, 674, "控制命令（请求帧）", 13.0, INK, "start", "600")
    d.T(76, 696, "dtype = 2，n_complex = 0，无 IQ 负载", 11.5, "#404040")
    d.T(76, 714, "label / seq 等字段照常填写", 11.5, "#404040")
    d.L(545, 687, 700, 687, YELLOW, 1.8, None, True)
    d.R(710, 650, 470, 74, "#FFFFFF", "#808080", 1)
    d.T(726, 674, "CommandAck（结果帧，k = 0）", 13.0, INK, "start", "600")
    d.T(726, 696, "回显 seq，status = ACK", 11.5, "#404040")
    d.T(726, 714, "不回传 top-k 列表", 11.5, "#404040")

    d.note(38, 744, 1164, [
        "接收侧以 recv_exact 循环读满定长头与负载；magic / version / dtype 与长度校验失败即断开该连接并回到 accept，不做盲目重同步。",
    ], "#F2F2F2", "#BFBFBF", 11.0)

    d.finish(path)


# ══════════════════════════════════════════════════════════════════════════
#  06  上位机软件总体结构（PySide6）
# ══════════════════════════════════════════════════════════════════════════
def svg_host(path):
    d = Doc(1240, 690,
            "上位机软件总体结构（PySide6）",
            "TCP 客户端 :9527 · 数据源统一实现 IQSource · 定时器驱动发送 · 结果按 seq 在途窗口匹配 · 统计发 / 收 / 丢 / 时延",
            "说明：请求帧与结果帧复用同一条 TCP 连接；丢帧数按在途窗口中超时未回填的 seq 统计；端到端时延为结果返回时刻与发送时刻之差。",
            title_size=23, sub_size=12.5)

    def node(x, y, w, h, title, sub, fill=BUS, edge=BLUE, ts=12.5, ss=10.0):
        d.R(x, y, w, h, fill, edge, 1.1, 4)
        d.T(x + w / 2, y + h / 2 - 3, title, ts, INK, "middle", "600")
        d.T(x + w / 2, y + h / 2 + 15, sub, ss, "#404040", "middle")

    # ── 数据源 ─────────────────────────────────────────────────────────
    d.R(40, 110, 240, 370, "#F7F9FC", "#A6A6A6", 1.2, 6, "6,4")
    d.T(54, 140, "数据源（IQSource 接口）", 13.0, INK, "start", "600")
    node(54, 156, 202, 80, "WiSig 本地测试", "本地 IQ 数据回放", BLUE2, BLUE, 13.0, 10.0)
    node(54, 254, 202, 80, "测试集测试", "按测试集样本读取", BLUE2, BLUE, 13.0, 10.0)
    node(54, 352, 202, 80, "轮播测试", "多类样本循环播放", BLUE2, BLUE, 13.0, 10.0)
    d.L(282, 262, 310, 262, BLUE, 1.8, None, True)

    # ── 上位机 ─────────────────────────────────────────────────────────
    d.R(300, 110, 600, 370, "#FFFFFF", INK, 1.6, 6)
    d.T(316, 139, "上位机（PySide6 · TCP 客户端）", 14.0, INK, "start", "600")

    # 发送通路：定时器驱动，按帧率取帧 → 组帧 → BoardLink::send
    node(316, 158, 176, 48, "定时器发送节拍", "主线程 QTimer · 按帧率", YELLOW2, YELLOW, 12.0, 9.6)
    d.L(404, 206, 404, 232, BLUE, 1.6, None, True)
    node(316, 234, 176, 56, "取一帧", "IQSource 接口", BUS, BLUE)
    d.L(492, 262, 504, 262, BLUE, 1.6, None, True)
    node(506, 234, 176, 56, "组帧", "32 B 头 + IQ 负载", BUS, BLUE)
    d.L(682, 262, 694, 262, BLUE, 1.6, None, True)
    node(696, 234, 176, 56, "BoardLink::send", "TCP 整帧发送", GREEN2, GREEN, 12.2, 9.8)

    # 上位机职责
    d.R(316, 312, 280, 54, "#FFFFFF", "#808080", 1, 4, "5,3")
    d.T(328, 336, "自动重连", 12.0, INK, "start", "600")
    d.T(328, 355, "断线退避重连，清空在途请求", 10.0, "#404040")
    d.R(612, 312, 280, 54, "#FFFFFF", "#808080", 1, 4, "5,3")
    d.T(624, 336, "背压保护", 12.0, INK, "start", "600")
    d.T(624, 355, "在途窗口满时暂停取帧", 10.0, "#404040")

    # 接收与匹配通路（右 → 左）
    node(760, 400, 132, 56, "结果拆包", "status / top-k", ORANGE2, ORANGE, 12.0, 9.0)
    node(612, 400, 132, 56, "序列匹配", "在途窗口", PURPLE2, PURPLE, 12.0, 10.0)
    node(464, 400, 132, 56, "统计更新", "发 · 收 · 丢 · 时延", GREEN2, GREEN, 12.0, 9.6)
    node(316, 400, 132, 56, "视图刷新", "卡片数据", YELLOW2, YELLOW, 12.0, 10.0)
    for x1, x2 in ((760, 746), (612, 598), (464, 450)):
        d.L(x1, 428, x2, 428, GREEN, 1.6, None, True)

    # 请求 / 结果（同一条 TCP 连接）
    d.L(872, 262, 946, 262, ORANGE, 1.8, None, True)
    d.T(920, 252, "请求帧", 10.5, ORANGE, "middle")
    d.L(948, 428, 896, 428, GREEN, 1.8, None, True)
    d.T(922, 447, "结果帧", 10.5, GREEN, "middle")

    # ── 板卡 ───────────────────────────────────────────────────────────
    d.R(950, 110, 250, 370, "#FDF2EC", ORANGE, 1.6, 6)
    d.T(966, 140, "板卡", 14.5, INK, "start", "600")
    d.T(966, 160, "TCP 服务端 :9527", 10.5, "#404040")
    d.T(966, 178, "请求 / 结果复用同一连接", 9.8, GRAY)
    node(966, 234, 218, 56, "接收请求帧", "recv_exact 读满", ORANGE2, ORANGE, 12.0, 9.6)
    d.L(1075, 290, 1075, 310, ORANGE, 1.6, None, True)
    d.R(966, 312, 218, 70, "#FFFFFF", ORANGE, 1, 4)
    d.T(1075, 334, "推理", 12.0, INK, "middle", "600")
    d.T(1075, 352, "PL 三路并行", 9.8, "#404040", "middle")
    d.T(1075, 368, "LcwtMLP · expert · lstf_eq", 9.0, GRAY, "middle")
    d.L(1075, 382, 1075, 398, ORANGE, 1.6, None, True)
    node(966, 400, 218, 56, "返回结果帧", "回显 seq / label", ORANGE2, ORANGE, 12.0, 9.6)

    # ── 界面卡片 ───────────────────────────────────────────────────────
    d.L(522, 480, 522, 492, GREEN, 1.8)
    d.L(326, 496, 1110, 496, GREEN, 1.6)
    for cx in (326, 522, 718, 914, 1110):
        d.L(cx, 496, cx, 512, GREEN, 1.4, None, True)
    d.T(534, 490, "视图更新", 10.0, GREEN)

    # 控制栏 → 上位机
    d.L(300, 480, 300, 560, YELLOW, 1.4, "5,3")
    d.L(300, 560, 226, 560, YELLOW, 1.4, "5,3", True)
    d.T(263, 550, "控制命令", 10.0, YELLOW, "middle")

    cards = [("控制栏", "连接 · 帧率 · 数据源 · 启停", YELLOW2, YELLOW),
             ("波形与星座", "IQ 时域 · I/Q 星座", BUS, BLUE),
             ("置信度", "top-1 置信度趋势", GREEN2, GREEN),
             ("Top-k", "类别与分数列表", ORANGE2, ORANGE),
             ("链路状态", "连接 · 重连 · 背压", PURPLE2, PURPLE),
             ("运行记录", "日志与告警", LGRAY, "#808080")]
    for i, (t, s, f, e) in enumerate(cards):
        x = 40 + i * 196
        d.R(x, 516, 180, 92, f, e, 1.2, 5)
        d.T(x + 90, 557, t, 13.5, INK, "middle", "600")
        d.T(x + 90, 578, s, 10.0, "#404040", "middle")

    d.note(40, 628, 1160, [
        "在途窗口以 seq 标识未完成请求，结果返回后按 seq 回填；窗口满时暂停取帧；断线后退避重连并清空未完成请求。",
    ], "#F2F2F2", "#BFBFBF", 11.0)

    d.finish(path)


# ══════════════════════════════════════════════════════════════════════════
#  07  PL-DMA 多通道零拷贝引擎：初始化 / 单轮收发 / udmabuf0 内存布局
# ══════════════════════════════════════════════════════════════════════════
def svg_dma(path):
    d = Doc(1240, 750,
            "PL-DMA 多通道零拷贝引擎架构",
            "初始化 · 单轮 8 帧收发 · udmabuf0 内存映射 · 四路 AXI DMA（1 × MM2S + 3 × S2MM）",
            "说明：偏移与字节数取自 sw/pl_dma_io/pl_dma_io.h；SG / 直读由 dma1 的 DMASR.bit3 在开库时判定；全流程轮询，不依赖中断。",
            title_size=22, sub_size=12.0)

    # ── ① 系统初始化 ────────────────────────────────────────────────────
    d.T(40, 96, "① 系统初始化（进程启动时执行一次）", 14.0, INK, "start", "600")
    init_boxes = [
        ("打开设备与配置", "pl_dma_io_open(cfg)",
         ["cfg：DMA 基址 · 超时 · 帧数",
          "/dev/udmabuf0（≥ 128 KB）",
          "sysfs 读物理基址 buf_phys"]),
        ("映射寄存器窗口", "mmap /dev/mem",
         ["dma0 0x80400000（MM2S）",
          "dma1 0x80410000（dout）",
          "dma2 / dma3 0x80420000 / 0x80430000"]),
        ("映射 udmabuf0", "mmap /dev/udmabuf0",
         ["MAP_LEN = 0x20000（128 KB）",
          "描述符 / 输入 / 三路输出分区",
          "四路 DMA 目标地址互不交叠"]),
        ("探测模式并排空", "DMASR.bit3 · drain",
         ["SG / 直读：按 dma1 判定",
          "dma2 / dma3 仅支持直读",
          "开库时排空三路残留帧"]),
    ]
    for i, (t, s, ls) in enumerate(init_boxes):
        x = 40 + i * 293.3
        d.R(x, 110, 279, 120, BUS, BLUE, 1.2, 5)
        d.T(x + 14, 134, t, 12.5, INK, "start", "600")
        d.T(x + 14, 153, s, 9.8, GRAY)
        for j, l in enumerate(ls):
            d.T(x + 14, 176 + 18 * j, l, 10.0, "#404040")

    # ── ② 单轮批量收发 ──────────────────────────────────────────────────
    d.T(40, 258, "② 单轮批量收发（一轮 = 8 帧，零拷贝、零中间缓冲）", 14.0, INK, "start", "600")
    steps = [
        ("① 拷贝输入", ["memcpy in.dat → SRC", "8192 B = 8 帧 × 1024 B", "sync: FOR_DEVICE"], BUS, BLUE),
        ("② 先挂 S2MM", ["直读：1216 B × 8 次", "SG：8 BD + TAILDESC", "先挂后起，避免半帧"], BUS, BLUE),
        ("③ 再启 MM2S", ["单描述符自环 8192 B", "C_SG_LENGTH_WIDTH=14", "上限 16383 B"], BUS, BLUE),
        ("④ 轮询完成", ["DMASR：IOC / IDLE", "单次 5 s · 整轮 15 s", "错误位 → 立即返回"], YELLOW2, YELLOW),
        ("⑤ 同步并取出", ["sync: FOR_CPU", "memcpy 输出 → 调用者", "仅 exit == 0 时"], ORANGE2, ORANGE),
        ("⑥ 校验并返回", ["实收字节：STATUS / LENGTH", "短包 / 超时 → 自动排空", "eq / 专家随后收"], GREEN2, GREEN),
    ]
    for i, (t, ls, f, e) in enumerate(steps):
        x = 40 + i * 195.67
        d.R(x, 272, 181.7, 100, f, e, 1.2, 5)
        d.T(x + 12, 296, t, 12.2, INK, "start", "600")
        for j, l in enumerate(ls):
            d.T(x + 12, 320 + 17 * j, l, 9.9, "#404040")
        if i < 5:
            d.L(x + 183.7, 322, x + 193.7, 322, BLUE, 1.6, None, True)

    # ── 约束面板 ───────────────────────────────────────────────────────
    cons = [
        ("四路 DMA 分工", [
            "dma0 MM2S → IQ 8192 B（8 帧 × 1024 B）",
            "dma1 S2MM ← dout 9728 B（8 帧 × 1216 B）",
            "dma2 / dma3 S2MM ← eq / 专家 各 8192 B",
            "dma2 / dma3 只收不发，仅支持直读",
        ]),
        ("时序硬约束", [
            "先挂 S2MM 再起 MM2S，否则首帧被切",
            "dout 每帧按 1216 B 挂一次（TLAST 即收工）",
            "热路径不夹 memset / printf / sysfs 同步",
            "流上有数据不复位；MM2S 自环传完立即复位",
        ]),
        ("eq / 专家支路", [
            "eq_recv / expert_recv 须在下一轮 xfer 前",
            "不用时先 drain，否则输出口被反压堵死",
            "收不满 = 给下一轮留存货 → 自动排空",
            "排空角落 0x1BB00 三路共用，不覆盖已收帧",
        ]),
    ]
    for i, (t, ls) in enumerate(cons):
        x = 40 + i * 391
        d.R(x, 392, 377, 110, "#FFFFFF", "#808080", 1, 4, "5,3")
        d.T(x + 14, 416, t, 12.2, INK, "start", "600")
        for j, l in enumerate(ls):
            d.T(x + 14, 440 + 18 * j, l, 10.0, "#404040")

    # ── ③ udmabuf0 内存布局 ─────────────────────────────────────────────
    d.T(40, 526, "③ udmabuf0 内存布局（MAP_LEN = 128 KB，四路 DMA 目标地址互不交叠）",
        14.0, INK, "start", "600")

    # 左侧描述符区放大示意
    d.R(40, 542, 260, 62, LGRAY, "#808080", 1, 4, "5,4")
    d.T(50, 562, "0x00000  MM2S 描述符（64 B）", 9.8, "#404040")
    d.T(50, 580, "0x00100  S2MM 环（8 × 64 B）", 9.8, "#404040")
    d.T(50, 598, "0x00300 起预留至 0x00FFF（放大示意）", 9.4, GRAY)

    # 主区按字节数等比绘制：0x001000 … 0x020000
    MX0, MX1 = 310, 1200
    A0, A1 = 0x1000, 0x20000
    def mxa(a):
        return MX0 + (a - A0) * (MX1 - MX0) / float(A1 - A0)

    regions = [
        (0x1000, 0x10000, BUS, BLUE, "SRC 输入缓冲", "预留 60 KB · 每轮写 8192 B"),
        (0x10000, 0x1C000, ORANGE2, ORANGE, "DST 主接收区（dout）", "预留 48 KB · 每轮收 9728 B"),
        (0x1C000, 0x1E000, GREEN2, GREEN, "EQ", "8 KB"),
        (0x1E000, 0x20000, PURPLE2, PURPLE, "EXP", "8 KB"),
    ]
    for a, b, f, e, t, s in regions:
        xa, xb = mxa(a), mxa(b)
        d.R(xa, 542, xb - xa, 62, f, e, 1.1)
        if xb - xa > 90:
            d.T((xa + xb) / 2, 570, t, 12.0, INK, "middle", "600")
            d.T((xa + xb) / 2, 590, s, 9.8, "#404040", "middle")
        else:
            d.T((xa + xb) / 2, 568, t, 10.5, INK, "middle", "600")
            d.T((xa + xb) / 2, 586, s, 9.4, "#404040", "middle")

    # 排空角落（DST 区尾部）
    xd0, xd1 = mxa(0x1BB00), mxa(0x1C000)
    d.R(xd0, 542, xd1 - xd0, 62, YELLOW, "#808080", 0.8)
    d.T(1200, 534, "排空角落 0x1BB00 · 1216 B", 9.6, YELLOW, "end")
    d.L(xd0 + 3, 534, xd0 + 3, 542, YELLOW, 1, "3,2")

    # 偏移标尺
    d.L(MX0, 618, MX1, 618, INK, 1.4)
    for a in (0x1000, 0x10000, 0x1C000, 0x1E000, 0x20000):
        x = mxa(a)
        d.L(x, 613, x, 623, INK, 1)
    for a, anc in ((0x1000, "middle"), (0x10000, "middle"),
                   (0x1C000, "middle"), (0x20000, "end")):
        d.T(mxa(a), 636, "0x%05X" % a, 11, INK, anc)
    d.T(40, 636, "物理地址偏移（字节）", 10.5, GRAY)

    d.note(40, 654, 1160, [
        "排空角落位于 DST 区尾部（0x1BB00 起 1216 B），由 dout / eq / 专家三路共用，不会覆盖已收帧。",
        "左侧 0x00000–0x00FFF 为放大示意（描述符区 0x00000–0x002FF 仅 768 B，按比例不可见）；其余区域按字节数等比绘制。",
    ], "#F2F2F2", "#BFBFBF", 11.0)

    d.finish(path)


def svg_ps_fusion(path):
    d = Doc(1240, 720,
            "PS 侧预处理与三路融合流程",
            "Q10 量化 · 均衡 IQ 中值 / 反量化 / 5 平移 · token Q4 · 专家特征归一化 · 对数加权融合",
            "说明：全部环节按文案顺序排列；5 个平移样本共用与输入一致的归一化口径；融合为对数域加权 + Softmax。",
            title_size=22, sub_size=12.0)

    def box(x, y, w, h, t, subs, f=BUS, e=BLUE, ts=11.0, ss=9.0):
        d.R(x, y, w, h, f, e, 1.2, 5)
        if subs:
            d.T(x + w / 2, y + 28, t, ts, INK, "middle", "600")
            for j, s in enumerate(subs):
                d.T(x + w / 2, y + 48 + 16 * j, s, ss, "#404040", "middle")
        else:
            d.T(x + w / 2, y + h / 2 + 5, t, ts, INK, "middle", "600")

    # ── ① 原始 IQ 量化与下发 ────────────────────────────────────────────
    d.T(40, 96, "① 原始 IQ 量化与下发", 14.0, INK, "start", "600")
    for i, (t, ss) in enumerate([("原始浮点 IQ", ["基带复数序列"]),
                                 ("Q10 量化", ["模拟 ADC 采样"]),
                                 ("DMA 输入缓冲", ["量化码值写入缓冲"])]):
        x = 40 + i * 400
        box(x, 108, 360, 74, t, ss, BUS, BLUE, 11.8, 9.3)
        if i < 2:
            d.L(x + 362, 145, x + 398, 145, BLUE, 1.6, None, True)

    # ── ② 均衡 IQ 支路 ──────────────────────────────────────────────────
    d.T(40, 206, "② 均衡 IQ 支路：DMA 回传 → Transformer 输入", 14.0, INK, "start", "600")
    steps = [
        ("均衡 IQ 回传", ["DMA 回传"]),
        ("逐元素取中位数", ["Q10 码值"]),
        ("Q10 反量化", ["→ 浮点"]),
        ("归一化", ["与输入同口径"]),
        ("5 个平移样本", ["作为模型输入"]),
        ("Transformer", ["NPU 前向"]),
        ("token 反量化", ["Q4 → 浮点"]),
        ("PS 补归一化", ["开方 / 除法", "常数项叠加"]),
    ]
    for i, (t, ss) in enumerate(steps):
        x = 40 + i * 146
        box(x, 216, 136, 84, t, ss, BUS, BLUE, 10.4, 8.8)
        if i < 7:
            d.L(x + 138, 258, x + 144, 258, BLUE, 1.4, None, True)

    d.callout(543, 314, 300,
              ["多平移融合有助于更充分地", "捕获信号的相位特征"])
    d.L(693, 314, 693, 300, YELLOW, 1.0, "4,3", True)

    # ── ③ 专家特征支路 ──────────────────────────────────────────────────
    d.T(40, 384, "③ 专家特征支路", 14.0, INK, "start", "600")
    ex = [("专家特征", ["特征向量"]),
          ("均值方差归一化", ["(x − μ) / σ"]),
          ("钳位", ["限制幅值"]),
          ("补零", ["补齐长度"])]
    for i, (t, ss) in enumerate(ex):
        x = 40 + i * 260
        box(x, 396, 240, 84, t, ss, GREEN2, GREEN, 11.0, 9.0)
        if i < 3:
            d.L(x + 242, 438, x + 258, 438, GREEN, 1.4, None, True)

    # ── 概率 / 特征汇流 ─────────────────────────────────────────────────
    d.L(1180, 300, 1180, 506, GREEN, 1.6)
    d.L(1180, 506, 250, 506, GREEN, 1.6)
    d.L(250, 506, 250, 542, GREEN, 1.6, None, True)
    d.L(1040, 480, 1040, 506, GREEN, 1.6)
    d.R(1037, 503, 6, 6, GREEN, "none", 0, 3)
    d.T(1172, 320, "输出概率", 9.0, GREEN, "end")
    d.T(1032, 498, "进入融合", 9.0, GREEN, "end")

    # ── ④ 三路输出概率融合 ──────────────────────────────────────────────
    d.T(40, 530, "④ 三路输出概率融合", 14.0, INK, "start", "600")
    fus = [
        (40, 300, "三路输出概率取对数", ["log p1 · log p2 · log p3"], BUS, BLUE),
        (360, 300, "按模型权重线性加权", ["每个模型的权重"], YELLOW2, YELLOW),
        (680, 220, "Softmax", ["→ 类别概率"], GREEN2, GREEN),
        (920, 280, "结果", [], ORANGE2, ORANGE),
    ]
    for i, (x, w, t, ss, f, e) in enumerate(fus):
        box(x, 542, w, 74, t, ss, f, e, 12.0, 9.2)
        if i < 3:
            d.L(x + w + 2, 579, x + w + 18, 579, BLUE, 1.6, None, True)

    d.note(40, 628, 1160, [
        "NPU 不支持开方与除法：归一化改由 PS 完成，常数项叠加至 NPU 输出；专家特征经归一化、钳位与补零后进入融合。",
        "三路输出概率取对数后按各模型权重线性加权，再经 Softmax 得到结果；多平移样本用于增强相位特征。",
    ], "#F2F2F2", "#BFBFBF", 10.4)

    d.finish(path)


if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    svg_system(os.path.join(here, "00_system_timing.svg"))
    svg_stream_buf(os.path.join(here, "01_stream_buf_timing.svg"))
    svg_hls(os.path.join(here, "02_lcwt_hls_timing.svg"))
    svg_expert(os.path.join(here, "03_expert_timing.svg"))
    svg_lstf_eq(os.path.join(here, "04_lstf_eq_timing.svg"))
    svg_frame(os.path.join(here, "05_frame_format.svg"))
    svg_host(os.path.join(here, "06_host_arch.svg"))
    svg_dma(os.path.join(here, "07_dma_arch.svg"))
    svg_ps_fusion(os.path.join(here, "08_ps_fusion.svg"))
    print("written to", here)
