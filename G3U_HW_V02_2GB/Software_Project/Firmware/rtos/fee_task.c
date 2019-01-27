/*
 * fee_task.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */


#include "fee_task.h"



void vFeeTask(void *task_data) {
	bool bSuccess = FALSE;
	static TNFee *pxNFee;
	INT8U error_code;
	unsigned char ucMemUsing;
	alt_u32 tCodeNext;
	static alt_u32 incrementador; /* remover*/
	tQMask uiCmdFEE;
	TCcdMemMap *xCcdMapLocal;
	unsigned char ucReadout;
	alt_u16 usiLengthBlocks;


	pxNFee = ( TNFee * ) task_data;

	#ifdef DEBUG_ON
		fprintf(fp,"NFEE %hhu Task. (Task on)\n", pxNFee->ucId);
	#endif

	#ifdef DEBUG_ON
		vPrintConsoleNFee( pxNFee );
	#endif


	for(;;){

		switch ( pxNFee->xControl.eMode ) {
			case sFeeInit:

				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}				

				pxNFee->xControl.eMode = sToFeeConfig;

				break;
			case sToFeeConfig: /* Transition */
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE-%hu Task: Config Mode\n", pxNFee->ucId);
				#endif

				/* Complete when MUTEX were created */
				if ( pxNFee->xControl.bDMALocked == TRUE ) {
					/* If is with the Mutex, should release */
					OSMutexPost(xDma[ucMemUsing].xMutexDMA);
					pxNFee->xControl.bDMALocked = FALSE;
				}

				/* End of simulation! Clear everything that is possible */
				pxNFee->xControl.bWatingSync = FALSE;
				pxNFee->xControl.bSimulating = FALSE;
				pxNFee->xControl.bUsingDMA = FALSE;
				pxNFee->xControl.bEnabled = TRUE;
				pxNFee->xControl.ucTimeCode = 0;

				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/* Clear the Queue that indicates when Sync Signals occours */
				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/* Disable the link SPW */
				bDisableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = FALSE;


				/* Disable RMAP interrupts */
				bDisableRmapIRQ(&pxNFee->xChannel.xRmap);


				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);


				/* Clear the timecode of the channel SPW (for now is for spw channel) */
				bSpwcClearTimecode(&pxNFee->xChannel.xSpacewire);

				pxNFee->xControl.eMode = sFeeConfig;
				break;


			case sFeeConfig: /* Real mode */

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinConfig( pxNFee, uiCmdFEE.ulWord );
				} else {
					#ifdef DEBUG_ON
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					#endif
				}

				break;
			case sFeeOn: /* Real mode */

				pxNFee->xControl.eMode = sToFeeStandBy;
				break;
			case sSIMFeeStandBy:

				//pxNFee->xControl.eMode = sToFeeConfig;

				break;
			case sToFeeStandBy: /* Transition */
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE-%hu Task: Standby Mode\n", pxNFee->ucId);
				#endif

				incrementador = 0; // remover !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

				pxNFee->xControl.bSimulating = TRUE;
				pxNFee->xControl.bUsingDMA = FALSE;

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);


				/* Disable RMAP interrupts */
				bEnableRmapIRQ(&pxNFee->xChannel.xRmap);

				/* Disable the link SPW */
				bEnableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = TRUE;

				pxNFee->xControl.eMode = sFeeStandBy;
				break;

			case sFeeStandBy: /* Real mode */

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinStandBy( pxNFee, uiCmdFEE.ulWord );
				} else {
					#ifdef DEBUG_ON
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					#endif
				}

				break;
			case sSIMTestFullPattern:
#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  ENTROU NO SIM TEST FULL\n ");
#endif

				pxNFee->xControl.bUsingDMA = TRUE;
				pxNFee->xControl.bSimulating = TRUE;

				/* Enable IRQ and clear the Double Buffer */
				bEnableDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Configurar o tamanho normal do double buffer !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  */
				bSpwcGetTimecode(&pxNFee->xChannel.xSpacewire);
