open_checkpoint D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI/proj_csynth/sol_csynth/ooc_rpt/post_synth.dcp
set luts [get_cells -quiet -hier -filter {REF_NAME =~ LUT* && IS_PRIMITIVE == 1}]
set i 0
foreach c $luts {
  set nm [get_property NAME $c]
  if {[string match "gsum_0_V*" $nm]} { puts $nm; incr i; if {$i>12} break }
}
puts "---regs---"
set ffs [get_cells -quiet -hier -filter {REF_NAME =~ FD* && IS_PRIMITIVE == 1}]
set i 0
foreach c $ffs {
  set nm [get_property NAME $c]
  if {[string match "gsum_0_V*" $nm]} { puts $nm; incr i; if {$i>8} break }
}
exit
