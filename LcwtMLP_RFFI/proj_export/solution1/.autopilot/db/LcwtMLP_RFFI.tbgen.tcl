set moduleName LcwtMLP_RFFI
set isTaskLevelControl 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set C_modelName {LcwtMLP_RFFI}
set C_modelType { void 0 }
set C_modelArgList {
	{ din_V_V int 33 regular {fifo 0 volatile }  }
	{ dout_V_data_V int 32 regular {axi_s 1 volatile  { dout Data } }  }
	{ dout_V_keep_V int 4 regular {axi_s 1 volatile  { dout Keep } }  }
	{ dout_V_strb_V int 4 regular {axi_s 1 volatile  { dout Strb } }  }
	{ dout_V_last_V int 1 regular {axi_s 1 volatile  { dout Last } }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "din_V_V", "interface" : "fifo", "bitwidth" : 33, "direction" : "READONLY", "bitSlice":[{"low":0,"up":32,"cElement": [{"cName": "din.V.V","cData": "uint33","bit_use": { "low": 0,"up": 32},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "dout_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "dout.V.data.V","cData": "uint32","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "dout_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "dout.V.keep.V","cData": "uint4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "dout_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "dout.V.strb.V","cData": "uint4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "dout_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "dout.V.last.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} ]}
# RTL Port declarations: 
set portNum 15
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ din_V_V_dout sc_in sc_lv 33 signal 0 } 
	{ din_V_V_empty_n sc_in sc_logic 1 signal 0 } 
	{ din_V_V_read sc_out sc_logic 1 signal 0 } 
	{ dout_TDATA sc_out sc_lv 32 signal 1 } 
	{ dout_TVALID sc_out sc_logic 1 outvld 4 } 
	{ dout_TREADY sc_in sc_logic 1 outacc 1 } 
	{ dout_TKEEP sc_out sc_lv 4 signal 2 } 
	{ dout_TSTRB sc_out sc_lv 4 signal 3 } 
	{ dout_TLAST sc_out sc_lv 1 signal 4 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "din_V_V_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":33, "type": "signal", "bundle":{"name": "din_V_V", "role": "dout" }} , 
 	{ "name": "din_V_V_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "din_V_V", "role": "empty_n" }} , 
 	{ "name": "din_V_V_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "din_V_V", "role": "read" }} , 
 	{ "name": "dout_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dout_V_data_V", "role": "default" }} , 
 	{ "name": "dout_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dout_V_last_V", "role": "default" }} , 
 	{ "name": "dout_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dout_V_data_V", "role": "default" }} , 
 	{ "name": "dout_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dout_V_keep_V", "role": "default" }} , 
 	{ "name": "dout_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dout_V_strb_V", "role": "default" }} , 
 	{ "name": "dout_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dout_V_last_V", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "159", "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171", "172", "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "192", "193", "194", "195", "196", "197", "198", "199", "200", "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216", "217", "218", "219", "220", "221", "222", "223", "224", "225", "226", "227", "228", "229", "230", "231", "232", "233", "234", "235", "236", "237"],
		"CDFG" : "LcwtMLP_RFFI",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "34081", "EstimateLatencyMax" : "134433",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "din_V_V", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "din_V_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_V_data_V", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "dout_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "dout_V_keep_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "dout_V_strb_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "dout_V_last_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "LOFF", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LCWT_A_V", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LCWT_S_V", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_3", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_4", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_5", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_6", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_7", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_8", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_9", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_10", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_11", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_12", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_13", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_14", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_15", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_16", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_17", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_18", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_19", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_20", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_21", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_22", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_23", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_24", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_25", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_26", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_27", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_28", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_29", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_30", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_31", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_32", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_33", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_34", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_35", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_36", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "PATCH_W_V_37", "Type" : "Memory", "Direction" : "I"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LOFF_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LCWT_A_V_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LCWT_S_V_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_0_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_1_U", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_2_U", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_3_U", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_4_U", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_5_U", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_6_U", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_7_U", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_8_U", "Parent" : "0"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_9_U", "Parent" : "0"},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_10_U", "Parent" : "0"},
	{"ID" : "15", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_11_U", "Parent" : "0"},
	{"ID" : "16", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_12_U", "Parent" : "0"},
	{"ID" : "17", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_13_U", "Parent" : "0"},
	{"ID" : "18", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_14_U", "Parent" : "0"},
	{"ID" : "19", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_15_U", "Parent" : "0"},
	{"ID" : "20", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_16_U", "Parent" : "0"},
	{"ID" : "21", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_17_U", "Parent" : "0"},
	{"ID" : "22", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_18_U", "Parent" : "0"},
	{"ID" : "23", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_19_U", "Parent" : "0"},
	{"ID" : "24", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_20_U", "Parent" : "0"},
	{"ID" : "25", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_21_U", "Parent" : "0"},
	{"ID" : "26", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_22_U", "Parent" : "0"},
	{"ID" : "27", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_23_U", "Parent" : "0"},
	{"ID" : "28", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_24_U", "Parent" : "0"},
	{"ID" : "29", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_25_U", "Parent" : "0"},
	{"ID" : "30", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_26_U", "Parent" : "0"},
	{"ID" : "31", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_27_U", "Parent" : "0"},
	{"ID" : "32", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_28_U", "Parent" : "0"},
	{"ID" : "33", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_29_U", "Parent" : "0"},
	{"ID" : "34", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_30_U", "Parent" : "0"},
	{"ID" : "35", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_31_U", "Parent" : "0"},
	{"ID" : "36", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_32_U", "Parent" : "0"},
	{"ID" : "37", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_33_U", "Parent" : "0"},
	{"ID" : "38", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_34_U", "Parent" : "0"},
	{"ID" : "39", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_35_U", "Parent" : "0"},
	{"ID" : "40", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_36_U", "Parent" : "0"},
	{"ID" : "41", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.PATCH_W_V_37_U", "Parent" : "0"},
	{"ID" : "42", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lr_i_U", "Parent" : "0"},
	{"ID" : "43", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.li_i_U", "Parent" : "0"},
	{"ID" : "44", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hr_i_U", "Parent" : "0"},
	{"ID" : "45", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hi_i_U", "Parent" : "0"},
	{"ID" : "46", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xr0_V_U", "Parent" : "0"},
	{"ID" : "47", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_V_U", "Parent" : "0"},
	{"ID" : "48", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.tokT_V_U", "Parent" : "0"},
	{"ID" : "49", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_PgM_U1", "Parent" : "0"},
	{"ID" : "50", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U2", "Parent" : "0"},
	{"ID" : "51", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U3", "Parent" : "0"},
	{"ID" : "52", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U4", "Parent" : "0"},
	{"ID" : "53", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Rg6_U5", "Parent" : "0"},
	{"ID" : "54", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Rg6_U6", "Parent" : "0"},
	{"ID" : "55", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U7", "Parent" : "0"},
	{"ID" : "56", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U8", "Parent" : "0"},
	{"ID" : "57", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U9", "Parent" : "0"},
	{"ID" : "58", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U10", "Parent" : "0"},
	{"ID" : "59", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Thq_U11", "Parent" : "0"},
	{"ID" : "60", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Thq_U12", "Parent" : "0"},
	{"ID" : "61", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U13", "Parent" : "0"},
	{"ID" : "62", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U14", "Parent" : "0"},
	{"ID" : "63", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U15", "Parent" : "0"},
	{"ID" : "64", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U16", "Parent" : "0"},
	{"ID" : "65", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Thq_U17", "Parent" : "0"},
	{"ID" : "66", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Thq_U18", "Parent" : "0"},
	{"ID" : "67", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U19", "Parent" : "0"},
	{"ID" : "68", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U20", "Parent" : "0"},
	{"ID" : "69", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U21", "Parent" : "0"},
	{"ID" : "70", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Shg_U22", "Parent" : "0"},
	{"ID" : "71", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Thq_U23", "Parent" : "0"},
	{"ID" : "72", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_Thq_U24", "Parent" : "0"},
	{"ID" : "73", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_PgM_U25", "Parent" : "0"},
	{"ID" : "74", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U26", "Parent" : "0"},
	{"ID" : "75", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U27", "Parent" : "0"},
	{"ID" : "76", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U28", "Parent" : "0"},
	{"ID" : "77", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U29", "Parent" : "0"},
	{"ID" : "78", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U30", "Parent" : "0"},
	{"ID" : "79", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U31", "Parent" : "0"},
	{"ID" : "80", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U32", "Parent" : "0"},
	{"ID" : "81", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_UhA_U33", "Parent" : "0"},
	{"ID" : "82", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_UhA_U34", "Parent" : "0"},
	{"ID" : "83", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_UhA_U35", "Parent" : "0"},
	{"ID" : "84", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_UhA_U36", "Parent" : "0"},
	{"ID" : "85", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U37", "Parent" : "0"},
	{"ID" : "86", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U38", "Parent" : "0"},
	{"ID" : "87", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U39", "Parent" : "0"},
	{"ID" : "88", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U40", "Parent" : "0"},
	{"ID" : "89", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U41", "Parent" : "0"},
	{"ID" : "90", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U42", "Parent" : "0"},
	{"ID" : "91", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U43", "Parent" : "0"},
	{"ID" : "92", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_QgW_U44", "Parent" : "0"},
	{"ID" : "93", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_UhA_U45", "Parent" : "0"},
	{"ID" : "94", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_UhA_U46", "Parent" : "0"},
	{"ID" : "95", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_UhA_U47", "Parent" : "0"},
	{"ID" : "96", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_UhA_U48", "Parent" : "0"},
	{"ID" : "97", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mux_VhK_U49", "Parent" : "0"},
	{"ID" : "98", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U50", "Parent" : "0"},
	{"ID" : "99", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U51", "Parent" : "0"},
	{"ID" : "100", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U52", "Parent" : "0"},
	{"ID" : "101", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U53", "Parent" : "0"},
	{"ID" : "102", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U54", "Parent" : "0"},
	{"ID" : "103", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U55", "Parent" : "0"},
	{"ID" : "104", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U56", "Parent" : "0"},
	{"ID" : "105", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U57", "Parent" : "0"},
	{"ID" : "106", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U58", "Parent" : "0"},
	{"ID" : "107", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U59", "Parent" : "0"},
	{"ID" : "108", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U60", "Parent" : "0"},
	{"ID" : "109", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U61", "Parent" : "0"},
	{"ID" : "110", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U62", "Parent" : "0"},
	{"ID" : "111", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U63", "Parent" : "0"},
	{"ID" : "112", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U64", "Parent" : "0"},
	{"ID" : "113", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U65", "Parent" : "0"},
	{"ID" : "114", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U66", "Parent" : "0"},
	{"ID" : "115", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U67", "Parent" : "0"},
	{"ID" : "116", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U68", "Parent" : "0"},
	{"ID" : "117", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U69", "Parent" : "0"},
	{"ID" : "118", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U70", "Parent" : "0"},
	{"ID" : "119", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U71", "Parent" : "0"},
	{"ID" : "120", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U72", "Parent" : "0"},
	{"ID" : "121", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U73", "Parent" : "0"},
	{"ID" : "122", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U74", "Parent" : "0"},
	{"ID" : "123", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U75", "Parent" : "0"},
	{"ID" : "124", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U76", "Parent" : "0"},
	{"ID" : "125", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U77", "Parent" : "0"},
	{"ID" : "126", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U78", "Parent" : "0"},
	{"ID" : "127", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U79", "Parent" : "0"},
	{"ID" : "128", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U80", "Parent" : "0"},
	{"ID" : "129", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U81", "Parent" : "0"},
	{"ID" : "130", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U82", "Parent" : "0"},
	{"ID" : "131", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U83", "Parent" : "0"},
	{"ID" : "132", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U84", "Parent" : "0"},
	{"ID" : "133", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U85", "Parent" : "0"},
	{"ID" : "134", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U86", "Parent" : "0"},
	{"ID" : "135", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U87", "Parent" : "0"},
	{"ID" : "136", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U88", "Parent" : "0"},
	{"ID" : "137", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U89", "Parent" : "0"},
	{"ID" : "138", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U90", "Parent" : "0"},
	{"ID" : "139", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U91", "Parent" : "0"},
	{"ID" : "140", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U92", "Parent" : "0"},
	{"ID" : "141", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U93", "Parent" : "0"},
	{"ID" : "142", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U94", "Parent" : "0"},
	{"ID" : "143", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U95", "Parent" : "0"},
	{"ID" : "144", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U96", "Parent" : "0"},
	{"ID" : "145", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U97", "Parent" : "0"},
	{"ID" : "146", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U98", "Parent" : "0"},
	{"ID" : "147", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U99", "Parent" : "0"},
	{"ID" : "148", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U100", "Parent" : "0"},
	{"ID" : "149", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U101", "Parent" : "0"},
	{"ID" : "150", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U102", "Parent" : "0"},
	{"ID" : "151", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U103", "Parent" : "0"},
	{"ID" : "152", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U104", "Parent" : "0"},
	{"ID" : "153", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U105", "Parent" : "0"},
	{"ID" : "154", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U106", "Parent" : "0"},
	{"ID" : "155", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U107", "Parent" : "0"},
	{"ID" : "156", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U108", "Parent" : "0"},
	{"ID" : "157", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U109", "Parent" : "0"},
	{"ID" : "158", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U110", "Parent" : "0"},
	{"ID" : "159", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U111", "Parent" : "0"},
	{"ID" : "160", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U112", "Parent" : "0"},
	{"ID" : "161", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_WhU_U113", "Parent" : "0"},
	{"ID" : "162", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U114", "Parent" : "0"},
	{"ID" : "163", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U115", "Parent" : "0"},
	{"ID" : "164", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U116", "Parent" : "0"},
	{"ID" : "165", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U117", "Parent" : "0"},
	{"ID" : "166", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U118", "Parent" : "0"},
	{"ID" : "167", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U119", "Parent" : "0"},
	{"ID" : "168", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U120", "Parent" : "0"},
	{"ID" : "169", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U121", "Parent" : "0"},
	{"ID" : "170", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U122", "Parent" : "0"},
	{"ID" : "171", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U123", "Parent" : "0"},
	{"ID" : "172", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U124", "Parent" : "0"},
	{"ID" : "173", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U125", "Parent" : "0"},
	{"ID" : "174", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U126", "Parent" : "0"},
	{"ID" : "175", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U127", "Parent" : "0"},
	{"ID" : "176", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U128", "Parent" : "0"},
	{"ID" : "177", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U129", "Parent" : "0"},
	{"ID" : "178", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U130", "Parent" : "0"},
	{"ID" : "179", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U131", "Parent" : "0"},
	{"ID" : "180", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U132", "Parent" : "0"},
	{"ID" : "181", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U133", "Parent" : "0"},
	{"ID" : "182", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U134", "Parent" : "0"},
	{"ID" : "183", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U135", "Parent" : "0"},
	{"ID" : "184", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U136", "Parent" : "0"},
	{"ID" : "185", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Zio_U137", "Parent" : "0"},
	{"ID" : "186", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U138", "Parent" : "0"},
	{"ID" : "187", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U139", "Parent" : "0"},
	{"ID" : "188", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U140", "Parent" : "0"},
	{"ID" : "189", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U141", "Parent" : "0"},
	{"ID" : "190", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U142", "Parent" : "0"},
	{"ID" : "191", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Xh4_U143", "Parent" : "0"},
	{"ID" : "192", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U144", "Parent" : "0"},
	{"ID" : "193", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U145", "Parent" : "0"},
	{"ID" : "194", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U146", "Parent" : "0"},
	{"ID" : "195", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U147", "Parent" : "0"},
	{"ID" : "196", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U148", "Parent" : "0"},
	{"ID" : "197", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U149", "Parent" : "0"},
	{"ID" : "198", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U150", "Parent" : "0"},
	{"ID" : "199", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_Yie_U151", "Parent" : "0"},
	{"ID" : "200", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U152", "Parent" : "0"},
	{"ID" : "201", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U153", "Parent" : "0"},
	{"ID" : "202", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U154", "Parent" : "0"},
	{"ID" : "203", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U155", "Parent" : "0"},
	{"ID" : "204", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U156", "Parent" : "0"},
	{"ID" : "205", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U157", "Parent" : "0"},
	{"ID" : "206", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U158", "Parent" : "0"},
	{"ID" : "207", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U159", "Parent" : "0"},
	{"ID" : "208", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U160", "Parent" : "0"},
	{"ID" : "209", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U161", "Parent" : "0"},
	{"ID" : "210", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U162", "Parent" : "0"},
	{"ID" : "211", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U163", "Parent" : "0"},
	{"ID" : "212", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U164", "Parent" : "0"},
	{"ID" : "213", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U165", "Parent" : "0"},
	{"ID" : "214", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U166", "Parent" : "0"},
	{"ID" : "215", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U167", "Parent" : "0"},
	{"ID" : "216", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U168", "Parent" : "0"},
	{"ID" : "217", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U169", "Parent" : "0"},
	{"ID" : "218", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U170", "Parent" : "0"},
	{"ID" : "219", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U171", "Parent" : "0"},
	{"ID" : "220", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U172", "Parent" : "0"},
	{"ID" : "221", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U173", "Parent" : "0"},
	{"ID" : "222", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U174", "Parent" : "0"},
	{"ID" : "223", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_2iS_U175", "Parent" : "0"},
	{"ID" : "224", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U176", "Parent" : "0"},
	{"ID" : "225", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U177", "Parent" : "0"},
	{"ID" : "226", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U178", "Parent" : "0"},
	{"ID" : "227", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U179", "Parent" : "0"},
	{"ID" : "228", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U180", "Parent" : "0"},
	{"ID" : "229", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_0iy_U181", "Parent" : "0"},
	{"ID" : "230", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U182", "Parent" : "0"},
	{"ID" : "231", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U183", "Parent" : "0"},
	{"ID" : "232", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U184", "Parent" : "0"},
	{"ID" : "233", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U185", "Parent" : "0"},
	{"ID" : "234", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U186", "Parent" : "0"},
	{"ID" : "235", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U187", "Parent" : "0"},
	{"ID" : "236", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U188", "Parent" : "0"},
	{"ID" : "237", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LcwtMLP_RFFI_mac_1iI_U189", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	LcwtMLP_RFFI {
		din_V_V {Type I LastRead 3 FirstWrite -1}
		dout_V_data_V {Type O LastRead -1 FirstWrite 14}
		dout_V_keep_V {Type O LastRead -1 FirstWrite 14}
		dout_V_strb_V {Type O LastRead -1 FirstWrite 14}
		dout_V_last_V {Type O LastRead -1 FirstWrite 14}
		LOFF {Type I LastRead -1 FirstWrite -1}
		LCWT_A_V {Type I LastRead -1 FirstWrite -1}
		LCWT_S_V {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_0 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_1 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_2 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_3 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_4 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_5 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_6 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_7 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_8 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_9 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_10 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_11 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_12 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_13 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_14 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_15 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_16 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_17 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_18 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_19 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_20 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_21 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_22 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_23 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_24 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_25 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_26 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_27 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_28 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_29 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_30 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_31 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_32 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_33 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_34 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_35 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_36 {Type I LastRead -1 FirstWrite -1}
		PATCH_W_V_37 {Type I LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "34081", "Max" : "134433"}
	, {"Name" : "Interval", "Min" : "34082", "Max" : "134434"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
	{"Pipeline" : "1", "EnableSignal" : "ap_enable_pp1"}
	{"Pipeline" : "2", "EnableSignal" : "ap_enable_pp2"}
	{"Pipeline" : "3", "EnableSignal" : "ap_enable_pp3"}
	{"Pipeline" : "4", "EnableSignal" : "ap_enable_pp4"}
	{"Pipeline" : "5", "EnableSignal" : "ap_enable_pp5"}
	{"Pipeline" : "6", "EnableSignal" : "ap_enable_pp6"}
	{"Pipeline" : "7", "EnableSignal" : "ap_enable_pp7"}
	{"Pipeline" : "8", "EnableSignal" : "ap_enable_pp8"}
	{"Pipeline" : "9", "EnableSignal" : "ap_enable_pp9"}
	{"Pipeline" : "10", "EnableSignal" : "ap_enable_pp10"}
	{"Pipeline" : "11", "EnableSignal" : "ap_enable_pp11"}
]}

set Spec2ImplPortList { 
	din_V_V { ap_fifo {  { din_V_V_dout fifo_data 0 33 }  { din_V_V_empty_n fifo_status 0 1 }  { din_V_V_read fifo_update 1 1 } } }
	dout_V_data_V { axis {  { dout_TDATA out_data 1 32 }  { dout_TREADY out_acc 0 1 } } }
	dout_V_keep_V { axis {  { dout_TKEEP out_data 1 4 } } }
	dout_V_strb_V { axis {  { dout_TSTRB out_data 1 4 } } }
	dout_V_last_V { axis {  { dout_TVALID out_vld 1 1 }  { dout_TLAST out_data 1 1 } } }
}

set busDeadlockParameterList { 
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
	din_V_V { fifo_read 256 has_conditional }
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
