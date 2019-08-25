/*
 * fee_taskV2.c
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */


#include "fee_taskV2.h"


typedef struct FEETransmission{
	bool bFirstT;
	bool bDmaReturn[2];				/*Two half CCDs-> Left and Right*/
	bool bFinal[2];				/*Two half CCDs-> Left and Right*/
	unsigned long ulAddrIni;		/* (byte) Initial transmission data, calculated after */
	unsigned long ulAddrFinal;
	unsigned long ulTotalBlocks;
	unsigned long ulSMD_MAX_BLOCKS;
	tNFeeSide side;
	unsigned char ucMemory;
	unsigned char ucCcdNumber;
	TCcdMemMap *xCcdMapLocal[2]; 	/*Two half CCDs-> Left and Right*/
} TFEETransmission;


void vFeeTaskV2(void *task_data) {
	TNFee *pxNFee;
	INT8U error_code;
	tQMask uiCmdFEE;
	TFEETransmission xTrans;
	unsigned char ucEL = 0, ucSideFromMSG = 0;
	unsigned short int usiLenLastBlocks = 0;


	/* Fee Instance Data Structure */
	pxNFee = ( TNFee * ) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
		fprintf(fp,"NFEE %hhu Task. (Task on)\n", pxNFee->ucId);
	}
	#endif

	for(;;){

		switch (pxNFee->xControl.eState) {
			case sInit:

				/* Flush the queue */
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/*Initializing the HW DataPacket*/
				vInitialConfig_DpktPacket( pxNFee );

				/*Initializing the the values of the HK memory area, only during dev*/
				vInitialConfig_RmapMemHKArea( pxNFee );

				/* Change the configuration of RMAP for a particular FEE*/
				vInitialConfig_RMAPCodecConfig( pxNFee );

				pxNFee->xControl.eState = sConfig_Enter;
				break;
			case sConfig_Enter:/* Transition */

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x06; /*Off*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable the link SPW */
				bDisableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = FALSE;
				bSetPainelLeds( LEDS_OFF , uliReturnMaskG( pxNFee->ucSPWId ) );
				bSetPainelLeds( LEDS_ON , uliReturnMaskR( pxNFee->ucSPWId ) );

				/* Disable RMAP interrupts */
				bDisableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucSPWId);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Config Mode\n", pxNFee->ucId);
				}
				#endif


				/* End of simulation! Clear everything that is possible */
				pxNFee->xControl.bWatingSync = FALSE;
				pxNFee->xControl.bSimulating = FALSE;
				pxNFee->xControl.bUsingDMA = FALSE;

				/*Clear all control variables that control the data in the RAM for this FEE*/
				vResetMemCCDFEE(pxNFee);

				/*Clear the queue message for this FEE*/
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sInit;
				pxNFee->xControl.eMode = sConfig;
				pxNFee->xControl.eNextMode = sConfig;
				/* Real State */
				pxNFee->xControl.eState = sConfig;
				break;

			case sConfig:

				/*Wait for message in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinConfig( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;


			case sOn_Enter:

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x00; /*On mode*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Enable RMAP interrupts */
				bEnableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucId);

				/* Enable the link SPW */
				bEnableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = TRUE;
				bSetPainelLeds( LEDS_OFF , uliReturnMaskR( pxNFee->ucSPWId ) );
				bSetPainelLeds( LEDS_ON , uliReturnMaskG( pxNFee->ucSPWId ) );

				/*Enabling some important variables*/
				pxNFee->xControl.bSimulating = TRUE;

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: On Mode\n", pxNFee->ucId);
				}
				#endif

				pxNFee->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = pxNFee->xControl.eMode;
				pxNFee->xControl.eMode = sOn;
				pxNFee->xControl.eNextMode = sOn;
				/* Real State */
				pxNFee->xControl.eState = sOn;
				break;

			case sOn:
				/*Wait for commands in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinOn( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;


			case sStandby_Enter:

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x04; /*sFeeStandBy*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Disable RMAP interrupts */
				bEnableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucId);

				/* Enable the link SPW */
				bEnableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = TRUE;
				bSetPainelLeds( LEDS_OFF , uliReturnMaskR( pxNFee->ucSPWId ) );
				bSetPainelLeds( LEDS_ON , uliReturnMaskG( pxNFee->ucSPWId ) );


				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Standby\n", pxNFee->ucId);
				}
				#endif

				/* Reset the memory control variables thats is used in the transmission*/
				vResetMemCCDFEE(pxNFee);

				pxNFee->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = pxNFee->xControl.eMode;
				pxNFee->xControl.eMode = sStandBy;
				pxNFee->xControl.eNextMode = sStandBy;
				pxNFee->xControl.eState = sStandBy;
				break;


			case sStandBy:
				/*Wait for commands in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinStandBy( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;

			case sWaitSync:
				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: (sFeeWaitingSync)\n", pxNFee->ucId);
				}
				#endif

				/* Wait for sync, or any other command*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code != OS_ERR_NONE ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ (sFeeWaitingSync)\n", pxNFee->ucId);
					}
					#endif
				} else {
					vQCmdFEEinWaitingSync( pxNFee, uiCmdFEE.ulWord  );
				}
				break;

			case sFullPattern_Enter:

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x01; /*Full Image Pattern Mode*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to FullImage Pattern after Sync.\n", pxNFee->ucId);
				}
				#endif

				vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sOn_Enter;
				pxNFee->xControl.eMode = sFullPattern;
				pxNFee->xControl.eNextMode = sFullPattern_Out;
				/* Real State */
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;


			case sFullPattern:
				// Vamos verificar se isso é necessario
				break;


			case sFullPattern_Out:
				// Vamos verificar se isso é necessario
				break;

			case redoutCycle_Enter:

				/* Indicates that this FEE will now need to use DMA*/
				pxNFee->xControl.bUsingDMA = TRUE;

				/* For now is fixed by this define, but at any moment it could change*/
				xTrans.ulSMD_MAX_BLOCKS = SDMA_MAX_BLOCKS;

				if ( xGlobal.bPreMaster == TRUE ) {
					/* Check any parameter or restriction that may have to transmit the data */
					pxNFee->xControl.eState = redoutCheckRestr;
				} else {
					/* Check any parameter or restriction that may have to transmit the data */
					pxNFee->xControl.eState = redoutConfigureTrans;
				}
				break;


			case redoutCheckRestr:


				if ( xGlobal.bPreMaster == TRUE ) {
					/*Need to verify if the Data Controller already update all memory*/
					if ( xGlobal.bDTCFinished == FALSE ) {

						/*Wait for commands in the Queue, expected to receive the message informing that DTC finished the memory update*/
						uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
						if ( error_code == OS_ERR_NONE ) {
							vQCmdFEEinWaitingMemUpdate( pxNFee, uiCmdFEE.ulWord );
						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
							}
							#endif
						}
						break;

					} else {
						pxNFee->xControl.eState = redoutConfigureTrans;

						/*The Meb My have sent a message to inform the finish of the update of the image*/
						error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
						if ( error_code != OS_NO_ERR ) {
							vFailFlushNFEEQueue();
						}
					}
				} else pxNFee->xControl.eState = redoutConfigureTrans;

				/* Wait until both buffers are empty  */
				vWaitUntilBufferEmpty( pxNFee->ucSPWId );
				/* Guard time that HW MAYBE need, this will be used during the development, will be removed in some future version*/
				OSTimeDlyHMSM(0, 0, 0, xDefaults.usiGuardNFEEDelay);

				break;


			case redoutConfigureTrans:

				/* Reset the memory control variables thats is used in the transmission*/
				vResetMemCCDFEE( pxNFee );

				//todo: Pegar com o França qual como ler esse registrador
				xTrans.side = sLeft;

				/*For now is HardCoded, for a complete half CCD*/
				xTrans.ulAddrIni = 0;
				xTrans.ulAddrFinal = pxNFee->xMemMap.xCommon.usiTotalBytes;
				xTrans.ulTotalBlocks = pxNFee->xMemMap.xCommon.usiNTotalBlocks;

				/* (re)Configuring the size of the double buffer to the HW DataPacket*/
				vSetDoubleBufferLeftSize( xTrans.ulSMD_MAX_BLOCKS, pxNFee->ucSPWId );
				vSetDoubleBufferRightSize( xTrans.ulSMD_MAX_BLOCKS, pxNFee->ucSPWId );

				/* Enable IRQ and clear the Double Buffer */
				bEnableDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Check which CCD should be send due to the configured readout order*/
				ucEL = (xGlobal.ucEP0_3 + 1) % 4;
				xTrans.ucCcdNumber = pxNFee->xControl.ucROutOrder[ ucEL ];

				/* Get the memory map values for this next readout*/
				xTrans.xCcdMapLocal[sLeft] = &pxNFee->xMemMap.xCcd[ xTrans.ucCcdNumber ].xLeft;
				xTrans.xCcdMapLocal[sRight] = &pxNFee->xMemMap.xCcd[ xTrans.ucCcdNumber ].xRight;

				/* Check if need to change the memory */
				if ( ucEL == 0 )
					xTrans.ucMemory = (unsigned char) (( *pxNFee->xControl.pActualMem + 1 ) % 2) ; /* Select the other memory*/
				else
					xTrans.ucMemory = (unsigned char) ( *pxNFee->xControl.pActualMem );



				/* Update DataPacket with the information of actual readout information*/
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = xTrans.ucCcdNumber;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePattern; //todo: Verificar com o França
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);


				xTrans.bDmaReturn[0] = TRUE;
				xTrans.bDmaReturn[1] = TRUE;

				if ( xTrans.side == sBoth ) {
					/* Make a requests for the Double buffer */
					bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 0, pxNFee->ucId); /*Request for the Left side*/
					bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, 1, pxNFee->ucId); /*Request for the Right side*/
					xTrans.bDmaReturn[0] = FALSE;
					xTrans.bDmaReturn[1] = FALSE;
				} else {
					bSendRequestNFeeCtrl( M_NFC_DMA_REQUEST, xTrans.side, pxNFee->ucId); /*Request for the Left or Right side*/
					xTrans.bDmaReturn[ xTrans.side ] = FALSE;
				}

				/*Will indicate the finish of transmission, just getting initial value from the DMA return, because it carries in this stage if is one side or both sides*/
				xTrans.bFinal[0] = xTrans.bDmaReturn[0];
				xTrans.bFinal[1] = xTrans.bDmaReturn[1];

				pxNFee->xControl.eState = redoutPreLoadBuffer;
				break;


			case redoutPreLoadBuffer:

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* First Check if is access to the DMA (priority) */
					if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {

						ucSideFromMSG = uiCmdFEE.ucByte[1];

						/* Try to get the Mutex */
						OSMutexPend(xDma[ xTrans.ucMemory ].xMutexDMA, 0, &error_code); /* Blocking way */
						if ( error_code == OS_ERR_NONE ) {

							/* Schedule the DMA to fill the double buffer for this FEE*/
							xTrans.bDmaReturn[ ucSideFromMSG ] = bPrepareDoubleBuffer( xTrans.xCcdMapLocal[ucSideFromMSG], xTrans.ucMemory, pxNFee->ucId, pxNFee, ucSideFromMSG );
							OSMutexPost(xDma[xTrans.ucMemory].xMutexDMA);
						}
						/* Send message telling to controller that is not using the DMA any more */
						bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, ucSideFromMSG, pxNFee->ucId);

						if ( (xTrans.bDmaReturn[0] == TRUE) && (xTrans.bDmaReturn[1] == TRUE) ) {

							pxNFee->xControl.eState = redoutWaitSync;
							pxNFee->xControl.eNextMode = redoutTransmission;


							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
								fprintf(fp,"\nNFEE-%hu Task: Double buffer prepared\n", pxNFee->ucId);
							}
							#endif
						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
								fprintf(fp,"\nNFEE-%hu Task: Could not prepare the double buffer\n", pxNFee->ucId);
							}
							#endif
						}
					} else {
						/* Is not access to DMA, so we need to check what is this received command */
						vQCmdFEEinNEED_CHANGE( pxNFee, uiCmdFEE.ulWord );//todo: fazer um leitor
					}
				} else {
					/* Error while trying to read from the Queue*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}

				break;


			case redoutTransmission:

				/* Wait for command for this FEE (DMA access or any other message)*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* First Check if is access to the DMA (priority) */
					if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {

						ucSideFromMSG = uiCmdFEE.ucByte[1];

						/* Try to get the Mutex */
						OSMutexPend(xDma[xTrans.ucMemory].xMutexDMA, 0, &error_code); /* Blocking way */
						if ( error_code == OS_ERR_NONE ) {

							/* Is this the last block? */

							if ( (xTrans.xCcdMapLocal[ucSideFromMSG]->ulBlockI + xTrans.ulSMD_MAX_BLOCKS) >= xTrans.ulTotalBlocks ) {

								/* Define the size of the data in the double buffer (need this to create the interrupt right)*/
								usiLenLastBlocks = xTrans.ulTotalBlocks - xTrans.xCcdMapLocal[ucSideFromMSG]->ulBlockI;

								/* The last packet don't fill all the buffer, we need to tell what is the size, in order to the HW set the new threshold for the IRQ*/
								if ( ucSideFromMSG == 0 ) /*Left*/
									vSetDoubleBufferLeftSize( (unsigned char)usiLenLastBlocks, pxNFee->ucSPWId );
								else
									vSetDoubleBufferRightSize( (unsigned char)usiLenLastBlocks, pxNFee->ucSPWId );

								/* Indicates that is the last packet*/
								xTrans.bFinal[ucSideFromMSG] = TRUE;
							} else {
								/* Full size*/
								usiLenLastBlocks = xTrans.ulSMD_MAX_BLOCKS;
							}

							/* Check which memory is using in this readout, this will be change in later versions */
							if ( xTrans.ucMemory == 0 )
								xTrans.bDmaReturn[ucSideFromMSG] = bSdmaDmaM1Transfer((alt_u32 *)xTrans.xCcdMapLocal[ucSideFromMSG]->ulAddrI, (alt_u16)usiLenLastBlocks, ucSideFromMSG, pxNFee->ucSPWId);
							else
								xTrans.bDmaReturn[ucSideFromMSG] = bSdmaDmaM2Transfer((alt_u32 *)xTrans.xCcdMapLocal[ucSideFromMSG]->ulAddrI, (alt_u16)usiLenLastBlocks, ucSideFromMSG, pxNFee->ucSPWId);

							/* Giving the mutex back*/
							OSMutexPost(xDma[xTrans.ucMemory].xMutexDMA);

							/* Check if was possible to schedule the transfer in the DMA*/
							if ( xTrans.bDmaReturn[ucSideFromMSG] == TRUE ) {
								/* Value of xCcdMapLocal->ulAddrI already set in the last iteration */
								xTrans.xCcdMapLocal[ucSideFromMSG]->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*usiLenLastBlocks; //todo: Provavelmente precisara mudar SDMA_PIXEL_BLOCK_SIZE_BYTES
								xTrans.xCcdMapLocal[ucSideFromMSG]->ulBlockI += usiLenLastBlocks;
							} else {
								xTrans.bFinal[ucSideFromMSG] = FALSE;
								/* Send the request for use the DMA, but to front of the QUEUE. Because will not have any other IRQ to set it for us */
								bSendRequestNFeeCtrl_Front( M_NFC_DMA_REQUEST, ucSideFromMSG, pxNFee->ucId);
							}

							/* Send message telling to controller that is not using the DMA any more */
							bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, ucSideFromMSG, pxNFee->ucId);

							/* Last Packet scheduled?*/
							if ( (xTrans.bFinal[0] == TRUE) && (xTrans.bFinal[1] == TRUE) ) {
								/* Changing the FEE state */
								pxNFee->xControl.eState = redoutEndSch;
							}
						}
					} else {
						//todo: TIAGO TIAGO CONTINUAR AQUI CONTINUAR AQUI
						/* Is not an access DMA command, check what is?*/
						vQCmdFEEinFullPatternNEEDCHANGE( pxNFee, uiCmdFEE.ulWord );//todo: é preciso avaliar!!!!!!!!!!!!!

						/* Check if need to wait for the Sync */
						if ( pxNFee->xControl.bWatingSync == FALSE ) {
							pxNFee->xControl.eMode = pxNFee->xControl.eNextMode;
						}
					}

				} else {
					/* Queue error*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;

			case redoutEndSch:
				//todo: acho que nao precisa, verificar
				xTrans.bFinal[0] = FALSE;
				xTrans.bFinal[1] = FALSE;
				break;


			case redoutCycle_Out:
				pxNFee->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);

				/* Real State */
				pxNFee->xControl.eState = pxNFee->xControl.eLastMode;
				break;


			case redoutWaitSync:


				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: (redoutWaitSync)\n", pxNFee->ucId);
				}
				#endif

				/* Wait for sync, or any other command*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code != OS_ERR_NONE ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ (redoutWaitSync)\n", pxNFee->ucId);
					}
					#endif
				} else {
					vQCmdFEEinReadoutSync( pxNFee, uiCmdFEE.ulWord  );
				}


				//todo: o valor do uliCurrentMode, vai para qual registrador? ccd_mode_config? lá nao apenas indica para onde deve ir o FEE?
				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				/*ccd_mode_config[3:0]*/
				/*Trying to save some processing*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				switch ( pxNFee->xControl.eMode ) {
					case sFullPattern: /*0x1*/
						if (pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode != 0x1) {
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x1;
							bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
						}
						break;
					case sWinPattern:/*0x2*/
						if (pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode != 0x2) {
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x2;
							bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
						}
						break;
					case sFullImage:/*0x6*/
						if (pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode != 0x6) {
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x6;
							bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
						}
						break;
					case sWindowing:/*0x5*/
						if (pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode != 0x5) {
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x5;
							bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
						}
						break;
					case sParTrap1:/*0x9*/
						if (pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode != 0x9) {
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x9;
							bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
						}
						break;
					case sParTrap2:/*0xA*/
						if (pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode != 0xA) {
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0xA;
							bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
						}
						break;
					case sSerialTrap1:/*0xB*/
						if (pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode != 0xB) {
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0xB;
							bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
						}
						break;
					case sSerialTrap2:/*0xC*/
						if (pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode != 0xC) {
							pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0xC;
							bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
						}
						break;
					default:
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"NFEE-%hu Task: Unexpected eMode (redoutWaitSync)\n", pxNFee->ucId);
						}
						#endif
						break;
				}
				break;

			default:
				pxNFee->xControl.eState = sConfig_Enter;
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"\nNFEE %hhu Task: Unexpected mode (default)\n", pxNFee->ucId);
				#endif
				break;
		}

	}
}

