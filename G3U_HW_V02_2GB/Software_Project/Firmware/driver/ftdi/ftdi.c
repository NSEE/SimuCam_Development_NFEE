/*
 * ftdi.c
 *
 *  Created on: 5 de set de 2019
 *      Author: rfranca
 */

#include "ftdi.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viRxBuffHoldContext;
static volatile int viTxBuffHoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

void vFtdiRxIrqHandler(void* pvContext) {
	INT8U error_codel;
	tQMask uiCmdtoSend;
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* viRxBuffHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*viRxBuffHoldContext = ...;
	// if (*viRxBuffHoldContext == '0') {}...
	// App logic sequence...

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

//#if DEBUG_ON
//if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
//	fprintf(fp,"--FTDI Irq--\n");
//}
//#endif

	/* Rx Half-CCD Received Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxHccdReceivedIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdReceivedIrqFlagClr = TRUE;

		/* Rx Buffer Last Empty flag treatment */
		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
		uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_EMPTY;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = 0;

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendBufferEmptyIRQtoDTC();
		}
		/*
		 #if DEBUG_ON
		 if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
		 fprintf(fp,"FTDI Irq Empty 0\n");
		 }
		 #endif
		 */

	}

	/* Rx Half-CCD Communication Error Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxHccdCommErrIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdCommErrIrqFlagClr = TRUE;

		/* Rx Communication Error flag treatment */
		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
		uiCmdtoSend.ucByte[2] = M_DATA_FTDI_ERROR;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = ucFtdiGetRxErrorCode();

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailFtdiErrorIRQtoDTC();
		}

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMajorMessage) {
			fprintf(fp, "FTDI Rx Irq Err \n");
//			fprintf(fp, "FTDI Rx Irq Err : Payload CRC %d\n", vpxFtdiModule->xFtdiRxCommError.bHalfCcdReplyPayCrcErr);
//			fprintf(fp, "FTDI Rx Irq Err : Payload EOP %d\n", vpxFtdiModule->xFtdiRxCommError.bHalfCcdReplyPayEopErr);
//			fprintf(fp, "FTDI Rx Irq Err Header : Received %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.bHalfCcdReceived);
//			fprintf(fp, "FTDI Rx Irq Err Header : FEE Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdFeeNumber);
//			fprintf(fp, "FTDI Rx Irq Err Header : CCD Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdCcdNumber);
//			fprintf(fp, "FTDI Rx Irq Err Header : CCD Side %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdCcdSide);
//			fprintf(fp, "FTDI Rx Irq Err Header : CCD Height %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdCcdHeight);
//			fprintf(fp, "FTDI Rx Irq Err Header : CCD Width %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdCcdWidth);
//			fprintf(fp, "FTDI Rx Irq Err Header : Exposure Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdExpNumber);
//			fprintf(fp, "FTDI Rx Irq Err Header : Image Length Bytes %lu\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.uliHalfCcdImgLengthBytes);
		}
#endif

	}

}

void vFtdiTxIrqHandler(void* pvContext) {
	INT8U error_codel;
	tQMask uiCmdtoSend;
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* viTxBuffHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*viTxBuffHoldContext = ...;
	// if (*viTxBuffHoldContext == '0') {}...
	// App logic sequence...

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	/* Tx Finished Transmission Flag */
	if (vpxFtdiModule->xFtdiTxIrqFlag.bTxLutFinishedIrqFlag) {
		vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutFinishedIrqFlagClr = TRUE;
		/* Tx Finished Transmission flag treatment */
		uiCmdtoSend.ucByte[3] = M_LUT_H_ADDR;
		uiCmdtoSend.ucByte[2] = M_LUT_FTDI_BUFFER_FINISH;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = 0;

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xLutQ, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendBufferLastIRQtoLUT();
		}
	}

	/* Tx Communication Error Flag */
	if (vpxFtdiModule->xFtdiTxIrqFlag.bTxLutCommErrIrqFlag) {
		vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutCommErrIrqFlagClr = TRUE;
		/* Tx Communication Error flag treatment */
		uiCmdtoSend.ucByte[3] = M_LUT_H_ADDR;
		uiCmdtoSend.ucByte[2] = M_LUT_FTDI_ERROR;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = ucFtdiGetRxErrorCode();

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xLutQ, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailFtdiErrorIRQtoLUT();
		}

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMajorMessage) {
			fprintf(fp, "FTDI Tx Irq Err \n");
//			fprintf(fp, "FTDI Tx Irq Err : Payload NACK %d\n", vpxFtdiModule->xFtdiTxCommError.bLutPayloadNackErr);
		}
