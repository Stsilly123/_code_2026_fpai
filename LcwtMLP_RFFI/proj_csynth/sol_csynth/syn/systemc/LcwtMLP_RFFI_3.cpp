#include "LcwtMLP_RFFI.h"
#include "AESL_pkg.h"

using namespace std;

namespace ap_rtl {

void LcwtMLP_RFFI::thread_hdltv_gen() {
    const char* dump_tv = std::getenv("AP_WRITE_TV");
    if (!(dump_tv && string(dump_tv) == "on")) return;

    wait();

    mHdltvinHandle << "[ " << endl;
    mHdltvoutHandle << "[ " << endl;
    int ap_cycleNo = 0;
    while (1) {
        wait();
        const char* mComma = ap_cycleNo == 0 ? " " : ", " ;
        mHdltvinHandle << mComma << "{"  <<  " \"ap_rst_n\" :  \"" << ap_rst_n.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"ap_start\" :  \"" << ap_start.read() << "\" ";
        mHdltvoutHandle << mComma << "{"  <<  " \"ap_done\" :  \"" << ap_done.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"ap_idle\" :  \"" << ap_idle.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"ap_ready\" :  \"" << ap_ready.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"din_V_V_dout\" :  \"" << din_V_V_dout.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"din_V_V_empty_n\" :  \"" << din_V_V_empty_n.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"din_V_V_read\" :  \"" << din_V_V_read.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"dout_TDATA\" :  \"" << dout_TDATA.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"dout_TVALID\" :  \"" << dout_TVALID.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"dout_TREADY\" :  \"" << dout_TREADY.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"dout_TKEEP\" :  \"" << dout_TKEEP.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"dout_TSTRB\" :  \"" << dout_TSTRB.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"dout_TLAST\" :  \"" << dout_TLAST.read() << "\" ";
        mHdltvinHandle << "}" << std::endl;
        mHdltvoutHandle << "}" << std::endl;
        ap_cycleNo++;
    }
}

}

