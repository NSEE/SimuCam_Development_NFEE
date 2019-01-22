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
// address
#define COMM_CHANNEL_1_BASE_ADDR        COMM_PEDREIRO_V1_01_A_BASE
#define COMM_CHANNEL_2_BASE_ADDR        COMM_PEDREIRO_V1_01_B_BASE
#define COMM_CHANNEL_3_BASE_ADDR        COMM_PEDREIRO_V1_01_C_BASE
#define COMM_CHANNEL_4_BASE_ADDR        COMM_PEDREIRO_V1_01_D_BASE
#define COMM_CHANNEL_5_BASE_ADDR        COMM_PEDREIRO_V1_01_E_BASE
#define COMM_CHANNEL_6_BASE_ADDR        COMM_PEDREIRO_V1_01_F_BASE
#define COMM_CHANNEL_7_BASE_ADDR        COMM_PEDREIRO_V1_01_G_BASE
#define COMM_CHANNEL_8_BASE_ADDR        COMM_PEDREIRO_V1_01_H_BASE
// address offset
#define COMM_LINK_CFG_STAT_REG_OFST      0x00
#define COMM_TIMECODE_REG_OFST           0x01
#define COMM_FEE_BUFF_CFG_REG_OFST       0x02
#define COMM_FEE_BUFF_STAT_REG_OFST      0x03
#define COMM_RMAP_CODEC_CFG_REG_OFST     0x04
#define COMM_RMAP_CODEC_STAT_REG_OFST    0x05
#define COMM_RMAP_LST_WR_ADDR_REG_OFST   0x06
#define COMM_RMAP_LST_RD_ADDR_REG_OFST   0x07
#define COMM_DATA_PKT_CFG_1_REG_OFST     0x08
#define COMM_DATA_PKT_CFG_2_REG_OFST     0x09
#define COMM_DATA_PKT_CFG_3_REG_OFST     0x0A
#define COMM_DATA_PKT_CFG_4_REG_OFST     0x0B
#define COMM_DATA_PKT_HDR_1_REG_OFST     0x0C
#define COMM_DATA_PKT_HDR_2_REG_OFST     0x0D
#define COMM_DATA_PKT_PX_DLY_1_REG_OFST  0x0E
#define COMM_DATA_PKT_PX_DLY_2_REG_OFST  0x0F
#define COMM_DATA_PKT_PX_DLY_3_REG_OFST  0x10
#define COMM_IRQ_CONTROL_REG_OFST        0x11
#define COMM_IRQ_FLAGS_REG_OFST          0x12
#define COMM_IRQ_FLAGS_CLR_REG_OFST      0x13

// bit masks
#define COMM_SPW_LNKCFG_DISCONNECT_MSK   (1    << 0)
#define COMM_SPW_LNKCFG_LINKSTART_MSK    (1    << 1)
#define COMM_SPW_LNKCFG_AUTOSTART_MSK    (1    << 2)
#define COMM_SPW_LNKSTAT_RUNNING_MSK     (1    << 8)
#define COMM_SPW_LNKSTAT_CONNECTING_MSK  (1    << 9)
#define COMM_SPW_LNKSTAT_STARTED_MSK     (1    << 10)
#define COMM_SPW_LNKERR_DISCONNECT_MSK   (1    << 16)
#define COMM_SPW_LNKERR_PARITY_MSK       (1    << 17)
#define COMM_SPW_LNKERR_ESCAPE_MSK       (1    << 18)
#define COMM_SPW_LNKERR_CREDIT_MSK       (1    << 19)
#define COMM_SPW_LNKCFG_TXDIVCNT_MSK     (0xFF << 24)

#define COMM_TIMECODE_TIME_MSK           (0b111111 << 0)
#define COMM_TIMECODE_CONTROL_MSK        (0b11     << 6)
#define COMM_TIMECODE_CLR_MSK            (1        << 8)

#define COMM_FEE_MACHINE_CLR_MSK         (1 << 0)
#define COMM_FEE_MACHINE_STOP_MSK        (1 << 1)
#define COMM_FEE_MACHINE_START_MSK       (1 << 2)
#define COMM_FEE_MASKING_EN_MSK          (1 << 3)

