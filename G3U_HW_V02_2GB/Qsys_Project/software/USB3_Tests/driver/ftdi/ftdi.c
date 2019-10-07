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
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiFtdiModuleControl.bModuleStop = TRUE;
}

void vFTDIStart( void ){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiFtdiModuleControl.bModuleStart = TRUE;
}

void vFTDIClear( void ){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiFtdiModuleControl.bModuleClear = TRUE;
}

void vFTDIAbort( void ){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiHalfCcdReqControl.bAbortHalfCcdReq = TRUE;
}

alt_u8 ucFTDIGetError( void ){
	alt_u8 ucErrorCode = 0;

	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	ucErrorCode = (alt_u8)(pxFtdiModule->xFtdiRxCommError.usiRxCommErrCode);

	return ucErrorCode;
}

alt_u32 uliFTDInDataLeftInBuffer( void ){
	alt_u32 uliBufferUsedBytes = 0;

	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	uliBufferUsedBytes = pxFtdiModule->xFtdiRxBufferStatus.usiRxDbuffUsedBytes;

	return uliBufferUsedBytes;
}

bool bFTDIRequestFullImage( alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight ){
	bool bStatus = FALSE;

	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	if ((ucFee < 6) && (ucCCD < 4) && (ucSide < 2) && (usiHalfWidth <= 4540 ) && (usiHeight <= 2295)) {

		pxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdFeeNumber = ucFee;
		pxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdNumber = ucCCD;
		pxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdSide = ucSide;
		pxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdExpNumber = usiEP;
		pxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdWidth = usiHalfWidth;
		pxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdHeight = usiHeight;
		pxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout = 0;
		pxFtdiModule->xFtdiHalfCcdReqControl.bRequestHalfCcd = TRUE;

		bStatus = TRUE;
	}

	return bStatus;
}

void vFTDIResetFullImage( void ){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiHalfCcdReqControl.bRstHalfCcdController = TRUE;
}

void vFTDIRxBufferIRQHandler(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* viRxBuffHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*viRxBuffHoldContext = ...;
	// if (*viRxBuffHoldContext == '0') {}...
	// App logic sequence...

	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	/* Rx Buffer 0 Readable Flag */
	if (pxFtdiModule->xFtdiRxIrqFlag.bRxBuff0RdableIrqFlag) {
		pxFtdiModule->xFtdiRxIrqFlagClr.bRxBuff0RdableIrqFlagClr = TRUE;

		/* Rx Buffer 0 Readable flag treatment */


	}

	/* Rx Buffer 1 Readable Flag */
	if (pxFtdiModule->xFtdiRxIrqFlag.bRxBuff1RdableIrqFlag) {
		pxFtdiModule->xFtdiRxIrqFlagClr.bRxBuff1RdableIrqFlagClr = TRUE;

		/* Rx Buffer 1 Readable flag treatment */


	}

	/* Rx Buffer Last Readable Flag */
	if (pxFtdiModule->xFtdiRxIrqFlag.bRxBuffLastRdableIrqFlag) {
		pxFtdiModule->xFtdiRxIrqFlagClr.bRxBuffLastRdableIrqFlagClr = TRUE;

		/* Rx Buffer Last Readable flag treatment */


	}

	/* Rx Buffer Last Empty Flag */
	if (pxFtdiModule->xFtdiRxIrqFlag.bRxBuffLastEmptyIrqFlag) {
		pxFtdiModule->xFtdiRxIrqFlagClr.bRxBuffLastEmptyIrqFlagClr = TRUE;

		/* Rx Buffer Last Empty flag treatment */


	}

	/* Rx Communication Error Flag */
	if (pxFtdiModule->xFtdiRxIrqFlag.bRxCommErrIrqFlag) {
		pxFtdiModule->xFtdiRxIrqFlagClr.bRxCommErrIrqFlagClr = TRUE;

		/* Rx Communication Error flag treatment */


	}

}

void vFTDIIrqRxBuffInit(void) {
	void* pvHoldContext;

	// Recast the hold_context pointer to match the alt_irq_register() function
	// prototype.
	pvHoldContext = (void*) &viRxBuffHoldContext;
	// Register the interrupt handler
	alt_irq_register(FTDI_RX_BUFFER_IRQ, pvHoldContext, vFTDIRxBufferIRQHandler);

}

void vFTDIIrqGlobalEn(bool bEnable){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiFtdiIrqControl.bFtdiGlobalIrqEn = bEnable;
}

void vFTDIIrqRxBuff0RdableEn(bool bEnable){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiRxIrqControl.bRxBuff0RdableIrqEn = bEnable;
}

void vFTDIIrqRxBuff1RdableEn(bool bEnable){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiRxIrqControl.bRxBuff1RdableIrqEn = bEnable;
}

void vFTDIIrqRxBuffLastRdableEn(bool bEnable){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiRxIrqControl.bRxBuffLastRdableIrqEn = bEnable;
}

void vFTDIIrqRxBuffLastEmptyEn(bool bEnable){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiRxIrqControl.bRxBuffLastEmptyIrqEn = bEnable;
}

void vFTDIIrqRxCommErrEn(bool bEnable){
	TFtdiModule *pxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	pxFtdiModule->xFtdiRxIrqControl.bRxCommErrIrqEn = bEnable;
}

//! [public functions]

//! [private functions]
//! [private functions]
