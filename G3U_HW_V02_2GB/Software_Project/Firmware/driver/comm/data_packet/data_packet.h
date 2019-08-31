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
	eDpktStandBy = 0, eDpktFullImage = 8, // First bit is used to indicate non standby. The modes start in 0b1000 = 8.
	eDpktFullImagePattern,
	eDpktWindowing,
	eDpktWindowingPattern,
	eDpktPartialReadOut,
} EDpktMode;

//! [public module structs definition]
typedef struct DpktDataPacketConfig {
	alt_u16 usiCcdXSize; /* Data Packet CCD X Size */
	alt_u16 usiCcdYSize; /* Data Packet CCD Y Size */
	alt_u16 usiDataYSize; /* Data Packet Data Y Size */
	alt_u16 usiOverscanYSize; /* Data Packet Overscan Y Size */
	alt_u16 usiPacketLength; /* Data Packet Packet Length */
	alt_u8 ucLogicalAddr; /* Data Packet Logical Address */
	alt_u8 ucProtocolId; /* Data Packet Protocol ID */
	alt_u8 ucFeeMode; /* Data Packet FEE Mode */
	alt_u8 ucCcdNumber; /* Data Packet CCD Number */
} TDpktDataPacketConfig;

typedef struct DpktDataPacketHeader {
	alt_u16 usiLength; /* Data Packet Header Length */
	alt_u16 usiType; /* Data Packet Header Type */
	alt_u16 usiFrameCounter; /* Data Packet Header Frame Counter */
	alt_u16 usiSequenceCounter; /* Data Packet Header Sequence Counter */
} TDpktDataPacketHeader;

typedef struct DpktPixelDelay {
	alt_u16 usiLineDelay; /* Data Packet Line Delay */
	alt_u16 usiColumnDelay; /* Data Packet Column Delay */
	alt_u16 usiAdcDelay; /* Data Packet ADC Delay */
} TDpktPixelDelay;

typedef struct DpktChannel {
	TDpktDataPacketConfig xDataPacketConfig;
	TDpktDataPacketHeader xDataPacketHeader;
	TDpktPixelDelay xPixelDelay;
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
alt_u16 usiAdcPxDelayCalcPeriodNs(alt_u32 uliPeriodNs);
alt_u16 usiLineTrDelayCalcPeriodNs(alt_u32 uliPeriodNs);
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
