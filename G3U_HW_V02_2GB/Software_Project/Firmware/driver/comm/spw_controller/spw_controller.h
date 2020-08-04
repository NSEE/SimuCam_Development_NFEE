/*
 * spw_controller.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef SPW_CONTROLLER_H_
#define SPW_CONTROLLER_H_

#include "../comm.h"
#include <math.h>

//! [constants definition]
// address
// bit masks
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bSpwcSetLinkConfig(TSpwcChannel *pxSpwcCh);
bool bSpwcGetLinkConfig(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh);

bool bSpwcSetTimecodeConfig(TSpwcChannel *pxSpwcCh);
bool bSpwcGetTimecodeConfig(TSpwcChannel *pxSpwcCh);

bool bSpwcGetTimecodeStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcClearTimecode(TSpwcChannel *pxSpwcCh);
bool bSpwcEnableTimecodeTrans(TSpwcChannel *pxSpwcCh, bool bEnable);

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucCommCh);

alt_u8 ucSpwcCalculateLinkDiv(alt_8 ucLinkSpeed);
alt_u32 uliTimecodeCalcDelayNs(alt_u32 uliDelayNs);
alt_u32 uliTimecodeCalcDelayMs(alt_u32 uliDelayMs);
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