#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  TIME CODE SPW: %hhu \n ", pxNFee->xChannel.xSpacewire.xTimecode.ucCounter);
#endif
				tCodeNext = ( pxNFee->xChannel.xSpacewire.xTimecode.ucCounter + 1) % 4;
				if ( tCodeNext == 0 ) {
					/* Should get Data from the another memory, because is a cicle start */
					ucMemUsing = (unsigned char) (( *pxNFee->xControl.pActualMem + 1 ) % 2) ; /* Select the other memory*/
				} else {
					ucMemUsing = (unsigned char) *pxNFee->xControl.pActualMem ; /* Select the of the data control (te future)*/
				}

				ucReadout = pxNFee->xControl.ucROutOrder[tCodeNext];

				if ( pxNFee->xControl.eSide == sLeft )
					xCcdMapLocal = &pxNFee->xMemMap.xCcd[ucReadout].xLeft;
				else
					xCcdMapLocal = &pxNFee->xMemMap.xCcd[ucReadout].xRight;


				/* todo: resetar o tamanho do buffer size para o maximo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  JA PEGOU A REFERENCIA DE ENDERECO, VAI MANDAR MENSAGEM REQUISITANDO DMA\n ");
#endif

				/* Make one requests for the Double buffer */
				bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId);

#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  ENVIOU MENSAGEM PARA O CONTROLLER PEDINDO DMA. AGUARDANDO NO xFeeQ\n ");
#endif

				/* When get the mutex, perform two DMA writes in order to fill the "double" part of the double buffer */
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  RECEBEU MENSAGEM\n ");
#endif

					/* First Check if is access to the DMA (priority) */
					if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {
#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  ERA DE ACESSO AO DMA\n ");
#endif

						/* Try to get the Mutex */
	                    OSMutexPend(xDma[ucMemUsing].xMutexDMA, 0, &error_code); /* Blocking way */
	                    if ( error_code == OS_ERR_NONE ) {
	                    	pxNFee->xControl.bDMALocked = TRUE;

#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  PEGOU MUTEX\n ");
#endif

						if (  ucMemUsing == 0  ) {
							/* Initializing the addr */
	                    	xCcdMapLocal->ulBlockI = 0;
							xCcdMapLocal->ulAddrI = xCcdMapLocal->ulOffsetAddr;
							bSdmaDmaM1Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
							//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
							xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
							xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;
							bSdmaDmaM1Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
							//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
							xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
							xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;
	                        OSMutexPost(xDma[ucMemUsing].xMutexDMA);
	                        pxNFee->xControl.bDMALocked = FALSE;
						} else {
							/* Initializing the addr */
	                    	xCcdMapLocal->ulBlockI = 0;
							xCcdMapLocal->ulAddrI = xCcdMapLocal->ulOffsetAddr;
							bSdmaDmaM2Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
							//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
							xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
							xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;
							bSdmaDmaM2Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
							//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
							xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
							xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;
	                        OSMutexPost(xDma[ucMemUsing].xMutexDMA);
	                        pxNFee->xControl.bDMALocked = FALSE;
						}

						incrementador = 2; // remover !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  MANDOU OS COMANDOS VIA DMA\n ");
#endif

	                        /* Send message telling to controller that is not using the DMA any more */
							bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);
#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  MSG PARA CONTROLER DEVOLVENDO DMA\n ");
#endif


	                    }
					} else {
						vQCmdFEEinFullPattern( pxNFee, uiCmdFEE.ulWord );
					}
				} else {
					#ifdef DEBUG_ON
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					#endif
				}

				if (pxNFee->xControl.bWatingSync==TRUE) {
					pxNFee->xControl.eNextMode = sToTestFullPattern;
					pxNFee->xControl.eMode = sFeeWaitingSync;
				} else {
					pxNFee->xControl.eNextMode = sToTestFullPattern;
					pxNFee->xControl.eMode = sToTestFullPattern;
				}

				break;


			case sToTestFullPattern: /* Transition */
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE-%hu Task: Full Image Pattern Mode\n", pxNFee->ucId);
				#endif

				pxNFee->xControl.bUsingDMA = TRUE;
				bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId); /*todo:REMOVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
				pxNFee->xControl.eMode = sFeeTestFullPattern;
				break;


			case sFeeTestFullPattern: /* Real mode */

