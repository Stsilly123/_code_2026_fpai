open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp
set luts [get_cells -quiet -hier -filter {REF_NAME =~ LUT* && IS_PRIMITIVE == 1}]
array unset h
set n 0
foreach c $luts {
  set nm [get_property NAME $c]
  if {![string match "*lr_V_ram_U*" $nm]} continue
  incr n
  set s $nm
  regsub {\[[0-9]+\]$} $s {} s
  regsub {_[0-9]+$} $s {} s
  if {![info exists h($s)]} { set h($s) 0 }
  incr h($s)
}
puts "MATCHED = $n"
set o {}
foreach {k v} [array get h] { lappend o [list $v $k] }
set i 0
set acc 0
foreach e [lsort -integer -decreasing -index 0 $o] {
  puts "  [lindex $e 0]  [lindex $e 1]"
  incr i; if {$i >= 18} break
}
exit
