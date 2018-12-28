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
#define RST_CONTROLLER_BASE_ADDR          0

// bit masks
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
void rst_simucam_reset(alt_u16 rst_cnt);

void rst_nios_ii_reset(alt_u16 rst_cnt);

void rst_release_device_reset(alt_u32 rst_mask);
void rst_hold_device_reset(alt_u32 rst_mask);
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
