/*
 * rmap.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "rmap.h"

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
/* todo:Trigger not working right */
void vRmapCh1HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);

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

	vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh2HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);

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


	vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh3HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);

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

	vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh4HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);

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

	vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh5HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);

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

	vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh6HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);

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

	vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh7HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);

	vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

void vRmapCh8HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);

	vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteCmdFlagClr = TRUE;
}

alt_u32 uliRmapCh1WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemConfigStat.uliLastWriteAddress);
}

alt_u32 uliRmapCh2WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemConfigStat.uliLastWriteAddress);
}

alt_u32 uliRmapCh3WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemConfigStat.uliLastWriteAddress);
}

alt_u32 uliRmapCh4WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemConfigStat.uliLastWriteAddress);
}

alt_u32 uliRmapCh5WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemConfigStat.uliLastWriteAddress);
}

alt_u32 uliRmapCh6WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemConfigStat.uliLastWriteAddress);
}

alt_u32 uliRmapCh7WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemConfigStat.uliLastWriteAddress);
}

alt_u32 uliRmapCh8WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemConfigStat.uliLastWriteAddress);
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
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapIrqControl = pxRmapCh->xRmapIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapIrqControl = vpxCommChannel->xRmap.xRmapIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapIrqFlag = vpxCommChannel->xRmap.xRmapIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapCodecConfig = pxRmapCh->xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecConfig = vpxCommChannel->xRmap.xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecStatus = vpxCommChannel->xRmap.xRmapCodecStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecError(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecError = vpxCommChannel->xRmap.xRmapCodecError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetMemConfigArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		*(vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr) = *(pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfigArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		*(pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr) = *(vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfigStat(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemConfigStat = vpxCommChannel->xRmap.xRmapMemConfigStat;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetRmapMemHKArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		*(vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr) = *(pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr);

		bStatus = TRUE;
	}

	return bStatus;

}

bool bRmapGetRmapMemHKArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		*(pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr) = *(vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_1_BASE_ADDR;
			pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_1_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_1_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_1_BASE_ADDR;
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_1_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_1_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_2_BASE_ADDR;
			pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_2_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_2_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_2_BASE_ADDR;
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_2_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_2_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_3_BASE_ADDR;
			pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_3_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_3_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_3_BASE_ADDR;
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_3_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_3_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_4_BASE_ADDR;
			pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_4_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_4_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_4_BASE_ADDR;
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_4_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_4_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_5_BASE_ADDR;
			pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_5_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_5_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_5_BASE_ADDR;
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_5_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_5_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_6_BASE_ADDR;
			pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_6_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_6_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_6_BASE_ADDR;
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_6_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_6_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			bValidCh = TRUE;
			break;
		case eCommSpwCh7:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_7_BASE_ADDR;
			pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_7_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_7_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_7_BASE_ADDR;
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_7_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_7_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			bValidCh = TRUE;
			break;
		case eCommSpwCh8:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_8_BASE_ADDR;
			pxRmapCh->xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_8_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			pxRmapCh->xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_8_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) COMM_CHANNEL_8_BASE_ADDR;
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_8_BASE_ADDR + COMM_RMAP_MEMAREA_CONFIG_OFST);
			vpxCommChannel->xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr = (alt_u32*) (COMM_CHANNEL_8_BASE_ADDR + COMM_RMAP_MEMAREA_HK_OFST);
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

//! [private functions]