/* Threat income command while the Fee is waiting for sync*/
void vQCmdFEEinReadoutSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eMode = sConfig;
				/* Real State */
				pxNFeeP->xControl.eState = sConfig_Enter;
				break;
			case M_FEE_ON:
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					/* If a transition to On was requested when the FEE is waiting to go to Calibration,
					 * configure the hardware to not send any data in the next sync */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					pxNFeeP->xControl.eState = redoutWaitSync;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
					}
					#endif
				}
				break;
			case M_FEE_ON_FORCED:

				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eState = sOn_Enter;

				break;

			case M_FEE_STANDBY_FORCED:
				break;

			case M_FEE_STANDBY:
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"\nNFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPNEED_CHANGE( pxNFeeP, cmd ); // todo: Precisa criar fluxo para RMAP
				break;
			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				/* Warning */
					pxNFeeP->xControl.eState = pxNFeeP->xControl.eNextMode;
				break;

			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}


/* Threat income command while the Fee is waiting for sync*/
void vQCmdFEEinWaitingSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eMode = sConfig;
				/* Real State */
				pxNFeeP->xControl.eState = sConfig_Enter;
				break;
			case M_FEE_STANDBY_FORCED:
			case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* If a transition to Standby was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */


				/*
				if ( sToTestFullPattern == pxNFeeP->xControl.eNextMode ) {

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				}

				pxNFeeP->xControl.eMode = sFeeWaitingSync;
				pxNFeeP->xControl.eNextMode = sToFeeStandBy;
				*/
				break;
			case M_FEE_FULL_PATTERN:
			case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */

				/*
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eMode = sNextPatternIteration;
				pxNFeeP->xControl.eNextMode = sFeeWaitingSync;*/
				break;
			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"\nNFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPWaitingSync( pxNFeeP, cmd );
				break;
			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				/* Warning */
					pxNFeeP->xControl.bWatingSync = FALSE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					/* Real State */
					pxNFeeP->xControl.eState = pxNFeeP->xControl.eNextMode;
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in Config mode)\n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}



