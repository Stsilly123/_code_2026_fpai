# Attribute LUTs to source-level signal stems in the OOC post-synth netlist.
open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp

set luts [get_cells -quiet -hier -filter {REF_NAME =~ LUT* && IS_PRIMITIVE == 1}]
array unset h
set n 0
foreach c $luts {
    incr n
    set nm [get_property NAME $c]
    # strip leaf + bus suffix, then trailing _i_N / _reg etc.
    set stem $nm
    regsub {\[[0-9]+\]$} $stem {} stem
    regsub {(_i_[0-9]+)+$} $stem {} stem
    regsub {_[0-9]+$} $stem {} stem
    if {![info exists h($stem)]} { set h($stem) 0 }
    incr h($stem)
}
puts "TOTAL LUT cells = $n"
foreach {k v} [array get h] { lappend out [list $k $v] }
set shown 0
foreach e [lsort -integer -decreasing -index 1 $out] {
    puts "  [lindex $e 1] [lindex $e 0]"
    incr shown
    if {$shown > 60} break
}
exit
