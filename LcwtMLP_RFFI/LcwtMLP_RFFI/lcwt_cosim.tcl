# C/RTL co-simulation for the WaveMLP PL design.
# Run from D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI:
#   D:/Xilinx/Vivado/2018.3/bin/vivado_hls.bat -f LcwtMLP_RFFI/lcwt_cosim.tcl
#
# Uses the already-synthesised RTL in proj_export/solution1 (same sources as the
# delivered IP), so no re-synthesis is triggered.  The testbench is the same
# tb_lcwt.cpp that passes csim.
#
# NOTE: vivado_hls.bat returns exit code 0 even on failure -- grep the log for
# "ERROR" and for "**PASS**" / "**FAIL**".
open_project proj_export
set_top LcwtMLP_RFFI
add_files -tb LcwtMLP_RFFI/SRC/tb/tb_lcwt.cpp
open_solution "solution1"
set_part {xc7z030ffg676-2} -tool vivado
create_clock -period 5 -name default
set_clock_uncertainty 20%
cosim_design -rtl verilog -tool xsim
exit
