`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// L-STF 均衡器（对应 SRC/pl_ai/LSTF均衡器Verilog实现指南.md）
//
// 输入不另开 AXIS：直接旁听 Signal_process 里 stream_buf 的输出
//   din       = hls_din[31:0] = {Q[31:16], I[15:0]}（一字一拍）
//   din_valid = hls_wr
// 帧边界照样**按 256 字数**切（和 stream_buf 同一套规矩），与 IP 无关。
//
// 输出是标准 AXIS master（形状抄 Signal_process.dout：32bit、TKEEP、TLAST）：
//   每帧 256 个字 = 256 对 IQ，TLAST 在第 256 字；m_tuser 逐字给出旁路标志
//   （1 = 门控没过 / 信道全零，本帧原样输出）。
//
// 定点方案（与 tools/gen_lstf_eq_vectors.py 的 lstf_equalize_fixed 逐级对应）：
//   SX=13 Q_TW=17 H_TGT=23 K_W=44 T_Q=24 TAP_SFT=13 ATAN_Q=18 CORDIC_N=18 CORDIC_P=21
//   INV_LUT_BITS=7  GATE_K=46080  S_TAP=eH-17
//
// 抽头定标（2026-10-20 补充指南）：真实 MMSE 抽头在弱信号/深衰落帧能到
//   10~1000（Q24 下远超 DSP A 口 ±1.0），直接 clip25 会把主瓣削平。
//   做法：IDFT 先按原 Q24 跑一遍，同时记「有没有分量放不进 25bit」的粘滞标志；
//   有就整帧再跑一遍，这一遍 nm 输出 >>TAP_SFT（Q24 -> Q11）再饱和，FIR 末级
//   从 >>T_Q 改为 >>(T_Q-TAP_SFT) 补回。抽头全都放得下的帧走第一遍（Q24 精度
//   不变），所以强信号帧不会因为这次改动掉精度。
//   均衡器绝对增益下游不关心（app 会做 per-sample norm），这两条移位等价。
//   25bit Q11 可表示 ±4096 的抽头，全 test 实测最大 1423。
//
// 运算引擎：一个共享复数 MAC（4 个 DSP48），A 口 25bit、B 口 18bit，
//   4 级流水（issue -> 取操作数 -> 乘 -> 累加），1 拍可发一项，
//   issue 后第 4 拍累加器可读（issue at T -> 读 at T+4）。
//   复数乘：{re = ar*br - ai*bi, im = ar*bi + ai*br}
//   |x|^2 用 conj 技巧：A=x、B=conj(x) -> re = |x|^2（Et 用它）
//   Sp / P 走另外一对专用平方器（25x25，两路共用一组 DSP）
//
// 帧缓存：8 槽 x 256 字环形。处理一帧期间该槽不再被写（环形最多存 7 帧
//   + 1 帧在处理；满了丢新帧并计 stat_drop）。
//
// 时序预算：一帧约 11k 拍 @200MHz = 55us，帧周期约 101us，约 1.8 倍余量。
//////////////////////////////////////////////////////////////////////////////////

module lstf_eq (
    input  wire         clk,
    input  wire         rst_n,
    // 旁听 stream_buf 输出（与 FIFO/HLS 输入同一份数据）
    input  wire [31:0]  din,          // {Q[31:16], I[15:0]}
    input  wire         din_valid,    // 一个字一拍
    // 均衡结果 AXIS master
    output wire [31:0]  m_tdata,      // {Q[31:16], I[15:0]}，Q10 码值
    output wire         m_tvalid,
    input  wire         m_tready,
    output wire [3:0]   m_tkeep,
    output wire         m_tlast,
    output wire         m_tuser,      // 1 = 本帧旁路（门控失败/全零）
    // 状态
    output wire [31:0]  stat_drop,    // 因 8 槽全满被丢掉的帧数
    output wire [22:0]  stat_theta,   // 最近一帧的 CFO 角（Q2.18）
    output wire         stat_gate,    // 最近一帧门控结果（1 = 做均衡）
    output wire         busy
);

    // ── 常数表（原 lstf_eq_rom.vh，现已内联）────────────────────────────────
    // 之前用 `include：Vivado 2018.3 的 source manager 会给被 include 的头文件建
    // proxy，一旦这个 .vh 没正确挂在 fileset 上就抛
    //   HDDASrcFileProxy::HDDASrcFileProxy: Given HDDASrcFile isn't associated
    //   with a fileset
    // 并把整个 design graph 搞坏（HADGDesignGraphMgr::getCurrentGraph: Graph could
    // not be found），表现就是 BD 里 module_ref 找不到、加不进来。内联后模块自包含。
    // Verilog-2001 不允许在根作用域声明 function，所以只能放在 module 里。
    // 自动生成，别手改 —— 生成器：SRC/pl_ai/tools/gen_lstf_eq_vectors.py
    // 用法：always @(posedge clk) rom_q <= lstf_dft_rom(addr);
    // DFT 12x20：index = p*20 + n，36bit = {cos[17:0], sin[17:0]}（Q17）
    `define LSTF_DFT_N 240
    function [35:0] lstf_dft_rom;
        input [7:0] idx;
        begin case (idx)
              0: lstf_dft_rom = 36'h7fffc0000;
              1: lstf_dft_rom = 36'hd8725e6f1;
              2: lstf_dft_rom = 36'h98726d30e;
              3: lstf_dft_rom = 36'h678ded30e;
              4: lstf_dft_rom = 36'h278dde6f1;
              5: lstf_dft_rom = 36'h800000000;
              6: lstf_dft_rom = 36'h278de190f;
              7: lstf_dft_rom = 36'h678dd2cf2;
              8: lstf_dft_rom = 36'h987252cf2;
              9: lstf_dft_rom = 36'hd8726190f;
             10: lstf_dft_rom = 36'h7fffc0000;
             11: lstf_dft_rom = 36'hd8725e6f1;
             12: lstf_dft_rom = 36'h98726d30e;
             13: lstf_dft_rom = 36'h678ded30e;
             14: lstf_dft_rom = 36'h278dde6f1;
             15: lstf_dft_rom = 36'h800000000;
             16: lstf_dft_rom = 36'h278de190f;
             17: lstf_dft_rom = 36'h678dd2cf2;
             18: lstf_dft_rom = 36'h987252cf2;
             19: lstf_dft_rom = 36'hd8726190f;
             20: lstf_dft_rom = 36'h7fffc0000;
             21: lstf_dft_rom = 36'h00001ffff;
             22: lstf_dft_rom = 36'h800000000;
             23: lstf_dft_rom = 36'h000020000;
             24: lstf_dft_rom = 36'h7fffc0000;
             25: lstf_dft_rom = 36'h00001ffff;
             26: lstf_dft_rom = 36'h800000000;
             27: lstf_dft_rom = 36'h000020000;
             28: lstf_dft_rom = 36'h7fffc0000;
             29: lstf_dft_rom = 36'h00001ffff;
             30: lstf_dft_rom = 36'h800000000;
             31: lstf_dft_rom = 36'h000020000;
             32: lstf_dft_rom = 36'h7fffc0000;
             33: lstf_dft_rom = 36'h00001ffff;
             34: lstf_dft_rom = 36'h800000000;
             35: lstf_dft_rom = 36'h000020000;
             36: lstf_dft_rom = 36'h7fffc0000;
             37: lstf_dft_rom = 36'h00001ffff;
             38: lstf_dft_rom = 36'h800000000;
             39: lstf_dft_rom = 36'h000020000;
             40: lstf_dft_rom = 36'h7fffc0000;
             41: lstf_dft_rom = 36'h278dde6f1;
             42: lstf_dft_rom = 36'h987252cf2;
             43: lstf_dft_rom = 36'h98726d30e;
             44: lstf_dft_rom = 36'h278de190f;
             45: lstf_dft_rom = 36'h7fffc0000;
             46: lstf_dft_rom = 36'h278dde6f1;
             47: lstf_dft_rom = 36'h987252cf2;
             48: lstf_dft_rom = 36'h98726d30e;
             49: lstf_dft_rom = 36'h278de190f;
             50: lstf_dft_rom = 36'h7fffc0000;
             51: lstf_dft_rom = 36'h278dde6f1;
             52: lstf_dft_rom = 36'h987252cf2;
             53: lstf_dft_rom = 36'h98726d30e;
             54: lstf_dft_rom = 36'h278de190f;
             55: lstf_dft_rom = 36'h7fffc0000;
             56: lstf_dft_rom = 36'h278dde6f1;
             57: lstf_dft_rom = 36'h987252cf2;
             58: lstf_dft_rom = 36'h98726d30e;
             59: lstf_dft_rom = 36'h278de190f;
             60: lstf_dft_rom = 36'h7fffc0000;
             61: lstf_dft_rom = 36'h4b3c99e37;
             62: lstf_dft_rom = 36'hd8725e6f1;
             63: lstf_dft_rom = 36'h8643c9e37;
             64: lstf_dft_rom = 36'h98726d30e;
             65: lstf_dft_rom = 36'h000020000;
             66: lstf_dft_rom = 36'h678ded30e;
             67: lstf_dft_rom = 36'h79bc49e37;
             68: lstf_dft_rom = 36'h278dde6f1;
             69: lstf_dft_rom = 36'hb4c399e37;
             70: lstf_dft_rom = 36'h800000000;
             71: lstf_dft_rom = 36'hb4c3a61c9;
             72: lstf_dft_rom = 36'h278de190f;
             73: lstf_dft_rom = 36'h79bc761c9;
             74: lstf_dft_rom = 36'h678dd2cf2;
             75: lstf_dft_rom = 36'h00001ffff;
             76: lstf_dft_rom = 36'h987252cf2;
             77: lstf_dft_rom = 36'h8643f61c9;
             78: lstf_dft_rom = 36'hd8726190f;
             79: lstf_dft_rom = 36'h4b3ca61c9;
             80: lstf_dft_rom = 36'h7fffc0000;
             81: lstf_dft_rom = 36'h678dd2cf2;
             82: lstf_dft_rom = 36'h278dde6f1;
             83: lstf_dft_rom = 36'hd8725e6f1;
             84: lstf_dft_rom = 36'h987252cf2;
             85: lstf_dft_rom = 36'h800000000;
             86: lstf_dft_rom = 36'h98726d30e;
             87: lstf_dft_rom = 36'hd8726190f;
             88: lstf_dft_rom = 36'h278de190f;
             89: lstf_dft_rom = 36'h678ded30e;
             90: lstf_dft_rom = 36'h7fffc0000;
             91: lstf_dft_rom = 36'h678dd2cf2;
             92: lstf_dft_rom = 36'h278dde6f1;
             93: lstf_dft_rom = 36'hd8725e6f1;
             94: lstf_dft_rom = 36'h987252cf2;
             95: lstf_dft_rom = 36'h800000000;
             96: lstf_dft_rom = 36'h98726d30e;
             97: lstf_dft_rom = 36'hd8726190f;
             98: lstf_dft_rom = 36'h278de190f;
             99: lstf_dft_rom = 36'h678ded30e;
            100: lstf_dft_rom = 36'h7fffc0000;
            101: lstf_dft_rom = 36'h79bc49e37;
            102: lstf_dft_rom = 36'h678dd2cf2;
            103: lstf_dft_rom = 36'h4b3c99e37;
            104: lstf_dft_rom = 36'h278dde6f1;
            105: lstf_dft_rom = 36'h00001ffff;
            106: lstf_dft_rom = 36'hd8725e6f1;
            107: lstf_dft_rom = 36'hb4c399e37;
            108: lstf_dft_rom = 36'h987252cf2;
            109: lstf_dft_rom = 36'h8643c9e37;
            110: lstf_dft_rom = 36'h800000000;
            111: lstf_dft_rom = 36'h8643f61c9;
            112: lstf_dft_rom = 36'h98726d30e;
            113: lstf_dft_rom = 36'hb4c3a61c9;
            114: lstf_dft_rom = 36'hd8726190f;
            115: lstf_dft_rom = 36'h000020000;
            116: lstf_dft_rom = 36'h278de190f;
            117: lstf_dft_rom = 36'h4b3ca61c9;
            118: lstf_dft_rom = 36'h678ded30e;
            119: lstf_dft_rom = 36'h79bc761c9;
            120: lstf_dft_rom = 36'h7fffc0000;
            121: lstf_dft_rom = 36'h79bc761c9;
            122: lstf_dft_rom = 36'h678ded30e;
            123: lstf_dft_rom = 36'h4b3ca61c9;
            124: lstf_dft_rom = 36'h278de190f;
            125: lstf_dft_rom = 36'h000020000;
            126: lstf_dft_rom = 36'hd8726190f;
            127: lstf_dft_rom = 36'hb4c3a61c9;
            128: lstf_dft_rom = 36'h98726d30e;
            129: lstf_dft_rom = 36'h8643f61c9;
            130: lstf_dft_rom = 36'h800000000;
            131: lstf_dft_rom = 36'h8643c9e37;
            132: lstf_dft_rom = 36'h987252cf2;
            133: lstf_dft_rom = 36'hb4c399e37;
            134: lstf_dft_rom = 36'hd8725e6f1;
            135: lstf_dft_rom = 36'h00001ffff;
            136: lstf_dft_rom = 36'h278dde6f1;
            137: lstf_dft_rom = 36'h4b3c99e37;
            138: lstf_dft_rom = 36'h678dd2cf2;
            139: lstf_dft_rom = 36'h79bc49e37;
            140: lstf_dft_rom = 36'h7fffc0000;
            141: lstf_dft_rom = 36'h678ded30e;
            142: lstf_dft_rom = 36'h278de190f;
            143: lstf_dft_rom = 36'hd8726190f;
            144: lstf_dft_rom = 36'h98726d30e;
            145: lstf_dft_rom = 36'h800000000;
            146: lstf_dft_rom = 36'h987252cf2;
            147: lstf_dft_rom = 36'hd8725e6f1;
            148: lstf_dft_rom = 36'h278dde6f1;
            149: lstf_dft_rom = 36'h678dd2cf2;
            150: lstf_dft_rom = 36'h7fffc0000;
            151: lstf_dft_rom = 36'h678ded30e;
            152: lstf_dft_rom = 36'h278de190f;
            153: lstf_dft_rom = 36'hd8726190f;
            154: lstf_dft_rom = 36'h98726d30e;
            155: lstf_dft_rom = 36'h800000000;
            156: lstf_dft_rom = 36'h987252cf2;
            157: lstf_dft_rom = 36'hd8725e6f1;
            158: lstf_dft_rom = 36'h278dde6f1;
            159: lstf_dft_rom = 36'h678dd2cf2;
            160: lstf_dft_rom = 36'h7fffc0000;
            161: lstf_dft_rom = 36'h4b3ca61c9;
            162: lstf_dft_rom = 36'hd8726190f;
            163: lstf_dft_rom = 36'h8643f61c9;
            164: lstf_dft_rom = 36'h987252cf2;
            165: lstf_dft_rom = 36'h00001ffff;
            166: lstf_dft_rom = 36'h678dd2cf2;
            167: lstf_dft_rom = 36'h79bc761c9;
            168: lstf_dft_rom = 36'h278de190f;
            169: lstf_dft_rom = 36'hb4c3a61c9;
            170: lstf_dft_rom = 36'h800000000;
            171: lstf_dft_rom = 36'hb4c399e37;
            172: lstf_dft_rom = 36'h278dde6f1;
            173: lstf_dft_rom = 36'h79bc49e37;
            174: lstf_dft_rom = 36'h678ded30e;
            175: lstf_dft_rom = 36'h000020000;
            176: lstf_dft_rom = 36'h98726d30e;
            177: lstf_dft_rom = 36'h8643c9e37;
            178: lstf_dft_rom = 36'hd8725e6f1;
            179: lstf_dft_rom = 36'h4b3c99e37;
            180: lstf_dft_rom = 36'h7fffc0000;
            181: lstf_dft_rom = 36'h278de190f;
            182: lstf_dft_rom = 36'h98726d30e;
            183: lstf_dft_rom = 36'h987252cf2;
            184: lstf_dft_rom = 36'h278dde6f1;
            185: lstf_dft_rom = 36'h7fffc0000;
            186: lstf_dft_rom = 36'h278de190f;
            187: lstf_dft_rom = 36'h98726d30e;
            188: lstf_dft_rom = 36'h987252cf2;
            189: lstf_dft_rom = 36'h278dde6f1;
            190: lstf_dft_rom = 36'h7fffc0000;
            191: lstf_dft_rom = 36'h278de190f;
            192: lstf_dft_rom = 36'h98726d30e;
            193: lstf_dft_rom = 36'h987252cf2;
            194: lstf_dft_rom = 36'h278dde6f1;
            195: lstf_dft_rom = 36'h7fffc0000;
            196: lstf_dft_rom = 36'h278de190f;
            197: lstf_dft_rom = 36'h98726d30e;
            198: lstf_dft_rom = 36'h987252cf2;
            199: lstf_dft_rom = 36'h278dde6f1;
            200: lstf_dft_rom = 36'h7fffc0000;
            201: lstf_dft_rom = 36'h000020000;
            202: lstf_dft_rom = 36'h800000000;
            203: lstf_dft_rom = 36'h00001ffff;
            204: lstf_dft_rom = 36'h7fffc0000;
            205: lstf_dft_rom = 36'h000020000;
            206: lstf_dft_rom = 36'h800000000;
            207: lstf_dft_rom = 36'h00001ffff;
            208: lstf_dft_rom = 36'h7fffc0000;
            209: lstf_dft_rom = 36'h000020000;
            210: lstf_dft_rom = 36'h800000000;
            211: lstf_dft_rom = 36'h00001ffff;
            212: lstf_dft_rom = 36'h7fffc0000;
            213: lstf_dft_rom = 36'h000020000;
            214: lstf_dft_rom = 36'h800000000;
            215: lstf_dft_rom = 36'h00001ffff;
            216: lstf_dft_rom = 36'h7fffc0000;
            217: lstf_dft_rom = 36'h000020000;
            218: lstf_dft_rom = 36'h800000000;
            219: lstf_dft_rom = 36'h00001ffff;
            220: lstf_dft_rom = 36'h7fffc0000;
            221: lstf_dft_rom = 36'hd8726190f;
            222: lstf_dft_rom = 36'h987252cf2;
            223: lstf_dft_rom = 36'h678dd2cf2;
            224: lstf_dft_rom = 36'h278de190f;
            225: lstf_dft_rom = 36'h800000000;
            226: lstf_dft_rom = 36'h278dde6f1;
            227: lstf_dft_rom = 36'h678ded30e;
            228: lstf_dft_rom = 36'h98726d30e;
            229: lstf_dft_rom = 36'hd8725e6f1;
            230: lstf_dft_rom = 36'h7fffc0000;
            231: lstf_dft_rom = 36'hd8726190f;
            232: lstf_dft_rom = 36'h987252cf2;
            233: lstf_dft_rom = 36'h678dd2cf2;
            234: lstf_dft_rom = 36'h278de190f;
            235: lstf_dft_rom = 36'h800000000;
            236: lstf_dft_rom = 36'h278dde6f1;
            237: lstf_dft_rom = 36'h678ded30e;
            238: lstf_dft_rom = 36'h98726d30e;
            239: lstf_dft_rom = 36'hd8725e6f1;
            default: lstf_dft_rom = 36'h0;
        endcase end
    endfunction
    // IDFT 20x20：index = m*20 + j
    `define LSTF_IDFT_N 400
    function [35:0] lstf_idft_rom;
        input [8:0] idx;
        begin case (idx)
              0: lstf_idft_rom = 36'h7fffc0000;
              1: lstf_idft_rom = 36'h7fffc0000;
              2: lstf_idft_rom = 36'h7fffc0000;
              3: lstf_idft_rom = 36'h7fffc0000;
              4: lstf_idft_rom = 36'h7fffc0000;
              5: lstf_idft_rom = 36'h7fffc0000;
              6: lstf_idft_rom = 36'h7fffc0000;
              7: lstf_idft_rom = 36'h7fffc0000;
              8: lstf_idft_rom = 36'h7fffc0000;
              9: lstf_idft_rom = 36'h7fffc0000;
             10: lstf_idft_rom = 36'h7fffc0000;
             11: lstf_idft_rom = 36'h7fffc0000;
             12: lstf_idft_rom = 36'h7fffc0000;
             13: lstf_idft_rom = 36'h7fffc0000;
             14: lstf_idft_rom = 36'h7fffc0000;
             15: lstf_idft_rom = 36'h7fffc0000;
             16: lstf_idft_rom = 36'h7fffc0000;
             17: lstf_idft_rom = 36'h7fffc0000;
             18: lstf_idft_rom = 36'h7fffc0000;
             19: lstf_idft_rom = 36'h7fffc0000;
             20: lstf_idft_rom = 36'h800000000;
             21: lstf_idft_rom = 36'h8643f61c9;
             22: lstf_idft_rom = 36'h98726d30e;
             23: lstf_idft_rom = 36'hb4c3a61c9;
             24: lstf_idft_rom = 36'hd8726190f;
             25: lstf_idft_rom = 36'h000020000;
             26: lstf_idft_rom = 36'h278de190f;
             27: lstf_idft_rom = 36'h4b3ca61c9;
             28: lstf_idft_rom = 36'h678ded30e;
             29: lstf_idft_rom = 36'h79bc761c9;
             30: lstf_idft_rom = 36'h7fffc0000;
             31: lstf_idft_rom = 36'h79bc49e37;
             32: lstf_idft_rom = 36'h678dd2cf2;
             33: lstf_idft_rom = 36'h4b3c99e37;
             34: lstf_idft_rom = 36'h278dde6f1;
             35: lstf_idft_rom = 36'h00001ffff;
             36: lstf_idft_rom = 36'hd8725e6f1;
             37: lstf_idft_rom = 36'hb4c399e37;
             38: lstf_idft_rom = 36'h987252cf2;
             39: lstf_idft_rom = 36'h8643c9e37;
             40: lstf_idft_rom = 36'h7fffc0000;
             41: lstf_idft_rom = 36'h678dd2cf2;
             42: lstf_idft_rom = 36'h278dde6f1;
             43: lstf_idft_rom = 36'hd8725e6f1;
             44: lstf_idft_rom = 36'h987252cf2;
             45: lstf_idft_rom = 36'h800000000;
             46: lstf_idft_rom = 36'h98726d30e;
             47: lstf_idft_rom = 36'hd8726190f;
             48: lstf_idft_rom = 36'h278de190f;
             49: lstf_idft_rom = 36'h678ded30e;
             50: lstf_idft_rom = 36'h7fffc0000;
             51: lstf_idft_rom = 36'h678dd2cf2;
             52: lstf_idft_rom = 36'h278dde6f1;
             53: lstf_idft_rom = 36'hd8725e6f1;
             54: lstf_idft_rom = 36'h987252cf2;
             55: lstf_idft_rom = 36'h800000000;
             56: lstf_idft_rom = 36'h98726d30e;
             57: lstf_idft_rom = 36'hd8726190f;
             58: lstf_idft_rom = 36'h278de190f;
             59: lstf_idft_rom = 36'h678ded30e;
             60: lstf_idft_rom = 36'h800000000;
             61: lstf_idft_rom = 36'hb4c3a61c9;
             62: lstf_idft_rom = 36'h278de190f;
             63: lstf_idft_rom = 36'h79bc761c9;
             64: lstf_idft_rom = 36'h678dd2cf2;
             65: lstf_idft_rom = 36'h00001ffff;
             66: lstf_idft_rom = 36'h987252cf2;
             67: lstf_idft_rom = 36'h8643f61c9;
             68: lstf_idft_rom = 36'hd8726190f;
             69: lstf_idft_rom = 36'h4b3ca61c9;
             70: lstf_idft_rom = 36'h7fffc0000;
             71: lstf_idft_rom = 36'h4b3c99e37;
             72: lstf_idft_rom = 36'hd8725e6f1;
             73: lstf_idft_rom = 36'h8643c9e37;
             74: lstf_idft_rom = 36'h98726d30e;
             75: lstf_idft_rom = 36'h000020000;
             76: lstf_idft_rom = 36'h678ded30e;
             77: lstf_idft_rom = 36'h79bc49e37;
             78: lstf_idft_rom = 36'h278dde6f1;
             79: lstf_idft_rom = 36'hb4c399e37;
             80: lstf_idft_rom = 36'h7fffc0000;
             81: lstf_idft_rom = 36'h278dde6f1;
             82: lstf_idft_rom = 36'h987252cf2;
             83: lstf_idft_rom = 36'h98726d30e;
             84: lstf_idft_rom = 36'h278de190f;
             85: lstf_idft_rom = 36'h7fffc0000;
             86: lstf_idft_rom = 36'h278dde6f1;
             87: lstf_idft_rom = 36'h987252cf2;
             88: lstf_idft_rom = 36'h98726d30e;
             89: lstf_idft_rom = 36'h278de190f;
             90: lstf_idft_rom = 36'h7fffc0000;
             91: lstf_idft_rom = 36'h278dde6f1;
             92: lstf_idft_rom = 36'h987252cf2;
             93: lstf_idft_rom = 36'h98726d30e;
             94: lstf_idft_rom = 36'h278de190f;
             95: lstf_idft_rom = 36'h7fffc0000;
             96: lstf_idft_rom = 36'h278dde6f1;
             97: lstf_idft_rom = 36'h987252cf2;
             98: lstf_idft_rom = 36'h98726d30e;
             99: lstf_idft_rom = 36'h278de190f;
            100: lstf_idft_rom = 36'h800000000;
            101: lstf_idft_rom = 36'h000020000;
            102: lstf_idft_rom = 36'h7fffc0000;
            103: lstf_idft_rom = 36'h00001ffff;
            104: lstf_idft_rom = 36'h800000000;
            105: lstf_idft_rom = 36'h000020000;
            106: lstf_idft_rom = 36'h7fffc0000;
            107: lstf_idft_rom = 36'h00001ffff;
            108: lstf_idft_rom = 36'h800000000;
            109: lstf_idft_rom = 36'h000020000;
            110: lstf_idft_rom = 36'h7fffc0000;
            111: lstf_idft_rom = 36'h00001ffff;
            112: lstf_idft_rom = 36'h800000000;
            113: lstf_idft_rom = 36'h000020000;
            114: lstf_idft_rom = 36'h7fffc0000;
            115: lstf_idft_rom = 36'h00001ffff;
            116: lstf_idft_rom = 36'h800000000;
            117: lstf_idft_rom = 36'h000020000;
            118: lstf_idft_rom = 36'h7fffc0000;
            119: lstf_idft_rom = 36'h00001ffff;
            120: lstf_idft_rom = 36'h7fffc0000;
            121: lstf_idft_rom = 36'hd8725e6f1;
            122: lstf_idft_rom = 36'h98726d30e;
            123: lstf_idft_rom = 36'h678ded30e;
            124: lstf_idft_rom = 36'h278dde6f1;
            125: lstf_idft_rom = 36'h800000000;
            126: lstf_idft_rom = 36'h278de190f;
            127: lstf_idft_rom = 36'h678dd2cf2;
            128: lstf_idft_rom = 36'h987252cf2;
            129: lstf_idft_rom = 36'hd8726190f;
            130: lstf_idft_rom = 36'h7fffc0000;
            131: lstf_idft_rom = 36'hd8725e6f1;
            132: lstf_idft_rom = 36'h98726d30e;
            133: lstf_idft_rom = 36'h678ded30e;
            134: lstf_idft_rom = 36'h278dde6f1;
            135: lstf_idft_rom = 36'h800000000;
            136: lstf_idft_rom = 36'h278de190f;
            137: lstf_idft_rom = 36'h678dd2cf2;
            138: lstf_idft_rom = 36'h987252cf2;
            139: lstf_idft_rom = 36'hd8726190f;
            140: lstf_idft_rom = 36'h800000000;
            141: lstf_idft_rom = 36'h4b3ca61c9;
            142: lstf_idft_rom = 36'h278dde6f1;
            143: lstf_idft_rom = 36'h8643f61c9;
            144: lstf_idft_rom = 36'h678ded30e;
            145: lstf_idft_rom = 36'h00001ffff;
            146: lstf_idft_rom = 36'h98726d30e;
            147: lstf_idft_rom = 36'h79bc761c9;
            148: lstf_idft_rom = 36'hd8725e6f1;
            149: lstf_idft_rom = 36'hb4c3a61c9;
            150: lstf_idft_rom = 36'h7fffc0000;
            151: lstf_idft_rom = 36'hb4c399e37;
            152: lstf_idft_rom = 36'hd8726190f;
            153: lstf_idft_rom = 36'h79bc49e37;
            154: lstf_idft_rom = 36'h987252cf2;
            155: lstf_idft_rom = 36'h000020000;
            156: lstf_idft_rom = 36'h678dd2cf2;
            157: lstf_idft_rom = 36'h8643c9e37;
            158: lstf_idft_rom = 36'h278de190f;
            159: lstf_idft_rom = 36'h4b3c99e37;
            160: lstf_idft_rom = 36'h7fffc0000;
            161: lstf_idft_rom = 36'h987252cf2;
            162: lstf_idft_rom = 36'h278de190f;
            163: lstf_idft_rom = 36'h278dde6f1;
            164: lstf_idft_rom = 36'h98726d30e;
            165: lstf_idft_rom = 36'h7fffc0000;
            166: lstf_idft_rom = 36'h987252cf2;
            167: lstf_idft_rom = 36'h278de190f;
            168: lstf_idft_rom = 36'h278dde6f1;
            169: lstf_idft_rom = 36'h98726d30e;
            170: lstf_idft_rom = 36'h7fffc0000;
            171: lstf_idft_rom = 36'h987252cf2;
            172: lstf_idft_rom = 36'h278de190f;
            173: lstf_idft_rom = 36'h278dde6f1;
            174: lstf_idft_rom = 36'h98726d30e;
            175: lstf_idft_rom = 36'h7fffc0000;
            176: lstf_idft_rom = 36'h987252cf2;
            177: lstf_idft_rom = 36'h278de190f;
            178: lstf_idft_rom = 36'h278dde6f1;
            179: lstf_idft_rom = 36'h98726d30e;
            180: lstf_idft_rom = 36'h800000000;
            181: lstf_idft_rom = 36'h79bc761c9;
            182: lstf_idft_rom = 36'h987252cf2;
            183: lstf_idft_rom = 36'h4b3ca61c9;
            184: lstf_idft_rom = 36'hd8725e6f1;
            185: lstf_idft_rom = 36'h000020000;
            186: lstf_idft_rom = 36'h278dde6f1;
            187: lstf_idft_rom = 36'hb4c3a61c9;
            188: lstf_idft_rom = 36'h678dd2cf2;
            189: lstf_idft_rom = 36'h8643f61c9;
            190: lstf_idft_rom = 36'h7fffc0000;
            191: lstf_idft_rom = 36'h8643c9e37;
            192: lstf_idft_rom = 36'h678ded30e;
            193: lstf_idft_rom = 36'hb4c399e37;
            194: lstf_idft_rom = 36'h278de190f;
            195: lstf_idft_rom = 36'h00001ffff;
            196: lstf_idft_rom = 36'hd8726190f;
            197: lstf_idft_rom = 36'h4b3c99e37;
            198: lstf_idft_rom = 36'h98726d30e;
            199: lstf_idft_rom = 36'h79bc49e37;
            200: lstf_idft_rom = 36'h7fffc0000;
            201: lstf_idft_rom = 36'h800000000;
            202: lstf_idft_rom = 36'h7fffc0000;
            203: lstf_idft_rom = 36'h800000000;
            204: lstf_idft_rom = 36'h7fffc0000;
            205: lstf_idft_rom = 36'h800000000;
            206: lstf_idft_rom = 36'h7fffc0000;
            207: lstf_idft_rom = 36'h800000000;
            208: lstf_idft_rom = 36'h7fffc0000;
            209: lstf_idft_rom = 36'h800000000;
            210: lstf_idft_rom = 36'h7fffc0000;
            211: lstf_idft_rom = 36'h800000000;
            212: lstf_idft_rom = 36'h7fffc0000;
            213: lstf_idft_rom = 36'h800000000;
            214: lstf_idft_rom = 36'h7fffc0000;
            215: lstf_idft_rom = 36'h800000000;
            216: lstf_idft_rom = 36'h7fffc0000;
            217: lstf_idft_rom = 36'h800000000;
            218: lstf_idft_rom = 36'h7fffc0000;
            219: lstf_idft_rom = 36'h800000000;
            220: lstf_idft_rom = 36'h800000000;
            221: lstf_idft_rom = 36'h79bc49e37;
            222: lstf_idft_rom = 36'h98726d30e;
            223: lstf_idft_rom = 36'h4b3c99e37;
            224: lstf_idft_rom = 36'hd8726190f;
            225: lstf_idft_rom = 36'h00001ffff;
            226: lstf_idft_rom = 36'h278de190f;
            227: lstf_idft_rom = 36'hb4c399e37;
            228: lstf_idft_rom = 36'h678ded30e;
            229: lstf_idft_rom = 36'h8643c9e37;
            230: lstf_idft_rom = 36'h7fffc0000;
            231: lstf_idft_rom = 36'h8643f61c9;
            232: lstf_idft_rom = 36'h678dd2cf2;
            233: lstf_idft_rom = 36'hb4c3a61c9;
            234: lstf_idft_rom = 36'h278dde6f1;
            235: lstf_idft_rom = 36'h000020000;
            236: lstf_idft_rom = 36'hd8725e6f1;
            237: lstf_idft_rom = 36'h4b3ca61c9;
            238: lstf_idft_rom = 36'h987252cf2;
            239: lstf_idft_rom = 36'h79bc761c9;
            240: lstf_idft_rom = 36'h7fffc0000;
            241: lstf_idft_rom = 36'h98726d30e;
            242: lstf_idft_rom = 36'h278dde6f1;
            243: lstf_idft_rom = 36'h278de190f;
            244: lstf_idft_rom = 36'h987252cf2;
            245: lstf_idft_rom = 36'h7fffc0000;
            246: lstf_idft_rom = 36'h98726d30e;
            247: lstf_idft_rom = 36'h278dde6f1;
            248: lstf_idft_rom = 36'h278de190f;
            249: lstf_idft_rom = 36'h987252cf2;
            250: lstf_idft_rom = 36'h7fffc0000;
            251: lstf_idft_rom = 36'h98726d30e;
            252: lstf_idft_rom = 36'h278dde6f1;
            253: lstf_idft_rom = 36'h278de190f;
            254: lstf_idft_rom = 36'h987252cf2;
            255: lstf_idft_rom = 36'h7fffc0000;
            256: lstf_idft_rom = 36'h98726d30e;
            257: lstf_idft_rom = 36'h278dde6f1;
            258: lstf_idft_rom = 36'h278de190f;
            259: lstf_idft_rom = 36'h987252cf2;
            260: lstf_idft_rom = 36'h800000000;
            261: lstf_idft_rom = 36'h4b3c99e37;
            262: lstf_idft_rom = 36'h278de190f;
            263: lstf_idft_rom = 36'h8643c9e37;
            264: lstf_idft_rom = 36'h678dd2cf2;
            265: lstf_idft_rom = 36'h000020000;
            266: lstf_idft_rom = 36'h987252cf2;
            267: lstf_idft_rom = 36'h79bc49e37;
            268: lstf_idft_rom = 36'hd8726190f;
            269: lstf_idft_rom = 36'hb4c399e37;
            270: lstf_idft_rom = 36'h7fffc0000;
            271: lstf_idft_rom = 36'hb4c3a61c9;
            272: lstf_idft_rom = 36'hd8725e6f1;
            273: lstf_idft_rom = 36'h79bc761c9;
            274: lstf_idft_rom = 36'h98726d30e;
            275: lstf_idft_rom = 36'h00001ffff;
            276: lstf_idft_rom = 36'h678ded30e;
            277: lstf_idft_rom = 36'h8643f61c9;
            278: lstf_idft_rom = 36'h278dde6f1;
            279: lstf_idft_rom = 36'h4b3ca61c9;
            280: lstf_idft_rom = 36'h7fffc0000;
            281: lstf_idft_rom = 36'hd8726190f;
            282: lstf_idft_rom = 36'h987252cf2;
            283: lstf_idft_rom = 36'h678dd2cf2;
            284: lstf_idft_rom = 36'h278de190f;
            285: lstf_idft_rom = 36'h800000000;
            286: lstf_idft_rom = 36'h278dde6f1;
            287: lstf_idft_rom = 36'h678ded30e;
            288: lstf_idft_rom = 36'h98726d30e;
            289: lstf_idft_rom = 36'hd8725e6f1;
            290: lstf_idft_rom = 36'h7fffc0000;
            291: lstf_idft_rom = 36'hd8726190f;
            292: lstf_idft_rom = 36'h987252cf2;
            293: lstf_idft_rom = 36'h678dd2cf2;
            294: lstf_idft_rom = 36'h278de190f;
            295: lstf_idft_rom = 36'h800000000;
            296: lstf_idft_rom = 36'h278dde6f1;
            297: lstf_idft_rom = 36'h678ded30e;
            298: lstf_idft_rom = 36'h98726d30e;
            299: lstf_idft_rom = 36'hd8725e6f1;
            300: lstf_idft_rom = 36'h800000000;
            301: lstf_idft_rom = 36'h00001ffff;
            302: lstf_idft_rom = 36'h7fffc0000;
            303: lstf_idft_rom = 36'h000020000;
            304: lstf_idft_rom = 36'h800000000;
            305: lstf_idft_rom = 36'h00001ffff;
            306: lstf_idft_rom = 36'h7fffc0000;
            307: lstf_idft_rom = 36'h000020000;
            308: lstf_idft_rom = 36'h800000000;
            309: lstf_idft_rom = 36'h00001ffff;
            310: lstf_idft_rom = 36'h7fffc0000;
            311: lstf_idft_rom = 36'h000020000;
            312: lstf_idft_rom = 36'h800000000;
            313: lstf_idft_rom = 36'h00001ffff;
            314: lstf_idft_rom = 36'h7fffc0000;
            315: lstf_idft_rom = 36'h000020000;
            316: lstf_idft_rom = 36'h800000000;
            317: lstf_idft_rom = 36'h00001ffff;
            318: lstf_idft_rom = 36'h7fffc0000;
            319: lstf_idft_rom = 36'h000020000;
            320: lstf_idft_rom = 36'h7fffc0000;
            321: lstf_idft_rom = 36'h278de190f;
            322: lstf_idft_rom = 36'h98726d30e;
            323: lstf_idft_rom = 36'h987252cf2;
            324: lstf_idft_rom = 36'h278dde6f1;
            325: lstf_idft_rom = 36'h7fffc0000;
            326: lstf_idft_rom = 36'h278de190f;
            327: lstf_idft_rom = 36'h98726d30e;
            328: lstf_idft_rom = 36'h987252cf2;
            329: lstf_idft_rom = 36'h278dde6f1;
            330: lstf_idft_rom = 36'h7fffc0000;
            331: lstf_idft_rom = 36'h278de190f;
            332: lstf_idft_rom = 36'h98726d30e;
            333: lstf_idft_rom = 36'h987252cf2;
            334: lstf_idft_rom = 36'h278dde6f1;
            335: lstf_idft_rom = 36'h7fffc0000;
            336: lstf_idft_rom = 36'h278de190f;
            337: lstf_idft_rom = 36'h98726d30e;
            338: lstf_idft_rom = 36'h987252cf2;
            339: lstf_idft_rom = 36'h278dde6f1;
            340: lstf_idft_rom = 36'h800000000;
            341: lstf_idft_rom = 36'hb4c399e37;
            342: lstf_idft_rom = 36'h278dde6f1;
            343: lstf_idft_rom = 36'h79bc49e37;
            344: lstf_idft_rom = 36'h678ded30e;
            345: lstf_idft_rom = 36'h000020000;
            346: lstf_idft_rom = 36'h98726d30e;
            347: lstf_idft_rom = 36'h8643c9e37;
            348: lstf_idft_rom = 36'hd8725e6f1;
            349: lstf_idft_rom = 36'h4b3c99e37;
            350: lstf_idft_rom = 36'h7fffc0000;
            351: lstf_idft_rom = 36'h4b3ca61c9;
            352: lstf_idft_rom = 36'hd8726190f;
            353: lstf_idft_rom = 36'h8643f61c9;
            354: lstf_idft_rom = 36'h987252cf2;
            355: lstf_idft_rom = 36'h00001ffff;
            356: lstf_idft_rom = 36'h678dd2cf2;
            357: lstf_idft_rom = 36'h79bc761c9;
            358: lstf_idft_rom = 36'h278de190f;
            359: lstf_idft_rom = 36'hb4c3a61c9;
            360: lstf_idft_rom = 36'h7fffc0000;
            361: lstf_idft_rom = 36'h678ded30e;
            362: lstf_idft_rom = 36'h278de190f;
            363: lstf_idft_rom = 36'hd8726190f;
            364: lstf_idft_rom = 36'h98726d30e;
            365: lstf_idft_rom = 36'h800000000;
            366: lstf_idft_rom = 36'h987252cf2;
            367: lstf_idft_rom = 36'hd8725e6f1;
            368: lstf_idft_rom = 36'h278dde6f1;
            369: lstf_idft_rom = 36'h678dd2cf2;
            370: lstf_idft_rom = 36'h7fffc0000;
            371: lstf_idft_rom = 36'h678ded30e;
            372: lstf_idft_rom = 36'h278de190f;
            373: lstf_idft_rom = 36'hd8726190f;
            374: lstf_idft_rom = 36'h98726d30e;
            375: lstf_idft_rom = 36'h800000000;
            376: lstf_idft_rom = 36'h987252cf2;
            377: lstf_idft_rom = 36'hd8725e6f1;
            378: lstf_idft_rom = 36'h278dde6f1;
            379: lstf_idft_rom = 36'h678dd2cf2;
            380: lstf_idft_rom = 36'h800000000;
            381: lstf_idft_rom = 36'h8643c9e37;
            382: lstf_idft_rom = 36'h987252cf2;
            383: lstf_idft_rom = 36'hb4c399e37;
            384: lstf_idft_rom = 36'hd8725e6f1;
            385: lstf_idft_rom = 36'h00001ffff;
            386: lstf_idft_rom = 36'h278dde6f1;
            387: lstf_idft_rom = 36'h4b3c99e37;
            388: lstf_idft_rom = 36'h678dd2cf2;
            389: lstf_idft_rom = 36'h79bc49e37;
            390: lstf_idft_rom = 36'h7fffc0000;
            391: lstf_idft_rom = 36'h79bc761c9;
            392: lstf_idft_rom = 36'h678ded30e;
            393: lstf_idft_rom = 36'h4b3ca61c9;
            394: lstf_idft_rom = 36'h278de190f;
            395: lstf_idft_rom = 36'h000020000;
            396: lstf_idft_rom = 36'hd8726190f;
            397: lstf_idft_rom = 36'hb4c3a61c9;
            398: lstf_idft_rom = 36'h98726d30e;
            399: lstf_idft_rom = 36'h8643f61c9;
            default: lstf_idft_rom = 36'h0;
        endcase end
    endfunction
    // CORDIC atan(2^-i)，Q2.18
    `define LSTF_ATAN_N 18
    function [18:0] lstf_atan;
        input [4:0] idx;
        begin case (idx)
             0: lstf_atan = 19'd205887;
             1: lstf_atan = 19'd121542;
             2: lstf_atan = 19'd64220;
             3: lstf_atan = 19'd32599;
             4: lstf_atan = 19'd16363;
             5: lstf_atan = 19'd8189;
             6: lstf_atan = 19'd4096;
             7: lstf_atan = 19'd2048;
             8: lstf_atan = 19'd1024;
             9: lstf_atan = 19'd512;
            10: lstf_atan = 19'd256;
            11: lstf_atan = 19'd128;
            12: lstf_atan = 19'd64;
            13: lstf_atan = 19'd32;
            14: lstf_atan = 19'd16;
            15: lstf_atan = 19'd8;
            16: lstf_atan = 19'd4;
            17: lstf_atan = 19'd2;
            default: lstf_atan = 19'd0;
        endcase end
    endfunction
    // 倒数 LUT：idx -> round(32767/(1+(idx+0.5)/128))，Q15
    `define LSTF_INV_N 128
    `define LSTF_INV_BITS 7
    function [15:0] lstf_inv;
        input [6:0] idx;
        begin case (idx)
              0: lstf_inv = 16'd32640;
              1: lstf_inv = 16'd32387;
              2: lstf_inv = 16'd32139;
              3: lstf_inv = 16'd31895;
              4: lstf_inv = 16'd31654;
              5: lstf_inv = 16'd31417;
              6: lstf_inv = 16'd31183;
              7: lstf_inv = 16'd30953;
              8: lstf_inv = 16'd30727;
              9: lstf_inv = 16'd30503;
             10: lstf_inv = 16'd30283;
             11: lstf_inv = 16'd30066;
             12: lstf_inv = 16'd29852;
             13: lstf_inv = 16'd29641;
             14: lstf_inv = 16'd29433;
             15: lstf_inv = 16'd29228;
             16: lstf_inv = 16'd29025;
             17: lstf_inv = 16'd28826;
             18: lstf_inv = 16'd28629;
             19: lstf_inv = 16'd28435;
             20: lstf_inv = 16'd28244;
             21: lstf_inv = 16'd28055;
             22: lstf_inv = 16'd27868;
             23: lstf_inv = 16'd27684;
             24: lstf_inv = 16'd27503;
             25: lstf_inv = 16'd27324;
             26: lstf_inv = 16'd27147;
             27: lstf_inv = 16'd26972;
             28: lstf_inv = 16'd26800;
             29: lstf_inv = 16'd26630;
             30: lstf_inv = 16'd26462;
             31: lstf_inv = 16'd26296;
             32: lstf_inv = 16'd26132;
             33: lstf_inv = 16'd25970;
             34: lstf_inv = 16'd25810;
             35: lstf_inv = 16'd25652;
             36: lstf_inv = 16'd25497;
             37: lstf_inv = 16'd25342;
             38: lstf_inv = 16'd25190;
             39: lstf_inv = 16'd25040;
             40: lstf_inv = 16'd24891;
             41: lstf_inv = 16'd24744;
             42: lstf_inv = 16'd24599;
             43: lstf_inv = 16'd24456;
             44: lstf_inv = 16'd24314;
             45: lstf_inv = 16'd24174;
             46: lstf_inv = 16'd24035;
             47: lstf_inv = 16'd23898;
             48: lstf_inv = 16'd23763;
             49: lstf_inv = 16'd23629;
             50: lstf_inv = 16'd23497;
             51: lstf_inv = 16'd23366;
             52: lstf_inv = 16'd23236;
             53: lstf_inv = 16'd23108;
             54: lstf_inv = 16'd22982;
             55: lstf_inv = 16'd22857;
             56: lstf_inv = 16'd22733;
             57: lstf_inv = 16'd22610;
             58: lstf_inv = 16'd22489;
             59: lstf_inv = 16'd22369;
             60: lstf_inv = 16'd22250;
             61: lstf_inv = 16'd22133;
             62: lstf_inv = 16'd22017;
             63: lstf_inv = 16'd21902;
             64: lstf_inv = 16'd21788;
             65: lstf_inv = 16'd21675;
             66: lstf_inv = 16'd21564;
             67: lstf_inv = 16'd21454;
             68: lstf_inv = 16'd21344;
             69: lstf_inv = 16'd21236;
             70: lstf_inv = 16'd21129;
             71: lstf_inv = 16'd21023;
             72: lstf_inv = 16'd20919;
             73: lstf_inv = 16'd20815;
             74: lstf_inv = 16'd20712;
             75: lstf_inv = 16'd20610;
             76: lstf_inv = 16'd20509;
             77: lstf_inv = 16'd20410;
             78: lstf_inv = 16'd20311;
             79: lstf_inv = 16'd20213;
             80: lstf_inv = 16'd20116;
             81: lstf_inv = 16'd20020;
             82: lstf_inv = 16'd19925;
             83: lstf_inv = 16'd19831;
             84: lstf_inv = 16'd19737;
             85: lstf_inv = 16'd19645;
             86: lstf_inv = 16'd19553;
             87: lstf_inv = 16'd19463;
             88: lstf_inv = 16'd19373;
             89: lstf_inv = 16'd19284;
             90: lstf_inv = 16'd19195;
             91: lstf_inv = 16'd19108;
             92: lstf_inv = 16'd19021;
             93: lstf_inv = 16'd18935;
             94: lstf_inv = 16'd18850;
             95: lstf_inv = 16'd18766;
             96: lstf_inv = 16'd18682;
             97: lstf_inv = 16'd18599;
             98: lstf_inv = 16'd18517;
             99: lstf_inv = 16'd18436;
            100: lstf_inv = 16'd18355;
            101: lstf_inv = 16'd18275;
            102: lstf_inv = 16'd18196;
            103: lstf_inv = 16'd18117;
            104: lstf_inv = 16'd18039;
            105: lstf_inv = 16'd17962;
            106: lstf_inv = 16'd17886;
            107: lstf_inv = 16'd17810;
            108: lstf_inv = 16'd17734;
            109: lstf_inv = 16'd17660;
            110: lstf_inv = 16'd17586;
            111: lstf_inv = 16'd17512;
            112: lstf_inv = 16'd17439;
            113: lstf_inv = 16'd17367;
            114: lstf_inv = 16'd17296;
            115: lstf_inv = 16'd17225;
            116: lstf_inv = 16'd17154;
            117: lstf_inv = 16'd17084;
            118: lstf_inv = 16'd17015;
            119: lstf_inv = 16'd16946;
            120: lstf_inv = 16'd16878;
            121: lstf_inv = 16'd16810;
            122: lstf_inv = 16'd16743;
            123: lstf_inv = 16'd16677;
            124: lstf_inv = 16'd16611;
            125: lstf_inv = 16'd16545;
            126: lstf_inv = 16'd16480;
            127: lstf_inv = 16'd16416;
            default: lstf_inv = 16'd0;
        endcase end
    endfunction

    // ── 定点参数 ────────────────────────────────────────────────────────────
    localparam integer SX   = 13;     // DFT 累加 -> X 的右移
    localparam integer QTW  = 17;     // 旋转因子 / p_b 的 Q 格式
    localparam integer HTG  = 23;     // 归一化后 |Hn|max 的位号
    localparam integer TAP_SFT     = 13;         // 溢出帧的 IDFT 抽头 Q24 -> Q(24-TAP_SFT)
    localparam integer TAP_OUT_SFT = 24 - TAP_SFT;  // FIR 末级补回
    localparam [63:0]  GATE_K = 64'd46080;      // 180 << 2*(QTW-SX)
    localparam integer NFR  = 256;    // 每帧字数

    // ── 状态 ────────────────────────────────────────────────────────────────
    localparam [4:0] ST_IDLE   = 5'd0,
                     ST_ET     = 5'd1,
                     ST_R1     = 5'd2,
                     ST_ATAN   = 5'd3,
                     ST_ROT    = 5'd4,
                     ST_PB     = 5'd5,
                     ST_DFT    = 5'd6,
                     ST_GATE   = 5'd7,
                     ST_LS     = 5'd8,
                     ST_NORM   = 5'd9,
                     ST_INTERP = 5'd10,
                     ST_PW     = 5'd11,
                     ST_RECIP  = 5'd12,
                     ST_IDFT   = 5'd13,
                     ST_FIR    = 5'd14,
                     ST_BYP    = 5'd15,
                     ST_NEXT   = 5'd16,
                     ST_PWEPS  = 5'd17,
                     ST_GATE2  = 5'd18;

    // 串行可变移位引擎的相位：load -> shift(|s| 拍) -> finish(舍入+clip) -> write。
    // ST_NORM / ST_RECIP / ST_IDFT 三处可变移位原来共用一份 56bit 桶形移位器；
    // 那条路 logic ~6.1ns、31~33 级，是 eq WNS 的源头，而且 2.5ns 的路由拥塞会把它
    // 放大到 16.7ns。现在全部改成一个 56bit 串行移位寄存器，每帧多 ~3.3k 拍
    // （最坏 14.3k / 预算 20.2k）。方向/位数在 start 那拍锁存。
    localparam [1:0] NM_IDLE  = 2'd0,
                     NM_SHIFT = 2'd1,
                     NM_FIN   = 2'd2,
                     NM_WR    = 2'd3;

    // ════════════════════════════════════════════════════════════════════════
    //  公共函数
    // ════════════════════════════════════════════════════════════════════════
    // 带舍入的算术移位；s<0 时左移（与 python rnd_shift 一致）
    function signed [55:0] rnds;
        input signed [55:0] v;
        input signed [7:0]  s;
        begin
            if (s == 8'sd0)      rnds = v;
            else if (s > 8'sd0)  rnds = (v + (56'sd1 <<< (s[5:0] - 6'd1))) >>> s[5:0];
            else                 rnds = v <<< (-s);
        end
    endfunction

    function signed [24:0] clip25;
        input signed [55:0] v;
        begin
            if (v > 56'sd16777215)        clip25 = 25'sd16777215;
            else if (v < -56'sd16777216)  clip25 = -25'sd16777216;
            else                          clip25 = v[24:0];
        end
    endfunction

    function signed [17:0] clip18;
        input signed [55:0] v;
        begin
            if (v > 56'sd131071)          clip18 = 18'sd131071;
            else if (v < -56'sd131072)    clip18 = -18'sd131072;
            else                          clip18 = v[17:0];
        end
    endfunction

    function signed [15:0] clip16;
        input signed [55:0] v;
        begin
            if (v > 56'sd32767)           clip16 = 16'sd32767;
            else if (v < -56'sd32768)     clip16 = -16'sd32768;
            else                          clip16 = v[15:0];
        end
    endfunction

    function [48:0] uabs49;
        input signed [48:0] v;
        begin
            uabs49 = v[48] ? (-v) : v;
        end
    endfunction

    // LSTF_SIGN = [1,-1,1,-1,-1,1,-1,-1,1,1,1,1]
    function lstf_sign;
        input [3:0] p;
        begin
            case (p)
                4'd0, 4'd2, 4'd5, 4'd8, 4'd9, 4'd10, 4'd11: lstf_sign = 1'b1;
                default:                                     lstf_sign = 1'b0;
            endcase
        end
    endfunction

    // FIR 系数序号：fir[j] = taps[(29-j)%20]
    function [4:0] fir_idx;
        input [4:0] j;
        begin
            fir_idx = (j < 5'd10) ? (5'd9 - j) : (5'd29 - j);
        end
    endfunction

    // 归一化：nh>=0 左移，否则带舍入右移，再饱和到 25bit。
    // 左移分支不涉及舍入，所以 nh>=0 时 rnds(vv,-nh) 与 vv<<<nh 完全等价，
    // 统一走 rnds 让 ST_NORM 也能复用下面那份共用移位器。
    // （原独立 hnorm 函数已删除，等价式：clip25(rnds({7{v[48]},v}, -nh))）

    // ════════════════════════════════════════════════════════════════════════
    //  1. 帧缓存
    // ════════════════════════════════════════════════════════════════════════
    (* ram_style = "block" *) reg [31:0] frames [0:2047];   // 64Kbit：必须落 BRAM
    reg  [10:0] wr_addr;
    reg         wr_en;
    reg  [31:0] wr_data;

    reg  [7:0]  wr_word;       // 本帧已收字数
    reg  [2:0]  wr_slot;
    reg  [2:0]  rd_slot;
    reg  [3:0]  frames_avail;  // 未处理帧数（不含正在处理的那帧）
    reg         frame_in_pulse;// 捕获块每收满一帧打一拍；计数只在 FSM 块里更新
    reg         dropping;
    reg  [2:0]  work_slot;
    reg  [31:0] stat_drop_r;
    reg  [31:0] mem_b_q;

    // ════════════════════════════════════════════════════════════════════════
    //  2. MAC 引擎
    // ════════════════════════════════════════════════════════════════════════
    reg         iss;
    reg  [1:0]  iss_a_sel;     // 0 = 直接寄存器, 1 = 帧缓存
    reg  [1:0]  iss_b_sel;     // 0 = 直接寄存器, 1 = ROM, 2 = 帧缓存, 3 = 0
    reg         iss_b_conj;
    reg         iss_acc;
    reg         iss_rom_i;
    reg  [10:0] iss_addr;
    reg  [8:0]  iss_rom;
    reg  signed [24:0] iss_a_re, iss_a_im;
    reg  signed [17:0] iss_b_re, iss_b_im;

    reg         iss_d;
    reg  [1:0]  a_sel_d, b_sel_d;
    reg         bconj_d;
    reg         accen_d;
    reg         romi_d;
    reg  signed [24:0] a_l_re, a_l_im;
    reg  signed [17:0] b_l_re, b_l_im;

    reg         mul_v_d;
    reg         mulen_d;
    reg  signed [24:0] mul_ar, mul_ai;
    reg  signed [17:0] mul_br, mul_bi;

    reg         prd_v_d;
    reg         prden_d;
    // 复数乘的四个乘积各落自己的 DSP P 寄存器。原来 (ar*br)-(ai*bi) 被综合成
    // 两个 DSP 的 PCIN 级联：mul_bi -> 乘 -> PCOUT -> 下一级 PCIN 整版只有
    // -0.059 ns（而且 68 个失败端点里绝大多数是这个形态）。求和移回 fabric，
    // 且不加流水级 —— pa/pb 正好在 prd_v_d/prden_d 有效的同一拍就绪，直接进
    // 累加器，issue->acc 的延迟与原来逐拍相同，状态机一行都不用改。
    reg  signed [43:0] pa_re, pb_re, pa_im, pb_im;
    wire signed [43:0] prd_re_c = pa_re - pb_re;
    wire signed [43:0] prd_im_c = pa_im + pb_im;

    reg  signed [55:0] acc_re, acc_im;

    // ════════════════════════════════════════════════════════════════════════
    //  3. msb 扫描（顺序找最高有效位，避开 56bit 优先级编码器的长路径）
    // ════════════════════════════════════════════════════════════════════════
    reg  [55:0] scan_v_in;
    reg  [55:0] scan_v;
    reg  [5:0]  scan_i;
    reg  [5:0]  scan_msb;
    reg         scan_run;
    reg         scan_done;
    reg         scan_start;
    reg         clr;

    // ════════════════════════════════════════════════════════════════════════
    //  4. FSM 寄存器
    // ════════════════════════════════════════════════════════════════════════
    reg  [4:0]  state;
    reg  [8:0]  cyc;       // 通用循环计数
    reg  [7:0]  rn;        // CORR 项 n
    reg  [2:0]  rq;        // CORR 相位
    reg  [5:0]  it;        // CORDIC 迭代
    reg  [1:0]  asub;      // ATAN 子状态
    reg  [3:0]  rsub;      // ROT / RECIP 子状态
    reg  [1:0]  nsub;      // NORM 子状态
    // 串行可变移位引擎（ST_NORM / ST_RECIP / ST_IDFT 共用）
    reg  [1:0]  nm_ph;     // NM_IDLE / NM_SHIFT / NM_FIN / NM_WR
    reg  [5:0]  nm_cnt;    // 剩余移位拍数
    reg         nm_left;   // 1 = 左移（rnds 的 s <= 0）
    reg  signed [55:0] nm_sr;   // 串行移位寄存器
    reg         nm_rnd;    // 右移最后一次移出的位（即原 bit(s-1)）
    reg  signed [24:0] nm_out;  // 裁剪结果，NM_WR 拍写回
    // 第二遍（抽头右移 TAP_SFT）的结果，与 nm_out 同拍寄存。放在这里是为了
    // 不在 nm 引擎的裁剪路径上再加一级 mux —— 选择只出现在 tap 入链处。
    reg  signed [24:0] nm_out_tap;
    reg  signed [55:0] nm_src;  // 本值装载源（按状态选择）
    reg         nm_src_left;    // 本值移位方向
    reg  [5:0]  nm_src_mag;     // 本值移位位数
    reg  [3:0]  pbp;       // p_b 序号
    reg  [2:0]  pbq;       // p_b 相位
    reg  [3:0]  db, dp;    // DFT 块 / bin
    reg  [4:0]  pk;        // PW 序号
    reg  [4:0]  im;        // IDFT 输出序号
    reg  [4:0]  rk;        // 倒数 bin
    reg  [7:0]  fn;        // FIR 输出序号
    reg  [8:0]  bn;        // 旁路输出序号

    reg  signed [24:0] xr, xi;                  // DFT 输出 X
    reg  signed [55:0] rr, ri;                  // lag-20 相关
    reg  [55:0] et_reg;                         // 前 200 点能量
    reg  [55:0] sp_reg;                         // 对齐前 |X|^2 之和
    // 单个 bin 的对齐累加器（DFT 循环改成 dp 外 / db 内后不再需要 12 深数组）
    reg  signed [47:0] bin_re, bin_im;
    reg  signed [35:0] pb_sr [0:9];             // {im,re}，10 级环形链
    reg  signed [17:0] pb_cur_re, pb_cur_im;    // 当前 p_b，供下一级乘法
    reg  signed [17:0] c_os, s_in;              // CFO 旋转因子
    reg  signed [22:0] theta_r;                 // atan2 结果 Q2.18
    reg  signed [25:0] xc, yc;                  // CORDIC 工作寄存器
    reg  signed [22:0] zc;
    // ── 顺序访问的数组一律做成移位链 ──────────────────────────────────
    // 读地址固定为链顶（[11]/[19]），写/推进都是整链上移，综合出的是纯
    // 触发器（无 12/20:1 读 mux）。约定：新值进 [0]，最老的到链顶。
    reg  signed [48:0] h_sr_re [0:11], h_sr_q [0:11];   // H_raw，bin 0..11
    reg  [48:0] hmv;
    reg  signed [48:0] hri_r, hrq_r;            // 每 bin 的 H_raw 流水寄存器
    reg  [5:0]  eH;
    reg  signed [24:0] hn_re [0:11], hn_im [0:11];
    // k=0 的中点 bin = (Hn5+Hn6)>>1：25bit 相加会溢出到第 26 位，必须先扩宽再移位
    wire signed [25:0] hmid_re = $signed(hn_re[5]) + $signed(hn_re[6]);
    wire signed [25:0] hmid_im = $signed(hn_im[5]) + $signed(hn_im[6]);
    // H20 不再单独存一份：它就是 Hn 的分段展开（k=-10..-7->Hn0，k=-6..-1->Hn0..5，
    // k=0->中点，k=1..6->Hn6..11，k=7..9->Hn11），用时按 k 组合读出即可。
    // k 在 ST_PW 取 pk、ST_RECIP 取 rk；两个状态互斥，共用一份 12:1 读 mux。
    wire [4:0] h20_k = (state == ST_PW) ? pk : rk;
    wire [3:0] h20_ix = (h20_k <= 5'd4) ? 4'd0 :
                        (h20_k <= 5'd9) ? (h20_k[3:0] - 4'd4) :
                        (h20_k <= 5'd16) ? (h20_k[3:0] - 4'd5) : 4'd11;
    wire       h20_mid = (h20_k == 5'd10);
    wire signed [24:0] h20_v_re = h20_mid ? (hmid_re >>> 1) : hn_re[h20_ix];
    wire signed [24:0] h20_v_im = h20_mid ? (hmid_im >>> 1) : hn_im[h20_ix];
    reg  [55:0] pl_sr [0:19];                   // |H20|^2，pk 顺序写、rk 顺序读
    reg  [55:0] sump, eps_r;
    // |H|^2 + eps 先寄存再进倒数桶形移位：原来 eps_r -> 56bit 加法 -> 变速移位
    // -> inv ROM -> r_reg 全在一拍，整版实测 -0.095 ns（21 级、13 个 CARRY4）。
    // pl_sr[19] 在 ST_RECIP 期间不推进，dsum 一拍采一次就够。
    reg  [55:0] dsum;
    // ST_PW 三级流水：h20 选值 -> 两路平方 -> 求和/累加/入链
    reg  [1:0]  pwp;
    reg  signed [24:0] h20p_re, h20p_im;
    reg  signed [49:0] pr, pi;
    reg  signed [49:0] ssr, ssi;               // ST_DFT 的 xr^2 / xi^2 流水
    reg  [5:0]  e_r;
    reg  [17:0] m_reg;
    reg  signed [17:0] r_reg;
    // Newton 一次迭代拆两拍：u = 2 - m*r 先落寄存器，再算下一拍 r
    reg  signed [17:0] u_reg;
    // W 支路：先锁 H20 选值，再乘 r，最后进串行引擎（每级一拍）
    reg  signed [24:0] h20w_re, h20w_im;
    reg  signed [42:0] hp_re, hp_im;
    reg  signed [49:0] w_sr [0:19];             // {im,re}，rk 顺序写、cyc 顺序读
    reg  signed [49:0] tap_sr [0:19];           // {im,re}，按 FIR 读序写入
    reg  signed [24:0] w_re_lat, tap_re_lat;    // re 先算、下一拍和 im 一起入链
    // IDFT 抽头定标：第一遍 Q24；若有分量放不进 25bit（|tap|>=1.0）则整帧重跑，
    // 第二遍 >>TAP_SFT。tap_ovf 在 IDFT 入口清、在 NM_FIN 累计。
    reg         tap_ovf;
    reg         tap_scale;

    reg         stat_gate_r;
    reg  [63:0] gate_l, gate_r;                 // 门控比较的两侧，先寄存再比
    reg  [22:0] stat_theta_r;

    // ════════════════════════════════════════════════════════════════════════
    //  5. 输出 FIFO
    // ════════════════════════════════════════════════════════════════════════
    (* ram_style = "block" *) reg [33:0] ofifo [0:511];   // {tuser, tlast, Q, I}
    reg  [8:0]  wrp, rdp;
    reg  [9:0]  cnt;
    reg  [33:0] out_q;
    reg         out_v;

    // ════════════════════════════════════════════════════════════════════════
    //  6. 组合派生信号
    // ════════════════════════════════════════════════════════════════════════
    wire [10:0] base = {work_slot, 8'h00};

    // 帧缓存读出（地址组合、数据寄存 -> 1 拍延迟）
    always @(posedge clk) begin
        mem_b_q <= frames[iss_addr];
    end

    // 常数表 ROM（地址组合、数据寄存 -> 1 拍延迟）
    reg  [35:0] dft_q, idft_q;
    always @(posedge clk) begin
        dft_q  <= lstf_dft_rom(iss_rom[7:0]);
        idft_q <= lstf_idft_rom(iss_rom);
    end
    wire [35:0] rom_q = romi_d ? idft_q : dft_q;
    wire signed [17:0] rom_cos = rom_q[35:18];
    wire signed [17:0] rom_sin = rom_q[17:0];

    // 取操作数（issue 后一拍，RAM/ROM 数据正好到）
    wire signed [24:0] cap_ar = (a_sel_d == 2'd1) ? {{9{mem_b_q[15]}}, mem_b_q[15:0]} : a_l_re;
    wire signed [24:0] cap_ai = (a_sel_d == 2'd1) ? {{9{mem_b_q[31]}}, mem_b_q[31:16]} : a_l_im;
    wire signed [17:0] braw_re = (b_sel_d == 2'd1) ? rom_cos :
                                 (b_sel_d == 2'd2) ? {{2{mem_b_q[15]}}, mem_b_q[15:0]} :
                                 (b_sel_d == 2'd3) ? 18'sd0 : b_l_re;
    wire signed [17:0] braw_im = (b_sel_d == 2'd1) ? rom_sin :
                                 (b_sel_d == 2'd2) ? {{2{mem_b_q[31]}}, mem_b_q[31:16]} :
                                 (b_sel_d == 2'd3) ? 18'sd0 : b_l_im;
    wire signed [17:0] cap_br = braw_re;
    wire signed [17:0] cap_bi = bconj_d ? (-braw_im) : braw_im;

    // DFT 输出（组合舍入，25bit 与模型一致；16bit 输入保证 |X| < 2^24）
    wire signed [55:0] xnew56  = (acc_re + 56'sd4096) >>> SX;
    wire signed [55:0] xinew56 = (acc_im + 56'sd4096) >>> SX;
    wire signed [24:0] xr_new = xnew56[24:0];
    wire signed [24:0] xi_new = xinew56[24:0];

    // Sp 专用平方器（ST_DFT 用），四级流水：
    //   cyc=23  xr/xi 落寄存器（脱离 acc 的 56bit 加法）
    //   cyc=24  x^2 拆成两片单 DSP 的部分积 x*lo / x*hi（片内 PREG，无 PCIN 级联）
    //   cyc=25  拼合 (x*hi)<<18 + x*lo 落 ssr/ssi
    //   cyc=26  求和累加进 sp_reg
    // 原来 25x25 平方被综合成两片 DSP 的 PCOUT->PCIN 级联，整版 -0.066 ns。
    // 拆法：x = hs*2^18 + ls（ls = x[17:0] 有符号；hs = 符号扩展(x[24:18]) + x[17]），
    // 故 x*x = (x*hs)<<18 + x*ls，两个单 DSP 乘法，结果与 x*x 逐位相同。
    // ST_PW 走下面的三级流水。
    // 注意：两处必须都 $signed 成 8 bit 再加。若写成 $signed(x[24:18]) + {7'd0,x[17]}，
    // 拼接使整个表达式变无符号，7 bit 的有符号数会被**零扩展**（x=-1 时 -1 变 127，
    // hs 出 -128），平方就错 2^25；只有 sp_reg（门控判决）受影响，仿真里表现为
    // 某一帧该旁路却去均衡。
    wire signed [7:0]  xr_hs = $signed({xr[24], xr[24:18]}) + $signed({7'd0, xr[17]});
    wire signed [7:0]  xi_hs = $signed({xi[24], xi[24:18]}) + $signed({7'd0, xi[17]});
    wire signed [17:0] xr_ls = xr[17:0];
    wire signed [17:0] xi_ls = xi[17:0];
    (* use_dsp48 = "yes" *) wire signed [32:0] xr_hi_n = xr * xr_hs;
    (* use_dsp48 = "yes" *) wire signed [32:0] xi_hi_n = xi * xi_hs;
    (* use_dsp48 = "yes" *) wire signed [42:0] xr_lo_n = xr * xr_ls;
    (* use_dsp48 = "yes" *) wire signed [42:0] xi_lo_n = xi * xi_ls;
    reg  signed [32:0] xr_hi_q, xi_hi_q;
    reg  signed [42:0] xr_lo_q, xi_lo_q;
    wire signed [49:0] ss_r2 = ({{17{xr_hi_q[32]}}, xr_hi_q} <<< 18) + {{7{xr_lo_q[42]}}, xr_lo_q};
    wire signed [49:0] ss_i2 = ({{17{xi_hi_q[32]}}, xi_hi_q} <<< 18) + {{7{xi_lo_q[42]}}, xi_lo_q};
    wire        [50:0] ss_psum = ssr + ssi;
    // ST_PW 流水第 3 级：两路平方相加，结果入 pl 链并累加进 sumP
    wire        [50:0] ss_val = pr + pi;

    // CORDIC：atan2（向量模式，y->0）
    wire signed [55:0] rr_abs = rr[55] ? (-rr) : rr;
    wire signed [55:0] ri_abs = ri[55] ? (-ri) : ri;
    wire [55:0] atan_m = (rr_abs > ri_abs) ? rr_abs : ri_abs;
    wire [5:0]  ash = (scan_msb > 6'd17) ? (scan_msb - 6'd17) : 6'd0;

    wire signed [25:0] xnew_a = (yc < 0) ? (xc - (yc >>> it[4:0])) : (xc + (yc >>> it[4:0]));
    wire signed [25:0] ynew_a = (yc < 0) ? (yc + (xc >>> it[4:0])) : (yc - (xc >>> it[4:0]));
    wire signed [22:0] znew_a = (yc < 0) ? (zc - lstf_atan(it[4:0])) : (zc + lstf_atan(it[4:0]));

    // CORDIC：旋转（z->0）
    wire signed [25:0] xnew_r = (zc >= 0) ? (xc - (yc >>> it[4:0])) : (xc + (yc >>> it[4:0]));
    wire signed [25:0] ynew_r = (zc >= 0) ? (yc + (xc >>> it[4:0])) : (yc - (xc >>> it[4:0]));
    wire signed [22:0] znew_r = (zc >= 0) ? (zc - lstf_atan(it[4:0])) : (zc + lstf_atan(it[4:0]));
    wire signed [25:0] xsh = (xnew_r + 26'sd8) >>> 4;
    wire signed [25:0] ysh = (ynew_r + 26'sd8) >>> 4;
    wire signed [17:0] cos_c = (xsh > 26'sd131071) ? 18'sd131071 : xsh[17:0];
    wire signed [17:0] sin_c = (ysh > 26'sd131071)  ? 18'sd131071 :
                               (ysh < -26'sd131072) ? -18'sd131072 : ysh[17:0];
    // 最后一轮 CORDIC 的 cos/sin：xnew_r/ynew_r 已在上一拍写回 xc/yc，
    // 这里直接从寄存器取值，避免“更新链 + 取角链”挤在同一拍。
    wire signed [25:0] xsh_f = (xc + 26'sd8) >>> 4;
    wire signed [25:0] ysh_f = (yc + 26'sd8) >>> 4;
    wire signed [17:0] cos_f = (xsh_f > 26'sd131071) ? 18'sd131071 : xsh_f[17:0];
    wire signed [17:0] sin_f = (ysh_f > 26'sd131071)  ? 18'sd131071 :
                               (ysh_f < -26'sd131072) ? -18'sd131072 : ysh_f[17:0];

    // H_raw = sign*[(ar+ai) + j(aq-ai)]
    // bin_re/bin_im 是当前 bin 已累加的 10 个 block；cyc=28 时先把本 block 的
    // acc 加上（与原来 accbin + acc_re[47:0] 的截断方式完全一致）。
    wire signed [47:0] bin_re_nxt = bin_re + acc_re[47:0];
    wire signed [47:0] bin_im_nxt = bin_im + acc_im[47:0];
    wire signed [48:0] hsum_re = $signed(bin_re_nxt) + $signed(bin_im_nxt);
    wire signed [48:0] hsum_im = $signed(bin_im_nxt) - $signed(bin_re_nxt);
    wire signed [48:0] hri_c = lstf_sign(dp) ?  hsum_re : (-hsum_re);
    wire signed [48:0] hrq_c = lstf_sign(dp) ?  hsum_im : (-hsum_im);
    wire [48:0] hi_abs = uabs49(hri_c);
    wire [48:0] hq_abs = uabs49(hrq_c);
    // hri_c/hrq_c 在 cyc=28 落寄存器，cyc=29 再做 |·| 和 max，断开
    // “bin 累加 -> ±求和 -> 取绝对值 -> 49bit 比较 -> hmv CE” 一长串
    wire [48:0] hi_abs_r = uabs49(hri_r);
    wire [48:0] hq_abs_r = uabs49(hrq_r);
    // |·| 的 49bit 取补也是一条长进位链，再单独一拍寄存，比较只用寄存器值
    reg  [48:0] hi_abs_q, hq_abs_q;
    wire [48:0] hmv_nxt3 = (hi_abs_q > hmv && hi_abs_q > hq_abs_q) ? hi_abs_q :
                           (hq_abs_q > hmv) ? hq_abs_q : hmv;

    // 倒数：d -> 尾数 m（18bit，bit17=1）
    wire [55:0] d_cur = pl_sr[19] + eps_r;
    wire signed [7:0] shm = $signed({2'b00, scan_msb}) - 8'sd17;
    // 移位用已寄存的 dsum；m_c 落 m_reg 后，倒数 ROM 的索引改从 m_reg 取，
    // 于是“加法 / 移位 / ROM”分成三拍，每拍都只有一段。
    wire [55:0] dshift = (shm >= 8'sd0) ? (dsum >> shm[5:0]) : (dsum << (-shm));
    wire [17:0] m_c = dshift[17:0];
    wire [6:0]  idx_c = m_reg[16:10];

    // Newton 迭代：r <- r*(2 - m*r)，m 是 Q17。两次迭代各拆成
    //   前半拍：u = 65536 - (m*r >> 17) -> u_reg
    //   后半拍：r = (r*u >> 15) 饱和 -> r_reg
    wire signed [35:0] mr = $signed({1'b0, m_reg}) * r_reg;
    // m*r 的 DSP 结果先寄存，下一拍再做 65536 - (mr>>17)
    reg  signed [35:0] mr_q;
    wire signed [35:0] t_c = mr_q >>> 17;
    wire signed [17:0] u_c = 18'sd65536 - t_c[17:0];
    wire signed [35:0] ru = r_reg * u_reg;
    // ru 先寄存：DSP 输出 -> 右移/饱和/下限 的链太长，拆成两拍
    reg  signed [35:0] ru_q;
    wire signed [17:0] r1_c = ru_q >>> 15;
    wire signed [17:0] r1_clip = (r1_c > 18'sd65535) ? 18'sd65535 :
                                 (r1_c < -18'sd65536) ? -18'sd65536 : r1_c;
    wire signed [17:0] r_new = (r1_clip <= 18'sd0) ? 18'sd1 : r1_clip;

    wire signed [42:0] hprod_re = $signed(h20w_re) * r_reg;
    wire signed [42:0] hprod_im = -($signed(h20w_im) * r_reg);

    // p_b 链下一级（ST_ROT 里 pb_cur 被预置成 1+j0）
    wire signed [17:0] pb_new_re = clip18(rnds(acc_re, 8'sd17));
    wire signed [17:0] pb_new_im = clip18(rnds(acc_im, 8'sd17));

    // ── 串行可变移位引擎 ───────────────────────────────────────────────
    // 右移用恒等式 (v + (1<<(s-1))) >>> s == (v >>> s) + v[s-1]；
    // nm_rnd 就是串行右移最后移出的 v[s-1]，左移时恒 0。
    // 三处可变移位（ST_NORM / ST_RECIP / ST_IDFT）在时间上互斥，共用一个
    // 56bit 串行移位寄存器。原来的 56bit 桶形移位器（含 state mux、56bit
    // 舍入加法器）整块去掉，关键路径只剩“40/56bit 加法 + clip”一段。
    wire [3:0] sh_bin = cyc[4:1];       // ST_NORM：值序号 0..23
    wire signed [55:0] nm_y = nm_sr + $signed({55'd0, nm_rnd});

    // IDFT 抽头：nm_y 是 Q24。只要有分量放不进 25bit（|tap| >= 1.0），第一遍
    // 算完后整帧重跑，第二遍 >>TAP_SFT。移位量是常数，综合只是取高位。
    wire        nm_y_ovf   = (nm_y > 56'sd16777215) || (nm_y < -56'sd16777216);
    wire signed [55:0] nm_y_tap = nm_y >>> TAP_SFT;

    // 各状态的移位方向/位数
    //   NORM：s = scan_msb-23，<=0 左移
    //   RECIP：s = e_r-29，<=0 左移
    //   IDFT：s = eH-17，<=0 左移
    wire        nm_left_n = (scan_msb <= 6'd23);
    wire [5:0]  nm_mag_n  = (scan_msb <= 6'd23) ? (6'd23 - scan_msb)
                                                : (scan_msb - 6'd23);
    wire        nm_left_w = (e_r < 6'd29);
    wire [5:0]  nm_mag_w  = (e_r < 6'd29) ? (6'd29 - e_r) : (e_r - 6'd29);
    wire        nm_left_t = (eH < 6'd17);
    wire [5:0]  nm_mag_t  = (eH < 6'd17) ? (6'd17 - eH) : (eH - 6'd17);

    wire nm_start = (nm_ph == NM_IDLE) &&
                    (((state == ST_NORM)  && (nsub == 2'd2)) ||
                     ((state == ST_RECIP) && ((rsub == 4'd8) || (rsub == 4'd9))) ||
                     ((state == ST_IDFT)  && ((cyc == 9'd23) || (cyc == 9'd24))));
    wire nm_done  = (nm_ph == NM_WR);
    // IDFT 第一遍的入口（与 ST_RECIP -> ST_IDFT 的转移同一拍），用于清 tap_ovf
    wire idft_first = (state == ST_RECIP) && (rsub == 4'd9) && nm_done &&
                      (rk == 5'd19);

    always @(*) begin
        nm_src      = 56'sd0;
        nm_src_left = 1'b0;
        nm_src_mag  = 6'd0;
        case (state)
        ST_NORM: begin
            nm_src      = cyc[0] ? {{7{h_sr_q[11][48]}}, h_sr_q[11]}
                                 : {{7{h_sr_re[11][48]}}, h_sr_re[11]};
            nm_src_left = nm_left_n;
            nm_src_mag  = nm_mag_n;
        end
        ST_RECIP: begin
            nm_src      = (rsub == 4'd8) ? {{13{hp_re[42]}}, hp_re}
                                         : {{13{hp_im[42]}}, hp_im};
            nm_src_left = nm_left_w;
            nm_src_mag  = nm_mag_w;
        end
        ST_IDFT: begin
            nm_src      = (cyc == 9'd23) ? acc_re : acc_im;
            nm_src_left = nm_left_t;
            nm_src_mag  = nm_mag_t;
        end
        default: ;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            nm_ph <= NM_IDLE; nm_cnt <= 6'd0; nm_left <= 1'b0;
            nm_sr <= 56'sd0; nm_rnd <= 1'b0; nm_out <= 25'sd0;
            nm_out_tap <= 25'sd0;
            tap_ovf <= 1'b0;
        end else begin
            if (idft_first) tap_ovf <= 1'b0;   // 新一帧 IDFT（第一遍）开始
            case (nm_ph)
            NM_IDLE: begin
                if (nm_start) begin
                    nm_sr   <= nm_src;
                    nm_left <= nm_src_left;
                    nm_rnd  <= 1'b0;
                    nm_cnt  <= nm_src_mag;
                    nm_ph   <= (nm_src_mag == 6'd0) ? NM_FIN : NM_SHIFT;
                end
            end
            NM_SHIFT: begin
                if (nm_cnt == 6'd0) begin
                    nm_ph <= NM_FIN;
                end else begin
                    if (nm_left) begin
                        nm_sr <= nm_sr <<< 1;
                    end else begin
                        nm_rnd <= nm_sr[0];   // 最后一次移出的位 = 原 bit(s-1)
                        nm_sr  <= $signed(nm_sr) >>> 1;
                    end
                    nm_cnt <= nm_cnt - 6'd1;
                    if (nm_cnt == 6'd1) nm_ph <= NM_FIN;
                end
            end
            NM_FIN: begin
                // ST_IDFT 的 nm_y 是 Q24 抽头。第一遍按 Q24 裁，同时累计
                // 「有分量放不进 25bit」；FSM 看到 tap_ovf 就整帧重跑第二遍，
                // 这一遍先 >>>TAP_SFT（常数移位，纯连线）再裁，量程变成 ±4096，
                // 定标 Q(24-TAP_SFT)，由 FIR 末级的 TAP_OUT_SFT 补回。
                // ST_NORM / ST_RECIP 的输出格式不变，仍按 Q24 裁到 ±1.0。
                nm_out <= clip25(nm_y);
                if (state == ST_IDFT) begin
                    nm_out_tap <= clip25(nm_y_tap);
                    tap_ovf    <= tap_ovf | nm_y_ovf;
                end
                nm_ph <= NM_WR;
            end
            NM_WR: begin
                nm_ph <= NM_IDLE;
            end
            default: nm_ph <= NM_IDLE;
            endcase
        end
    end

    // eps = (sumP*5243)>>20（ST_PWEPS 时 sump 已含最后一个 bin，不能再加 ss_val）
    wire [55:0] sump_nxt = sump + {5'd0, ss_val};
    wire [71:0] eps_prod = {16'd0, sump} * 20'd5243;

    // 25x25 平方拆成两个独立 DSP 乘积：v = h*2^18 + lo（lo 取 v[17:0] 有符号，
    // h = v[24:18] + v[17]），于是 v*v = v*lo + (v*h)<<18，与整乘逐位相同。
    // 两个乘积各落自己的 P 寄存器（无 PCIN 级联），求和放到下一拍。
    wire signed [24:0] pr_v  = h20p_re;
    wire signed [17:0] pr_lo = pr_v[17:0];
    wire signed [7:0]  pr_hi = pr_v[24:18] + {7'd0, pr_v[17]};
    wire signed [42:0] pr_lo_c = pr_v * pr_lo;
    wire signed [32:0] pr_hi_c = pr_v * pr_hi;
    wire signed [24:0] pi_v  = h20p_im;
    wire signed [17:0] pi_lo = pi_v[17:0];
    wire signed [7:0]  pi_hi = pi_v[24:18] + {7'd0, pi_v[17]};
    wire signed [42:0] pi_lo_c = pi_v * pi_lo;
    wire signed [32:0] pi_hi_c = pi_v * pi_hi;
    reg  signed [42:0] pr_lo_q, pi_lo_q;
    reg  signed [32:0] pr_hi_q, pi_hi_q;
    wire signed [55:0] pr_lo_e = {{12{pr_lo_q[42]}}, pr_lo_q};
    wire signed [55:0] pr_hi_e = {{23{pr_hi_q[32]}}, pr_hi_q};
    wire signed [55:0] pi_lo_e = {{12{pi_lo_q[42]}}, pi_lo_q};
    wire signed [55:0] pi_hi_e = {{23{pi_hi_q[32]}}, pi_hi_q};
    wire signed [55:0] pr_sum56 = pr_lo_e + (pr_hi_e <<< 18);
    wire signed [55:0] pi_sum56 = pi_lo_e + (pi_hi_e <<< 18);

    // FIR
    wire [4:0]  f_j   = cyc[4:0];
    wire [4:0]  f_idx = fir_idx(f_j);
    wire [8:0]  f_e   = {1'b0, fn} + {4'b0000, f_j};
    // FIR 读地址 = base + ((f_e<9) ? 191+f_e : f_e-9)，f_e = fn+cyc。
    // 不再现场算加法/比较，改由 fir_acnt/fir_fe 两个寄存器推进，
    // 缩短到 BRAM 地址的路径（每个样本只在 f_e 8->9 时回卷一次）。
    reg  [8:0]  fir_acnt;                       // 槽内读地址 0..265
    reg  [8:0]  fir_fe;                         // fn + cyc
    wire [10:0] f_addr = base + fir_acnt;
    wire [8:0]  fn_nxt9 = {1'b0, fn} + 9'd1;
    wire [8:0]  fst9    = (fn_nxt9 < 9'd9) ? (9'd191 + fn_nxt9)
                                           : (fn_nxt9 - 9'd9);
    // 抽头在第一遍是 Q24、第二遍是 Q(24-TAP_SFT)。这里把两个常数移位并行算、
    // 按 tap_scale 二选一；**不能**写成 rnds(acc, tap_scale ? .. : ..) ——
    // 那会让综合器再推出 56bit 可变移位器（上一版 WNS 就是它）。现在多出来的
    // 只是一个 2:1 mux。
    wire signed [55:0] fir_yi_q24 = rnds(acc_re, 8'sd24);
    wire signed [55:0] fir_yi_qsc = rnds(acc_re, TAP_OUT_SFT);
    wire signed [55:0] fir_yq_q24 = rnds(acc_im, 8'sd24);
    wire signed [55:0] fir_yq_qsc = rnds(acc_im, TAP_OUT_SFT);
    // 先在各自分支里裁到 int16，再二选一 —— 选择器只有 16bit，且两条
    // 「加法 -> 移位 -> 饱和」路径互为并行，不串在一条链上。
    wire signed [15:0] fir16_i = tap_scale ? clip16(fir_yi_qsc)
                                           : clip16(fir_yi_q24);
    wire signed [15:0] fir16_q = tap_scale ? clip16(fir_yq_qsc)
                                           : clip16(fir_yq_q24);

    // DFT/IDFT 地址
    //   样本地址按**块** db 走（第 b 块 = x[b*20+n]）
    //   旋转因子按**bin** dp 走（第 p 个频点 = DFT_ROM[p*20+n]）—— 两者不能共用一个变量
    wire [8:0] blk_off   = {1'b0, db, 4'b0000} + {3'b000, db, 2'b00};    // db*20
    wire [8:0] bin_off   = {1'b0, dp, 4'b0000} + {3'b000, dp, 2'b00};    // dp*20
    wire [8:0] idft_off  = {1'b0, im, 4'b0000} + {3'b000, im, 2'b00};    // im*20
    wire [8:0] dft_rom_a  = bin_off  + {4'b0000, cyc[4:0]};
    wire [8:0] idft_rom_a = idft_off + {4'b0000, cyc[4:0]};

    // 门控
    wire [63:0] gate_l_c = {8'd0, sp_reg} * 64'd11;
    wire [63:0] gate_r_c = {8'd0, et_reg} * GATE_K;
    wire        gate_ok = (et_reg != 56'd0) && (gate_l >= gate_r);

    // 输出 FIFO 状态
    wire        pop    = out_v & m_tready;
    wire        refill = (~out_v | pop) & (cnt != 10'd0);
    wire        fifo_full = (cnt == 10'd512) & out_v & (~pop);
    wire        push;
    wire [33:0] push_d;

    // ════════════════════════════════════════════════════════════════════════
    //  7. 输入捕获（按 256 字数切帧）
    // ════════════════════════════════════════════════════════════════════════
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_word        <= 8'd0;
            wr_slot        <= 3'd0;
            dropping       <= 1'b0;
            frame_in_pulse <= 1'b0;
            stat_drop_r    <= 32'd0;
            wr_en          <= 1'b0;
            wr_addr        <= 11'd0;
            wr_data        <= 32'd0;
        end else begin
            wr_en          <= 1'b0;
            frame_in_pulse <= 1'b0;
            if (din_valid) begin
                // 8 槽里 1 个在处理、7 个排队，再满就丢整帧
                if (!dropping && (frames_avail == 4'd7)) begin
                    dropping    <= 1'b1;
                    stat_drop_r <= stat_drop_r + 32'd1;
                end
                if (!dropping) begin
                    wr_en   <= 1'b1;
                    wr_addr <= {wr_slot, wr_word};
                    wr_data <= din;
                end
                if (wr_word == 8'd255) begin
                    wr_word  <= 8'd0;
                    dropping <= 1'b0;
                    if (!dropping) begin
                        wr_slot        <= wr_slot + 3'd1;
                        frame_in_pulse <= 1'b1;
                    end
                end else begin
                    wr_word <= wr_word + 8'd1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (wr_en) frames[wr_addr] <= wr_data;
    end

    // ════════════════════════════════════════════════════════════════════════
    //  8. MAC 引擎时序
    // ════════════════════════════════════════════════════════════════════════
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            iss_d <= 1'b0; a_sel_d <= 2'd0; b_sel_d <= 2'd0; bconj_d <= 1'b0;
            accen_d <= 1'b0; romi_d <= 1'b0;
            a_l_re <= 25'sd0; a_l_im <= 25'sd0;
            b_l_re <= 18'sd0; b_l_im <= 18'sd0;
        end else begin
            iss_d   <= iss;
            a_sel_d <= iss_a_sel;
            b_sel_d <= iss_b_sel;
            bconj_d <= iss_b_conj;
            accen_d <= iss_acc;
            romi_d  <= iss_rom_i;
            a_l_re  <= iss_a_re;
            a_l_im  <= iss_a_im;
            b_l_re  <= iss_b_re;
            b_l_im  <= iss_b_im;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_v_d <= 1'b0; mulen_d <= 1'b0;
            mul_ar <= 25'sd0; mul_ai <= 25'sd0; mul_br <= 18'sd0; mul_bi <= 18'sd0;
        end else begin
            mul_v_d <= iss_d;
            if (iss_d) begin
                mul_ar  <= cap_ar;
                mul_ai  <= cap_ai;
                mul_br  <= cap_br;
                mul_bi  <= cap_bi;
                mulen_d <= accen_d;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prd_v_d <= 1'b0; prden_d <= 1'b0;
            pa_re <= 44'sd0; pb_re <= 44'sd0;
            pa_im <= 44'sd0; pb_im <= 44'sd0;
        end else begin
            prd_v_d <= mul_v_d;
            if (mul_v_d) begin
                pa_re   <= mul_ar * mul_br;
                pb_re   <= mul_ai * mul_bi;
                pa_im   <= mul_ar * mul_bi;
                pb_im   <= mul_ai * mul_br;
                prden_d <= mulen_d;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_re <= 56'sd0;
            acc_im <= 56'sd0;
        end else if (clr) begin
            acc_re <= 56'sd0;
            acc_im <= 56'sd0;
        end else if (prd_v_d && prden_d) begin
            acc_re <= acc_re + {{12{prd_re_c[43]}}, prd_re_c};
            acc_im <= acc_im + {{12{prd_im_c[43]}}, prd_im_c};
        end
    end

    // ════════════════════════════════════════════════════════════════════════
    //  9. msb 扫描
    // ════════════════════════════════════════════════════════════════════════
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_v <= 56'd0; scan_i <= 6'd0; scan_msb <= 6'd0;
            scan_run <= 1'b0; scan_done <= 1'b0;
        end else begin
            scan_done <= 1'b0;
            if (scan_start) begin
                scan_v   <= scan_v_in;
                scan_i   <= 6'd55;
                scan_run <= 1'b1;
            end else if (scan_run) begin
                if (scan_v[scan_i]) begin
                    scan_run <= 1'b0;
                    scan_msb <= scan_i;
                    scan_done <= 1'b1;
                end else if (scan_i == 6'd0) begin
                    scan_run <= 1'b0;
                    scan_msb <= 6'd0;
                    scan_done <= 1'b1;
                end else begin
                    scan_i <= scan_i - 6'd1;
                end
            end
        end
    end

    // ════════════════════════════════════════════════════════════════════════
    //  10. 每拍的 issue 内容 / clr / scan_start
    // ════════════════════════════════════════════════════════════════════════
    always @(*) begin
        iss         = 1'b0;
        iss_a_sel   = 2'd0;
        iss_b_sel   = 2'd0;
        iss_b_conj  = 1'b0;
        iss_acc     = 1'b1;
        iss_rom_i   = 1'b0;
        iss_addr    = 11'd0;
        iss_rom     = 9'd0;
        iss_a_re    = 25'sd0;
        iss_a_im    = 25'sd0;
        iss_b_re    = 18'sd0;
        iss_b_im    = 18'sd0;
        clr         = 1'b0;
        scan_start  = 1'b0;
        scan_v_in   = 56'd0;

        case (state)
        // ── 能量 Et = sum |x[n]|^2, n=0..199 ─────────────────────────────
        ST_ET: begin
            iss_addr = base + cyc[7:0];
            if (cyc < 9'd200) begin
                iss        = 1'b1;
                iss_a_sel  = 2'd1;
                iss_b_sel  = 2'd2;
                iss_b_conj = 1'b1;
            end
            if (cyc == 9'd203) clr = 1'b1;
        end

        // ── lag-20 相关 r = sum x[n]*conj(x[n-20]) ───────────────────────
        ST_R1: begin
            iss_addr = base + {1'b0, rn} - ((rq == 3'd0) ? 9'd0 : 9'd20);
            if (rq == 3'd2) begin
                iss        = 1'b1;
                iss_b_sel  = 2'd2;
                iss_b_conj = 1'b1;
                iss_a_re   = xr;
                iss_a_im   = xi;
            end
            if (rq == 3'd6) clr = 1'b1;
        end

        // ── atan2：先扫 msb，再 18 次迭代 ───────────────────────────────
        ST_ATAN: begin
            if (asub == 2'd0) begin
                scan_start = 1'b1;
                scan_v_in  = atan_m;
            end
        end

        // ── p_b 链 ─────────────────────────────────────────────────────
        ST_PB: begin
            if (pbq == 3'd0) begin
                iss        = 1'b1;
                iss_b_conj = 1'b1;
                iss_a_re   = {{7{pb_cur_re[17]}}, pb_cur_re};
                iss_a_im   = {{7{pb_cur_im[17]}}, pb_cur_im};
                iss_b_re   = c_os;
                iss_b_im   = s_in;
                clr        = 1'b1;
            end
            if (pbq == 3'd4) clr = 1'b1;
        end

        // ── 12bin x 10blk DFT + 对齐累加 ────────────────────────────────
        ST_DFT: begin
            iss_addr = base + blk_off + {4'd0, cyc[4:0]};
            if (cyc < 9'd20) begin
                iss       = 1'b1;
                iss_a_sel = 2'd1;
                iss_b_sel = 2'd1;
                iss_rom   = dft_rom_a;
            end
            if (cyc == 9'd23) clr = 1'b1;
            if (cyc == 9'd24) begin
                iss      = 1'b1;
                iss_a_re = xr;
                iss_a_im = xi;
                iss_b_re = pb_sr[9][17:0];
                iss_b_im = pb_sr[9][35:18];
            end
            if (cyc == 9'd28) clr = 1'b1;
        end

        // ── H_raw -> Hn 归一化 ──────────────────────────────────────────
        ST_NORM: begin
            if (nsub == 2'd0) begin
                scan_start = 1'b1;
                scan_v_in  = {7'd0, hmv};
            end
        end

        // ── 倒数 ───────────────────────────────────────────────────────
        ST_RECIP: begin
            if (rsub == 3'd0) begin
                scan_start = 1'b1;
                scan_v_in  = d_cur;
            end
        end

        // ── IDFT -> taps ───────────────────────────────────────────────
        ST_IDFT: begin
            iss_rom_i = 1'b1;
            iss_rom   = idft_rom_a;
            if (cyc < 9'd20) begin
                iss       = 1'b1;
                iss_b_sel = 2'd1;
                iss_a_re  = w_sr[19][24:0];
                iss_a_im  = w_sr[19][49:25];
            end
            if (cyc == 9'd0)  clr = 1'b1;
            if (cyc == 9'd24) clr = 1'b1;
        end

        // ── FIR ────────────────────────────────────────────────────────
        ST_FIR: begin
            iss_addr = f_addr;
            if (cyc < 9'd20) begin
                iss       = 1'b1;
                iss_b_sel = (f_e <= 9'd264) ? 2'd2 : 2'd3;
                iss_a_re  = tap_sr[19][24:0];
                iss_a_im  = tap_sr[19][49:25];
            end
            if (cyc == 9'd0)  clr = 1'b0;
            if (cyc == 9'd0)  clr = 1'b1;
            if (cyc == 9'd23) clr = 1'b1;
        end

        // ── 旁路输出 ───────────────────────────────────────────────────
        ST_BYP: begin
            iss_addr = base + ((bn < 9'd256) ? bn : 9'd255);
        end

        default: ;
        endcase
    end

    // ════════════════════════════════════════════════════════════════════════
    //  11. FSM
    // ════════════════════════════════════════════════════════════════════════
    // 取帧条件（ST_IDLE / ST_NEXT 且队列非空）。state/frames_avail 都是寄存器，
    // 这里取到的是本拍之前（case 分支看到的同一个）值。
    wire take_frame = ((state == ST_IDLE) || (state == ST_NEXT))
                      && (frames_avail != 4'd0);

    integer k;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
            cyc <= 9'd0; rn <= 8'd0; rq <= 3'd0; it <= 6'd0;
            asub <= 2'd0; rsub <= 3'd0; nsub <= 2'd0;
            pbp <= 4'd0; pbq <= 3'd0; db <= 4'd0; dp <= 4'd0;
            pk <= 5'd0; im <= 5'd0; rk <= 5'd0; fn <= 8'd0; bn <= 9'd0;
            fir_acnt <= 9'd0; fir_fe <= 9'd0;
            tap_scale <= 1'b0;
            work_slot    <= 3'd0;
            rd_slot      <= 3'd0;   // 读指针与帧计数只在 FSM 块里驱动
            frames_avail <= 4'd0;   // 唯一复位点（+1/-1 也都在本块）
            xr <= 25'sd0; xi <= 25'sd0;
            rr <= 56'sd0; ri <= 56'sd0;
            et_reg <= 56'd0; sp_reg <= 56'd0;
            pb_cur_re <= 18'sd0; pb_cur_im <= 18'sd0;
            c_os <= 18'sd0; s_in <= 18'sd0;
            theta_r <= 23'sd0;
            xc <= 26'sd0; yc <= 26'sd0; zc <= 23'sd0;
            hmv <= 49'd0; eH <= 6'd0;
            hi_abs_q <= 49'd0; hq_abs_q <= 49'd0;
            hri_r <= 49'sd0; hrq_r <= 49'sd0;
            sump <= 56'd0; eps_r <= 56'd0; dsum <= 56'd0;
            pwp <= 2'd0; h20p_re <= 25'sd0; h20p_im <= 25'sd0;
            pr <= 50'sd0; pi <= 50'sd0;
            ssr <= 50'sd0; ssi <= 50'sd0;
            xr_hi_q <= 33'sd0; xi_hi_q <= 33'sd0;
            xr_lo_q <= 43'sd0; xi_lo_q <= 43'sd0;
            e_r <= 6'd0; m_reg <= 18'd0; r_reg <= 18'd0; u_reg <= 18'sd0;
            ru_q <= 36'sd0; mr_q <= 36'sd0;
            h20w_re <= 25'sd0; h20w_im <= 25'sd0;
            hp_re <= 43'sd0; hp_im <= 43'sd0;
            bin_re <= 48'sd0; bin_im <= 48'sd0;
            w_re_lat <= 25'sd0; tap_re_lat <= 25'sd0;
            stat_gate_r <= 1'b0;
            gate_l <= 64'd0; gate_r <= 64'd0;
            stat_theta_r <= 23'sd0;
            for (k = 0; k < 12; k = k + 1) begin
                hn_re[k] <= 25'sd0; hn_im[k] <= 25'sd0;
            end
        end else begin
            case (state)

            // ── 取下一帧 ────────────────────────────────────────────────
            ST_IDLE: begin
                if (frames_avail != 4'd0) begin
                    work_slot    <= rd_slot;
                    rd_slot      <= rd_slot + 3'd1;
                    sp_reg <= 56'd0;
                    hmv    <= 49'd0;
                    bin_re <= 48'sd0;
                    bin_im <= 48'sd0;
                    state <= ST_ET;
                    cyc   <= 9'd0;
                end
            end

            // ── Et ──────────────────────────────────────────────────────
            ST_ET: begin
                if (cyc == 9'd203) begin
                    et_reg <= acc_re;
                    cyc    <= 9'd0;
                    rn     <= 8'd20;
                    rq     <= 3'd0;
                    state  <= ST_R1;
                end else begin
                    cyc <= cyc + 9'd1;
                end
            end

            // ── lag-20 相关 ─────────────────────────────────────────────
            ST_R1: begin
                case (rq)
                3'd0: rq <= 3'd1;
                3'd1: begin
                    xr <= {{9{mem_b_q[15]}}, mem_b_q[15:0]};
                    xi <= {{9{mem_b_q[31]}}, mem_b_q[31:16]};
                    rq <= 3'd2;
                end
                3'd2: begin
                    if (rn == 8'd199) rq <= 3'd3;
                    else begin
                        rn <= rn + 8'd1;
                        rq <= 3'd0;
                    end
                end
                3'd3, 3'd4, 3'd5: rq <= rq + 3'd1;
                3'd6: begin
                    rr    <= acc_re;
                    ri    <= acc_im;
                    state <= ST_ATAN;
                    asub  <= 2'd0;
                end
                default: rq <= 3'd3;
                endcase
            end

            // ── atan2 ───────────────────────────────────────────────────
            ST_ATAN: begin
                case (asub)
                2'd0: asub <= 2'd1;
                2'd1: begin
                    if (scan_done) begin
                        if ((rr == 56'sd0) && (ri == 56'sd0)) begin
                            theta_r <= 23'sd0;
                            state   <= ST_ROT;
                            rsub    <= 3'd0;
                        end else begin
                            xc   <= {{30{rr[55]}}, rr} >>> ash;
                            yc   <= {{30{ri[55]}}, ri} >>> ash;
                            zc   <= 23'sd0;
                            it   <= 6'd0;
                            asub <= 2'd2;
                        end
                    end
                end
                2'd2: begin
                    xc <= xnew_a;
                    yc <= ynew_a;
                    zc <= znew_a;
                    if (it == 6'd17) begin
                        theta_r <= znew_a;
                        state   <= ST_ROT;
                        rsub    <= 3'd0;
                    end else begin
                        it <= it + 6'd1;
                    end
                end
                default: asub <= 2'd0;
                endcase
            end

            // ── CFO 旋转因子 ────────────────────────────────────────────
            ST_ROT: begin
                case (rsub)
                2'd0: begin
                    xc   <= 26'sd1273537;
                    yc   <= 26'sd0;
                    zc   <= theta_r;
                    it   <= 6'd0;
                    rsub <= 3'd1;
                end
                2'd1: begin
                    xc <= xnew_r;
                    yc <= ynew_r;
                    zc <= znew_r;
                    if (it == 6'd17) rsub <= 3'd2;   // 最后一轮：取角单独一拍
                    else             it   <= it + 6'd1;
                end
                3'd2: begin
                    c_os      <= cos_f;
                    s_in      <= sin_f;
                    pb_cur_re <= 18'sd131071;
                    pb_cur_im <= 18'sd0;
                    state     <= ST_PB;
                    pbp       <= 4'd1;
                    pbq       <= 3'd0;
                    rsub      <= 3'd0;
                end
                default: rsub <= 3'd0;
                endcase
            end

            // ── p_b[b] = p_b[b-1] * (c - j s) ──────────────────────────
            ST_PB: begin
                if (pbq == 3'd0) begin
                    pbq <= 3'd1;
                end else if (pbq == 3'd4) begin
                    pb_cur_re <= pb_new_re;
                    pb_cur_im <= pb_new_im;
                    pbq <= 3'd0;
                    if (pbp == 4'd9) begin
                        state <= ST_DFT;
                        db <= 4'd0; dp <= 4'd0; cyc <= 9'd0;
                        bin_re <= 48'sd0; bin_im <= 48'sd0;
                    end else begin
                        pbp <= pbp + 4'd1;
                    end
                end else begin
                    pbq <= pbq + 3'd1;
                end
            end

            // ── DFT + 对齐（dp 外 / db 内）────────────────────────────
            // 一个 bin 的 10 个 block 连续累加完再换下个 bin，所以
            // 不需要 12 深的 accbin 数组：bin_re/bin_im 一对寄存器即可，
            // 累加顺序、48bit 截断点和原来完全相同。
            ST_DFT: begin
                if (cyc == 9'd28) begin
                    if (db == 4'd9) begin
                        // 该 bin 完成：hri_c/hrq_c 已含本 block（bin_*_nxt），先寄存
                        hri_r  <= hri_c;
                        hrq_r  <= hrq_c;
                        db     <= 4'd0;
                        bin_re <= 48'sd0;
                        bin_im <= 48'sd0;
                        cyc    <= 9'd29;
                    end else begin
                        db     <= db + 4'd1;
                        bin_re <= bin_re_nxt;
                        bin_im <= bin_im_nxt;
                        cyc    <= 9'd0;
                    end
                end else if (cyc == 9'd29) begin
                    // 流水第二拍：|hr| 寄存（入 h 链在 SR 块里按 cyc==29 做）
                    hi_abs_q <= hi_abs_r;
                    hq_abs_q <= hq_abs_r;
                    cyc      <= 9'd30;
                end else if (cyc == 9'd30) begin
                    // 流水第三拍：更新 hmv、换下一个 bin
                    hmv <= hmv_nxt3;
                    cyc <= 9'd0;
                    if (dp == 4'd11) begin
                        dp <= 4'd0;
                        state <= ST_GATE;
                    end else begin
                        dp <= dp + 4'd1;
                    end
                end else begin
                    if (cyc == 9'd23) begin
                        xr <= xr_new;
                        xi <= xi_new;
                    end else if (cyc == 9'd24) begin
                        xr_hi_q <= xr_hi_n; xi_hi_q <= xi_hi_n;
                        xr_lo_q <= xr_lo_n; xi_lo_q <= xi_lo_n;
                    end else if (cyc == 9'd25) begin
                        ssr <= ss_r2;
                        ssi <= ss_i2;
                    end else if (cyc == 9'd26) begin
                        sp_reg <= sp_reg + {5'd0, ss_psum};
                    end
                    cyc <= cyc + 9'd1;
                end
            end

            // ── 门控 ───────────────────────────────────────────────────
            ST_GATE: begin
                // gate_l/gate_r 先寄存，下一拍再比较/判决：
                // 断开 “et_reg -> 常数乘 -> 64bit 比较 -> 状态译码 -> cyc CE”
                gate_l       <= gate_l_c;
                gate_r       <= gate_r_c;
                stat_theta_r <= theta_r;
                state        <= ST_GATE2;
            end
            ST_GATE2: begin
                stat_gate_r <= gate_ok;
                if (gate_ok && (hmv != 49'd0)) begin
                    state <= ST_NORM;
                    nsub  <= 2'd0;
                    cyc   <= 9'd0;
                end else begin
                    state <= ST_BYP;
                    bn    <= 9'd0;
                end
            end

            // ── ST_LS 已废弃（H_raw 在 ST_DFT 每个 bin 结束时直接入链）──
            ST_LS: state <= ST_GATE;

            // ── 归一化到 2^23 ──────────────────────────────────────────
            // 串行归一化：每个值单独 load 进 nm_sr，左/右移 |nh_r| 拍，再舍入、
            // 裁剪、写回。关键路径从“状态 mux -> 56bit 桶形移位器 -> 舍入加法 ->
            // clip -> 12:1 写 mux”拆成四段，每段只有一两级 LUT/CARRY。
            // 代价：每值最多 25 拍移位，24 个值/帧最多多 ~650 拍（预算 ~20.2k）。
            ST_NORM: begin
                case (nsub)
                2'd0: nsub <= 2'd1;
                2'd1: begin
                    if (scan_done) begin
                        eH   <= scan_msb;
                        cyc  <= 9'd0;       // 归一化从 k=0 开始
                        nsub <= 2'd2;
                    end
                end
                2'd2: begin
                    // nm_start（nm_ph==IDLE）那拍引擎载入链顶，h_adv_en 同时推进链；
                    // NM_WR 这拍取结果写回。
                    if (nm_done) begin
                        // 偶值取 hri，奇值取 hrq（同一 bin 的两个分量）
                        if (cyc[0]) hn_im[sh_bin] <= nm_out;
                        else        hn_re[sh_bin] <= nm_out;
                        if (cyc == 9'd23) begin
                            state <= ST_INTERP;
                        end else begin
                            cyc <= cyc + 9'd1;
                        end
                    end
                end
                default: nsub <= 2'd0;
                endcase
            end

            // ── 12 -> 20 bin ───────────────────────────────────────────
            // H20 是组合读出的（见 h20_v_re/im），这里只做状态交接：
            // k=-10..-7 -> Hn0; k=-6..-1 -> Hn0..5; k=0 -> (Hn5+Hn6)>>1;
            // k=1..6 -> Hn6..11; k=7..9 -> Hn11
            ST_INTERP: begin
                pk    <= 5'd0;
                pwp   <= 2'd0;
                sump  <= 56'd0;
                state <= ST_PW;
            end

            // ── P = |H20|^2，sumP ──────────────────────────────────────
            // 三级流水/每 bin，断开“状态 mux -> 24x24 平方 -> 51bit 求和 ->
            // 56bit 累加 -> 13bit 乘”这一整条链：
            //   pwp=0: 锁存 H20 选值
            //   pwp=1: 两路 25x25 平方（各一个 DSP，无级联）
            //   pwp=2: pr+pi 入 pl 链、累加 sumP；最后一个 bin 后进 ST_PWEPS
            ST_PW: begin
                case (pwp)
                2'd0: begin
                    h20p_re <= h20_v_re;
                    h20p_im <= h20_v_im;
                    pwp     <= 2'd1;
                end
                2'd1: begin
                    pr  <= h20p_re * h20p_re;
                    pi  <= h20p_im * h20p_im;
                    pwp <= 2'd2;
                end
                default: begin      // pwp=2：ss_val/pr+pi 与 sump_nxt 都在这一拍算
                    sump <= sump_nxt;
                    if (pk == 5'd19) begin
                        state <= ST_PWEPS;
                    end else begin
                        pk  <= pk + 5'd1;
                        pwp <= 2'd0;
                    end
                end
                endcase
            end

            // 最后一个累加已落进 sump，这一拍单独做 eps = (sumP*5243)>>20
            ST_PWEPS: begin
                eps_r <= eps_prod[71:20];
                state <= ST_RECIP;
                rk    <= 5'd0;
                rsub  <= 3'd0;
            end

            // ── W = conj(H) 2^K_W / (|H|^2 + eps) ──────────────────────
            ST_RECIP: begin
                case (rsub)
                3'd0: begin
                    dsum <= d_cur;          // 与扫描同时锁存，移位不再从加法链起步
                    rsub <= 3'd1;
                end
                2'd1: begin
                    if (scan_done) begin
                        e_r   <= scan_msb;
                        m_reg <= m_c;
                        rsub  <= 4'd14;     // 倒数 ROM 单独一拍：索引来自 m_reg
                    end
                end
                4'd14: begin
                    r_reg <= {1'b0, lstf_inv(idx_c)};
                    rsub  <= 3'd2;
                end
                3'd2: begin        // 第 1 次 Newton：m*r 的 DSP 结果先寄存
                    mr_q <= mr;
                    rsub <= 4'd12;
                end
                4'd12: begin       // 第 1 次 Newton：u = 2 - m*r
                    u_reg <= u_c;
                    rsub  <= 3'd3;
                end
                3'd3: begin        // 第 1 次 Newton：r*u 的 DSP 结果先寄存
                    ru_q <= ru;
                    rsub <= 4'd10;
                end
                4'd10: begin       // 第 1 次 Newton：r = r*u（裁剪/下限另起一拍）
                    r_reg <= r_new;
                    rsub  <= 3'd4;
                end
                3'd4: begin        // 第 2 次 Newton：m*r 的 DSP 结果先寄存
                    mr_q <= mr;
                    rsub <= 4'd13;
                end
                4'd13: begin       // 第 2 次 Newton：u = 2 - m*r
                    u_reg <= u_c;
                    rsub  <= 3'd5;
                end
                3'd5: begin        // 第 2 次 Newton：r*u 的 DSP 结果先寄存
                    ru_q <= ru;
                    rsub <= 4'd11;
                end
                4'd11: begin       // 第 2 次 Newton：r = r*u
                    r_reg <= r_new;
                    rsub  <= 3'd6;
                end
                3'd6: begin        // 锁 H20 选值（rk 已稳定，断开状态 mux -> DSP）
                    h20w_re <= h20_v_re;
                    h20w_im <= h20_v_im;
                    rsub    <= 3'd7;
                end
                3'd7: begin        // H20 * r -> hp（DSP 单独一拍）
                    hp_re <= hprod_re;
                    hp_im <= hprod_im;
                    rsub  <= 4'd8;
                end
                // re/im 分两拍出（共用串行引擎）；re 先存起来，
                // rsub=9 时和 im 组成 {im,re} 一起推进 w 移位链
                4'd8: begin
                    if (nm_done) begin
                        w_re_lat <= nm_out;
                        rsub     <= 4'd9;
                    end
                end
                4'd9: begin
                    if (nm_done) begin
                        rsub <= 4'd0;
                        if (rk == 5'd19) begin
                            state <= ST_IDFT;
                            im    <= 5'd9;   // 按 FIR 的读序倒着算：9..0,19..10
                            cyc   <= 9'd0;
                            tap_scale <= 1'b0;   // 先走 Q24 第一遍
                        end else begin
                            rk <= rk + 5'd1;
                        end
                    end
                end
                default: rsub <= 3'd0;
                endcase
            end

            // ── IDFT -> 20 tap ─────────────────────────────────────────
            // re/im 分两拍出（cyc=23 写 taps_re，cyc=24 写 taps_im），
            // 共用串行引擎；clr 相应从 23 挪到 24，保证 acc 在 24 拍仍有效。
            ST_IDFT: begin
                if (cyc == 9'd23) begin
                    if (nm_done) begin
                        tap_re_lat <= tap_scale ? nm_out_tap : nm_out;
                        cyc <= 9'd24;
                    end
                end else if (cyc == 9'd24) begin
                    // {im,re} 在 SR always 块里入链
                    if (nm_done) begin
                        cyc <= 9'd0;
                        if (im == 5'd10) begin     // 9,8..0,19,18..10 的最后一步
                            if (tap_ovf && !tap_scale) begin
                                // 第一遍有抽头超出 ±1.0：整帧重跑第二遍。
                                // tap_sr 是 20 深移位链，再插 20 个正好把第一遍
                                // 的旧值全部顶出去；w_sr 每 bin 转满 20 拍回到原序。
                                tap_scale <= 1'b1;
                                im  <= 5'd9;
                                cyc <= 9'd0;
                            end else begin
                                state <= ST_FIR;
                                fn    <= 8'd0;
                                fir_acnt <= 9'd191;    // fn=0,cyc=0 的读起点
                                fir_fe   <= 9'd0;
                            end
                        end else begin
                            im <= (im == 5'd0) ? 5'd19 : (im - 5'd1);
                        end
                    end
                end else begin
                    cyc <= cyc + 9'd1;
                end
            end

            // ── 20 tap 复数 FIR ────────────────────────────────────────
            ST_FIR: begin
                if (cyc == 9'd20) begin
                    // 下一个输出样本的读起点（fn 在 cyc=23 才 +1，这里用 fn+1）
                    fir_acnt <= fst9;
                    fir_fe   <= fn_nxt9;
                end else if (cyc < 9'd20) begin
                    fir_acnt <= (fir_fe == 9'd8) ? 9'd0 : (fir_acnt + 9'd1);
                    fir_fe   <= fir_fe + 9'd1;
                end
                if (cyc == 9'd23) begin
                    if (!fifo_full) begin
                        cyc <= 9'd0;
                        if (fn == 8'd255) state <= ST_NEXT;
                        else              fn <= fn + 8'd1;
                    end
                end else begin
                    cyc <= cyc + 9'd1;
                end
            end

            // ── 旁路输出（门控失败 / 全零）──────────────────────────────
            ST_BYP: begin
                if ((bn >= 9'd1) && fifo_full) begin
                    // 等 FIFO
                end else if (bn == 9'd256) begin
                    bn    <= 9'd0;
                    state <= ST_NEXT;
                end else begin
                    bn <= bn + 9'd1;
                end
            end

            // ── 下一帧 / 空闲 ──────────────────────────────────────────
            ST_NEXT: begin
                if (frames_avail != 4'd0) begin
                    work_slot    <= rd_slot;
                    rd_slot      <= rd_slot + 3'd1;
                    sp_reg <= 56'd0;
                    hmv    <= 49'd0;
                    bin_re <= 48'sd0;
                    bin_im <= 48'sd0;
                    state <= ST_ET;
                    cyc   <= 9'd0;
                end else begin
                    state <= ST_IDLE;
                end
            end

            default: state <= ST_IDLE;
            endcase

            // ── 帧计数：全模块唯一驱动点 ──────────────────────────────
            // 捕获块来一帧（脉冲）+1，ST_IDLE/ST_NEXT 取走一帧 -1。
            // 同拍两者都发生时净变化为 0，不赋值（保持）。
            // 以前 +1 写在捕获块、-1 写在 FSM 块，两个 always 驱动同一个 reg，
            // 仿真不报（xsim 按最后写入），综合却推成两个寄存器
            // （frames_avail_reg[0] / frames_avail_reg[0]__0）同驱一根网线，
            // opt_design 的 DRC MDRV-1 就是从这里来的。
            if (take_frame && !frame_in_pulse)
                frames_avail <= frames_avail - 4'd1;
            else if (frame_in_pulse && !take_frame)
                frames_avail <= frames_avail + 4'd1;
        end
    end

    // ════════════════════════════════════════════════════════════════════════
    //  11b. 顺序数组移位链
    // ════════════════════════════════════════════════════════════════════════
    // 约定：新值进 [0]，最老的值到链顶（[11]/[19]）；读地址恒为链顶，
    // 综合出来没有地址 mux。推进 = 整链上移一位、[0] 补 0。
    wire h_sh_en  = (state == ST_DFT) && (cyc == 9'd29);
    // 归一化链在**载入奇值（hrq）那拍**推进：nm_sr 同一拍采样的是推进前的链顶，
    // 下一拍的偶值读到的是新 bin。
    wire h_adv_en = nm_start && cyc[0];

    // ST_IDFT 每个输出 bin 都要把 w[0..19] 从头读一遍、ST_FIR 每个输出样本
    // 都要把 20 个 tap 从头读一遍，所以这两条链在读取阶段是**环形**移位
    // （链顶回灌链底），20 拍正好转回原序；写入阶段才是推进式。
    wire w_ins_en = (state == ST_RECIP) && (rsub == 4'd9) && nm_done;
    wire tap_ins_en = (state == ST_IDFT) && (cyc == 9'd24) && nm_done;
    wire w_sh_en = w_ins_en || ((state == ST_IDFT) && (cyc < 9'd20));
    wire w_rot   = (state == ST_IDFT) && (cyc < 9'd20);
    wire signed [49:0] w_sh_in = w_ins_en ? {nm_out, w_re_lat} : 50'sd0;

    wire tap_sh_en = tap_ins_en || ((state == ST_FIR) && (cyc < 9'd20));
    wire tap_rot   = (state == ST_FIR) && (cyc < 9'd20);
    wire signed [24:0] tap_im_out = tap_scale ? nm_out_tap : nm_out;
    wire signed [49:0] tap_sh_in = tap_ins_en ? {tap_im_out, tap_re_lat} : 50'sd0;

    wire pl_sh_en = ((state == ST_PW) && (pwp == 2'd2)) ||
                    ((state == ST_RECIP) && (rsub == 4'd9) && nm_done);
    wire [55:0] pl_sh_in = ((state == ST_PW) && (pwp == 2'd2))
                         ? {5'd0, ss_val} : 56'd0;

    // p_b：ST_ROT 末尾先入 p_0=1+j0，ST_PB 每级再入一个；DFT 里每 block 转一格
    wire pb_ins_en = ((state == ST_ROT) && (rsub == 3'd1) && (it == 6'd17)) ||
                     ((state == ST_PB)  && (pbq == 3'd4));
    wire signed [35:0] pb_ins = (state == ST_ROT) ? {18'sd0, 18'sd131071}
                                                 : {pb_new_im, pb_new_re};
    wire pb_rot = (state == ST_DFT) && (cyc == 9'd28);

    integer si;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (si = 0; si < 12; si = si + 1) begin
                h_sr_re[si] <= 49'sd0;
                h_sr_q[si]  <= 49'sd0;
            end
            for (si = 0; si < 20; si = si + 1) begin
                w_sr[si]   <= 50'sd0;
                tap_sr[si] <= 50'sd0;
                pl_sr[si]  <= 56'd0;
            end
            for (si = 0; si < 10; si = si + 1) pb_sr[si] <= 36'sd0;
        end else begin
            if (h_sh_en) begin
                for (si = 11; si > 0; si = si - 1) begin
                    h_sr_re[si] <= h_sr_re[si-1];
                    h_sr_q[si]  <= h_sr_q[si-1];
                end
                h_sr_re[0] <= hri_r;
                h_sr_q[0]  <= hrq_r;
            end else if (h_adv_en) begin
                for (si = 11; si > 0; si = si - 1) begin
                    h_sr_re[si] <= h_sr_re[si-1];
                    h_sr_q[si]  <= h_sr_q[si-1];
                end
                h_sr_re[0] <= 49'sd0;
                h_sr_q[0]  <= 49'sd0;
            end

            if (w_sh_en) begin
                for (si = 19; si > 0; si = si - 1) w_sr[si] <= w_sr[si-1];
                w_sr[0] <= w_rot ? w_sr[19] : w_sh_in;
            end

            if (tap_sh_en) begin
                for (si = 19; si > 0; si = si - 1) tap_sr[si] <= tap_sr[si-1];
                tap_sr[0] <= tap_rot ? tap_sr[19] : tap_sh_in;
            end

            if (pl_sh_en) begin
                for (si = 19; si > 0; si = si - 1) pl_sr[si] <= pl_sr[si-1];
                pl_sr[0] <= pl_sh_in;
            end

            if (pb_ins_en) begin
                for (si = 9; si > 0; si = si - 1) pb_sr[si] <= pb_sr[si-1];
                pb_sr[0] <= pb_ins;
            end else if (pb_rot) begin
                for (si = 9; si > 0; si = si - 1) pb_sr[si] <= pb_sr[si-1];
                pb_sr[0] <= pb_sr[9];
            end
        end
    end

    // ════════════════════════════════════════════════════════════════════════
    //  12. 输出 FIFO（BRAM 寄存读出 FWFT）
    // ════════════════════════════════════════════════════════════════════════
    assign push = ((state == ST_FIR) && (cyc == 9'd23) && !fifo_full) ||
                  ((state == ST_BYP) && (bn >= 9'd1) && !fifo_full);
    assign push_d = (state == ST_FIR)
                  ? {1'b0, (fn == 8'd255), fir16_q, fir16_i}
                  : {1'b1, (bn == 9'd256), mem_b_q[31:16], mem_b_q[15:0]};

    // 写口单独一块，且**不能带异步复位**：Vivado 2018.3 不会在带 async reset 的
    // always 块里推断 RAM（Synth 8-4767 "RAM is sensitive to asynchronous reset"），
    // 512x34 会被拆成 17,408 个 FF——实测多花 5.5k LUT、512 个控制集。
    // ofifo 本身不复位；复位后 out_v=0、cnt=0，不会被读出，所以行为不变。
    always @(posedge clk) begin
        if (push) ofifo[wrp] <= push_d;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wrp <= 9'd0; rdp <= 9'd0; cnt <= 10'd0;
            out_q <= 34'd0; out_v <= 1'b0;
        end else begin
            if (push) wrp <= wrp + 9'd1;
            if (refill) begin
                out_q <= ofifo[rdp];
                rdp   <= rdp + 9'd1;
            end
            cnt <= cnt + (push ? 10'd1 : 10'd0) - (refill ? 10'd1 : 10'd0);
            if (refill)   out_v <= 1'b1;
            else if (pop) out_v <= 1'b0;
        end
    end

    assign m_tvalid = out_v;
    assign m_tdata  = out_q[31:0];
    assign m_tlast  = out_q[32];
    assign m_tuser  = out_q[33];
    assign m_tkeep  = 4'hF;

    assign stat_drop  = stat_drop_r;
    assign stat_theta = stat_theta_r;
    assign stat_gate  = stat_gate_r;
    assign busy       = (state != ST_IDLE);

endmodule
