# Re-synthesize solution1 from the current sources and export the IP catalogue.
# Run from D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI:
#   D:/Xilinx/Vivado/2018.3/bin/vivado_hls.bat -f LcwtMLP_RFFI/export_ip.tcl
#
# The old vivado_hls.app is stale (no file list, no top), so this opens a fresh
# project.  The solution is named "solution1" so the usual pack_ip.tcl paths
# apply.
#
# Expected failure at the end:
#   ERROR: [IMPL 213-28] Failed to generate IP.
# This is Vivado HLS 2018.3's core_revision date overflow (YYMMDDHHMM as a
# 10-digit int > INT32_MAX), unrelated to the design.  RTL is already written.
# After this script, run pack_ip.tcl to patch and re-pack.
#
# vivado_hls.bat returns exit code 0 even on failure -- grep the log for
# "ERROR" and for "error deleting".
open_project -reset proj_export
set_top LcwtMLP_RFFI
add_files LcwtMLP_RFFI/SRC/top.cpp
add_files LcwtMLP_RFFI/SRC/pl_lcwt.cpp
add_files LcwtMLP_RFFI/SRC/top.hpp
add_files LcwtMLP_RFFI/SRC/pl_lcwt.hpp
add_files LcwtMLP_RFFI/SRC/pl_lcwt_config.hpp
add_files LcwtMLP_RFFI/SRC/pl_lcwt_weights.hpp
open_solution "solution1"
set_part {xc7z030ffg676-2} -tool vivado
create_clock -period 5 -name default
set_clock_uncertainty 20%
csynth_design
export_design -rtl verilog -format ip_catalog
exit
