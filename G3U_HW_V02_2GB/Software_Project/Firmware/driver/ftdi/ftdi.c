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
bool bFTDIRequestFullImage( alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight ){
    bool bStatus = FALSE;
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    if ((ucFee < 6) && (ucCCD < 4) && (ucSide < 2) && (usiHalfWidth <= 2295 ) && (usiHeight <= 4540)) {
        vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdFeeNumber = ucFee;
        vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdNumber = ucCCD;
        vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdSide = ucSide;
        vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdExpNumber = usiEP;
        vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdWidth = usiHalfWidth;
        vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdHeight = usiHeight;
        if (0 == usiEP) {
        	vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout = 0;
        } else {
        	vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout = 27;
        }
        vpxFtdiModule->xFtdiHalfCcdReqControl.bRequestHalfCcd = TRUE;
        bStatus = TRUE;
    }
    return bStatus;
}

bool bFTDITransmitWindowArea(alt_u8 ucFee, alt_u16 usiHalfWidth, alt_u16 usiHeight){
	bool bStatus = FALSE;
	bStatus = TRUE;
	return bStatus;
}

void vFTDIResetFullImage( void ){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiHalfCcdReqControl.bRstHalfCcdController = TRUE;
}

void vFTDIResetWindowArea(void){
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiHalfCcdReqControl.bRstHalfCcdController = FALSE; /* Dummy */
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

//#if DEBUG_ON
//if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
//	fprintf(fp,"--FTDI Irq--\n");
//}
//#endif


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
	fprintf(fp,"FTDI Irq Err Header : Received %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.bHalfCcdReceived);
	fprintf(fp,"FTDI Irq Err Header : FEE Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdFeeNumber);
	fprintf(fp,"FTDI Irq Err Header : CCD Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdCcdNumber);
	fprintf(fp,"FTDI Irq Err Header : CCD Side %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdCcdSide);
	fprintf(fp,"FTDI Irq Err Header : CCD Height %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdCcdHeight);
	fprintf(fp,"FTDI Irq Err Header : CCD Width %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdCcdWidth);
	fprintf(fp,"FTDI Irq Err Header : Exposure Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdExpNumber);
	fprintf(fp,"FTDI Irq Err Header : Image Length Bytes %lu\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.uliHalfCcdImgLengthBytes);

}
#endif

	}

}

void vFTDITxBufferIRQHandler(void* pvContext) {
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

	}

	/* Tx Communication Error Flag */
	if (vpxFtdiModule->xFtdiTxIrqFlag.bTxLutCommErrIrqFlag) {
		vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutCommErrIrqFlagClr = TRUE;
		/* Tx Communication Error flag treatment */

	}

}

bool bFTDIIrqRxBuffInit(void) {
    bool bStatus = FALSE;
    void* pvHoldContext;
    // Recast the hold_context pointer to match the alt_irq_register() function
    // prototype.
    pvHoldContext = (void*) &viRxBuffHoldContext;
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	// Clear all flags
    vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuff0RdableIrqFlagClr = TRUE;
    vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuff1RdableIrqFlagClr = TRUE;
    vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuffLastRdableIrqFlagClr = TRUE;
    vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuffLastEmptyIrqFlagClr = TRUE;
    vpxFtdiModule->xFtdiRxIrqFlagClr.bRxCommErrIrqFlagClr = TRUE;
    // Register the interrupt handler
    if (0 == alt_irq_register(FTDI_RX_BUFFER_IRQ, pvHoldContext, vFTDIRxBufferIRQHandler)){
        bStatus = TRUE;
    }
    return bStatus;
}

bool bFTDIIrqTxBuffInit(void) {
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
    if (0 == alt_irq_register(FTDI_TX_BUFFER_IRQ, pvHoldContext, vFTDITxBufferIRQHandler)){
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

void vFTDIIrqTxFinishedEn(bool bEnable){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiTxIrqControl.bTxLutFinishedIrqEn = bEnable;
}

void vFTDIIrqTxCommErrEn(bool bEnable){
    volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
    vpxFtdiModule->xFtdiTxIrqControl.bTxLutCommErrIrqEn = bEnable;
}

//! [public functions]

//! [private functions]
//! [private functions]
