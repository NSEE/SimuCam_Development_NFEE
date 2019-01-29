/*
 * fee_task.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */


#include "fee_task.h"

TRmapChannel RmapConfAreaL;

void vFeeTask(void *task_data) {
	bool bSuccess = FALSE;
	static TNFee *pxNFee;
	INT8U error_code;
	unsigned char ucMemUsing;
	static alt_u32 tCodFeeTask;
	alt_u32 tCodeNext;
	static alt_u32 incrementador; /* remover*/
	tQMask uiCmdFEE;
	TCcdMemMap *xCcdMapLocal;
	unsigned char ucReadout;
	alt_u16 usiLengthBlocks;
	bool bDmaReturn;
	bool bFinal;


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

				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdXSize = pxNFee->xCcdInfo.usiHalfWidth;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdYSize = pxNFee->xCcdInfo.usiHeight;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiDataYSize = pxNFee->xCcdInfo.usiHeight - pxNFee->xCcdInfo.usiOLN;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiOverscanYSize = pxNFee->xCcdInfo.usiOLN;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = 32768;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = 0; /* 32 KB */
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePattern; /* todo:N�o esquecer de atualizar para o ENUM  */
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);


				pxNFee->xControl.eMode = sToFeeConfig;

				break;
			case sToFeeConfig: /* Transition */

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x06; /*Off*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable the link SPW */
				bDisableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = FALSE;

				/* Disable RMAP interrupts */
				bDisableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucId);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				#ifdef DEBUG_ON
					fprintf(fp,"NFEE-%hu Task: Config Mode\n", pxNFee->ucId);
				#endif

				/* Complete when MUTEX were created */
				if ( pxNFee->xControl.bDMALocked == TRUE ) {
					/* If is with the Mutex, should release */
					OSMutexPost(xDma[ucMemUsing].xMutexDMA);
					pxNFee->xControl.bDMALocked = FALSE;
				}

				/* Cleaning other syncs that maybe in the queue */
				pxNFee->xControl.bWatingSync = FALSE;
				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);

				/* End of simulation! Clear everything that is possible */
				pxNFee->xControl.bWatingSync = FALSE;
				pxNFee->xControl.bSimulating = FALSE;
				pxNFee->xControl.bUsingDMA = FALSE;
				pxNFee->xControl.bEnabled = TRUE;

				vResetMemCCDFEE(pxNFee);

				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				pxNFee->xControl.bWatingSync = TRUE;
				pxNFee->xControl.eMode = sFeeConfig;
				bFinal = FALSE;
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
			case sFeeOn: /* Not implemented yet */

				pxNFee->xControl.eMode = sToFeeStandBy;
				break;
			case sToFeeStandBy: /* Transition */

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x00; /*sToFeeStandBy*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Disable RMAP interrupts */
				bEnableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucId);

				/* Disable the link SPW */
				bEnableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = TRUE;

				pxNFee->xControl.bSimulating = TRUE;
				pxNFee->xControl.bUsingDMA = FALSE;
				pxNFee->xControl.bEnabled = TRUE;

				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);

				/* Cleaning other syncs that maybe in the queue */
				pxNFee->xControl.bWatingSync = FALSE;
				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				#ifdef DEBUG_ON
					fprintf(fp,"NFEE-%hu Task: Standby Mode\n", pxNFee->ucId);
				#endif

				/* Reset the memory addr variables thats is used in the transmission*/
				vResetMemCCDFEE(pxNFee);

				pxNFee->xControl.bWatingSync = TRUE;
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


			case sNextPatternIteration:


				error_code = OSQFlush( xWaitSyncQFee[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				pxNFee->xControl.bUsingDMA = TRUE;
				pxNFee->xControl.bSimulating = TRUE;

				vResetMemCCDFEE(pxNFee);

				bFeebCh1SetBufferSize(SDMA_MAX_BLOCKS,0);
				bFeebCh1SetBufferSize(SDMA_MAX_BLOCKS,1);

				/* Enable IRQ and clear the Double Buffer */
				bEnableDbBuffer(&pxNFee->xChannel.xFeeBuffer);


				bSpwcGetTimecode(&pxNFee->xChannel.xSpacewire);
				tCodFeeTask = pxNFee->xChannel.xSpacewire.xTimecode.ucCounter;
				tCodeNext = ( tCodFeeTask + 1) % 4;
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


				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = ucReadout;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePattern; /* todo:N�o esquecer de atualizar para o ENUM  */
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);


				/* Make one requests for the Double buffer */
				bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId);
				bDmaReturn = FALSE;
				/* When get the mutex, perform two DMA writes in order to fill the "double" part of the double buffer */
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* First Check if is access to the DMA (priority) */
					if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {

						/* Try to get the Mutex */
	                    OSMutexPend(xDma[ucMemUsing].xMutexDMA, 0, &error_code); /* Blocking way */
	                    if ( error_code == OS_ERR_NONE ) {
	                    	pxNFee->xControl.bDMALocked = TRUE;

							if (  ucMemUsing == 0  ) {
								/* Initializing the addr */
								xCcdMapLocal->ulBlockI = 0;
								xCcdMapLocal->ulAddrI = xCcdMapLocal->ulOffsetAddr;
								bDmaReturn = bSdmaDmaM1Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
								if ( bDmaReturn == TRUE ) {
									//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
									xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
									xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;
									bDmaReturn = bSdmaDmaM1Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
									if ( bDmaReturn == TRUE ) {
										//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
										xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
										xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;

									}
								}
								OSMutexPost(xDma[ucMemUsing].xMutexDMA);
								pxNFee->xControl.bDMALocked = FALSE;
							} else {
								xCcdMapLocal->ulBlockI = 0;
								xCcdMapLocal->ulAddrI = xCcdMapLocal->ulOffsetAddr;
								bDmaReturn = bSdmaDmaM2Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
								if ( bDmaReturn == TRUE ) {
									//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
									xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
									xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;
									bDmaReturn = bSdmaDmaM2Transfer(xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId);
									if ( bDmaReturn == TRUE ) {
										//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
										xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
										xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;

									}
								}
								OSMutexPost(xDma[ucMemUsing].xMutexDMA);
								pxNFee->xControl.bDMALocked = FALSE;
							}
	                        /* Send message telling to controller that is not using the DMA any more */
							bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);							

							if ( bDmaReturn == TRUE ) {
								if (pxNFee->xControl.bWatingSync==TRUE) {
									pxNFee->xControl.eNextMode = sToTestFullPattern;
									pxNFee->xControl.eMode = sFeeWaitingSync;
								} else {
									pxNFee->xControl.eNextMode = sToTestFullPattern;
									pxNFee->xControl.eMode = sToTestFullPattern;
								}
							}


							#ifdef DEBUG_ON
								fprintf(fp,"\nFEE TASK:  Double buffer prepared\n ");
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


			case sToTestFullPattern: /* Transition */
				bFinal = FALSE;

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x02; /*Pattern Full Image*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				#ifdef DEBUG_ON
					fprintf(fp,"NFEE-%hu Task: Full Image Pattern Mode\n", pxNFee->ucId);
				#endif

				pxNFee->xControl.bUsingDMA = TRUE;
				pxNFee->xControl.eMode = sFeeTestFullPattern;
				pxNFee->xControl.eNextMode = sFeeTestFullPattern;
				pxNFee->xControl.bWatingSync = TRUE;
				pxNFee->xControl.bSimulating = TRUE;
				pxNFee->xControl.bEnabled = TRUE;
				bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId); /*todo:REMOVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

				break;


			case sFeeTestFullPattern: /* Real mode */

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* First Check if is access to the DMA (priority) */
						if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {

							/* Try to get the Mutex */
		                    OSMutexPend(xDma[ucMemUsing].xMutexDMA, 0, &error_code); /* Blocking way */
		                    if ( error_code == OS_ERR_NONE ) {
		                    	pxNFee->xControl.bDMALocked = TRUE;

		                    	/* Is this the last block? */
		                    	if ( (xCcdMapLocal->ulBlockI + SDMA_MAX_BLOCKS) >= pxNFee->xMemMap.xCommon.usiNTotalBlocks ) {

									#ifdef DEBUG_ON
										//fprintf(fp,"\n    i: %u ",incrementador);
										fprintf(fp,"\nEnd of transmission NFEE-%hhu -> CCD %hhu  -> Time Code Ref. used -> %hu  \n", pxNFee->ucId, ucReadout, tCodFeeTask);
										fprintf(fp,"\nMemory used: %u ", ucMemUsing);
										fprintf(fp,"\nTotal blocks transmited: %u ",xCcdMapLocal->ulBlockI);
									#endif

		                    		/*Define the size of the data in the double buffer (need this to create the interrupt riht)*/
		                    		bFeebCh1SetBufferSize( (pxNFee->xMemMap.xCommon.usiNTotalBlocks - xCcdMapLocal->ulBlockI), 0 );
		                    		bFeebCh1SetBufferSize( (pxNFee->xMemMap.xCommon.usiNTotalBlocks - xCcdMapLocal->ulBlockI), 1 );

		                    		usiLengthBlocks = pxNFee->xMemMap.xCommon.usiNTotalBlocks - xCcdMapLocal->ulBlockI;
		                    		bFinal = TRUE;

		                    	} else {

		                    		bFinal = FALSE;
		                    		usiLengthBlocks = SDMA_MAX_BLOCKS;
		                    	}

		                    	if ( ucMemUsing == 0  ) {
		                    		//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
		                    		bDmaReturn = bSdmaDmaM1Transfer(xCcdMapLocal->ulAddrI, usiLengthBlocks, pxNFee->xControl.eSide, pxNFee->ucId);
		                    	} else {

		                    		//(*xDma[ucMemUsing].pDmaTranfer)( xCcdMapLocal->ulAddrI,SDMA_MAX_BLOCKS, pxNFee->xControl.eSide, pxNFee->ucId );
		                    		bDmaReturn = bSdmaDmaM2Transfer(xCcdMapLocal->ulAddrI, usiLengthBlocks, pxNFee->xControl.eSide, pxNFee->ucId);
		                    	}


		                    	if ( bDmaReturn = TRUE ) {
									/* Value of xCcdMapLocal->ulAddrI already set in the last iteration */
									xCcdMapLocal->ulAddrI += SDMA_BUFFER_SIZE_BYTES;
									xCcdMapLocal->ulBlockI += SDMA_MAX_BLOCKS;

									//bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);
		                    	} else {
									#ifdef DEBUG_ON
										fprintf(fp,"\n--\n ");
									#endif
									bFinal = FALSE;
		                    	}

		                    	OSMutexPost(xDma[ucMemUsing].xMutexDMA);
		                    	pxNFee->xControl.bDMALocked = FALSE;
		                        /* Send message telling to controller that is not using the DMA any more */
								bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);

								/* Just to see the progress */
								if ( ((xCcdMapLocal->ulBlockI) % 4096 == 0) ) {

									#ifdef DEBUG_ON
										fprintf(fp,"\nblock: %u ", xCcdMapLocal->ulBlockI);
									#endif
								}


								if ( bFinal == TRUE ) {
									pxNFee->xControl.eMode = sEndTransmission;
								} else {
									bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId); /*todo:REMOVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
								}

		                    }
						} else {
							vQCmdFEEinFullPattern( pxNFee, uiCmdFEE.ulWord );

							if ( pxNFee->xControl.bWatingSync == FALSE ) {
								pxNFee->xControl.eMode = pxNFee->xControl.eNextMode;
							}
						}

				} else {
					#ifdef DEBUG_ON
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					#endif
				}

				break;

			case sEndTransmission:

				pxNFee->xControl.bWatingSync = TRUE;
				pxNFee->xControl.bUsingDMA = FALSE;

				if ( pxNFee->xControl.eNextMode == sToFeeStandBy ) {
					pxNFee->xControl.eMode =  sFeeWaitingSync;
					pxNFee->xControl.eNextMode =  sToFeeStandBy;
				} else {
					pxNFee->xControl.eMode =  sNextPatternIteration;
					pxNFee->xControl.eNextMode =  sFeeWaitingSync;
				}

				break;

			case sFeeWaitingSync:

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code != OS_ERR_NONE ) {
					#ifdef DEBUG_ON
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ (sFeeWaitingSync)\n", pxNFee->ucId);
					#endif
				} else {
					vQCmdFEEinWaitingSync( pxNFee, uiCmdFEE.ulWord  );
				}

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

void vQCmdFEEinWaitingSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeConfig;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;
			case M_FEE_STANDBY_FORCED:
			case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync; /*sSIMTestFullPattern*/
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				break;
			case M_FEE_FULL_PATTERN:
			case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sNextPatternIteration; /*sSIMTestFullPattern*/
				pxNFeeP->xControl.eNextMode = sFeeWaitingSync;
				break;
			case M_FEE_RMAP:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task: RMAP Message Received\n", pxNFeeP->ucId);
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPWaitingSync( pxNFeeP, cmd );
				break;
			case M_SYNC:
			case M_MASTER_SYNC:
				/* Warning */
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					pxNFeeP->xControl.bWatingSync = FALSE;

				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			default:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Config mode)\n", pxNFeeP->ucId);
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
			/*case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				break;*/
			case M_FEE_STANDBY: /* Config -> StandBy is always forced mode (don't need sync) */
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
			case M_FEE_RMAP:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task: Shouldn't receive RMAP Messages in this mode (Config Mode)\n", pxNFeeP->ucId);
				#endif
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_SYNC:
			case M_MASTER_SYNC:
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
			/*case M_FEE_CONFIG:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;*/
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sToFeeConfig;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;				
			case M_FEE_STANDBY_FORCED:
			case M_FEE_STANDBY:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Already in Stand by mode\n", pxNFeeP->ucId);
				#endif
				break;
			case M_FEE_FULL_PATTERN:
			case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sNextPatternIteration; /*sSIMTestFullPattern*/
				pxNFeeP->xControl.eNextMode = sFeeWaitingSync;
				break;

			case M_FEE_RMAP:
				vQCmdFeeRMAPinStandBy( pxNFeeP, cmd );

				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task: RMAP Message Received\n", pxNFeeP->ucId);
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */

				break;


			case M_SYNC:
			case M_MASTER_SYNC:
				/* Warning */
				if ( pxNFeeP->xControl.eMode == sFeeWaitingSync ) {
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					pxNFeeP->xControl.bWatingSync = FALSE;
				}
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
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
			/*case M_FEE_CONFIG:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeConfig;
				break;*/
			case M_FEE_CONFIG:
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
				/*pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;*/ /* To finish the actual transfer only when sync comes */
				if ( pxNFeeP->xControl.eMode == sNextPatternIteration ) {
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eMode = sFeeWaitingSync;
					pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				} else {
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eMode = sFeeTestFullPattern;
					pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				}

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
			case M_FEE_RMAP:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task: RMAP Message Received\n", pxNFeeP->ucId);
				#endif

				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPinFullPattern( pxNFeeP, cmd );

				break;

			case M_SYNC:
			case M_MASTER_SYNC:
				/* Warning */
				if ( pxNFeeP->xControl.eMode == sFeeWaitingSync ) {
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					pxNFeeP->xControl.bWatingSync = FALSE;
				}

				break;
			default:
				#ifdef DEBUG_ON
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Confg mode)\n", pxNFeeP->ucId);
				#endif
				break;
		}
	}
}



