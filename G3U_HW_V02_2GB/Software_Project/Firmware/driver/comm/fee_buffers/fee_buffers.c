/*
 * fee_buffers.c
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#include "fee_buffers.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
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

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + 0;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = 0;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[0];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = 0; /*Left*/
		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[0], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 0; /*Left*/
		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[0], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = 1; /*Right*/
		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[0], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 1; /*Right*/
		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[0], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
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

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + 1;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = 1;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[1];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[1], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[1], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[1], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[1], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
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

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + 2;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = 2;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[2];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[2], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[2], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[2], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[2], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
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

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + 3;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = 3;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[3];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[3], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[3], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[3], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[3], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
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

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + 4;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = 4;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[4];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[4], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[4], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[4], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[4], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF4\n");
	}
#endif

}

void vFeebCh6HandleIrq(void* pvContext) {
//	//volatile int* pviHoldContext = (volatile int*) pvContext;

	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + 5;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = 5;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[5];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[5], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 0; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[5], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[5], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(1);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {

		uiCmdtoSend.ucByte[1] = 1; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xFeeQ[5], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ(0);
		}

		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
	}

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF5\n");
	}
#endif

}

void vFeebCh7HandleIrq(void* pvContext) {
//	//volatile int* pviHoldContext = (volatile int*) pvContext;
//
//	INT8U error_codel;
//	tQMask uiCmdtoSend;
//
//	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
//	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
//	uiCmdtoSend.ucByte[1] = 0;
//	//uiCmdtoSend.ucByte[0] = 6;
//	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[6];
//
//	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
//
//	// Check Irq Buffer Empty Flags
//	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
//
//		/*Sync the Meb task and tell that has a PUS command waiting*/
//		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
//		if (error_codel != OS_ERR_NONE) {
//			vFailRequestDMAFromIRQ(0);
//		}
//
//		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
//	}
//	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {
//
//		/*Sync the Meb task and tell that has a PUS command waiting*/
//		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
//		if (error_codel != OS_ERR_NONE) {
//			vFailRequestDMAFromIRQ(0);
//		}
//
//		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
//	}
//	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
//
//		/*Sync the Meb task and tell that has a PUS command waiting*/
//		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
//		if (error_codel != OS_ERR_NONE) {
//			vFailRequestDMAFromIRQ(1);
//		}
//
//		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
//	}
//	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {
//
//		/*Sync the Meb task and tell that has a PUS command waiting*/
//		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
//		if (error_codel != OS_ERR_NONE) {
//			vFailRequestDMAFromIRQ(0);
//		}
//
//		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
//	}
//
//#if DEBUG_ON
//	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
//		fprintf(fp, "IntF6\n");
//	}
//#endif

}

void vFeebCh8HandleIrq(void* pvContext) {
//	//volatile int* pviHoldContext = (volatile int*) pvContext;
//
//	INT8U error_codel;
//	tQMask uiCmdtoSend;
//
//	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
//	uiCmdtoSend.ucByte[2] = M_NFC_DMA_REQUEST;
//	uiCmdtoSend.ucByte[1] = 0;
//	//uiCmdtoSend.ucByte[0] = 7;
//	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[7];
//
//	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
//
//	// Check Irq Buffer Empty Flags
//	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
//
//		/*Sync the Meb task and tell that has a PUS command waiting*/
//		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
//		if (error_codel != OS_ERR_NONE) {
//			vFailRequestDMAFromIRQ(0);
//		}
//
//		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
//	}
//	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {
//
//		/*Sync the Meb task and tell that has a PUS command waiting*/
//		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
//		if (error_codel != OS_ERR_NONE) {
//			vFailRequestDMAFromIRQ(0);
//		}
//
//		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
//	}
//	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
//
//		/*Sync the Meb task and tell that has a PUS command waiting*/
//		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
//		if (error_codel != OS_ERR_NONE) {
//			vFailRequestDMAFromIRQ(1);
//		}
//
//		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
//	}
//	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {
//
//		/*Sync the Meb task and tell that has a PUS command waiting*/
//		error_codel = OSQPost(xNfeeSchedule, (void *) uiCmdtoSend.ulWord);
//		if (error_codel != OS_ERR_NONE) {
//			vFailRequestDMAFromIRQ(0);
//		}
//
//		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
//	}
//
//#if DEBUG_ON
//	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
//		fprintf(fp, "IntF7\n");
//	}
//#endif

}