#define COMM_WIND_RIGH_BUFF_EMPTY_MSK    (1 << 0)
#define COMM_WIND_LEFT_BUFF_EMPTY_MSK    (1 << 1)

#define COMM_RMAP_TARGET_LOG_ADDR_MSK    (0xFF << 0)
#define COMM_RMAP_TARGET_KEY_MSK         (0xFF << 8)

#define COMM_RMAP_STAT_CMD_RECEIVED_MSK  (1 << 0)
#define COMM_RMAP_STAT_WR_REQ_MSK        (1 << 1)
#define COMM_RMAP_STAT_WR_AUTH_MSK       (1 << 2)
#define COMM_RMAP_STAT_RD_REQ_MSK        (1 << 3)
#define COMM_RMAP_STAT_RD_AUTH_MSK       (1 << 4)
#define COMM_RMAP_STAT_REPLY_SEND_MSK    (1 << 5)
#define COMM_RMAP_STAT_DISCARD_PKG_MSK   (1 << 6)
#define COMM_RMAP_ERR_EARLY_EOP_MSK      (1 << 16)
#define COMM_RMAP_ERR_EEP_MSK            (1 << 17)
#define COMM_RMAP_ERR_HEADER_CRC_MSK     (1 << 18)
#define COMM_RMAP_ERR_UNUSED_PKT_MSK     (1 << 19)
#define COMM_RMAP_ERR_INVALID_CMD_MSK    (1 << 20)
#define COMM_RMAP_ERR_TOO_MUCH_DATA_MSK  (1 << 21)
#define COMM_RMAP_ERR_INVALID_DCRC_MSK   (1 << 22)

#define COMM_RMAP_LST_WR_ADDR_MSK        (0xFFFFFFFF << 0)

#define COMM_RMAP_LST_RD_ADDR_MSK        (0xFFFFFFFF << 0)

#define COMM_DATA_PKT_CCD_X_SIZE_MSK     (0xFFFF << 0)
#define COMM_DATA_PKT_CCD_Y_SIZE_MSK     (0xFFFF << 16)

#define COMM_DATA_PKT_DATA_Y_SIZE_MSK    (0xFFFF << 0)
#define COMM_DATA_PKT_OVER_Y_SIZE_MSK    (0xFFFF << 16)

#define COMM_DATA_PKT_LENGTH_MSK         (0xFFFF << 0)

#define COMM_DATA_PKT_FEE_MODE_MSK       (0xFF << 0)
#define COMM_DATA_PKT_CCD_NUMBER_MSK     (0xFF << 8)

#define COMM_DATA_PKT_HDR_LENGTH_MSK     (0xFFFF << 0)
#define COMM_DATA_PKT_HDR_TYPE_MSK       (0xFFFF << 16)

#define COMM_DATA_PKT_HDR_FRAME_CNT_MSK  (0xFFFF << 0)
#define COMM_DATA_PKT_SEQ_CNT_MSK        (0xFFFF << 16)

#define COMM_DATA_PKT_LINE_DLY_MSK       (0xFFFF << 0)

#define COMM_DATA_PKT_COLUMN_DLY_MSK     (0xFFFF << 0)

#define COMM_DATA_PKT_ADC_DLY_MSK        (0xFFFF << 0)

#define COMM_IRQ_RMAP_WRCMD_EN_MSK       (1 << 0)
#define COMM_IRQ_RIGH_BUFF_EPY_EN_MSK    (1 << 8)
#define COMM_IRQ_LEFT_BUFF_EPY_EN_MSK    (1 << 9)
#define COMM_IRQ_GLOBAL_EN_MSK           (1 << 16)

#define COMM_IRQ_RMAP_WRCMD_FLG_MSK      (1 << 0)
#define COMM_IRQ_BUFF_EPY_FLG_MSK        (1 << 8)

#define COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK  (1 << 0)
#define COMM_IRQ_BUFF_EPY_FLG_CLR_MSK    (1 << 8)
//! [constants definition]

//! [public module structs definition]
enum CommSpwCh {
	eCommSpwCh1 = 1,
	eCommSpwCh2 = 2,
	eCommSpwCh3 = 3,
	eCommSpwCh4 = 4,
	eCommSpwCh5 = 5,
	eCommSpwCh6 = 6,
	eCommSpwCh7 = 7,
	eCommSpwCh8 = 8
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
