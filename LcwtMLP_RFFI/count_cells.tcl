# Primitive histograms on the OOC post-synth checkpoint.
open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp

proc hist_under {name} {
    if {$name eq ""} {
        set cells [get_cells -quiet -hier -filter "IS_PRIMITIVE == 1"]
        set tag "ALL"
    } else {
        set cells [get_cells -quiet -hier -filter "NAME =~ ${name}/*"]
        set tag $name
    }
    array unset h
    foreach c $cells {
        set r [get_property REF_NAME $c]
        if {![info exists h($r)]} { set h($r) 0 }
        incr h($r)
    }
    puts "HIST $tag total=[llength $cells]"
    set out {}
    foreach {k v} [array get h] { lappend out [list $k $v] }
    foreach e [lsort -integer -decreasing -index 1 $out] { puts "  [lindex $e 0] [lindex $e 1]" }
}

hist_under ""
hist_under "lr_V_U"
hist_under "LcwtMLP_RFFI_mux_c6D_U61"
exit