/* Threat income command while the Fee is in On mode*/
void vQCmdFEEinOn( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eNextMode = sConfig;
				/* Real State */
				pxNFeeP->xControl.eState = sConfig_Enter;
				break;
			case M_FEE_STANDBY_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sStandBy;
				/* Real State */
				pxNFeeP->xControl.eState = sStandby_Enter;
				break;
			case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn;
				pxNFeeP->xControl.eMode = sStandby_Enter;
				pxNFeeP->xControl.eNextMode = sStandBy;
				/* Real State */
				pxNFeeP->xControl.eState = sWaitSync;
				break;
			case M_FEE_FULL_PATTERN:
			case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */

				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sFullPattern;
				/* Real State */
				pxNFeeP->xControl.eState = sFullPattern_Enter;
				break;
			case M_FEE_WIN_PATTERN:
			case M_FEE_WIN_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sWinPattern;
				/* Real State */
				pxNFeeP->xControl.eState = sWinPattern_Enter;
				break;
			case M_FEE_RMAP:
				vQCmdFeeRMAPinStandBy( pxNFeeP, cmd );

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */

				break;
			case M_SYNC:
			case M_MASTER_SYNC:
				/* Warning */
				/*
				if ( pxNFeeP->xControl.eMode == sFeeWaitingSync ) {
					pxNFeeP->xControl.eMode = pxNFeeP->xControl.eNextMode;
					pxNFeeP->xControl.bWatingSync = FALSE;
				}
				*/
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed in this mode (ON, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
				}
				#endif
				break;
				break;
		}
	}
}


