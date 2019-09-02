/*
 * rmap.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "rmap.h"

//! [private function prototypes]
static alt_u32 uliConvRmapCfgAddr(alt_u32 puliRmapAddr);
//! [private function prototypes]

//! [data memory public global variables]
TRmapChannel xRmap[N_OF_NFEE];
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
/* todo:Trigger not working right */
void vRmapCh1HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_1_BASE_ADDR + COMM_RMAP_OFST);

	/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IRQ RMAP.\n");
	}
#endif

	ucADDRReg = (unsigned char)uliRmapCh1WriteCmdAddress();

	uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 0;
	uiCmdRmap.ucByte[2] = M_FEE_RMAP;
	uiCmdRmap.ucByte[1] = ucADDRReg;
	uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[0];

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IucADDRReg: %u\n", ucADDRReg);
	}
#endif

	error_codel = OSQPostFront(xFeeQ[0], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendRMAPFromIRQ( 0 );
	}

	vpxRmapChannel->xIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh2HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_2_BASE_ADDR + COMM_RMAP_OFST);

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IRQ RMAP.\n");
	}
#endif

	ucADDRReg = (unsigned char)uliRmapCh2WriteCmdAddress();

	uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 1;
	uiCmdRmap.ucByte[2] = M_FEE_RMAP;
	uiCmdRmap.ucByte[1] = ucADDRReg;
	uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[1];

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IucADDRReg: %u\n", ucADDRReg);
	}
#endif

	error_codel = OSQPostFront(xFeeQ[1], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendRMAPFromIRQ( 1 );
	}


	vpxRmapChannel->xIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh3HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_3_BASE_ADDR + COMM_RMAP_OFST);

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IRQ RMAP.\n");
	}
#endif

	ucADDRReg = (unsigned char)uliRmapCh3WriteCmdAddress();

	uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 2;
	uiCmdRmap.ucByte[2] = M_FEE_RMAP;
	uiCmdRmap.ucByte[1] = ucADDRReg;
	uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[2];

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IucADDRReg: %u\n", ucADDRReg);
	}
#endif

	error_codel = OSQPostFront(xFeeQ[2], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendRMAPFromIRQ( 2 );
	}

	vpxRmapChannel->xIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh4HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_4_BASE_ADDR + COMM_RMAP_OFST);

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IRQ RMAP.\n");
	}
#endif

	ucADDRReg = (unsigned char)uliRmapCh4WriteCmdAddress();

	uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 3;
	uiCmdRmap.ucByte[2] = M_FEE_RMAP;
	uiCmdRmap.ucByte[1] = ucADDRReg;
	uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[3];

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IucADDRReg: %u\n", ucADDRReg);
	}
#endif

	error_codel = OSQPostFront(xFeeQ[3], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendRMAPFromIRQ( 3 );
	}

	vpxRmapChannel->xIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh5HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_5_BASE_ADDR + COMM_RMAP_OFST);

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IRQ RMAP.\n");
	}
#endif

	ucADDRReg = (unsigned char)uliRmapCh4WriteCmdAddress();

	uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 4;
	uiCmdRmap.ucByte[2] = M_FEE_RMAP;
	uiCmdRmap.ucByte[1] = ucADDRReg;
	uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[4];

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IucADDRReg: %u\n", ucADDRReg);
	}
#endif

	error_codel = OSQPostFront(xFeeQ[4], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendRMAPFromIRQ( 4 );
	}

	vpxRmapChannel->xIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh6HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_6_BASE_ADDR + COMM_RMAP_OFST);

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IRQ RMAP.\n");
	}
#endif

	ucADDRReg = (unsigned char)uliRmapCh4WriteCmdAddress();

	uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 5;
	uiCmdRmap.ucByte[2] = M_FEE_RMAP;
	uiCmdRmap.ucByte[1] = ucADDRReg;
	uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[5];

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IucADDRReg: %u\n", ucADDRReg);
	}
#endif

	error_codel = OSQPostFront(xFeeQ[5], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendRMAPFromIRQ( 5 );
	}

	vpxRmapChannel->xIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh7HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_7_BASE_ADDR + COMM_RMAP_OFST);

	vpxRmapChannel->xIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh8HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_8_BASE_ADDR + COMM_RMAP_OFST);

	vpxRmapChannel->xIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

alt_u32 uliRmapCh1WriteCmdAddress(void) {
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_1_BASE_ADDR + COMM_RMAP_OFST);
	return (uliConvRmapCfgAddr(vpxRmapChannel->xMemConfigStat.uliLastWriteAddress));
}

alt_u32 uliRmapCh2WriteCmdAddress(void) {
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_2_BASE_ADDR + COMM_RMAP_OFST);
	return (uliConvRmapCfgAddr(vpxRmapChannel->xMemConfigStat.uliLastWriteAddress));
}

alt_u32 uliRmapCh3WriteCmdAddress(void) {
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_3_BASE_ADDR + COMM_RMAP_OFST);
	return (uliConvRmapCfgAddr(vpxRmapChannel->xMemConfigStat.uliLastWriteAddress));
}

alt_u32 uliRmapCh4WriteCmdAddress(void) {
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_4_BASE_ADDR + COMM_RMAP_OFST);
	return (uliConvRmapCfgAddr(vpxRmapChannel->xMemConfigStat.uliLastWriteAddress));
}

