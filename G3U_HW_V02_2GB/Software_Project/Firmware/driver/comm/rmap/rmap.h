/*
 * rmap.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef RMAP_H_
#define RMAP_H_

#include "../comm.h"
#include "../../../utils/queue_commands_list.h"
#include "../../../utils/configs_simucam.h"
#include "../../../utils/error_handler_simucam.h"
#include "../../../simucam_definitions.h"
#include "../../../utils/configs_bind_channel_FEEinst.h"

//! [constants definition]
// address
// bit masks
//! [constants definition]

extern OS_EVENT *xFeeQ[N_OF_NFEE];
//extern OS_EVENT *xWaitSyncQFee[N_OF_NFEE];

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
void vRmapCh1HandleIrq(void* pvContext);
void vRmapCh2HandleIrq(void* pvContext);
void vRmapCh3HandleIrq(void* pvContext);
void vRmapCh4HandleIrq(void* pvContext);
void vRmapCh5HandleIrq(void* pvContext);
void vRmapCh6HandleIrq(void* pvContext);
void vRmapCh7HandleIrq(void* pvContext);
void vRmapCh8HandleIrq(void* pvContext);

alt_u32 uliRmapCh1WriteCmdAddress(void);
alt_u32 uliRmapCh2WriteCmdAddress(void);
alt_u32 uliRmapCh3WriteCmdAddress(void);
alt_u32 uliRmapCh4WriteCmdAddress(void);
alt_u32 uliRmapCh5WriteCmdAddress(void);
alt_u32 uliRmapCh6WriteCmdAddress(void);
alt_u32 uliRmapCh7WriteCmdAddress(void);
alt_u32 uliRmapCh8WriteCmdAddress(void);

bool vRmapInitIrq(alt_u8 ucCommCh);

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bRmapSetIrqControl(TRmapChannel *pxRmapCh);
bool bRmapGetIrqControl(TRmapChannel *pxRmapCh);
bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh);

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh);
bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh);

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh);

bool bRmapGetCodecError(TRmapChannel *pxRmapCh);

bool bRmapSetMemConfigArea(TRmapChannel *pxRmapCh);
bool bRmapGetMemConfigArea(TRmapChannel *pxRmapCh);

bool bRmapGetMemConfigStat(TRmapChannel *pxRmapCh);

bool bRmapSetRmapMemHKArea(TRmapChannel *pxRmapCh);
bool bRmapGetRmapMemHKArea(TRmapChannel *pxRmapCh);

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucCommCh);

alt_u32 uliRmapReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* RMAP_H_ */
