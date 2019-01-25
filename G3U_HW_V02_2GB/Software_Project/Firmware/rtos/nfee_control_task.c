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
	INT8U error_code;
	INT8U error_codeCtrl;
	unsigned char ucFeeInstL;
	static bool bDmaBack;

	pxFeeC = (TNFee_Control *) task_data;

	#ifdef DEBUG_ON
        debug(fp,"NFee Controller Task. (Task on)\n");
    #endif

	bCmdSent = FALSE;
	bDmaBack = TRUE;
	for (;;) {

		/* todo: Tem os mesmos estados que o SIMUCAM : Config e Running */
		/* todo: No config ou a Meb ira configurar sozinha os FEEs e os controladores ou ir� passar a mensagem completa sem usar a QueueMask */
		/* todo: No modo Running o NFEE control s� utiliza o Queue MAsk pois � mais rapido e s� transmite no Qmask tbm */

		
		switch (pxFeeC->sMode)
		{
			case sMebConfig:
				
				uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskFeeCtrl, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Check if the command is for NFEE Controller */
					if ( uiCmdNFC.ucByte[3] == M_FEE_CTRL_ADDR ) {
						
						vPerformActionNFCConfig(uiCmdNFC.ulWord, pxFeeC);

					} else {
						#ifdef DEBUG_ON
							fprintf(fp,"Provavel para FEE (Remover)\n");
						#endif
					}

					bDmaBack = TRUE;
				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetQueueMaskNfeeCtrl();
				}
				break;
			case sRun:
				/* 	We have 2 importantes Queues here.  
					xQMaskFeeCtrl is How NFEE Controller receive Commands in a fat way and 
					xNfeeSchedule that has the schedule of access to the DMA (this has priority)*/
				

				/* Get the id of the FEE that wants DMA access */
				if ( bDmaBack == TRUE ) {
					uiCmdNFC.ulWord = (unsigned int)OSQPend(xNfeeSchedule, 2, &error_code);
					if ( error_code == OS_ERR_NONE ) {
						ucFeeInstL = uiCmdNFC.ucByte[0];
						if (  pxFeeC->xNfee[ucFeeInstL].xControl.bUsingDMA == TRUE ) {
							bCmdSent = bSendCmdQToNFeeInst( ucFeeInstL, M_FEE_DMA_ACCESS, 0, ucFeeInstL );
							if ( bCmdSent == TRUE )
								bDmaBack = FALSE;
						}
					}
				} 

				if ( bDmaBack == FALSE )
					/* DMA with some NFEE instance */
					uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskFeeCtrl, 0, &error_codeCtrl);
				else
					/* If No FEE has the DMA */
					uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskFeeCtrl, 2, &error_codeCtrl);

				if ( error_codeCtrl == OS_ERR_NONE ){
					/* Check if is some FEE giving the DMA back */
					if ( uiCmdNFC.ucByte[2] == M_NFC_DMA_GIVEBACK ) {
						bDmaBack = TRUE;
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
						bDmaBack = FALSE;
					}
				}
				
				break;		
			default:
				#ifdef DEBUG_ON
					debug(fp,"NFEE Controller Task: Unknow state, backing to Config Mode.\n");
				#endif
				
				/* todo:Aplicar toda logica de mudança de esteado aqui */
				pxFeeC->sMode = sMebConfig;
				break;
		}
	}
}


void vPerformActionNFCConfig( unsigned int uiCmdParam, TNFee_Control *pxFeeCP ) {
	tQMask uiCmdLocal;
	INT8U errorCodeL;
	unsigned char i;

	uiCmdLocal.ulWord = uiCmdParam;

	switch (uiCmdLocal.ucByte[2]) {
		case M_NFC_CONFIG:
			#ifdef DEBUG_ON
				debug(fp,"NFEE Controller Task: NFC already in the Config Mode\n");
			#endif

			/* Do nothing for now */

			break;
		case M_NFC_RUN:
			#ifdef DEBUG_ON
				debug(fp,"NFEE Controller Task: Changing to RUN Mode\n");
			#endif

			vEvtChangeFeeControllerMode(pxFeeCP->sMode, sRun);
			pxFeeCP->sMode = sRun;
			/* ALlow NFEEs to go to any Running mode */

			/* Clear The Queue That gives access to the DMA */
			errorCodeL = OSQFlush(xNfeeSchedule);
			if ( errorCodeL != OS_NO_ERR ) {
				vFailFlushQueue();
			}

			for( i = 0; i < N_OF_NFEE; i++)
			{
				errorCodeL = OSQFlush( xFeeQ[ i ] );
				if ( errorCodeL != OS_NO_ERR ) {
					vFailFlushQueue();
				}
			}


			break;		
		default:
			#ifdef DEBUG_ON
				debug(fp,"NFEE Controller Task: Unknow Command.\n");
			#endif	
			break;
	}

}

void vPerformActionNFCRunning( unsigned int uiCmdParam, TNFee_Control *pxFeeCP ) {
	tQMask uiCmdLocal;
	unsigned char i;
	bool bCheckSimulation;

	uiCmdLocal.ulWord = uiCmdParam;

	switch (uiCmdLocal.ucByte[2]) {
		case M_NFC_CONFIG:
			#ifdef DEBUG_ON
				debug(fp,"NFEE Controller Task: Changing to Config Mode\n");
			#endif

			vEvtChangeFeeControllerMode(pxFeeCP->sMode, sMebConfig);
			pxFeeCP->sMode = sMebConfig;

			/* Change all NFEEs to Config mode */

			for( i = 0; i < N_OF_NFEE; i++)
			{
				if ( (*pxFeeCP->pbEnabledNFEEs[i]) == TRUE ) {
					bSendCmdQToNFeeInst( i, M_FEE_CONFIG, 0, i  );
				}
			}

			break;
		case M_NFC_RUN:
			#ifdef DEBUG_ON
				debug(fp,"NFEE Controller Task: NFC already in the Running Mode\n");
			#endif		
			/* Do nothing for now */

			break;		
		default:
			#ifdef DEBUG_ON
				debug(fp,"NFEE Controller Task: Unknow Command.\n");
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
