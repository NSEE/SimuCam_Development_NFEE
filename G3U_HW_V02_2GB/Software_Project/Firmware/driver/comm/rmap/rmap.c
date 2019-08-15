/*
 * rmap.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "rmap.h"

//! [private function prototypes]
static void vRmapWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset, alt_u32 uliValue);

static alt_u32 uliConvRmapCfgAddr(alt_u32 puliRmapAddr);

TRmapChannel xRmap[N_OF_NFEE];

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

	vRmapCh1IrqFlagClrWriteCmd();
}

void vRmapCh2HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;


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


	vRmapCh2IrqFlagClrWriteCmd();
}

void vRmapCh3HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;


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

	vRmapCh3IrqFlagClrWriteCmd();
}

void vRmapCh4HandleIrq(void* pvContext) {

	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;


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

	vRmapCh4IrqFlagClrWriteCmd();
}

void vRmapCh5HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;


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

	vRmapCh5IrqFlagClrWriteCmd();
}

void vRmapCh6HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;


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
	vRmapCh6IrqFlagClrWriteCmd();
}

void vRmapCh7HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh7IrqFlagClrWriteCmd();
}

void vRmapCh8HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh8IrqFlagClrWriteCmd();
}

void vRmapCh1IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh2IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh3IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh4IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh5IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh6IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh7IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh8IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

bool bRmapCh1IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh2IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh3IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh4IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh5IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh6IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh7IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh8IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

alt_u32 uliRmapCh1WriteCmdAddress(void) {
	volatile alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg((alt_u32*)
	COMM_CHANNEL_1_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);


	uliWriteAddr = uliConvRmapCfgAddr(uliWriteAddr);

	return uliWriteAddr;
}

alt_u32 uliRmapCh2WriteCmdAddress(void) {
	volatile alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg((alt_u32*)
	COMM_CHANNEL_2_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	uliWriteAddr = uliConvRmapCfgAddr(uliWriteAddr);

	return uliWriteAddr;
}

alt_u32 uliRmapCh3WriteCmdAddress(void) {
	volatile alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg((alt_u32*)
	COMM_CHANNEL_3_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	uliWriteAddr = uliConvRmapCfgAddr(uliWriteAddr);

	return uliWriteAddr;
}

alt_u32 uliRmapCh4WriteCmdAddress(void) {
	volatile alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg((alt_u32*)
	COMM_CHANNEL_4_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	uliWriteAddr = uliConvRmapCfgAddr(uliWriteAddr);

	return uliWriteAddr;
}

alt_u32 uliRmapCh5WriteCmdAddress(void) {
	volatile alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg((alt_u32*)
	COMM_CHANNEL_5_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	uliWriteAddr = uliConvRmapCfgAddr(uliWriteAddr);

	return uliWriteAddr;
}

alt_u32 uliRmapCh6WriteCmdAddress(void) {
	volatile alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg((alt_u32*)
	COMM_CHANNEL_6_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	uliWriteAddr = uliConvRmapCfgAddr(uliWriteAddr);

	return uliWriteAddr;
}

alt_u32 uliRmapCh7WriteCmdAddress(void) {
	volatile alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg((alt_u32*)
	COMM_CHANNEL_7_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	uliWriteAddr = uliConvRmapCfgAddr(uliWriteAddr);

	return uliWriteAddr;
}

alt_u32 uliRmapCh8WriteCmdAddress(void) {
	volatile alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg((alt_u32*)
	COMM_CHANNEL_8_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	uliWriteAddr = uliConvRmapCfgAddr(uliWriteAddr);

	return uliWriteAddr;
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
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_IRQ_CONTROL_REG_OFST);

		if (pxRmapCh->xRmapIrqControl.bWriteCmdEn) {
			uliReg |= COMM_IRQ_RMAP_WRCMD_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_RMAP_WRCMD_EN_MSK);
		}

		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_IRQ_CONTROL_REG_OFST,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_IRQ_CONTROL_REG_OFST);

		if (uliReg & COMM_IRQ_RMAP_WRCMD_EN_MSK) {
			pxRmapCh->xRmapIrqControl.bWriteCmdEn = TRUE;
		} else {
			pxRmapCh->xRmapIrqControl.bWriteCmdEn = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_IRQ_FLAGS_REG_OFST);

		if (uliReg & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
			pxRmapCh->xRmapIrqFlag.bWriteCmdFlag = TRUE;
		} else {
			pxRmapCh->xRmapIrqFlag.bWriteCmdFlag = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CODEC_CFG_REG_OFST);

		uliReg &= (~COMM_RMAP_TARGET_LOG_ADDR_MSK);
		uliReg |= (COMM_RMAP_TARGET_LOG_ADDR_MSK
				& (alt_u32) (pxRmapCh->xRmapCodecConfig.ucLogicalAddress << 0));
		uliReg &= (~COMM_RMAP_TARGET_KEY_MSK);
		uliReg |= (COMM_RMAP_TARGET_KEY_MSK
				& (alt_u32) (pxRmapCh->xRmapCodecConfig.ucKey << 8));

		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CODEC_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CODEC_CFG_REG_OFST);

		pxRmapCh->xRmapCodecConfig.ucLogicalAddress = (alt_u8) ((uliReg
				& COMM_RMAP_TARGET_LOG_ADDR_MSK) >> 0);
		pxRmapCh->xRmapCodecConfig.ucKey = (alt_u8) ((uliReg
				& COMM_RMAP_TARGET_KEY_MSK) >> 8);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CODEC_STAT_REG_OFST);

		if (uliReg & COMM_RMAP_STAT_CMD_RECEIVED_MSK) {
			pxRmapCh->xRmapCodecStatus.bCommandReceived = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bCommandReceived = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_WR_REQ_MSK) {
			pxRmapCh->xRmapCodecStatus.bWriteRequested = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bWriteRequested = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_WR_AUTH_MSK) {
			pxRmapCh->xRmapCodecStatus.bWriteAuthorized = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bWriteAuthorized = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_RD_REQ_MSK) {
			pxRmapCh->xRmapCodecStatus.bReadRequested = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bReadRequested = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_RD_AUTH_MSK) {
			pxRmapCh->xRmapCodecStatus.bReadAuthorized = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bReadAuthorized = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_REPLY_SEND_MSK) {
			pxRmapCh->xRmapCodecStatus.bReplySended = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bReplySended = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_DISCARD_PKG_MSK) {
			pxRmapCh->xRmapCodecStatus.bDiscardedPackage = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bCommandReceived = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetCodecError(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CODEC_STAT_REG_OFST);

		if (uliReg & COMM_RMAP_ERR_EARLY_EOP_MSK) {
			pxRmapCh->xRmapCodecError.bEarlyEop = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bEarlyEop = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_EEP_MSK) {
			pxRmapCh->xRmapCodecError.bEep = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bEep = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_HEADER_CRC_MSK) {
			pxRmapCh->xRmapCodecError.bHeaderCRC = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bHeaderCRC = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_UNUSED_PKT_MSK) {
			pxRmapCh->xRmapCodecError.bUnusedPacketType = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bUnusedPacketType = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_INVALID_CMD_MSK) {
			pxRmapCh->xRmapCodecError.bInvalidCommandCode = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bInvalidCommandCode = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_TOO_MUCH_DATA_MSK) {
			pxRmapCh->xRmapCodecError.bTooMuchData = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bTooMuchData = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_INVALID_DCRC_MSK) {
			pxRmapCh->xRmapCodecError.bInvalidDataCrc = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bInvalidDataCrc = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapSetMemConfigArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_SEQ_1_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcdSeq1Config;
//			uliReg &= (~COMM_RMAP_TRI_LV_CLK_CTRL_MSK);
//			uliReg |= (COMM_RMAP_TRI_LV_CLK_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcdSeq1Config. << 1));
//			uliReg &= (~COMM_RMAP_IMGCLK_DIR_CTRL_MSK);
//			uliReg |= (COMM_RMAP_IMGCLK_DIR_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcdSeq1Config. << 2));
//			uliReg &= (~COMM_RMAP_REGCLK_DIR_CTRL_MSK);
//			uliReg |= (COMM_RMAP_REGCLK_DIR_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcdSeq1Config. << 3));
//			uliReg &= (~COMM_RMAP_IMGCLK_TRCNT_CTRL_MSK);
//			uliReg |= (COMM_RMAP_IMGCLK_TRCNT_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcdSeq1Config. << 4));
//			uliReg &= (~COMM_RMAP_REGCLK_TRCNT_CTRL_MSK);
//			uliReg |= (COMM_RMAP_REGCLK_TRCNT_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcdSeq1Config. << 20));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_SEQ_1_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_SEQ_2_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcdSeq2Config;
//			uliReg &= (~COMM_RMAP_SL_RDOUT_PAUSE_CNT_MSK);
//			uliReg |= (COMM_RMAP_SL_RDOUT_PAUSE_CNT_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcdSeq2Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_SEQ_2_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_SPW_PKT_1_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliSpwPacket1Config;
//			uliReg &= (~COMM_RMAP_DIGITISE_CTRL_MSK);
//			uliReg |= (COMM_RMAP_DIGITISE_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliSpwPacket1Config. << 0));
//			uliReg &= (~COMM_RMAP_CCD_DTRAN_SEL_CTRL_MSK);
//			uliReg |= (COMM_RMAP_CCD_DTRAN_SEL_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliSpwPacket1Config. << 0));
//			uliReg &= (~COMM_RMAP_PACKET_SIZE_CTRL_MSK);
//			uliReg |= (COMM_RMAP_PACKET_SIZE_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliSpwPacket1Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_SPW_PKT_1_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_SPW_PKT_2_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliSpwPacket2Config;
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_SPW_PKT_2_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_1_W_1_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliFrameNumber;
//			uliReg &= (~COMM_RMAP_WLIST_P_IADDR_CCD1_MSK);
//			uliReg |= (COMM_RMAP_WLIST_P_IADDR_CCD1_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd1Windowing1Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_1_W_1_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_1_W_2_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcd1Windowing2Config;
//			uliReg &= (~COMM_RMAP_WINDOW_WIDTH_CCD1_MSK);
//			uliReg |= (COMM_RMAP_WINDOW_WIDTH_CCD1_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd1Windowing2Config. << 0));
//			uliReg &= (~COMM_RMAP_WINDOW_HEIGHT_CCD1_MSK);
//			uliReg |= (COMM_RMAP_WINDOW_HEIGHT_CCD1_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd1Windowing2Config. << 0));
//			uliReg &= (~COMM_RMAP_WLIST_LENGTH_CCD1_MSK);
//			uliReg |= (COMM_RMAP_WLIST_LENGTH_CCD1_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd1Windowing2Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_1_W_2_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_2_W_1_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcd2Windowing1Config;
//			uliReg &= (~COMM_RMAP_WLIST_P_IADDR_CCD2_MSK);
//			uliReg |= (COMM_RMAP_WLIST_P_IADDR_CCD2_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd2Windowing1Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_2_W_1_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_2_W_2_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcd2Windowing2Config;
//			uliReg &= (~COMM_RMAP_WINDOW_WIDTH_CCD2_MSK);
//			uliReg |= (COMM_RMAP_WINDOW_WIDTH_CCD2_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd2Windowing2Config. << 0));
//			uliReg &= (~COMM_RMAP_WINDOW_HEIGHT_CCD2_MSK);
//			uliReg |= (COMM_RMAP_WINDOW_HEIGHT_CCD2_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd2Windowing2Config. << 0));
//			uliReg &= (~COMM_RMAP_WLIST_LENGTH_CCD2_MSK);
//			uliReg |= (COMM_RMAP_WLIST_LENGTH_CCD2_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd2Windowing2Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_2_W_2_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_3_W_1_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcd3Windowing1Config;
//			uliReg &= (~COMM_RMAP_WLIST_P_IADDR_CCD3_MSK);
//			uliReg |= (COMM_RMAP_WLIST_P_IADDR_CCD3_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd3Windowing1Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_3_W_1_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_3_W_2_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcd3Windowing2Config;
//			uliReg &= (~COMM_RMAP_WINDOW_WIDTH_CCD3_MSK);
//			uliReg |= (COMM_RMAP_WINDOW_WIDTH_CCD3_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd3Windowing2Config. << 0));
//			uliReg &= (~COMM_RMAP_WINDOW_HEIGHT_CCD3_MSK);
//			uliReg |= (COMM_RMAP_WINDOW_HEIGHT_CCD3_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd3Windowing2Config. << 0));
//			uliReg &= (~COMM_RMAP_WLIST_LENGTH_CCD3_MSK);
//			uliReg |= (COMM_RMAP_WLIST_LENGTH_CCD3_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd3Windowing2Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_3_W_2_CFG_REG_OFST, uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_4_W_1_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcd4Windowing1Config;
//			uliReg &= (~COMM_RMAP_WLIST_P_IADDR_CCD4_MSK);
//			uliReg |= (COMM_RMAP_WLIST_P_IADDR_CCD4_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd4Windowing1Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_4_W_1_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CCD_4_W_2_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCcd4Windowing2Config;
//			uliReg &= (~COMM_RMAP_WINDOW_WIDTH_CCD4_MSK);
//			uliReg |= (COMM_RMAP_WINDOW_WIDTH_CCD4_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd4Windowing2Config. << 0));
//			uliReg &= (~COMM_RMAP_WINDOW_HEIGHT_CCD4_MSK);
//			uliReg |= (COMM_RMAP_WINDOW_HEIGHT_CCD4_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd4Windowing2Config. << 0));
//			uliReg &= (~COMM_RMAP_WLIST_LENGTH_CCD4_MSK);
//			uliReg |= (COMM_RMAP_WLIST_LENGTH_CCD4_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCcd4Windowing2Config. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_4_W_2_CFG_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_OP_MODE_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliOperationModeConfig;
//			uliReg &= (~COMM_RMAP_MODE_SEL_CTRL_MSK);
//			uliReg |= (COMM_RMAP_MODE_SEL_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliOperationModeConfig. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_OP_MODE_CFG_REG_OFST,
				uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_SYNC_CFG_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliSyncConfig;
//			uliReg &= (~COMM_RMAP_SYNC_CFG_MSK);
//			uliReg |= (COMM_RMAP_SYNC_CFG_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliSyncConfig. << 0));
//			uliReg &= (~COMM_RMAP_SELF_TRIGGER_CTRL_MSK);
//			uliReg |= (COMM_RMAP_SELF_TRIGGER_CTRL_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliSyncConfig. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_SYNC_CFG_REG_OFST,
				uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_DAC_CTRL_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliDacControl;
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_DAC_CTRL_REG_OFST,
				uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CLK_SRCE_CTRL_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliFrameNumber;
		vRmapWriteReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CLK_SRCE_CTRL_REG_OFST, uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_FRAME_NUMBER_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliFrameNumber;
//			uliReg &= (~COMM_RMAP_FRAME_NUMBER_MSK);
//			uliReg |= (COMM_RMAP_FRAME_NUMBER_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliFrameNumber. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_FRAME_NUMBER_REG_OFST,
				uliReg);

//		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CURRENT_MODE_REG_OFST);
		uliReg = pxRmapCh->xRmapMemConfigArea.uliCurrentMode;
//			uliReg &= (~COMM_RMAP_CURRENT_MODE_MSK);
//			uliReg |= (COMM_RMAP_CURRENT_MODE_MSK & (alt_u32)(pxRmapCh->xRmapMemConfigArea.uliCurrentMode. << 0));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CURRENT_MODE_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfigArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_SEQ_1_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcdSeq1Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_SEQ_2_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcdSeq2Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_SPW_PKT_1_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliSpwPacket1Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_SPW_PKT_2_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliSpwPacket2Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_1_W_1_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliFrameNumber = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_1_W_2_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcd1Windowing2Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_2_W_1_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcd2Windowing1Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_2_W_2_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcd2Windowing2Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_3_W_1_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcd3Windowing1Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_3_W_2_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcd3Windowing2Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_4_W_1_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcd4Windowing1Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CCD_4_W_2_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCcd4Windowing2Config = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_OP_MODE_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliOperationModeConfig = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_SYNC_CFG_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliSyncConfig = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_DAC_CTRL_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliDacControl = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CLK_SRCE_CTRL_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliFrameNumber = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_FRAME_NUMBER_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliFrameNumber = uliReg;

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CURRENT_MODE_REG_OFST);
		pxRmapCh->xRmapMemConfigArea.uliCurrentMode = uliReg;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfigStat(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_LST_RD_ADDR_REG_OFST);

		pxRmapCh->xRmapMemConfigStat.uliLastReadAddress = (alt_u32) ((uliReg
				& COMM_RMAP_LST_RD_ADDR_MSK) >> 0);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_LST_WR_ADDR_REG_OFST);

		pxRmapCh->xRmapMemConfigStat.uliLastWriteAddress = (alt_u32) ((uliReg
				& COMM_RMAP_LST_WR_ADDR_MSK) >> 0);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapSetRmapMemHKArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_0_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_CCD1_VOD_E_MSK);
		uliReg |= (COMM_RMAP_HK_CCD1_VOD_E_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd1VodE >> 0));
		uliReg &= (~COMM_RMAP_HK_CCD1_VOD_F_MSK);
		uliReg |= (COMM_RMAP_HK_CCD1_VOD_F_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd1VodF << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_0_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_1_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_CCD1_VRD_MON_MSK);
		uliReg |= (COMM_RMAP_HK_CCD1_VRD_MON_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd1VrdMon >> 0));
		uliReg &= (~COMM_RMAP_HK_CCD2_VOD_E_MSK);
		uliReg |= (COMM_RMAP_HK_CCD2_VOD_E_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd2VodE << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_1_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_2_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_CCD2_VOD_F_MSK);
		uliReg |= (COMM_RMAP_HK_CCD2_VOD_F_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd2VodF >> 0));
		uliReg &= (~COMM_RMAP_HK_CCD2_VRD_MON_MSK);
		uliReg |= (COMM_RMAP_HK_CCD2_VRD_MON_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd2VrdMon << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_2_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_3_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_CCD3_VOD_E_MSK);
		uliReg |= (COMM_RMAP_HK_CCD3_VOD_E_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd3VodE >> 0));
		uliReg &= (~COMM_RMAP_HK_CCD3_VOD_F_MSK);
		uliReg |= (COMM_RMAP_HK_CCD3_VOD_F_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd3VodF << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_3_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_4_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_CCD3_VRD_MON_MSK);
		uliReg |= (COMM_RMAP_HK_CCD3_VRD_MON_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd3VrdMon >> 0));
		uliReg &= (~COMM_RMAP_HK_CCD4_VOD_E_MSK);
		uliReg |= (COMM_RMAP_HK_CCD4_VOD_E_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd4VodE << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_4_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_5_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_CCD4_VOD_F_MSK);
		uliReg |= (COMM_RMAP_HK_CCD4_VOD_F_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd4VodF >> 0));
		uliReg &= (~COMM_RMAP_HK_CCD4_VRD_MON_MSK);
		uliReg |= (COMM_RMAP_HK_CCD4_VRD_MON_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd4VrdMon << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_5_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_6_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_VCCD_MSK);
		uliReg |= (COMM_RMAP_HK_VCCD_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVccd >> 0));
		uliReg &= (~COMM_RMAP_HK_VRCLK_MSK);
		uliReg |= (COMM_RMAP_HK_VRCLK_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVrclk << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_6_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_7_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_VICLK_MSK);
		uliReg |= (COMM_RMAP_HK_VICLK_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkViclk >> 0));
		uliReg &= (~COMM_RMAP_HK_VRCLK_LOW_MSK);
		uliReg |= (COMM_RMAP_HK_VRCLK_LOW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVrclkLow << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_7_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_8_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_5VB_POS_MSK);
		uliReg |= (COMM_RMAP_HK_5VB_POS_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHk5vbPos >> 0));
		uliReg &= (~COMM_RMAP_HK_5VB_NEG_MSK);
		uliReg |= (COMM_RMAP_HK_5VB_NEG_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHk5vbNeg << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_8_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_9_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_3_3VB_POS_MSK);
		uliReg |= (COMM_RMAP_HK_3_3VB_POS_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHk33vbPos >> 0));
		uliReg &= (~COMM_RMAP_HK_2_5VA_POS_MSK);
		uliReg |= (COMM_RMAP_HK_2_5VA_POS_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHk25vaPos << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_9_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_10_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_3_3VD_POS_MSK);
		uliReg |= (COMM_RMAP_HK_3_3VD_POS_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHk33vdPos >> 0));
		uliReg &= (~COMM_RMAP_HK_2_5VD_POS_MSK);
		uliReg |= (COMM_RMAP_HK_2_5VD_POS_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHk25vdPos << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_10_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_11_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_1_5VD_POS_MSK);
		uliReg |= (COMM_RMAP_HK_1_5VD_POS_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHk15vdPos >> 0));
		uliReg &= (~COMM_RMAP_HK_5VREF_MSK);
		uliReg |= (COMM_RMAP_HK_5VREF_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHk5vref << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_11_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_12_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_VCCD_POS_RAW_MSK);
		uliReg |= (COMM_RMAP_HK_VCCD_POS_RAW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVccdPosRaw >> 0));
		uliReg &= (~COMM_RMAP_HK_VCLK_POS_RAW_MSK);
		uliReg |= (COMM_RMAP_HK_VCLK_POS_RAW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVclkPosRaw << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_12_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_13_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_VAN1_POS_RAW_MSK);
		uliReg |= (COMM_RMAP_HK_VAN1_POS_RAW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVan1PosRaw >> 0));
		uliReg &= (~COMM_RMAP_HK_VAN3_NEG_RAW_MSK);
		uliReg |= (COMM_RMAP_HK_VAN3_NEG_RAW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVan3NegRaw << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_13_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_14_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_VAN2_POS_RAW_MSK);
		uliReg |= (COMM_RMAP_HK_VAN2_POS_RAW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVan2PosRaw >> 0));
		uliReg &= (~COMM_RMAP_HK_VDIG_FPGA_RAW_MSK);
		uliReg |= (COMM_RMAP_HK_VDIG_FPGA_RAW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVdigFpgaRaw << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_14_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_15_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_VDIG_SPW_RAW_MSK);
		uliReg |= (COMM_RMAP_HK_VDIG_SPW_RAW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkVdigSpwRaw >> 0));
		uliReg &= (~COMM_RMAP_HK_VICLK_LOW_MSK);
		uliReg |= (COMM_RMAP_HK_VICLK_LOW_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkViclkLow << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_15_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_16_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_ADC_TEMP_A_E_MSK);
		uliReg |= (COMM_RMAP_HK_ADC_TEMP_A_E_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkAdcTempAE >> 0));
		uliReg &= (~COMM_RMAP_HK_ADC_TEMP_A_F_MSK);
		uliReg |= (COMM_RMAP_HK_ADC_TEMP_A_F_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkAdcTempAF << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_16_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_17_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_CCD1_TEMP_MSK);
		uliReg |= (COMM_RMAP_HK_CCD1_TEMP_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd1Temp >> 0));
		uliReg &= (~COMM_RMAP_HK_CCD2_TEMP_MSK);
		uliReg |= (COMM_RMAP_HK_CCD2_TEMP_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd2Temp << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_17_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_18_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_CCD3_TEMP_MSK);
		uliReg |= (COMM_RMAP_HK_CCD3_TEMP_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd3Temp >> 0));
		uliReg &= (~COMM_RMAP_HK_CCD4_TEMP_MSK);
		uliReg |= (COMM_RMAP_HK_CCD4_TEMP_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkCcd4Temp << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_18_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_19_REG_OFST);
		uliReg &= (~COMM_RMAP_HK_WP605_SPARE_MSK);
		uliReg |= (COMM_RMAP_HK_WP605_SPARE_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiHkWp605Spare >> 0));
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_0_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_0_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA0 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_19_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_20_REG_OFST);
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_1_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_1_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA1 >> 0));
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_2_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_2_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA2 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_20_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_21_REG_OFST);
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_3_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_3_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA3 >> 0));
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_4_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_4_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA4 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_21_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_22_REG_OFST);
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_5_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_5_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA5 >> 0));
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_6_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_6_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA6 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_22_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_23_REG_OFST);
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_7_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_7_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA7 >> 0));
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_8_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_8_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA8 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_23_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_24_REG_OFST);
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_9_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_9_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA9 >> 0));
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_10_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_10_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA10 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_24_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_25_REG_OFST);
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_11_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_11_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA11 >> 0));
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_12_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_12_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA12 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_25_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_26_REG_OFST);
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_13_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_13_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA13 >> 0));
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_14_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_14_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA14 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_26_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_27_REG_OFST);
		uliReg &= (~COMM_RMAP_LOWRES_PRT_A_15_MSK);
		uliReg |= (COMM_RMAP_LOWRES_PRT_A_15_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiLowresPrtA15 >> 0));
		uliReg &= (~COMM_RMAP_SEL_HIRES_PRT0_MSK);
		uliReg |= (COMM_RMAP_SEL_HIRES_PRT0_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiSelHiresPrt0 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_27_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_28_REG_OFST);
		uliReg &= (~COMM_RMAP_SEL_HIRES_PRT1_MSK);
		uliReg |= (COMM_RMAP_SEL_HIRES_PRT1_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiSelHiresPrt1 >> 0));
		uliReg &= (~COMM_RMAP_SEL_HIRES_PRT2_MSK);
		uliReg |= (COMM_RMAP_SEL_HIRES_PRT2_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiSelHiresPrt2 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_28_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_29_REG_OFST);
		uliReg &= (~COMM_RMAP_SEL_HIRES_PRT3_MSK);
		uliReg |= (COMM_RMAP_SEL_HIRES_PRT3_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiSelHiresPrt3 >> 0));
		uliReg &= (~COMM_RMAP_SEL_HIRES_PRT4_MSK);
		uliReg |= (COMM_RMAP_SEL_HIRES_PRT4_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiSelHiresPrt4 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_29_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_30_REG_OFST);
		uliReg &= (~COMM_RMAP_SEL_HIRES_PRT5_MSK);
		uliReg |= (COMM_RMAP_SEL_HIRES_PRT5_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiSelHiresPrt5 >> 0));
		uliReg &= (~COMM_RMAP_SEL_HIRES_PRT6_MSK);
		uliReg |= (COMM_RMAP_SEL_HIRES_PRT6_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiSelHiresPrt6 << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_30_REG_OFST,
				uliReg);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_31_REG_OFST);
		uliReg &= (~COMM_RMAP_SEL_HIRES_PRT7_MSK);
		uliReg |= (COMM_RMAP_SEL_HIRES_PRT7_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiSelHiresPrt7 >> 0));
		uliReg &= (~COMM_RMAP_ZERO_HIRES_AMP_MSK);
		uliReg |= (COMM_RMAP_ZERO_HIRES_AMP_MSK
				& (alt_u32) (pxRmapCh->xRmapMemHKArea.usiZeroHiresAmp << 16));
		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_HK_31_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetRmapMemHKArea(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_0_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkCcd1VodE = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD1_VOD_E_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkCcd1VodF = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD1_VOD_F_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_1_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkCcd1VrdMon = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD1_VRD_MON_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkCcd2VodE = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD2_VOD_E_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_2_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkCcd2VodF = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD2_VOD_F_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkCcd2VrdMon = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD2_VRD_MON_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_3_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkCcd3VodE = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD3_VOD_E_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkCcd3VodF = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD3_VOD_F_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_4_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkCcd3VrdMon = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD3_VRD_MON_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkCcd4VodE = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD4_VOD_E_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_5_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkCcd4VodF = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD4_VOD_F_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkCcd4VrdMon = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD4_VRD_MON_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_6_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkVccd = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VCCD_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkVrclk = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VRCLK_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_7_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkViclk = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VICLK_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkVrclkLow = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VRCLK_LOW_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_8_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHk5vbPos = (alt_u16) ((uliReg
				& COMM_RMAP_HK_5VB_POS_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHk5vbNeg = (alt_u16) ((uliReg
				& COMM_RMAP_HK_5VB_NEG_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_9_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHk33vbPos = (alt_u16) ((uliReg
				& COMM_RMAP_HK_3_3VB_POS_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHk25vaPos = (alt_u16) ((uliReg
				& COMM_RMAP_HK_2_5VA_POS_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_10_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHk33vdPos = (alt_u16) ((uliReg
				& COMM_RMAP_HK_3_3VD_POS_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHk25vdPos = (alt_u16) ((uliReg
				& COMM_RMAP_HK_2_5VD_POS_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_11_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHk15vdPos = (alt_u16) ((uliReg
				& COMM_RMAP_HK_1_5VD_POS_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHk5vref = (alt_u16) ((uliReg
				& COMM_RMAP_HK_5VREF_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_12_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkVccdPosRaw = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VCCD_POS_RAW_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkVclkPosRaw = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VCLK_POS_RAW_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_13_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkVan1PosRaw = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VAN1_POS_RAW_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkVan3NegRaw = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VAN3_NEG_RAW_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_14_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkVan2PosRaw = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VAN2_POS_RAW_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkVdigFpgaRaw = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VDIG_FPGA_RAW_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_15_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkVdigSpwRaw = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VDIG_SPW_RAW_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkViclkLow = (alt_u16) ((uliReg
				& COMM_RMAP_HK_VICLK_LOW_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_16_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkAdcTempAE = (alt_u16) ((uliReg
				& COMM_RMAP_HK_ADC_TEMP_A_E_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkAdcTempAF = (alt_u16) ((uliReg
				& COMM_RMAP_HK_ADC_TEMP_A_F_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_17_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkCcd1Temp = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD1_TEMP_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkCcd2Temp = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD2_TEMP_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_18_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkCcd3Temp = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD3_TEMP_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiHkCcd4Temp = (alt_u16) ((uliReg
				& COMM_RMAP_HK_CCD4_TEMP_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_19_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiHkWp605Spare = (alt_u16) ((uliReg
				& COMM_RMAP_HK_WP605_SPARE_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA0 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_0_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_20_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA1 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_1_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA2 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_2_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_21_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA3 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_3_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA4 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_4_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_22_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA5 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_5_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA6 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_6_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_23_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA7 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_7_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA8 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_8_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_24_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA9 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_9_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA10 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_10_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_25_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA11 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_11_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA12 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_12_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_26_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA13 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_13_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA14 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_14_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_27_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiLowresPrtA15 = (alt_u16) ((uliReg
				& COMM_RMAP_LOWRES_PRT_A_15_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiSelHiresPrt0 = (alt_u16) ((uliReg
				& COMM_RMAP_SEL_HIRES_PRT0_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_28_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiSelHiresPrt1 = (alt_u16) ((uliReg
				& COMM_RMAP_SEL_HIRES_PRT1_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiSelHiresPrt2 = (alt_u16) ((uliReg
				& COMM_RMAP_SEL_HIRES_PRT2_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_29_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiSelHiresPrt3 = (alt_u16) ((uliReg
				& COMM_RMAP_SEL_HIRES_PRT3_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiSelHiresPrt4 = (alt_u16) ((uliReg
				& COMM_RMAP_SEL_HIRES_PRT4_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_30_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiSelHiresPrt5 = (alt_u16) ((uliReg
				& COMM_RMAP_SEL_HIRES_PRT5_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiSelHiresPrt6 = (alt_u16) ((uliReg
				& COMM_RMAP_SEL_HIRES_PRT6_MSK) >> 16);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_HK_31_REG_OFST);
		pxRmapCh->xRmapMemHKArea.usiSelHiresPrt7 = (alt_u16) ((uliReg
				& COMM_RMAP_SEL_HIRES_PRT7_MSK) >> 0);
		pxRmapCh->xRmapMemHKArea.usiZeroHiresAmp = (alt_u16) ((uliReg
				& COMM_RMAP_ZERO_HIRES_AMP_MSK) >> 16);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;

	if (pxRmapCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh7:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh8:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
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
static void vRmapWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

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
