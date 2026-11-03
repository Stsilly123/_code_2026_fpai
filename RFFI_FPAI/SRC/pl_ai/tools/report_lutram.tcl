# 只读：统计 OOC 综合 DCP 里的分布式 RAM（LUTRAM）分布在哪个子模块。
# 不综合、不改工程。
set dcp "D:/FPGA/FPGA/FPAI_PL/RFFI_FPAI/RFFI_FPAI.runs/ps_ai_Signal_process_0_0_synth_1/ps_ai_Signal_process_0_0.dcp"
set rpt "D:/FPGA/FPGA/FPAI_PL/RFFI_FPAI/SRC/pl_ai/tools/lutram_signal_process.rpt"
open_checkpoint $dcp
report_utilization -hierarchical -hierarchical_depth 6 -file $rpt

puts "==== LUTRAM primitives by parent ===="
set prims {RAMS32 RAMS64 RAMS128 RAMS256 RAM32X1S RAM32X1D RAM64X1S RAM64X1D RAM128X1S RAM128X1D RAM256X1S RAM512X1S}
array set cnt {}
foreach p $prims {
    set cs [get_cells -hier -quiet -filter "REF_NAME == $p"]
    foreach c $cs {
        set par [get_property PARENT $c]
        if {[info exists cnt($par)]} { incr cnt($par) } else { set cnt($par) 1 }
    }
}
set out {}
foreach k [array names cnt] { lappend out [list $cnt($k) $k] }
foreach e [lsort -integer -decreasing -index 0 $out] {
    puts [format "%6d  %s" [lindex $e 0] [lindex $e 1]]
}
puts "==== total ===="
set tot 0
foreach k [array names cnt] { incr tot $cnt($k) }
puts "LUTRAM cells: $tot"
close_design
