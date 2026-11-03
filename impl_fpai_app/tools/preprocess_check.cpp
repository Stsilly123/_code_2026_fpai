// 离线自检 `preprocess.hpp` —— 不碰 icraft、不碰设备，所以**在 PC 上就能跑**。
//
// 为什么要单拎出来测：反交错 / 归一化这两处写错了**不会报错**，只会让准确率
// 莫名下降。把它和「板子能不能跑通」分开验证，出错时才知道该查哪一边。
//
//   ./preprocess_check <frames.bin> <out.raw> [seg_len]
//        frames.bin —— tools/send_iq.py --dump-frames 产出的帧流
//        out.raw    —— 每帧 2*seg_len 个 float32（模型实际看到的输入），顺序拼接
//
// 然后 tools/check_preprocess.py 会拿 IQDataset 的输出逐位比。

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <vector>

#include "../src/iq_frame.hpp"
#include "../src/preprocess.hpp"

int main(int argc, char *argv[]) {
    if (argc < 3) {
        std::fprintf(stderr, "用法: %s <frames.bin> <out.raw> [seg_len=256]\n", argv[0]);
        return 1;
    }
    const int seg_len = (argc > 3) ? std::atoi(argv[3]) : 256;

    FILE *fin = std::fopen(argv[1], "rb");
    if (!fin) {
        std::fprintf(stderr, "打不开 %s\n", argv[1]);
        return 1;
    }
    FILE *fout = std::fopen(argv[2], "wb");
    if (!fout) {
        std::fprintf(stderr, "写不了 %s\n", argv[2]);
        std::fclose(fin);
        return 1;
    }

    std::vector<char> payload;
    std::vector<float> raw;
    std::vector<float> norm(static_cast<size_t>(seg_len) * 2);
    long long n = 0;

    for (;;) {
        rffi::IqFrameHeader hdr{};
        if (std::fread(&hdr, sizeof(hdr), 1, fin) != 1) break;

        std::string err;
        if (!rffi::validate_header(hdr, seg_len, err)) {
            std::fprintf(stderr, "第 %lld 帧帧头非法: %s\n", n + 1, err.c_str());
            break;
        }
        payload.resize(rffi::payload_bytes(hdr));
        if (std::fread(payload.data(), 1, payload.size(), fin) != payload.size()) {
            std::fprintf(stderr, "第 %lld 帧截断\n", n + 1);
            break;
        }
        if (!rffi::decode_payload(hdr, payload.data(), payload.size(), seg_len, raw)) {
            std::fprintf(stderr, "第 %lld 帧载荷解不出来\n", n + 1);
            break;
        }

        rffi::deinterleave_normalize(raw.data(), static_cast<size_t>(seg_len), norm.data());
        if (n == 0) {
            const auto s = rffi::norm_stats(raw.data(), static_cast<size_t>(seg_len));
            std::fprintf(stderr, "首帧 mean=%.6f std=%.6f label=%d seq=%u\n", s.mean, s.stddev,
                         hdr.label, hdr.seq);
        }
        std::fwrite(norm.data(), sizeof(float), norm.size(), fout);
        ++n;
    }

    std::fprintf(stderr, "共 %lld 帧 -> %s\n", n, argv[2]);
    std::fclose(fin);
    std::fclose(fout);
    return n > 0 ? 0 : 2;
}
