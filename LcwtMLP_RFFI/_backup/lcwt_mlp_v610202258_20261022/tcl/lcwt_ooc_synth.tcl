# Out-of-context synthesis of a csynth'd WaveMLP solution.
# Gives the true LUT / FF / BRAM / DSP and the true WNS, which the csynth
# Utilization/Timing tables cannot give (csynth DSP for conv-like structures is
# systematically low -- measured 1.6-1.8x on the CNN project).
#
# Run from D:/FPGA/FPGA/FPAI_PL/HLS/:
#   D:/Xilinx/Vivado/2018.3/bin/vivado -notrace -mode batch \
#       -source LcwtMLP_RFFI/LcwtMLP_RFFI/lcwt_ooc_synth.tcl -tclargs sol_csynth
#
# Reports land in <proj>/<sol>/ooc_rpt/ (NOT under impl/, which csynth wipes).

set root [file normalize [file dirname [info script]]]
set projdir [file normalize "$root/.."]

set sol "sol_csynth"
if {[llength $argv] >= 1} { set sol [lindex $argv 0] }

set solroot "$projdir/$sol"
if {![file exists $solroot]} { set solroot "$projdir/proj_csynth/$sol" }

set srcdir ""
foreach cand [list "$solroot/syn/verilog" "$solroot/impl/verilog"] {
    if {[file exists $cand]} { set srcdir $cand; break }
}
if {$srcdir eq ""} {
    puts "!!! no RTL dir under $solroot -- run csynth first"
    exit 1
}

set outdir "$solroot/ooc_rpt"
file mkdir $outdir

puts "=== OOC synth: solution=$sol  src=$srcdir ==="

create_project -in_memory -part xc7z030ffg676-2
set_property target_language Verilog [current_project]

set vfiles [glob -nocomplain "$srcdir/*.v"]
puts "=== reading [llength $vfiles] verilog files ==="
read_verilog $vfiles

set xdc "$root/lcwt_ooc.xdc"
read_xdc $xdc
puts "=== read_xdc $xdc ==="

synth_design -top LcwtMLP_RFFI -part xc7z030ffg676-2
write_checkpoint -force "$outdir/post_synth.dcp"

report_utilization -file "$outdir/util_flat.rpt"
report_utilization -hierarchical -hierarchical_depth 3 -file "$outdir/util_hier.rpt"
report_timing_summary -delay_type max -file "$outdir/timing.rpt"
report_timing -delay_type max -max_paths 25 -file "$outdir/timing_paths.rpt"

puts "=== OOC synth DONE ($sol), reports in $outdir ==="
exit
