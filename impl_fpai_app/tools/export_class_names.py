"""把 `data_cache/meta.npz` 里的 150 个发射机名导成 `names/class_names.txt`。

板子只认「第 k 行 = 类别 k」这个纯文本约定，不需要 numpy，也就不需要把
meta.npz 一起搬上板。

类别名**不是** `0..149`：`prepare_data.py` 用的是原始 pkl 的 `tx_list` 顺序，
形如 `['1-1', '1-10', '1-11', ...]`。只影响控制台显示，不影响 argmax。

用法::

    ./transformer_4_rf/Scripts/python.exe tools/export_class_names.py
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np

_APP = Path(__file__).resolve().parents[1]


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    ap = argparse.ArgumentParser(description="导出类别名到 names/class_names.txt")
    ap.add_argument(
        "--meta",
        default=str(_APP.parent / "Transformer_Train" / "data_cache" / "meta.npz"),
        help="meta.npz 路径（含 class_names）",
    )
    ap.add_argument("--out", default=str(_APP / "names" / "class_names.txt"))
    args = ap.parse_args()

    meta_path = Path(args.meta)
    if not meta_path.exists():
        raise SystemExit(f"找不到 {meta_path}")

    m = np.load(meta_path, allow_pickle=True)
    if "class_names" not in m:
        raise SystemExit(f"{meta_path} 里没有 class_names 键（只有 {sorted(m.keys())}）")
    names = [str(x) for x in m["class_names"]]
    n_cls = int(m["num_classes"]) if "num_classes" in m else len(names)
    if len(names) != n_cls:
        raise SystemExit(f"class_names 有 {len(names)} 个，num_classes 说 {n_cls} 个")

    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(names) + "\n", encoding="utf-8")
    print(f"写 {out}：{len(names)} 行")
    print(f"  前 6 行 {names[:6]}")
    print(f"  末 3 行 {names[-3:]}")


if __name__ == "__main__":
    main()
