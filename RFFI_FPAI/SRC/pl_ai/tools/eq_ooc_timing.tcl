# 只综合 lstf_eq 本身（OOC），看逻辑层级/资源；不碰整版工程。
# 用法：D:/Xilinx/Vivado/2018.3/bin/vivado -notrace -mode batch -source eq_ooc_timing.tcl
set root "D:/FPGA/FPGA/FPAI_PL/RFFI_FPAI"
set src  "$root/SRC/pl_ai/lstf_eq.v"
set out  "$root/SRC/pl_ai/tools/eq_ooc"
file mkdir $out

read_verilog $src
synth_design -top lstf_eq -part xc7z030ffg676-2 -mode out_of_context -flatten_hierarchy rebuilt
create_clock -name clk -period 5.000 [get_ports clk]

report_utilization -file $out/util_synth.rpt
report_timing_summary -max_paths 20 -file $out/timing_synth.rpt
report_timing -max_paths 10 -delay_type max -sort_by slack -file $out/timing_paths.rpt

write_checkpoint -force $out/eq_synth.dcp
puts "==== OOC synth done: $out ===="
