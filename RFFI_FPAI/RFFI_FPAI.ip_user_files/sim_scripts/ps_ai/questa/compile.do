vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/generic_baseblocks_v2_1_0
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_register_slice_v2_1_18
vlib questa_lib/msim/fifo_generator_v13_2_3
vlib questa_lib/msim/axi_data_fifo_v2_1_17
vlib questa_lib/msim/axi_crossbar_v2_1_19
vlib questa_lib/msim/lib_cdc_v1_0_2
vlib questa_lib/msim/proc_sys_reset_v5_0_13
vlib questa_lib/msim/axi_vip_v1_1_4
vlib questa_lib/msim/processing_system7_vip_v1_0_6
vlib questa_lib/msim/util_vector_logic_v2_0_1
vlib questa_lib/msim/xlconcat_v2_1_1
vlib questa_lib/msim/lib_pkg_v1_0_2
vlib questa_lib/msim/lib_fifo_v1_0_12
vlib questa_lib/msim/lib_srl_fifo_v1_0_2
vlib questa_lib/msim/axi_datamover_v5_1_20
vlib questa_lib/msim/axi_sg_v4_1_11
vlib questa_lib/msim/axi_dma_v7_1_19
vlib questa_lib/msim/xlconstant_v1_1_5
vlib questa_lib/msim/smartconnect_v1_0
vlib questa_lib/msim/axi_protocol_converter_v2_1_18

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap generic_baseblocks_v2_1_0 questa_lib/msim/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_18 questa_lib/msim/axi_register_slice_v2_1_18
vmap fifo_generator_v13_2_3 questa_lib/msim/fifo_generator_v13_2_3
vmap axi_data_fifo_v2_1_17 questa_lib/msim/axi_data_fifo_v2_1_17
vmap axi_crossbar_v2_1_19 questa_lib/msim/axi_crossbar_v2_1_19
vmap lib_cdc_v1_0_2 questa_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 questa_lib/msim/proc_sys_reset_v5_0_13
vmap axi_vip_v1_1_4 questa_lib/msim/axi_vip_v1_1_4
vmap processing_system7_vip_v1_0_6 questa_lib/msim/processing_system7_vip_v1_0_6
vmap util_vector_logic_v2_0_1 questa_lib/msim/util_vector_logic_v2_0_1
vmap xlconcat_v2_1_1 questa_lib/msim/xlconcat_v2_1_1
vmap lib_pkg_v1_0_2 questa_lib/msim/lib_pkg_v1_0_2
vmap lib_fifo_v1_0_12 questa_lib/msim/lib_fifo_v1_0_12
vmap lib_srl_fifo_v1_0_2 questa_lib/msim/lib_srl_fifo_v1_0_2
vmap axi_datamover_v5_1_20 questa_lib/msim/axi_datamover_v5_1_20
vmap axi_sg_v4_1_11 questa_lib/msim/axi_sg_v4_1_11
vmap axi_dma_v7_1_19 questa_lib/msim/axi_dma_v7_1_19
vmap xlconstant_v1_1_5 questa_lib/msim/xlconstant_v1_1_5
vmap smartconnect_v1_0 questa_lib/msim/smartconnect_v1_0
vmap axi_protocol_converter_v2_1_18 questa_lib/msim/axi_protocol_converter_v2_1_18

vlog -work xilinx_vip -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_18 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/cc23/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_3 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/64f4/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_3 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/64f4/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_3 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/64f4/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_17 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/c4fd/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_19 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/6c9d/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_xbar_0/sim/ps_ai_xbar_0.v" \
"../../../bd/ps_ai/ip/ps_ai_xbar_1/sim/ps_ai_xbar_1.v" \
"../../../bd/ps_ai/ip/ps_ai_xbar_2/sim/ps_ai_xbar_2.v" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/ps_ai/ip/ps_ai_proc_sys_reset_0_0/sim/ps_ai_proc_sys_reset_0_0.vhd" \
"../../../bd/ps_ai/ip/ps_ai_proc_sys_reset_1_0/sim/ps_ai_proc_sys_reset_1_0.vhd" \

vlog -work axi_vip_v1_1_4 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/98af/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_6 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_processing_system7_0_0/sim/ps_ai_processing_system7_0_0.v" \

vlog -work util_vector_logic_v2_0_1 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/2137/hdl/util_vector_logic_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_util_vector_logic_0_0/sim/ps_ai_util_vector_logic_0_0.v" \

vlog -work xlconcat_v2_1_1 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/2f66/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_xlconcat_0_0/sim/ps_ai_xlconcat_0_0.v" \
"../../../bd/ps_ai/sim/ps_ai.v" \

vcom -work lib_pkg_v1_0_2 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_fifo_v1_0_12 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/544a/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_20 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/dfb3/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_11 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/efa7/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_19 -64 -93 \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/09b0/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/ps_ai/ip/ps_ai_axi_dma_0_1/sim/ps_ai_axi_dma_0_1.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_Signal_process_0_0/sim/ps_ai_Signal_process_0_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/ps_ai/ip/ps_ai_axi_dma_1_0/sim/ps_ai_axi_dma_1_0.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/sim/bd_e437.v" \

