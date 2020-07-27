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
#define COMM_WINDOING_RMAP_AREA_SIZE    0x00800000
#define COMM_WINDOING_RMAP_AREA_OFST    0x00800000
// bit masks
//! [constants definition]

//! [public module structs definition]

/* Windowing Windows Length Data Struct */
typedef struct WindWindowsLength {
	alt_u32 uliCcd1SideEWinLen; /* CCD 1 Side E Windows Length */
	alt_u32 uliCcd1SideFWinLen; /* CCD 1 Side F Windows Length */
	alt_u32 uliCcd2SideEWinLen; /* CCD 2 Side E Windows Length */
	alt_u32 uliCcd2SideFWinLen; /* CCD 2 Side F Windows Length */
	alt_u32 uliCcd3SideEWinLen; /* CCD 3 Side E Windows Length */
	alt_u32 uliCcd3SideFWinLen; /* CCD 3 Side F Windows Length */
	alt_u32 uliCcd4SideEWinLen; /* CCD 4 Side E Windows Length */
	alt_u32 uliCcd4SideFWinLen; /* CCD 4 Side F Windows Length */
} TWindWindowsLength;

/* MEB Windowing Parameters Register Struct */
typedef struct WindMebWindowingParam {
	TDpktWindowingParam xDpktWindowingParam;
	TWindWindowsLength xWindWindowsLength;
} TWindMebWindowingParam;
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
