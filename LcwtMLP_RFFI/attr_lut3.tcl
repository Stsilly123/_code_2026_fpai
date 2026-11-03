open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp
set luts [get_cells -quiet -hier -filter {REF_NAME =~ LUT* && IS_PRIMITIVE == 1}]
array unset h
array unset hh
foreach c $luts {
    set nm [get_property NAME $c]
    if {[string match -nocase "*lcwt*" $nm]} {
        set stem $nm
        regsub {\[[0-9]+\]$} $stem {} stem
        regsub {(_i_[0-9]+)+$} $stem {} stem
        regsub {_[0-9]+$} $stem {} stem
        if {![info exists h($stem)]} { set h($stem) 0 }
        incr h($stem)
        # also module-ish prefix
        set pre [lindex [split $nm "/"] 0]
        if {![info exists hh($pre)]} { set hh($pre) 0 }
        incr hh($pre)
    }
}
puts "== by top module =="
foreach {k v} [array get hh] { lappend o1 [list $k $v] }
foreach e [lsort -integer -decreasing -index 1 $o1] { puts "  [lindex $e 1]  [lindex $e 0]" }
puts "== by stem (top 40) =="
foreach {k v} [array get h] { lappend o2 [list $k $v] }
set i 0
foreach e [lsort -integer -decreasing -index 1 $o2] {
    puts "  [lindex $e 1]  [lindex $e 0]"
    incr i; if {$i > 40} break
}
exit
