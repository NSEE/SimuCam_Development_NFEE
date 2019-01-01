/*
 * reset.h
 *
 *  Created on: 28/12/2018
 *      Author: rfranca
 */

#ifndef RESET_H_
#define RESET_H_

#include "../../utils/meb_includes.h"

//! [constants definition]
// address
#define RSTC_CONTROLLER_BASE_ADDR     RST_CONTROLLER_BASE
#define RSTC_SIMUCAM_RESET_REG_OFFSET 0
#define RSTC_DEVICE_RESET_REG_OFFSET  1

// bit masks
#define RSTC_SIMUCAM_RST_CONTROL_MASK         (1 << 16)
#define RSTC_SIMUCAM_RST_TIMER_MASK           (0xFFFF << 0)

#define RSTC_DEVICE_SYNC_RST_CONTROL_MASK     (1 << 10)
#define RSTC_DEVICE_RS232_RST_CONTROL_MASK    (1 << 9)
#define RSTC_DEVICE_SD_CARD_RST_CONTROL_MASK  (1 << 8)
#define RSTC_DEVICE_COMM_CH8_RST_CONTROL_MASK (1 << 7)
#define RSTC_DEVICE_COMM_CH7_RST_CONTROL_MASK (1 << 6)
#define RSTC_DEVICE_COMM_CH6_RST_CONTROL_MASK (1 << 5)
#define RSTC_DEVICE_COMM_CH5_RST_CONTROL_MASK (1 << 4)
#define RSTC_DEVICE_COMM_CH4_RST_CONTROL_MASK (1 << 3)
#define RSTC_DEVICE_COMM_CH3_RST_CONTROL_MASK (1 << 2)
#define RSTC_DEVICE_COMM_CH2_RST_CONTROL_MASK (1 << 1)
#define RSTC_DEVICE_COMM_CH1_RST_CONTROL_MASK (1 << 0)

#define RSTC_DEVICE_ALL_MASK                  (0x07FF)
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
void rstc_simucam_reset(alt_u16 rst_cnt);

void rstc_release_device_reset(alt_u32 rst_mask);
void rstc_hold_device_reset(alt_u32 rst_mask);
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
