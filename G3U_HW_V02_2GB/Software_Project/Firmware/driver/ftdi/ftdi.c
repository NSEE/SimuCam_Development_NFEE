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
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vFTDIStop( void ){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiFtdiModuleControl.bModuleStop = TRUE;
}
void vFTDIStart( void ){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiFtdiModuleControl.bModuleStart = TRUE;
}
void vFTDIClear( void ){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiFtdiModuleControl.bModuleClear = TRUE;
}
void vFTDIAbort( void ){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiHalfCcdReqControl.bAbortHalfCcdReq = TRUE;
}
alt_u8 ucFTDIGetError( void ){
    alt_u8 ucErrorCode = 0;
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    ucErrorCode = (alt_u8)(vpxFtdiModule->xFtdiRxCommError.usiRxCommErrCode);
    return ucErrorCode;
}
alt_u32 uliFTDInDataLeftInBuffer( void ){
    alt_u32 uliBufferUsedBytes = 0;
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    uliBufferUsedBytes = vpxFtdiModule->xFtdiRxBufferStatus.usiRxDbuffUsedBytes;
    return uliBufferUsedBytes;
}
bool bFTDIRequestFullImage( alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight,  alt_u16 usiTimeoutMs ){
    bool bStatus = FALSE;
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    if ((6 > ucFee) && (4 > ucCCD) && (2 > ucSide) && (xDefaults.usiCols >= usiHalfWidth) && ((xDefaults.usiRows + xDefaults.usiOLN) >= usiHeight) && (32500 >= usiTimeoutMs)) {
        vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdFeeNumber = ucFee;
        vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdNumber = ucCCD;
        vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdSide = ucSide;
        vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdExpNumber = usiEP;
        vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdWidth = usiHalfWidth;
        vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdHeight = usiHeight;
        vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout = usiTimeoutMs * 2; /* usiHalfCcdReqTimeout is in units of 0.5 ms */
        vpxFtdiModule->xFtdiHalfCcdReqControl.bRequestHalfCcd = TRUE;
        bStatus = TRUE;
    } else {
    	if (6 <= ucFee) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 Full-Image Request: CRITICAL! FEE %d does not exist.\n", ucFee);
			}
			#endif
    	}
    	if (4 <= ucCCD) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 Full-Image Request: CRITICAL! CCD %d does not exist.\n", ucCCD);
			}
			#endif
    	}
    	if (2 <= ucSide) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 Full-Image Request: CRITICAL! Side %d does not exist.\n", ucSide);
			}
			#endif
    	}
    	if (xDefaults.usiCols < usiHalfWidth) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 Full-Image Request: CRITICAL! CCD Half-Width of %d is larger than the maximum allowed of %d pixels.\n", usiHalfWidth, xDefaults.usiRows);
			}
			#endif
    	}
    	if ((xDefaults.usiRows + xDefaults.usiOLN) < usiHeight) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 Full-Image Request: CRITICAL! CCD Height of %d is larger than the maximum allowed of %d pixels.\n", usiHeight, (xDefaults.usiRows + xDefaults.usiOLN));
			}
			#endif
    	}
    	if (32500 < usiTimeoutMs) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 Full-Image Request: CRITICAL! Timeout of %d ms is larger than the maximum allowed of %d ms.\n", usiTimeoutMs, 32500);
			}
			#endif
    	}
    }
    return bStatus;
}
void vFTDIResetFullImage( void ){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiHalfCcdReqControl.bRstHalfCcdController = TRUE;
}

void vFTDIRxBufferIRQHandler(void* pvContext) {
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
/*
#if DEBUG_ON
if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
	fprintf(fp,"FTDI Irq 0\n");
}
#endif
*/

	/* Rx Buffer 0 Readable Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxBuff0RdableIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuff0RdableIrqFlagClr = TRUE;

		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
		uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_FULL;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = 0;

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendBufferFullIRQtoDTC();
		}
/*
#if DEBUG_ON
if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
	fprintf(fp,"FTDI Irq Rd 0\n");
}
#endif
*/

	}

	/* Rx Buffer 1 Readable Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxBuff1RdableIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuff1RdableIrqFlagClr = TRUE;

		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
		uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_FULL;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = 0;

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendBufferFullIRQtoDTC();
		}
/*
#if DEBUG_ON
if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
	fprintf(fp,"FTDI Irq Rd 1\n");
}
#endif
*/
	}

	/* Rx Buffer Last Readable Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxBuffLastRdableIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuffLastRdableIrqFlagClr = TRUE;

		/* Rx Buffer Last Readable flag treatment */
		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
		uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_LAST;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = 0;

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendBufferLastIRQtoDTC();
		}

//#if DEBUG_ON
//if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
//	fprintf(fp,"FTDI Irq Last\n");
//}
//#endif


	}

	/* Rx Buffer Last Empty Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxBuffLastEmptyIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuffLastEmptyIrqFlagClr = TRUE;

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
if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
	fprintf(fp,"FTDI Irq Empty 0\n");
}
#endif
*/

	}

	/* Rx Communication Error Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxCommErrIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxCommErrIrqFlagClr = TRUE;

		/* Rx Communication Error flag treatment */
		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
		uiCmdtoSend.ucByte[2] = M_DATA_FTDI_ERROR;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = ucFTDIGetError();

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailFtdiErrorIRQtoDTC();
		}

#if DEBUG_ON
if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
	fprintf(fp,"FTDI Irq Err \n");
	fprintf(fp,"FTDI Irq Err : Payload CRC %d\n", vpxFtdiModule->xFtdiRxCommError.bHalfCcdReplyPayCrcErr);
	fprintf(fp,"FTDI Irq Err : Payload EOP %d\n", vpxFtdiModule->xFtdiRxCommError.bHalfCcdReplyPayEopErr);
}
#endif

	}

}

bool bFTDIIrqRxBuffInit(void) {
    bool bStatus = FALSE;
    void* pvHoldContext;
    // Recast the hold_context pointer to match the alt_irq_register() function
    // prototype.
    pvHoldContext = (void*) &viRxBuffHoldContext;
    // Register the interrupt handler
    if (0 == alt_irq_register(FTDI_RX_BUFFER_IRQ, pvHoldContext, vFTDIRxBufferIRQHandler)){
        bStatus = TRUE;
    }
    return bStatus;
}
void vFTDIIrqGlobalEn(bool bEnable){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiFtdiIrqControl.bFtdiGlobalIrqEn = bEnable;
}
void vFTDIIrqRxBuff0RdableEn(bool bEnable){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiRxIrqControl.bRxBuff0RdableIrqEn = bEnable;
}
void vFTDIIrqRxBuff1RdableEn(bool bEnable){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiRxIrqControl.bRxBuff1RdableIrqEn = bEnable;
}
void vFTDIIrqRxBuffLastRdableEn(bool bEnable){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiRxIrqControl.bRxBuffLastRdableIrqEn = bEnable;
}
void vFTDIIrqRxBuffLastEmptyEn(bool bEnable){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiRxIrqControl.bRxBuffLastEmptyIrqEn = bEnable;
}
void vFTDIIrqRxCommErrEn(bool bEnable){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiRxIrqControl.bRxCommErrIrqEn = bEnable;
}

//! [public functions]

//! [private functions]
//! [private functions]
