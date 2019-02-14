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

void vFeebCh1IrqFlagClrBufferEmpty(void);
void vFeebCh2IrqFlagClrBufferEmpty(void);
void vFeebCh3IrqFlagClrBufferEmpty(void);
void vFeebCh4IrqFlagClrBufferEmpty(void);
void vFeebCh5IrqFlagClrBufferEmpty(void);
void vFeebCh6IrqFlagClrBufferEmpty(void);
void vFeebCh7IrqFlagClrBufferEmpty(void);
void vFeebCh8IrqFlagClrBufferEmpty(void);

bool bFeebCh1IrqFlagBufferEmpty(void);
bool bFeebCh2IrqFlagBufferEmpty(void);
bool bFeebCh3IrqFlagBufferEmpty(void);
bool bFeebCh4IrqFlagBufferEmpty(void);
bool bFeebCh5IrqFlagBufferEmpty(void);
bool bFeebCh6IrqFlagBufferEmpty(void);
bool bFeebCh7IrqFlagBufferEmpty(void);
bool bFeebCh8IrqFlagBufferEmpty(void);

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
