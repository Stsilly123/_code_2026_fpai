`timescale 1ns / 1ps
// 把专家模块对 frames.bin 前两帧（各 8 份）的输出落盘，供与板上 FNV 指纹对拍。
// 每帧 256 字，写成 hex（每行一个 32bit 字）。
module tb_expert_dump;
    reg clk = 0;
    reg rst_n = 0;
    reg [31:0] din = 0;
    reg        din_valid = 0;
    reg        din_last = 0;
    reg        m_tready = 1;

    wire [31:0] m_tdata;
    wire        m_tvalid, m_tlast;
    wire [3:0]  m_tkeep;
    wire [31:0] stat_drop, stat_frames;
    wire        busy;

    reg [31:0] raw [0:65535];
    reg [31:0] got [0:4095];
    integer nout, k, rep, guard;
    integer fd;

    expert_feat_rffi dut (
        .clk(clk), .rst_n(rst_n),
        .din(din), .din_valid(din_valid), .din_last(din_last),
        .m_tdata(m_tdata), .m_tvalid(m_tvalid), .m_tready(m_tready),
        .m_tlast(m_tlast), .m_tkeep(m_tkeep),
        .stat_drop(stat_drop), .stat_frames(stat_frames), .busy(busy)
    );

    always #2.5 clk = ~clk;

    always @(posedge clk) begin
        if (rst_n && m_tvalid && m_tready) begin
            if (nout < 4096) got[nout] = m_tdata;
            nout = nout + 1;
        end
    end

    initial begin
        $readmemh("expert_in_rep.hex", raw);
        nout = 0;
        repeat (10) @(posedge clk);
        rst_n = 1;
        repeat (4) @(posedge clk);

        for (rep = 0; rep < 2; rep = rep + 1) begin
            for (k = 0; k < 2048; k = k + 1) begin
                @(negedge clk);
                din = raw[rep*2048 + k];
                din_valid = 1'b1;
                din_last = ((k % 256) == 255);
            end
            @(negedge clk);
            din_valid = 0;
            din_last = 0;
            guard = 0;
            while ((nout < (rep+1)*2048) && (guard < 4000000)) begin
                @(posedge clk);
                guard = guard + 1;
            end
            @(posedge clk);
            // 这次调用输出块的第 0、1 槽
            if (rep == 0) fd = $fopen("dump_call0_s0.hex", "w");
            else          fd = $fopen("dump_call1_s0.hex", "w");
            for (k = 0; k < 256; k = k + 1)
                $fdisplay(fd, "%08x", got[rep*2048 + k]);
            $fclose(fd);
            if (rep == 0) fd = $fopen("dump_call0_s1.hex", "w");
            else          fd = $fopen("dump_call1_s1.hex", "w");
            for (k = 0; k < 256; k = k + 1)
                $fdisplay(fd, "%08x", got[rep*2048 + 256 + k]);
            $fclose(fd);
            $display("call %0d done, nout=%0d", rep, nout);
        end
        $finish;
    end
endmodule
