/*
 * data_packet.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef DATA_PACKET_H_
#define DATA_PACKET_H_

#include "../comm.h"
#include "../../../utils/configs_simucam.h"
#include "../../../api_driver/ddr2/ddr2.h"

//! [constants definition]
// address
// bit masks
//! [constants definition]

/* Data Packet Mode */
enum DpktMode {
	eDpktOff                      = 0u,  /* N-FEE Off Mode */
	eDpktOn                       = 1u,  /* N-FEE On Mode */
	eDpktFullImagePattern         = 2u,  /* N-FEE Full-Image Pattern Mode */
	eDpktWindowingPattern         = 3u,  /* N-FEE Windowing Pattern Mode */
	eDpktStandby                  = 4u,  /* N-FEE Standby Mode */
	eDpktFullImagePatternMode     = 5u,  /* N-FEE Full-Image Mode / Pattern Mode */
	eDpktFullImageSsdMode         = 6u,  /* N-FEE Full-Image Mode / SSD Mode */
	eDpktWindowingPatternMode     = 7u,  /* N-FEE Windowing Mode / Pattern Mode */
	eDpktWindowingSsdImgMode      = 8u,  /* N-FEE Windowing Mode / SSD Image Mode */
	eDpktWindowingSsdWinMode      = 9u,  /* N-FEE Windowing Mode / SSD Window Mode */
	eDpktPerformanceTest          = 10u, /* N-FEE Performance Test Mode */
	eDpktParallelTrapPumping1Pump = 11u, /* N-FEE Parallel Trap Pumping 1 Mode / Pumping Mode */
	eDpktParallelTrapPumping1Data = 12u, /* N-FEE Parallel Trap Pumping 1 Mode / Data Emiting Mode  */
	eDpktParallelTrapPumping2Pump = 13u, /* N-FEE Parallel Trap Pumping 2 Mode / Pumping Mode */
	eDpktParallelTrapPumping2Data = 14u, /* N-FEE Parallel Trap Pumping 2 Mode / Data Emiting Mode  */
	eDpktSerialTrapPumping1       = 15u, /* N-FEE Serial Trap Pumping 1 Mode */
	eDpktSerialTrapPumping2       = 16u  /* N-FEE Serial Trap Pumping 2 Mode */
} EDpktMode;

enum DpktCcdSide {
	eDpktCcdSideE                 = 0u,  /* F-FEE CCD Side E (Left) */
	eDpktCcdSideF                 = 1u   /* F-FEE CCD Side F (Right) */
} EDpktCcdSide;

enum DpktSpwCodecErrId {
	eDpktSpwCodecErrIdNone        = 0u,  /* SpaceWire Codec Error Injection Error ID for No Error */
	eDpktSpwCodecErrIdDiscon      = 1u,  /* SpaceWire Codec Error Injection Error ID for Disconnection Error */
	eDpktSpwCodecErrIdParity      = 2u,  /* SpaceWire Codec Error Injection Error ID for Parity Error */
	eDpktSpwCodecErrIdEscape      = 3u,  /* SpaceWire Codec Error Injection Error ID for Escape (ESC+ESC) Error */
	eDpktSpwCodecErrIdCredit      = 4u,  /* SpaceWire Codec Error Injection Error ID for Credit Error */
	eDpktSpwCodecErrIdChar        = 5u,  /* SpaceWire Codec Error Injection Error ID for Char Error */
} DpktSpwCodecErrId;

enum DpktRmapErrId {
	eDpktRmapErrIdInitLogAddr     = 0u,  /* RMAP Error Injection Error ID for Initiator Logical Address */
	eDpktRmapErrIdInstructions    = 1u,  /* RMAP Error Injection Error ID for Instructions Field */
	eDpktRmapErrIdInsPktType      = 2u,  /* RMAP Error Injection Error ID for Packet Type Instruction */
	eDpktRmapErrIdInsCmdWriteRead = 3u,  /* RMAP Error Injection Error ID for Write/Read Instruction Command */
	eDpktRmapErrIdInsCmdVerifData = 4u,  /* RMAP Error Injection Error ID for Verify Data Before Reply Instruction Command */
	eDpktRmapErrIdInsCmdReply     = 5u,  /* RMAP Error Injection Error ID for Reply Instruction Command */
	eDpktRmapErrIdInsCmdIncAddr   = 6u,  /* RMAP Error Injection Error ID for Increment Address Instruction Command */
	eDpktRmapErrIdInsReplyAddrLen = 7u,  /* RMAP Error Injection Error ID for Reply Address Length Instruction */
	eDpktRmapErrIdStatus          = 8u,  /* RMAP Error Injection Error ID for Status */
	eDpktRmapErrIdTargLogAddr     = 9u,  /* RMAP Error Injection Error ID for Target Logical Address */
	eDpktRmapErrIdTransactionId   = 10u, /* RMAP Error Injection Error ID for Transaction Identifier */
	eDpktRmapErrIdDataLength      = 11u, /* RMAP Error Injection Error ID for Data Length */
	eDpktRmapErrIdHeaderCrc       = 12u, /* RMAP Error Injection Error ID for Header CRC */
	eDpktRmapErrIdHeaderEep       = 13u, /* RMAP Error Injection Error ID for Header EEP */
	eDpktRmapErrIdDataCrc         = 14u, /* RMAP Error Injection Error ID for Data CRC */
	eDpktRmapErrIdDataEep         = 15u  /* RMAP Error Injection Error ID for Data EEP */
} DpktRmapErrId;

