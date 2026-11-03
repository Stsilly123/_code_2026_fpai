# C simulation for the WaveMLP PL design.
# Run from D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI:
#   D:/Xilinx/Vivado/2018.3/bin/vivado_hls.bat -f LcwtMLP_RFFI/lcwt_csim.tcl
# NOTE: vivado_hls.bat returns exit code 0 even on failure -- grep the log for
# "ERROR" (and the csim report for "**PASS**"), never trust $?.
open_project -reset proj_csim
set_top LcwtMLP_RFFI
add_files LcwtMLP_RFFI/SRC/top.cpp
add_files LcwtMLP_RFFI/SRC/pl_lcwt.cpp
add_files -tb LcwtMLP_RFFI/SRC/tb/tb_lcwt.cpp
add_files LcwtMLP_RFFI/SRC/top.hpp
add_files LcwtMLP_RFFI/SRC/pl_lcwt.hpp
add_files LcwtMLP_RFFI/SRC/pl_lcwt_config.hpp
add_files LcwtMLP_RFFI/SRC/pl_lcwt_weights.hpp
open_solution "sol_csim"
set_part {xc7z030ffg676-2} -tool vivado
create_clock -period 5 -name default
set_clock_uncertainty 20%
csim_design
exit
