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

extern OS_EVENT *xNfeeSchedule;

//! [constants definition]
// address
// bit masks
//! [constants definition]

//! [public module structs definition]
typedef struct FeebWindowingConfig {
	bool bMasking;
} TFeebWindowingConfig;

typedef struct FeebIrqControl {
	bool bLeftBufferEmptyEn;
	bool bRightBufferEmptyEn;
} TFeebIrqControl;

typedef struct FeebIrqFlag {
	bool bBufferEmptyFlag;
} TFeebIrqFlag;

typedef struct FeebBufferStatus {
	bool bLeftBufferEmpty;
	bool bRightBufferEmpty;
	bool bLeftFeeBusy;
	bool bRightFeeBusy;
	alt_u8 ucLeftBufferSize;
	alt_u8 ucRightBufferSize;
} TFeebBufferStatus;

typedef struct FeebChannel {
	alt_u32 *puliFeebChAddr;
	TFeebWindowingConfig xWindowingConfig;
	TFeebIrqControl xIrqControl;
	TFeebIrqFlag xIrqFlag;
	TFeebBufferStatus xBufferStatus;
} TFeebChannel;
//! [public module structs definition]

//! [public function prototypes]
void vFeebCh1HandleIrq(void* pvContext);
void vFeebCh2HandleIrq(void* pvContext);
void vFeebCh3HandleIrq(void* pvContext);
void vFeebCh4HandleIrq(void* pvContext);
void vFeebCh5HandleIrq(void* pvContext);
void vFeebCh6HandleIrq(void* pvContext);
void vFeebCh7HandleIrq(void* pvContext);
void vFeebCh8HandleIrq(void* pvContext);

void vFeebCh1IrqFlagClrRBuff0Empty(void);
void vFeebCh2IrqFlagClrRBuff0Empty(void);
void vFeebCh3IrqFlagClrRBuff0Empty(void);
void vFeebCh4IrqFlagClrRBuff0Empty(void);
void vFeebCh5IrqFlagClrRBuff0Empty(void);
void vFeebCh6IrqFlagClrRBuff0Empty(void);
void vFeebCh7IrqFlagClrRBuff0Empty(void);
void vFeebCh8IrqFlagClrRBuff0Empty(void);

void vFeebCh1IrqFlagClrRBuff1Empty(void);
void vFeebCh2IrqFlagClrRBuff1Empty(void);
void vFeebCh3IrqFlagClrRBuff1Empty(void);
void vFeebCh4IrqFlagClrRBuff1Empty(void);
void vFeebCh5IrqFlagClrRBuff1Empty(void);
void vFeebCh6IrqFlagClrRBuff1Empty(void);
void vFeebCh7IrqFlagClrRBuff1Empty(void);
void vFeebCh8IrqFlagClrRBuff1Empty(void);

void vFeebCh1IrqFlagClrLBuff0Empty(void);
void vFeebCh2IrqFlagClrLBuff0Empty(void);
void vFeebCh3IrqFlagClrLBuff0Empty(void);
void vFeebCh4IrqFlagClrLBuff0Empty(void);
void vFeebCh5IrqFlagClrLBuff0Empty(void);
void vFeebCh6IrqFlagClrLBuff0Empty(void);
void vFeebCh7IrqFlagClrLBuff0Empty(void);
void vFeebCh8IrqFlagClrLBuff0Empty(void);

void vFeebCh1IrqFlagClrLBuff1Empty(void);
void vFeebCh2IrqFlagClrLBuff1Empty(void);
void vFeebCh3IrqFlagClrLBuff1Empty(void);
void vFeebCh4IrqFlagClrLBuff1Empty(void);
void vFeebCh5IrqFlagClrLBuff1Empty(void);
void vFeebCh6IrqFlagClrLBuff1Empty(void);
void vFeebCh7IrqFlagClrLBuff1Empty(void);
void vFeebCh8IrqFlagClrLBuff1Empty(void);

bool bFeebCh1IrqFlagRBuff0Empty(void);
bool bFeebCh2IrqFlagRBuff0Empty(void);
bool bFeebCh3IrqFlagRBuff0Empty(void);
bool bFeebCh4IrqFlagRBuff0Empty(void);
bool bFeebCh5IrqFlagRBuff0Empty(void);
bool bFeebCh6IrqFlagRBuff0Empty(void);
bool bFeebCh7IrqFlagRBuff0Empty(void);
bool bFeebCh8IrqFlagRBuff0Empty(void);

bool bFeebCh1IrqFlagRBuff1Empty(void);
bool bFeebCh2IrqFlagRBuff1Empty(void);
bool bFeebCh3IrqFlagRBuff1Empty(void);
bool bFeebCh4IrqFlagRBuff1Empty(void);
bool bFeebCh5IrqFlagRBuff1Empty(void);
bool bFeebCh6IrqFlagRBuff1Empty(void);
bool bFeebCh7IrqFlagRBuff1Empty(void);
bool bFeebCh8IrqFlagRBuff1Empty(void);

bool bFeebCh1IrqFlagLBuff0Empty(void);
bool bFeebCh2IrqFlagLBuff0Empty(void);
bool bFeebCh3IrqFlagLBuff0Empty(void);
bool bFeebCh4IrqFlagLBuff0Empty(void);
bool bFeebCh5IrqFlagLBuff0Empty(void);
bool bFeebCh6IrqFlagLBuff0Empty(void);
bool bFeebCh7IrqFlagLBuff0Empty(void);
bool bFeebCh8IrqFlagLBuff0Empty(void);

bool bFeebCh1IrqFlagLBuff1Empty(void);
bool bFeebCh2IrqFlagLBuff1Empty(void);
bool bFeebCh3IrqFlagLBuff1Empty(void);
bool bFeebCh4IrqFlagLBuff1Empty(void);
bool bFeebCh5IrqFlagLBuff1Empty(void);
bool bFeebCh6IrqFlagLBuff1Empty(void);
bool bFeebCh7IrqFlagLBuff1Empty(void);
bool bFeebCh8IrqFlagLBuff1Empty(void);

bool bFeebCh1SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);
bool bFeebCh2SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);
bool bFeebCh3SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);
bool bFeebCh4SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);
bool bFeebCh5SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);
bool bFeebCh6SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);
bool bFeebCh7SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);
bool bFeebCh8SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);

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

bool bFeebGetCh1LeftFeeBusy(void);
bool bFeebGetCh1RightFeeBusy(void);
bool bFeebGetCh2LeftFeeBusy(void);
bool bFeebGetCh2RightFeeBusy(void);

bool bFeebSetBufferSize(TFeebChannel *pxFeebCh, alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide);

bool bFeebSetWindowing(TFeebChannel *pxFeebCh);
bool bFeebGetWindowing(TFeebChannel *pxFeebCh);

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
