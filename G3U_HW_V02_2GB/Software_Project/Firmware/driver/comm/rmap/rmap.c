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

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 1 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
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

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh2HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 1;
	const unsigned char cucIrqNumber = 1;
	const unsigned char cucChNumber = 1;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);

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

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 2 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
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

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh3HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 2;
	const unsigned char cucIrqNumber = 2;
	const unsigned char cucChNumber = 2;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);

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

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 3 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
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

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh4HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 3;
	const unsigned char cucIrqNumber = 3;
	const unsigned char cucChNumber = 3;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);

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

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 4 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
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

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh5HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 4;
	const unsigned char cucIrqNumber = 4;
	const unsigned char cucChNumber = 4;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);

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

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 5 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
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

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

}

void vRmapCh6HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 5;
	const unsigned char cucIrqNumber = 5;
	const unsigned char cucChNumber = 5;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);

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

		ucADDRReg = (unsigned char) vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + cucFeeNumber;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif
#if ( 6 <= N_OF_NFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "RMAP IRQ CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
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

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
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

bool bRmapChEnableCodec(alt_u8 ucCommCh, bool bEnable){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		bValidCh = TRUE;
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {
		vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
		bStatus = TRUE;
	}

	return (bStatus);
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

bool bRmapSoftRstMemAreaConfig(alt_u8 ucCommCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TRmapMemArea *vpxRmapMemArea = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {

		vpxRmapMemArea->xRmapMemAreaConfig.usiVStart = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiVEnd = 4539;
		vpxRmapMemArea->xRmapMemAreaConfig.usiChargeInjectionWidth = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiChargeInjectionGap = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiParallelToiPeriod = 0x0465;
		vpxRmapMemArea->xRmapMemAreaConfig.usiParallelClkOverlap = 0x00FA;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd = 1;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd = 2;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd = 3;
		vpxRmapMemArea->xRmapMemAreaConfig.usiNFinalDump = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiHEnd = 2294;
		vpxRmapMemArea->xRmapMemAreaConfig.bChargeInjectionEn = FALSE;
		vpxRmapMemArea->xRmapMemAreaConfig.bTriLevelClkEn = FALSE;
		vpxRmapMemArea->xRmapMemAreaConfig.bImgClkDir = FALSE;
		vpxRmapMemArea->xRmapMemAreaConfig.bRegClkDir = FALSE;
		vpxRmapMemArea->xRmapMemAreaConfig.usiPacketSize = 32140;
		vpxRmapMemArea->xRmapMemAreaConfig.usiIntSyncPeriod = 6250;
		vpxRmapMemArea->xRmapMemAreaConfig.uliTrapPumpingDwellCounter = 250000;
		vpxRmapMemArea->xRmapMemAreaConfig.bSyncSel = FALSE;
		vpxRmapMemArea->xRmapMemAreaConfig.ucSensorSel = 3;
		vpxRmapMemArea->xRmapMemAreaConfig.bDigitiseEn = TRUE;
		vpxRmapMemArea->xRmapMemAreaConfig.bDGEn = FALSE;
		vpxRmapMemArea->xRmapMemAreaConfig.bCcdReadEn = TRUE;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg5ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.uliCcd1WinListPtr = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.uliCcd1PktorderListPtr = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1WinListLength = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd1WinSizeX = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd1WinSizeY = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg8ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.uliCcd2WinListPtr = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.uliCcd2PktorderListPtr = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2WinListLength = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2WinSizeX = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2WinSizeY = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg11ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.uliCcd3WinListPtr = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.uliCcd3PktorderListPtr = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3WinListLength = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd3WinSizeX = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd3WinSizeY = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg14ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.uliCcd4WinListPtr = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.uliCcd4PktorderListPtr = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4WinListLength = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd4WinSizeX = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd4WinSizeY = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg17ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcdVodConfig = 3276;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1VrdConfig = 3685;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2VrdConfig0 = 101;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2VrdConfig1 = 14;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3VrdConfig = 3685;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4VrdConfig = 3685;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcdVgdConfig0 = 12;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcdVgdConfig1 = 204;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcdVogConfig = 410;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcdIgHiConfig = 3276;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcdIgLoConfig = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiReg21ConfigReserved0 = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucCcdModeConfig = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg21ConfigReserved1 = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.bClearErrorFlag = FALSE;
		vpxRmapMemArea->xRmapMemAreaConfig.uliReg22ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1LastEPacket = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1LastFPacket = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2LastEPacket = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg23ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2LastFPacket = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3LastEPacket = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3LastFPacket = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg24ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4LastEPacket = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4LastFPacket = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiSurfaceInversionCounter = 100;
		vpxRmapMemArea->xRmapMemAreaConfig.ucReg25ConfigReserved = 0;
		vpxRmapMemArea->xRmapMemAreaConfig.usiReadoutPauseCounter = 2000;
		vpxRmapMemArea->xRmapMemAreaConfig.usiTrapPumpingShuffleCounter = 1000;

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bRmapSoftRstMemAreaHk(alt_u8 ucCommCh){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TRmapMemArea *vpxRmapMemArea = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxRmapMemArea = (TRmapMemArea *) (COMM_RMAP_MEM_6_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {

		vpxRmapMemArea->xRmapMemAreaHk.usiTouSense1 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiTouSense2 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiTouSense3 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiTouSense4 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiTouSense5 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiTouSense6 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd1Ts = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd2Ts = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd3Ts = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd4Ts = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiPrt1 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiPrt2 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiPrt3 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiPrt4 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiPrt5 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiZeroDiffAmp = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VodMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VogMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VrdMonE = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VodMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VogMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VrdMonE = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VodMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VogMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VrdMonE = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VodMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VogMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VrdMonE = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVccd = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVrclkMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiViclk = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVrclkLow = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usi5vbPosMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usi5vbNegMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usi3v3bMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usi2v5aMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usi3v3dMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usi2v5dMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usi1v5dMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usi5vrefMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVccdPosRaw = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVclkPosRaw = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVan1PosRaw = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVan3NegMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVan2PosRaw = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVdigRaw = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiVdigRaw2 = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiViclkLow = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VrdMonF = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VddMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VgdMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VrdMonF = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VddMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VgdMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VrdMonF = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VddMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VgdMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VrdMonF = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VddMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VgdMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiIgHiMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiIgLoMon = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiTsenseA = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.usiTsenseB = 0xFFFF;
		vpxRmapMemArea->xRmapMemAreaHk.ucSpwStatusSpwStatusReserved = 0;
		vpxRmapMemArea->xRmapMemAreaHk.ucReg32HkReserved = 0;
		vpxRmapMemArea->xRmapMemAreaHk.usiReg33HkReserved = 0;
		vpxRmapMemArea->xRmapMemAreaHk.ucOpMode = 0;
		vpxRmapMemArea->xRmapMemAreaHk.uliErrorFlagsErrorFlagsReserved = 0;
		vpxRmapMemArea->xRmapMemAreaHk.ucFpgaMinorVersion = 0;
		vpxRmapMemArea->xRmapMemAreaHk.ucFpgaMajorVersion = 0;
		vpxRmapMemArea->xRmapMemAreaHk.usiBoardId = 0;
		vpxRmapMemArea->xRmapMemAreaHk.uliReg35HkReserved = 0;

		bStatus = TRUE;
	}

	return (bStatus);
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
