/*
 * comm_channel.h
 *
 *  Created on: 10/01/2019
 *      Author: rfranca
 */

#ifndef COMM_CHANNEL_H_
#define COMM_CHANNEL_H_

#include "comm.h"
#include "data_packet/data_packet.h"
#include "fee_buffers/fee_buffers.h"
#include "rmap/rmap.h"
#include "spw_controller/spw_controller.h"

//! [constants definition]
// address
// bit masks
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
bool bCommSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucCommCh);

bool bCommInitCh(TCommChannel *pxCommCh, alt_u8 ucCommCh);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* COMM_CHANNEL_H_ */