alt_u32 uliRmapCh5WriteCmdAddress(void) {
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_5_BASE_ADDR + COMM_RMAP_OFST);
	return (uliConvRmapCfgAddr(vpxRmapChannel->xMemConfigStat.uliLastWriteAddress));
}

alt_u32 uliRmapCh6WriteCmdAddress(void) {
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_6_BASE_ADDR + COMM_RMAP_OFST);
	return (uliConvRmapCfgAddr(vpxRmapChannel->xMemConfigStat.uliLastWriteAddress));
}

alt_u32 uliRmapCh7WriteCmdAddress(void) {
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_7_BASE_ADDR + COMM_RMAP_OFST);
	return (uliConvRmapCfgAddr(vpxRmapChannel->xMemConfigStat.uliLastWriteAddress));
}

alt_u32 uliRmapCh8WriteCmdAddress(void) {
	volatile TRmapChannel *vpxRmapChannel = (TRmapChannel *)(COMM_CHANNEL_8_BASE_ADDR + COMM_RMAP_OFST);
	return (uliConvRmapCfgAddr(vpxRmapChannel->xMemConfigStat.uliLastWriteAddress));
}

bool vRmapInitIrq(alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	switch (ucCommCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_1_RMAP_IRQ, pvHoldContext, vRmapCh1HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_RMAP_IRQ, pvHoldContext, vRmapCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_RMAP_IRQ, pvHoldContext, vRmapCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_RMAP_IRQ, pvHoldContext, vRmapCh4HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_5_RMAP_IRQ, pvHoldContext, vRmapCh5HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_6_RMAP_IRQ, pvHoldContext, vRmapCh6HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_7_RMAP_IRQ, pvHoldContext, vRmapCh7HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_8_RMAP_IRQ, pvHoldContext, vRmapCh8HandleIrq);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bRmapSetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		vpxRmapChannel->xIrqControl = pxRmapCh->xIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		pxRmapCh->xIrqControl = vpxRmapChannel->xIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		pxRmapCh->xIrqFlag = vpxRmapChannel->xIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		vpxRmapChannel->xCodecConfig = pxRmapCh->xCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		pxRmapCh->xCodecConfig = vpxRmapChannel->xCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		pxRmapCh->xCodecStatus = vpxRmapChannel->xCodecStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecError(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		pxRmapCh->xCodecError = vpxRmapChannel->xCodecError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetMemConfigArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		vpxRmapChannel->pxMemArea->xRmapMemConfigArea = pxRmapCh->pxMemArea->xRmapMemConfigArea;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfigArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		pxRmapCh->pxMemArea->xRmapMemConfigArea = vpxRmapChannel->pxMemArea->xRmapMemConfigArea;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfigStat(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		pxRmapCh->xMemConfigStat = vpxRmapChannel->xMemConfigStat;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetRmapMemHKArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		vpxRmapChannel->pxMemArea->xRmapMemHKArea = pxRmapCh->pxMemArea->xRmapMemHKArea;

		bStatus = TRUE;
	}

	return bStatus;

}

bool bRmapGetRmapMemHKArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TRmapChannel *vpxRmapChannel;

	if (pxRmapCh != NULL) {

		vpxRmapChannel = (TRmapChannel *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		pxRmapCh->pxMemArea->xRmapMemHKArea = vpxRmapChannel->pxMemArea->xRmapMemHKArea;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	alt_u32 *uliCommChBaseAddr;

	if (pxRmapCh != NULL) {

		uliCommChBaseAddr = (alt_u32 *)((alt_u32)pxRmapCh + COMM_RMAP_BASE_ADDR_OFST);

		switch (ucCommCh) {
		case eCommSpwCh1:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh7:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh8:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bRmapGetIrqControl(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetCodecConfig(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetCodecStatus(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetMemConfigArea(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetMemConfigStat(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetRmapMemHKArea(pxRmapCh)) {
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
alt_u32 uliRmapReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	volatile alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}

static alt_u32 uliConvRmapCfgAddr(alt_u32 puliRmapAddr) {
	alt_u32 uliValue;

	switch (puliRmapAddr) {
	case 0x00000000:
		uliValue = 0x00000040;
		break;
	case 0x00000004:
		uliValue = 0x00000041;
		break;
	case 0x00000008:
		uliValue = 0x00000042;
		break;
	case 0x0000000C:
		uliValue = 0x00000043;
		break;
	case 0x00000010:
		uliValue = 0x00000044;
		break;
	case 0x00000014:
		uliValue = 0x00000045;
		break;
	case 0x00000018:
		uliValue = 0x00000046;
		break;
	case 0x0000001C:
		uliValue = 0x00000047;
		break;
	case 0x00000020:
		uliValue = 0x00000048;
		break;
	case 0x00000024:
		uliValue = 0x00000049;
		break;
	case 0x00000028:
		uliValue = 0x0000004A;
		break;
	case 0x0000002C:
		uliValue = 0x0000004B;
		break;
	case 0x00000038:
		uliValue = 0x0000004C;
		break;
	case 0x0000003C:
		uliValue = 0x0000004D;
		break;
	case 0x00000040:
		uliValue = 0x0000004E;
		break;
	case 0x00000044:
		uliValue = 0x0000004F;
		break;
	case 0x00000048:
		uliValue = 0x00000050;
		break;
	case 0x0000004C:
		uliValue = 0x00000051;
		break;
	default:
		uliValue = 0x00000000;
		break;
	}

	return uliValue;
}
//! [private functions]
