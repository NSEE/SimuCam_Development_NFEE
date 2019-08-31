/*
 * comm.h
 *
 *  Created on: 18/12/2018
 *      Author: rfranca
 */

#ifndef COMM_H_
#define COMM_H_

#include "../../simucam_definitions.h"


//! [constants definition]
// irq numbers
#define COMM_CH_1_RMAP_IRQ              15
#define COMM_CH_1_BUFFERS_IRQ           5
#define COMM_CH_2_RMAP_IRQ              16
#define COMM_CH_2_BUFFERS_IRQ           6
#define COMM_CH_3_RMAP_IRQ              17
#define COMM_CH_3_BUFFERS_IRQ           7
#define COMM_CH_4_RMAP_IRQ              18
#define COMM_CH_4_BUFFERS_IRQ           8
#define COMM_CH_5_RMAP_IRQ              19
#define COMM_CH_5_BUFFERS_IRQ           9
#define COMM_CH_6_RMAP_IRQ              20
#define COMM_CH_6_BUFFERS_IRQ           10
#define COMM_CH_7_RMAP_IRQ              -1
#define COMM_CH_7_BUFFERS_IRQ           -1
#define COMM_CH_8_RMAP_IRQ              -1
#define COMM_CH_8_BUFFERS_IRQ           -1
// address
#define COMM_CHANNEL_1_BASE_ADDR        COMM_PEDREIRO_V1_01_A_BASE
#define COMM_CHANNEL_2_BASE_ADDR        COMM_PEDREIRO_V1_01_B_BASE
#define COMM_CHANNEL_3_BASE_ADDR        COMM_PEDREIRO_V1_01_C_BASE
#define COMM_CHANNEL_4_BASE_ADDR        COMM_PEDREIRO_V1_01_D_BASE
#define COMM_CHANNEL_5_BASE_ADDR        COMM_PEDREIRO_V1_01_E_BASE
#define COMM_CHANNEL_6_BASE_ADDR        COMM_PEDREIRO_V1_01_F_BASE
#define COMM_CHANNEL_7_BASE_ADDR        COMM_PEDREIRO_V1_01_A_BASE
#define COMM_CHANNEL_8_BASE_ADDR        COMM_PEDREIRO_V1_01_B_BASE
// RMAP config addr
#define COMM_RMAP_CCD_SEQ_1_CFG_REG_OFST 0x40
#define COMM_RMAP_CCD_SEQ_2_CFG_REG_OFST 0x41
#define COMM_RMAP_SPW_PKT_1_CFG_REG_OFST 0x42
#define COMM_RMAP_SPW_PKT_2_CFG_REG_OFST 0x43
#define COMM_RMAP_CCD_1_W_1_CFG_REG_OFST 0x44
#define COMM_RMAP_CCD_1_W_2_CFG_REG_OFST 0x45
#define COMM_RMAP_CCD_2_W_1_CFG_REG_OFST 0x46
#define COMM_RMAP_CCD_2_W_2_CFG_REG_OFST 0x47
#define COMM_RMAP_CCD_3_W_1_CFG_REG_OFST 0x48
#define COMM_RMAP_CCD_3_W_2_CFG_REG_OFST 0x49
#define COMM_RMAP_CCD_4_W_1_CFG_REG_OFST 0x4A
#define COMM_RMAP_CCD_4_W_2_CFG_REG_OFST 0x4B
#define COMM_RMAP_OP_MODE_CFG_REG_OFST   0x4C
#define COMM_RMAP_SYNC_CFG_REG_OFST      0x4D
#define COMM_RMAP_DAC_CTRL_REG_OFST      0x4E
#define COMM_RMAP_CLK_SRCE_CTRL_REG_OFST 0x4F
#define COMM_RMAP_FRAME_NUMBER_REG_OFST  0x50
#define COMM_RMAP_CURRENT_MODE_REG_OFST  0x51
// rmap hk addr
#define COMM_RMAP_HK_0_REG_OFST          0xA0
#define COMM_RMAP_HK_1_REG_OFST          0xA1
#define COMM_RMAP_HK_2_REG_OFST          0xA2
#define COMM_RMAP_HK_3_REG_OFST          0xA3
#define COMM_RMAP_HK_4_REG_OFST          0xA4
#define COMM_RMAP_HK_5_REG_OFST          0xA5
#define COMM_RMAP_HK_6_REG_OFST          0xA6
#define COMM_RMAP_HK_7_REG_OFST          0xA7
#define COMM_RMAP_HK_8_REG_OFST          0xA8
#define COMM_RMAP_HK_9_REG_OFST          0xA9
#define COMM_RMAP_HK_10_REG_OFST         0xAA
#define COMM_RMAP_HK_11_REG_OFST         0xAB
#define COMM_RMAP_HK_12_REG_OFST         0xAC
#define COMM_RMAP_HK_13_REG_OFST         0xAD
#define COMM_RMAP_HK_14_REG_OFST         0xAE
#define COMM_RMAP_HK_15_REG_OFST         0xAF
#define COMM_RMAP_HK_16_REG_OFST         0xB0
#define COMM_RMAP_HK_17_REG_OFST         0xB1
#define COMM_RMAP_HK_18_REG_OFST         0xB2
#define COMM_RMAP_HK_19_REG_OFST         0xB3
#define COMM_RMAP_HK_20_REG_OFST         0xB4
#define COMM_RMAP_HK_21_REG_OFST         0xB5
#define COMM_RMAP_HK_22_REG_OFST         0xB6
#define COMM_RMAP_HK_23_REG_OFST         0xB7
#define COMM_RMAP_HK_24_REG_OFST         0xB8
#define COMM_RMAP_HK_25_REG_OFST         0xB9
#define COMM_RMAP_HK_26_REG_OFST         0xBA
#define COMM_RMAP_HK_27_REG_OFST         0xBB
#define COMM_RMAP_HK_28_REG_OFST         0xBC
#define COMM_RMAP_HK_29_REG_OFST         0xBD
#define COMM_RMAP_HK_30_REG_OFST         0xBE
#define COMM_RMAP_HK_31_REG_OFST         0xBF

