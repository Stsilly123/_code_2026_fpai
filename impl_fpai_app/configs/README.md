# 验收预设：不用再手改 YAML

四份配置都由 `rffi_transformer.yaml` 派生，只改了标注的那几行。**换配置不用编辑文件，
换命令行参数 + 重启进程即可**（YAML 只在启动时读一次）。

| 配置 | 返回给上位机的是哪一路 | 改了什么 |
|---|---|---|
| `eval_fusion.yaml` | 融合（部署口径，PL 权重 1/3） | 原样 |
| `eval_xf_only.yaml` | 纯 XF（五折 × 5 平移） | `fusion.pl_weight: 0` |
| `eval_pl_only.yaml` | 纯 PL（PL token + NPU 的 LCWT 头） | `fusion.pl_weight: 1` |
| `eval_fold2_only.yaml` | 单折 XF（fold2） | `pl_weight: 0`、`fused_folds: 0`、`models` 只装 `fold2_b5_ZG` |

```bash
./rffi_deploy configs/eval_fusion.yaml        # 融合
./rffi_deploy configs/eval_xf_only.yaml       # 纯 XF
./rffi_deploy configs/eval_pl_only.yaml       # 纯 PL
./rffi_deploy configs/eval_fold2_only.yaml    # 单折 fold2
```

板子上用 `run.sh` 更省事（后台运行、每套预设单独一份日志，四组对比不互相覆盖）：

```bash
bash run.sh start tcp --preset fusion   # 或 xf / pl / fold2
bash run.sh restart tcp --preset xf     # 换一路；不带 --preset 则沿用上次
bash run.sh status                      # 看当前预设 / 端口 / 日志路径
bash run.sh log -f                      # 当前预设的实时日志
bash run.sh presets                     # 列出预设
```

## 两条注意

1. **`pl_weight=0` 不等于 PL 不跑。** XF 的输入是 PL 的 dma2 均衡输出，PL 必须开着；
   这两份配置只改「返回哪一路」，不省 PL 的时间。`pl_weight=1` 时 XF 仍会跑（结果被乘 0）。
2. **单折配置只装了 fold2。** 换折改 `models` 里那两行（`fold0_b5_ZG` … `fold4_b5_ZG`）；
   b5 图的输入 batch 是 5，`xf.shifts` 必须保持 5 个，少一个启动就报错。

## 改完主配置怎么办

`rffi_transformer.yaml` 是部署口径的唯一真源。改了它以后，用派生脚本重新生成：

```bash
python tools/make_eval_configs.py
```
