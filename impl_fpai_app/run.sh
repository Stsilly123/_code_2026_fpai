#!/usr/bin/env bash
#
# rffi_deploy 的启停管理脚本（板子上用）。解决三件事：
#   1) 切 tcp / file、切验收预设（融合 / 纯 XF / 纯 PL / 单折）都不用手改 configs ——
#      脚本从 configs/eval_*.yaml 生成 run/active.yaml 再启动，源配置保持原样；
#   2) 后台跑 + pid 文件：SSH 断了不影响，stop 也只由本脚本管；
#   3) 启动失败会自己把日志尾巴打出来，不用再翻文件。
#
#   bash run.sh start tcp --preset fusion   # 融合（默认，部署口径）
#   bash run.sh start tcp --preset xf       # 纯 XF（五折 × 平移 TTA）
#   bash run.sh start tcp --preset pl       # 纯 PL（LcwtMLP）
#   bash run.sh start tcp --preset fold2    # 单折 fold2
#   bash run.sh start tcp                   # 网口模式（上位机连 <板子IP>:9527）
#   bash run.sh start file                  # 离线帧流模式（读 samples/frames.bin）
#   bash run.sh start tcp --port 9600       # 指定端口
#   bash run.sh start file --file samples/frames.bin --topk 3 --print-every 1
#   bash run.sh stop                        # 优雅退出（SIGTERM；10 s 不退再 KILL）
#   bash run.sh restart tcp --preset xf     # 重启（模式/预设可换；不带预设则沿用上次）
#   bash run.sh status                      # pid / 运行时长 / 端口 / 预设 / 最近日志
#   bash run.sh log [-f]                    # 看日志，-f 跟随
#   bash run.sh config                      # 看本次生效的 active.yaml
#   bash run.sh presets                     # 列出可用的验收预设
#
# 退出码：0 正常；1 参数/环境错误；2 启动后立刻挂了。
#
# 注意：所有路径（./imodel/...、./configs/...）都是 **CWD 相对**，脚本会自动
# cd 到仓库根目录再启动，所以你从哪个目录调用都行。

set -euo pipefail

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
bin="$here/build/rffi_deploy"
src_yaml="$here/configs/rffi_transformer.yaml"
preset_dir="$here/configs"

run_dir="$here/run"
active_yaml="$run_dir/active.yaml"
pidfile="$run_dir/rffi_deploy.pid"
logfile="$run_dir/rffi_deploy.log"
# 上一次用的预设（存解析后的绝对路径）；restart 不带 --preset 时沿用它
presetfile="$run_dir/preset"

die()  { printf '\n[ERROR] %s\n' "$*" >&2; exit 1; }
info() { printf '[run] %s\n' "$*"; }
warn() { printf '[warn] %s\n' "$*" >&2; }

# ------------------------------------------------------------------ 进程状态 ---
# pid 文件里的号可能已经被系统回收给别的进程，所以一律核对 cmdline。
pid_is_ours() {
    local pid="${1:-}"
    [ -n "$pid" ] || return 1
    [ -d "/proc/$pid" ] || return 1
    tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null | grep -q 'rffi_deploy'
}

current_pid() {
    local pid=""
    [ -f "$pidfile" ] && pid="$(cat "$pidfile" 2>/dev/null || true)"
    if pid_is_ours "$pid"; then
        printf '%s' "$pid"
        return 0
    fi
    # pid 文件丢了/过期了：按进程名兜底找一个
    pid="$(pgrep -f '[r]ffi_deploy' 2>/dev/null | head -n1 || true)"
    if pid_is_ours "$pid"; then
        printf '%s' "$pid"
        return 0
    fi
    return 1
}

cfg_port() {
    [ -f "$active_yaml" ] || { printf '?'; return; }
    sed -n 's/^[[:space:]]*port:[[:space:]]*\([0-9]\+\).*/\1/p' "$active_yaml" | head -n1
}

