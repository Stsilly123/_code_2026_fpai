`timescale 1ns / 1ps
// 用真实 xfft_256 IP 抓 8 帧 I/Q 的 256 点 FFT 输出（自然序），给 Python golden 用。
// 输出文件：fft_cap.hex，每行 "%08h %08h" = re, im（32-bit 二补码）。
module tb_fft_cap;
    reg aclk = 0;
    reg aresetn = 0;

    reg  [7:0]  s_cfg_tdata = 8'h01;
    reg         s_cfg_tvalid = 0;
    wire        s_cfg_tready;

    reg         s_dat_tvalid = 0;
    wire        s_dat_tready;
    reg  [31:0] s_dat_tdata = 0;
    reg         s_dat_tlast = 0;

    wire [63:0] m_dat_tdata;
    wire        m_dat_tvalid;
    wire        m_dat_tlast;
    wire        m_dat_tready = 1'b1;

    wire ev_frame, ev_tlu, ev_tlm, ev_sch, ev_dich, ev_doch;

    reg [31:0] zn [0:2047];
    reg [24:0] cap_re [0:255];
    reg [24:0] cap_im [0:255];
    reg [7:0]  out_cnt;
    reg [3:0]  frames_written;
    integer in_cnt, fi, fd, i;
    reg cfg_done, frame_ready, done;
    reg [7:0] nidx;

    xfft_256 u_fft (
        .aclk(aclk), .aresetn(aresetn),
        .s_axis_config_tdata(s_cfg_tdata),
        .s_axis_config_tvalid(s_cfg_tvalid),
        .s_axis_config_tready(s_cfg_tready),
        .s_axis_data_tdata(s_dat_tdata),
        .s_axis_data_tvalid(s_dat_tvalid),
        .s_axis_data_tready(s_dat_tready),
        .s_axis_data_tlast(s_dat_tlast),
        .m_axis_data_tdata(m_dat_tdata),
        .m_axis_data_tvalid(m_dat_tvalid),
        .m_axis_data_tready(m_dat_tready),
        .m_axis_data_tlast(m_dat_tlast),
        .event_frame_started(ev_frame),
        .event_tlast_unexpected(ev_tlu),
        .event_tlast_missing(ev_tlm),
        .event_status_channel_halt(ev_sch),
        .event_data_in_channel_halt(ev_dich),
        .event_data_out_channel_halt(ev_doch)
    );

    always #2.5 aclk = ~aclk;

    function [7:0] bitrev8;
        input [7:0] x;
        integer k;
        begin
            for (k = 0; k < 8; k = k + 1)
                bitrev8[k] = x[7-k];
        end
    endfunction

    // 输入帧：fi 0..7，每帧 256 个字
    always @* begin
        if (fi < 8)
            s_dat_tdata = zn[fi*256 + in_cnt];
        else
            s_dat_tdata = 32'd0;
        s_dat_tvalid = cfg_done && (fi < 8);
        s_dat_tlast  = (in_cnt == 255);
    end

    always @(posedge aclk) begin
        if (!aresetn) begin
            s_cfg_tvalid <= 0;
            cfg_done <= 0;
            in_cnt <= 0;
            fi <= 0;
        end else begin
            if (!cfg_done) begin
                s_cfg_tvalid <= 1;
                if (s_cfg_tvalid && s_cfg_tready)
                    cfg_done <= 1;
            end
            if (s_dat_tvalid && s_dat_tready) begin
                if (in_cnt == 255) begin
                    in_cnt <= 0;
                    fi <= fi + 1;
                end else begin
                    in_cnt <= in_cnt + 1;
                end
            end
        end
    end

    always @(posedge aclk) begin
        if (!aresetn) begin
            out_cnt <= 0;
            frame_ready <= 0;
            frames_written <= 0;
            done <= 0;
        end else begin
            if (m_dat_tvalid && m_dat_tready) begin
                nidx = bitrev8(out_cnt);
                cap_re[nidx] <= m_dat_tdata[24:0];
                cap_im[nidx] <= m_dat_tdata[56:32];
                if (m_dat_tlast) begin
                    out_cnt <= 0;
                    frame_ready <= 1;
                end else begin
                    out_cnt <= out_cnt + 1;
                end
            end
            if (frame_ready) begin
                for (i = 0; i < 256; i = i + 1)
                    $fdisplay(fd, "%08h %08h", {{7{cap_re[i][24]}}, cap_re[i]},
                                               {{7{cap_im[i][24]}}, cap_im[i]});
                frame_ready <= 0;
                frames_written <= frames_written + 1;
                if (frames_written == 7)
                    done <= 1;
            end
        end
    end

    initial begin
        $readmemh("gold_zn.hex", zn);
        fd = $fopen("fft_cap.hex", "w");
        if (fd == 0) begin
            $display("cannot open fft_cap.hex");
            $finish;
        end
        aresetn = 0;
        repeat (6) @(posedge aclk);
        aresetn = 1;
        wait (done == 1'b1);
        repeat (4) @(posedge aclk);
        $fclose(fd);
        $display("FFT capture done, 8 frames");
        $finish;
    end

    initial begin
        #2000000;
        $display("FFT CAP TIMEOUT: fi=%0d in=%0d out=%0d frames=%0d", fi, in_cnt, out_cnt, frames_written);
        $fclose(fd);
        $finish;
    end
endmodule
