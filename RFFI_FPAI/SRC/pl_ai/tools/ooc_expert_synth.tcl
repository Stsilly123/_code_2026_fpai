# -----------------------------------------------------------------------------
# ooc_expert_synth.tcl : expert_feat_rffi 单独综合（out-of-context）
#
#   只综合专家特征提取模块，不动主工程、不动 BD。
#   用法（2018.3）：
#     vivado -mode batch -source SRC/pl_ai/tools/ooc_expert_synth.tcl
#   结果：<repo>/ef_ooc/ 下的 util / timing 报告
# -----------------------------------------------------------------------------
set script_dir [file normalize [file dirname [info script]]]
set root       [file normalize [file join $script_dir .. .. ..]]
set src        [file join $root SRC pl_ai]
set exdir      [file join $src expert]
set ipdir      [file join $root RFFI_FPAI.srcs sources_1 ip]
set outdir     [file join $root ef_ooc]

file mkdir $outdir
set part xc7z030ffg676-2

create_project -in_memory -part $part

set_property include_dirs [list $exdir] [get_filesets sources_1]

add_files -norecurse [glob [file join $exdir *.v]]
add_files -norecurse [file join $exdir cordic_vl.vhd]

add_files -norecurse [file join $ipdir xfft_256 xfft_256.xci]
add_files -norecurse [file join $ipdir cordic_0 cordic_0.xci]
add_files -norecurse [file join $ipdir log2_lut_rom log2_lut_rom.xci]
set_property top expert_feat_rffi [current_fileset]

# 200 MHz，I/O 按外部已寄存处理
set xdc [file join $outdir ooc_expert.xdc]
set fh [open $xdc w]
puts $fh "create_clock -period 5.000 -name sclk \[get_ports clk\]"
# XDC 文件里不能用 remove_from_collection（Designutils 20-1307，整行会被丢掉），
# 用 get_ports 的 filter 排除时钟口。
puts $fh "set_input_delay  -clock sclk 0.500 \[get_ports -filter {NAME != \"clk\"}\]"
puts $fh "set_output_delay -clock sclk 0.500 \[all_outputs\]"
close $fh
add_files -fileset constrs_1 -norecurse $xdc

synth_design -top expert_feat_rffi -mode out_of_context -directive Default

report_utilization -file [file join $outdir util.rpt]
report_utilization -hierarchical -hierarchical_depth 2 -file [file join $outdir util_hier.rpt]
report_timing_summary -delay_type max -file [file join $outdir timing.rpt]
report_timing -delay_type max -max_paths 20 -file [file join $outdir timing_paths.rpt]
report_timing -delay_type max -max_paths 200 -nworst 1 -file [file join $outdir timing_paths200.rpt]
write_checkpoint -force [file join $outdir expert_ooc.dcp]

# ---- 实现（仍是 out-of-context）---------------------------------------------
# 综合后的路由是「未布局」估算，偏差很大（高扇出网动辄 0.5~0.6 ns/段）。
# 在 OOC 里再跑一遍 opt/place/route，拿到的 WNS 才是这块逻辑在 200 MHz 下的真实值。
# 注意：这里只实现专家模块自己，不是整个工程。
opt_design
place_design
route_design
report_utilization -file [file join $outdir util_impl.rpt]
report_utilization -hierarchical -hierarchical_depth 2 -file [file join $outdir util_hier_impl.rpt]
report_timing_summary -delay_type max -file [file join $outdir timing_impl.rpt]
report_timing -delay_type max -max_paths 100 -file [file join $outdir timing_paths_impl.rpt]
write_checkpoint -force [file join $outdir expert_ooc_routed.dcp]

puts "==== OOC SYNTH+IMPL DONE ===="
