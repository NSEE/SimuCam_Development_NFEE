/*
 * nfee_control_taskV2.c
 *
 *  Created on: 20 de set de 2019
 *      Author: Tiago-note
 */


/*
 * data_control_task.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */

#include "nfee_control_taskV3.h"

volatile unsigned char ucWhoGetDMA;
volatile bool bDmaBack;
volatile bool bCmdSent;

void vNFeeControlTaskV3(void *task_data) {
	TNFee_Control * pxFeeC;
	tQMask uiCmdNFC;
	INT8U error_codeCtrl;
	unsigned char ucFeeInstL = 0, ucSide = 0;
	unsigned char ucCmd;

	pxFeeC = (TNFee_Control *) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage )
        debug(fp,"FEE Controller Task. (Task on)\n");
    #endif

	for (;;) {

		switch (pxFeeC->sMode) {
			case sMebInit:
				/* Starting the NFEE Controller */

				/* Put initialization only, here*/

				pxFeeC->sMode = sMebToConfig;
				break;

			case sMebToConfig:
				/* Transition state */
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"NFEE Controller Task: Config Mode\n");
				#endif

				/* Clear Queue that is responsible to schedule the DMA access */
				error_codeCtrl = OSQFlush(xNfeeSchedule);
				if ( error_codeCtrl != OS_NO_ERR ) {
					vFailFlushQueue();
				}

				/* Clear in CMD Queue  */
				error_codeCtrl = OSQFlush(xQMaskFeeCtrl);
				if ( error_codeCtrl != OS_NO_ERR ) {
					vFailFlushQueue();
				}

				pxFeeC->sMode = sMebConfig;
				break;

			case sMebConfig:

				uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskFeeCtrl, 0, &error_codeCtrl); /* Blocking operation */
				if ( error_codeCtrl == OS_ERR_NONE ) {
					/* Check if the command is for NFEE Controller */
					if ( uiCmdNFC.ucByte[3] == M_FEE_CTRL_ADDR ) {
						vPerformActionNFCConfig(uiCmdNFC.ulWord, pxFeeC);
					}
				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetQueueMaskNfeeCtrl();
				}
				break;


			case sMebToRun:
				/* Transition state */
				vEvtChangeFeeControllerMode();
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"NFEE Controller Task: RUN Mode\n");
				#endif

				/* Clear Queue that is responsible to schedule the DMA access */
				error_codeCtrl = OSQFlush(xNfeeSchedule);
				if ( error_codeCtrl != OS_NO_ERR ) {
					vFailFlushQueue();
				}

				/* Clear message that maybe is in the FEEs Queues */
				/*
				for( ucIL = 0; ucIL < N_OF_NFEE; ucIL++)
				{
					error_codeCtrl = OSQFlush( xFeeQ[ ucIL ] );
					if ( error_codeCtrl != OS_NO_ERR ) {
						vFailFlushQueue();
					}
				}
				*/

				bCmdSent = FALSE;
				bDmaBack = TRUE;
				ucWhoGetDMA = 255;
				pxFeeC->sMode = sMebRun;
				break;

			case sMebRun:
				/* 	We have 2 important Queues here.
					xQMaskFeeCtrl is How NFEE Controller receive Commands in a fast way and
					xNfeeSchedule that has the schedule of access to the DMA (this has priority)*/

					uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskFeeCtrl, 0, &error_codeCtrl);
					if ( error_codeCtrl == OS_ERR_NONE ) {
						ucCmd = uiCmdNFC.ucByte[2];
						if ( ucCmd == M_NFC_DMA_REQUEST ) {
							ucFeeInstL = uiCmdNFC.ucByte[0];
							ucSide = uiCmdNFC.ucByte[1];
							if (  pxFeeC->xNfee[ucFeeInstL].xControl.bUsingDMA == TRUE )
								bCmdSent = bSendCmdQToNFeeInst( ucFeeInstL, M_FEE_DMA_ACCESS, ucSide, ucFeeInstL);
						} else {
							if ( uiCmdNFC.ucByte[3] == M_FEE_CTRL_ADDR ) {
								vPerformActionNFCRunning(uiCmdNFC.ulWord, pxFeeC);
							} else {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
									fprintf(fp,"NFEE Controller Task: Received a CMD with wrong addr. (xQMaskFeeCtrl)\n");
								}
								#endif
							}
						}
					}

				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					debug(fp,"NFEE Controller Task: Unknown state, backing to Config Mode.\n");
				}
				#endif

				pxFeeC->sMode = sMebToConfig;
		}
	}
}


void vPerformActionNFCConfig( unsigned int uiCmdParam, TNFee_Control *pxFeeCP ) {
	tQMask uiCmdLocal;

	uiCmdLocal.ulWord = uiCmdParam;

	switch (uiCmdLocal.ucByte[2]) {
		case M_NFC_CONFIG_FORCED:
		case M_NFC_CONFIG:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
				debug(fp,"NFEE Controller Task: NFC already in the Config Mode\n");
			}
			#endif
			/* Do nothing for now */
			break;

		case M_NFC_RUN_FORCED:
		case M_NFC_RUN:
			pxFeeCP->sMode = sMebToRun;
			break;
		case M_NFC_CONFIG_RESET:
		case M_NFC_DMA_GIVEBACK:
		case M_NFC_DMA_REQUEST:
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				debug(fp,"NFEE Controller Task: Unknown Command.\n");
			#endif
	}
}

void vPerformActionNFCRunning( unsigned int uiCmdParam, TNFee_Control *pxFeeCP ) {
	tQMask uiCmdLocal;
	unsigned char i;

	uiCmdLocal.ulWord = uiCmdParam;

	switch (uiCmdLocal.ucByte[2]) {

		case M_NFC_CONFIG:
		case M_NFC_CONFIG_FORCED:

			pxFeeCP->sMode = sMebToConfig;

			/* Change all NFEEs to Config mode */
			for( i = 0; i < N_OF_NFEE; i++) {
				if ( (pxFeeCP->xNfee[i].xControl.bSimulating) == TRUE ) {
					bSendCmdQToNFeeInst_Prio( i, M_FEE_CONFIG_FORCED, 0, i  );
				}
			}
			break;

		case M_NFC_CONFIG_RESET:
			pxFeeCP->sMode = sMebToConfig;
			break;

		case M_NFC_RUN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
				debug(fp,"NFEE Controller Task: NFC already in the Running Mode\n");
			}
			#endif
			break;
		case M_NFC_DMA_GIVEBACK:
		case M_NFC_DMA_REQUEST:
			/* Do nothing for now */
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				debug(fp,"NFEE Controller Task: Unknown Command.\n");
			}
			#endif
			break;
	}
}


bool bSendCmdQToNFeeInst( unsigned char ucFeeInstP, unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucFeeInstP;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPost(xFeeQ[ ucFeeInstP ], (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgAccessDMA( ucFeeInstP );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}

	return bSuccesL;
}


bool bSendCmdQToNFeeInst_Prio( unsigned char ucFeeInstP, unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucFeeInstP;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPostFront(xFeeQ[ ucFeeInstP ], (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgAccessDMA( ucFeeInstP );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}

	return bSuccesL;
}