#endif

	}

}

bool bFtdiRxIrqInit(void) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	// Recast the hold_context pointer to match the alt_irq_register() function
	// prototype.
	pvHoldContext = (void*) &viRxBuffHoldContext;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	// Clear all flags
	vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdReceivedIrqFlagClr = TRUE;
	vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdCommErrIrqFlagClr = TRUE;
	// Register the interrupt handler
	if (0 == alt_irq_register(FTDI_RX_BUFFER_IRQ, pvHoldContext, vFtdiRxIrqHandler)) {
		bStatus = TRUE;
	}
	return bStatus;
}

bool bFtdiTxIrqInit(void) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	// Recast the hold_context pointer to match the alt_irq_register() function
	// prototype.
	pvHoldContext = (void*) &viTxBuffHoldContext;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	// Clear all flags
	vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutFinishedIrqFlagClr = TRUE;
	vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutCommErrIrqFlagClr = TRUE;
	// Register the interrupt handler
	if (0 == alt_irq_register(FTDI_TX_BUFFER_IRQ, pvHoldContext, vFtdiTxIrqHandler)) {
		bStatus = TRUE;
	}
	return bStatus;
}

bool bFtdiRequestHalfCcdImg(alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight, alt_u32 uliPayloadLengthInBytes) {
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	bool bPayloadLengthFlag = FALSE;

	if ((FTDI_TRANSFER_MIN_BYTES <= uliPayloadLengthInBytes) && (FTDI_TRANSFER_MAX_BYTES >= uliPayloadLengthInBytes)) {
		bPayloadLengthFlag = TRUE;
		/* Rounding up the size to the nearest multiple of FTDI_DATA_ACCESS_WIDTH_BYTES (FTDI_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
		if (uliPayloadLengthInBytes % FTDI_DATA_ACCESS_WIDTH_BYTES) {
			/* Transfer size is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
			vpxFtdiModule->xFtdiPayloadConfig.uliRxPayRdForceLenBytes = (alt_u32) ((uliPayloadLengthInBytes & FTDI_DATA_TRANSFER_SIZE_MASK ) + FTDI_DATA_ACCESS_WIDTH_BYTES );
		} else {
			vpxFtdiModule->xFtdiPayloadConfig.uliRxPayRdForceLenBytes = uliPayloadLengthInBytes;
		}
	}

	if ((ucFee < 6) && (ucCCD < 4) && (ucSide < 2) && (usiHalfWidth <= FTDI_MAX_HCCD_IMG_WIDTH) && (usiHeight <= FTDI_MAX_HCCD_IMG_HEIGHT) && (bPayloadLengthFlag)) {
		vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdFeeNumber = ucFee;
		vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdNumber = ucCCD;
		vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdSide = ucSide;
		vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdExpNumber = usiEP;
		vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdWidth = usiHalfWidth;
		vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdHeight = usiHeight;
		vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout = FTDI_HALFCCD_REQ_TIMEOUT;
//        if (0 == usiEP) {
//        	vpxFtdiModule->xFtdiPayloadDelay.usiRxPayRdQqwordDly = 0;
//        } else {
//        	vpxFtdiModule->xFtdiPayloadDelay.usiRxPayRdQqwordDly = 27;
//        }
        vpxFtdiModule->xFtdiPayloadConfig.usiRxPayRdQqwordDly = 0;
		vpxFtdiModule->xFtdiHalfCcdReqControl.bRequestHalfCcd = TRUE;
		bStatus = TRUE;
	}
	return bStatus;
}

bool bFtdiTransmitLutWinArea(alt_u8 ucFee, alt_u16 usiHalfWidth, alt_u16 usiHeight, alt_u32 uliLutLengthBytes) {
	bool bStatus = FALSE;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	if ((ucFee < 6) && (usiHalfWidth <= FTDI_MAX_HCCD_IMG_WIDTH) && (usiHeight <= FTDI_MAX_HCCD_IMG_HEIGHT) && (uliLutLengthBytes <= FTDI_WIN_AREA_PAYLOAD_SIZE)) {
		vpxFtdiModule->xFtdiLutTransControl.ucLutFeeNumber = ucFee;
		vpxFtdiModule->xFtdiLutTransControl.ucLutCcdNumber = 0;
		vpxFtdiModule->xFtdiLutTransControl.ucLutCcdSide = 0;
		vpxFtdiModule->xFtdiLutTransControl.usiLutExpNumber = 0;
		vpxFtdiModule->xFtdiLutTransControl.usiLutCcdWidth = usiHalfWidth;
		vpxFtdiModule->xFtdiLutTransControl.usiLutCcdHeight = usiHeight;
		vpxFtdiModule->xFtdiLutTransControl.usiLutTransTimeout = FTDI_LUT_TRANS_TIMEOUT;
		vpxFtdiModule->xFtdiLutTransControl.uliLutLengthBytes = FTDI_WIN_AREA_WINDOING_SIZE + uliLutLengthBytes;
		vpxFtdiModule->xFtdiPayloadConfig.usiTxPayWrQqwordDly = 0;
		vpxFtdiModule->xFtdiLutTransControl.bTransmitLut = TRUE;
		bStatus = TRUE;
	}
	return bStatus;
}

void vFtdiResetHalfCcdImg(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiHalfCcdReqControl.bRstHalfCcdController = TRUE;
}

void vFtdiResetLutWinArea(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiLutTransControl.bRstLutController = TRUE;
}

alt_u8 ucFtdiGetRxErrorCode(void) {
	alt_u8 ucErrorCode = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	ucErrorCode = (alt_u8) (vpxFtdiModule->xFtdiRxCommError.usiRxCommErrCode);
	return ucErrorCode;
}

alt_u8 ucFtdiGetTxErrorCode(void) {
	alt_u8 ucErrorCode = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	ucErrorCode = (alt_u8) (vpxFtdiModule->xFtdiTxCommError.usiTxLutCommErrCode);
	return ucErrorCode;
}

alt_u16 usiFtdiRxBufferUsedBytes(void) {
	alt_u32 usiBufferUsedBytes = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	usiBufferUsedBytes = vpxFtdiModule->xFtdiRxBufferStatus.usiRxBuffUsedBytes;
	return usiBufferUsedBytes;
}

alt_u16 usiFtdiTxBufferUsedBytes(void) {
	alt_u32 usiBufferUsedBytes = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	usiBufferUsedBytes = vpxFtdiModule->xFtdiTxBufferStatus.usiTxBuffUsedBytes;
	return usiBufferUsedBytes;
}

void vFtdiResetModule(alt_u32 uliWaitTimeUs) {
	IOWR_ALTERA_AVALON_PIO_DATA(PIO_FTDI_UMFT601A_MODULE_RESET_BASE, 0x00000001);
	usleep(uliWaitTimeUs);
	IOWR_ALTERA_AVALON_PIO_DATA(PIO_FTDI_UMFT601A_MODULE_RESET_BASE, 0x00000000);
}

void vFtdiStopModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleStop = TRUE;
}

void vFtdiStartModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleStart = TRUE;
}

void vFtdiClearModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleClear = TRUE;
}

void vFtdiAbortOperation(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiHalfCcdReqControl.bAbortHalfCcdReq = TRUE;
	vpxFtdiModule->xFtdiLutTransControl.bAbortLutTrans = TRUE;
}

void vFtdiIrqGlobalEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiIrqControl.bFtdiGlobalIrqEn = bEnable;
}

void vFtdiIrqRxHccdReceivedEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiRxIrqControl.bRxHccdReceivedIrqEn = bEnable;
}

void vFtdiIrqRxHccdCommErrEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiRxIrqControl.bRxHccdCommErrIrqEn = bEnable;
}

void vFtdiIrqTxLutFinishedEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiTxIrqControl.bTxLutFinishedIrqEn = bEnable;
}

void vFtdiIrqTxLutCommErrEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiTxIrqControl.bTxLutCommErrIrqEn = bEnable;
}

//! [public functions]

//! [private functions]
//! [private functions]