#ifdef DEBUG_ON
	//fprintf(fp,"\nFEE TASK:  sFeeTestFullPattern\n ");
#endif

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

#ifdef DEBUG_ON
	//fprintf(fp,"\nFEE TASK:  RECEBEU COMANDO\n ");
#endif

					/* First Check if is access to the DMA (priority) */
						if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {
#ifdef DEBUG_ON
	//fprintf(fp,"\nFEE TASK:  ERA ACESSO AO DMA\n ");
#endif

							/* Try to get the Mutex */
		                    OSMutexPend(xDma[ucMemUsing].xMutexDMA, 0, &error_code); /* Blocking way */
		                    if ( error_code == OS_ERR_NONE ) {
		                    	pxNFee->xControl.bDMALocked = TRUE;
#ifdef DEBUG_ON
	//fprintf(fp,"\nFEE TASK:  PEGOU MUTEX DO DMA\n ");
#endif

		                    	/* Is this the last block? */
		                    	if ( (xCcdMapLocal->ulBlockI+SDMA_MAX_BLOCKS) >= pxNFee->xMemMap.xCommon.usiNTotalBlocks ) {

		                    		/* todo: Configurar o tamanho do buffer para um numero menor = pxNFee->xMemMap.xCommon.usiNTotalBlocks - xCcdMapLocal->ulBlockI */
		                    		/* todo: Nao esquece porra !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
		                    		usiLengthBlocks = pxNFee->xMemMap.xCommon.usiNTotalBlocks - xCcdMapLocal->ulBlockI;
		                    		pxNFee->xControl.bWatingSync = TRUE;
		                    		pxNFee->xControl.eMode = sSIMTestFullPattern;
		                    		pxNFee->xControl.eNextMode = sSIMTestFullPattern;
		                    		pxNFee->xControl.bUsingDMA = FALSE;
		                    		pxNFee->xControl.eMode = sToFeeStandBy; /* todo:REMOVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
		                    	} else {
		                    		usiLengthBlocks = SDMA_MAX_BLOCKS;
		                    		bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId); /*todo:REMOVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
		                    	}

		                    	if ( ucMemUsing == 0  ) {

		                    		//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
		                    		bSdmaDmaM1Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
		                    	} else {

		                    		//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
		                    		bSdmaDmaM2Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
		                    	}


								/* Value of xCcdMapLocal->ulAddrI already set in the last iteration */

								xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
		                        OSMutexPost(xDma[ucMemUsing].xMutexDMA);
		                        pxNFee->xControl.bDMALocked = FALSE;
		                        //bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

		                        incrementador++; // remover !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#ifdef DEBUG_ON
	//fprintf(fp,"\nFEE TASK:  ENVIOU DADOS AO DMA\n ");
#endif
		                        /* Send message talling to controller that is not using the DMA any more */
								bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);
#ifdef DEBUG_ON
	//fprintf(fp,"\nFEE TASK:  DEVOLVEU AO CONTROLLER\n ");
#endif

#ifdef DEBUG_ON
	fprintf(fp,"\nFEE TASK:  pckt: %ui\n ",incrementador);
#endif


                   }
						} else {
							vQCmdFEEinFullPattern( pxNFee, uiCmdFEE.ulWord );
						}

				} else {
					#ifdef DEBUG_ON
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					#endif
				}

				break;

			case sFeeWaitingSync:

				pxNFee->xControl.eMode = pxNFee->xControl.eNextMode;

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xWaitSyncQFee[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Write in the RMAP */
					bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);

					/* UCL- NFEE ICD p. 49 */
					switch ( pxNFee->xControl.eNextMode ) {
						case sToFeeConfig:
						case sFeeConfig:
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x06; /* Off-Mode */
							break;
						case sFeeStandBy:
						case sToFeeStandBy:
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x00;
							break;
						case sSIMTestFullPattern:
						case sToTestFullPattern:
						case sFeeTestFullPattern:
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x02;
							break;
						default:
							break;
					}

					bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				} else {
					#ifdef DEBUG_ON
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xWaitSyncQFee\n", pxNFee->ucId);
					#endif
				}

				pxNFee->xControl.bWatingSync = FALSE;
				break;
			default:
				pxNFee->xControl.eMode = sToFeeConfig;
				#ifdef DEBUG_ON
					fprintf(fp,"\nNFEE %hhu Task: Unexpected mode (default)\n", pxNFee->ucId);
				#endif
				break;
		}

	}

}


