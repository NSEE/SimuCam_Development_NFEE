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
#define COMM_WINDOW_CTRL_REG_OFFSET     0
#define COMM_WINDOW_STAT_REG_OFFSET     1
#define COMM_TIMECODE_RX_REG_OFFSET     2
#define COMM_TIMECODE_TX_REG_OFFSET     3
#define COMM_IRQ_CTRL_REG_OFFSET        4
#define COMM_IRQ_FLAG_REG_OFFSET        5
#define COMM_WINDOW_BUFFER_REG_OFFSET   6

// bit masks
#define COMM_CTRL_MASKING_EN_MSK        (1 << 8)
#define COMM_CTRL_LINK_AUTOSTART_MSK    (1 << 2)
#define COMM_CTRL_LINK_START_MSK        (1 << 1)
#define COMM_CTRL_LINK_DISCONNECT_MSK   (1 << 0)

#define COMM_STAT_LINK_DISC_ERR_MSK     (1 << 11)
#define COMM_STAT_LINK_PAR_ERR_MSK      (1 << 10)
#define COMM_STAT_LINK_ESC_ERR_MSK      (1 << 9)
#define COMM_STAT_LINK_CRED_ERR_MSK     (1 << 8)
#define COMM_STAT_LINK_STARTED_MSK      (1 << 2)
#define COMM_STAT_LINK_CONNECTING_MSK   (1 << 1)
#define COMM_STAT_LINK_RUNNING_MSK      (1 << 0)

#define COMM_TIMECODE_RX_CONTROL_MSK    (0b11     << 7)
#define COMM_TIMECODE_RX_COUNTER_MSK    (0b111111 << 1)
#define COMM_TIMECODE_RX_RECEIVED_MSK   (1        << 0)

#define COMM_TIMECODE_TX_CONTROL_MSK    (0b11     << 7)
#define COMM_TIMECODE_TX_COUNTER_MSK    (0b111111 << 1)
#define COMM_TIMECODE_TX_SEND_MSK       (1        << 0)

#define COMM_IRQ_L_BUFFER_EMPTY_EN_MSK  (1 << 8)
#define COMM_IRQ_R_BUFFER_EMPTY_EN_MSK  (1 << 0)

#define COMM_IRQ_BUFFER_EMPTY_FLAG_MSK  (1 << 0)

#define COMM_BUFF_STAT_L_BUFF_EPY_MSK   (1 << 8)
#define COMM_BUFF_STAT_R_BUFF_EPY_MSK   (1 << 0)
//! [constants definition]

//! [public module structs definition]
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
