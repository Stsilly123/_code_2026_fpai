vlib work
vlib activehdl

vlib activehdl/xilinx_vip
vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xilinx_vip activehdl/xilinx_vip
vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xilinx_vip  -sv2k12 "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Xilinx/Vivado/2018.3/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_hr_i.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_LCWTbkb.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_LCWTcud.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_LOFF.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_lr_i.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mac_0iy.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mac_1iI.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mac_2iS.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mac_WhU.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mac_Xh4.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mac_Yie.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mac_Zio.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mux_PgM.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mux_QgW.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mux_Rg6.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mux_Shg.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mux_Thq.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mux_UhA.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_mux_VhK.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCAem.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCBew.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCCeG.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCdEe.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCDeQ.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCEe0.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCeOg.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCFfa.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCfYi.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCg8j.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCGfk.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATChbi.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCHfu.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCibs.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCIfE.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCjbC.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCJfO.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCkbM.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCKfY.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATClbW.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCLf8.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCmb6.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCMgi.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCncg.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCNgs.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCocq.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCOgC.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCpcA.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCqcK.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCrcU.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCsc4.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCtde.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCudo.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCvdy.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCwdI.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCxdS.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCyd2.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_PATCzec.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_tokT_V.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI_xr0_V.v" \
"../../../ipstatic/hdl/verilog/LcwtMLP_RFFI.v" \
"../../../../RFFI_FPAI.srcs/sources_1/ip/LcwtMLP_RFFI_0/sim/LcwtMLP_RFFI_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