cfg_mode() {
    [ -f "$active_yaml" ] || { printf '?'; return; }
    # 只认 input: 段里的 mode（tcp/file）。runtime: 段也有一个 mode:
    # （fast/fusion/analysis），不能拿第一个匹配。
    awk '
        /^[^[:space:]#][^:]*:/ { sect = $0; sub(/:.*/, "", sect) }
        sect == "input" && /^[[:space:]]*mode:/ {
            sub(/^[[:space:]]*mode:[[:space:]]*/, "");
            sub(/[[:space:]].*$/, "");
            print; exit
        }
    ' "$active_yaml"
}

# ---------------------------------------------------------------- 验收预设 ---
# 预设只决定「板端回给上位机哪一路」：fusion / xf / pl / fold2。
# 也接受完整 yaml 路径（例如自己改过的副本），方便临时试参数。
resolve_preset() {
    local p="${1:-fusion}"
    case "$p" in
        fusion)          p="$preset_dir/eval_fusion.yaml" ;;
        xf|xf_only)      p="$preset_dir/eval_xf_only.yaml" ;;
        pl|pl_only)      p="$preset_dir/eval_pl_only.yaml" ;;
        fold2|fold2_only) p="$preset_dir/eval_fold2_only.yaml" ;;
        *)
            # 既接受完整路径（绝对或相对 CWD），也接受 configs/ 下的文件名
            [ -f "$p" ] || p="$preset_dir/$p"
            ;;
    esac
    [ -f "$p" ] || return 1
    printf '%s' "$p"
}

# 路径 -> 短名（也是日志文件名里那一段）
preset_name_of() {
    local p="${1##*/}"
    case "$p" in
        eval_fusion.yaml)     printf 'fusion' ;;
        eval_xf_only.yaml)    printf 'xf' ;;
        eval_pl_only.yaml)    printf 'pl' ;;
        eval_fold2_only.yaml) printf 'fold2' ;;
        *)                    printf '%s' "${p%.yaml}" ;;
    esac
}

# 显示用：当前预设的短名
preset_label() {
    [ -f "$presetfile" ] || { printf '?'; return; }
    local p
    p="$(cat "$presetfile" 2>/dev/null || true)"
    [ -n "$p" ] || { printf '?'; return; }
    preset_name_of "$p"
}

# 每套预设一份日志：四组对比不会互相覆盖，事后能拿板端 top1 和上位机对账。
active_log() {
    local l
    l="$(preset_label)"
    if [ "$l" = "?" ]; then
        printf '%s' "$logfile"
    else
        printf '%s' "$run_dir/rffi_deploy_${l}.log"
    fi
}

cmd_presets() {
    printf '可用预设（板端回给上位机的是哪一路）：\n\n'
    printf '  %-9s %-34s %s\n' 'preset' '含义' '配置文件'
    printf '  %-9s %-34s %s\n' 'fusion' '融合（部署口径，PL 权重 1/3）' 'configs/eval_fusion.yaml'
    printf '  %-9s %-34s %s\n' 'xf'     '纯 XF（五折 × 平移 TTA）'      'configs/eval_xf_only.yaml'
    printf '  %-9s %-34s %s\n' 'pl'     '纯 PL（LcwtMLP int8 QAT）'     'configs/eval_pl_only.yaml'
    printf '  %-9s %-34s %s\n' 'fold2'  '单折 XF（fold2，无五折集成）'  'configs/eval_fold2_only.yaml'
    printf '\n用法： bash run.sh start tcp --preset xf\n'
    local missing=0 p
    for p in eval_fusion eval_xf_only eval_pl_only eval_fold2_only; do
        [ -f "$preset_dir/$p.yaml" ] || { warn "缺文件：configs/$p.yaml"; missing=1; }
    done
    [ "$missing" -eq 0 ] || return 1
}

