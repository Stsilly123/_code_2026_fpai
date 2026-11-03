open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp
set luts [get_cells -quiet -hier -filter {REF_NAME =~ LUT* && IS_PRIMITIVE == 1}]
array unset h
foreach c $luts {
  set nm [get_property NAME $c]
  if {![string match "*lr_V_ram_U*" $nm]} continue
  regsub {\[[0-9]+\]$} $nm {} s
  regsub {_[0-9]+$} $s {} s
  if {![info exists h($s)]} { set h($s) 0 }
  incr h($s)
}
foreach {k v} [array get h] { lappend o [list $k $v] }
set i 0
foreach e [lsort -integer -decreasing -index 1 $o] { puts "  [lindex $e 1]  [lindex $e 0]"; incr i; if {$i>15} break }
exit
