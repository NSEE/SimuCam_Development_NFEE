/*
 * fee_buffers.h
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#ifndef FEE_BUFFERS_H_
#define FEE_BUFFERS_H_

#include "../comm.h"
#include "../../../utils/error_handler_simucam.h"
#include "../../../utils/queue_commands_list.h"
#include "../../../utils/configs_bind_channel_FEEinst.h"

extern OS_EVENT *xNfeeSchedule;
extern OS_EVENT *xFeeQ[N_OF_NFEE];

//! [constants definition]
#define FEEB_PIXEL_BLOCK_SIZE_BYTES      (alt_u32)136
#define FEEB_TRANSFER_MIN_BLOCKS         (alt_u32)1
#define FEEB_TRANSFER_MAX_BLOCKS         (alt_u32)493447
#define FEEB_TRANSFER_MIN_BYTES          (alt_u32)(FEEB_PIXEL_BLOCK_SIZE_BYTES * FEEB_TRANSFER_MIN_BLOCKS)
#define FEEB_TRANSFER_MAX_BYTES          (alt_u32)(FEEB_PIXEL_BLOCK_SIZE_BYTES * FEEB_TRANSFER_MAX_BLOCKS)
#define FEEB_DATA_ACCESS_WIDTH_BYTES     (alt_u32)32
#define FEEB_DATA_TRANSFER_SIZE_MASK     (alt_u32)0xFFFFFFE0
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
void vFeebCh1HandleIrq(void* pvContext);
void vFeebCh2HandleIrq(void* pvContext);
void vFeebCh3HandleIrq(void* pvContext);
void vFeebCh4HandleIrq(void* pvContext);
void vFeebCh5HandleIrq(void* pvContext);
void vFeebCh6HandleIrq(void* pvContext);

bool vFeebInitIrq(alt_u8 ucCommCh);

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bFeebSetIrqControl(TFeebChannel *pxFeebCh);
bool bFeebGetIrqControl(TFeebChannel *pxFeebCh);
bool bFeebGetIrqFlags(TFeebChannel *pxFeebCh);

bool bFeebGetBuffersStatus(TFeebChannel *pxFeebCh);
bool bFeebGetLeftBufferEmpty(TFeebChannel *pxFeebCh);

bool bFeebGetCh1LeftBufferEmpty(void);
bool bFeebGetCh1RightBufferEmpty(void);
bool bFeebGetCh2LeftBufferEmpty(void);
bool bFeebGetCh2RightBufferEmpty(void);
bool bFeebGetCh3LeftBufferEmpty(void);
bool bFeebGetCh3RightBufferEmpty(void);
bool bFeebGetCh4LeftBufferEmpty(void);
bool bFeebGetCh4RightBufferEmpty(void);
bool bFeebGetCh5LeftBufferEmpty(void);
bool bFeebGetCh5RightBufferEmpty(void);
bool bFeebGetCh6LeftBufferEmpty(void);
bool bFeebGetCh6RightBufferEmpty(void);

bool bFeebGetCh1LeftFeeBusy(void);
bool bFeebGetCh1RightFeeBusy(void);
bool bFeebGetCh2LeftFeeBusy(void);
bool bFeebGetCh2RightFeeBusy(void);
bool bFeebGetCh3LeftFeeBusy(void);
bool bFeebGetCh3RightFeeBusy(void);
bool bFeebGetCh4LeftFeeBusy(void);
bool bFeebGetCh4RightFeeBusy(void);
bool bFeebGetCh5LeftFeeBusy(void);
bool bFeebGetCh5RightFeeBusy(void);
bool bFeebGetCh6LeftFeeBusy(void);
bool bFeebGetCh6RightFeeBusy(void);

bool bFeebGetBufferDataControl(TFeebChannel *pxFeebCh);
bool bFeebSetBufferDataControl(TFeebChannel *pxFeebCh);

bool bFeebGetBufferDataStatus(TFeebChannel *pxFeebCh);

bool bFeebGetMachineControl(TFeebChannel *pxFeebCh);
bool bFeebSetMachineControl(TFeebChannel *pxFeebCh);

bool bFeebClearMachineStatistics(TFeebChannel *pxFeebCh);
bool bFeebGetMachineStatistics(TFeebChannel *pxFeebCh);

bool bFeebStartCh(TFeebChannel *pxFeebCh);
bool bFeebStopCh(TFeebChannel *pxFeebCh);
bool bFeebClrCh(TFeebChannel *pxFeebCh);

bool bFeebInitCh(TFeebChannel *pxFeebCh, alt_u8 ucCommCh);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* FEE_BUFFERS_H_ */
