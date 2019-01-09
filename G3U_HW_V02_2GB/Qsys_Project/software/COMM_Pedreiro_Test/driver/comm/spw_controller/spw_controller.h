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
	bool bAutostart;
	bool bStart;
	bool bDisconnect;
} TSpwcLinkConfig;

typedef struct SpwcLinkError {
	bool bDisconnect;
	bool bParity;
	bool bEscape;
	bool bCredit;
} TSpwcLinkError;

typedef struct SpwcLinkStatus {
	bool bStarted;
	bool bConnecting;
	bool bRunning;
} TSpwcLinkStatus;

typedef struct SpwcTimecode {
	alt_u8 ucControl;
	alt_u8 ucCounter;
} TSpwcTimecode;

typedef struct SpwcChannel {
	alt_u32 *puliSpwcChAddr;
	TSpwcLinkConfig xLinkConfig;
	TSpwcLinkError xLinkError;
	TSpwcLinkStatus xLinkStatus;
	TSpwcTimecode xTimecode;
} TSpwcChannel;
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bSpwcSetLink(TSpwcChannel *pxCh);
bool bSpwcGetLink(TSpwcChannel *pxCh);
bool bSpwcGetLinkError(TSpwcChannel *pxCh);
bool bSpwcGetLinkStatus(TSpwcChannel *pxCh);
bool bSpwcGetTimecode(TSpwcChannel *pxCh);
bool bSpwcClearTimecode(TSpwcChannel *pxCh);
bool bSpwcInitCh(TSpwcChannel *pxCh, alt_u8 ucSpwCh);
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
