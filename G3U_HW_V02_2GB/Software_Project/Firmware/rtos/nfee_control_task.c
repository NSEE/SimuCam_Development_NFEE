/*
 * data_control_task.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */



#include "nfee_control_task.h"


void vNFeeControlTask(void *task_data) {
	TNFee_Control * pxFeeC;
	tQMask uiCmdNFC;
	bool bCmdSent;
	INT8U error_codeCtrl;
	unsigned char ucFeeInstL;
	static bool bDmaBack;
	static unsigned char ucWhoGetDMA;
	unsigned char ucIL;

	pxFeeC = (TNFee_Control *) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
        debug(fp,"NFee Controller Task. (Task on)\n");
	}
    #endif

	for (;;) {

		switch (pxFeeC->sMode)
		{
			case sMebInit:
				/* Starting the NFEE Controller */

				/* Clear in CMD Queue  */
				error_codeCtrl = OSQFlush(xQMaskFeeCtrl);
				if ( error_codeCtrl != OS_NO_ERR ) {
					vFailFlushQueue();
				}

				pxFeeC->sMode = sMebToConfig;
				break;


			case sMebToConfig:
				/* Transition state */
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					debug(fp,"NFEE Controller Task: Config Mode\n");
				}
				#endif

				/* Clear Queue that is responsible to schedule the DMA access */
				error_codeCtrl = OSQFlush(xNfeeSchedule);
				if ( error_codeCtrl != OS_NO_ERR ) {
					vFailFlushQueue();
				}

				bCmdSent = FALSE;
				bDmaBack = TRUE;
				ucWhoGetDMA = 255;
				pxFeeC->sMode = sMebConfig;
				break;


			case sMebToRun:
				/* Transition state */
				vEvtChangeFeeControllerMode();
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					debug(fp,"NFEE Controller Task: RUN Mode\n");
				}
				#endif

				/* Clear Queue that is responsible to schedule the DMA access */
				error_codeCtrl = OSQFlush(xNfeeSchedule);
				if ( error_codeCtrl != OS_NO_ERR ) {
					vFailFlushQueue();
				}

				/* Clear message that maybe is in the FEEs Queues */
				for( ucIL = 0; ucIL < N_OF_NFEE; ucIL++)
				{
					error_codeCtrl = OSQFlush( xFeeQ[ ucIL ] );
					if ( error_codeCtrl != OS_NO_ERR ) {
						vFailFlushQueue();
					}
				}

				bCmdSent = FALSE;
				bDmaBack = TRUE;
				ucWhoGetDMA = 255;
				pxFeeC->sMode = sMebRun;
				break;


			case sMebConfig:
				
				uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskFeeCtrl, 0, &error_codeCtrl); /* Blocking operation */
				if ( error_codeCtrl == OS_ERR_NONE ) {

					/* Check if the command is for NFEE Controller */
					if ( uiCmdNFC.ucByte[3] == M_FEE_CTRL_ADDR ) {
						vPerformActionNFCConfig(uiCmdNFC.ulWord, pxFeeC);
					}
					bCmdSent = FALSE;
					bDmaBack = TRUE;
				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetQueueMaskNfeeCtrl();
				}
				break;


			case sMebRun:
				/* 	We have 2 importantes Queues here.  
					xQMaskFeeCtrl is How NFEE Controller receive Commands in a fast way and
					xNfeeSchedule that has the schedule of access to the DMA (this has priority)*/
				
				/* Get the id of the FEE that wants DMA access */
				if ( bDmaBack == TRUE ) {

					uiCmdNFC.ulWord = (unsigned int)OSQPend(xNfeeSchedule, 4, &error_codeCtrl);
					if ( error_codeCtrl == OS_ERR_NONE ) {
						ucFeeInstL = uiCmdNFC.ucByte[0];

						if (  pxFeeC->xNfee[ucFeeInstL].xControl.bUsingDMA == TRUE ) {
							bCmdSent = bSendCmdQToNFeeInst( ucFeeInstL, M_FEE_DMA_ACCESS, 0, ucFeeInstL );
							if ( bCmdSent == TRUE ) {
								bDmaBack = FALSE;
								ucWhoGetDMA = ucFeeInstL;
							}
						}
					}
				} 

				if ( bDmaBack == FALSE ) {
					/* DMA with some NFEE instance */
					uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskFeeCtrl, 0, &error_codeCtrl);
				} else {
					/* If No FEE has the DMA */
					uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskFeeCtrl, 4, &error_codeCtrl);
				}

				if ( error_codeCtrl == OS_ERR_NONE ){
					/* Check if is some FEE giving the DMA back */
					if ( uiCmdNFC.ucByte[2] == M_NFC_DMA_GIVEBACK ) {
						if ( uiCmdNFC.ucByte[0] == ucWhoGetDMA ){
							bDmaBack = TRUE;
							ucFeeInstL = 255;
						}

					} else {

						/* Check if the command is for NFEE Controller */
						if ( uiCmdNFC.ucByte[3] == M_FEE_CTRL_ADDR ) {
							
							vPerformActionNFCRunning(uiCmdNFC.ulWord, pxFeeC);

						} else {
							/* Check if the message if for any one of the instances of NFEE */
							if ( (uiCmdNFC.ucByte[3] >= M_NFEE_BASE_ADDR) && ( uiCmdNFC.ucByte[3] <= (M_NFEE_BASE_ADDR+N_OF_NFEE) ) ) {
								//todo: tratar retorno
								bSendCmdQToNFeeInst( (uiCmdNFC.ucByte[3]-M_NFEE_BASE_ADDR), uiCmdNFC.ucByte[2], uiCmdNFC.ucByte[1], uiCmdNFC.ucByte[0] );
							}
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
				
				pxFeeC->sMode = sMebConfig;
				break;
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
		case M_NFC_DMA_GIVEBACK:
		case M_NFC_DMA_REQUEST:
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

void vPerformActionNFCRunning( unsigned int uiCmdParam, TNFee_Control *pxFeeCP ) {
	tQMask uiCmdLocal;
	unsigned char i;

	uiCmdLocal.ulWord = uiCmdParam;

	switch (uiCmdLocal.ucByte[2]) {
		case M_NFC_CONFIG:
		case M_NFC_CONFIG_FORCED:

			pxFeeCP->sMode = sMebToConfig;

			/* Change all NFEEs to Config mode */
			for( i = 0; i < N_OF_NFEE; i++)
			{
				if ( (*pxFeeCP->pbEnabledNFEEs[i]) == TRUE ) {
					bSendCmdQToNFeeInst_Prio( i, M_FEE_CONFIG_FORCED, 0, i  );
				}
			}

			break;
		case M_NFC_RUN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
				debug(fp,"NFEE Controller Task: NFC already in the Running Mode\n");
			}
			#endif		
			/* Do nothing for now */

			break;
		case M_NFC_DMA_GIVEBACK:
		case M_NFC_DMA_REQUEST:
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
