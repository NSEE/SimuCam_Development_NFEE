/*
 * data_packet.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef DATA_PACKET_H_
#define DATA_PACKET_H_

#include "../comm.h"

//! [constants definition]
// address
// bit masks
//! [constants definition]

enum DpktMode {
    eDpktFullImage        = 0,
    eDpktFullImagePattern = 1,
    eDpktWindowing        = 2,
    eDpktWindowingPattern = 3,
    eDpktPartialReadOut   = 4
} EDpktMode;


//! [public module structs definition]
typedef struct DpktDataPacketConfig {
	alt_u16 usiCcdXSize;
	alt_u16 usiCcdYSize;
	alt_u16 usiDataYSize;
	alt_u16 usiOverscanYSize;
	alt_u16 usiPacketLength;
	alt_u8 ucFeeMode;
	alt_u8 ucCcdNumber;
} TDpktDataPacketConfig;
typedef struct DpktDataPacketHeader {
	alt_u16 usiLength;
	alt_u16 usiType;
	alt_u16 usiFrameCounter;
	alt_u16 usiSequenceCounter;
} TDpktDataPacketHeader;
typedef struct DpktPixelDelay {
	alt_u16 usiLineDelay;
	alt_u16 usiColumnDelay;
	alt_u16 usiAdcDelay;
} TDpktPixelDelay;
typedef struct DpktChannel {
	alt_u32 *puliDpktChAddr;
	TDpktDataPacketConfig xDpktDataPacketConfig;
	TDpktDataPacketHeader xDpktDataPacketHeader;
	TDpktPixelDelay xDpktPixelDelay;
} TDpktChannel;
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bDpktSetPacketConfig(TDpktChannel *pxDpktCh);
bool bDpktGetPacketConfig(TDpktChannel *pxDpktCh);

bool bDpktGetPacketHeader(TDpktChannel *pxDpktCh);

bool bDpktSetPixelDelay(TDpktChannel *pxDpktCh);
bool bDpktGetPixelDelay(TDpktChannel *pxDpktCh);

bool bDpktInitCh(TDpktChannel *pxDpktCh, alt_u8 ucCommCh);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DATA_PACKET_H_ */
