#include "LcwtMLP_RFFI.h"
#include "AESL_pkg.h"

using namespace std;

namespace ap_rtl {

void LcwtMLP_RFFI::thread_LCWT_A_V_address0() {
    LCWT_A_V_address0 =  (sc_lv<8>) (tmp_25_fu_8862_p1.read());
}

void LcwtMLP_RFFI::thread_LCWT_A_V_address1() {
    LCWT_A_V_address1 =  (sc_lv<8>) (tmp_43_0_1_fu_8977_p1.read());
}

void LcwtMLP_RFFI::thread_LCWT_A_V_address2() {
    LCWT_A_V_address2 =  (sc_lv<8>) (tmp_43_1_fu_8998_p1.read());
}

void LcwtMLP_RFFI::thread_LCWT_A_V_address3() {
    LCWT_A_V_address3 =  (sc_lv<8>) (tmp_43_1_1_fu_9003_p1.read());
}

void LcwtMLP_RFFI::thread_LCWT_A_V_ce0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp2_stage0.read()) && 
         esl_seteq<1,1,1>(ap_block_pp2_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp2_iter0.read()))) {
        LCWT_A_V_ce0 = ap_const_logic_1;
    } else {
        LCWT_A_V_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LCWT_A_V_ce1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp2_stage0.read()) && 
         esl_seteq<1,1,1>(ap_block_pp2_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp2_iter1.read()))) {
        LCWT_A_V_ce1 = ap_const_logic_1;
    } else {
        LCWT_A_V_ce1 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LCWT_A_V_ce2() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp2_stage0.read()) && 
         esl_seteq<1,1,1>(ap_block_pp2_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp2_iter1.read()))) {
        LCWT_A_V_ce2 = ap_const_logic_1;
    } else {
        LCWT_A_V_ce2 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LCWT_A_V_ce3() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp2_stage0.read()) && 
         esl_seteq<1,1,1>(ap_block_pp2_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp2_iter1.read()))) {
        LCWT_A_V_ce3 = ap_const_logic_1;
    } else {
        LCWT_A_V_ce3 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LCWT_S_V_address0() {
    LCWT_S_V_address0 =  (sc_lv<8>) (tmp_38_fu_10879_p1.read());
}

void LcwtMLP_RFFI::thread_LCWT_S_V_address1() {
    LCWT_S_V_address1 =  (sc_lv<8>) (tmp_49_0_1_fu_10994_p1.read());
}

void LcwtMLP_RFFI::thread_LCWT_S_V_address2() {
    LCWT_S_V_address2 =  (sc_lv<8>) (tmp_49_1_fu_11015_p1.read());
}

void LcwtMLP_RFFI::thread_LCWT_S_V_address3() {
    LCWT_S_V_address3 =  (sc_lv<8>) (tmp_49_1_1_fu_11020_p1.read());
}

void LcwtMLP_RFFI::thread_LCWT_S_V_ce0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp5_stage0.read()) && 
         esl_seteq<1,1,1>(ap_block_pp5_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp5_iter0.read()))) {
        LCWT_S_V_ce0 = ap_const_logic_1;
    } else {
        LCWT_S_V_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LCWT_S_V_ce1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp5_stage0.read()) && 
         esl_seteq<1,1,1>(ap_block_pp5_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp5_iter1.read()))) {
        LCWT_S_V_ce1 = ap_const_logic_1;
    } else {
        LCWT_S_V_ce1 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LCWT_S_V_ce2() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp5_stage0.read()) && 
         esl_seteq<1,1,1>(ap_block_pp5_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp5_iter1.read()))) {
        LCWT_S_V_ce2 = ap_const_logic_1;
    } else {
        LCWT_S_V_ce2 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LCWT_S_V_ce3() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp5_stage0.read()) && 
         esl_seteq<1,1,1>(ap_block_pp5_stage0_11001.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp5_iter1.read()))) {
        LCWT_S_V_ce3 = ap_const_logic_1;
    } else {
        LCWT_S_V_ce3 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LOFF_address0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state31.read())) {
        LOFF_address0 =  (sc_lv<3>) (tmp_5_fu_10767_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state11.read())) {
        LOFF_address0 =  (sc_lv<3>) (tmp_6_fu_8739_p1.read());
    } else {
        LOFF_address0 = "XXX";
    }
}

void LcwtMLP_RFFI::thread_LOFF_address1() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state31.read())) {
        LOFF_address1 =  (sc_lv<3>) (tmp_7_fu_10772_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state11.read())) {
        LOFF_address1 =  (sc_lv<3>) (tmp_8_fu_8744_p1.read());
    } else {
        LOFF_address1 = "XXX";
    }
}

void LcwtMLP_RFFI::thread_LOFF_ce0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state11.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state31.read()))) {
        LOFF_ce0 = ap_const_logic_1;
    } else {
        LOFF_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_LOFF_ce1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state11.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state31.read()))) {
        LOFF_ce1 = ap_const_logic_1;
    } else {
        LOFF_ce1 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_0_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_0_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_0_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_0_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_0_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_0_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_0_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_10_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_10_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_10_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_10_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_10_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_10_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_10_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_11_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_11_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_11_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_11_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_11_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_11_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_11_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_12_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_12_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_12_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_12_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_12_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_12_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_12_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_13_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_13_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_13_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_13_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_13_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_13_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_13_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_14_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_14_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_14_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_14_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_14_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_14_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_14_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_15_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_15_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_15_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_15_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_15_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_15_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_15_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_16_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_16_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_16_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_16_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_16_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_16_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_16_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_17_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_17_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_17_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_17_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_17_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_17_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_17_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_18_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_18_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_18_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_18_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_18_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_18_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_18_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_19_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_19_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_19_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_19_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_19_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_19_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_19_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_1_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_1_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_1_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_1_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_1_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_1_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_1_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_20_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_20_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_20_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_20_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_20_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_20_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_20_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_21_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_21_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_21_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_21_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_21_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_21_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_21_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_22_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_22_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_22_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_22_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_22_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_22_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_22_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_23_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_23_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_23_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_23_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_23_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_23_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_23_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_24_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_24_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_24_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_24_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_24_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_24_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_24_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_25_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_25_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_25_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_25_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_25_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_25_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_25_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_26_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_26_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_26_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_26_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_26_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_26_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_26_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_27_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_27_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_27_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_27_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_27_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_27_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_27_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_28_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_28_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_28_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_28_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_28_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_28_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_28_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_29_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_29_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_29_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_29_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_29_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_29_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_29_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_2_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_2_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_2_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_2_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_2_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_2_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_2_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_30_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_30_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_30_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_30_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_30_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_30_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_30_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_31_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_31_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_31_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_31_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_31_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_31_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_31_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_32_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_32_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_32_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_32_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_32_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_32_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_32_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_33_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_33_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_33_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_33_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_33_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_33_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_33_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_34_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_34_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_34_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_34_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_34_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_34_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_34_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_35_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_35_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_35_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_35_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_35_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_35_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_35_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_36_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_36_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_36_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_36_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_36_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_36_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_36_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_37_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_37_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_37_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_37_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_37_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_37_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_37_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_3_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_3_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_3_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_3_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_3_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_3_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_3_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_4_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_4_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_4_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_4_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_4_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_4_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_4_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_5_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_5_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_5_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_5_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_5_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_5_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_5_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_6_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_6_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_6_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_6_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_6_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_6_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_6_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_7_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_7_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_7_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_7_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_7_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_7_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_7_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_8_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_8_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_8_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_8_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_8_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_8_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_8_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_9_address0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_9_address0 =  (sc_lv<5>) (tmp_71_fu_13472_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
                esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        PATCH_W_V_9_address0 =  (sc_lv<5>) (tmp_43_fu_13087_p1.read());
    } else {
        PATCH_W_V_9_address0 =  (sc_lv<5>) ("XXXXX");
    }
}