void vQCmdFeeRMAPinStandBy( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT32U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

#ifdef DEBUG_ON
	fprintf(fp,"vQCmdFeeRMAPinStandBy REMOVER\n", pxNFeeP->ucId);
#endif

	uiCmdFEEL.ulWord = cmd;

	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);

	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			ucValueMasked = (COMM_RMAP_IMGCLK_TRCNT_CTRL_MSK & ucValueReg) >> 4; /* Number of rows */
			ucValueMasked2 = (COMM_RMAP_REGCLK_TRCNT_CTRL_MSK & ucValueReg) >> 20; /* Number of columns */

			pxNFeeP->xCcdInfo.usiHeight = ucValueMasked;
			pxNFeeP->xCcdInfo.usiHalfWidth = ucValueMasked2;
			vUpdateMemMapFEE(pxNFeeP);

			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdXSize = pxNFeeP->xCcdInfo.usiHalfWidth;
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdYSize = pxNFeeP->xCcdInfo.usiHeight;
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiDataYSize = pxNFeeP->xCcdInfo.usiHeight - pxNFeeP->xCcdInfo.usiOLN;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

			#ifdef DEBUG_ON
				fprintf(fp,"- Rows: %u\n - Columns: %u\n", ucValueMasked, ucValueMasked2);
			#endif

			break;
		case 0x041://0x00000004:ccd_seq_2_config
			break;
		case 0x042://0x00000008:spw_packet_1_config

			ucValueMasked = (ucValueReg & COMM_RMAP_PACKET_SIZE_CTRL_MSK) >> 4;
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = ucValueMasked;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

			#ifdef DEBUG_ON
				fprintf(fp,"- Pckt Length: %u\n", ucValueMasked);
			#endif

			ucValueMasked2 = (ucValueReg & COMM_RMAP_CCD_DTRAN_SEL_CTRL_MSK) >> 2;

			switch (ucValueMasked2) {
				case 0b01:
					pxNFeeP->xControl.eSide = sLeft;
					#ifdef DEBUG_ON
						fprintf(fp," - Left side\n");
					#endif
					break;
				case 0b10:
					pxNFeeP->xControl.eSide = sRight;
					#ifdef DEBUG_ON
						fprintf(fp," - Right side\n");
					#endif
					break;
				case 0b11:
					pxNFeeP->xControl.eSide = sLeft;
					#ifdef DEBUG_ON
						fprintf(fp," - Both sides, but not supported yet. Switching to Left side\n");
					#endif
				default:
					pxNFeeP->xControl.eSide = sLeft;

					bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
					pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSpwPacket1Config = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSpwPacket1Config & 0xFFFFFFF7);
					bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);
					#ifdef DEBUG_ON
						fprintf(fp," - Switching to Left side\n");
					#endif
					break;
			}
			break;
		case 0x043://0x0000000C:spw_packet_2_config
		case 0x44://0x00000010:CCD_1_windowing_1_config
		case 0x45://0x00000014:CCD_1_windowing_2_config
		case 0x46://0x00000018:CCD_2_windowing_1_config
		case 0x47://0x0000001C:CCD_2_windowing_2_config
		case 0x48://0x00000020:CCD_3_windowing_1_config
		case 0x49://0x00000024:CCD_3_windowing_2_config
		case 0x4A://0x00000028:CCD_4_windowing_1_config
		case 0x4B://0x0000002C:CCD_4_windowing_2_config
			#ifdef DEBUG_ON
				fprintf(fp,"Command not allowed yet ( %hhu )\n", ucValueMasked);
			#endif
				break;
		case 0x0000004C://0x00000038:operation_mode_config
			/* Mode Selection */
			ucValueMasked = (COMM_RMAP_MODE_SEL_CTRL_MSK & ucValueReg) >>4;

			switch (ucValueMasked) {
				case 0: /* Standby */

				#ifdef DEBUG_ON
					fprintf(fp,"- already in Stand by mode\n", pxNFeeP->ucId);
				#endif

					break;
				case 2: /* PAttern Full image */
				#ifdef DEBUG_ON
					fprintf(fp,"- to Full-Image-Pattern\n");
				#endif

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eMode = sNextPatternIteration; /*sSIMTestFullPattern*/
					pxNFeeP->xControl.eNextMode = sFeeWaitingSync;

					break;
				case 6:
				#ifdef DEBUG_ON
					fprintf(fp,"- Off-Mode not allowed.\n");
				#endif
					break;
				case 1:
				case 3:
				case 4:
				case 5:
				default:
					#ifdef DEBUG_ON
						fprintf(fp,"- mode not allowed yet ( %hhu )\n", ucValueMasked);
					#endif
					break;
			}

			break;
		case 0x0000004D://0x0000003C:sync_config

			ucValueMasked = (COMM_RMAP_SELF_TRIGGER_CTRL_MSK & ucValueReg) >> 2; /* Number of rows */

			/* Cannot perform this operation */
			if ( ucValueMasked ) {
				#ifdef DEBUG_ON
					fprintf(fp," - operation not allowed (StandBy-Mode)\n");
				#endif
				/* Clear the trigger */
				bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
				pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig & 0xFFFFFFFB);
				bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);
			}

			break;
		case 0x0000004E://0x00000040:dac_control
		case 0x0000004F://0x00000044:clock_source_control
		case 0x00000050://0x00000048:frame_number
		case 0x00000051://0x0000004C:current_mode
		default:
			#ifdef DEBUG_ON
				fprintf(fp," Command not allowed yet ( %hhu )\n", ucADDRReg);
			#endif
			break;
		}
}

