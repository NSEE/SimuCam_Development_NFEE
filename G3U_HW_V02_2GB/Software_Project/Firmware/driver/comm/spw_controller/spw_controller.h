/*
 * spw_controller.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef SPW_CONTROLLER_H_
#define SPW_CONTROLLER_H_

#include "../comm.h"

//! [constants definition]
// address
// bit masks
//! [constants definition]

//! [public module structs definition]
typedef struct SpwcLinkConfig {
	bool bDisconnect; /* SpaceWire Link Config Disconnect */
	bool bLinkStart; /* SpaceWire Link Config Linkstart */
	bool bAutostart; /* SpaceWire Link Config Autostart */
	alt_u8 ucTxDivCnt; /* SpaceWire Link Config TxDivCnt */
} TSpwcLinkConfig;

typedef struct SpwcLinkStatus {
	bool bRunning; /* SpaceWire Link Running */
	bool bConnecting; /* SpaceWire Link Connecting */
	bool bStarted; /* SpaceWire Link Started */
} TSpwcLinkStatus;

typedef struct SpwcLinkError {
	bool bDisconnect; /* SpaceWire Error Disconnect */
	bool bParity; /* SpaceWire Error Parity */
	bool bEscape; /* SpaceWire Error Escape */
	bool bCredit; /* SpaceWire Error Credit */
} TSpwcLinkError;

typedef struct SpwcTimecode {
	bool bClear; /* SpaceWire Timecode Clear */
	bool bEnable; /* SpaceWire Timecode Enable */
	alt_u8 ucTime; /* SpaceWire Timecode Time */
	alt_u8 ucControl; /* SpaceWire Timecode Control */
} TSpwcTimecode;

typedef struct SpwcChannel {
	TSpwcLinkConfig xLinkConfig;
	TSpwcLinkStatus xLinkStatus;
	TSpwcLinkError xLinkError;
	TSpwcTimecode xTimecode;
} TSpwcChannel;
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bSpwcSetLink(TSpwcChannel *pxSpwcCh);
bool bSpwcGetLink(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcGetTimecode(TSpwcChannel *pxSpwcCh);

bool bSpwcClearTimecode(TSpwcChannel *pxSpwcCh);
bool bSpwcEnableTimecode(TSpwcChannel *pxSpwcCh, bool bEnable);

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucCommCh);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* SPW_CONTROLLER_H_ */