void vQCmdFEEinConfig( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG_FORCED:
			case M_FEE_CONFIG:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Already in Config mode\n", pxNFeeP->ucId);
				#endif
				break;
			case M_FEE_RUN:
				/*pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sFeeOn;*/
				break;
			case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				break;
			case M_FEE_STANDBY_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeStandBy;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				break;				
			case M_FEE_FULL_PATTERN_FORCED:
			case M_FEE_FULL_PATTERN:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task: Can't go to Full Image Pattern from Config mode\n", pxNFeeP->ucId);
				#endif
				break;											
			default:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Confg mode)\n", pxNFeeP->ucId);
				#endif
				break;
		}
	}
}

void vQCmdFEEinStandBy( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeConfig; /* To finish the actual transfer only when sync comes */
				break;
			case M_FEE_CONFIG_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeConfig;
				pxNFeeP->xControl.eNextMode = sToFeeConfig; /* To finish the actual transfer only when sync comes */
				break;				
			case M_FEE_RUN:
				/*pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sFeeOn;*/
				break;
			case M_FEE_STANDBY_FORCED:
			case M_FEE_STANDBY:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Already in Stand by mode\n", pxNFeeP->ucId);
				#endif
				break;
			case M_FEE_FULL_PATTERN:
			case M_FEE_FULL_PATTERN_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sSIMTestFullPattern; /*sSIMTestFullPattern*/
				pxNFeeP->xControl.eNextMode = sSIMTestFullPattern;
				break;				
			default:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Config mode)\n", pxNFeeP->ucId);
				#endif
				break;
		}
	}
}

void vQCmdFEEinFullPattern( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;
			case M_FEE_CONFIG_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeConfig;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;				
			case M_FEE_RUN:
				/*pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sFeeOn;*/
				break;
			case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy; /* To finish the actual transfer only when sync comes */
				break;
			case M_FEE_STANDBY_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeStandBy;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy; /* To finish the actual transfer only when sync comes */
				break;				
			case M_FEE_FULL_PATTERN:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Already in Full Image Pattern mode\n", pxNFeeP->ucId);
				#endif
				break;
			default:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Confg mode)\n", pxNFeeP->ucId);
				#endif
				break;
		}
	}
}

