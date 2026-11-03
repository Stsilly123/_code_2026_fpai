# Bucket LUT cells by keyword in the cell name (OOC post-synth netlist).
open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp

set luts [get_cells -quiet -hier -filter {REF_NAME =~ LUT* && IS_PRIMITIVE == 1}]
array unset h
set n 0
foreach c $luts {
    incr n
    set nm [get_property NAME $c]
    set hit "ZZZ_other"
    foreach k {amax tsum vv_ acc_ tokT_V lnT_V lns_V gels_V pres_ fc2s_ gps_ lcwt LCWT hr_V hi_V lr_V li_V s1 s2 pj_ gap_ logits_ udiv isqrt bitlen gelu mux_} {
        if {[string match -nocase "*${k}*" $nm]} { set hit $k; break }
    }
    if {![info exists h($hit)]} { set h($hit) 0 }
    incr h($hit)
}
puts "TOTAL LUT cells = $n"
foreach {k v} [array get h] { puts "  $v  $k" }
exit
