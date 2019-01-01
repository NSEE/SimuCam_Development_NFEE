/*
 * reset.c
 *
 *  Created on: 28/12/2018
 *      Author: rfranca
 */

#include "reset.h"

//! [private function prototypes]
static void write_reg(alt_u32 *address, alt_u32 offset, alt_u32 data);
static alt_u32 read_reg(alt_u32 *address, alt_u32 offset);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void rstc_simucam_reset(alt_u16 rst_cnt) {
	alt_u32 reg = 0;

	reg |= (alt_u32) (rst_cnt & RSTC_SIMUCAM_RST_TIMER_MASK);
	reg |= (alt_u32) RSTC_SIMUCAM_RST_CONTROL_MASK;
	write_reg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
			RSTC_SIMUCAM_RESET_REG_OFFSET, reg);
}

void rstc_release_device_reset(alt_u32 rst_mask) {
	alt_u32 reg = 0;

	reg = read_reg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
			RSTC_DEVICE_RESET_REG_OFFSET);
	reg &= ~((alt_u32) rst_mask);
	write_reg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
			RSTC_DEVICE_RESET_REG_OFFSET, reg);
}

void rstc_hold_device_reset(alt_u32 rst_mask) {
	alt_u32 reg = 0;

	reg = read_reg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
			RSTC_DEVICE_RESET_REG_OFFSET);
	reg |= (alt_u32) rst_mask;
	write_reg((alt_u32*) RSTC_CONTROLLER_BASE_ADDR,
			RSTC_DEVICE_RESET_REG_OFFSET, reg);
}
//! [public functions]

//! [private functions]
static void write_reg(alt_u32 *address, alt_u32 offset, alt_u32 value) {
	*(address + offset) = value;
}

static alt_u32 read_reg(alt_u32 *address, alt_u32 offset) {
	alt_u32 value;

	value = *(address + offset);
	return value;
}
//! [private functions]