/* Threat income command while the Fee is in Config. mode*/
void vQCmdFEEinConfig( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {

			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sOn_Enter;
				break;
			case M_FEE_ON:
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.eMode = sWaitSync;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sWaitSync;
				break;
			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: Can't threat RMAP Messages in this mode (Config)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_SYNC:
			case M_MASTER_SYNC:
				/* Do nothing for now */
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed in this mode (Config, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
				}
				#endif
				break;
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			fprintf(fp,"NFEE %hhu Task:  Wrong FEE id (Config)\n", pxNFeeP->ucId);
		}
		#endif
		break;
	}
}

/* Threat income command while the Fee is in Config. mode*/
void vQCmdFEEinWaitingMemUpdate( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {

			case M_FEE_CAN_ACCESS_NEXT_MEM:
				pxNFeeP->xControl.eState = redoutConfigureTrans;
				break;
			case M_FEE_ON_FORCED:
				//todo: precisa ser possivel voltar para o mode on
				break;
			case M_FEE_ON:
				//todo: precisa ser possivel voltar para o mode on
				break;
			case M_FEE_RMAP:
				//todo: Isso precisa ser tratado para quando for necessario voltar para ON no modo forced, só pra isso
				break;
			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: Fee stuck waiting for DTC. CRITICAL, check this condition (Readout Cycle)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed in this mode (Readout Cycle, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
				}
				#endif
				break;
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			fprintf(fp,"NFEE %hhu Task:  Wrong FEE id (Config)\n", pxNFeeP->ucId);
		}
		#endif
		break;
	}
}



