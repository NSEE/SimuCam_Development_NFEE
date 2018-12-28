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
void rst_simucam_reset(alt_u16 rst_cnt){

}

void rst_nios_ii_reset(alt_u16 rst_cnt){

}

void rst_release_device_reset(alt_u32 rst_mask){

}

void rst_hold_device_reset(alt_u32 rst_mask){

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