bool bDisableRmapIRQ( TRmapChannel *pxRmapCh ) {
	/* Disable SPW channel */
	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteCmdEn = FALSE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableRmapIRQ( TRmapChannel *pxRmapCh ) {
	/* Disable SPW channel */
	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteCmdEn = TRUE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bDisableSPWChannel( TSpwcChannel *xSPW ) {
	/* Disable SPW channel */
	bSpwcGetLink(xSPW);
	xSPW->xLinkConfig.bLinkStart = FALSE;
	xSPW->xLinkConfig.bAutostart = FALSE;
	xSPW->xLinkConfig.bDisconnect = TRUE;
	bSpwcSetLink(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableSPWChannel( TSpwcChannel *xSPW ) {
	/* Enable SPW channel */
	bSpwcGetLink(xSPW);
	xSPW->xLinkConfig.bLinkStart = FALSE;
	xSPW->xLinkConfig.bAutostart = TRUE;
	xSPW->xLinkConfig.bDisconnect = FALSE;
	bSpwcSetLink(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableDbBuffer( TFeebChannel *pxFeebCh ) {

	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);

	/* Start the module Double Buffer */
	bFeebStartCh(pxFeebCh);

	/*Enable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xIrqControl.bLeftBufferEmptyEn = TRUE;
	pxFeebCh->xIrqControl.bRightBufferEmptyEn = TRUE;
	bFeebSetIrqControl(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}


bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh ) {

	/*Disable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xIrqControl.bLeftBufferEmptyEn = FALSE;
	pxFeebCh->xIrqControl.bRightBufferEmptyEn = FALSE;
	bFeebSetIrqControl(pxFeebCh);

	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);

	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bSendRequestNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPost(xNfeeSchedule, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailRequestDMA( ucValue );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}

	return bSuccesL;
}


bool bSendGiveBackNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailRequestDMA( ucValue );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}

	return bSuccesL;
}


#ifdef DEBUG_ON
	void vPrintConsoleNFee( TNFee *pxNFeeI ) {
		TNFee *pxNFee;

		pxNFee = pxNFeeI;

		fprintf(fp,"=================================NFEE %hhu=====================================\n", pxNFee->ucId);
		fprintf(fp,"\n");
		fprintf(fp,"NFEE %hhu CCD infos: \n", pxNFee->ucId);
		fprintf(fp,"    PreScan = %hu \n", pxNFee->xCcdInfo.usiSPrescanN);
		fprintf(fp,"    OverScan = %hu \n", pxNFee->xCcdInfo.usiSOverscanN);
		fprintf(fp,"    OLN = %hu \n", pxNFee->xCcdInfo.usiOLN);
		fprintf(fp,"    Half Width = %hu \n", pxNFee->xCcdInfo.usiHalfWidth);
		fprintf(fp,"    Height = %hu \n", pxNFee->xCcdInfo.usiHeight);
		fprintf(fp,"\n");
		fprintf(fp,"NFEE %hhu Control: \n", pxNFee->ucId);
		fprintf(fp,"    NFEE State 	= %hu \n", pxNFee->xControl.eMode);
		fprintf(fp,"    NFEE Enable? = %hu \n", pxNFee->xControl.bEnabled);
		fprintf(fp,"    Using DMA?   = %hu \n", pxNFee->xControl.bUsingDMA);
		fprintf(fp,"    Logging?     = %hu \n", pxNFee->xControl.bLogging);
		fprintf(fp,"    Echoing?     = %hu \n", pxNFee->xControl.bEchoing);
		fprintf(fp,"    Channel Enable? = %hu \n", pxNFee->xControl.bChannelEnable);
		fprintf(fp,"    Readout order = [ %hhu , %hhu , %hhu , %hhu ] \n", pxNFee->xControl.ucROutOrder[0], pxNFee->xControl.ucROutOrder[1], pxNFee->xControl.ucROutOrder[2], pxNFee->xControl.ucROutOrder[3]);
		fprintf(fp,"    CCD Side = = %hu \n", pxNFee->xControl.eSide);
		fprintf(fp,"\n\n");
		fprintf(fp,"NFEE %hhu MEMORY MAP: \n", pxNFee->ucId);
		fprintf(fp,"    General Info: \n");
		fprintf(fp,"        Offset root 	= %lu \n", pxNFee->xMemMap.ulOffsetRoot);
		fprintf(fp,"        Total Bytes 	= %lu \n", pxNFee->xMemMap.ulTotalBytes);
		fprintf(fp,"        LUT ADDR 	= %lu \n", pxNFee->xMemMap.ulLUTAddr);
		fprintf(fp,"    Common to all CCDs: \n");
		fprintf(fp,"        Total Bytes 	= %hu \n", pxNFee->xMemMap.xCommon.usiTotalBytes);
		fprintf(fp,"        Total of Blocks = %hu \n", pxNFee->xMemMap.xCommon.usiNTotalBlocks);
		fprintf(fp,"        Padding Bytes 	= %hhu\n", pxNFee->xMemMap.xCommon.ucPaddingBytes);
		fprintf(fp,"        Padding MASK 	= %llu\n", pxNFee->xMemMap.xCommon.ucPaddingMask.ullWord);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 0 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 1 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 2 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 3 , pxNFee->ucId);
		fprintf(fp,"        Left side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulAddrI);
		fprintf(fp,"        Right side \n");
		fprintf(fp,"            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulOffsetAddr);
		fprintf(fp,"            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulBlockI);
		fprintf(fp,"            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulAddrI);
		fprintf(fp,"\n");
		fprintf(fp,"==============================================================================\n");
		fprintf(fp,"==============================================================================\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
		fprintf(fp,"\n");
	}
#endif

	/*
#ifdef DEBUG_ON
	void vPrintUARTNFee( TNFee *pxNFeeI ) {
		TNFee *pxNFee;

		pxNFee = pxNFeeI;

		printf("=================================NFEE %hhu=====================================\n", pxNFee->ucId);
		printf("\n");
		printf("NFEE %hhu CCD infos: \n", pxNFee->ucId);
		printf("    PreScan = %hu \n", pxNFee->xCcdInfo.usiSPrescanN);
		printf("    OverScan = %hu \n", pxNFee->xCcdInfo.usiSOverscanN);
		printf("    OLN = %hu \n", pxNFee->xCcdInfo.usiOLN);
		printf("    Half Width = %hu \n", pxNFee->xCcdInfo.usiHalfWidth);
		printf("    Height = %hu \n", pxNFee->xCcdInfo.usiHeight);
		printf("\n");
		printf("NFEE %hhu Control: \n", pxNFee->ucId);
		printf("    NFEE State 	= %hu \n", pxNFee->xControl.eMode);
		printf("    NFEE Enable? = %hu \n", pxNFee->xControl.bEnabled);
		printf("    Using DMA?   = %hu \n", pxNFee->xControl.bUsingDMA);
		printf("    Logging?     = %hu \n", pxNFee->xControl.bLogging);
		printf("    Echoing?     = %hu \n", pxNFee->xControl.bEchoing);
		printf("    Channel Enable? = %hu \n", pxNFee->xControl.bChannelEnable);
		printf("    Readout order = [ %hhu , %hhu , %hhu , %hhu ] \n", pxNFee->xControl.ucROutOrder[0], pxNFee->xControl.ucROutOrder[1], pxNFee->xControl.ucROutOrder[2], pxNFee->xControl.ucROutOrder[3]);
		printf("    CCD Side = = %hu \n", pxNFee->xControl.eSide);
		printf("\n\n");
		printf("NFEE %hhu MEMORY MAP: \n", pxNFee->ucId);
		printf("    General Info: \n");
		printf("        Offset root 	= %lu \n", pxNFee->xMemMap.ulOffsetRoot);
		printf("        Total Bytes 	= %lu \n", pxNFee->xMemMap.ulTotalBytes);
		printf("        LUT ADDR 	= %lu \n", pxNFee->xMemMap.ulLUTAddr);
		printf("    Common to all CCDs: \n");
		printf("        Total Bytes 	= %hu \n", pxNFee->xMemMap.xCommon.usiTotalBytes);
		printf("        Total of Blocks = %hu \n", pxNFee->xMemMap.xCommon.usiNTotalBlocks);
		printf("        Padding Bytes 	= %hhu\n", pxNFee->xMemMap.xCommon.ucPaddingBytes);
		printf("        Padding MASK 	= %llu\n", pxNFee->xMemMap.xCommon.ucPaddingMask.ullWord);
		printf("\n");
		printf("    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 0 , pxNFee->ucId);
		printf("        Left side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xLeft.ulAddrI);
		printf("        Right side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[0].xRight.ulAddrI);
		printf("\n");
		printf("    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 1 , pxNFee->ucId);
		printf("        Left side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xLeft.ulAddrI);
		printf("        Right side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[1].xRight.ulAddrI);
		printf("\n");
		printf("    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 2 , pxNFee->ucId);
		printf("        Left side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xLeft.ulAddrI);
		printf("        Right side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[2].xRight.ulAddrI);
		printf("\n");
		printf("    CCD %hhu - NFEE %hhu MEMORY MAP: \n", 3 , pxNFee->ucId);
		printf("        Left side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xLeft.ulAddrI);
		printf("        Right side \n");
		printf("            Offset (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulOffsetAddr);
		printf("            Block index (Blocks) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulBlockI);
		printf("            Initial next block (Bytes) = %lu \n", pxNFee->xMemMap.xCcd[3].xRight.ulAddrI);
		printf("\n");
		printf("==============================================================================\n");
		printf("==============================================================================\n");
		printf("\n");
		printf("\n");
		printf("\n");
		printf("\n");
	}
#endif

*/