/* Change the configuration of RMAP for a particular FEE*/
void vInitialConfig_RMAPCodecConfig( TNFee *pxNFeeP ) {

	bRmapGetCodecConfig( &pxNFeeP->xChannel.xRmap );
	pxNFeeP->xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char) xDefaults.ucRmapKey ;
	pxNFeeP->xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char) xDefaults.ucLogicalAddr;
	bRmapSetCodecConfig( &pxNFeeP->xChannel.xRmap );

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"NFEE %hhu Task. RMAP KEY = %hu\n", pxNFeeP->ucId ,xDefaults.ucRmapKey );
		fprintf(fp,"NFEE %hhu Task. Log. Addr. = %hu \n", pxNFeeP->ucId, xDefaults.ucLogicalAddr);
	}
	#endif

}

/* Initializing the HW DataPacket*/
void vInitialConfig_DpktPacket( TNFee *pxNFeeP ) {

	bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdXSize = pxNFeeP->xCcdInfo.usiHalfWidth + pxNFeeP->xCcdInfo.usiSPrescanN + pxNFeeP->xCcdInfo.usiSOverscanN;
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdYSize = pxNFeeP->xCcdInfo.usiHeight + pxNFeeP->xCcdInfo.usiOLN;
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiDataYSize = pxNFeeP->xCcdInfo.usiHeight;
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiOverscanYSize = pxNFeeP->xCcdInfo.usiOLN;
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = xDefaults.usiSpwPLength;
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = pxNFeeP->xControl.ucROutOrder[0];
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy;
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucProtocolId = xDefaults.usiDataProtId; /* 0xF0 ou  0x02*/
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xDefaults.usiDpuLogicalAddr;
	bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
}