void LcwtMLP_RFFI::thread_PATCH_W_V_9_ce0() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        PATCH_W_V_9_ce0 = ap_const_logic_1;
    } else {
        PATCH_W_V_9_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_acc_V_10_cast_fu_13397_p1() {
    acc_V_10_cast_fu_13397_p1 = esl_sext<43,42>(acc_V_10_reg_7970.read());
}

void LcwtMLP_RFFI::thread_acc_V_11_cast_fu_13393_p1() {
    acc_V_11_cast_fu_13393_p1 = esl_sext<44,43>(acc_V_11_reg_7958.read());
}

void LcwtMLP_RFFI::thread_acc_V_12_cast_fu_13389_p1() {
    acc_V_12_cast_fu_13389_p1 = esl_sext<44,43>(acc_V_12_reg_7946.read());
}

void LcwtMLP_RFFI::thread_acc_V_13_cast_fu_13385_p1() {
    acc_V_13_cast_fu_13385_p1 = esl_sext<43,42>(acc_V_13_reg_7934.read());
}

void LcwtMLP_RFFI::thread_acc_V_14_cast_fu_13381_p1() {
    acc_V_14_cast_fu_13381_p1 = esl_sext<44,43>(acc_V_14_reg_7922.read());
}

void LcwtMLP_RFFI::thread_acc_V_15_cast_fu_13377_p1() {
    acc_V_15_cast_fu_13377_p1 = esl_sext<44,43>(acc_V_15_reg_7910.read());
}

void LcwtMLP_RFFI::thread_acc_V_16_cast_fu_13373_p1() {
    acc_V_16_cast_fu_13373_p1 = esl_sext<43,42>(acc_V_16_reg_7898.read());
}

void LcwtMLP_RFFI::thread_acc_V_17_cast_fu_13369_p1() {
    acc_V_17_cast_fu_13369_p1 = esl_sext<43,42>(acc_V_17_reg_7886.read());
}

void LcwtMLP_RFFI::thread_acc_V_18_cast_fu_13365_p1() {
    acc_V_18_cast_fu_13365_p1 = esl_sext<44,43>(acc_V_18_reg_7874.read());
}

void LcwtMLP_RFFI::thread_acc_V_19_cast_fu_13361_p1() {
    acc_V_19_cast_fu_13361_p1 = esl_sext<44,43>(acc_V_19_reg_7862.read());
}

void LcwtMLP_RFFI::thread_acc_V_1_cast_fu_13433_p1() {
    acc_V_1_cast_fu_13433_p1 = esl_sext<43,42>(acc_V_1_reg_8078.read());
}

void LcwtMLP_RFFI::thread_acc_V_20_cast_fu_13357_p1() {
    acc_V_20_cast_fu_13357_p1 = esl_sext<44,43>(acc_V_20_reg_7850.read());
}

void LcwtMLP_RFFI::thread_acc_V_21_cast_fu_13353_p1() {
    acc_V_21_cast_fu_13353_p1 = esl_sext<43,42>(acc_V_21_reg_7838.read());
}

void LcwtMLP_RFFI::thread_acc_V_22_cast_fu_13349_p1() {
    acc_V_22_cast_fu_13349_p1 = esl_sext<44,43>(acc_V_22_reg_7826.read());
}

void LcwtMLP_RFFI::thread_acc_V_24_cast_fu_13345_p1() {
    acc_V_24_cast_fu_13345_p1 = esl_sext<43,42>(acc_V_24_reg_7802.read());
}

void LcwtMLP_RFFI::thread_acc_V_25_cast_fu_13341_p1() {
    acc_V_25_cast_fu_13341_p1 = esl_sext<44,43>(acc_V_25_reg_7790.read());
}

void LcwtMLP_RFFI::thread_acc_V_26_cast_fu_13337_p1() {
    acc_V_26_cast_fu_13337_p1 = esl_sext<44,43>(acc_V_26_reg_7778.read());
}

void LcwtMLP_RFFI::thread_acc_V_27_cast_fu_13333_p1() {
    acc_V_27_cast_fu_13333_p1 = esl_sext<43,42>(acc_V_27_reg_7766.read());
}

void LcwtMLP_RFFI::thread_acc_V_28_cast_fu_13329_p1() {
    acc_V_28_cast_fu_13329_p1 = esl_sext<43,42>(acc_V_28_reg_7754.read());
}

void LcwtMLP_RFFI::thread_acc_V_29_cast_fu_13325_p1() {
    acc_V_29_cast_fu_13325_p1 = esl_sext<43,42>(acc_V_29_reg_7742.read());
}

void LcwtMLP_RFFI::thread_acc_V_2_cast_fu_13429_p1() {
    acc_V_2_cast_fu_13429_p1 = esl_sext<44,43>(acc_V_2_reg_8066.read());
}

void LcwtMLP_RFFI::thread_acc_V_30_cast_fu_13321_p1() {
    acc_V_30_cast_fu_13321_p1 = esl_sext<44,43>(acc_V_30_reg_7730.read());
}

void LcwtMLP_RFFI::thread_acc_V_31_cast_fu_13317_p1() {
    acc_V_31_cast_fu_13317_p1 = esl_sext<44,43>(acc_V_31_reg_7718.read());
}

void LcwtMLP_RFFI::thread_acc_V_32_cast_fu_13313_p1() {
    acc_V_32_cast_fu_13313_p1 = esl_sext<44,43>(acc_V_32_reg_7706.read());
}

void LcwtMLP_RFFI::thread_acc_V_33_cast_fu_13309_p1() {
    acc_V_33_cast_fu_13309_p1 = esl_sext<44,43>(acc_V_33_reg_7694.read());
}

void LcwtMLP_RFFI::thread_acc_V_34_cast_fu_13305_p1() {
    acc_V_34_cast_fu_13305_p1 = esl_sext<44,43>(acc_V_34_reg_7682.read());
}

void LcwtMLP_RFFI::thread_acc_V_35_cast_fu_13301_p1() {
    acc_V_35_cast_fu_13301_p1 = esl_sext<44,43>(acc_V_35_reg_7670.read());
}

void LcwtMLP_RFFI::thread_acc_V_36_cast_fu_13297_p1() {
    acc_V_36_cast_fu_13297_p1 = esl_sext<44,43>(acc_V_36_reg_7658.read());
}

void LcwtMLP_RFFI::thread_acc_V_3_cast_fu_13425_p1() {
    acc_V_3_cast_fu_13425_p1 = esl_sext<43,42>(acc_V_3_reg_8054.read());
}

void LcwtMLP_RFFI::thread_acc_V_4_cast_fu_13421_p1() {
    acc_V_4_cast_fu_13421_p1 = esl_sext<44,43>(acc_V_4_reg_8042.read());
}

void LcwtMLP_RFFI::thread_acc_V_5_cast_fu_13417_p1() {
    acc_V_5_cast_fu_13417_p1 = esl_sext<43,42>(acc_V_5_reg_8030.read());
}

void LcwtMLP_RFFI::thread_acc_V_6_cast_fu_13413_p1() {
    acc_V_6_cast_fu_13413_p1 = esl_sext<43,42>(acc_V_6_reg_8018.read());
}

void LcwtMLP_RFFI::thread_acc_V_7_cast_fu_13409_p1() {
    acc_V_7_cast_fu_13409_p1 = esl_sext<44,43>(acc_V_7_reg_8006.read());
}

void LcwtMLP_RFFI::thread_acc_V_8_cast_fu_13405_p1() {
    acc_V_8_cast_fu_13405_p1 = esl_sext<43,42>(acc_V_8_reg_7994.read());
}

void LcwtMLP_RFFI::thread_acc_V_9_cast_fu_13401_p1() {
    acc_V_9_cast_fu_13401_p1 = esl_sext<43,42>(acc_V_9_reg_7982.read());
}

void LcwtMLP_RFFI::thread_acc_V_cast_89_fu_13437_p1() {
    acc_V_cast_89_fu_13437_p1 = esl_sext<43,42>(acc_V_reg_8090.read());
}

void LcwtMLP_RFFI::thread_acc_V_cast_fu_13293_p1() {
    acc_V_cast_fu_13293_p1 = esl_sext<44,43>(acc_V_s_reg_7646.read());
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp0_stage0() {
    ap_CS_fsm_pp0_stage0 = ap_CS_fsm.read()[2];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp10_stage0() {
    ap_CS_fsm_pp10_stage0 = ap_CS_fsm.read()[41];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp11_stage0() {
    ap_CS_fsm_pp11_stage0 = ap_CS_fsm.read()[43];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp1_stage0() {
    ap_CS_fsm_pp1_stage0 = ap_CS_fsm.read()[4];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp2_stage0() {
    ap_CS_fsm_pp2_stage0 = ap_CS_fsm.read()[8];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp3_stage0() {
    ap_CS_fsm_pp3_stage0 = ap_CS_fsm.read()[10];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp4_stage0() {
    ap_CS_fsm_pp4_stage0 = ap_CS_fsm.read()[13];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp5_stage0() {
    ap_CS_fsm_pp5_stage0 = ap_CS_fsm.read()[22];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp6_stage0() {
    ap_CS_fsm_pp6_stage0 = ap_CS_fsm.read()[24];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp7_stage0() {
    ap_CS_fsm_pp7_stage0 = ap_CS_fsm.read()[27];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp8_stage0() {
    ap_CS_fsm_pp8_stage0 = ap_CS_fsm.read()[37];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_pp9_stage0() {
    ap_CS_fsm_pp9_stage0 = ap_CS_fsm.read()[39];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state1() {
    ap_CS_fsm_state1 = ap_CS_fsm.read()[0];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state10() {
    ap_CS_fsm_state10 = ap_CS_fsm.read()[5];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state11() {
    ap_CS_fsm_state11 = ap_CS_fsm.read()[6];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state12() {
    ap_CS_fsm_state12 = ap_CS_fsm.read()[7];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state16() {
    ap_CS_fsm_state16 = ap_CS_fsm.read()[9];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state2() {
    ap_CS_fsm_state2 = ap_CS_fsm.read()[1];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state20() {
    ap_CS_fsm_state20 = ap_CS_fsm.read()[11];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state21() {
    ap_CS_fsm_state21 = ap_CS_fsm.read()[12];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state25() {
    ap_CS_fsm_state25 = ap_CS_fsm.read()[14];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state26() {
    ap_CS_fsm_state26 = ap_CS_fsm.read()[15];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state27() {
    ap_CS_fsm_state27 = ap_CS_fsm.read()[16];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state28() {
    ap_CS_fsm_state28 = ap_CS_fsm.read()[17];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state29() {
    ap_CS_fsm_state29 = ap_CS_fsm.read()[18];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state30() {
    ap_CS_fsm_state30 = ap_CS_fsm.read()[19];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state31() {
    ap_CS_fsm_state31 = ap_CS_fsm.read()[20];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state32() {
    ap_CS_fsm_state32 = ap_CS_fsm.read()[21];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state36() {
    ap_CS_fsm_state36 = ap_CS_fsm.read()[23];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state41() {
    ap_CS_fsm_state41 = ap_CS_fsm.read()[25];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state42() {
    ap_CS_fsm_state42 = ap_CS_fsm.read()[26];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state46() {
    ap_CS_fsm_state46 = ap_CS_fsm.read()[28];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state47() {
    ap_CS_fsm_state47 = ap_CS_fsm.read()[29];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state48() {
    ap_CS_fsm_state48 = ap_CS_fsm.read()[30];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state49() {
    ap_CS_fsm_state49 = ap_CS_fsm.read()[31];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state50() {
    ap_CS_fsm_state50 = ap_CS_fsm.read()[32];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state51() {
    ap_CS_fsm_state51 = ap_CS_fsm.read()[33];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state52() {
    ap_CS_fsm_state52 = ap_CS_fsm.read()[34];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state53() {
    ap_CS_fsm_state53 = ap_CS_fsm.read()[35];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state54() {
    ap_CS_fsm_state54 = ap_CS_fsm.read()[36];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state6() {
    ap_CS_fsm_state6 = ap_CS_fsm.read()[3];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state60() {
    ap_CS_fsm_state60 = ap_CS_fsm.read()[38];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state66() {
    ap_CS_fsm_state66 = ap_CS_fsm.read()[40];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state69() {
    ap_CS_fsm_state69 = ap_CS_fsm.read()[42];
}

void LcwtMLP_RFFI::thread_ap_CS_fsm_state76() {
    ap_CS_fsm_state76 = ap_CS_fsm.read()[44];
}

void LcwtMLP_RFFI::thread_ap_block_pp0_stage0() {
    ap_block_pp0_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp0_stage0_11001() {
    ap_block_pp0_stage0_11001 = (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp0_iter1.read()) && esl_seteq<1,1,1>(ap_const_logic_0, din_V_V_empty_n.read()) && esl_seteq<1,1,1>(ap_const_boolean_1, ap_predicate_op305_read_state4.read()));
}

void LcwtMLP_RFFI::thread_ap_block_pp0_stage0_subdone() {
    ap_block_pp0_stage0_subdone = (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp0_iter1.read()) && esl_seteq<1,1,1>(ap_const_logic_0, din_V_V_empty_n.read()) && esl_seteq<1,1,1>(ap_const_boolean_1, ap_predicate_op305_read_state4.read()));
}

void LcwtMLP_RFFI::thread_ap_block_pp10_stage0() {
    ap_block_pp10_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp10_stage0_11001() {
    ap_block_pp10_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp10_stage0_subdone() {
    ap_block_pp10_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp11_stage0() {
    ap_block_pp11_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp11_stage0_01001() {
    ap_block_pp11_stage0_01001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp11_stage0_11001() {
    ap_block_pp11_stage0_11001 = ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter4.read()) && 
  esl_seteq<1,1,1>(ap_const_boolean_1, ap_block_state74_io.read())) || (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter5.read()) && 
  esl_seteq<1,1,1>(ap_const_boolean_1, ap_block_state75_io.read())));
}

void LcwtMLP_RFFI::thread_ap_block_pp11_stage0_subdone() {
    ap_block_pp11_stage0_subdone = ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter4.read()) && 
  esl_seteq<1,1,1>(ap_const_boolean_1, ap_block_state74_io.read())) || (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter5.read()) && 
  esl_seteq<1,1,1>(ap_const_boolean_1, ap_block_state75_io.read())));
}

void LcwtMLP_RFFI::thread_ap_block_pp1_stage0() {
    ap_block_pp1_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp1_stage0_11001() {
    ap_block_pp1_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp1_stage0_subdone() {
    ap_block_pp1_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp2_stage0() {
    ap_block_pp2_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp2_stage0_11001() {
    ap_block_pp2_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp2_stage0_subdone() {
    ap_block_pp2_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp3_stage0() {
    ap_block_pp3_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp3_stage0_11001() {
    ap_block_pp3_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp3_stage0_subdone() {
    ap_block_pp3_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp4_stage0() {
    ap_block_pp4_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp4_stage0_11001() {
    ap_block_pp4_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp4_stage0_subdone() {
    ap_block_pp4_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp5_stage0() {
    ap_block_pp5_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp5_stage0_11001() {
    ap_block_pp5_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp5_stage0_subdone() {
    ap_block_pp5_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp6_stage0() {
    ap_block_pp6_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp6_stage0_11001() {
    ap_block_pp6_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp6_stage0_subdone() {
    ap_block_pp6_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp7_stage0() {
    ap_block_pp7_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp7_stage0_11001() {
    ap_block_pp7_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp7_stage0_subdone() {
    ap_block_pp7_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp8_stage0() {
    ap_block_pp8_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp8_stage0_11001() {
    ap_block_pp8_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp8_stage0_subdone() {
    ap_block_pp8_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp9_stage0() {
    ap_block_pp9_stage0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp9_stage0_11001() {
    ap_block_pp9_stage0_11001 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_pp9_stage0_subdone() {
    ap_block_pp9_stage0_subdone = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state13_pp2_stage0_iter0() {
    ap_block_state13_pp2_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state14_pp2_stage0_iter1() {
    ap_block_state14_pp2_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state15_pp2_stage0_iter2() {
    ap_block_state15_pp2_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state17_pp3_stage0_iter0() {
    ap_block_state17_pp3_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state18_pp3_stage0_iter1() {
    ap_block_state18_pp3_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state19_pp3_stage0_iter2() {
    ap_block_state19_pp3_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state2() {
    ap_block_state2 = (esl_seteq<1,1,1>(ap_const_logic_0, dout_V_data_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_keep_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_strb_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_last_V_1_ack_in.read()));
}

void LcwtMLP_RFFI::thread_ap_block_state22_pp4_stage0_iter0() {
    ap_block_state22_pp4_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state23_pp4_stage0_iter1() {
    ap_block_state23_pp4_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state24_pp4_stage0_iter2() {
    ap_block_state24_pp4_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state33_pp5_stage0_iter0() {
    ap_block_state33_pp5_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state34_pp5_stage0_iter1() {
    ap_block_state34_pp5_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state35_pp5_stage0_iter2() {
    ap_block_state35_pp5_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state37_pp6_stage0_iter0() {
    ap_block_state37_pp6_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state38_pp6_stage0_iter1() {
    ap_block_state38_pp6_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state39_pp6_stage0_iter2() {
    ap_block_state39_pp6_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state3_pp0_stage0_iter0() {
    ap_block_state3_pp0_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state40_pp6_stage0_iter3() {
    ap_block_state40_pp6_stage0_iter3 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state43_pp7_stage0_iter0() {
    ap_block_state43_pp7_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state44_pp7_stage0_iter1() {
    ap_block_state44_pp7_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state45_pp7_stage0_iter2() {
    ap_block_state45_pp7_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state4_pp0_stage0_iter1() {
    ap_block_state4_pp0_stage0_iter1 = (esl_seteq<1,1,1>(ap_const_logic_0, din_V_V_empty_n.read()) && esl_seteq<1,1,1>(ap_const_boolean_1, ap_predicate_op305_read_state4.read()));
}

void LcwtMLP_RFFI::thread_ap_block_state55_pp8_stage0_iter0() {
    ap_block_state55_pp8_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state56_pp8_stage0_iter1() {
    ap_block_state56_pp8_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state57_pp8_stage0_iter2() {
    ap_block_state57_pp8_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state58_pp8_stage0_iter3() {
    ap_block_state58_pp8_stage0_iter3 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state59_pp8_stage0_iter4() {
    ap_block_state59_pp8_stage0_iter4 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state5_pp0_stage0_iter2() {
    ap_block_state5_pp0_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state61_pp9_stage0_iter0() {
    ap_block_state61_pp9_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state62_pp9_stage0_iter1() {
    ap_block_state62_pp9_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state63_pp9_stage0_iter2() {
    ap_block_state63_pp9_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state64_pp9_stage0_iter3() {
    ap_block_state64_pp9_stage0_iter3 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state65_pp9_stage0_iter4() {
    ap_block_state65_pp9_stage0_iter4 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state67_pp10_stage0_iter0() {
    ap_block_state67_pp10_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state68_pp10_stage0_iter1() {
    ap_block_state68_pp10_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state70_pp11_stage0_iter0() {
    ap_block_state70_pp11_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state71_pp11_stage0_iter1() {
    ap_block_state71_pp11_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state72_pp11_stage0_iter2() {
    ap_block_state72_pp11_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state73_pp11_stage0_iter3() {
    ap_block_state73_pp11_stage0_iter3 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state74_io() {
    ap_block_state74_io = (esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522_pp11_iter3_reg.read()) && esl_seteq<1,1,1>(ap_const_logic_0, dout_V_data_V_1_ack_in.read()));
}

void LcwtMLP_RFFI::thread_ap_block_state74_pp11_stage0_iter4() {
    ap_block_state74_pp11_stage0_iter4 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state75_io() {
    ap_block_state75_io = (esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522_pp11_iter4_reg.read()) && esl_seteq<1,1,1>(ap_const_logic_0, dout_V_data_V_1_ack_in.read()));
}

void LcwtMLP_RFFI::thread_ap_block_state75_pp11_stage0_iter5() {
    ap_block_state75_pp11_stage0_iter5 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state7_pp1_stage0_iter0() {
    ap_block_state7_pp1_stage0_iter0 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state8_pp1_stage0_iter1() {
    ap_block_state8_pp1_stage0_iter1 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_block_state9_pp1_stage0_iter2() {
    ap_block_state9_pp1_stage0_iter2 = !esl_seteq<1,1,1>(ap_const_boolean_1, ap_const_boolean_1);
}

void LcwtMLP_RFFI::thread_ap_condition_3567() {
    ap_condition_3567 = (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp0_iter1.read()) && esl_seteq<1,1,1>(ap_block_pp0_stage0_11001.read(), ap_const_boolean_0));
}

void LcwtMLP_RFFI::thread_ap_condition_4791() {
    ap_condition_4791 = (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp7_stage0.read()) && esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp7_iter0.read()) && esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1584_i_i_i_fu_11529_p2.read()) && esl_seteq<1,1,1>(ap_block_pp7_stage0.read(), ap_const_boolean_0));
}

void LcwtMLP_RFFI::thread_ap_condition_5135() {
    ap_condition_5135 = (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp4_stage0.read()) && esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp4_iter0.read()) && esl_seteq<1,1,1>(ap_const_lv1_0, exitcond800_i_i_i_fu_9497_p2.read()) && esl_seteq<1,1,1>(ap_block_pp4_stage0.read(), ap_const_boolean_0));
}

void LcwtMLP_RFFI::thread_ap_condition_9273() {
    ap_condition_9273 = (!esl_seteq<1,4,4>(tmp_180_0_t_fu_11553_p2.read(), ap_const_lv4_2) && !esl_seteq<1,4,4>(tmp_180_0_t_fu_11553_p2.read(), ap_const_lv4_6) && !esl_seteq<1,4,4>(tmp_180_0_t_fu_11553_p2.read(), ap_const_lv4_A));
}

void LcwtMLP_RFFI::thread_ap_condition_pp0_exit_iter1_state4() {
    if ((esl_seteq<1,1,1>(ap_enable_reg_pp0_iter1.read(), ap_const_logic_1) && 
         esl_seteq<1,1,1>(ap_enable_reg_pp0_iter0.read(), ap_const_logic_0))) {
        ap_condition_pp0_exit_iter1_state4 = ap_const_logic_1;
    } else {
        ap_condition_pp0_exit_iter1_state4 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp10_exit_iter0_state67() {
    if (esl_seteq<1,1,1>(ap_const_lv1_1, exitcond_i61_i_i_fu_14445_p2.read())) {
        ap_condition_pp10_exit_iter0_state67 = ap_const_logic_1;
    } else {
        ap_condition_pp10_exit_iter0_state67 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp11_exit_iter0_state70() {
    if (esl_seteq<1,1,1>(ap_const_lv1_1, exitcond_flatten_fu_14522_p2.read())) {
        ap_condition_pp11_exit_iter0_state70 = ap_const_logic_1;
    } else {
        ap_condition_pp11_exit_iter0_state70 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp1_exit_iter0_state7() {
    if (esl_seteq<1,1,1>(ap_const_lv1_1, exitcond_i_i_fu_8605_p2.read())) {
        ap_condition_pp1_exit_iter0_state7 = ap_const_logic_1;
    } else {
        ap_condition_pp1_exit_iter0_state7 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp2_exit_iter1_state14() {
    if ((esl_seteq<1,1,1>(ap_enable_reg_pp2_iter1.read(), ap_const_logic_1) && 
         esl_seteq<1,1,1>(ap_enable_reg_pp2_iter0.read(), ap_const_logic_0))) {
        ap_condition_pp2_exit_iter1_state14 = ap_const_logic_1;
    } else {
        ap_condition_pp2_exit_iter1_state14 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp4_exit_iter0_state22() {
    if (esl_seteq<1,1,1>(ap_const_lv1_1, exitcond800_i_i_i_fu_9497_p2.read())) {
        ap_condition_pp4_exit_iter0_state22 = ap_const_logic_1;
    } else {
        ap_condition_pp4_exit_iter0_state22 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp5_exit_iter1_state34() {
    if ((esl_seteq<1,1,1>(ap_enable_reg_pp5_iter1.read(), ap_const_logic_1) && 
         esl_seteq<1,1,1>(ap_enable_reg_pp5_iter0.read(), ap_const_logic_0))) {
        ap_condition_pp5_exit_iter1_state34 = ap_const_logic_1;
    } else {
        ap_condition_pp5_exit_iter1_state34 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp7_exit_iter0_state43() {
    if (esl_seteq<1,1,1>(ap_const_lv1_1, exitcond1584_i_i_i_fu_11529_p2.read())) {
        ap_condition_pp7_exit_iter0_state43 = ap_const_logic_1;
    } else {
        ap_condition_pp7_exit_iter0_state43 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp8_exit_iter0_state55() {
    if (esl_seteq<1,1,1>(ap_const_lv1_1, exitcond134_i_i_i_fu_13062_p2.read())) {
        ap_condition_pp8_exit_iter0_state55 = ap_const_logic_1;
    } else {
        ap_condition_pp8_exit_iter0_state55 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_condition_pp9_exit_iter0_state61() {
    if (esl_seteq<1,1,1>(ap_const_lv1_1, exitcond132_i_i_i_fu_13441_p2.read())) {
        ap_condition_pp9_exit_iter0_state61 = ap_const_logic_1;
    } else {
        ap_condition_pp9_exit_iter0_state61 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_done() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state2.read()) && 
         !(esl_seteq<1,1,1>(ap_const_logic_0, dout_V_data_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_keep_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_strb_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_last_V_1_ack_in.read())) && 
         esl_seteq<1,1,1>(ap_const_logic_0, dout_V_data_V_1_state.read()[0]) && 
         esl_seteq<1,1,1>(ap_const_logic_0, dout_V_keep_V_1_state.read()[0]) && 
         esl_seteq<1,1,1>(ap_const_logic_0, dout_V_strb_V_1_state.read()[0]) && 
         esl_seteq<1,1,1>(ap_const_logic_0, dout_V_last_V_1_state.read()[0]) && 
         esl_seteq<1,1,1>(ap_const_lv1_1, exitcond_fu_8550_p2.read()))) {
        ap_done = ap_const_logic_1;
    } else {
        ap_done = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_enable_pp0() {
    ap_enable_pp0 = (ap_idle_pp0.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp1() {
    ap_enable_pp1 = (ap_idle_pp1.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp10() {
    ap_enable_pp10 = (ap_idle_pp10.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp11() {
    ap_enable_pp11 = (ap_idle_pp11.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp2() {
    ap_enable_pp2 = (ap_idle_pp2.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp3() {
    ap_enable_pp3 = (ap_idle_pp3.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp4() {
    ap_enable_pp4 = (ap_idle_pp4.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp5() {
    ap_enable_pp5 = (ap_idle_pp5.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp6() {
    ap_enable_pp6 = (ap_idle_pp6.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp7() {
    ap_enable_pp7 = (ap_idle_pp7.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp8() {
    ap_enable_pp8 = (ap_idle_pp8.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_enable_pp9() {
    ap_enable_pp9 = (ap_idle_pp9.read() ^ ap_const_logic_1);
}

void LcwtMLP_RFFI::thread_ap_idle() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_start.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state1.read()))) {
        ap_idle = ap_const_logic_1;
    } else {
        ap_idle = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp0_iter2.read()))) {
        ap_idle_pp0 = ap_const_logic_1;
    } else {
        ap_idle_pp0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp1_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp1_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp1_iter2.read()))) {
        ap_idle_pp1 = ap_const_logic_1;
    } else {
        ap_idle_pp1 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp10() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp10_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp10_iter1.read()))) {
        ap_idle_pp10 = ap_const_logic_1;
    } else {
        ap_idle_pp10 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp11() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp11_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp11_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp11_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp11_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp11_iter4.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp11_iter5.read()))) {
        ap_idle_pp11 = ap_const_logic_1;
    } else {
        ap_idle_pp11 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp2() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp2_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp2_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp2_iter2.read()))) {
        ap_idle_pp2 = ap_const_logic_1;
    } else {
        ap_idle_pp2 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp3() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp3_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp3_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp3_iter2.read()))) {
        ap_idle_pp3 = ap_const_logic_1;
    } else {
        ap_idle_pp3 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp4() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp4_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp4_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp4_iter2.read()))) {
        ap_idle_pp4 = ap_const_logic_1;
    } else {
        ap_idle_pp4 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp5() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp5_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp5_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp5_iter2.read()))) {
        ap_idle_pp5 = ap_const_logic_1;
    } else {
        ap_idle_pp5 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp6() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp6_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp6_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp6_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp6_iter3.read()))) {
        ap_idle_pp6 = ap_const_logic_1;
    } else {
        ap_idle_pp6 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp7() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp7_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp7_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp7_iter2.read()))) {
        ap_idle_pp7 = ap_const_logic_1;
    } else {
        ap_idle_pp7 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp8() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp8_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp8_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp8_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp8_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp8_iter4.read()))) {
        ap_idle_pp8 = ap_const_logic_1;
    } else {
        ap_idle_pp8 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_idle_pp9() {
    if ((esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp9_iter0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp9_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp9_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_0, ap_enable_reg_pp9_iter4.read()))) {
        ap_idle_pp9 = ap_const_logic_1;
    } else {
        ap_idle_pp9 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_i_0_i_i_i_phi_fu_8106_p4() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond134_i_i_i_reg_18840.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_i_0_i_i_i_phi_fu_8106_p4 = i_2_reg_18844.read();
    } else {
        ap_phi_mux_i_0_i_i_i_phi_fu_8106_p4 = i_0_i_i_i_reg_8102.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_i_0_i_phi_fu_2518_p4() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp0_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp0_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_i_reg_17059.read()))) {
        ap_phi_mux_i_0_i_phi_fu_2518_p4 = i_1_reg_17063.read();
    } else {
        ap_phi_mux_i_0_i_phi_fu_2518_p4 = i_0_i_reg_2514.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_k_0_i44_i_i_phi_fu_5503_p4() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp5_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp5_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1590_i_i_i_reg_18170.read()) && 
         esl_seteq<1,1,1>(ap_block_pp5_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_k_0_i44_i_i_phi_fu_5503_p4 = k_2_reg_18174.read();
    } else {
        ap_phi_mux_k_0_i44_i_i_phi_fu_5503_p4 = k_0_i44_i_i_reg_5499.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_k_0_i_i_i_phi_fu_2588_p4() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp2_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp2_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond806_i_i_i_reg_17333.read()) && 
         esl_seteq<1,1,1>(ap_block_pp2_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_k_0_i_i_i_phi_fu_2588_p4 = k_1_reg_17337.read();
    } else {
        ap_phi_mux_k_0_i_i_i_phi_fu_2588_p4 = k_0_i_i_i_reg_2584.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_p_047_0_i_phi_fu_2530_p4() {
    if ((esl_seteq<1,1,1>(ap_block_pp0_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp0_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_i_reg_17059_pp0_iter1_reg.read()))) {
        ap_phi_mux_p_047_0_i_phi_fu_2530_p4 = p_047_1_i_reg_2538.read();
    } else {
        ap_phi_mux_p_047_0_i_phi_fu_2530_p4 = p_047_0_i_reg_2526.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_s0rE_V_0_phi_phi_fu_7624_p8() {
    if (esl_seteq<1,1,1>(ap_condition_4791.read(), ap_const_boolean_1)) {
        if (esl_seteq<1,4,4>(tmp_180_0_t_fu_11553_p2.read(), ap_const_lv4_2)) {
            ap_phi_mux_s0rE_V_0_phi_phi_fu_7624_p8 = wsr_V_0_0_2_load_reg_18198.read();
        } else if (esl_seteq<1,1,1>(ap_condition_9273.read(), ap_const_boolean_1)) {
            ap_phi_mux_s0rE_V_0_phi_phi_fu_7624_p8 = wsr_V_0_0_14_load_reg_18213.read();
        } else if (esl_seteq<1,4,4>(tmp_180_0_t_fu_11553_p2.read(), ap_const_lv4_A)) {
            ap_phi_mux_s0rE_V_0_phi_phi_fu_7624_p8 = wsr_V_0_0_10_load_reg_18208.read();
        } else if (esl_seteq<1,4,4>(tmp_180_0_t_fu_11553_p2.read(), ap_const_lv4_6)) {
            ap_phi_mux_s0rE_V_0_phi_phi_fu_7624_p8 = wsr_V_0_0_6_load_reg_18203.read();
        } else {
            ap_phi_mux_s0rE_V_0_phi_phi_fu_7624_p8 = ap_phi_reg_pp7_iter0_s0rE_V_0_phi_reg_7621.read();
        }
    } else {
        ap_phi_mux_s0rE_V_0_phi_phi_fu_7624_p8 = ap_phi_reg_pp7_iter0_s0rE_V_0_phi_reg_7621.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_t_0_i_phi_fu_8532_p4() {
    if ((esl_seteq<1,1,1>(ap_block_pp11_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp11_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter1.read()))) {
        ap_phi_mux_t_0_i_phi_fu_8532_p4 = tmp_31_mid2_v_reg_20536.read();
    } else {
        ap_phi_mux_t_0_i_phi_fu_8532_p4 = t_0_i_reg_8528.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_w0r_V_0_phi_phi_fu_5477_p8() {
    if (esl_seteq<1,1,1>(ap_condition_5135.read(), ap_const_boolean_1)) {
        if (esl_seteq<1,2,2>(ap_const_lv2_0, tmp_221_fu_9509_p1.read())) {
            ap_phi_mux_w0r_V_0_phi_phi_fu_5477_p8 = war_V_0_0_0_load_reg_17361.read();
        } else if (esl_seteq<1,2,2>(ap_const_lv2_3, tmp_221_fu_9509_p1.read())) {
            ap_phi_mux_w0r_V_0_phi_phi_fu_5477_p8 = war_V_0_0_12_load_reg_17376.read();
        } else if (esl_seteq<1,2,2>(ap_const_lv2_2, tmp_221_fu_9509_p1.read())) {
            ap_phi_mux_w0r_V_0_phi_phi_fu_5477_p8 = war_V_0_0_8_load_reg_17371.read();
        } else if (esl_seteq<1,2,2>(ap_const_lv2_1, tmp_221_fu_9509_p1.read())) {
            ap_phi_mux_w0r_V_0_phi_phi_fu_5477_p8 = war_V_0_0_4_load_reg_17366.read();
        } else {
            ap_phi_mux_w0r_V_0_phi_phi_fu_5477_p8 = ap_phi_reg_pp4_iter0_w0r_V_0_phi_reg_5474.read();
        }
    } else {
        ap_phi_mux_w0r_V_0_phi_phi_fu_5477_p8 = ap_phi_reg_pp4_iter0_w0r_V_0_phi_reg_5474.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whi_V_0_3_phi_fu_6807_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0))) {
        ap_phi_mux_whi_V_0_3_phi_fu_6807_p16 = hi_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)))) {
        ap_phi_mux_whi_V_0_3_phi_fu_6807_p16 = whi_V_0_2_reg_5592.read();
    } else {
        ap_phi_mux_whi_V_0_3_phi_fu_6807_p16 = ap_phi_reg_pp6_iter3_whi_V_0_3_reg_6803.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whi_V_1_3_phi_fu_6776_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1))) {
        ap_phi_mux_whi_V_1_3_phi_fu_6776_p16 = hi_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whi_V_1_3_phi_fu_6776_p16 = whi_V_1_2_reg_5582.read();
    } else {
        ap_phi_mux_whi_V_1_3_phi_fu_6776_p16 = ap_phi_reg_pp6_iter3_whi_V_1_3_reg_6772.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whi_V_2_3_phi_fu_6745_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2))) {
        ap_phi_mux_whi_V_2_3_phi_fu_6745_p16 = hi_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whi_V_2_3_phi_fu_6745_p16 = whi_V_2_2_reg_5572.read();
    } else {
        ap_phi_mux_whi_V_2_3_phi_fu_6745_p16 = ap_phi_reg_pp6_iter3_whi_V_2_3_reg_6741.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whi_V_3_3_phi_fu_6714_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3))) {
        ap_phi_mux_whi_V_3_3_phi_fu_6714_p16 = hi_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whi_V_3_3_phi_fu_6714_p16 = whi_V_3_2_reg_5562.read();
    } else {
        ap_phi_mux_whi_V_3_3_phi_fu_6714_p16 = ap_phi_reg_pp6_iter3_whi_V_3_3_reg_6710.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whi_V_4_3_phi_fu_6683_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4))) {
        ap_phi_mux_whi_V_4_3_phi_fu_6683_p16 = hi_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whi_V_4_3_phi_fu_6683_p16 = whi_V_4_2_reg_5552.read();
    } else {
        ap_phi_mux_whi_V_4_3_phi_fu_6683_p16 = ap_phi_reg_pp6_iter3_whi_V_4_3_reg_6679.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whi_V_5_3_phi_fu_6652_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5))) {
        ap_phi_mux_whi_V_5_3_phi_fu_6652_p16 = hi_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whi_V_5_3_phi_fu_6652_p16 = whi_V_5_2_reg_5542.read();
    } else {
        ap_phi_mux_whi_V_5_3_phi_fu_6652_p16 = ap_phi_reg_pp6_iter3_whi_V_5_3_reg_6648.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whi_V_6_3_phi_fu_6621_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6))) {
        ap_phi_mux_whi_V_6_3_phi_fu_6621_p16 = hi_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whi_V_6_3_phi_fu_6621_p16 = whi_V_6_2_reg_5532.read();
    } else {
        ap_phi_mux_whi_V_6_3_phi_fu_6621_p16 = ap_phi_reg_pp6_iter3_whi_V_6_3_reg_6617.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whi_V_7_3_phi_fu_6590_p16() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whi_V_7_3_phi_fu_6590_p16 = whi_V_7_2_reg_5522.read();
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_whi_V_7_3_phi_fu_6590_p16 = hi_i_q0.read();
    } else {
        ap_phi_mux_whi_V_7_3_phi_fu_6590_p16 = ap_phi_reg_pp6_iter3_whi_V_7_3_reg_6586.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whr_V_0_3_phi_fu_6559_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0))) {
        ap_phi_mux_whr_V_0_3_phi_fu_6559_p16 = hr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)))) {
        ap_phi_mux_whr_V_0_3_phi_fu_6559_p16 = whr_V_0_2_reg_5672.read();
    } else {
        ap_phi_mux_whr_V_0_3_phi_fu_6559_p16 = ap_phi_reg_pp6_iter3_whr_V_0_3_reg_6555.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whr_V_1_3_phi_fu_6528_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1))) {
        ap_phi_mux_whr_V_1_3_phi_fu_6528_p16 = hr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whr_V_1_3_phi_fu_6528_p16 = whr_V_1_2_reg_5662.read();
    } else {
        ap_phi_mux_whr_V_1_3_phi_fu_6528_p16 = ap_phi_reg_pp6_iter3_whr_V_1_3_reg_6524.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whr_V_2_3_phi_fu_6497_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2))) {
        ap_phi_mux_whr_V_2_3_phi_fu_6497_p16 = hr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whr_V_2_3_phi_fu_6497_p16 = whr_V_2_2_reg_5652.read();
    } else {
        ap_phi_mux_whr_V_2_3_phi_fu_6497_p16 = ap_phi_reg_pp6_iter3_whr_V_2_3_reg_6493.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whr_V_3_3_phi_fu_6466_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3))) {
        ap_phi_mux_whr_V_3_3_phi_fu_6466_p16 = hr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whr_V_3_3_phi_fu_6466_p16 = whr_V_3_2_reg_5642.read();
    } else {
        ap_phi_mux_whr_V_3_3_phi_fu_6466_p16 = ap_phi_reg_pp6_iter3_whr_V_3_3_reg_6462.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whr_V_4_3_phi_fu_6435_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4))) {
        ap_phi_mux_whr_V_4_3_phi_fu_6435_p16 = hr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whr_V_4_3_phi_fu_6435_p16 = whr_V_4_2_reg_5632.read();
    } else {
        ap_phi_mux_whr_V_4_3_phi_fu_6435_p16 = ap_phi_reg_pp6_iter3_whr_V_4_3_reg_6431.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whr_V_5_3_phi_fu_6404_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5))) {
        ap_phi_mux_whr_V_5_3_phi_fu_6404_p16 = hr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whr_V_5_3_phi_fu_6404_p16 = whr_V_5_2_reg_5622.read();
    } else {
        ap_phi_mux_whr_V_5_3_phi_fu_6404_p16 = ap_phi_reg_pp6_iter3_whr_V_5_3_reg_6400.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whr_V_6_3_phi_fu_6373_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6))) {
        ap_phi_mux_whr_V_6_3_phi_fu_6373_p16 = hr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whr_V_6_3_phi_fu_6373_p16 = whr_V_6_2_reg_5612.read();
    } else {
        ap_phi_mux_whr_V_6_3_phi_fu_6373_p16 = ap_phi_reg_pp6_iter3_whr_V_6_3_reg_6369.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_whr_V_7_3_phi_fu_6342_p16() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_whr_V_7_3_phi_fu_6342_p16 = whr_V_7_2_reg_5602.read();
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_whr_V_7_3_phi_fu_6342_p16 = hr_i_q0.read();
    } else {
        ap_phi_mux_whr_V_7_3_phi_fu_6342_p16 = ap_phi_reg_pp6_iter3_whr_V_7_3_reg_6338.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_0_3_phi_fu_4636_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0))) {
        ap_phi_mux_wi_V_0_3_phi_fu_4636_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)))) {
        ap_phi_mux_wi_V_0_3_phi_fu_4636_p32 = wi_V_0_2_reg_2757.read();
    } else {
        ap_phi_mux_wi_V_0_3_phi_fu_4636_p32 = ap_phi_reg_pp3_iter2_wi_V_0_3_reg_4632.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_10_3_phi_fu_4086_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A))) {
        ap_phi_mux_wi_V_10_3_phi_fu_4086_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_10_3_phi_fu_4086_p32 = wi_V_10_2_reg_2657.read();
    } else {
        ap_phi_mux_wi_V_10_3_phi_fu_4086_p32 = ap_phi_reg_pp3_iter2_wi_V_10_3_reg_4082.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_11_3_phi_fu_4031_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B))) {
        ap_phi_mux_wi_V_11_3_phi_fu_4031_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_11_3_phi_fu_4031_p32 = wi_V_11_2_reg_2647.read();
    } else {
        ap_phi_mux_wi_V_11_3_phi_fu_4031_p32 = ap_phi_reg_pp3_iter2_wi_V_11_3_reg_4027.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_12_3_phi_fu_3976_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C))) {
        ap_phi_mux_wi_V_12_3_phi_fu_3976_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_12_3_phi_fu_3976_p32 = wi_V_12_2_reg_2637.read();
    } else {
        ap_phi_mux_wi_V_12_3_phi_fu_3976_p32 = ap_phi_reg_pp3_iter2_wi_V_12_3_reg_3972.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_13_3_phi_fu_3921_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D))) {
        ap_phi_mux_wi_V_13_3_phi_fu_3921_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_13_3_phi_fu_3921_p32 = wi_V_13_2_reg_2627.read();
    } else {
        ap_phi_mux_wi_V_13_3_phi_fu_3921_p32 = ap_phi_reg_pp3_iter2_wi_V_13_3_reg_3917.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_14_3_phi_fu_3866_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E))) {
        ap_phi_mux_wi_V_14_3_phi_fu_3866_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_14_3_phi_fu_3866_p32 = wi_V_14_2_reg_2617.read();
    } else {
        ap_phi_mux_wi_V_14_3_phi_fu_3866_p32 = ap_phi_reg_pp3_iter2_wi_V_14_3_reg_3862.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_15_3_phi_fu_3811_p32() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_15_3_phi_fu_3811_p32 = wi_V_15_2_reg_2607.read();
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_wi_V_15_3_phi_fu_3811_p32 = li_i_q0.read();
    } else {
        ap_phi_mux_wi_V_15_3_phi_fu_3811_p32 = ap_phi_reg_pp3_iter2_wi_V_15_3_reg_3807.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_1_3_phi_fu_4581_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1))) {
        ap_phi_mux_wi_V_1_3_phi_fu_4581_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_1_3_phi_fu_4581_p32 = wi_V_1_2_reg_2747.read();
    } else {
        ap_phi_mux_wi_V_1_3_phi_fu_4581_p32 = ap_phi_reg_pp3_iter2_wi_V_1_3_reg_4577.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_2_3_phi_fu_4526_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2))) {
        ap_phi_mux_wi_V_2_3_phi_fu_4526_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_2_3_phi_fu_4526_p32 = wi_V_2_2_reg_2737.read();
    } else {
        ap_phi_mux_wi_V_2_3_phi_fu_4526_p32 = ap_phi_reg_pp3_iter2_wi_V_2_3_reg_4522.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_3_3_phi_fu_4471_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3))) {
        ap_phi_mux_wi_V_3_3_phi_fu_4471_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_3_3_phi_fu_4471_p32 = wi_V_3_2_reg_2727.read();
    } else {
        ap_phi_mux_wi_V_3_3_phi_fu_4471_p32 = ap_phi_reg_pp3_iter2_wi_V_3_3_reg_4467.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_4_3_phi_fu_4416_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4))) {
        ap_phi_mux_wi_V_4_3_phi_fu_4416_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_4_3_phi_fu_4416_p32 = wi_V_4_2_reg_2717.read();
    } else {
        ap_phi_mux_wi_V_4_3_phi_fu_4416_p32 = ap_phi_reg_pp3_iter2_wi_V_4_3_reg_4412.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_5_3_phi_fu_4361_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5))) {
        ap_phi_mux_wi_V_5_3_phi_fu_4361_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_5_3_phi_fu_4361_p32 = wi_V_5_2_reg_2707.read();
    } else {
        ap_phi_mux_wi_V_5_3_phi_fu_4361_p32 = ap_phi_reg_pp3_iter2_wi_V_5_3_reg_4357.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_6_3_phi_fu_4306_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6))) {
        ap_phi_mux_wi_V_6_3_phi_fu_4306_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_6_3_phi_fu_4306_p32 = wi_V_6_2_reg_2697.read();
    } else {
        ap_phi_mux_wi_V_6_3_phi_fu_4306_p32 = ap_phi_reg_pp3_iter2_wi_V_6_3_reg_4302.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_7_3_phi_fu_4251_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7))) {
        ap_phi_mux_wi_V_7_3_phi_fu_4251_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_7_3_phi_fu_4251_p32 = wi_V_7_2_reg_2687.read();
    } else {
        ap_phi_mux_wi_V_7_3_phi_fu_4251_p32 = ap_phi_reg_pp3_iter2_wi_V_7_3_reg_4247.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_8_3_phi_fu_4196_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8))) {
        ap_phi_mux_wi_V_8_3_phi_fu_4196_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_8_3_phi_fu_4196_p32 = wi_V_8_2_reg_2677.read();
    } else {
        ap_phi_mux_wi_V_8_3_phi_fu_4196_p32 = ap_phi_reg_pp3_iter2_wi_V_8_3_reg_4192.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wi_V_9_3_phi_fu_4141_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9))) {
        ap_phi_mux_wi_V_9_3_phi_fu_4141_p32 = li_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wi_V_9_3_phi_fu_4141_p32 = wi_V_9_2_reg_2667.read();
    } else {
        ap_phi_mux_wi_V_9_3_phi_fu_4141_p32 = ap_phi_reg_pp3_iter2_wi_V_9_3_reg_4137.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wli_V_0_3_phi_fu_6311_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0))) {
        ap_phi_mux_wli_V_0_3_phi_fu_6311_p16 = li_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)))) {
        ap_phi_mux_wli_V_0_3_phi_fu_6311_p16 = wli_V_0_2_reg_5752.read();
    } else {
        ap_phi_mux_wli_V_0_3_phi_fu_6311_p16 = ap_phi_reg_pp6_iter3_wli_V_0_3_reg_6307.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wli_V_1_3_phi_fu_6280_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1))) {
        ap_phi_mux_wli_V_1_3_phi_fu_6280_p16 = li_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wli_V_1_3_phi_fu_6280_p16 = wli_V_1_2_reg_5742.read();
    } else {
        ap_phi_mux_wli_V_1_3_phi_fu_6280_p16 = ap_phi_reg_pp6_iter3_wli_V_1_3_reg_6276.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wli_V_2_3_phi_fu_6249_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2))) {
        ap_phi_mux_wli_V_2_3_phi_fu_6249_p16 = li_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wli_V_2_3_phi_fu_6249_p16 = wli_V_2_2_reg_5732.read();
    } else {
        ap_phi_mux_wli_V_2_3_phi_fu_6249_p16 = ap_phi_reg_pp6_iter3_wli_V_2_3_reg_6245.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wli_V_3_3_phi_fu_6218_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3))) {
        ap_phi_mux_wli_V_3_3_phi_fu_6218_p16 = li_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wli_V_3_3_phi_fu_6218_p16 = wli_V_3_2_reg_5722.read();
    } else {
        ap_phi_mux_wli_V_3_3_phi_fu_6218_p16 = ap_phi_reg_pp6_iter3_wli_V_3_3_reg_6214.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wli_V_4_3_phi_fu_6187_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4))) {
        ap_phi_mux_wli_V_4_3_phi_fu_6187_p16 = li_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wli_V_4_3_phi_fu_6187_p16 = wli_V_4_2_reg_5712.read();
    } else {
        ap_phi_mux_wli_V_4_3_phi_fu_6187_p16 = ap_phi_reg_pp6_iter3_wli_V_4_3_reg_6183.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wli_V_5_3_phi_fu_6156_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5))) {
        ap_phi_mux_wli_V_5_3_phi_fu_6156_p16 = li_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wli_V_5_3_phi_fu_6156_p16 = wli_V_5_2_reg_5702.read();
    } else {
        ap_phi_mux_wli_V_5_3_phi_fu_6156_p16 = ap_phi_reg_pp6_iter3_wli_V_5_3_reg_6152.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wli_V_6_3_phi_fu_6125_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6))) {
        ap_phi_mux_wli_V_6_3_phi_fu_6125_p16 = li_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wli_V_6_3_phi_fu_6125_p16 = wli_V_6_2_reg_5692.read();
    } else {
        ap_phi_mux_wli_V_6_3_phi_fu_6125_p16 = ap_phi_reg_pp6_iter3_wli_V_6_3_reg_6121.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wli_V_7_3_phi_fu_6094_p16() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wli_V_7_3_phi_fu_6094_p16 = wli_V_7_2_reg_5682.read();
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_wli_V_7_3_phi_fu_6094_p16 = li_i_q1.read();
    } else {
        ap_phi_mux_wli_V_7_3_phi_fu_6094_p16 = ap_phi_reg_pp6_iter3_wli_V_7_3_reg_6090.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wlr_V_0_3_phi_fu_6063_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0))) {
        ap_phi_mux_wlr_V_0_3_phi_fu_6063_p16 = lr_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)))) {
        ap_phi_mux_wlr_V_0_3_phi_fu_6063_p16 = wlr_V_0_2_reg_5832.read();
    } else {
        ap_phi_mux_wlr_V_0_3_phi_fu_6063_p16 = ap_phi_reg_pp6_iter3_wlr_V_0_3_reg_6059.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wlr_V_1_3_phi_fu_6032_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1))) {
        ap_phi_mux_wlr_V_1_3_phi_fu_6032_p16 = lr_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wlr_V_1_3_phi_fu_6032_p16 = wlr_V_1_2_reg_5822.read();
    } else {
        ap_phi_mux_wlr_V_1_3_phi_fu_6032_p16 = ap_phi_reg_pp6_iter3_wlr_V_1_3_reg_6028.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wlr_V_2_3_phi_fu_6001_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2))) {
        ap_phi_mux_wlr_V_2_3_phi_fu_6001_p16 = lr_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wlr_V_2_3_phi_fu_6001_p16 = wlr_V_2_2_reg_5812.read();
    } else {
        ap_phi_mux_wlr_V_2_3_phi_fu_6001_p16 = ap_phi_reg_pp6_iter3_wlr_V_2_3_reg_5997.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wlr_V_3_3_phi_fu_5970_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3))) {
        ap_phi_mux_wlr_V_3_3_phi_fu_5970_p16 = lr_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wlr_V_3_3_phi_fu_5970_p16 = wlr_V_3_2_reg_5802.read();
    } else {
        ap_phi_mux_wlr_V_3_3_phi_fu_5970_p16 = ap_phi_reg_pp6_iter3_wlr_V_3_3_reg_5966.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wlr_V_4_3_phi_fu_5939_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4))) {
        ap_phi_mux_wlr_V_4_3_phi_fu_5939_p16 = lr_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wlr_V_4_3_phi_fu_5939_p16 = wlr_V_4_2_reg_5792.read();
    } else {
        ap_phi_mux_wlr_V_4_3_phi_fu_5939_p16 = ap_phi_reg_pp6_iter3_wlr_V_4_3_reg_5935.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wlr_V_5_3_phi_fu_5908_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5))) {
        ap_phi_mux_wlr_V_5_3_phi_fu_5908_p16 = lr_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wlr_V_5_3_phi_fu_5908_p16 = wlr_V_5_2_reg_5782.read();
    } else {
        ap_phi_mux_wlr_V_5_3_phi_fu_5908_p16 = ap_phi_reg_pp6_iter3_wlr_V_5_3_reg_5904.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wlr_V_6_3_phi_fu_5877_p16() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6))) {
        ap_phi_mux_wlr_V_6_3_phi_fu_5877_p16 = lr_i_q1.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wlr_V_6_3_phi_fu_5877_p16 = wlr_V_6_2_reg_5772.read();
    } else {
        ap_phi_mux_wlr_V_6_3_phi_fu_5877_p16 = ap_phi_reg_pp6_iter3_wlr_V_6_3_reg_5873.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wlr_V_7_3_phi_fu_5846_p16() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_6)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_5)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_4)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_3)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_2)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_1)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_0)))) {
        ap_phi_mux_wlr_V_7_3_phi_fu_5846_p16 = wlr_V_7_2_reg_5762.read();
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter3.read()) && 
                esl_seteq<1,1,1>(ap_const_lv1_0, exitcond1587_i_i_i_reg_18244_pp6_iter2_reg.read()) && 
                esl_seteq<1,3,3>(tmp_77_reg_18258_pp6_iter2_reg.read(), ap_const_lv3_7) && 
                esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_wlr_V_7_3_phi_fu_5846_p16 = lr_i_q1.read();
    } else {
        ap_phi_mux_wlr_V_7_3_phi_fu_5846_p16 = ap_phi_reg_pp6_iter3_wlr_V_7_3_reg_5842.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_0_3_phi_fu_3756_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0))) {
        ap_phi_mux_wr_V_0_3_phi_fu_3756_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)))) {
        ap_phi_mux_wr_V_0_3_phi_fu_3756_p32 = wr_V_0_2_reg_2917.read();
    } else {
        ap_phi_mux_wr_V_0_3_phi_fu_3756_p32 = ap_phi_reg_pp3_iter2_wr_V_0_3_reg_3752.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_10_3_phi_fu_3206_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A))) {
        ap_phi_mux_wr_V_10_3_phi_fu_3206_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_10_3_phi_fu_3206_p32 = wr_V_10_2_reg_2817.read();
    } else {
        ap_phi_mux_wr_V_10_3_phi_fu_3206_p32 = ap_phi_reg_pp3_iter2_wr_V_10_3_reg_3202.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_11_3_phi_fu_3151_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B))) {
        ap_phi_mux_wr_V_11_3_phi_fu_3151_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_11_3_phi_fu_3151_p32 = wr_V_11_2_reg_2807.read();
    } else {
        ap_phi_mux_wr_V_11_3_phi_fu_3151_p32 = ap_phi_reg_pp3_iter2_wr_V_11_3_reg_3147.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_12_3_phi_fu_3096_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C))) {
        ap_phi_mux_wr_V_12_3_phi_fu_3096_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_12_3_phi_fu_3096_p32 = wr_V_12_2_reg_2797.read();
    } else {
        ap_phi_mux_wr_V_12_3_phi_fu_3096_p32 = ap_phi_reg_pp3_iter2_wr_V_12_3_reg_3092.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_13_3_phi_fu_3041_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D))) {
        ap_phi_mux_wr_V_13_3_phi_fu_3041_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_13_3_phi_fu_3041_p32 = wr_V_13_2_reg_2787.read();
    } else {
        ap_phi_mux_wr_V_13_3_phi_fu_3041_p32 = ap_phi_reg_pp3_iter2_wr_V_13_3_reg_3037.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_14_3_phi_fu_2986_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E))) {
        ap_phi_mux_wr_V_14_3_phi_fu_2986_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_14_3_phi_fu_2986_p32 = wr_V_14_2_reg_2777.read();
    } else {
        ap_phi_mux_wr_V_14_3_phi_fu_2986_p32 = ap_phi_reg_pp3_iter2_wr_V_14_3_reg_2982.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_15_3_phi_fu_2931_p32() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_15_3_phi_fu_2931_p32 = wr_V_15_2_reg_2767.read();
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0))) {
        ap_phi_mux_wr_V_15_3_phi_fu_2931_p32 = lr_i_q0.read();
    } else {
        ap_phi_mux_wr_V_15_3_phi_fu_2931_p32 = ap_phi_reg_pp3_iter2_wr_V_15_3_reg_2927.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_1_3_phi_fu_3701_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1))) {
        ap_phi_mux_wr_V_1_3_phi_fu_3701_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_1_3_phi_fu_3701_p32 = wr_V_1_2_reg_2907.read();
    } else {
        ap_phi_mux_wr_V_1_3_phi_fu_3701_p32 = ap_phi_reg_pp3_iter2_wr_V_1_3_reg_3697.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_2_3_phi_fu_3646_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2))) {
        ap_phi_mux_wr_V_2_3_phi_fu_3646_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_2_3_phi_fu_3646_p32 = wr_V_2_2_reg_2897.read();
    } else {
        ap_phi_mux_wr_V_2_3_phi_fu_3646_p32 = ap_phi_reg_pp3_iter2_wr_V_2_3_reg_3642.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_3_3_phi_fu_3591_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3))) {
        ap_phi_mux_wr_V_3_3_phi_fu_3591_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_3_3_phi_fu_3591_p32 = wr_V_3_2_reg_2887.read();
    } else {
        ap_phi_mux_wr_V_3_3_phi_fu_3591_p32 = ap_phi_reg_pp3_iter2_wr_V_3_3_reg_3587.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_4_3_phi_fu_3536_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4))) {
        ap_phi_mux_wr_V_4_3_phi_fu_3536_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_4_3_phi_fu_3536_p32 = wr_V_4_2_reg_2877.read();
    } else {
        ap_phi_mux_wr_V_4_3_phi_fu_3536_p32 = ap_phi_reg_pp3_iter2_wr_V_4_3_reg_3532.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_5_3_phi_fu_3481_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5))) {
        ap_phi_mux_wr_V_5_3_phi_fu_3481_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_5_3_phi_fu_3481_p32 = wr_V_5_2_reg_2867.read();
    } else {
        ap_phi_mux_wr_V_5_3_phi_fu_3481_p32 = ap_phi_reg_pp3_iter2_wr_V_5_3_reg_3477.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_6_3_phi_fu_3426_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6))) {
        ap_phi_mux_wr_V_6_3_phi_fu_3426_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_6_3_phi_fu_3426_p32 = wr_V_6_2_reg_2857.read();
    } else {
        ap_phi_mux_wr_V_6_3_phi_fu_3426_p32 = ap_phi_reg_pp3_iter2_wr_V_6_3_reg_3422.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_7_3_phi_fu_3371_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7))) {
        ap_phi_mux_wr_V_7_3_phi_fu_3371_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_7_3_phi_fu_3371_p32 = wr_V_7_2_reg_2847.read();
    } else {
        ap_phi_mux_wr_V_7_3_phi_fu_3371_p32 = ap_phi_reg_pp3_iter2_wr_V_7_3_reg_3367.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_8_3_phi_fu_3316_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8))) {
        ap_phi_mux_wr_V_8_3_phi_fu_3316_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_8_3_phi_fu_3316_p32 = wr_V_8_2_reg_2837.read();
    } else {
        ap_phi_mux_wr_V_8_3_phi_fu_3316_p32 = ap_phi_reg_pp3_iter2_wr_V_8_3_reg_3312.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_mux_wr_V_9_3_phi_fu_3261_p32() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_9))) {
        ap_phi_mux_wr_V_9_3_phi_fu_3261_p32 = lr_i_q0.read();
    } else if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_F) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_E)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_D)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_C)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_B)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_A)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_8)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_7)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_6)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_5)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_4)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_3)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_2)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_1)) || 
                (esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter2.read()) && 
                 esl_seteq<1,1,1>(ap_const_lv1_0, exitcond803_i_i_i_reg_17408_pp3_iter1_reg.read()) && 
                 esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                 esl_seteq<1,4,4>(tmp_46_reg_17422_pp3_iter1_reg.read(), ap_const_lv4_0)))) {
        ap_phi_mux_wr_V_9_3_phi_fu_3261_p32 = wr_V_9_2_reg_2827.read();
    } else {
        ap_phi_mux_wr_V_9_3_phi_fu_3261_p32 = ap_phi_reg_pp3_iter2_wr_V_9_3_reg_3257.read();
    }
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp0_iter0_p_Val2_1_reg_2550() {
    ap_phi_reg_pp0_iter0_p_Val2_1_reg_2550 =  (sc_lv<33>) ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp0_iter1_p_047_1_i_reg_2538() {
    ap_phi_reg_pp0_iter1_p_047_1_i_reg_2538 =  (sc_lv<1>) ("X");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_0_3_reg_4632() {
    ap_phi_reg_pp3_iter2_wi_V_0_3_reg_4632 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_10_3_reg_4082() {
    ap_phi_reg_pp3_iter2_wi_V_10_3_reg_4082 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_11_3_reg_4027() {
    ap_phi_reg_pp3_iter2_wi_V_11_3_reg_4027 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_12_3_reg_3972() {
    ap_phi_reg_pp3_iter2_wi_V_12_3_reg_3972 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_13_3_reg_3917() {
    ap_phi_reg_pp3_iter2_wi_V_13_3_reg_3917 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_14_3_reg_3862() {
    ap_phi_reg_pp3_iter2_wi_V_14_3_reg_3862 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_15_3_reg_3807() {
    ap_phi_reg_pp3_iter2_wi_V_15_3_reg_3807 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_1_3_reg_4577() {
    ap_phi_reg_pp3_iter2_wi_V_1_3_reg_4577 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_2_3_reg_4522() {
    ap_phi_reg_pp3_iter2_wi_V_2_3_reg_4522 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_3_3_reg_4467() {
    ap_phi_reg_pp3_iter2_wi_V_3_3_reg_4467 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_4_3_reg_4412() {
    ap_phi_reg_pp3_iter2_wi_V_4_3_reg_4412 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_5_3_reg_4357() {
    ap_phi_reg_pp3_iter2_wi_V_5_3_reg_4357 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_6_3_reg_4302() {
    ap_phi_reg_pp3_iter2_wi_V_6_3_reg_4302 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_7_3_reg_4247() {
    ap_phi_reg_pp3_iter2_wi_V_7_3_reg_4247 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_8_3_reg_4192() {
    ap_phi_reg_pp3_iter2_wi_V_8_3_reg_4192 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wi_V_9_3_reg_4137() {
    ap_phi_reg_pp3_iter2_wi_V_9_3_reg_4137 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_0_3_reg_3752() {
    ap_phi_reg_pp3_iter2_wr_V_0_3_reg_3752 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_10_3_reg_3202() {
    ap_phi_reg_pp3_iter2_wr_V_10_3_reg_3202 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_11_3_reg_3147() {
    ap_phi_reg_pp3_iter2_wr_V_11_3_reg_3147 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_12_3_reg_3092() {
    ap_phi_reg_pp3_iter2_wr_V_12_3_reg_3092 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_13_3_reg_3037() {
    ap_phi_reg_pp3_iter2_wr_V_13_3_reg_3037 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_14_3_reg_2982() {
    ap_phi_reg_pp3_iter2_wr_V_14_3_reg_2982 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_15_3_reg_2927() {
    ap_phi_reg_pp3_iter2_wr_V_15_3_reg_2927 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_1_3_reg_3697() {
    ap_phi_reg_pp3_iter2_wr_V_1_3_reg_3697 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_2_3_reg_3642() {
    ap_phi_reg_pp3_iter2_wr_V_2_3_reg_3642 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_3_3_reg_3587() {
    ap_phi_reg_pp3_iter2_wr_V_3_3_reg_3587 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_4_3_reg_3532() {
    ap_phi_reg_pp3_iter2_wr_V_4_3_reg_3532 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_5_3_reg_3477() {
    ap_phi_reg_pp3_iter2_wr_V_5_3_reg_3477 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_6_3_reg_3422() {
    ap_phi_reg_pp3_iter2_wr_V_6_3_reg_3422 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_7_3_reg_3367() {
    ap_phi_reg_pp3_iter2_wr_V_7_3_reg_3367 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_8_3_reg_3312() {
    ap_phi_reg_pp3_iter2_wr_V_8_3_reg_3312 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp3_iter2_wr_V_9_3_reg_3257() {
    ap_phi_reg_pp3_iter2_wr_V_9_3_reg_3257 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp4_iter0_w0r_V_0_phi_reg_5474() {
    ap_phi_reg_pp4_iter0_w0r_V_0_phi_reg_5474 =  (sc_lv<16>) ("XXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whi_V_0_3_reg_6803() {
    ap_phi_reg_pp6_iter3_whi_V_0_3_reg_6803 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whi_V_1_3_reg_6772() {
    ap_phi_reg_pp6_iter3_whi_V_1_3_reg_6772 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whi_V_2_3_reg_6741() {
    ap_phi_reg_pp6_iter3_whi_V_2_3_reg_6741 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whi_V_3_3_reg_6710() {
    ap_phi_reg_pp6_iter3_whi_V_3_3_reg_6710 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whi_V_4_3_reg_6679() {
    ap_phi_reg_pp6_iter3_whi_V_4_3_reg_6679 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whi_V_5_3_reg_6648() {
    ap_phi_reg_pp6_iter3_whi_V_5_3_reg_6648 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whi_V_6_3_reg_6617() {
    ap_phi_reg_pp6_iter3_whi_V_6_3_reg_6617 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whi_V_7_3_reg_6586() {
    ap_phi_reg_pp6_iter3_whi_V_7_3_reg_6586 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whr_V_0_3_reg_6555() {
    ap_phi_reg_pp6_iter3_whr_V_0_3_reg_6555 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whr_V_1_3_reg_6524() {
    ap_phi_reg_pp6_iter3_whr_V_1_3_reg_6524 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whr_V_2_3_reg_6493() {
    ap_phi_reg_pp6_iter3_whr_V_2_3_reg_6493 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whr_V_3_3_reg_6462() {
    ap_phi_reg_pp6_iter3_whr_V_3_3_reg_6462 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whr_V_4_3_reg_6431() {
    ap_phi_reg_pp6_iter3_whr_V_4_3_reg_6431 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whr_V_5_3_reg_6400() {
    ap_phi_reg_pp6_iter3_whr_V_5_3_reg_6400 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whr_V_6_3_reg_6369() {
    ap_phi_reg_pp6_iter3_whr_V_6_3_reg_6369 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_whr_V_7_3_reg_6338() {
    ap_phi_reg_pp6_iter3_whr_V_7_3_reg_6338 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wli_V_0_3_reg_6307() {
    ap_phi_reg_pp6_iter3_wli_V_0_3_reg_6307 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wli_V_1_3_reg_6276() {
    ap_phi_reg_pp6_iter3_wli_V_1_3_reg_6276 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wli_V_2_3_reg_6245() {
    ap_phi_reg_pp6_iter3_wli_V_2_3_reg_6245 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wli_V_3_3_reg_6214() {
    ap_phi_reg_pp6_iter3_wli_V_3_3_reg_6214 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wli_V_4_3_reg_6183() {
    ap_phi_reg_pp6_iter3_wli_V_4_3_reg_6183 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wli_V_5_3_reg_6152() {
    ap_phi_reg_pp6_iter3_wli_V_5_3_reg_6152 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wli_V_6_3_reg_6121() {
    ap_phi_reg_pp6_iter3_wli_V_6_3_reg_6121 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wli_V_7_3_reg_6090() {
    ap_phi_reg_pp6_iter3_wli_V_7_3_reg_6090 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wlr_V_0_3_reg_6059() {
    ap_phi_reg_pp6_iter3_wlr_V_0_3_reg_6059 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wlr_V_1_3_reg_6028() {
    ap_phi_reg_pp6_iter3_wlr_V_1_3_reg_6028 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wlr_V_2_3_reg_5997() {
    ap_phi_reg_pp6_iter3_wlr_V_2_3_reg_5997 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wlr_V_3_3_reg_5966() {
    ap_phi_reg_pp6_iter3_wlr_V_3_3_reg_5966 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wlr_V_4_3_reg_5935() {
    ap_phi_reg_pp6_iter3_wlr_V_4_3_reg_5935 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wlr_V_5_3_reg_5904() {
    ap_phi_reg_pp6_iter3_wlr_V_5_3_reg_5904 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wlr_V_6_3_reg_5873() {
    ap_phi_reg_pp6_iter3_wlr_V_6_3_reg_5873 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp6_iter3_wlr_V_7_3_reg_5842() {
    ap_phi_reg_pp6_iter3_wlr_V_7_3_reg_5842 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_phi_reg_pp7_iter0_s0rE_V_0_phi_reg_7621() {
    ap_phi_reg_pp7_iter0_s0rE_V_0_phi_reg_7621 =  (sc_lv<16>) ("XXXXXXXXXXXXXXXX");
}

void LcwtMLP_RFFI::thread_ap_predicate_op305_read_state4() {
    ap_predicate_op305_read_state4 = (esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_i_reg_17059.read()) && esl_seteq<1,1,1>(ap_const_lv1_0, ap_phi_mux_p_047_0_i_phi_fu_2530_p4.read()));
}

void LcwtMLP_RFFI::thread_ap_ready() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state2.read()) && 
         !(esl_seteq<1,1,1>(ap_const_logic_0, dout_V_data_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_keep_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_strb_V_1_ack_in.read()) || esl_seteq<1,1,1>(ap_const_logic_0, dout_V_last_V_1_ack_in.read())) && 
         esl_seteq<1,1,1>(ap_const_logic_0, dout_V_data_V_1_state.read()[0]) && 
         esl_seteq<1,1,1>(ap_const_logic_0, dout_V_keep_V_1_state.read()[0]) && 
         esl_seteq<1,1,1>(ap_const_logic_0, dout_V_strb_V_1_state.read()[0]) && 
         esl_seteq<1,1,1>(ap_const_logic_0, dout_V_last_V_1_state.read()[0]) && 
         esl_seteq<1,1,1>(ap_const_lv1_1, exitcond_fu_8550_p2.read()))) {
        ap_ready = ap_const_logic_1;
    } else {
        ap_ready = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_ap_rst_n_inv() {
    ap_rst_n_inv =  (sc_logic) (~ap_rst_n.read());
}

void LcwtMLP_RFFI::thread_b_last_V_fu_14624_p2() {
    b_last_V_fu_14624_p2 = (tmp_34_mid2_fu_14578_p3.read() & tmp_64_fu_14618_p2.read());
}

void LcwtMLP_RFFI::thread_d_fu_14451_p2() {
    d_fu_14451_p2 = (!d7_0_i_i_i_reg_8506.read().is_01() || !ap_const_lv6_1.is_01())? sc_lv<6>(): (sc_biguint<6>(d7_0_i_i_i_reg_8506.read()) + sc_biguint<6>(ap_const_lv6_1));
}

void LcwtMLP_RFFI::thread_din_V_V_blk_n() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp0_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp0_stage0.read(), ap_const_boolean_0) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_i_reg_17059.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, ap_phi_mux_p_047_0_i_phi_fu_2530_p4.read()))) {
        din_V_V_blk_n = din_V_V_empty_n.read();
    } else {
        din_V_V_blk_n = ap_const_logic_1;
    }
}

void LcwtMLP_RFFI::thread_din_V_V_read() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp0_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp0_iter1.read()) && 
         esl_seteq<1,1,1>(ap_const_boolean_1, ap_predicate_op305_read_state4.read()) && 
         esl_seteq<1,1,1>(ap_block_pp0_stage0_11001.read(), ap_const_boolean_0))) {
        din_V_V_read = ap_const_logic_1;
    } else {
        din_V_V_read = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_dout_TDATA() {
    dout_TDATA = dout_V_data_V_1_data_out.read();
}

void LcwtMLP_RFFI::thread_dout_TDATA_blk_n() {
    if (((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter4.read()) && 
          esl_seteq<1,1,1>(ap_block_pp11_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522_pp11_iter3_reg.read())) || 
         (esl_seteq<1,1,1>(ap_block_pp11_stage0.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter5.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522_pp11_iter4_reg.read())))) {
        dout_TDATA_blk_n = dout_V_data_V_1_state.read()[1];
    } else {
        dout_TDATA_blk_n = ap_const_logic_1;
    }
}

void LcwtMLP_RFFI::thread_dout_TKEEP() {
    dout_TKEEP = dout_V_keep_V_1_data_out.read();
}

void LcwtMLP_RFFI::thread_dout_TLAST() {
    dout_TLAST = dout_V_last_V_1_data_out.read();
}

void LcwtMLP_RFFI::thread_dout_TSTRB() {
    dout_TSTRB = dout_V_strb_V_1_data_out.read();
}

void LcwtMLP_RFFI::thread_dout_TVALID() {
    dout_TVALID = dout_V_last_V_1_state.read()[0];
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_ack_in() {
    dout_V_data_V_1_ack_in = dout_V_data_V_1_state.read()[1];
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_ack_out() {
    dout_V_data_V_1_ack_out = dout_TREADY.read();
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_data_out() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, dout_V_data_V_1_sel.read())) {
        dout_V_data_V_1_data_out = dout_V_data_V_1_payload_B.read();
    } else {
        dout_V_data_V_1_data_out = dout_V_data_V_1_payload_A.read();
    }
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_load_A() {
    dout_V_data_V_1_load_A = (dout_V_data_V_1_state_cmp_full.read() & ~dout_V_data_V_1_sel_wr.read());
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_load_B() {
    dout_V_data_V_1_load_B = (dout_V_data_V_1_sel_wr.read() & dout_V_data_V_1_state_cmp_full.read());
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_sel() {
    dout_V_data_V_1_sel = dout_V_data_V_1_sel_rd.read();
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_state_cmp_full() {
    dout_V_data_V_1_state_cmp_full =  (sc_logic) ((!dout_V_data_V_1_state.read().is_01() || !ap_const_lv2_1.is_01())? sc_lv<1>(): sc_lv<1>(dout_V_data_V_1_state.read() != ap_const_lv2_1))[0];
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_vld_in() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter4.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522_pp11_iter3_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp11_stage0_11001.read(), ap_const_boolean_0))) {
        dout_V_data_V_1_vld_in = ap_const_logic_1;
    } else {
        dout_V_data_V_1_vld_in = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_dout_V_data_V_1_vld_out() {
    dout_V_data_V_1_vld_out = dout_V_data_V_1_state.read()[0];
}

void LcwtMLP_RFFI::thread_dout_V_keep_V_1_ack_in() {
    dout_V_keep_V_1_ack_in = dout_V_keep_V_1_state.read()[1];
}

void LcwtMLP_RFFI::thread_dout_V_keep_V_1_ack_out() {
    dout_V_keep_V_1_ack_out = dout_TREADY.read();
}

void LcwtMLP_RFFI::thread_dout_V_keep_V_1_data_out() {
    dout_V_keep_V_1_data_out = ap_const_lv4_F;
}

void LcwtMLP_RFFI::thread_dout_V_keep_V_1_sel() {
    dout_V_keep_V_1_sel = dout_V_keep_V_1_sel_rd.read();
}

void LcwtMLP_RFFI::thread_dout_V_keep_V_1_vld_in() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter4.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522_pp11_iter3_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp11_stage0_11001.read(), ap_const_boolean_0))) {
        dout_V_keep_V_1_vld_in = ap_const_logic_1;
    } else {
        dout_V_keep_V_1_vld_in = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_dout_V_keep_V_1_vld_out() {
    dout_V_keep_V_1_vld_out = dout_V_keep_V_1_state.read()[0];
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_ack_in() {
    dout_V_last_V_1_ack_in = dout_V_last_V_1_state.read()[1];
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_ack_out() {
    dout_V_last_V_1_ack_out = dout_TREADY.read();
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_data_out() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, dout_V_last_V_1_sel.read())) {
        dout_V_last_V_1_data_out = dout_V_last_V_1_payload_B.read();
    } else {
        dout_V_last_V_1_data_out = dout_V_last_V_1_payload_A.read();
    }
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_load_A() {
    dout_V_last_V_1_load_A = (dout_V_last_V_1_state_cmp_full.read() & ~dout_V_last_V_1_sel_wr.read());
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_load_B() {
    dout_V_last_V_1_load_B = (dout_V_last_V_1_sel_wr.read() & dout_V_last_V_1_state_cmp_full.read());
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_sel() {
    dout_V_last_V_1_sel = dout_V_last_V_1_sel_rd.read();
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_state_cmp_full() {
    dout_V_last_V_1_state_cmp_full =  (sc_logic) ((!dout_V_last_V_1_state.read().is_01() || !ap_const_lv2_1.is_01())? sc_lv<1>(): sc_lv<1>(dout_V_last_V_1_state.read() != ap_const_lv2_1))[0];
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_vld_in() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter4.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522_pp11_iter3_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp11_stage0_11001.read(), ap_const_boolean_0))) {
        dout_V_last_V_1_vld_in = ap_const_logic_1;
    } else {
        dout_V_last_V_1_vld_in = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_dout_V_last_V_1_vld_out() {
    dout_V_last_V_1_vld_out = dout_V_last_V_1_state.read()[0];
}

void LcwtMLP_RFFI::thread_dout_V_strb_V_1_ack_in() {
    dout_V_strb_V_1_ack_in = dout_V_strb_V_1_state.read()[1];
}

void LcwtMLP_RFFI::thread_dout_V_strb_V_1_ack_out() {
    dout_V_strb_V_1_ack_out = dout_TREADY.read();
}

void LcwtMLP_RFFI::thread_dout_V_strb_V_1_data_out() {
    dout_V_strb_V_1_data_out = ap_const_lv4_F;
}

void LcwtMLP_RFFI::thread_dout_V_strb_V_1_sel() {
    dout_V_strb_V_1_sel = dout_V_strb_V_1_sel_rd.read();
}

void LcwtMLP_RFFI::thread_dout_V_strb_V_1_vld_in() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp11_iter4.read()) && 
         esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_flatten_reg_20522_pp11_iter3_reg.read()) && 
         esl_seteq<1,1,1>(ap_block_pp11_stage0_11001.read(), ap_const_boolean_0))) {
        dout_V_strb_V_1_vld_in = ap_const_logic_1;
    } else {
        dout_V_strb_V_1_vld_in = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_dout_V_strb_V_1_vld_out() {
    dout_V_strb_V_1_vld_out = dout_V_strb_V_1_state.read()[0];
}

void LcwtMLP_RFFI::thread_exitcond132_i_i_i_fu_13441_p2() {
    exitcond132_i_i_i_fu_13441_p2 = (!i3_0_i_i_i_reg_8495.read().is_01() || !ap_const_lv5_10.is_01())? sc_lv<1>(): sc_lv<1>(i3_0_i_i_i_reg_8495.read() == ap_const_lv5_10);
}

void LcwtMLP_RFFI::thread_exitcond134_i_i_i_fu_13062_p2() {
    exitcond134_i_i_i_fu_13062_p2 = (!ap_phi_mux_i_0_i_i_i_phi_fu_8106_p4.read().is_01() || !ap_const_lv5_10.is_01())? sc_lv<1>(): sc_lv<1>(ap_phi_mux_i_0_i_i_i_phi_fu_8106_p4.read() == ap_const_lv5_10);
}

void LcwtMLP_RFFI::thread_exitcond136_i_i_i_fu_13038_p2() {
    exitcond136_i_i_i_fu_13038_p2 = (!t_0_i57_i_i_reg_7634.read().is_01() || !ap_const_lv5_10.is_01())? sc_lv<1>(): sc_lv<1>(t_0_i57_i_i_reg_7634.read() == ap_const_lv5_10);
}

void LcwtMLP_RFFI::thread_exitcond1584_i_i_i_fu_11529_p2() {
    exitcond1584_i_i_i_fu_11529_p2 = (!m_0_i52_i_i_reg_7610.read().is_01() || !ap_const_lv3_4.is_01())? sc_lv<1>(): sc_lv<1>(m_0_i52_i_i_reg_7610.read() == ap_const_lv3_4);
}

void LcwtMLP_RFFI::thread_exitcond1587_i_i_i_fu_11285_p2() {
    exitcond1587_i_i_i_fu_11285_p2 = (!j_0_i47_i_i_reg_5511.read().is_01() || !ap_const_lv4_8.is_01())? sc_lv<1>(): sc_lv<1>(j_0_i47_i_i_reg_5511.read() == ap_const_lv4_8);
}

void LcwtMLP_RFFI::thread_exitcond1590_i_i_i_fu_10854_p2() {
    exitcond1590_i_i_i_fu_10854_p2 = (!ap_phi_mux_k_0_i44_i_i_phi_fu_5503_p4.read().is_01() || !ap_const_lv5_10.is_01())? sc_lv<1>(): sc_lv<1>(ap_phi_mux_k_0_i44_i_i_phi_fu_5503_p4.read() == ap_const_lv5_10);
}

void LcwtMLP_RFFI::thread_exitcond2_fu_9318_p2() {
    exitcond2_fu_9318_p2 = (!t_0_i_i_i_reg_5067.read().is_01() || !tmp_13_reg_17291.read().is_01())? sc_lv<1>(): sc_lv<1>(t_0_i_i_i_reg_5067.read() == tmp_13_reg_17291.read());
}

void LcwtMLP_RFFI::thread_exitcond800_i_i_i_fu_9497_p2() {
    exitcond800_i_i_i_fu_9497_p2 = (!m_0_i_i_i_reg_5463.read().is_01() || !ap_const_lv3_4.is_01())? sc_lv<1>(): sc_lv<1>(m_0_i_i_i_reg_5463.read() == ap_const_lv3_4);
}

void LcwtMLP_RFFI::thread_exitcond803_i_i_i_fu_9268_p2() {
    exitcond803_i_i_i_fu_9268_p2 = (!k9_0_i_i_i_reg_2596.read().is_01() || !ap_const_lv5_10.is_01())? sc_lv<1>(): sc_lv<1>(k9_0_i_i_i_reg_2596.read() == ap_const_lv5_10);
}

void LcwtMLP_RFFI::thread_exitcond806_i_i_i_fu_8837_p2() {
    exitcond806_i_i_i_fu_8837_p2 = (!ap_phi_mux_k_0_i_i_i_phi_fu_2588_p4.read().is_01() || !ap_const_lv5_10.is_01())? sc_lv<1>(): sc_lv<1>(ap_phi_mux_k_0_i_i_i_phi_fu_2588_p4.read() == ap_const_lv5_10);
}

void LcwtMLP_RFFI::thread_exitcond807_i_i_i_fu_8727_p2() {
    exitcond807_i_i_i_fu_8727_p2 = (!lv_0_i_i_i_reg_2572.read().is_01() || !ap_const_lv3_4.is_01())? sc_lv<1>(): sc_lv<1>(lv_0_i_i_i_reg_2572.read() == ap_const_lv3_4);
}

void LcwtMLP_RFFI::thread_exitcond_flatten_fu_14522_p2() {
    exitcond_flatten_fu_14522_p2 = (!indvar_flatten_reg_8517.read().is_01() || !ap_const_lv9_130.is_01())? sc_lv<1>(): sc_lv<1>(indvar_flatten_reg_8517.read() == ap_const_lv9_130);
}

void LcwtMLP_RFFI::thread_exitcond_fu_8550_p2() {
    exitcond_fu_8550_p2 = (!f_reg_2503.read().is_01() || !ap_const_lv4_8.is_01())? sc_lv<1>(): sc_lv<1>(f_reg_2503.read() == ap_const_lv4_8);
}

void LcwtMLP_RFFI::thread_exitcond_i1_fu_14540_p2() {
    exitcond_i1_fu_14540_p2 = (!j_0_i_reg_8539.read().is_01() || !ap_const_lv5_13.is_01())? sc_lv<1>(): sc_lv<1>(j_0_i_reg_8539.read() == ap_const_lv5_13);
}

void LcwtMLP_RFFI::thread_exitcond_i61_i_i_fu_14445_p2() {
    exitcond_i61_i_i_fu_14445_p2 = (!d7_0_i_i_i_reg_8506.read().is_01() || !ap_const_lv6_26.is_01())? sc_lv<1>(): sc_lv<1>(d7_0_i_i_i_reg_8506.read() == ap_const_lv6_26);
}

void LcwtMLP_RFFI::thread_exitcond_i_fu_8562_p2() {
    exitcond_i_fu_8562_p2 = (!ap_phi_mux_i_0_i_phi_fu_2518_p4.read().is_01() || !ap_const_lv9_100.is_01())? sc_lv<1>(): sc_lv<1>(ap_phi_mux_i_0_i_phi_fu_2518_p4.read() == ap_const_lv9_100);
}

void LcwtMLP_RFFI::thread_exitcond_i_i_fu_8605_p2() {
    exitcond_i_i_fu_8605_p2 = (!i_0_i_i_reg_2561.read().is_01() || !ap_const_lv9_100.is_01())? sc_lv<1>(): sc_lv<1>(i_0_i_i_reg_2561.read() == ap_const_lv9_100);
}

void LcwtMLP_RFFI::thread_f_1_fu_8556_p2() {
    f_1_fu_8556_p2 = (!f_reg_2503.read().is_01() || !ap_const_lv4_1.is_01())? sc_lv<4>(): (sc_biguint<4>(f_reg_2503.read()) + sc_biguint<4>(ap_const_lv4_1));
}

void LcwtMLP_RFFI::thread_grp_fu_14778_p0() {
    grp_fu_14778_p0 =  (sc_lv<25>) (tmp_152_cast_fu_9895_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14778_p1() {
    grp_fu_14778_p1 =  (sc_lv<16>) (tmp_151_cast_fu_9891_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14786_p0() {
    grp_fu_14786_p0 =  (sc_lv<25>) (tmp_155_cast_fu_9903_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14786_p1() {
    grp_fu_14786_p1 =  (sc_lv<16>) (tmp_154_cast_fu_9899_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14794_p0() {
    grp_fu_14794_p0 =  (sc_lv<25>) (tmp_152_cast_fu_9895_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14794_p1() {
    grp_fu_14794_p1 =  (sc_lv<16>) (tmp_154_cast_fu_9899_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14802_p0() {
    grp_fu_14802_p0 =  (sc_lv<25>) (tmp_155_cast_fu_9903_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14802_p1() {
    grp_fu_14802_p1 =  (sc_lv<16>) (tmp_151_cast_fu_9891_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14810_p0() {
    grp_fu_14810_p0 =  (sc_lv<25>) (tmp_152_cast_fu_9895_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14810_p1() {
    grp_fu_14810_p1 =  (sc_lv<16>) (tmp_159_cast_fu_9907_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14818_p0() {
    grp_fu_14818_p0 =  (sc_lv<25>) (tmp_155_cast_fu_9903_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14818_p1() {
    grp_fu_14818_p1 =  (sc_lv<16>) (tmp_161_cast_fu_9911_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14826_p0() {
    grp_fu_14826_p0 =  (sc_lv<25>) (tmp_152_cast_fu_9895_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14826_p1() {
    grp_fu_14826_p1 =  (sc_lv<16>) (tmp_161_cast_fu_9911_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14834_p0() {
    grp_fu_14834_p0 =  (sc_lv<25>) (tmp_155_cast_fu_9903_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14834_p1() {
    grp_fu_14834_p1 =  (sc_lv<16>) (tmp_159_cast_fu_9907_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14842_p0() {
    grp_fu_14842_p0 =  (sc_lv<25>) (tmp_123_1_cast_fu_10003_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14842_p1() {
    grp_fu_14842_p1 =  (sc_lv<16>) (tmp_122_1_cast_fu_9999_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14850_p0() {
    grp_fu_14850_p0 =  (sc_lv<25>) (tmp_127_1_cast_fu_10011_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14850_p1() {
    grp_fu_14850_p1 =  (sc_lv<16>) (tmp_126_1_cast_fu_10007_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14858_p0() {
    grp_fu_14858_p0 =  (sc_lv<25>) (tmp_123_1_cast_fu_10003_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14858_p1() {
    grp_fu_14858_p1 =  (sc_lv<16>) (tmp_126_1_cast_fu_10007_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14866_p0() {
    grp_fu_14866_p0 =  (sc_lv<25>) (tmp_127_1_cast_fu_10011_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14866_p1() {
    grp_fu_14866_p1 =  (sc_lv<16>) (tmp_122_1_cast_fu_9999_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14874_p0() {
    grp_fu_14874_p0 =  (sc_lv<25>) (tmp_123_1_cast_fu_10003_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14874_p1() {
    grp_fu_14874_p1 =  (sc_lv<16>) (tmp_134_1_cast_fu_10015_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14882_p0() {
    grp_fu_14882_p0 =  (sc_lv<25>) (tmp_127_1_cast_fu_10011_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14882_p1() {
    grp_fu_14882_p1 =  (sc_lv<16>) (tmp_137_1_cast_fu_10019_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14890_p0() {
    grp_fu_14890_p0 =  (sc_lv<25>) (tmp_123_1_cast_fu_10003_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14890_p1() {
    grp_fu_14890_p1 =  (sc_lv<16>) (tmp_137_1_cast_fu_10019_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14898_p0() {
    grp_fu_14898_p0 =  (sc_lv<25>) (tmp_127_1_cast_fu_10011_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14898_p1() {
    grp_fu_14898_p1 =  (sc_lv<16>) (tmp_134_1_cast_fu_10015_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14906_p0() {
    grp_fu_14906_p0 =  (sc_lv<25>) (tmp_123_2_cast_fu_10111_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14906_p1() {
    grp_fu_14906_p1 =  (sc_lv<16>) (tmp_122_2_cast_fu_10107_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14914_p0() {
    grp_fu_14914_p0 =  (sc_lv<25>) (tmp_127_2_cast_fu_10119_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14914_p1() {
    grp_fu_14914_p1 =  (sc_lv<16>) (tmp_126_2_cast_fu_10115_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14922_p0() {
    grp_fu_14922_p0 =  (sc_lv<25>) (tmp_123_2_cast_fu_10111_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14922_p1() {
    grp_fu_14922_p1 =  (sc_lv<16>) (tmp_126_2_cast_fu_10115_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14930_p0() {
    grp_fu_14930_p0 =  (sc_lv<25>) (tmp_127_2_cast_fu_10119_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14930_p1() {
    grp_fu_14930_p1 =  (sc_lv<16>) (tmp_122_2_cast_fu_10107_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14938_p0() {
    grp_fu_14938_p0 =  (sc_lv<25>) (tmp_123_2_cast_fu_10111_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14938_p1() {
    grp_fu_14938_p1 =  (sc_lv<16>) (tmp_134_2_cast_fu_10123_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14946_p0() {
    grp_fu_14946_p0 =  (sc_lv<25>) (tmp_127_2_cast_fu_10119_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14946_p1() {
    grp_fu_14946_p1 =  (sc_lv<16>) (tmp_137_2_cast_fu_10127_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14954_p0() {
    grp_fu_14954_p0 =  (sc_lv<25>) (tmp_123_2_cast_fu_10111_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14954_p1() {
    grp_fu_14954_p1 =  (sc_lv<16>) (tmp_137_2_cast_fu_10127_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14962_p0() {
    grp_fu_14962_p0 =  (sc_lv<25>) (tmp_127_2_cast_fu_10119_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14962_p1() {
    grp_fu_14962_p1 =  (sc_lv<16>) (tmp_134_2_cast_fu_10123_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14970_p0() {
    grp_fu_14970_p0 =  (sc_lv<25>) (tmp_123_3_cast_fu_10219_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14970_p1() {
    grp_fu_14970_p1 =  (sc_lv<16>) (tmp_122_3_cast_fu_10215_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14978_p0() {
    grp_fu_14978_p0 =  (sc_lv<25>) (tmp_127_3_cast_fu_10227_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14978_p1() {
    grp_fu_14978_p1 =  (sc_lv<16>) (tmp_126_3_cast_fu_10223_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14986_p0() {
    grp_fu_14986_p0 =  (sc_lv<25>) (tmp_123_3_cast_fu_10219_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14986_p1() {
    grp_fu_14986_p1 =  (sc_lv<16>) (tmp_126_3_cast_fu_10223_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14994_p0() {
    grp_fu_14994_p0 =  (sc_lv<25>) (tmp_127_3_cast_fu_10227_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_14994_p1() {
    grp_fu_14994_p1 =  (sc_lv<16>) (tmp_122_3_cast_fu_10215_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15002_p0() {
    grp_fu_15002_p0 =  (sc_lv<25>) (tmp_123_3_cast_fu_10219_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15002_p1() {
    grp_fu_15002_p1 =  (sc_lv<16>) (tmp_134_3_cast_fu_10231_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15010_p0() {
    grp_fu_15010_p0 =  (sc_lv<25>) (tmp_127_3_cast_fu_10227_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15010_p1() {
    grp_fu_15010_p1 =  (sc_lv<16>) (tmp_137_3_cast_fu_10235_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15018_p0() {
    grp_fu_15018_p0 =  (sc_lv<25>) (tmp_123_3_cast_fu_10219_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15018_p1() {
    grp_fu_15018_p1 =  (sc_lv<16>) (tmp_137_3_cast_fu_10235_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15026_p0() {
    grp_fu_15026_p0 =  (sc_lv<25>) (tmp_127_3_cast_fu_10227_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15026_p1() {
    grp_fu_15026_p1 =  (sc_lv<16>) (tmp_134_3_cast_fu_10231_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15034_p0() {
    grp_fu_15034_p0 =  (sc_lv<25>) (tmp_167_cast_fu_12109_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15034_p1() {
    grp_fu_15034_p1 =  (sc_lv<16>) (tmp_166_cast_fu_12105_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15042_p0() {
    grp_fu_15042_p0 =  (sc_lv<25>) (tmp_170_cast_fu_12117_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15042_p1() {
    grp_fu_15042_p1 =  (sc_lv<16>) (tmp_169_cast_fu_12113_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15050_p0() {
    grp_fu_15050_p0 =  (sc_lv<25>) (tmp_173_cast_fu_12125_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15050_p1() {
    grp_fu_15050_p1 =  (sc_lv<16>) (tmp_172_cast_fu_12121_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15058_p0() {
    grp_fu_15058_p0 =  (sc_lv<25>) (tmp_176_cast_fu_12133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15058_p1() {
    grp_fu_15058_p1 =  (sc_lv<16>) (tmp_175_cast_fu_12129_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15066_p0() {
    grp_fu_15066_p0 =  (sc_lv<25>) (tmp_167_cast_fu_12109_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15066_p1() {
    grp_fu_15066_p1 =  (sc_lv<16>) (tmp_169_cast_fu_12113_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15074_p0() {
    grp_fu_15074_p0 =  (sc_lv<25>) (tmp_170_cast_fu_12117_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15074_p1() {
    grp_fu_15074_p1 =  (sc_lv<16>) (tmp_166_cast_fu_12105_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15082_p0() {
    grp_fu_15082_p0 =  (sc_lv<25>) (tmp_173_cast_fu_12125_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15082_p1() {
    grp_fu_15082_p1 =  (sc_lv<16>) (tmp_175_cast_fu_12129_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15090_p0() {
    grp_fu_15090_p0 =  (sc_lv<25>) (tmp_176_cast_fu_12133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15090_p1() {
    grp_fu_15090_p1 =  (sc_lv<16>) (tmp_172_cast_fu_12121_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15098_p0() {
    grp_fu_15098_p0 =  (sc_lv<25>) (tmp_167_cast_fu_12109_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15098_p1() {
    grp_fu_15098_p1 =  (sc_lv<16>) (tmp_182_cast_fu_12137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15106_p0() {
    grp_fu_15106_p0 =  (sc_lv<25>) (tmp_170_cast_fu_12117_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15106_p1() {
    grp_fu_15106_p1 =  (sc_lv<16>) (tmp_184_cast_fu_12141_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15114_p0() {
    grp_fu_15114_p0 =  (sc_lv<25>) (tmp_173_cast_fu_12125_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15114_p1() {
    grp_fu_15114_p1 =  (sc_lv<16>) (tmp_186_cast_fu_12145_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15122_p0() {
    grp_fu_15122_p0 =  (sc_lv<25>) (tmp_176_cast_fu_12133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15122_p1() {
    grp_fu_15122_p1 =  (sc_lv<16>) (tmp_188_cast_fu_12149_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15130_p0() {
    grp_fu_15130_p0 =  (sc_lv<25>) (tmp_167_cast_fu_12109_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15130_p1() {
    grp_fu_15130_p1 =  (sc_lv<16>) (tmp_184_cast_fu_12141_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15138_p0() {
    grp_fu_15138_p0 =  (sc_lv<25>) (tmp_170_cast_fu_12117_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15138_p1() {
    grp_fu_15138_p1 =  (sc_lv<16>) (tmp_182_cast_fu_12137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15146_p0() {
    grp_fu_15146_p0 =  (sc_lv<25>) (tmp_173_cast_fu_12125_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15146_p1() {
    grp_fu_15146_p1 =  (sc_lv<16>) (tmp_188_cast_fu_12149_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15154_p0() {
    grp_fu_15154_p0 =  (sc_lv<25>) (tmp_176_cast_fu_12133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15154_p1() {
    grp_fu_15154_p1 =  (sc_lv<16>) (tmp_186_cast_fu_12145_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15162_p0() {
    grp_fu_15162_p0 =  (sc_lv<25>) (tmp_187_1_cast_fu_12573_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15162_p1() {
    grp_fu_15162_p1 =  (sc_lv<16>) (tmp_186_1_cast_fu_12569_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15170_p0() {
    grp_fu_15170_p0 =  (sc_lv<25>) (tmp_191_1_cast_fu_12581_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15170_p1() {
    grp_fu_15170_p1 =  (sc_lv<16>) (tmp_190_1_cast_fu_12577_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15178_p0() {
    grp_fu_15178_p0 =  (sc_lv<25>) (tmp_195_1_cast_fu_12589_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15178_p1() {
    grp_fu_15178_p1 =  (sc_lv<16>) (tmp_194_1_cast_fu_12585_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15186_p0() {
    grp_fu_15186_p0 =  (sc_lv<25>) (tmp_199_1_cast_fu_12597_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15186_p1() {
    grp_fu_15186_p1 =  (sc_lv<16>) (tmp_198_1_cast_fu_12593_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15194_p0() {
    grp_fu_15194_p0 =  (sc_lv<25>) (tmp_187_1_cast_fu_12573_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15194_p1() {
    grp_fu_15194_p1 =  (sc_lv<16>) (tmp_190_1_cast_fu_12577_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15202_p0() {
    grp_fu_15202_p0 =  (sc_lv<25>) (tmp_191_1_cast_fu_12581_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15202_p1() {
    grp_fu_15202_p1 =  (sc_lv<16>) (tmp_186_1_cast_fu_12569_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15210_p0() {
    grp_fu_15210_p0 =  (sc_lv<25>) (tmp_195_1_cast_fu_12589_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15210_p1() {
    grp_fu_15210_p1 =  (sc_lv<16>) (tmp_198_1_cast_fu_12593_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15218_p0() {
    grp_fu_15218_p0 =  (sc_lv<25>) (tmp_199_1_cast_fu_12597_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15218_p1() {
    grp_fu_15218_p1 =  (sc_lv<16>) (tmp_194_1_cast_fu_12585_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15226_p0() {
    grp_fu_15226_p0 =  (sc_lv<25>) (tmp_187_1_cast_fu_12573_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15226_p1() {
    grp_fu_15226_p1 =  (sc_lv<16>) (tmp_210_1_cast_fu_12601_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15234_p0() {
    grp_fu_15234_p0 =  (sc_lv<25>) (tmp_191_1_cast_fu_12581_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15234_p1() {
    grp_fu_15234_p1 =  (sc_lv<16>) (tmp_213_1_cast_fu_12605_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15242_p0() {
    grp_fu_15242_p0 =  (sc_lv<25>) (tmp_195_1_cast_fu_12589_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15242_p1() {
    grp_fu_15242_p1 =  (sc_lv<16>) (tmp_216_1_cast_fu_12609_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15250_p0() {
    grp_fu_15250_p0 =  (sc_lv<25>) (tmp_199_1_cast_fu_12597_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15250_p1() {
    grp_fu_15250_p1 =  (sc_lv<16>) (tmp_219_1_cast_fu_12613_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15258_p0() {
    grp_fu_15258_p0 =  (sc_lv<25>) (tmp_187_1_cast_fu_12573_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15258_p1() {
    grp_fu_15258_p1 =  (sc_lv<16>) (tmp_213_1_cast_fu_12605_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15266_p0() {
    grp_fu_15266_p0 =  (sc_lv<25>) (tmp_191_1_cast_fu_12581_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15266_p1() {
    grp_fu_15266_p1 =  (sc_lv<16>) (tmp_210_1_cast_fu_12601_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15274_p0() {
    grp_fu_15274_p0 =  (sc_lv<25>) (tmp_195_1_cast_fu_12589_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15274_p1() {
    grp_fu_15274_p1 =  (sc_lv<16>) (tmp_219_1_cast_fu_12613_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15282_p0() {
    grp_fu_15282_p0 =  (sc_lv<25>) (tmp_199_1_cast_fu_12597_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15282_p1() {
    grp_fu_15282_p1 =  (sc_lv<16>) (tmp_216_1_cast_fu_12609_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15290_p1() {
    grp_fu_15290_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15298_p1() {
    grp_fu_15298_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15306_p1() {
    grp_fu_15306_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15314_p1() {
    grp_fu_15314_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15322_p1() {
    grp_fu_15322_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15330_p1() {
    grp_fu_15330_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15338_p1() {
    grp_fu_15338_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15346_p1() {
    grp_fu_15346_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15354_p1() {
    grp_fu_15354_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15362_p1() {
    grp_fu_15362_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15370_p1() {
    grp_fu_15370_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15378_p1() {
    grp_fu_15378_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15386_p1() {
    grp_fu_15386_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15394_p1() {
    grp_fu_15394_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15402_p1() {
    grp_fu_15402_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15410_p1() {
    grp_fu_15410_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15418_p1() {
    grp_fu_15418_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15426_p1() {
    grp_fu_15426_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15434_p1() {
    grp_fu_15434_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15442_p1() {
    grp_fu_15442_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15450_p1() {
    grp_fu_15450_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15458_p1() {
    grp_fu_15458_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15466_p1() {
    grp_fu_15466_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15482_p1() {
    grp_fu_15482_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15490_p1() {
    grp_fu_15490_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15498_p1() {
    grp_fu_15498_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15506_p1() {
    grp_fu_15506_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15514_p1() {
    grp_fu_15514_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15522_p1() {
    grp_fu_15522_p1 =  (sc_lv<25>) (tmp_45_cast_cast_fu_13137_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15530_p1() {
    grp_fu_15530_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15538_p1() {
    grp_fu_15538_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15546_p1() {
    grp_fu_15546_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15554_p1() {
    grp_fu_15554_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15562_p1() {
    grp_fu_15562_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15570_p1() {
    grp_fu_15570_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15578_p1() {
    grp_fu_15578_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15586_p1() {
    grp_fu_15586_p1 =  (sc_lv<25>) (tmp_45_cast1_cast_fu_13133_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15594_p1() {
    grp_fu_15594_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15602_p1() {
    grp_fu_15602_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15610_p1() {
    grp_fu_15610_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15618_p1() {
    grp_fu_15618_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15626_p1() {
    grp_fu_15626_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15634_p1() {
    grp_fu_15634_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15642_p1() {
    grp_fu_15642_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15650_p1() {
    grp_fu_15650_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15658_p1() {
    grp_fu_15658_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15666_p1() {
    grp_fu_15666_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15674_p1() {
    grp_fu_15674_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15682_p1() {
    grp_fu_15682_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15690_p1() {
    grp_fu_15690_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15698_p1() {
    grp_fu_15698_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15706_p1() {
    grp_fu_15706_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15714_p1() {
    grp_fu_15714_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15722_p1() {
    grp_fu_15722_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15730_p1() {
    grp_fu_15730_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15738_p1() {
    grp_fu_15738_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15746_p1() {
    grp_fu_15746_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15754_p1() {
    grp_fu_15754_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15762_p1() {
    grp_fu_15762_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15770_p1() {
    grp_fu_15770_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15786_p1() {
    grp_fu_15786_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15794_p1() {
    grp_fu_15794_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15802_p1() {
    grp_fu_15802_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15810_p1() {
    grp_fu_15810_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15818_p1() {
    grp_fu_15818_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15826_p1() {
    grp_fu_15826_p1 =  (sc_lv<25>) (tmp_72_cast_cast_fu_13521_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15834_p1() {
    grp_fu_15834_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15842_p1() {
    grp_fu_15842_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15850_p1() {
    grp_fu_15850_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15858_p1() {
    grp_fu_15858_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15866_p1() {
    grp_fu_15866_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15874_p1() {
    grp_fu_15874_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15882_p1() {
    grp_fu_15882_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_grp_fu_15890_p1() {
    grp_fu_15890_p1 =  (sc_lv<25>) (tmp_72_cast1_cast_fu_13517_p1.read());
}

void LcwtMLP_RFFI::thread_hi_i_address0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state48.read())) {
        hi_i_address0 =  (sc_lv<8>) (tmp_141_fu_12948_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter2.read()))) {
        hi_i_address0 =  (sc_lv<8>) (tmp_30_fu_11343_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read())) {
        hi_i_address0 =  (sc_lv<8>) (tmp_95_fu_10642_p1.read());
    } else {
        hi_i_address0 =  (sc_lv<8>) ("XXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_hi_i_ce0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state48.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read()) || 
         (esl_seteq<1,1,1>(ap_block_pp6_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter2.read())))) {
        hi_i_ce0 = ap_const_logic_1;
    } else {
        hi_i_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_hi_i_we0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read())) {
        hi_i_we0 = ap_const_logic_1;
    } else {
        hi_i_we0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_hr_i_address0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state48.read())) {
        hr_i_address0 =  (sc_lv<8>) (tmp_141_fu_12948_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter2.read()))) {
        hr_i_address0 =  (sc_lv<8>) (tmp_30_fu_11343_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read())) {
        hr_i_address0 =  (sc_lv<8>) (tmp_95_fu_10642_p1.read());
    } else {
        hr_i_address0 =  (sc_lv<8>) ("XXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_hr_i_ce0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state48.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read()) || 
         (esl_seteq<1,1,1>(ap_block_pp6_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter2.read())))) {
        hr_i_ce0 = ap_const_logic_1;
    } else {
        hr_i_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_hr_i_we0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read())) {
        hr_i_we0 = ap_const_logic_1;
    } else {
        hr_i_we0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_i0_fu_10380_p2() {
    i0_fu_10380_p2 = (!tmp_107_cast_fu_10376_p1.read().is_01() || !ioff_cast_reg_17296.read().is_01())? sc_lv<10>(): (sc_biguint<10>(tmp_107_cast_fu_10376_p1.read()) + sc_biguint<10>(ioff_cast_reg_17296.read()));
}

void LcwtMLP_RFFI::thread_i1_fu_10400_p2() {
    i1_fu_10400_p2 = (!tmp_109_cast_fu_10396_p1.read().is_01() || !ioff_cast_reg_17296.read().is_01())? sc_lv<10>(): (sc_biguint<10>(tmp_109_cast_fu_10396_p1.read()) + sc_biguint<10>(ioff_cast_reg_17296.read()));
}

void LcwtMLP_RFFI::thread_i3_0_i_i_i_cast_fu_13453_p1() {
    i3_0_i_i_i_cast_fu_13453_p1 = esl_zext<8,5>(i3_0_i_i_i_reg_8495.read());
}

void LcwtMLP_RFFI::thread_i_0_i_i_i_cast_fu_13074_p1() {
    i_0_i_i_i_cast_fu_13074_p1 = esl_zext<8,5>(ap_phi_mux_i_0_i_i_i_phi_fu_8106_p4.read());
}

void LcwtMLP_RFFI::thread_i_1_fu_8568_p2() {
    i_1_fu_8568_p2 = (!ap_phi_mux_i_0_i_phi_fu_2518_p4.read().is_01() || !ap_const_lv9_1.is_01())? sc_lv<9>(): (sc_biguint<9>(ap_phi_mux_i_0_i_phi_fu_2518_p4.read()) + sc_biguint<9>(ap_const_lv9_1));
}

void LcwtMLP_RFFI::thread_i_2_fu_13068_p2() {
    i_2_fu_13068_p2 = (!ap_phi_mux_i_0_i_i_i_phi_fu_8106_p4.read().is_01() || !ap_const_lv5_1.is_01())? sc_lv<5>(): (sc_biguint<5>(ap_phi_mux_i_0_i_i_i_phi_fu_8106_p4.read()) + sc_biguint<5>(ap_const_lv5_1));
}

void LcwtMLP_RFFI::thread_i_3_fu_13447_p2() {
    i_3_fu_13447_p2 = (!i3_0_i_i_i_reg_8495.read().is_01() || !ap_const_lv5_1.is_01())? sc_lv<5>(): (sc_biguint<5>(i3_0_i_i_i_reg_8495.read()) + sc_biguint<5>(ap_const_lv5_1));
}

void LcwtMLP_RFFI::thread_i_fu_8611_p2() {
    i_fu_8611_p2 = (!i_0_i_i_reg_2561.read().is_01() || !ap_const_lv9_1.is_01())? sc_lv<9>(): (sc_biguint<9>(i_0_i_i_reg_2561.read()) + sc_biguint<9>(ap_const_lv9_1));
}

void LcwtMLP_RFFI::thread_icmp1_fu_14715_p2() {
    icmp1_fu_14715_p2 = (!tmp_66_fu_14705_p4.read().is_01() || !ap_const_lv14_0.is_01())? sc_lv<1>(): (sc_bigint<14>(tmp_66_fu_14705_p4.read()) > sc_bigint<14>(ap_const_lv14_0));
}

void LcwtMLP_RFFI::thread_icmp_fu_14699_p2() {
    icmp_fu_14699_p2 = (!tmp_62_fu_14689_p4.read().is_01() || !ap_const_lv14_0.is_01())? sc_lv<1>(): (sc_bigint<14>(tmp_62_fu_14689_p4.read()) > sc_bigint<14>(ap_const_lv14_0));
}

void LcwtMLP_RFFI::thread_idx_1_fu_11328_p2() {
    idx_1_fu_11328_p2 = (!ioff_1_cast_reg_18132.read().is_01() || !tmp_26_cast_fu_11324_p1.read().is_01())? sc_lv<10>(): (sc_biguint<10>(ioff_1_cast_reg_18132.read()) + sc_biguint<10>(tmp_26_cast_fu_11324_p1.read()));
}

void LcwtMLP_RFFI::thread_idx_fu_9304_p2() {
    idx_fu_9304_p2 = (!ioff_cast_reg_17296.read().is_01() || !tmp_17_cast_fu_9300_p1.read().is_01())? sc_lv<10>(): (sc_biguint<10>(ioff_cast_reg_17296.read()) + sc_biguint<10>(tmp_17_cast_fu_9300_p1.read()));
}

void LcwtMLP_RFFI::thread_indvar_flatten_next_fu_14528_p2() {
    indvar_flatten_next_fu_14528_p2 = (!indvar_flatten_reg_8517.read().is_01() || !ap_const_lv9_1.is_01())? sc_lv<9>(): (sc_biguint<9>(indvar_flatten_reg_8517.read()) + sc_biguint<9>(ap_const_lv9_1));
}

void LcwtMLP_RFFI::thread_ioff_1_cast_fu_10786_p1() {
    ioff_1_cast_fu_10786_p1 = esl_zext<10,9>(LOFF_q0.read());
}

void LcwtMLP_RFFI::thread_ioff_cast_fu_8769_p1() {
    ioff_cast_fu_8769_p1 = esl_zext<10,9>(LOFF_q0.read());
}

void LcwtMLP_RFFI::thread_j_0_i_mid2_fu_14546_p3() {
    j_0_i_mid2_fu_14546_p3 = (!exitcond_i1_fu_14540_p2.read()[0].is_01())? sc_lv<5>(): ((exitcond_i1_fu_14540_p2.read()[0].to_bool())? ap_const_lv5_0: j_0_i_reg_8539.read());
}

void LcwtMLP_RFFI::thread_j_1_fu_14630_p2() {
    j_1_fu_14630_p2 = (!ap_const_lv5_1.is_01() || !j_0_i_mid2_fu_14546_p3.read().is_01())? sc_lv<5>(): (sc_biguint<5>(ap_const_lv5_1) + sc_biguint<5>(j_0_i_mid2_fu_14546_p3.read()));
}

void LcwtMLP_RFFI::thread_j_fu_11291_p2() {
    j_fu_11291_p2 = (!j_0_i47_i_i_reg_5511.read().is_01() || !ap_const_lv4_1.is_01())? sc_lv<4>(): (sc_biguint<4>(j_0_i47_i_i_reg_5511.read()) + sc_biguint<4>(ap_const_lv4_1));
}

void LcwtMLP_RFFI::thread_k_0_i44_i_i_cast_fu_10866_p1() {
    k_0_i44_i_i_cast_fu_10866_p1 = esl_zext<8,5>(ap_phi_mux_k_0_i44_i_i_phi_fu_5503_p4.read());
}

void LcwtMLP_RFFI::thread_k_0_i_i_i_cast_fu_8849_p1() {
    k_0_i_i_i_cast_fu_8849_p1 = esl_zext<8,5>(ap_phi_mux_k_0_i_i_i_phi_fu_2588_p4.read());
}

void LcwtMLP_RFFI::thread_k_1_fu_8843_p2() {
    k_1_fu_8843_p2 = (!ap_phi_mux_k_0_i_i_i_phi_fu_2588_p4.read().is_01() || !ap_const_lv5_1.is_01())? sc_lv<5>(): (sc_biguint<5>(ap_phi_mux_k_0_i_i_i_phi_fu_2588_p4.read()) + sc_biguint<5>(ap_const_lv5_1));
}

void LcwtMLP_RFFI::thread_k_2_fu_10860_p2() {
    k_2_fu_10860_p2 = (!ap_phi_mux_k_0_i44_i_i_phi_fu_5503_p4.read().is_01() || !ap_const_lv5_1.is_01())? sc_lv<5>(): (sc_biguint<5>(ap_phi_mux_k_0_i44_i_i_phi_fu_5503_p4.read()) + sc_biguint<5>(ap_const_lv5_1));
}

void LcwtMLP_RFFI::thread_k_fu_9274_p2() {
    k_fu_9274_p2 = (!k9_0_i_i_i_reg_2596.read().is_01() || !ap_const_lv5_1.is_01())? sc_lv<5>(): (sc_biguint<5>(k9_0_i_i_i_reg_2596.read()) + sc_biguint<5>(ap_const_lv5_1));
}

void LcwtMLP_RFFI::thread_lhs_V_1_fu_14670_p1() {
    lhs_V_1_fu_14670_p1 = esl_sext<33,32>(tokT_V_load_1_reg_20572.read());
}

void LcwtMLP_RFFI::thread_lhs_V_fu_14651_p1() {
    lhs_V_fu_14651_p1 = esl_sext<33,32>(tokT_V_load_reg_20567.read());
}

void LcwtMLP_RFFI::thread_li_i_address0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state52.read())) {
        li_i_address0 =  (sc_lv<9>) (tmp_139_fu_13033_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state29.read())) {
        li_i_address0 =  (sc_lv<9>) (tmp_108_fu_10647_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read())) {
        li_i_address0 =  (sc_lv<9>) (tmp_83_fu_10637_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp3_stage0.read()) && 
                esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter1.read()))) {
        li_i_address0 =  (sc_lv<9>) (tmp_19_fu_9313_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_block_pp1_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp1_iter2.read()))) {
        li_i_address0 =  (sc_lv<9>) (tmp_reg_17082_pp1_iter1_reg.read());
    } else {
        li_i_address0 =  (sc_lv<9>) ("XXXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_li_i_address1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp9_stage0.read(), ap_const_boolean_0))) {
        li_i_address1 =  (sc_lv<9>) (tmp_69_fu_13468_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state51.read())) {
        li_i_address1 =  (sc_lv<9>) (tmp_127_fu_13028_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state50.read())) {
        li_i_address1 =  (sc_lv<9>) (tmp_114_fu_13023_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter2.read()))) {
        li_i_address1 =  (sc_lv<9>) (tmp_28_fu_11338_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state29.read())) {
        li_i_address1 =  (sc_lv<9>) (tmp_109_fu_10652_p1.read());
    } else {
        li_i_address1 =  (sc_lv<9>) ("XXXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_li_i_ce0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state29.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state52.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read()) || 
         (esl_seteq<1,1,1>(ap_block_pp1_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp1_iter2.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp3_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter1.read())))) {
        li_i_ce0 = ap_const_logic_1;
    } else {
        li_i_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_li_i_ce1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state29.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state50.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state51.read()) || 
         (esl_seteq<1,1,1>(ap_block_pp6_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter2.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp9_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp9_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp9_iter1.read())))) {
        li_i_ce1 = ap_const_logic_1;
    } else {
        li_i_ce1 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_li_i_d0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read())) {
        li_i_d0 = tmp_93_reg_17893.read();
    } else if ((esl_seteq<1,1,1>(ap_block_pp1_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp1_iter2.read()))) {
        li_i_d0 = tmp_2_fu_8627_p1.read();
    } else {
        li_i_d0 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_li_i_d1() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state51.read())) {
        li_i_d1 = tmp_135_reg_18760.read();
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state50.read())) {
        li_i_d1 = tmp_123_reg_18750.read();
    } else {
        li_i_d1 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_li_i_we0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read()) || 
         (esl_seteq<1,1,1>(ap_block_pp1_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp1_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_i_i_reg_17073_pp1_iter1_reg.read())))) {
        li_i_we0 = ap_const_logic_1;
    } else {
        li_i_we0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_li_i_we1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state50.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state51.read()))) {
        li_i_we1 = ap_const_logic_1;
    } else {
        li_i_we1 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_lr_i_address0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state52.read())) {
        lr_i_address0 =  (sc_lv<9>) (tmp_139_fu_13033_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state29.read())) {
        lr_i_address0 =  (sc_lv<9>) (tmp_108_fu_10647_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read())) {
        lr_i_address0 =  (sc_lv<9>) (tmp_83_fu_10637_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp3_stage0.read()) && 
                esl_seteq<1,1,1>(ap_block_pp3_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter1.read()))) {
        lr_i_address0 =  (sc_lv<9>) (tmp_19_fu_9313_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_block_pp1_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp1_iter2.read()))) {
        lr_i_address0 =  (sc_lv<9>) (tmp_reg_17082_pp1_iter1_reg.read());
    } else {
        lr_i_address0 =  (sc_lv<9>) ("XXXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_lr_i_address1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read()) && 
         esl_seteq<1,1,1>(ap_block_pp8_stage0.read(), ap_const_boolean_0))) {
        lr_i_address1 =  (sc_lv<9>) (tmp_42_fu_13083_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state51.read())) {
        lr_i_address1 =  (sc_lv<9>) (tmp_127_fu_13028_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state50.read())) {
        lr_i_address1 =  (sc_lv<9>) (tmp_114_fu_13023_p1.read());
    } else if ((esl_seteq<1,1,1>(ap_block_pp6_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter2.read()))) {
        lr_i_address1 =  (sc_lv<9>) (tmp_28_fu_11338_p1.read());
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state29.read())) {
        lr_i_address1 =  (sc_lv<9>) (tmp_109_fu_10652_p1.read());
    } else {
        lr_i_address1 =  (sc_lv<9>) ("XXXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_lr_i_ce0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state29.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state52.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read()) || 
         (esl_seteq<1,1,1>(ap_block_pp1_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp1_iter2.read())) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp3_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp3_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp3_iter1.read())))) {
        lr_i_ce0 = ap_const_logic_1;
    } else {
        lr_i_ce0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_lr_i_ce1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state29.read()) || 
         (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_pp8_stage0.read()) && 
          esl_seteq<1,1,1>(ap_block_pp8_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp8_iter1.read())) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state50.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state51.read()) || 
         (esl_seteq<1,1,1>(ap_block_pp6_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp6_iter2.read())))) {
        lr_i_ce1 = ap_const_logic_1;
    } else {
        lr_i_ce1 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_lr_i_d0() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read())) {
        lr_i_d0 = tmp_89_reg_17888.read();
    } else if ((esl_seteq<1,1,1>(ap_block_pp1_stage0.read(), ap_const_boolean_0) && 
                esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp1_iter2.read()))) {
        lr_i_d0 = tmp_1_fu_8623_p1.read();
    } else {
        lr_i_d0 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_lr_i_d1() {
    if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state51.read())) {
        lr_i_d1 = tmp_132_reg_18790.read();
    } else if (esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state50.read())) {
        lr_i_d1 = tmp_119_reg_18780.read();
    } else {
        lr_i_d1 =  (sc_lv<25>) ("XXXXXXXXXXXXXXXXXXXXXXXXX");
    }
}

void LcwtMLP_RFFI::thread_lr_i_we0() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state28.read()) || 
         (esl_seteq<1,1,1>(ap_block_pp1_stage0_11001.read(), ap_const_boolean_0) && 
          esl_seteq<1,1,1>(ap_const_logic_1, ap_enable_reg_pp1_iter2.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, exitcond_i_i_reg_17073_pp1_iter1_reg.read())))) {
        lr_i_we0 = ap_const_logic_1;
    } else {
        lr_i_we0 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_lr_i_we1() {
    if ((esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state50.read()) || 
         esl_seteq<1,1,1>(ap_const_logic_1, ap_CS_fsm_state51.read()))) {
        lr_i_we1 = ap_const_logic_1;
    } else {
        lr_i_we1 = ap_const_logic_0;
    }
}

void LcwtMLP_RFFI::thread_lv_0_i_i_i_cast_fu_8749_p1() {
    lv_0_i_i_i_cast_fu_8749_p1 = esl_zext<9,3>(lv_0_i_i_i_reg_2572.read());
}

void LcwtMLP_RFFI::thread_lv_1_fu_11363_p2() {
    lv_1_fu_11363_p2 = (!lv_0_i39_i_i_reg_5487.read().is_01() || !ap_const_lv3_7.is_01())? sc_lv<3>(): (sc_biguint<3>(lv_0_i39_i_i_reg_5487.read()) + sc_bigint<3>(ap_const_lv3_7));
}

void LcwtMLP_RFFI::thread_lv_fu_8733_p2() {
    lv_fu_8733_p2 = (!lv_0_i_i_i_reg_2572.read().is_01() || !ap_const_lv3_1.is_01())? sc_lv<3>(): (sc_biguint<3>(lv_0_i_i_i_reg_2572.read()) + sc_biguint<3>(ap_const_lv3_1));
}

void LcwtMLP_RFFI::thread_m_1_fu_11535_p2() {
    m_1_fu_11535_p2 = (!m_0_i52_i_i_reg_7610.read().is_01() || !ap_const_lv3_1.is_01())? sc_lv<3>(): (sc_biguint<3>(m_0_i52_i_i_reg_7610.read()) + sc_biguint<3>(ap_const_lv3_1));
}

void LcwtMLP_RFFI::thread_m_fu_9503_p2() {
    m_fu_9503_p2 = (!m_0_i_i_i_reg_5463.read().is_01() || !ap_const_lv3_1.is_01())? sc_lv<3>(): (sc_biguint<3>(m_0_i_i_i_reg_5463.read()) + sc_biguint<3>(ap_const_lv3_1));
}

void LcwtMLP_RFFI::thread_n_1_fu_10780_p2() {
    n_1_fu_10780_p2 = (!tmp_3_cast_fu_10777_p1.read().is_01())? sc_lv<9>(): ap_const_lv9_100 >> (unsigned short)tmp_3_cast_fu_10777_p1.read().to_uint();
}

void LcwtMLP_RFFI::thread_n_fu_8753_p2() {
    n_fu_8753_p2 = (!lv_0_i_i_i_cast_fu_8749_p1.read().is_01())? sc_lv<9>(): ap_const_lv9_100 >> (unsigned short)lv_0_i_i_i_cast_fu_8749_p1.read().to_uint();
}

void LcwtMLP_RFFI::thread_nn_cast1_fu_12874_p1() {
    nn_cast1_fu_12874_p1 = esl_zext<32,7>(nn_reg_18669.read());
}

void LcwtMLP_RFFI::thread_nn_cast_fu_12877_p1() {
    nn_cast_fu_12877_p1 = esl_zext<10,7>(nn_reg_18669.read());
}

void LcwtMLP_RFFI::thread_nn_fu_12711_p2() {
    nn_fu_12711_p2 = (u_cast_fu_12705_p2.read() & tmp_13_cast_reg_18238.read());
}

void LcwtMLP_RFFI::thread_ooff_1_cast_fu_10790_p1() {
    ooff_1_cast_fu_10790_p1 = esl_zext<10,9>(LOFF_q1.read());
}

void LcwtMLP_RFFI::thread_ooff_cast_fu_8773_p1() {
    ooff_cast_fu_8773_p1 = esl_zext<10,9>(LOFF_q1.read());
}

void LcwtMLP_RFFI::thread_p_phitmp237_i_fu_14745_p3() {
    p_phitmp237_i_fu_14745_p3 = (!icmp1_reg_20592.read()[0].is_01())? sc_lv<29>(): ((icmp1_reg_20592.read()[0].to_bool())? ap_const_lv29_7FFF: tmp_58_reg_20582.read());
}

void LcwtMLP_RFFI::thread_p_phitmp_i_fu_14721_p3() {
    p_phitmp_i_fu_14721_p3 = (!icmp_reg_20587.read()[0].is_01())? sc_lv<29>(): ((icmp_reg_20587.read()[0].to_bool())? ap_const_lv29_7FFF: tmp_52_reg_20577.read());
}

void LcwtMLP_RFFI::thread_ret_V_1_fu_14654_p2() {
    ret_V_1_fu_14654_p2 = (!ap_const_lv33_8.is_01() || !lhs_V_fu_14651_p1.read().is_01())? sc_lv<33>(): (sc_biguint<33>(ap_const_lv33_8) + sc_bigint<33>(lhs_V_fu_14651_p1.read()));
}

void LcwtMLP_RFFI::thread_ret_V_2_fu_14673_p2() {
    ret_V_2_fu_14673_p2 = (!ap_const_lv33_8.is_01() || !lhs_V_1_fu_14670_p1.read().is_01())? sc_lv<33>(): (sc_biguint<33>(ap_const_lv33_8) + sc_bigint<33>(lhs_V_1_fu_14670_p1.read()));
}

void LcwtMLP_RFFI::thread_ret_V_fu_14769_p3() {
    ret_V_fu_14769_p3 = esl_concat<16,16>(tmp_63_fu_14761_p3.read(), tmp_59_fu_14737_p3.read());
}

void LcwtMLP_RFFI::thread_s0_V_3_fu_10475_p2() {
    s0_V_3_fu_10475_p2 = (!tmp3_reg_17788.read().is_01() || !tmp4_fu_10469_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp3_reg_17788.read()) + sc_biguint<38>(tmp4_fu_10469_p2.read()));
}

void LcwtMLP_RFFI::thread_s10_V_1_fu_12671_p2() {
    s10_V_1_fu_12671_p2 = (!tmp_233_fu_12637_p1.read().is_01() || !tmp_232_fu_12633_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_233_fu_12637_p1.read()) + sc_biguint<38>(tmp_232_fu_12633_p1.read()));
}

void LcwtMLP_RFFI::thread_s11_V_1_fu_12814_p2() {
    s11_V_1_fu_12814_p2 = (!tmp_231_fu_12736_p1.read().is_01() || !tmp_230_fu_12732_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_231_fu_12736_p1.read()) + sc_biguint<38>(tmp_230_fu_12732_p1.read()));
}

void LcwtMLP_RFFI::thread_s1_V_1_1_fu_12796_p2() {
    s1_V_1_1_fu_12796_p2 = (!tmp_251_fu_12784_p1.read().is_01() || !tmp_250_fu_12780_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_251_fu_12784_p1.read()) + sc_biguint<38>(tmp_250_fu_12780_p1.read()));
}

void LcwtMLP_RFFI::thread_s1_V_3_fu_10486_p2() {
    s1_V_3_fu_10486_p2 = (!tmp5_reg_17793.read().is_01() || !tmp6_fu_10480_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp5_reg_17793.read()) + sc_biguint<38>(tmp6_fu_10480_p2.read()));
}

void LcwtMLP_RFFI::thread_s2_V_1_1_fu_12665_p2() {
    s2_V_1_1_fu_12665_p2 = (!tmp_249_fu_12661_p1.read().is_01() || !tmp_248_fu_12657_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_249_fu_12661_p1.read()) + sc_biguint<38>(tmp_248_fu_12657_p1.read()));
}

void LcwtMLP_RFFI::thread_s3_V_1_1_fu_12802_p2() {
    s3_V_1_1_fu_12802_p2 = (!tmp_247_fu_12776_p1.read().is_01() || !tmp_246_fu_12772_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_247_fu_12776_p1.read()) + sc_biguint<38>(tmp_246_fu_12772_p1.read()));
}

void LcwtMLP_RFFI::thread_s4_V_3_fu_10497_p2() {
    s4_V_3_fu_10497_p2 = (!tmp7_reg_17798.read().is_01() || !tmp8_fu_10491_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp7_reg_17798.read()) + sc_biguint<38>(tmp8_fu_10491_p2.read()));
}

void LcwtMLP_RFFI::thread_s5_V_3_fu_10508_p2() {
    s5_V_3_fu_10508_p2 = (!tmp9_reg_17803.read().is_01() || !tmp10_fu_10502_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp9_reg_17803.read()) + sc_biguint<38>(tmp10_fu_10502_p2.read()));
}

void LcwtMLP_RFFI::thread_s9_V_1_fu_12808_p2() {
    s9_V_1_fu_12808_p2 = (!tmp_235_fu_12744_p1.read().is_01() || !tmp_234_fu_12740_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_235_fu_12744_p1.read()) + sc_biguint<38>(tmp_234_fu_12740_p1.read()));
}

void LcwtMLP_RFFI::thread_t_0_i_i_i_cast1_fu_9329_p1() {
    t_0_i_i_i_cast1_fu_9329_p1 = esl_zext<32,8>(t_0_i_i_i_reg_5067.read());
}

void LcwtMLP_RFFI::thread_t_0_i_i_i_cast2_fu_9333_p1() {
    t_0_i_i_i_cast2_fu_9333_p1 = esl_zext<10,8>(t_0_i_i_i_reg_5067.read());
}

void LcwtMLP_RFFI::thread_t_1_fu_9323_p2() {
    t_1_fu_9323_p2 = (!t_0_i_i_i_reg_5067.read().is_01() || !ap_const_lv8_1.is_01())? sc_lv<8>(): (sc_biguint<8>(t_0_i_i_i_reg_5067.read()) + sc_biguint<8>(ap_const_lv8_1));
}

void LcwtMLP_RFFI::thread_t_2_fu_13044_p2() {
    t_2_fu_13044_p2 = (!t_0_i57_i_i_reg_7634.read().is_01() || !ap_const_lv5_1.is_01())? sc_lv<5>(): (sc_biguint<5>(t_0_i57_i_i_reg_7634.read()) + sc_biguint<5>(ap_const_lv5_1));
}

void LcwtMLP_RFFI::thread_t_V_10_fu_13877_p2() {
    t_V_10_fu_13877_p2 = (!acc_V_10_1_reg_8385.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_10_1_reg_8385.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_11_fu_13897_p2() {
    t_V_11_fu_13897_p2 = (!acc_V_11_1_reg_8375.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_11_1_reg_8375.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_12_fu_13917_p2() {
    t_V_12_fu_13917_p2 = (!acc_V_12_1_reg_8365.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_12_1_reg_8365.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_13_fu_13937_p2() {
    t_V_13_fu_13937_p2 = (!acc_V_13_1_reg_8355.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_13_1_reg_8355.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_14_fu_13957_p2() {
    t_V_14_fu_13957_p2 = (!acc_V_14_1_reg_8345.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_14_1_reg_8345.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_15_fu_13977_p2() {
    t_V_15_fu_13977_p2 = (!acc_V_15_1_reg_8335.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_15_1_reg_8335.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_16_fu_13997_p2() {
    t_V_16_fu_13997_p2 = (!acc_V_16_1_reg_8325.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_16_1_reg_8325.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_17_fu_14017_p2() {
    t_V_17_fu_14017_p2 = (!acc_V_17_1_reg_8315.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_17_1_reg_8315.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_18_fu_14037_p2() {
    t_V_18_fu_14037_p2 = (!acc_V_18_1_reg_8305.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_18_1_reg_8305.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_19_fu_14057_p2() {
    t_V_19_fu_14057_p2 = (!acc_V_19_1_reg_8295.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_19_1_reg_8295.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_1_fu_10561_p2() {
    t_V_1_fu_10561_p2 = (!ap_const_lv38_1000.is_01() || !tmp_84_fu_10557_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(ap_const_lv38_1000) + sc_biguint<38>(tmp_84_fu_10557_p2.read()));
}

void LcwtMLP_RFFI::thread_t_V_20_fu_14077_p2() {
    t_V_20_fu_14077_p2 = (!acc_V_20_1_reg_8285.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_20_1_reg_8285.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_21_fu_14097_p2() {
    t_V_21_fu_14097_p2 = (!acc_V_21_1_reg_8275.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_21_1_reg_8275.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_22_fu_14117_p2() {
    t_V_22_fu_14117_p2 = (!acc_V_22_1_reg_8265.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_22_1_reg_8265.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_23_fu_14141_p2() {
    t_V_23_fu_14141_p2 = (!tmp_86_22_cast_fu_14137_p1.read().is_01() || !ap_const_lv45_8000.is_01())? sc_lv<45>(): (sc_bigint<45>(tmp_86_22_cast_fu_14137_p1.read()) + sc_biguint<45>(ap_const_lv45_8000));
}

void LcwtMLP_RFFI::thread_t_V_24_fu_14161_p2() {
    t_V_24_fu_14161_p2 = (!acc_V_24_1_reg_8244.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_24_1_reg_8244.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_25_fu_14181_p2() {
    t_V_25_fu_14181_p2 = (!acc_V_25_1_reg_8234.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_25_1_reg_8234.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_26_fu_14201_p2() {
    t_V_26_fu_14201_p2 = (!acc_V_26_1_reg_8224.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_26_1_reg_8224.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_27_fu_14221_p2() {
    t_V_27_fu_14221_p2 = (!acc_V_27_1_reg_8214.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_27_1_reg_8214.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_28_fu_14241_p2() {
    t_V_28_fu_14241_p2 = (!acc_V_28_1_reg_8204.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_28_1_reg_8204.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_29_fu_14261_p2() {
    t_V_29_fu_14261_p2 = (!acc_V_29_1_reg_8194.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_29_1_reg_8194.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_2_fu_10581_p2() {
    t_V_2_fu_10581_p2 = (!ap_const_lv38_1000.is_01() || !tmp_90_fu_10577_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(ap_const_lv38_1000) + sc_biguint<38>(tmp_90_fu_10577_p2.read()));
}

void LcwtMLP_RFFI::thread_t_V_30_fu_14281_p2() {
    t_V_30_fu_14281_p2 = (!acc_V_30_1_reg_8184.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_30_1_reg_8184.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_31_fu_14301_p2() {
    t_V_31_fu_14301_p2 = (!acc_V_31_1_reg_8174.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_31_1_reg_8174.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_32_fu_14321_p2() {
    t_V_32_fu_14321_p2 = (!acc_V_32_1_reg_8164.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_32_1_reg_8164.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_33_fu_14341_p2() {
    t_V_33_fu_14341_p2 = (!acc_V_33_1_reg_8154.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_33_1_reg_8154.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_34_fu_14361_p2() {
    t_V_34_fu_14361_p2 = (!acc_V_34_1_reg_8144.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_34_1_reg_8144.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_35_fu_14381_p2() {
    t_V_35_fu_14381_p2 = (!acc_V_35_1_reg_8134.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_35_1_reg_8134.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_36_fu_14401_p2() {
    t_V_36_fu_14401_p2 = (!acc_V_36_1_reg_8124.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_36_1_reg_8124.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_37_fu_14421_p2() {
    t_V_37_fu_14421_p2 = (!acc_V_37_1_reg_8114.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_37_1_reg_8114.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_38_fu_13717_p2() {
    t_V_38_fu_13717_p2 = (!acc_V_2_1_reg_8465.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_2_1_reg_8465.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_39_fu_13737_p2() {
    t_V_39_fu_13737_p2 = (!acc_V_3_1_reg_8455.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_3_1_reg_8455.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_3_fu_10601_p2() {
    t_V_3_fu_10601_p2 = (!ap_const_lv38_1000.is_01() || !tmp_96_fu_10597_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(ap_const_lv38_1000) + sc_biguint<38>(tmp_96_fu_10597_p2.read()));
}

void LcwtMLP_RFFI::thread_t_V_40_fu_13757_p2() {
    t_V_40_fu_13757_p2 = (!acc_V_4_1_reg_8445.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_4_1_reg_8445.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_41_fu_13777_p2() {
    t_V_41_fu_13777_p2 = (!acc_V_5_1_reg_8435.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_5_1_reg_8435.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_42_fu_13797_p2() {
    t_V_42_fu_13797_p2 = (!acc_V_6_1_reg_8425.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_6_1_reg_8425.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_43_fu_13817_p2() {
    t_V_43_fu_13817_p2 = (!acc_V_7_1_reg_8415.read().is_01() || !ap_const_lv44_8000.is_01())? sc_lv<44>(): (sc_biguint<44>(acc_V_7_1_reg_8415.read()) + sc_biguint<44>(ap_const_lv44_8000));
}

void LcwtMLP_RFFI::thread_t_V_44_fu_13837_p2() {
    t_V_44_fu_13837_p2 = (!acc_V_8_1_reg_8405.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_8_1_reg_8405.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_4_fu_10621_p2() {
    t_V_4_fu_10621_p2 = (!ap_const_lv38_1000.is_01() || !tmp_99_fu_10617_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(ap_const_lv38_1000) + sc_biguint<38>(tmp_99_fu_10617_p2.read()));
}

void LcwtMLP_RFFI::thread_t_V_5_fu_12972_p2() {
    t_V_5_fu_12972_p2 = (!ap_const_lv38_1000.is_01() || !tmp_117_fu_12968_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(ap_const_lv38_1000) + sc_biguint<38>(tmp_117_fu_12968_p2.read()));
}

void LcwtMLP_RFFI::thread_t_V_6_fu_12903_p2() {
    t_V_6_fu_12903_p2 = (!ap_const_lv38_1000.is_01() || !tmp_121_fu_12899_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(ap_const_lv38_1000) + sc_biguint<38>(tmp_121_fu_12899_p2.read()));
}

void LcwtMLP_RFFI::thread_t_V_7_fu_13007_p2() {
    t_V_7_fu_13007_p2 = (!ap_const_lv38_1000.is_01() || !tmp_130_fu_13003_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(ap_const_lv38_1000) + sc_biguint<38>(tmp_130_fu_13003_p2.read()));
}

void LcwtMLP_RFFI::thread_t_V_8_fu_12932_p2() {
    t_V_8_fu_12932_p2 = (!ap_const_lv38_1000.is_01() || !tmp_133_fu_12928_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(ap_const_lv38_1000) + sc_biguint<38>(tmp_133_fu_12928_p2.read()));
}

void LcwtMLP_RFFI::thread_t_V_9_fu_13857_p2() {
    t_V_9_fu_13857_p2 = (!acc_V_9_1_reg_8395.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_9_1_reg_8395.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_fu_13677_p2() {
    t_V_fu_13677_p2 = (!acc_V_0_1_reg_8485.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_0_1_reg_8485.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_V_s_fu_13697_p2() {
    t_V_s_fu_13697_p2 = (!acc_V_1_1_reg_8475.read().is_01() || !ap_const_lv43_8000.is_01())? sc_lv<43>(): (sc_biguint<43>(acc_V_1_1_reg_8475.read()) + sc_biguint<43>(ap_const_lv43_8000));
}

void LcwtMLP_RFFI::thread_t_fu_14534_p2() {
    t_fu_14534_p2 = (!ap_const_lv5_1.is_01() || !ap_phi_mux_t_0_i_phi_fu_8532_p4.read().is_01())? sc_lv<5>(): (sc_biguint<5>(ap_const_lv5_1) + sc_biguint<5>(ap_phi_mux_t_0_i_phi_fu_8532_p4.read()));
}

void LcwtMLP_RFFI::thread_tmp10_fu_10502_p2() {
    tmp10_fu_10502_p2 = (!tmp_196_fu_10421_p1.read().is_01() || !tmp_197_fu_10425_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_196_fu_10421_p1.read()) + sc_biguint<38>(tmp_197_fu_10425_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp11_fu_10519_p2() {
    tmp11_fu_10519_p2 = (!tmp12_reg_17813.read().is_01() || !tmp13_fu_10513_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp12_reg_17813.read()) + sc_biguint<38>(tmp13_fu_10513_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp12_fu_10331_p2() {
    tmp12_fu_10331_p2 = (!tmp_206_fu_10271_p1.read().is_01() || !tmp_207_fu_10275_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_206_fu_10271_p1.read()) + sc_biguint<38>(tmp_207_fu_10275_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp13_fu_10513_p2() {
    tmp13_fu_10513_p2 = (!tmp_204_fu_10437_p1.read().is_01() || !tmp_205_fu_10441_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_204_fu_10437_p1.read()) + sc_biguint<38>(tmp_205_fu_10441_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp14_fu_10530_p2() {
    tmp14_fu_10530_p2 = (!tmp15_reg_17818.read().is_01() || !tmp16_fu_10524_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp15_reg_17818.read()) + sc_biguint<38>(tmp16_fu_10524_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp15_fu_10337_p2() {
    tmp15_fu_10337_p2 = (!tmp_209_fu_10283_p1.read().is_01() || !tmp_208_fu_10279_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_209_fu_10283_p1.read()) + sc_biguint<38>(tmp_208_fu_10279_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp16_fu_10524_p2() {
    tmp16_fu_10524_p2 = (!tmp_211_fu_10449_p1.read().is_01() || !tmp_210_fu_10445_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_211_fu_10449_p1.read()) + sc_biguint<38>(tmp_210_fu_10445_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp17_fu_10541_p2() {
    tmp17_fu_10541_p2 = (!tmp18_reg_17828.read().is_01() || !tmp19_fu_10535_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp18_reg_17828.read()) + sc_biguint<38>(tmp19_fu_10535_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp18_fu_10347_p2() {
    tmp18_fu_10347_p2 = (!tmp_187_fu_10239_p1.read().is_01() || !tmp_188_fu_10243_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_187_fu_10239_p1.read()) + sc_biguint<38>(tmp_188_fu_10243_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp190_fu_12988_p2() {
    tmp190_fu_12988_p2 = (tmp_255_fu_12953_p2.read() | ap_const_lv8_1);
}

void LcwtMLP_RFFI::thread_tmp19_fu_10535_p2() {
    tmp19_fu_10535_p2 = (!tmp_185_fu_10405_p1.read().is_01() || !tmp_186_fu_10409_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_185_fu_10405_p1.read()) + sc_biguint<38>(tmp_186_fu_10409_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp20_fu_10552_p2() {
    tmp20_fu_10552_p2 = (!tmp21_reg_17833.read().is_01() || !tmp22_fu_10546_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp21_reg_17833.read()) + sc_biguint<38>(tmp22_fu_10546_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp21_fu_10353_p2() {
    tmp21_fu_10353_p2 = (!tmp_190_fu_10251_p1.read().is_01() || !tmp_189_fu_10247_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_190_fu_10251_p1.read()) + sc_biguint<38>(tmp_189_fu_10247_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp22_fu_10546_p2() {
    tmp22_fu_10546_p2 = (!tmp_193_fu_10417_p1.read().is_01() || !tmp_191_fu_10413_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_193_fu_10417_p1.read()) + sc_biguint<38>(tmp_191_fu_10413_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp23_fu_11297_p2() {
    tmp23_fu_11297_p2 = (!ap_const_lv4_9.is_01() || !j_0_i47_i_i_reg_5511.read().is_01())? sc_lv<4>(): (sc_bigint<4>(ap_const_lv4_9) + sc_biguint<4>(j_0_i47_i_i_reg_5511.read()));
}

void LcwtMLP_RFFI::thread_tmp24_fu_12894_p2() {
    tmp24_fu_12894_p2 = (!tmp_252_reg_18685.read().is_01() || !tmp_116_fu_12890_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_252_reg_18685.read()) + sc_biguint<38>(tmp_116_fu_12890_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp25_fu_12831_p2() {
    tmp25_fu_12831_p2 = (!tmp27_reg_18649.read().is_01() || !tmp26_fu_12825_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp27_reg_18649.read()) + sc_biguint<38>(tmp26_fu_12825_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp26_fu_12825_p2() {
    tmp26_fu_12825_p2 = (!tmp_245_fu_12768_p1.read().is_01() || !tmp_244_fu_12764_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_245_fu_12768_p1.read()) + sc_biguint<38>(tmp_244_fu_12764_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp27_fu_12681_p2() {
    tmp27_fu_12681_p2 = (!tmp_240_fu_12641_p1.read().is_01() || !tmp_241_fu_12645_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_240_fu_12641_p1.read()) + sc_biguint<38>(tmp_241_fu_12645_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp28_fu_12842_p2() {
    tmp28_fu_12842_p2 = (!tmp30_reg_18654.read().is_01() || !tmp29_fu_12836_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp30_reg_18654.read()) + sc_biguint<38>(tmp29_fu_12836_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp29_fu_12836_p2() {
    tmp29_fu_12836_p2 = (!tmp_238_fu_12756_p1.read().is_01() || !tmp_239_fu_12760_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_238_fu_12756_p1.read()) + sc_biguint<38>(tmp_239_fu_12760_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp2_fu_9280_p2() {
    tmp2_fu_9280_p2 = (!ap_const_lv5_19.is_01() || !k9_0_i_i_i_reg_2596.read().is_01())? sc_lv<5>(): (sc_bigint<5>(ap_const_lv5_19) + sc_biguint<5>(k9_0_i_i_i_reg_2596.read()));
}

void LcwtMLP_RFFI::thread_tmp30_fu_12687_p2() {
    tmp30_fu_12687_p2 = (!tmp_242_fu_12649_p1.read().is_01() || !tmp_243_fu_12653_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_242_fu_12649_p1.read()) + sc_biguint<38>(tmp_243_fu_12653_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp3139_cast_fu_12994_p1() {
    tmp3139_cast_fu_12994_p1 = esl_zext<10,8>(tmp190_fu_12988_p2.read());
}

void LcwtMLP_RFFI::thread_tmp32_fu_12923_p2() {
    tmp32_fu_12923_p2 = (!tmp_236_reg_18675.read().is_01() || !tmp_129_fu_12919_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_236_reg_18675.read()) + sc_biguint<38>(tmp_129_fu_12919_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp33_fu_12858_p2() {
    tmp33_fu_12858_p2 = (!tmp35_reg_18659.read().is_01() || !tmp34_fu_12852_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp35_reg_18659.read()) + sc_biguint<38>(tmp34_fu_12852_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp34_fu_12852_p2() {
    tmp34_fu_12852_p2 = (!tmp_229_fu_12728_p1.read().is_01() || !tmp_228_fu_12724_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_229_fu_12728_p1.read()) + sc_biguint<38>(tmp_228_fu_12724_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp35_fu_12693_p2() {
    tmp35_fu_12693_p2 = (!tmp_224_fu_12617_p1.read().is_01() || !tmp_225_fu_12621_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_224_fu_12617_p1.read()) + sc_biguint<38>(tmp_225_fu_12621_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp36_fu_12869_p2() {
    tmp36_fu_12869_p2 = (!tmp38_reg_18664.read().is_01() || !tmp37_fu_12863_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp38_reg_18664.read()) + sc_biguint<38>(tmp37_fu_12863_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp37_fu_12863_p2() {
    tmp37_fu_12863_p2 = (!tmp_222_fu_12716_p1.read().is_01() || !tmp_223_fu_12720_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_222_fu_12716_p1.read()) + sc_biguint<38>(tmp_223_fu_12720_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp38_fu_12699_p2() {
    tmp38_fu_12699_p2 = (!tmp_226_fu_12625_p1.read().is_01() || !tmp_227_fu_12629_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_226_fu_12625_p1.read()) + sc_biguint<38>(tmp_227_fu_12629_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp3_fu_10303_p2() {
    tmp3_fu_10303_p2 = (!tmp_218_fu_10295_p1.read().is_01() || !tmp_219_fu_10299_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_218_fu_10295_p1.read()) + sc_biguint<38>(tmp_219_fu_10299_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp4_fu_10469_p2() {
    tmp4_fu_10469_p2 = (!tmp_216_fu_10461_p1.read().is_01() || !tmp_217_fu_10465_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_216_fu_10461_p1.read()) + sc_biguint<38>(tmp_217_fu_10465_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp5_fu_10309_p2() {
    tmp5_fu_10309_p2 = (!tmp_214_fu_10287_p1.read().is_01() || !tmp_215_fu_10291_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_214_fu_10287_p1.read()) + sc_biguint<38>(tmp_215_fu_10291_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp6_fu_10480_p2() {
    tmp6_fu_10480_p2 = (!tmp_212_fu_10453_p1.read().is_01() || !tmp_213_fu_10457_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_212_fu_10453_p1.read()) + sc_biguint<38>(tmp_213_fu_10457_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp7_fu_10315_p2() {
    tmp7_fu_10315_p2 = (!tmp_202_fu_10263_p1.read().is_01() || !tmp_203_fu_10267_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_202_fu_10263_p1.read()) + sc_biguint<38>(tmp_203_fu_10267_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp8_fu_10491_p2() {
    tmp8_fu_10491_p2 = (!tmp_200_fu_10429_p1.read().is_01() || !tmp_201_fu_10433_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_200_fu_10429_p1.read()) + sc_biguint<38>(tmp_201_fu_10433_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp9_fu_10321_p2() {
    tmp9_fu_10321_p2 = (!tmp_198_fu_10255_p1.read().is_01() || !tmp_199_fu_10259_p1.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_198_fu_10255_p1.read()) + sc_biguint<38>(tmp_199_fu_10259_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp_100_fu_13843_p4() {
    tmp_100_fu_13843_p4 = t_V_44_fu_13837_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_102_fu_13863_p4() {
    tmp_102_fu_13863_p4 = t_V_9_fu_13857_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_103_fu_13883_p4() {
    tmp_103_fu_13883_p4 = t_V_10_fu_13877_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_104_fu_10365_p2() {
    tmp_104_fu_10365_p2 = (!ap_const_lv8_9.is_01() || !tmp_220_fu_10359_p2.read().is_01())? sc_lv<8>(): (sc_biguint<8>(ap_const_lv8_9) + sc_biguint<8>(tmp_220_fu_10359_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp_105_fu_10371_p2() {
    tmp_105_fu_10371_p2 = (tmp_104_fu_10365_p2.read() & tmp_11_cast_reg_17401.read());
}

void LcwtMLP_RFFI::thread_tmp_106_fu_10385_p2() {
    tmp_106_fu_10385_p2 = (!ap_const_lv8_A.is_01() || !tmp_220_fu_10359_p2.read().is_01())? sc_lv<8>(): (sc_biguint<8>(ap_const_lv8_A) + sc_biguint<8>(tmp_220_fu_10359_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp_107_cast_fu_10376_p1() {
    tmp_107_cast_fu_10376_p1 = esl_zext<10,8>(tmp_105_fu_10371_p2.read());
}

void LcwtMLP_RFFI::thread_tmp_107_fu_10391_p2() {
    tmp_107_fu_10391_p2 = (tmp_106_fu_10385_p2.read() & tmp_11_cast_reg_17401.read());
}

void LcwtMLP_RFFI::thread_tmp_108_fu_10647_p1() {
    tmp_108_fu_10647_p1 = esl_zext<64,10>(i0_reg_17838.read());
}

void LcwtMLP_RFFI::thread_tmp_109_cast_fu_10396_p1() {
    tmp_109_cast_fu_10396_p1 = esl_zext<10,8>(tmp_107_fu_10391_p2.read());
}

void LcwtMLP_RFFI::thread_tmp_109_fu_10652_p1() {
    tmp_109_fu_10652_p1 = esl_zext<64,10>(i1_reg_17843.read());
}

void LcwtMLP_RFFI::thread_tmp_111_fu_13903_p4() {
    tmp_111_fu_13903_p4 = t_V_11_fu_13897_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_112_fu_13923_p4() {
    tmp_112_fu_13923_p4 = t_V_12_fu_13917_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_113_fu_12963_p2() {
    tmp_113_fu_12963_p2 = (!ooff_1_cast_reg_18138.read().is_01() || !tmp_114_cast_fu_12959_p1.read().is_01())? sc_lv<10>(): (sc_biguint<10>(ooff_1_cast_reg_18138.read()) + sc_biguint<10>(tmp_114_cast_fu_12959_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp_114_cast_fu_12959_p1() {
    tmp_114_cast_fu_12959_p1 = esl_zext<10,8>(tmp_255_fu_12953_p2.read());
}

void LcwtMLP_RFFI::thread_tmp_114_fu_13023_p1() {
    tmp_114_fu_13023_p1 = esl_zext<64,10>(tmp_113_reg_18775.read());
}

void LcwtMLP_RFFI::thread_tmp_115_fu_12820_p2() {
    tmp_115_fu_12820_p2 = (!s2_V_1_1_reg_18639.read().is_01() || !s3_V_1_1_fu_12802_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(s2_V_1_1_reg_18639.read()) - sc_biguint<38>(s3_V_1_1_fu_12802_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp_116_fu_12890_p2() {
    tmp_116_fu_12890_p2 = (!tmp_115_reg_18705.read().is_01() || !s1_V_1_1_reg_18695.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_115_reg_18705.read()) - sc_biguint<38>(s1_V_1_1_reg_18695.read()));
}

void LcwtMLP_RFFI::thread_tmp_117_fu_12968_p2() {
    tmp_117_fu_12968_p2 = (!tmp24_reg_18745.read().is_01() || !tmp_253_reg_18690.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp24_reg_18745.read()) + sc_biguint<38>(tmp_253_reg_18690.read()));
}

void LcwtMLP_RFFI::thread_tmp_118_fu_13943_p4() {
    tmp_118_fu_13943_p4 = t_V_13_fu_13937_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_11_cast_fu_9262_p2() {
    tmp_11_cast_fu_9262_p2 = (!ap_const_lv8_FF.is_01() || !tmp_27_fu_9259_p1.read().is_01())? sc_lv<8>(): (sc_bigint<8>(ap_const_lv8_FF) + sc_biguint<8>(tmp_27_fu_9259_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp_120_fu_13963_p4() {
    tmp_120_fu_13963_p4 = t_V_14_fu_13957_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_121_fu_12899_p2() {
    tmp_121_fu_12899_p2 = (!tmp28_reg_18715.read().is_01() || !tmp25_reg_18710.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp28_reg_18715.read()) + sc_biguint<38>(tmp25_reg_18710.read()));
}

void LcwtMLP_RFFI::thread_tmp_122_1_cast_fu_9999_p1() {
    tmp_122_1_cast_fu_9999_p1 = esl_sext<41,16>(w0r_V_1_phi_fu_9915_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_122_2_cast_fu_10107_p1() {
    tmp_122_2_cast_fu_10107_p1 = esl_sext<41,16>(w0r_V_2_phi_fu_10023_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_122_3_cast_fu_10215_p1() {
    tmp_122_3_cast_fu_10215_p1 = esl_sext<41,16>(w0r_V_3_phi_fu_10131_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_122_fu_13983_p4() {
    tmp_122_fu_13983_p4 = t_V_15_fu_13977_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_123_1_cast_fu_10003_p1() {
    tmp_123_1_cast_fu_10003_p1 = esl_sext<41,25>(wr_V_load_14_1_phi_fu_9971_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_123_2_cast_fu_10111_p1() {
    tmp_123_2_cast_fu_10111_p1 = esl_sext<41,25>(wr_V_load_14_2_phi_fu_10079_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_123_3_cast_fu_10219_p1() {
    tmp_123_3_cast_fu_10219_p1 = esl_sext<41,25>(wr_V_load_14_3_phi_fu_10187_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_124_fu_14003_p4() {
    tmp_124_fu_14003_p4 = t_V_16_fu_13997_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_125_fu_12998_p2() {
    tmp_125_fu_12998_p2 = (!tmp3139_cast_fu_12994_p1.read().is_01() || !ooff_1_cast_reg_18138.read().is_01())? sc_lv<10>(): (sc_biguint<10>(tmp3139_cast_fu_12994_p1.read()) + sc_biguint<10>(ooff_1_cast_reg_18138.read()));
}

void LcwtMLP_RFFI::thread_tmp_126_1_cast_fu_10007_p1() {
    tmp_126_1_cast_fu_10007_p1 = esl_sext<41,16>(w0i_V_1_phi_fu_9929_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_126_2_cast_fu_10115_p1() {
    tmp_126_2_cast_fu_10115_p1 = esl_sext<41,16>(w0i_V_2_phi_fu_10037_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_126_3_cast_fu_10223_p1() {
    tmp_126_3_cast_fu_10223_p1 = esl_sext<41,16>(w0i_V_3_phi_fu_10145_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_126_fu_14023_p4() {
    tmp_126_fu_14023_p4 = t_V_17_fu_14017_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_127_1_cast_fu_10011_p1() {
    tmp_127_1_cast_fu_10011_p1 = esl_sext<41,25>(wi_V_load_14_1_phi_fu_9985_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_127_2_cast_fu_10119_p1() {
    tmp_127_2_cast_fu_10119_p1 = esl_sext<41,25>(wi_V_load_14_2_phi_fu_10093_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_127_3_cast_fu_10227_p1() {
    tmp_127_3_cast_fu_10227_p1 = esl_sext<41,25>(wi_V_load_14_3_phi_fu_10201_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_127_fu_13028_p1() {
    tmp_127_fu_13028_p1 = esl_zext<64,10>(tmp_125_reg_18785.read());
}

void LcwtMLP_RFFI::thread_tmp_128_fu_12847_p2() {
    tmp_128_fu_12847_p2 = (!s10_V_1_reg_18644.read().is_01() || !s11_V_1_fu_12814_p2.read().is_01())? sc_lv<38>(): (sc_biguint<38>(s10_V_1_reg_18644.read()) - sc_biguint<38>(s11_V_1_fu_12814_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp_129_fu_12919_p2() {
    tmp_129_fu_12919_p2 = (!tmp_128_reg_18720.read().is_01() || !s9_V_1_reg_18700.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp_128_reg_18720.read()) - sc_biguint<38>(s9_V_1_reg_18700.read()));
}

void LcwtMLP_RFFI::thread_tmp_130_fu_13003_p2() {
    tmp_130_fu_13003_p2 = (!tmp32_reg_18755.read().is_01() || !tmp_237_reg_18680.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp32_reg_18755.read()) + sc_biguint<38>(tmp_237_reg_18680.read()));
}

void LcwtMLP_RFFI::thread_tmp_131_fu_14043_p4() {
    tmp_131_fu_14043_p4 = t_V_18_fu_14037_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_133_fu_12928_p2() {
    tmp_133_fu_12928_p2 = (!tmp36_reg_18730.read().is_01() || !tmp33_reg_18725.read().is_01())? sc_lv<38>(): (sc_biguint<38>(tmp36_reg_18730.read()) + sc_biguint<38>(tmp33_reg_18725.read()));
}

void LcwtMLP_RFFI::thread_tmp_134_1_cast_fu_10015_p1() {
    tmp_134_1_cast_fu_10015_p1 = esl_sext<41,16>(w1r_V_1_phi_fu_9943_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_134_2_cast_fu_10123_p1() {
    tmp_134_2_cast_fu_10123_p1 = esl_sext<41,16>(w1r_V_2_phi_fu_10051_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_134_3_cast_fu_10231_p1() {
    tmp_134_3_cast_fu_10231_p1 = esl_sext<41,16>(w1r_V_3_phi_fu_10159_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_134_fu_14063_p4() {
    tmp_134_fu_14063_p4 = t_V_19_fu_14057_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_136_fu_12880_p2() {
    tmp_136_fu_12880_p2 = (!ioff_1_cast_reg_18132.read().is_01() || !nn_cast_fu_12877_p1.read().is_01())? sc_lv<10>(): (sc_biguint<10>(ioff_1_cast_reg_18132.read()) + sc_biguint<10>(nn_cast_fu_12877_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp_137_1_cast_fu_10019_p1() {
    tmp_137_1_cast_fu_10019_p1 = esl_sext<41,16>(w1i_V_1_phi_fu_9957_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_137_2_cast_fu_10127_p1() {
    tmp_137_2_cast_fu_10127_p1 = esl_sext<41,16>(w1i_V_2_phi_fu_10065_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_137_3_cast_fu_10235_p1() {
    tmp_137_3_cast_fu_10235_p1 = esl_sext<41,16>(w1i_V_3_phi_fu_10173_p6.read());
}

void LcwtMLP_RFFI::thread_tmp_137_fu_14083_p4() {
    tmp_137_fu_14083_p4 = t_V_20_fu_14077_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_138_fu_14103_p4() {
    tmp_138_fu_14103_p4 = t_V_21_fu_14097_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_139_fu_13033_p1() {
    tmp_139_fu_13033_p1 = esl_zext<64,10>(tmp_136_reg_18735.read());
}

void LcwtMLP_RFFI::thread_tmp_13_cast_fu_11279_p2() {
    tmp_13_cast_fu_11279_p2 = (!ap_const_lv7_7F.is_01() || !tmp_36_fu_11276_p1.read().is_01())? sc_lv<7>(): (sc_bigint<7>(ap_const_lv7_7F) + sc_biguint<7>(tmp_36_fu_11276_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp_140_fu_12885_p2() {
    tmp_140_fu_12885_p2 = (!hoff_1_reg_18149.read().is_01() || !nn_cast1_fu_12874_p1.read().is_01())? sc_lv<32>(): (sc_biguint<32>(hoff_1_reg_18149.read()) + sc_biguint<32>(nn_cast1_fu_12874_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp_141_fu_12948_p1() {
    tmp_141_fu_12948_p1 = esl_zext<64,32>(tmp_140_reg_18740.read());
}

void LcwtMLP_RFFI::thread_tmp_143_fu_14123_p4() {
    tmp_143_fu_14123_p4 = t_V_22_fu_14117_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_144_fu_11545_p3() {
    tmp_144_fu_11545_p3 = esl_concat<2,2>(tmp_256_fu_11541_p1.read(), ap_const_lv2_0);
}

void LcwtMLP_RFFI::thread_tmp_148_fu_14147_p4() {
    tmp_148_fu_14147_p4 = t_V_23_fu_14141_p2.read().range(44, 16);
}

void LcwtMLP_RFFI::thread_tmp_14_fu_8795_p3() {
    tmp_14_fu_8795_p3 = esl_concat<2,2>(tmp_18_fu_8777_p1.read(), ap_const_lv2_0);
}

void LcwtMLP_RFFI::thread_tmp_151_cast_fu_9891_p1() {
    tmp_151_cast_fu_9891_p1 = esl_sext<41,16>(ap_phi_mux_w0r_V_0_phi_phi_fu_5477_p8.read());
}

void LcwtMLP_RFFI::thread_tmp_151_fu_14167_p4() {
    tmp_151_fu_14167_p4 = t_V_24_fu_14161_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_152_cast_fu_9895_p1() {
    tmp_152_cast_fu_9895_p1 = esl_sext<41,25>(wr_V_load_14_0_phi_fu_9815_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_154_cast_fu_9899_p1() {
    tmp_154_cast_fu_9899_p1 = esl_sext<41,16>(w0i_V_0_phi_fu_9701_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_154_fu_14187_p4() {
    tmp_154_fu_14187_p4 = t_V_25_fu_14181_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_155_cast_fu_9903_p1() {
    tmp_155_cast_fu_9903_p1 = esl_sext<41,25>(wi_V_load_14_0_phi_fu_9853_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_155_fu_14207_p4() {
    tmp_155_fu_14207_p4 = t_V_26_fu_14201_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_159_cast_fu_9907_p1() {
    tmp_159_cast_fu_9907_p1 = esl_sext<41,16>(w1r_V_0_phi_fu_9739_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_161_cast_fu_9911_p1() {
    tmp_161_cast_fu_9911_p1 = esl_sext<41,16>(w1i_V_0_phi_fu_9777_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_161_fu_14227_p4() {
    tmp_161_fu_14227_p4 = t_V_27_fu_14221_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_165_fu_14247_p4() {
    tmp_165_fu_14247_p4 = t_V_28_fu_14241_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_166_cast_fu_12105_p1() {
    tmp_166_cast_fu_12105_p1 = esl_sext<41,16>(ap_phi_mux_s0rE_V_0_phi_phi_fu_7624_p8.read());
}

void LcwtMLP_RFFI::thread_tmp_167_cast_fu_12109_p1() {
    tmp_167_cast_fu_12109_p1 = esl_sext<41,25>(wlr_V_load_7_0_phi_fu_12017_p10.read());
}

void LcwtMLP_RFFI::thread_tmp_167_fu_14267_p4() {
    tmp_167_fu_14267_p4 = t_V_29_fu_14261_p2.read().range(42, 16);
}

void LcwtMLP_RFFI::thread_tmp_169_cast_fu_12113_p1() {
    tmp_169_cast_fu_12113_p1 = esl_sext<41,16>(s0iE_V_0_phi_fu_11739_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_169_fu_14287_p4() {
    tmp_169_fu_14287_p4 = t_V_30_fu_14281_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_16_cast_fu_9290_p2() {
    tmp_16_cast_fu_9290_p2 = (!tmp_45_fu_9286_p1.read().is_01() || !tmp_27_reg_17396.read().is_01())? sc_lv<8>(): (sc_bigint<8>(tmp_45_fu_9286_p1.read()) + sc_biguint<8>(tmp_27_reg_17396.read()));
}

void LcwtMLP_RFFI::thread_tmp_16_fu_10812_p3() {
    tmp_16_fu_10812_p3 = esl_concat<2,2>(tmp_23_fu_10794_p1.read(), ap_const_lv2_0);
}

void LcwtMLP_RFFI::thread_tmp_170_cast_fu_12117_p1() {
    tmp_170_cast_fu_12117_p1 = esl_sext<41,25>(wli_V_load_7_0_phi_fu_12039_p10.read());
}

void LcwtMLP_RFFI::thread_tmp_172_cast_fu_12121_p1() {
    tmp_172_cast_fu_12121_p1 = esl_sext<41,16>(s1rE_V_0_phi_fu_11777_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_172_fu_14307_p4() {
    tmp_172_fu_14307_p4 = t_V_31_fu_14301_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_173_cast_fu_12125_p1() {
    tmp_173_cast_fu_12125_p1 = esl_sext<41,25>(whr_V_load_7_0_phi_fu_12061_p10.read());
}

void LcwtMLP_RFFI::thread_tmp_173_fu_14327_p4() {
    tmp_173_fu_14327_p4 = t_V_32_fu_14321_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_175_cast_fu_12129_p1() {
    tmp_175_cast_fu_12129_p1 = esl_sext<41,16>(s1iE_V_0_phi_fu_11815_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_176_cast_fu_12133_p1() {
    tmp_176_cast_fu_12133_p1 = esl_sext<41,25>(whi_V_load_7_0_phi_fu_12083_p10.read());
}

void LcwtMLP_RFFI::thread_tmp_176_fu_14347_p4() {
    tmp_176_fu_14347_p4 = t_V_33_fu_14341_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_17_cast_fu_9300_p1() {
    tmp_17_cast_fu_9300_p1 = esl_zext<10,8>(tmp_17_fu_9295_p2.read());
}

void LcwtMLP_RFFI::thread_tmp_17_fu_9295_p2() {
    tmp_17_fu_9295_p2 = (tmp_16_cast_fu_9290_p2.read() & tmp_11_cast_reg_17401.read());
}

void LcwtMLP_RFFI::thread_tmp_180_0_t_fu_11553_p2() {
    tmp_180_0_t_fu_11553_p2 = (!ap_const_lv4_E.is_01() || !tmp_144_fu_11545_p3.read().is_01())? sc_lv<4>(): (sc_bigint<4>(ap_const_lv4_E) - sc_biguint<4>(tmp_144_fu_11545_p3.read()));
}

void LcwtMLP_RFFI::thread_tmp_180_1_t_fu_12159_p2() {
    tmp_180_1_t_fu_12159_p2 = (!ap_const_lv4_E.is_01() || !tmp_180_fu_12153_p2.read().is_01())? sc_lv<4>(): (sc_bigint<4>(ap_const_lv4_E) - sc_biguint<4>(tmp_180_fu_12153_p2.read()));
}

void LcwtMLP_RFFI::thread_tmp_180_fu_12153_p2() {
    tmp_180_fu_12153_p2 = (tmp_144_fu_11545_p3.read() | ap_const_lv4_2);
}

void LcwtMLP_RFFI::thread_tmp_181_fu_14367_p4() {
    tmp_181_fu_14367_p4 = t_V_34_fu_14361_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_182_0_t_fu_11853_p2() {
    tmp_182_0_t_fu_11853_p2 = (tmp_144_fu_11545_p3.read() ^ ap_const_lv4_F);
}

void LcwtMLP_RFFI::thread_tmp_182_1_t_fu_12317_p2() {
    tmp_182_1_t_fu_12317_p2 = (tmp_144_fu_11545_p3.read() ^ ap_const_lv4_D);
}

void LcwtMLP_RFFI::thread_tmp_182_cast_fu_12137_p1() {
    tmp_182_cast_fu_12137_p1 = esl_sext<41,16>(s0rO_V_0_phi_fu_11859_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_182_fu_14387_p4() {
    tmp_182_fu_14387_p4 = t_V_35_fu_14381_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_183_fu_14407_p4() {
    tmp_183_fu_14407_p4 = t_V_36_fu_14401_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_184_cast_fu_12141_p1() {
    tmp_184_cast_fu_12141_p1 = esl_sext<41,16>(s0iO_V_0_phi_fu_11897_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_184_fu_14427_p4() {
    tmp_184_fu_14427_p4 = t_V_37_fu_14421_p2.read().range(43, 16);
}

void LcwtMLP_RFFI::thread_tmp_185_fu_10405_p1() {
    tmp_185_fu_10405_p1 = ac_V_7_3_reg_5079.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_186_1_cast_fu_12569_p1() {
    tmp_186_1_cast_fu_12569_p1 = esl_sext<41,16>(s0rE_V_1_phi_fu_12165_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_186_cast_fu_12145_p1() {
    tmp_186_cast_fu_12145_p1 = esl_sext<41,16>(s1rO_V_0_phi_fu_11935_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_186_fu_10409_p1() {
    tmp_186_fu_10409_p1 = ac_V_7_2_reg_5091.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_187_1_cast_fu_12573_p1() {
    tmp_187_1_cast_fu_12573_p1 = esl_sext<41,25>(wlr_V_load_7_1_phi_fu_12481_p10.read());
}

void LcwtMLP_RFFI::thread_tmp_187_fu_10239_p1() {
    tmp_187_fu_10239_p1 = ac_V_7_1_reg_5103.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_188_cast_fu_12149_p1() {
    tmp_188_cast_fu_12149_p1 = esl_sext<41,16>(s1iO_V_0_phi_fu_11973_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_188_fu_10243_p1() {
    tmp_188_fu_10243_p1 = ac_V_7_reg_5115.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_189_fu_10247_p1() {
    tmp_189_fu_10247_p1 = ac_V_6_3_reg_5127.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_18_fu_8777_p1() {
    tmp_18_fu_8777_p1 = lv_0_i_i_i_reg_2572.read().range(2-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_190_1_cast_fu_12577_p1() {
    tmp_190_1_cast_fu_12577_p1 = esl_sext<41,16>(s0iE_V_1_phi_fu_12203_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_190_fu_10251_p1() {
    tmp_190_fu_10251_p1 = ac_V_6_2_reg_5139.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_191_1_cast_fu_12581_p1() {
    tmp_191_1_cast_fu_12581_p1 = esl_sext<41,25>(wli_V_load_7_1_phi_fu_12503_p10.read());
}

void LcwtMLP_RFFI::thread_tmp_191_fu_10413_p1() {
    tmp_191_fu_10413_p1 = ac_V_6_1_reg_5151.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_192_fu_14457_p3() {
    tmp_192_fu_14457_p3 = esl_concat<6,4>(d7_0_i_i_i_reg_8506.read(), ap_const_lv4_0);
}

void LcwtMLP_RFFI::thread_tmp_193_cast8_fu_14465_p1() {
    tmp_193_cast8_fu_14465_p1 = esl_zext<11,10>(tmp_192_fu_14457_p3.read());
}

void LcwtMLP_RFFI::thread_tmp_193_fu_10417_p1() {
    tmp_193_fu_10417_p1 = ac_V_6_reg_5163.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_194_1_cast_fu_12585_p1() {
    tmp_194_1_cast_fu_12585_p1 = esl_sext<41,16>(s1rE_V_1_phi_fu_12241_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_194_cast_fu_14518_p1() {
    tmp_194_cast_fu_14518_p1 = esl_zext<64,11>(tmp_194_reg_20512.read());
}

void LcwtMLP_RFFI::thread_tmp_194_fu_14469_p2() {
    tmp_194_fu_14469_p2 = (!tmp_66_cast_reg_20498.read().is_01() || !tmp_193_cast8_fu_14465_p1.read().is_01())? sc_lv<11>(): (sc_biguint<11>(tmp_66_cast_reg_20498.read()) + sc_biguint<11>(tmp_193_cast8_fu_14465_p1.read()));
}

void LcwtMLP_RFFI::thread_tmp_195_1_cast_fu_12589_p1() {
    tmp_195_1_cast_fu_12589_p1 = esl_sext<41,25>(whr_V_load_7_1_phi_fu_12525_p10.read());
}

void LcwtMLP_RFFI::thread_tmp_196_fu_10421_p1() {
    tmp_196_fu_10421_p1 = ac_V_5_3_reg_5175.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_197_fu_10425_p1() {
    tmp_197_fu_10425_p1 = ac_V_5_2_reg_5187.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_198_1_cast_fu_12593_p1() {
    tmp_198_1_cast_fu_12593_p1 = esl_sext<41,16>(s1iE_V_1_phi_fu_12279_p18.read());
}

void LcwtMLP_RFFI::thread_tmp_198_fu_10255_p1() {
    tmp_198_fu_10255_p1 = ac_V_5_1_reg_5199.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_199_1_cast_fu_12597_p1() {
    tmp_199_1_cast_fu_12597_p1 = esl_sext<41,25>(whi_V_load_7_1_phi_fu_12547_p10.read());
}

void LcwtMLP_RFFI::thread_tmp_199_fu_10259_p1() {
    tmp_199_fu_10259_p1 = ac_V_5_reg_5211.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_19_fu_9313_p1() {
    tmp_19_fu_9313_p1 = esl_zext<64,10>(idx_reg_17417.read());
}

void LcwtMLP_RFFI::thread_tmp_1_fu_8623_p1() {
    tmp_1_fu_8623_p1 = esl_sext<25,16>(xr0_V_load_reg_17098.read());
}

void LcwtMLP_RFFI::thread_tmp_200_fu_10429_p1() {
    tmp_200_fu_10429_p1 = ac_V_4_3_reg_5223.read().range(38-1, 0);
}

void LcwtMLP_RFFI::thread_tmp_201_fu_10433_p1() {
    tmp_201_fu_10433_p1 = ac_V_4_2_reg_5235.read().range(38-1, 0);
}

}