# ------------------------------------------------------------ 生成 active.yaml ---
# 只在传了覆盖参数时才改那一行；没传的保持原配置。
apply_kv() {
    local key="$1" value="$2"
    [ -n "$value" ] || return 0
    # **只改 input: 段**。runtime: 段里也有 mode:（fast/fusion/analysis），
    # 全局替换会把 runtime.mode 改成 tcp/file，程序启动即报配置错误。
    awk -v k="$key" -v v="$value" '
        /^[^[:space:]#][^:]*:/ { sect = $0; sub(/:.*/, "", sect) }
        sect == "input" && $0 ~ "^[[:space:]]*" k ":" {
            match($0, /^[[:space:]]*/);
            print substr($0, 1, RLENGTH) k ": " v;
            next
        }
        { print }
    ' "$active_yaml" > "$active_yaml.tmp" && mv "$active_yaml.tmp" "$active_yaml"
}

gen_active() {
    local base="$1" mode="$2" port="$3" topk="$4" print_every="$5" idle="$6" sigstd="$7" file="$8"
    [ -f "$base" ] || die "找不到预设配置 $base（bash run.sh presets 看可用的）"
    mkdir -p "$run_dir"
    printf '%s' "$base" > "$presetfile"
    # 头注释写清楚这份 active.yaml 是从哪来的，排查时不用猜
    {
        printf '# 由 run.sh 生成：preset=%s  base=%s\n' "$(preset_name_of "$base")" "$base"
        cat "$base"
    } > "$active_yaml"

    apply_kv mode "$mode"
    apply_kv port "$port"
    apply_kv topk "$topk"
    apply_kv print_every "$print_every"
    apply_kv idle_warn_ms "$idle"
    apply_kv signal_min_std "$sigstd"
    apply_kv file "$file"

    # 兜底校验：模式只能是 tcp / file
    case "$(cfg_mode)" in
        tcp|file) : ;;
        *) die "active.yaml 里的 input.mode 不是 tcp/file（生成了 '$(cfg_mode)'）" ;;
    esac
}

# ----------------------------------------------------------------------- start ---
cmd_start() {
    local mode="${1:-tcp}"
    shift || true

    local port="" topk="" print_every="" idle="" sigstd="" file="" preset="" fg=0 force=0
    while [ $# -gt 0 ]; do
        case "$1" in
            --port)        port="${2:-}";        shift 2 ;;
            --topk)        topk="${2:-}";        shift 2 ;;
            --print-every) print_every="${2:-}"; shift 2 ;;
            --idle)        idle="${2:-}";        shift 2 ;;
            --signal-std)  sigstd="${2:-}";      shift 2 ;;
            --file)        file="${2:-}";        shift 2 ;;
            --preset)      preset="${2:-}";      shift 2 ;;
            --preset=*)    preset="${1#--preset=}"; shift ;;
            -f|--foreground) fg=1;               shift ;;
            --force)       force=1;              shift ;;
            --fusion|--xf|--pl|--fold2)
                die "预设要写成 '--preset ${1#--}'（默认就是 fusion，不用写）" ;;
            *) die "认不出的参数 '$1'（bash run.sh 看用法）" ;;
        esac
    done

    case "$mode" in
        tcp|file) : ;;
        # 常见误用：把预设当成第一个参数写进来
        fusion|xf|pl|fold2|xf_only|pl_only|fold2_only)
            die "第一个参数只能是 tcp 或 file；预设用 --preset，例如：
  bash run.sh start file --preset $mode --file samples/frames.bin" ;;
        *) die "第一个参数只能是 tcp 或 file，收到 '$mode'" ;;
    esac
    local base
    base="$(resolve_preset "$preset")" \
        || die "认不出的预设 '$preset'（bash run.sh presets 看可用的）"
    [ -x "$bin" ] || die "找不到可执行的 $bin —— 先编：bash build.sh -c ZG"

    local pid
    if pid="$(current_pid)"; then
        if [ "$force" -eq 0 ]; then
            warn "已经在跑（pid $pid，mode=$(cfg_mode)，port=$(cfg_port)）"
            warn "要重启用：bash run.sh restart $mode（或加 --force）"
            return 0
        fi
        warn "已经在跑（pid $pid），--force：先停掉"
        stop_pid "$pid" 10
    fi

    gen_active "$base" "$mode" "$port" "$topk" "$print_every" "$idle" "$sigstd" "$file"
    mkdir -p "$run_dir"
    local log
    log="$(active_log)"
    # 同一预设上一轮的日志留一份 .prev，方便对比（不然每次 start 都覆盖掉）
    [ -f "$log" ] && mv -f "$log" "$log.prev" || true

    cd "$here"   # 关键：配置里的路径都是 CWD 相对

    if [ "$fg" -eq 1 ]; then
        info "前台运行：$bin $active_yaml（preset=$(preset_label)，Ctrl-C 退出）"
        exec "$bin" "$active_yaml"
    fi

    nohup "$bin" "$active_yaml" > "$log" 2>&1 &
    pid=$!
    printf '%s' "$pid" > "$pidfile"
    info "已启动 pid=$pid  preset=$(preset_label)  mode=$(cfg_mode)  port=$(cfg_port)  日志 $log"

    # 起来就挂（模型缺失、设备打不开…）要立刻看得见，而不是等你半天后发现没输出
    sleep 2
    if ! pid_is_ours "$pid"; then
        warn "启动后 2 秒内就退出了，最后 25 行日志："
        tail -n 25 "$log" 2>/dev/null || true
        rm -f "$pidfile"
        exit 2
    fi
    tail -n 6 "$log" 2>/dev/null || true
    if [ "$(cfg_mode)" = "tcp" ]; then
        local ip
        ip="$(hostname -I 2>/dev/null | awk '{print $1}' || true)"
        [ -n "$ip" ] || ip="<板子IP>"
        info "在等上位机连 ${ip}:$(cfg_port)"
        info "看实时日志：bash run.sh log -f"
    fi
}