vlog -work xlconstant_v1_1_5 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/4649/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_0/sim/bd_e437_one_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_1/sim/bd_e437_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/c012/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_2/sim/bd_e437_arinsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_3/sim/bd_e437_rinsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_4/sim/bd_e437_awinsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_5/sim/bd_e437_winsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_6/sim/bd_e437_binsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_7/sim/bd_e437_aroutsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_8/sim/bd_e437_routsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_9/sim/bd_e437_awoutsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_10/sim/bd_e437_woutsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_11/sim/bd_e437_boutsw_0.sv" \

vlog -work smartconnect_v1_0 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_12/sim/bd_e437_arni_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_13/sim/bd_e437_rni_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_14/sim/bd_e437_awni_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_15/sim/bd_e437_wni_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_16/sim/bd_e437_bni_0.sv" \

vlog -work smartconnect_v1_0 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/f85e/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_17/sim/bd_e437_s00mmu_0.sv" \

vlog -work smartconnect_v1_0 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ca72/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_18/sim/bd_e437_s00tr_0.sv" \

vlog -work smartconnect_v1_0 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/9ade/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_19/sim/bd_e437_s00sic_0.sv" \

vlog -work smartconnect_v1_0 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b89e/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_20/sim/bd_e437_s00a2s_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_21/sim/bd_e437_sarn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_22/sim/bd_e437_srn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_23/sim/bd_e437_sawn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_24/sim/bd_e437_swn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_25/sim/bd_e437_sbn_0.sv" \

vlog -work smartconnect_v1_0 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/7005/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_26/sim/bd_e437_m00s2a_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_27/sim/bd_e437_m00arn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_28/sim/bd_e437_m00rn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_29/sim/bd_e437_m00awn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_30/sim/bd_e437_m00wn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_31/sim/bd_e437_m00bn_0.sv" \

vlog -work smartconnect_v1_0 -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b387/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_32/sim/bd_e437_m00e_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_33/sim/bd_e437_m01s2a_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_34/sim/bd_e437_m01arn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_35/sim/bd_e437_m01rn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_36/sim/bd_e437_m01awn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_37/sim/bd_e437_m01wn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_38/sim/bd_e437_m01bn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/bd_0/ip/ip_39/sim/bd_e437_m01e_0.sv" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_1_0/sim/ps_ai_smartconnect_1_0.v" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_0/sim/bd_2466_one_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_1/sim/bd_2466_psr_aclk_0.vhd" \

vlog -work xil_defaultlib -64 -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_2/sim/bd_2466_arsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_3/sim/bd_2466_rsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_4/sim/bd_2466_awsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_5/sim/bd_2466_wsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_6/sim/bd_2466_bsw_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_7/sim/bd_2466_s00mmu_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_8/sim/bd_2466_s00tr_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_9/sim/bd_2466_s00sic_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_10/sim/bd_2466_s00a2s_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_11/sim/bd_2466_sarn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_12/sim/bd_2466_srn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_13/sim/bd_2466_sawn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_14/sim/bd_2466_swn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_15/sim/bd_2466_sbn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_16/sim/bd_2466_s01mmu_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_17/sim/bd_2466_s01tr_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_18/sim/bd_2466_s01sic_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_19/sim/bd_2466_s01a2s_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_20/sim/bd_2466_sarn_1.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_21/sim/bd_2466_srn_1.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_22/sim/bd_2466_s02mmu_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_23/sim/bd_2466_s02tr_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_24/sim/bd_2466_s02sic_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_25/sim/bd_2466_s02a2s_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_26/sim/bd_2466_sarn_2.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_27/sim/bd_2466_srn_2.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_28/sim/bd_2466_sawn_1.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_29/sim/bd_2466_swn_1.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_30/sim/bd_2466_sbn_1.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_31/sim/bd_2466_s03mmu_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_32/sim/bd_2466_s03tr_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_33/sim/bd_2466_s03sic_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_34/sim/bd_2466_s03a2s_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_35/sim/bd_2466_sawn_2.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_36/sim/bd_2466_swn_2.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_37/sim/bd_2466_sbn_2.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_38/sim/bd_2466_m00s2a_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_39/sim/bd_2466_m00arn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_40/sim/bd_2466_m00rn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_41/sim/bd_2466_m00awn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_42/sim/bd_2466_m00wn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_43/sim/bd_2466_m00bn_0.sv" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/ip/ip_44/sim/bd_2466_m00e_0.sv" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/bd_0/sim/bd_2466.v" \
"../../../bd/ps_ai/ip/ps_ai_smartconnect_0_0/sim/ps_ai_smartconnect_0_0.v" \
"../../../bd/ps_ai/ip/ps_ai_s00_regslice_0/sim/ps_ai_s00_regslice_0.v" \
"../../../bd/ps_ai/ip/ps_ai_s00_regslice_1/sim/ps_ai_s00_regslice_1.v" \

vlog -work axi_protocol_converter_v2_1_18 -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/7a04/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/ec67/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/70cf/hdl" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/979d/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ipshared/b2d0/hdl/verilog" "+incdir+../../../../RFFI_FPAI.srcs/sources_1/bd/ps_ai/ip/ps_ai_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/ps_ai/ip/ps_ai_auto_pc_1/sim/ps_ai_auto_pc_1.v" \
"../../../bd/ps_ai/ip/ps_ai_s01_regslice_0/sim/ps_ai_s01_regslice_0.v" \
"../../../bd/ps_ai/ip/ps_ai_m00_regslice_0/sim/ps_ai_m00_regslice_0.v" \
"../../../bd/ps_ai/ip/ps_ai_auto_pc_0/sim/ps_ai_auto_pc_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

