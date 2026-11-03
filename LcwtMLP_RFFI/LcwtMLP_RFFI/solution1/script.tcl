############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project LcwtMLP_RFFI
open_solution "solution1"
set_part {xc7z030ffg676-2} -tool vivado
create_clock -period 5 -name default
set_clock_uncertainty 20%
#source "./LcwtMLP_RFFI/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -format ip_catalog
