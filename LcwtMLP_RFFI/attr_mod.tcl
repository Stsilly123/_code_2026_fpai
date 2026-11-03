# Bucket LUT cells by first sub-hierarchy component (the HLS core instance).
open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp
set luts [get_cells -quiet -hier -filter {REF_NAME =~ LUT* && IS_PRIMITIVE == 1}]
array unset h
set n 0
foreach c $luts {
    incr n
    set nm [get_property NAME $c]
    set parts [split $nm "/"]
    if {[llength $parts] > 1} {
        # strip the trailing _U\d+ instance tag so identical cores merge
        set m [lindex $parts 1]
        regsub {_U[0-9]+$} $m {} m
    } else {
        set m "TOP_LEVEL_LOGIC"
    }
    if {![info exists h($m)]} { set h($m) 0 }
    incr h($m)
}
puts "TOTAL LUT cells = $n"
foreach {k v} [array get h] { lappend out [list $k $v] }
foreach e [lsort -integer -decreasing -index 1 $out] {
    puts "  [lindex $e 1]  [lindex $e 0]"
}
exit
