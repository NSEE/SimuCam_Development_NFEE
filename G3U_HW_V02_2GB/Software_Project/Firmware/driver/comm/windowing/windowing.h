/*
 * windowing.h
 *
 *  Created on: 17 de jan de 2020
 *      Author: rfranca
 */

#ifndef DRIVER_COMM_WINDOWING_WINDOWING_H_
#define DRIVER_COMM_WINDOWING_WINDOWING_H_

#include "../comm.h"
#include "../../ftdi/ftdi.h"
#include "../../../api_driver/ddr2/ddr2.h"
#include "../../../utils/configs_simucam.h"

//! [constants definition]
// address
#define COMM_WINDOING_PARAMETERS_OFST   512 /* Offset for all windowing related parameters (packet order list, etc.) */
#define COMM_WINDOING_RMAP_AREA_OFST    0x00800000
// bit masks
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
bool bWindCopyMebWindowingParam(alt_u32 uliWindowingParamAddr, alt_u8 ucMemoryId, alt_u8 ucCommCh); /* Copy the meb windowing parameters from the memory address to the specified channel */
bool bWindCopyCcdXWindowingConfig(alt_u8 ucCommCh); /* Copy the ccdx windowing configurations the specified channel to the ftdi module */
bool bWindClearWindowingArea(alt_u8 ucMemoryId, alt_u32 uliWindowingAreaAddr, alt_u32 uliWinAreaLengthBytes);
bool bWindSetWindowingAreaOffset(alt_u8 ucCommCh, alt_u8 ucMemoryId, alt_u32 uliWindowingAreaAddr);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DRIVER_COMM_WINDOWING_WINDOWING_H_ */
