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

	const unsigned char cucFeeNumber = 0;
	const unsigned char cucIrqNumber = 0;
	const unsigned char cucChNumber = 0;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = cucChNumber;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = eCommLeftBuffer; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 1 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = eCommRightBuffer; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 1 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}

#if DEBUG_ON
	if (xDefaults.ucDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF%u\n", cucIrqNumber);
	}
#endif

}

void vFeebCh2HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	INT8U error_codel;
	tQMask uiCmdtoSend;

	const unsigned char cucFeeNumber = 1;
	const unsigned char cucIrqNumber = 1;
	const unsigned char cucChNumber = 1;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = cucChNumber;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = eCommLeftBuffer; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 2 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = eCommRightBuffer; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 2 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}

#if DEBUG_ON
	if (xDefaults.ucDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF%u\n", cucIrqNumber);
	}
#endif

}

void vFeebCh3HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	INT8U error_codel;
	tQMask uiCmdtoSend;

	const unsigned char cucFeeNumber = 2;
	const unsigned char cucIrqNumber = 2;
	const unsigned char cucChNumber = 2;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = cucChNumber;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = eCommLeftBuffer; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 3 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = eCommRightBuffer; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 3 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}

#if DEBUG_ON
	if (xDefaults.ucDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF%u\n", cucIrqNumber);
	}
#endif

}

void vFeebCh4HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	INT8U error_codel;
	tQMask uiCmdtoSend;

	const unsigned char cucFeeNumber = 3;
	const unsigned char cucIrqNumber = 3;
	const unsigned char cucChNumber = 3;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = cucChNumber;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = eCommLeftBuffer; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 4 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = eCommRightBuffer; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 4 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}

#if DEBUG_ON
	if (xDefaults.ucDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF%u\n", cucIrqNumber);
	}
#endif

}

void vFeebCh5HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	INT8U error_codel;
	tQMask uiCmdtoSend;

	const unsigned char cucFeeNumber = 4;
	const unsigned char cucIrqNumber = 4;
	const unsigned char cucChNumber = 4;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = cucChNumber;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = eCommLeftBuffer; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 5 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = eCommRightBuffer; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 5 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}

#if DEBUG_ON
	if (xDefaults.ucDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF%u\n", cucIrqNumber);
	}
#endif

}

void vFeebCh6HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	INT8U error_codel;
	tQMask uiCmdtoSend;

	const unsigned char cucFeeNumber = 5;
	const unsigned char cucIrqNumber = 5;
	const unsigned char cucChNumber = 5;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
	//uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED;
	uiCmdtoSend.ucByte[1] = 0;
	//uiCmdtoSend.ucByte[0] = cucChNumber;
	uiCmdtoSend.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_L;
		uiCmdtoSend.ucByte[1] = eCommLeftBuffer; /*Left*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 6 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBuffCtrlFinishedFlag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;

		uiCmdtoSend.ucByte[2] = M_FEE_TRANS_FINISHED_D;
		uiCmdtoSend.ucByte[1] = eCommRightBuffer; /*Right*/

		/*Sync the Meb task and tell that has a PUS command waiting*/
#if ( 6 <= N_OF_NFEE )
		error_codel = OSQPost(xFeeQ[cucFeeNumber], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailRequestDMAFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n, cucFeeNumber");
#endif

	}

#if DEBUG_ON
	if (xDefaults.ucDebugLevel <= dlMinorMessage) {
		fprintf(fp, "IntF%u\n", cucIrqNumber);
	}
#endif

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
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_1_BUFFERS_IRQ, pvHoldContext, vFeebCh1HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_BUFFERS_IRQ, pvHoldContext, vFeebCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_BUFFERS_IRQ, pvHoldContext, vFeebCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_BUFFERS_IRQ, pvHoldContext, vFeebCh4HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_5_BUFFERS_IRQ, pvHoldContext, vFeebCh5HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBuffCtrlFinishedFlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBuffCtrlFinishedFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_6_BUFFERS_IRQ, pvHoldContext, vFeebCh6HandleIrq);
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

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebIrqControl = pxFeebCh->xFeebIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebIrqControl = vpxCommChannel->xFeeBuffer.xFeebIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetIrqFlags(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebIrqFlag = vpxCommChannel->xFeeBuffer.xFeebIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetBuffersStatus(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebBufferStatus = vpxCommChannel->xFeeBuffer.xFeebBufferStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetLeftBufferEmpty(TFeebChannel *pxFeebCh) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;

	}

	return bFlag;
}

bool bFeebGetRightBufferEmpty(TFeebChannel *pxFeebCh) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;

	}

	return bFlag;
}

bool bFeebGetCh1LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh1RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh2LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh2RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh3LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh3RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh4LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh4RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh5LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh5RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh6LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh6RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh1LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh1RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh2LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh2RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh3LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh3RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh4LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh4RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh5LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh5RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh6LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh6RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetBufferDataControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebBufferDataControl = vpxCommChannel->xFeeBuffer.xFeebBufferDataControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebSetBufferDataControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebBufferDataControl = pxFeebCh->xFeebBufferDataControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetBufferDataStatus(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebBufferDataStatus = vpxCommChannel->xFeeBuffer.xFeebBufferDataStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetMachineControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebMachineControl = vpxCommChannel->xFeeBuffer.xFeebMachineControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebSetMachineControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl = pxFeebCh->xFeebMachineControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebClearMachineStatistics(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetMachineStatistics(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebMachineStatistics = vpxCommChannel->xFeeBuffer.xFeebMachineStatistics;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebStartCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bStart = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebStopCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bStop = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebClrCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebSetPxStorageSize(TFeebChannel *pxFeebCh, alt_u8 ucBufferSide, alt_u32 uliPxStorageSizeBytes, alt_u16 usiDataPktLength){
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		switch (ucBufferSide) {
			case eCommLeftBuffer:
				vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);
				/* The hardware need the storage size in Pixels, 2 Bytes = 1 Pixel */
				vpxCommChannel->xFeeBuffer.xFeebMachineControl.uliLeftPxStorageSize =
						(alt_u32)(((uliPxStorageSizeBytes - FEEB_PX_INT_STORAGE_SIZE_BYTES - 2*(usiDataPktLength - FEEB_DATAPKT_HEADER_SIZE_BYTES)) / 2) - 1);
				bStatus = TRUE;
				break;
			case eCommRightBuffer:
				vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);
				/* The hardware need the storage size in Pixels, 2 Bytes = 1 Pixel */
				vpxCommChannel->xFeeBuffer.xFeebMachineControl.uliRightPxStorageSize =
						(alt_u32)(((uliPxStorageSizeBytes - FEEB_PX_INT_STORAGE_SIZE_BYTES - 2*(usiDataPktLength - FEEB_DATAPKT_HEADER_SIZE_BYTES)) / 2) - 1);
				bStatus = TRUE;
				break;
			default:
				bStatus = FALSE;
				break;
		}

	}

	return (bStatus);
}

bool bFeebInitCh(TFeebChannel *pxFeebCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
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
			if (!bFeebGetBufferDataControl(pxFeebCh)) {
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
