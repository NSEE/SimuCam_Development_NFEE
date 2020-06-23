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

/* Data Packet Mode */
enum DpktMode {
	eDpktOff = 0u, /* N-FEE Off Mode */
	eDpktOn = 1u, /* N-FEE On Mode */
	eDpktFullImagePattern = 2u, /* N-FEE Full-Image Pattern Mode */
	eDpktWindowingPattern = 3u, /* N-FEE Windowing Pattern Mode */
	eDpktStandby = 4u, /* N-FEE Standby Mode */
	eDpktFullImagePatternMode = 5u, /* N-FEE Full-Image Mode / Pattern Mode */
	eDpktFullImageSsdMode = 6u, /* N-FEE Full-Image Mode / SSD Mode */
	eDpktWindowingPatternMode = 7u, /* N-FEE Windowing Mode / Pattern Mode */
	eDpktWindowingSsdImgMode = 8u, /* N-FEE Windowing Mode / SSD Image Mode */
	eDpktWindowingSsdWinMode = 9u, /* N-FEE Windowing Mode / SSD Window Mode */
	eDpktPerformanceTest = 10u, /* N-FEE Performance Test Mode */
	eDpktParallelTrapPumping1Pump = 11u, /* N-FEE Parallel Trap Pumping 1 Mode / Pumping Mode */
	eDpktParallelTrapPumping1Data = 12u, /* N-FEE Parallel Trap Pumping 1 Mode / Data Emiting Mode  */
	eDpktParallelTrapPumping2Pump = 13u, /* N-FEE Parallel Trap Pumping 2 Mode / Pumping Mode */
	eDpktParallelTrapPumping2Data = 14u, /* N-FEE Parallel Trap Pumping 2 Mode / Data Emiting Mode  */
	eDpktSerialTrapPumping1 = 15u, /* N-FEE Serial Trap Pumping 1 Mode */
	eDpktSerialTrapPumping2 = 16u, /* N-FEE Serial Trap Pumping 2 Mode */
} EDpktMode;

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bDpktSetPacketConfig(TDpktChannel *pxDpktCh);
bool bDpktGetPacketConfig(TDpktChannel *pxDpktCh);

bool bDpktSetPacketErrors(TDpktChannel *pxDpktCh);
bool bDpktGetPacketErrors(TDpktChannel *pxDpktCh);

bool bDpktGetPacketHeader(TDpktChannel *pxDpktCh);

bool bDpktSetPixelDelay(TDpktChannel *pxDpktCh);
bool bDpktGetPixelDelay(TDpktChannel *pxDpktCh);

bool bDpktSetErrorInjection(TDpktChannel *pxDpktCh);
bool bDpktGetErrorInjection(TDpktChannel *pxDpktCh);

bool bDpktSetWindowingParams(TDpktChannel *pxDpktCh);
bool bDpktGetWindowingParams(TDpktChannel *pxDpktCh);

bool bDpktInitCh(TDpktChannel *pxDpktCh, alt_u8 ucCommCh);
alt_u32 uliPxDelayCalcPeriodNs(alt_u32 uliPeriodNs);
alt_u32 uliPxDelayCalcPeriodMs(alt_u32 uliPeriodMs);
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