enum DpktHeaderErrId {
	eDpktHeaderErrIdMode          = 0u, /* Header Error Injection Field ID for Mode */
	eDpktHeaderErrIdLastPkt       = 1u, /* Header Error Injection Field ID for Last Packet */
	eDpktHeaderErrIdCcdSide       = 2u, /* Header Error Injection Field ID for CCD Side */
	eDpktHeaderErrIdCcdNum        = 3u, /* Header Error Injection Field ID for CCD Number */
	eDpktHeaderErrIdFrameNum      = 4u, /* Header Error Injection Field ID for Frame Number */
	eDpktHeaderErrIdPktType       = 5u, /* Header Error Injection Field ID for Packet Type */
	eDpktHeaderErrIdFrameCnt      = 6u, /* Header Error Injection Field ID for Frame Counter */
	eDpktHeaderErrIdSeqCnt        = 7u, /* Header Error Injection Field ID for Sequence Counter */
	eDpktHeaderErrIdLength        = 8u  /* Header Error Injection Field ID for Length */
} EDpktHeaderErrId;

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

bool bDpktSetSpacewireErrInj(TDpktChannel *pxDpktCh);
bool bDpktGetSpacewireErrInj(TDpktChannel *pxDpktCh);

bool bDpktSetSpwCodecErrInj(TDpktChannel *pxDpktCh);
bool bDpktGetSpwCodecErrInj(TDpktChannel *pxDpktCh);

bool bDpktSetRmapErrInj(TDpktChannel *pxDpktCh);
bool bDpktGetRmapErrInj(TDpktChannel *pxDpktCh);

bool bDpktSetTransmissionErrInj(TDpktChannel *pxDpktCh);
bool bDpktGetTransmissionErrInj(TDpktChannel *pxDpktCh);

bool bDpktSetLeftContentErrInj(TDpktChannel *pxDpktCh);
bool bDpktGetLeftContentErrInj(TDpktChannel *pxDpktCh);

bool bDpktSetRightContentErrInj(TDpktChannel *pxDpktCh);
bool bDpktGetRightContentErrInj(TDpktChannel *pxDpktCh);

bool bDpktContentErrInjClearEntries(TDpktChannel *pxDpktCh, alt_u8 ucCcdSide);
bool bDpktContentErrInjOpenList(TDpktChannel *pxDpktCh, alt_u8 ucCcdSide);
alt_u8 ucDpktContentErrInjAddEntry(TDpktChannel *pxDpktCh, alt_u8 ucCcdSide, alt_u16 usiStartFrame, alt_u16 usiStopFrame, alt_u16 usiPxColX, alt_u16 usiPxRowY, alt_u16 usiPxValue);
bool bDpktContentErrInjCloseList(TDpktChannel *pxDpktCh, alt_u8 ucCcdSide);
bool bDpktContentErrInjStartInj(TDpktChannel *pxDpktCh, alt_u8 ucCcdSide);
bool bDpktContentErrInjStopInj(TDpktChannel *pxDpktCh, alt_u8 ucCcdSide);

bool bDpktSetHeaderErrInj(TDpktChannel *pxDpktCh);
bool bDpktGetHeaderErrInj(TDpktChannel *pxDpktCh);

bool bDpktHeaderErrInjClearEntries(TDpktChannel *pxDpktCh);
bool bDpktHeaderErrInjOpenList(TDpktChannel *pxDpktCh);
alt_u8 ucDpktHeaderErrInjAddEntry(TDpktChannel *pxDpktCh, alt_u8 ucFrameNum, alt_u16 usiSequenceCnt, alt_u8 ucFieldId, alt_u16 usiFieldValue);
bool bDpktHeaderErrInjCloseList(TDpktChannel *pxDpktCh);
bool bDpktHeaderErrInjStartInj(TDpktChannel *pxDpktCh);
bool bDpktHeaderErrInjStopInj(TDpktChannel *pxDpktCh);

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