// rmap config bit masks
#define COMM_RMAP_TRI_LV_CLK_CTRL_MSK    (1 << 1)
#define COMM_RMAP_IMGCLK_DIR_CTRL_MSK    (1 << 2)
#define COMM_RMAP_REGCLK_DIR_CTRL_MSK    (1 << 3)
#define COMM_RMAP_IMGCLK_TRCNT_CTRL_MSK  (0xFFFF << 4)
#define COMM_RMAP_REGCLK_TRCNT_CTRL_MSK  (0xFFF << 20)

#define COMM_RMAP_SL_RDOUT_PAUSE_CNT_MSK (0xFFFFF << 0)

#define COMM_RMAP_DIGITISE_CTRL_MSK      (1 << 1)
#define COMM_RMAP_CCD_DTRAN_SEL_CTRL_MSK (0b11 << 2)
#define COMM_RMAP_PACKET_SIZE_CTRL_MSK   (0xFFFF << 4)

#define COMM_RMAP_WLIST_P_IADDR_CCD1_MSK (0xFFFFFFFF << 0)

#define COMM_RMAP_WINDOW_WIDTH_CCD1_MSK  (0b111111 << 0)
#define COMM_RMAP_WINDOW_HEIGHT_CCD1_MSK (0b111111 << 6)
#define COMM_RMAP_WLIST_LENGTH_CCD1_MSK  (0xFFFF << 16)

#define COMM_RMAP_WLIST_P_IADDR_CCD2_MSK (0xFFFFFFFF << 0)

#define COMM_RMAP_WINDOW_WIDTH_CCD2_MSK  (0b111111 << 0)
#define COMM_RMAP_WINDOW_HEIGHT_CCD2_MSK (0b111111 << 6)
#define COMM_RMAP_WLIST_LENGTH_CCD2_MSK  (0xFFFF << 16)

#define COMM_RMAP_WLIST_P_IADDR_CCD3_MSK (0xFFFFFFFF << 0)

#define COMM_RMAP_WINDOW_WIDTH_CCD3_MSK  (0b111111 << 0)
#define COMM_RMAP_WINDOW_HEIGHT_CCD3_MSK (0b111111 << 6)
#define COMM_RMAP_WLIST_LENGTH_CCD3_MSK  (0xFFFF << 16)

#define COMM_RMAP_WLIST_P_IADDR_CCD4_MSK (0xFFFFFFFF << 0)

#define COMM_RMAP_WINDOW_WIDTH_CCD4_MSK  (0b111111 << 0)
#define COMM_RMAP_WINDOW_HEIGHT_CCD4_MSK (0b111111 << 6)
#define COMM_RMAP_WLIST_LENGTH_CCD4_MSK  (0xFFFF << 16)

#define COMM_RMAP_MODE_SEL_CTRL_MSK      (0xF << 4)

#define COMM_RMAP_SYNC_CFG_MSK           (0b11 << 0)
#define COMM_RMAP_SELF_TRIGGER_CTRL_MSK  (1 << 2)

#define COMM_RMAP_FRAME_NUMBER_MSK       (0b11 << 0)