void vQCmdFeeRMAPinFullPattern( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U error_codel;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;

	uiCmdFEEL.ulWord = cmd;

	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);


	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
		case 0x041://0x00000004:ccd_seq_2_config
		case 0x042://0x00000008:spw_packet_1_config
		case 0x043://0x0000000C:spw_packet_2_config
		case 0x44://0x00000010:CCD_1_windowing_1_config
		case 0x45://0x00000014:CCD_1_windowing_2_config
		case 0x46://0x00000018:CCD_2_windowing_1_config
		case 0x47://0x0000001C:CCD_2_windowing_2_config
		case 0x48://0x00000020:CCD_3_windowing_1_config
		case 0x49://0x00000024:CCD_3_windowing_2_config
		case 0x4A://0x00000028:CCD_4_windowing_1_config
		case 0x4B://0x0000002C:CCD_4_windowing_2_config
			#ifdef DEBUG_ON
				fprintf(fp," Command not allowed yet ( %hhu )\n", ucValueMasked);
			#endif
				break;

		case 0x0000004C://0x00000038:operation_mode_config
			/* Mode Selection */
			ucValueMasked = (COMM_RMAP_MODE_SEL_CTRL_MSK & ucValueReg) >>4;

			switch (ucValueMasked) {
				case 0: /* Standby */
				#ifdef DEBUG_ON
					fprintf(fp,"- to Stand-By\n");
				#endif

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eMode = sFeeTestFullPattern;
					pxNFeeP->xControl.eNextMode = sToFeeStandBy; /* To finish the actual transfer only when sync comes */

					break;
				case 2: /* PAttern Full image */
					#ifdef DEBUG_ON
						fprintf(fp,"NFEE %hhu Task:  Already in Full Image Pattern mode\n", pxNFeeP->ucId);
					#endif

					break;
				case 6:
				#ifdef DEBUG_ON
					fprintf(fp," Off-Mode not allowed.\n");
				#endif
					break;
				case 1:
				case 3:
				case 4:
				case 5:
				default:
					#ifdef DEBUG_ON
						fprintf(fp," mode not allowed yet ( %hhu )\n", ucValueMasked);
					#endif
					break;
			}

			break;
		case 0x0000004D://0x0000003C:sync_config

			ucValueMasked = (COMM_RMAP_SELF_TRIGGER_CTRL_MSK & ucValueReg) >> 2; /* Number of rows */

			if ( ucValueMasked ) {

				if ( pxNFeeP->xControl.eNextMode == sToFeeStandBy ) {
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					#ifdef DEBUG_ON
						fprintf(fp," - Mode Forced.\n");
					#endif
				}

				/* Clear the trigger */
//				bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
//				pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig & 0xFFFFFFFB);
//				bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);

			}

			break;
		case 0x0000004E://0x00000040:dac_control
		case 0x0000004F://0x00000044:clock_source_control
		case 0x00000050://0x00000048:frame_number
		case 0x00000051://0x0000004C:current_mode
		default:
			#ifdef DEBUG_ON
				fprintf(fp," Command not allowed yet ( %hhu )\n", ucADDRReg);
			#endif
			break;
		}
}