/* Initializing the the values of the HK memory area, only during dev*/
void vInitialConfig_RmapMemHKArea( TNFee *pxNFeeP ) {

	bRmapGetRmapMemHKArea(&pxNFeeP->xChannel.xRmap);
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1VodE = 0xFF00;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1VodF = 0xFF01;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1VrdMon = 0xFF02;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd2VodE = 0xFF03;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd2VodF = 0xFF04;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd2VrdMon = 0xFF05;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd3VodE = 0xFF06;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd3VodF = 0xFF07;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd3VrdMon = 0xFF08;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd4VodE  = 0xFF09;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd4VodF = 0xFF0A;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd4VrdMon = 0xFF0B;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVccd = 0xFF0C;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVrclk = 0xFF0D;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkViclk = 0xFF0E;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVrclkLow = 0xFF0F;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHk5vbPos = 0xFF10;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHk5vbNeg = 0xFF11;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHk33vbPos = 0xFF12;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHk25vaPos = 0xFF13;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHk33vdPos = 0xFF14;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHk25vdPos = 0xFF15;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHk15vdPos = 0xFF16;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHk5vref = 0xFF17;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVccdPosRaw = 0xFF18;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVclkPosRaw = 0xFF19;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVan1PosRaw = 0xFF1A;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVan3NegRaw = 0xFF1B;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVan2PosRaw = 0xFF1C;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVdigFpgaRaw = 0xFF1D;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkVdigSpwRaw = 0xFF1E;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkViclkLow = 0xFF1F;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkAdcTempAE = 0xFF20;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkAdcTempAF = 0xFF21;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd1Temp = 0xFF22;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd2Temp = 0xFF23;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd3Temp = 0xFF24;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkCcd4Temp = 0xFF25;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiHkWp605Spare = 0xFF26;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA0 = 0xFF27;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA1 = 0xFF28;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA2 = 0xFF29;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA3 = 0xFF2A;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA4 = 0xFF2B;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA5 = 0xFF2C;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA6 = 0xFF2D;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA7 = 0xFF2E;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA8 = 0xFF2F;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA9 = 0xFF30;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA10 = 0xFF31;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA11 = 0xFF32;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA12 = 0xFF33;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA13 = 0xFF34;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA14 = 0xFF35;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiLowresPrtA15 = 0xFF36;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt0 = 0xFF37;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt1 = 0xFF38;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt2 = 0xFF39;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt3 = 0xFF3A;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt4 = 0xFF3B;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt5 = 0xFF3C;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt6 = 0xFF3D;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiSelHiresPrt7 = 0xFF3E;
	pxNFeeP->xChannel.xRmap.xRmapMemHKArea.usiZeroHiresAmp = 0xFF3F;
	bRmapSetRmapMemHKArea(&pxNFeeP->xChannel.xRmap);
}

void vSendMessageNUCModeFeeChange( unsigned char usIdFee, tFEEStates mode  ) {

	/* Should send message to the NUc to inform the FEE mode */

}