#define COMM_RMAP_CURRENT_MODE_MSK       (0xF << 0)

// rmap hk bit masks
#define COMM_RMAP_HK_CCD1_VOD_E_MSK      (0xFFFF << 0)
#define COMM_RMAP_HK_CCD1_VOD_F_MSK      (0xFFFF << 16)
#define COMM_RMAP_HK_CCD1_VRD_MON_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_CCD2_VOD_E_MSK      (0xFFFF << 16)
#define COMM_RMAP_HK_CCD2_VOD_F_MSK      (0xFFFF << 0)
#define COMM_RMAP_HK_CCD2_VRD_MON_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_CCD3_VOD_E_MSK      (0xFFFF << 0)
#define COMM_RMAP_HK_CCD3_VOD_F_MSK      (0xFFFF << 16)
#define COMM_RMAP_HK_CCD3_VRD_MON_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_CCD4_VOD_E_MSK      (0xFFFF << 16)
#define COMM_RMAP_HK_CCD4_VOD_F_MSK      (0xFFFF << 0)
#define COMM_RMAP_HK_CCD4_VRD_MON_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_VCCD_MSK            (0xFFFF << 0)
#define COMM_RMAP_HK_VRCLK_MSK           (0xFFFF << 16)
#define COMM_RMAP_HK_VICLK_MSK           (0xFFFF << 0)
#define COMM_RMAP_HK_VRCLK_LOW_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_5VB_POS_MSK         (0xFFFF << 0)
#define COMM_RMAP_HK_5VB_NEG_MSK         (0xFFFF << 16)
#define COMM_RMAP_HK_3_3VB_POS_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_2_5VA_POS_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_3_3VD_POS_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_2_5VD_POS_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_1_5VD_POS_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_5VREF_MSK           (0xFFFF << 16)
#define COMM_RMAP_HK_VCCD_POS_RAW_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_VCLK_POS_RAW_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_VAN1_POS_RAW_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_VAN3_NEG_RAW_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_VAN2_POS_RAW_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_VDIG_FPGA_RAW_MSK   (0xFFFF << 16)
#define COMM_RMAP_HK_VDIG_SPW_RAW_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_VICLK_LOW_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_ADC_TEMP_A_E_MSK    (0xFFFF << 0)
#define COMM_RMAP_HK_ADC_TEMP_A_F_MSK    (0xFFFF << 16)
#define COMM_RMAP_HK_CCD1_TEMP_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_CCD2_TEMP_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_CCD3_TEMP_MSK       (0xFFFF << 0)
#define COMM_RMAP_HK_CCD4_TEMP_MSK       (0xFFFF << 16)
#define COMM_RMAP_HK_WP605_SPARE_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_0_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_1_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_2_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_3_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_4_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_5_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_6_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_7_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_8_MSK     (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_9_MSK     (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_10_MSK    (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_11_MSK    (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_12_MSK    (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_13_MSK    (0xFFFF << 0)
#define COMM_RMAP_LOWRES_PRT_A_14_MSK    (0xFFFF << 16)
#define COMM_RMAP_LOWRES_PRT_A_15_MSK    (0xFFFF << 0)
#define COMM_RMAP_SEL_HIRES_PRT0_MSK     (0xFFFF << 16)
#define COMM_RMAP_SEL_HIRES_PRT1_MSK     (0xFFFF << 0)
#define COMM_RMAP_SEL_HIRES_PRT2_MSK     (0xFFFF << 16)
#define COMM_RMAP_SEL_HIRES_PRT3_MSK     (0xFFFF << 0)
#define COMM_RMAP_SEL_HIRES_PRT4_MSK     (0xFFFF << 16)
#define COMM_RMAP_SEL_HIRES_PRT5_MSK     (0xFFFF << 0)
#define COMM_RMAP_SEL_HIRES_PRT6_MSK     (0xFFFF << 16)
#define COMM_RMAP_SEL_HIRES_PRT7_MSK     (0xFFFF << 0)
#define COMM_RMAP_ZERO_HIRES_AMP_MSK     (0xFFFF << 16)
//! [constants definition]

//! [public module structs definition]
enum CommBufferSide {
	eCommLeftBuffer = 0, eCommRightBuffer = 1
} ECommBufferSide;

enum CommSpwCh {
	eCommSpwCh1 = 0,
	eCommSpwCh2,
	eCommSpwCh3,
	eCommSpwCh4,
	eCommSpwCh5,
	eCommSpwCh6,
	eCommSpwCh7,
	eCommSpwCh8
} ECommSpwCh;
//! [public module structs definition]

//! [public function prototypes]
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* COMM_H_ */
