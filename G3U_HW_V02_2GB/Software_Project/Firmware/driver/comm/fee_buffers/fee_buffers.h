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
const alt_u8 ucFeebIrqEmptyBufferFlagsQtd = 4;
//! [constants definition]

//! [public module structs definition]
enum FeebIrqEmptyBufferFlags {
	eFeebIrqRightEmptyBuffer0Flag = 0,
	eFeebIrqRightEmptyBuffer1Flag,
	eFeebIrqLeftEmptyBuffer0Flag,
	eFeebIrqLeftEmptyBuffer1Flag
} EFeebIrqEmptyBufferFlags;

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

void vFeebCh1IrqFlagClrRBufferEmpty(EFeebIrqEmptyBufferFlags xEmptyBufferFlag);
void vFeebCh2IrqFlagClrRBufferEmpty(EFeebIrqEmptyBufferFlags xEmptyBufferFlag);
void vFeebCh3IrqFlagClrRBufferEmpty(EFeebIrqEmptyBufferFlags xEmptyBufferFlag);
void vFeebCh4IrqFlagClrRBufferEmpty(EFeebIrqEmptyBufferFlags xEmptyBufferFlag);
void vFeebCh5IrqFlagClrRBufferEmpty(EFeebIrqEmptyBufferFlags xEmptyBufferFlag);
void vFeebCh6IrqFlagClrRBufferEmpty(EFeebIrqEmptyBufferFlags xEmptyBufferFlag);
void vFeebCh7IrqFlagClrRBufferEmpty(EFeebIrqEmptyBufferFlags xEmptyBufferFlag);
void vFeebCh8IrqFlagClrRBufferEmpty(EFeebIrqEmptyBufferFlags xEmptyBufferFlag);

void vFeebCh1IrqFlagRBufferEmpty(bool *pbChEmptyBufferFlags);
void vFeebCh2IrqFlagRBufferEmpty(bool *pbChEmptyBufferFlags);
void vFeebCh3IrqFlagRBufferEmpty(bool *pbChEmptyBufferFlags);
void vFeebCh4IrqFlagRBufferEmpty(bool *pbChEmptyBufferFlags);
void vFeebCh5IrqFlagRBufferEmpty(bool *pbChEmptyBufferFlags);
void vFeebCh6IrqFlagRBufferEmpty(bool *pbChEmptyBufferFlags);
void vFeebCh7IrqFlagRBufferEmpty(bool *pbChEmptyBufferFlags);
void vFeebCh8IrqFlagRBufferEmpty(bool *pbChEmptyBufferFlags);

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
