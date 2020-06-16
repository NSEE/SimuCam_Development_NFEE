/*
 * reset.h
 *
 *  Created on: 28/12/2018
 *      Author: rfranca
 */

#ifndef RESET_H_
#define RESET_H_

#include "system.h"
#include <altera_avalon_pio_regs.h>
#include <stdio.h>

//! [constants definition]
// address
#define RSTC_CONTROLLER_BASE_ADDR       RST_CONTROLLER_BASE
#define RSTC_SIMUCAM_RESET_REG_OFFSET   0
#define RSTC_DEVICE_RESET_REG_OFFSET    1

// bit masks
#define RSTC_SIMUCAM_RST_CTRL_MSK       (1 << 31)
#define RSTC_SIMUCAM_RST_TMR_MSK        (0x7FFFFFFF << 0)

#define RSTC_DEV_FTDI_RST_CTRL_MSK      (1 << 11)
#define RSTC_DEV_SYNC_RST_CTRL_MSK      (1 << 10)
#define RSTC_DEV_RS232_RST_CTRL_MSK     (1 << 9)
#define RSTC_DEV_SD_CARD_RST_CTRL_MSK   (1 << 8)
#define RSTC_DEV_COMM_CH8_RST_CTRL_MSK  (1 << 7)
#define RSTC_DEV_COMM_CH7_RST_CTRL_MSK  (1 << 6)
#define RSTC_DEV_COMM_CH6_RST_CTRL_MSK  (1 << 5)
#define RSTC_DEV_COMM_CH5_RST_CTRL_MSK  (1 << 4)
#define RSTC_DEV_COMM_CH4_RST_CTRL_MSK  (1 << 3)
#define RSTC_DEV_COMM_CH3_RST_CTRL_MSK  (1 << 2)
#define RSTC_DEV_COMM_CH2_RST_CTRL_MSK  (1 << 1)
#define RSTC_DEV_COMM_CH1_RST_CTRL_MSK  (1 << 0)

#define RSTC_DEV_ALL_MSK                (0x0FFF)
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
void vRstcReleaseSimucamReset(alt_u32 uliRstCnt);
void vRstcHoldSimucamReset(alt_u32 uliRstCnt);

void vRstcReleaseDeviceReset(alt_u32 usiRstMask);
void vRstcHoldDeviceReset(alt_u32 usiRstMask);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* RESET_H_ */
