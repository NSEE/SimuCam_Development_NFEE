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

	const unsigned char cucFeeNumber = 0;
	const unsigned char cucIrqNumber = 0;
	const unsigned char cucChNumber = 0;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh1WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 0;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[0];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 1 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh2HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh2WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 1;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[1];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[1], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(1);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[1];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(1);
		}
	}

}

void vRmapCh3HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh3WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 2;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[2];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[2], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(2);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[2];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(2);
		}
	}

}

void vRmapCh4HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh4WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 3;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[3];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[3], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(3);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[3];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(3);
		}
	}

}

void vRmapCh5HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh5WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 4;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[4];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[4], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(4);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[4];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(4);
		}
	}

}

void vRmapCh6HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh6WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 5;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[5];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[5], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(5);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[5];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(5);
		}
	}

}

alt_u32 uliRmapCh1WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh2WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh3WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh4WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh5WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh6WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

void vRmapCh1EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh2EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh3EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh4EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh5EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh6EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

bool vRmapInitIrq(alt_u8 ucCommCh) {
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
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_1_RMAP_IRQ, pvHoldContext, vRmapCh1HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_RMAP_IRQ, pvHoldContext, vRmapCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_RMAP_IRQ, pvHoldContext, vRmapCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_RMAP_IRQ, pvHoldContext, vRmapCh4HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_5_RMAP_IRQ, pvHoldContext, vRmapCh5HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_6_RMAP_IRQ, pvHoldContext, vRmapCh6HandleIrq);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

void vRmapSoftRstDebMemArea(void){
	volatile TRmapMemDebArea *vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);

	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bFoff = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bLock1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bLock0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bLockw1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bLockw0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bC1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bC0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bHold = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bReset = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bReshol = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bPd = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY4Mux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY3Mux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY2Mux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY1Mux = 5;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY0Mux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucFbMux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucPfd = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucCpCurrent = 0x0F;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bPrecp = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bCpDir = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bC1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bC0 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bN90Div8 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bN90Div4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bAdlock = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bSxoiref = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bSref = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY4Mode = 0x05;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY3Mode = 0x00;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY2Mode = 0x00;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY1Mode = 0x00;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY0Mode = 0x05;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel4 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel3 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel2 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bC1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bC0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.bRefdec = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.bManaut = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.ucDlyn = 7;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.ucDlym = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.usiN = 0x0001;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.usiM = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.bC1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.bC0 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod = 7;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOperMod = 7;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllRef = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllVcxo = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllLock = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bWdg = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVdigIn = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVio = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVcor = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVlvd = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk3.usiDebTemp = 0;

}

bool bRmapSetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapIrqControl = pxRmapCh->xRmapIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapIrqControl = vpxCommChannel->xRmap.xRmapIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapIrqFlag = vpxCommChannel->xRmap.xRmapIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetEchoingMode(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapEchoingModeConfig = pxRmapCh->xRmapEchoingModeConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetEchoingMode(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapEchoingModeConfig = vpxCommChannel->xRmap.xRmapEchoingModeConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapCodecConfig = pxRmapCh->xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecConfig = vpxCommChannel->xRmap.xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecStatus = vpxCommChannel->xRmap.xRmapCodecStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecError(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecError = vpxCommChannel->xRmap.xRmapCodecError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetMemConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapMemConfig = pxRmapCh->xRmapMemConfig;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemConfig = vpxCommChannel->xRmap.xRmapMemConfig;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemStatus = vpxCommChannel->xRmap.xRmapMemStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetRmapMemCfgArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig = pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;
}

bool bRmapGetRmapMemCfgArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;
}

bool bRmapSetRmapMemHkArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk = pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;

}

bool bRmapGetRmapMemHkArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk;

	 bStatus = TRUE;
	 }
	 */

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
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
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
			if (!bRmapGetMemConfig(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetMemStatus(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetRmapMemCfgArea(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetRmapMemHkArea(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetEchoingMode(pxRmapCh)) {
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
