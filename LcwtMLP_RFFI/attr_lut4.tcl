open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp
set luts [get_cells -quiet -hier -filter {REF_NAME =~ LUT* && IS_PRIMITIVE == 1}]
foreach key {gps_ logits_} {
    array unset h
    foreach c $luts {
        set nm [get_property NAME $c]
        if {![string match -nocase "*${key}*" $nm]} continue
        set stem $nm
        regsub {\[[0-9]+\]$} $stem {} stem
        regsub {(_i_[0-9]+)+$} $stem {} stem
        regsub {_[0-9]+$} $stem {} stem
        if {![info exists h($stem)]} { set h($stem) 0 }
        incr h($stem)
    }
    puts "===== $key ====="
    foreach {k v} [array get h] { lappend o [list $k $v] }
    set i 0
    foreach e [lsort -integer -decreasing -index 1 $o] {
        puts "  [lindex $e 1]  [lindex $e 0]"
        incr i; if {$i > 15} break
    }
    unset o
}
exit