# ------------------------------------------------------------------------ stop ---
stop_pid() {
    local pid="$1" timeout="${2:-10}"
    kill -TERM "$pid" 2>/dev/null || true
    local i=0
    while [ "$i" -lt "$((timeout * 10))" ]; do
        if ! pid_is_ours "$pid"; then
            info "已退出（pid $pid）"
            rm -f "$pidfile"
            return 0
        fi
        sleep 0.1
        i=$((i + 1))
    done
    warn "${timeout}s 没退，强制 KILL（可能卡在 DMA/驱动里，退出汇总会丢）"
    kill -KILL "$pid" 2>/dev/null || true
    sleep 0.5
    rm -f "$pidfile"
    pid_is_ours "$pid" && { warn "pid $pid 仍然存在，请检查 dmesg"; return 1; }
    return 0
}

cmd_stop() {
    local timeout=10
    while [ $# -gt 0 ]; do
        case "$1" in
            --wait) timeout="${2:-10}"; shift 2 ;;
            *) die "认不出的参数 '$1'" ;;
        esac
    done
    local pid
    if ! pid="$(current_pid)"; then
        info "没在跑（或者 pid 文件已经过期），顺手清理"
        rm -f "$pidfile"
        return 0
    fi
    info "停止 pid=$pid（SIGTERM，最多等 ${timeout}s）"
    stop_pid "$pid" "$timeout"
}

# ---------------------------------------------------------------------- status ---
cmd_status() {
    local pid
    if pid="$(current_pid)"; then
        local etime
        etime="$(ps -o etime= -p "$pid" 2>/dev/null | tr -d ' ' || true)"
        printf '状态    : 运行中\n'
        printf 'pid     : %s\n' "$pid"
        printf '运行时长: %s\n' "${etime:-?}"
        printf '预设    : %s\n' "$(preset_label)"
        printf '模式    : %s\n' "$(cfg_mode)"
        printf '端口    : %s\n' "$(cfg_port)"
        printf '配置    : %s\n' "$active_yaml"
        printf '日志    : %s\n' "$(active_log)"
        printf '\n监听：\n'
        if command -v ss >/dev/null 2>&1; then
            ss -ltnp 2>/dev/null | grep -F 'rffi_deploy' || printf '  （没有 LISTEN —— 可能还在初始化）\n'
        elif command -v netstat >/dev/null 2>&1; then
            netstat -ltnp 2>/dev/null | grep -F 'rffi_deploy' || printf '  （没有 LISTEN）\n'
        else
            printf '  （没有 ss/netstat，跳过）\n'
        fi
        printf '\n最近 8 行日志：\n'
        tail -n 8 "$(active_log)" 2>/dev/null || true
    else
        printf '状态    : 未运行\n'
        if [ -f "$active_yaml" ]; then
            printf '上次配置: preset=%s mode=%s port=%s\n' \
                "$(preset_label)" "$(cfg_mode)" "$(cfg_port)"
        fi
        if [ -f "$(active_log)" ]; then
            printf '\n上次运行最后 8 行：\n'
            tail -n 8 "$(active_log)" 2>/dev/null || true
        fi
        return 1
    fi
}

