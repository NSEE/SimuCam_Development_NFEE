/*
 * fee_buffers.c
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#include "fee_buffers.h"

//! [private function prototypes]
static ALT_INLINE bool ALT_ALWAYS_INLINE bFeebGetChFlag(
		alt_u32 uliCommChBaseAddr, alt_u32 uliCommRegOffset,
		alt_u32 uliCommFlagMask);
static void vFeebWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliFeebReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
//! [private function prototypes]

//! [data memory public global variables]
const alt_u8 ucFeebIrqEmptyBufferFlagsQtd = 4;
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viCh1HoldContext;
static volatile int viCh2HoldContext;
static volatile int viCh3HoldContext;
static volatile int viCh4HoldContext;
static volatile int viCh5HoldContext;
static volatile int viCh6HoldContext;
static volatile int viCh7HoldContext;
static volatile int viCh8HoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vFeebCh1HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 0;

	// Get Irq Buffer Empty Flags
	bool bIrqEmptyBufferFlags[ucFeebIrqEmptyBufferFlagsQtd];
	vFeebCh1IrqFlagBufferEmpty(bIrqEmptyBufferFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh1IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh1IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer1Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh1IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh1IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer1Flag);
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF0\n");
	}
#endif

}

void vFeebCh2HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 1;

	// Get Irq Buffer Empty Flags
	bool bIrqEmptyBufferFlags[ucFeebIrqEmptyBufferFlagsQtd];
	vFeebCh2IrqFlagBufferEmpty(bIrqEmptyBufferFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh2IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh2IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer1Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vFeebCh2IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh2IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer1Flag);
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF1\n");
	}
#endif

}

void vFeebCh3HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 2;

	// Get Irq Buffer Empty Flags
	bool bIrqEmptyBufferFlags[ucFeebIrqEmptyBufferFlagsQtd];
	vFeebCh3IrqFlagBufferEmpty(bIrqEmptyBufferFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh3IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh3IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer1Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vFeebCh3IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh3IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer1Flag);
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF2\n");
	}
#endif
}

void vFeebCh4HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 3;

	// Get Irq Buffer Empty Flags
	bool bIrqEmptyBufferFlags[ucFeebIrqEmptyBufferFlagsQtd];
	vFeebCh4IrqFlagBufferEmpty(bIrqEmptyBufferFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh4IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh4IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer1Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vFeebCh4IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh4IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer1Flag);
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF3\n");
	}
#endif
}

void vFeebCh5HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 4;

	// Get Irq Buffer Empty Flags
	bool bIrqEmptyBufferFlags[ucFeebIrqEmptyBufferFlagsQtd];
	vFeebCh5IrqFlagBufferEmpty(bIrqEmptyBufferFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh5IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh5IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer1Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vFeebCh5IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh5IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer1Flag);
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF4\n");
	}
#endif

}

void vFeebCh6HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 5;

	// Get Irq Buffer Empty Flags
	bool bIrqEmptyBufferFlags[ucFeebIrqEmptyBufferFlagsQtd];
	vFeebCh6IrqFlagBufferEmpty(bIrqEmptyBufferFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh6IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh6IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer1Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vFeebCh6IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh6IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer1Flag);
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF5\n");
	}
#endif

}

void vFeebCh7HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 6;

	// Get Irq Buffer Empty Flags
	bool bIrqEmptyBufferFlags[ucFeebIrqEmptyBufferFlagsQtd];
	vFeebCh7IrqFlagBufferEmpty(bIrqEmptyBufferFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh7IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh7IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer1Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vFeebCh7IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh7IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer1Flag);
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF6\n");
	}
#endif

}

void vFeebCh8HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 7;

	// Get Irq Buffer Empty Flags
	bool bIrqEmptyBufferFlags[ucFeebIrqEmptyBufferFlagsQtd];
	vFeebCh8IrqFlagBufferEmpty(bIrqEmptyBufferFlags);

	// Check Irq Buffer Empty Flags
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh8IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh8IrqFlagClrBufferEmpty(eFeebIrqLeftEmptyBuffer1Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vFeebCh8IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer0Flag);
	}
	if (bIrqEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag]) {

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vFeebCh8IrqFlagClrBufferEmpty(eFeebIrqRightEmptyBuffer1Flag);
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF7\n");
	}
#endif

}

void vFeebCh1IrqFlagClrBufferEmpty(alt_u8 ucEmptyBufferFlag) {

	alt_u32 uliEmptyFlagClearMask = 0;

	switch (ucEmptyBufferFlag) {
	case eFeebIrqLeftEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqLeftEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_1_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_1_E_FLG_CLR_MSK;
		break;
	default:
		uliEmptyFlagClearMask = 0;
		;
		break;
	}

	vFeebWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
			COMM_IRQ_FLAGS_CLR_REG_OFST, uliEmptyFlagClearMask);

}

void vFeebCh2IrqFlagClrBufferEmpty(alt_u8 ucEmptyBufferFlag) {

	alt_u32 uliEmptyFlagClearMask = 0;

	switch (ucEmptyBufferFlag) {
	case eFeebIrqLeftEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqLeftEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_1_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_1_E_FLG_CLR_MSK;
		break;
	default:
		uliEmptyFlagClearMask = 0;
		;
		break;
	}

	vFeebWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
			COMM_IRQ_FLAGS_CLR_REG_OFST, uliEmptyFlagClearMask);

}

void vFeebCh3IrqFlagClrBufferEmpty(alt_u8 ucEmptyBufferFlag) {

	alt_u32 uliEmptyFlagClearMask = 0;

	switch (ucEmptyBufferFlag) {
	case eFeebIrqLeftEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqLeftEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_1_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_1_E_FLG_CLR_MSK;
		break;
	default:
		uliEmptyFlagClearMask = 0;
		;
		break;
	}

	vFeebWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
			COMM_IRQ_FLAGS_CLR_REG_OFST, uliEmptyFlagClearMask);

}

void vFeebCh4IrqFlagClrBufferEmpty(alt_u8 ucEmptyBufferFlag) {

	alt_u32 uliEmptyFlagClearMask = 0;

	switch (ucEmptyBufferFlag) {
	case eFeebIrqLeftEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqLeftEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_1_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_1_E_FLG_CLR_MSK;
		break;
	default:
		uliEmptyFlagClearMask = 0;
		;
		break;
	}

	vFeebWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
			COMM_IRQ_FLAGS_CLR_REG_OFST, uliEmptyFlagClearMask);

}

void vFeebCh5IrqFlagClrBufferEmpty(alt_u8 ucEmptyBufferFlag) {

	alt_u32 uliEmptyFlagClearMask = 0;

	switch (ucEmptyBufferFlag) {
	case eFeebIrqLeftEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqLeftEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_1_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_1_E_FLG_CLR_MSK;
		break;
	default:
		uliEmptyFlagClearMask = 0;
		;
		break;
	}

	vFeebWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
			COMM_IRQ_FLAGS_CLR_REG_OFST, uliEmptyFlagClearMask);

}

void vFeebCh6IrqFlagClrBufferEmpty(alt_u8 ucEmptyBufferFlag) {

	alt_u32 uliEmptyFlagClearMask = 0;

	switch (ucEmptyBufferFlag) {
	case eFeebIrqLeftEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqLeftEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_1_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_1_E_FLG_CLR_MSK;
		break;
	default:
		uliEmptyFlagClearMask = 0;
		;
		break;
	}

	vFeebWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
			COMM_IRQ_FLAGS_CLR_REG_OFST, uliEmptyFlagClearMask);

}

void vFeebCh7IrqFlagClrBufferEmpty(alt_u8 ucEmptyBufferFlag) {

	alt_u32 uliEmptyFlagClearMask = 0;

	switch (ucEmptyBufferFlag) {
	case eFeebIrqLeftEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqLeftEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_1_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_1_E_FLG_CLR_MSK;
		break;
	default:
		uliEmptyFlagClearMask = 0;
		;
		break;
	}

	vFeebWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
			COMM_IRQ_FLAGS_CLR_REG_OFST, uliEmptyFlagClearMask);

}

void vFeebCh8IrqFlagClrBufferEmpty(alt_u8 ucEmptyBufferFlag) {

	alt_u32 uliEmptyFlagClearMask = 0;

	switch (ucEmptyBufferFlag) {
	case eFeebIrqLeftEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqLeftEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_L_BUFF_1_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer0Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_0_E_FLG_CLR_MSK;
		break;
	case eFeebIrqRightEmptyBuffer1Flag:
		uliEmptyFlagClearMask = (alt_u32) COMM_IRQ_R_BUFF_1_E_FLG_CLR_MSK;
		break;
	default:
		uliEmptyFlagClearMask = 0;
		;
		break;
	}

	vFeebWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
			COMM_IRQ_FLAGS_CLR_REG_OFST, uliEmptyFlagClearMask);

}

void vFeebCh1IrqFlagBufferEmpty(bool *pbChEmptyBufferFlags) {
	alt_u32 uliIrqFlagsReg = 0;

	if (pbChEmptyBufferFlags != NULL) {

		uliIrqFlagsReg = uliFeebReadReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
				COMM_IRQ_FLAGS_REG_OFST);
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = FALSE;
		}

	}
}

void vFeebCh2IrqFlagBufferEmpty(bool *pbChEmptyBufferFlags) {
	alt_u32 uliIrqFlagsReg = 0;

	if (pbChEmptyBufferFlags != NULL) {

		uliIrqFlagsReg = uliFeebReadReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
				COMM_IRQ_FLAGS_REG_OFST);
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = FALSE;
		}

	}
}

void vFeebCh3IrqFlagBufferEmpty(bool *pbChEmptyBufferFlags) {
	alt_u32 uliIrqFlagsReg = 0;

	if (pbChEmptyBufferFlags != NULL) {

		uliIrqFlagsReg = uliFeebReadReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
				COMM_IRQ_FLAGS_REG_OFST);
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = FALSE;
		}

	}
}

void vFeebCh4IrqFlagBufferEmpty(bool *pbChEmptyBufferFlags) {
	alt_u32 uliIrqFlagsReg = 0;

	if (pbChEmptyBufferFlags != NULL) {

		uliIrqFlagsReg = uliFeebReadReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
				COMM_IRQ_FLAGS_REG_OFST);
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = FALSE;
		}

	}
}

void vFeebCh5IrqFlagBufferEmpty(bool *pbChEmptyBufferFlags) {
	alt_u32 uliIrqFlagsReg = 0;

	if (pbChEmptyBufferFlags != NULL) {

		uliIrqFlagsReg = uliFeebReadReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
				COMM_IRQ_FLAGS_REG_OFST);
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = FALSE;
		}

	}
}

void vFeebCh6IrqFlagBufferEmpty(bool *pbChEmptyBufferFlags) {
	alt_u32 uliIrqFlagsReg = 0;

	if (pbChEmptyBufferFlags != NULL) {

		uliIrqFlagsReg = uliFeebReadReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
				COMM_IRQ_FLAGS_REG_OFST);
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = FALSE;
		}

	}
}

void vFeebCh7IrqFlagBufferEmpty(bool *pbChEmptyBufferFlags) {
	alt_u32 uliIrqFlagsReg = 0;

	if (pbChEmptyBufferFlags != NULL) {

		uliIrqFlagsReg = uliFeebReadReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
				COMM_IRQ_FLAGS_REG_OFST);
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = FALSE;
		}

	}
}

void vFeebCh8IrqFlagBufferEmpty(bool *pbChEmptyBufferFlags) {
	alt_u32 uliIrqFlagsReg = 0;

	if (pbChEmptyBufferFlags != NULL) {

		uliIrqFlagsReg = uliFeebReadReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
				COMM_IRQ_FLAGS_REG_OFST);
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqLeftEmptyBuffer1Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer0Flag] = FALSE;
		}
		if (uliIrqFlagsReg & (alt_u32) COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = TRUE;
		} else {
			pbChEmptyBufferFlags[eFeebIrqRightEmptyBuffer1Flag] = FALSE;
		}

	}
}

bool bFeebCh1SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
			COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
			COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}
	}

	return bStatus;
}

bool bFeebCh2SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
			COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
			COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}
	}

	return bStatus;
}

bool bFeebCh3SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
			COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
			COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}
	}

	return bStatus;
}

bool bFeebCh4SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
			COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
			COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}
	}

	return bStatus;
}

bool bFeebCh5SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
			COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
			COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}
	}

	return bStatus;
}

bool bFeebCh6SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
			COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
			COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}
	}

	return bStatus;
}

bool bFeebCh7SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
			COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
			COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}
	}

	return bStatus;
}

bool bFeebCh8SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
			COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
			COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}
	}

	return bStatus;
}

bool vFeebInitIrq(alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	switch (ucCommCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_1_BUFFERS_IRQ, pvHoldContext,
				vFeebCh1HandleIrq);

		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_BUFFERS_IRQ, pvHoldContext,
				vFeebCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_BUFFERS_IRQ, pvHoldContext,
				vFeebCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_BUFFERS_IRQ, pvHoldContext,
				vFeebCh4HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_5_BUFFERS_IRQ, pvHoldContext,
				vFeebCh5HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_6_BUFFERS_IRQ, pvHoldContext,
				vFeebCh6HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_7_BUFFERS_IRQ, pvHoldContext,
				vFeebCh7HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_8_BUFFERS_IRQ, pvHoldContext,
				vFeebCh8HandleIrq);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bFeebSetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_IRQ_CONTROL_REG_OFST);

		if (pxFeebCh->xIrqControl.bLeftBufferEmptyEn) {
			uliReg |= COMM_IRQ_LEFT_BUFF_EPY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_LEFT_BUFF_EPY_EN_MSK);
		}
		if (pxFeebCh->xIrqControl.bRightBufferEmptyEn) {
			uliReg |= COMM_IRQ_RIGH_BUFF_EPY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_RIGH_BUFF_EPY_EN_MSK);
		}

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_IRQ_CONTROL_REG_OFST,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_IRQ_CONTROL_REG_OFST);

		if (uliReg & COMM_IRQ_LEFT_BUFF_EPY_EN_MSK) {
			pxFeebCh->xIrqControl.bLeftBufferEmptyEn = TRUE;
		} else {
			pxFeebCh->xIrqControl.bLeftBufferEmptyEn = FALSE;
		}
		if (uliReg & COMM_IRQ_RIGH_BUFF_EPY_EN_MSK) {
			pxFeebCh->xIrqControl.bRightBufferEmptyEn = TRUE;
		} else {
			pxFeebCh->xIrqControl.bRightBufferEmptyEn = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetIrqFlags(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
				COMM_IRQ_FLAGS_REG_OFST);

		if (uliReg & COMM_IRQ_L_BUFF_0_EPY_FLG_MSK) {
			pxFeebCh->xIrqFlag.bLeftBufferEmpty0Flag = TRUE;
		} else {
			pxFeebCh->xIrqFlag.bLeftBufferEmpty0Flag = FALSE;
		}

		if (uliReg & COMM_IRQ_L_BUFF_1_EPY_FLG_MSK) {
			pxFeebCh->xIrqFlag.bLeftBufferEmpty1Flag = TRUE;
		} else {
			pxFeebCh->xIrqFlag.bLeftBufferEmpty1Flag = FALSE;
		}

		if (uliReg & COMM_IRQ_R_BUFF_0_EPY_FLG_MSK) {
			pxFeebCh->xIrqFlag.bRightBufferEmpty0Flag = TRUE;
		} else {
			pxFeebCh->xIrqFlag.bRightBufferEmpty0Flag = FALSE;
		}

		if (uliReg & COMM_IRQ_R_BUFF_1_EPY_FLG_MSK) {
			pxFeebCh->xIrqFlag.bRightBufferEmpty1Flag = TRUE;
		} else {
			pxFeebCh->xIrqFlag.bRightBufferEmpty1Flag = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetBuffersStatus(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_STAT_REG_OFST);

		if (uliReg & COMM_WIND_LEFT_BUFF_EMPTY_MSK) {
			pxFeebCh->xBufferStatus.bLeftBufferEmpty = TRUE;
		} else {
			pxFeebCh->xBufferStatus.bLeftBufferEmpty = FALSE;
		}
		if (uliReg & COMM_WIND_RIGH_BUFF_EMPTY_MSK) {
			pxFeebCh->xBufferStatus.bRightBufferEmpty = TRUE;
		} else {
			pxFeebCh->xBufferStatus.bRightBufferEmpty = FALSE;
		}

		if (uliReg & COMM_WIND_RIGH_FEE_BUSY_MSK) {
			pxFeebCh->xBufferStatus.bRightFeeBusy = TRUE;
		} else {
			pxFeebCh->xBufferStatus.bRightFeeBusy = FALSE;
		}
		if (uliReg & COMM_WIND_LEFT_FEE_BUSY_MSK) {
			pxFeebCh->xBufferStatus.bLeftFeeBusy = TRUE;
		} else {
			pxFeebCh->xBufferStatus.bLeftFeeBusy = FALSE;
		}

		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_RIGT_FEEBUFF_SIZE_REG_OFST);
		pxFeebCh->xBufferStatus.ucRightBufferSize = (alt_u8) (uliReg
				& COMM_RIGT_FEEBUFF_SIZE_MSK) + 1;

		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_LEFT_FEEBUFF_SIZE_REG_OFST);
		pxFeebCh->xBufferStatus.ucRightBufferSize = (alt_u8) (uliReg
				& COMM_LEFT_FEEBUFF_SIZE_MSK) + 1;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetLeftBufferEmpty(TFeebChannel *pxFeebCh) {
	bool bFlag = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_STAT_REG_OFST);

		if (uliReg & COMM_WIND_LEFT_BUFF_EMPTY_MSK) {
			bFlag = TRUE;
		} else {
			bFlag = FALSE;
		}

	}

	return bFlag;
}

bool bFeebGetRightBufferEmpty(TFeebChannel *pxFeebCh) {
	bool bFlag = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_STAT_REG_OFST);

		if (uliReg & COMM_WIND_RIGH_BUFF_EMPTY_MSK) {
			bFlag = TRUE;
		} else {
			bFlag = FALSE;
		}

	}

	return bFlag;
}

bool bFeebGetCh1LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_1_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh1RightBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_1_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh2LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_2_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh2RightBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_2_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh3LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_3_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh3RightBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_3_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh4LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_4_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh4RightBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_4_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh5LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_5_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh5RightBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_5_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh6LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_6_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh6RightBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_6_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh7LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_7_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh7RightBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_7_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh8LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_8_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_BUFF_EMPTY_MSK);
	return bFlag;
}

bool bFeebGetCh8RightBufferEmpty(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_8_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_BUFF_EMPTY_MSK);
	return bFlag;
}


bool bFeebGetCh1LeftFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_1_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh1RightFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_1_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh2LeftFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_2_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh2RightFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_2_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh3LeftFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_3_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh3RightFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_3_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh4LeftFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_4_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh4RightFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_4_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh5LeftFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_5_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh5RightFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_5_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh6LeftFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_6_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh6RightFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_6_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh7LeftFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_7_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh7RightFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_7_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh8LeftFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_8_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_LEFT_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebGetCh8RightFeeBusy(void) {
	bool bFlag = FALSE;
	bFlag = bFeebGetChFlag(COMM_CHANNEL_8_BASE_ADDR, COMM_FEE_BUFF_STAT_REG_OFST, COMM_WIND_RIGH_FEE_BUSY_MSK);
	return bFlag;
}

bool bFeebSetBufferSize(TFeebChannel *pxFeebCh, alt_u8 ucBufferSizeInBlocks,
		alt_u8 ucBufferSide) {
	bool bStatus = TRUE;
	volatile alt_u32 uliReg = 0;

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_LEFT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg(pxFeebCh->puliFeebChAddr,
					COMM_LEFT_FEEBUFF_SIZE_REG_OFST, uliReg);
			break;
		case eCommRightBuffer:
			uliReg = (alt_u32) ((ucBufferSizeInBlocks - 1)
					& COMM_RIGT_FEEBUFF_SIZE_MSK);
			vFeebWriteReg(pxFeebCh->puliFeebChAddr,
					COMM_RIGT_FEEBUFF_SIZE_REG_OFST, uliReg);
			break;
		default:
			bStatus = FALSE;
			break;
		}
	} else {
		bStatus = FALSE;
	}

	return bStatus;
}

bool bFeebSetWindowing(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_CFG_REG_OFST);

		if (pxFeebCh->xWindowingConfig.bMasking) {
			uliReg |= COMM_FEE_MASKING_EN_MSK;
		} else {
			uliReg &= (~COMM_FEE_MASKING_EN_MSK);
		}

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_FEE_BUFF_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetWindowing(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_CFG_REG_OFST);

		if (uliReg & COMM_FEE_MASKING_EN_MSK) {
			pxFeebCh->xWindowingConfig.bMasking = TRUE;
		} else {
			pxFeebCh->xWindowingConfig.bMasking = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebStartCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_CFG_REG_OFST);

		uliReg |= COMM_FEE_MACHINE_START_MSK;

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_FEE_BUFF_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebStopCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_CFG_REG_OFST);

		uliReg |= COMM_FEE_MACHINE_STOP_MSK;

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_FEE_BUFF_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebClrCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_CFG_REG_OFST);

		uliReg |= COMM_FEE_MACHINE_CLR_MSK;

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_FEE_BUFF_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebInitCh(TFeebChannel *pxFeebCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;

	if (pxFeebCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh7:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh8:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bFeebGetIrqControl(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetIrqFlags(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetBuffersStatus(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetWindowing(pxFeebCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}

//! [public functions]

//! [private functions]
static ALT_INLINE bool ALT_ALWAYS_INLINE bFeebGetChFlag(alt_u32 uliCommChBaseAddr, alt_u32 uliCommRegOffset, alt_u32 uliCommFlagMask) {
	bool bFlag = FALSE;
	volatile alt_u32 uliReg = 0;

	uliReg = uliFeebReadReg((alt_u32 *) uliCommChBaseAddr, uliCommRegOffset);

	if (uliReg & uliCommFlagMask) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;

	}

	return bFlag;
}

static void vFeebWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliFeebReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	volatile alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