bool bFeebCh1SetBufferSize(alt_u8 ucBufferSizeInBlocks, alt_u8 ucBufferSide) {
	bool bStatus = FALSE;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
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

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
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

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
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

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
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

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
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

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
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

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
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

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);

	if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
		switch (ucBufferSide) {
		case eCommLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
			bStatus = TRUE;
			break;
		case eCommRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
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
	volatile TCommChannel *vpxCommChannel;
	switch (ucCommCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_1_BUFFERS_IRQ, pvHoldContext, vFeebCh1HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_BUFFERS_IRQ, pvHoldContext, vFeebCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_BUFFERS_IRQ, pvHoldContext, vFeebCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_BUFFERS_IRQ, pvHoldContext, vFeebCh4HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_5_BUFFERS_IRQ, pvHoldContext, vFeebCh5HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_6_BUFFERS_IRQ, pvHoldContext, vFeebCh6HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_7_BUFFERS_IRQ, pvHoldContext, vFeebCh7HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_8_BUFFERS_IRQ, pvHoldContext, vFeebCh8HandleIrq);
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
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebIrqControl = pxFeebCh->xFeebIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebIrqControl = vpxCommChannel->xFeeBuffer.xFeebIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetIrqFlags(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebIrqFlag = vpxCommChannel->xFeeBuffer.xFeebIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetBuffersStatus(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebBufferStatus = vpxCommChannel->xFeeBuffer.xFeebBufferStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetLeftBufferEmpty(TFeebChannel *pxFeebCh) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;

	}

	return bFlag;
}

bool bFeebGetRightBufferEmpty(TFeebChannel *pxFeebCh) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;

	}

	return bFlag;
}

bool bFeebGetCh1LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh1RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh2LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh2RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh3LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh3RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh4LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh4RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh5LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh5RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh6LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh6RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh7LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh7RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh8LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh8RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh1LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh1RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh2LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh2RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh3LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh3RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh4LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh4RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh5LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh5RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh6LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh6RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh7LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh7RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh8LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh8RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebSetBufferSize(TFeebChannel *pxFeebCh, alt_u8 ucBufferSizeInBlocks,
		alt_u8 ucBufferSide) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		if ((0 < ucBufferSizeInBlocks) && (16 >= ucBufferSizeInBlocks)) {
			switch (ucBufferSide) {
			case eCommLeftBuffer:
				vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucLeftBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
				bStatus = TRUE;
				break;
			case eCommRightBuffer:
				vpxCommChannel->xFeeBuffer.xFeebBufferStatus.ucRightBufferSize = (alt_u8) (ucBufferSizeInBlocks - 1);
				bStatus = TRUE;
				break;
			default:
				bStatus = FALSE;
				break;
			}
		}
	}

	return bStatus;
}

bool bFeebSetMachineControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl = pxFeebCh->xFeebMachineControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetMachineControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebMachineControl = vpxCommChannel->xFeeBuffer.xFeebMachineControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebClearMachineStatistics(TFeebChannel *pxFeebCh){
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetMachineStatistics(TFeebChannel *pxFeebCh){
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebMachineStatistics = vpxCommChannel->xFeeBuffer.xFeebMachineStatistics;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebStartCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bStart = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebStopCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bStop = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebClrCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebInitCh(TFeebChannel *pxFeebCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_1_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_2_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_3_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_4_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_5_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_6_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh7:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_7_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh8:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_8_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) COMM_CHANNEL_8_BASE_ADDR;
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
			if (!bFeebGetMachineControl(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetMachineStatistics(pxFeebCh)) {
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
//! [private functions]