# ------------------------------------------------------------------------- log ---
cmd_log() {
    local follow=0 lines=40
    while [ $# -gt 0 ]; do
        case "$1" in
            -f|--follow) follow=1; shift ;;
            -n) lines="${2:-40}"; shift 2 ;;
            *) die "认不出的参数 '$1'" ;;
        esac
    done
    local log
    log="$(active_log)"
    [ -f "$log" ] || die "还没有日志：$log（先 bash run.sh start tcp --preset <名字>）"
    if [ "$follow" -eq 1 ]; then
        tail -n "$lines" -f "$log"
    else
        tail -n "$lines" "$log"
    fi
}

# ---------------------------------------------------------------------- config ---
cmd_config() {
    [ -f "$active_yaml" ] || die "还没有 $active_yaml（先 bash run.sh start tcp）"
    local base="?"
    [ -f "$presetfile" ] && base="$(cat "$presetfile" 2>/dev/null || true)"
    printf '# 本次生效的配置：%s\n' "$active_yaml"
    printf '# 预设：         %s\n' "$(preset_label)"
    printf '# 预设文件：     %s\n' "$base"
    printf '# 主配置（deployment 真源）：%s\n\n' "$src_yaml"
    cat "$active_yaml"
}

# ------------------------------------------------------------------------ help ---
cmd_help() {
    # 打印文件头的注释块（第 3 行起，到第一条非注释为止），改头部不用再调行号
    awk 'NR >= 3 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"
}

# --------------------------------------------------------------------- restart ---
cmd_restart() {
    # 不带模式参数就沿用上一次的（active.yaml 里那个），没有才落到 tcp
    local mode=""
    if [ $# -gt 0 ] && [ "${1#-}" = "$1" ]; then
        mode="$1"; shift
    fi
    if [ -z "$mode" ]; then
        mode="$(cfg_mode)"
        [ "$mode" = "tcp" ] || [ "$mode" = "file" ] || mode="tcp"
    fi
    # 不带 --preset 就沿用上一次的预设，避免「只想换端口」却退回 fusion
    local a have_preset=0
    for a in "$@"; do
        case "$a" in --preset|--preset=*) have_preset=1 ;; esac
    done
    if [ "$have_preset" -eq 0 ] && [ -f "$presetfile" ]; then
        set -- "$@" --preset "$(cat "$presetfile" 2>/dev/null || true)"
    fi
    cmd_stop --wait 10 || true
    cmd_start "$mode" "$@"
}

# ------------------------------------------------------------------------ main ---
cmd="${1:-help}"
[ $# -gt 0 ] && shift || true
case "$cmd" in
    start)   cmd_start "$@" ;;
    stop)    cmd_stop "$@" ;;
    restart) cmd_restart "$@" ;;
    status)  cmd_status ;;
    log)     cmd_log "$@" ;;
    config)  cmd_config ;;
    presets) cmd_presets ;;
    help|-h|--help) cmd_help ;;
    tcp|file) cmd_start "$cmd" "$@" ;;   # 省略 start 的写法：bash run.sh tcp
    *) die "认不出的子命令 '$cmd'（bash run.sh 看用法）" ;;
esac