void vQCmdFeeRMAPWaitingSync( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U error_codel;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;

	#ifdef DEBUG_ON
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	#endif

	uiCmdFEEL.ulWord = cmd;

	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);


	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
		case 0x041://0x00000004:ccd_seq_2_config
		case 0x042://0x00000008:spw_packet_1_config
		case 0x043://0x0000000C:spw_packet_2_config
		case 0x44://0x00000010:CCD_1_windowing_1_config
		case 0x45://0x00000014:CCD_1_windowing_2_config
		case 0x46://0x00000018:CCD_2_windowing_1_config
		case 0x47://0x0000001C:CCD_2_windowing_2_config
		case 0x48://0x00000020:CCD_3_windowing_1_config
		case 0x49://0x00000024:CCD_3_windowing_2_config
		case 0x4A://0x00000028:CCD_4_windowing_1_config
		case 0x4B://0x0000002C:CCD_4_windowing_2_config
		case 0x0000004C://0x00000038:operation_mode_config
		#ifdef DEBUG_ON
			fprintf(fp,"- a mode was already selected by DPU, waiting for sync.\n", pxNFeeP->ucId);
		#endif
			break;
		case 0x0000004D://0x0000003C:sync_config

			ucValueMasked = (COMM_RMAP_SELF_TRIGGER_CTRL_MSK & ucValueReg) >> 2; /* Number of rows */

			if ( ucValueMasked ) {

				if ( pxNFeeP->xControl.eNextMode == sToFeeStandBy ) {
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					#ifdef DEBUG_ON
						fprintf(fp," - Mode Forced.\n");
					#endif
				}

				/* Clear the trigger */
				bRmapGetMemConfigArea(&pxNFeeP->xChannel.xRmap);
				pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig = ( pxNFeeP->xChannel.xRmap.xRmapMemConfigArea.uliSyncConfig & 0xFFFFFFFB);
				bRmapSetMemConfigArea(&pxNFeeP->xChannel.xRmap);
			}

			break;
		case 0x0000004E://0x00000040:dac_control
		case 0x0000004F://0x00000044:clock_source_control
		case 0x00000050://0x00000048:frame_number
		case 0x00000051://0x0000004C:current_mode
		default:
			#ifdef DEBUG_ON
				fprintf(fp," Command not allowed yet ( %hhu )\n", ucADDRReg);
			#endif
			break;
		}
}


bool bDisableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {
	/* Disable RMAP channel */
	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteCmdEn = FALSE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {
	/* Enable RMAP */
	/* Before Enable the IRQ for Rmap, make a copy for compare when some command arrive */
	//bRmapGetMemConfigArea(&xRmap[ucId]);

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
	bFeebGetWindowing(pxFeebCh);
	pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
	bFeebSetWindowing(pxFeebCh);

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
