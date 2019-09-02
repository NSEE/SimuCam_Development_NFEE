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

//! [constants definition]
// address
// bit masks
//! [constants definition]

//! [public module structs definition]
typedef struct FeebMachineControl {
	bool bClear; /* FEE Machine Clear */
	bool bStop; /* FEE Machine Stop */
	bool bStart; /* FEE Machine Start */
	bool bMasking; /* FEE Masking Enable */
} TFeebMachineControl;

typedef struct FeebBufferStatus {
	alt_u8 ucRightBufferSize; /* Windowing Right Buffer Size Config */
	alt_u8 ucLeftBufferSize; /* Windowing Left Buffer Size Config */
	bool bRightBufferEmpty; /* Windowing Right Buffer Empty */
	bool bLeftBufferEmpty; /* Windowing Left Buffer Empty */
	bool bRightFeeBusy; /* FEE Right Machine Busy */
	bool bLeftFeeBusy; /* FEE Left Machine Busy */
} TFeebBufferStatus;

typedef struct FeebIrqControl {
	bool bRightBufferEmptyEn; /* FEE Right Buffer Empty IRQ Enable */
	bool bLeftBufferEmptyEn; /* FEE Left Buffer Empty IRQ Enable */
} TFeebIrqControl;

typedef struct FeebIrqFlag {
	bool bRightBufferEmpty0Flag; /* FEE Right Buffer 0 Empty IRQ Flag */
	bool bRightBufferEmpty1Flag; /* FEE Right Buffer 1 Empty IRQ Flag */
	bool bLeftBufferEmpty0Flag; /* FEE Left Buffer 0 Empty IRQ Flag */
	bool bLeftBufferEmpty1Flag; /* FEE Left Buffer 1 Empty IRQ Flag */
} TFeebIrqFlag;

typedef struct FeebIrqFlagClr {
	bool bRightBufferEmpty0FlagClr; /* FEE Right Buffer 0 Empty IRQ Flag Clear */
	bool bRightBufferEmpty1FlagClr; /* FEE Right Buffer 1 Empty IRQ Flag Clear */
	bool bLeftBufferEmpty0FlagClr; /* FEE Left Buffer 0 Empty IRQ Flag Clear */
	bool bLeftBufferEmpty1FlagClr; /* FEE Left Buffer 1 Empty IRQ Flag Clear */
} TFeebIrqFlagClr;

typedef struct FeebChannel {
	TFeebMachineControl xMachineControl;
	TFeebBufferStatus xBufferStatus;
	TFeebIrqControl xIrqControl;
	TFeebIrqFlag xIrqFlag;
	TFeebIrqFlagClr xIrqFlagClr;
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
bool bFeebGetCh3LeftBufferEmpty(void);
bool bFeebGetCh3RightBufferEmpty(void);
bool bFeebGetCh4LeftBufferEmpty(void);
bool bFeebGetCh4RightBufferEmpty(void);
bool bFeebGetCh5LeftBufferEmpty(void);
bool bFeebGetCh5RightBufferEmpty(void);
bool bFeebGetCh6LeftBufferEmpty(void);
bool bFeebGetCh6RightBufferEmpty(void);
bool bFeebGetCh7LeftBufferEmpty(void);
bool bFeebGetCh7RightBufferEmpty(void);
bool bFeebGetCh8LeftBufferEmpty(void);
bool bFeebGetCh8RightBufferEmpty(void);

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
bool bFeebGetCh7LeftFeeBusy(void);
bool bFeebGetCh7RightFeeBusy(void);
bool bFeebGetCh8LeftFeeBusy(void);
bool bFeebGetCh8RightFeeBusy(void);

bool bFeebSetBufferSize(TFeebChannel *pxFeebCh, alt_u8 ucBufferSizeInBlocks,
		alt_u8 ucBufferSide);

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
