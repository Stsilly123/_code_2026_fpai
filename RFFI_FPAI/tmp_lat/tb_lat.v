`timescale 1ns / 1ps
// 只看 CFO 的 atan 握手：请求时刻、CORDIC 固有延迟、atc 落点、S_ASM 时 angtmp 内容。
module tb_lat;
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
    integer nout, k, rep, guard;

    expert_feat_rffi dut (
        .clk(clk), .rst_n(rst_n),
        .din(din), .din_valid(din_valid), .din_last(din_last),
        .m_tdata(m_tdata), .m_tvalid(m_tvalid), .m_tready(m_tready),
        .m_tlast(m_tlast), .m_tkeep(m_tkeep),
        .stat_drop(stat_drop), .stat_frames(stat_frames), .busy(busy)
    );

    always #2.5 clk = ~clk;

    always @(posedge clk) begin
        if (rst_n && m_tvalid && m_tready) nout = nout + 1;
    end

    // ---- CFO 观察点 ----
    always @(posedge clk) begin
        if (rst_n && dut.u_cfo.at_req)
            $display("t=%0t  REQ in=%08h", $time, dut.u_cfo.at_in);
        if (rst_n && dut.u_cfo.at_ack)
            $display("t=%0t  ACK atc=%0d out=%0d av=%08h", $time,
                     dut.u_cfo.atc, $signed(dut.u_cfo.at_out), dut.u_cfo.at_out);
        if (rst_n && dut.u_cfo.state == 4'd6 && dut.u_cfo.iissue == 4'd0)
            $display("t=%0t  S_ISSUE START atv=%0d %0d %0d %0d %0d %0d", $time,
                     $signed(dut.u_cfo.atv[0]), $signed(dut.u_cfo.atv[1]),
                     $signed(dut.u_cfo.atv[2]), $signed(dut.u_cfo.atv[3]),
                     $signed(dut.u_cfo.atv[4]), $signed(dut.u_cfo.atv[5]));
        if (rst_n && dut.u_cfo.state == 4'd11)
            $display("t=%0t  S_ASM angtmp=%0d %0d %0d %0d %0d %0d  atc=%0d", $time,
                     $signed(dut.u_cfo.angtmp[0]), $signed(dut.u_cfo.angtmp[1]),
                     $signed(dut.u_cfo.angtmp[2]), $signed(dut.u_cfo.angtmp[3]),
                     $signed(dut.u_cfo.angtmp[4]), $signed(dut.u_cfo.angtmp[5]),
                     dut.u_cfo.atc);
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
            $display("---- call %0d done, nout=%0d ----", rep, nout);
        end
        $finish;
    end
endmodule
