/*
 * fee_taskV2.c
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */


#include "fee_taskV2.h"



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
				if ( error_code != OS_NO_ERR )
					vFailFlushNFEEQueue();

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
				pxNFee->xChannel.xRmap.xRmapMemConfigArea.uliCurrentMode = 0x00; /*Off*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

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

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
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

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

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
				pxNFee->xControl.bUsingDMA = FALSE;

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

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
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

				pxNFee->xControl.bUsingDMA = FALSE;

				pxNFee->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = pxNFee->xControl.eMode;
				pxNFee->xControl.eMode = sStandBy;
				pxNFee->xControl.eNextMode = sStandBy;

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
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
				/* Real State */

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sWinPattern_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Windowing Pattern after Sync.\n", pxNFee->ucId);
				}
				#endif

				vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sOn_Enter;
				pxNFee->xControl.eMode = sWinPattern;
				/* Real State */
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sFullImage_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to FullImage after Sync.\n", pxNFee->ucId);
				}
				#endif

				vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sFullImage;
				/* Real State */

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sWindowing_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Windowing after Sync.\n", pxNFee->ucId);
				}
				#endif

				vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sWindowing;
				/* Real State */

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sParTrap1_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Parallel Trap 1 after Sync.\n", pxNFee->ucId);
				}
				#endif

				vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sParTrap1;
				/* Real State */

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sParTrap2_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Parallel Trap 2 after Sync.\n", pxNFee->ucId);
				}
				#endif

				vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sParTrap2;
				/* Real State */

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sSerialTrap1_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Serial Trap 1 after Sync.\n", pxNFee->ucId);
				}
				#endif

				vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sSerialTrap1;
				/* Real State */

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sSerialTrap2_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Serial Trap 2 after Sync.\n", pxNFee->ucId);
				}
				#endif

				vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sSerialTrap2;
				/* Real State */

				vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;




/*============================== Readout Cycle Implementation ========================*/



			case redoutCycle_Enter:

				/* Indicates that this FEE will now need to use DMA*/
				pxNFee->xControl.bUsingDMA = TRUE;
				xTrans.bFirstT = TRUE;

				if (xGlobal.bJustBeforSync == FALSE)
					pxNFee->xControl.eState = redoutWaitBeforeSyncSignal;
				else
					pxNFee->xControl.eState = redoutCheckDTCUpdate;

				break;

			case redoutWaitBeforeSyncSignal:

				/*Will wait for the Before sync signal, probably in this state it will need to treat many RMAP commands*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdWaitBeforeSyncSignal( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;



			case redoutCheckDTCUpdate:

				/*Check if is needed wait the update of the memory, need only in the last readout cycle */
				if ( xGlobal.bPreMaster == FALSE ) {
					pxNFee->xControl.eState = redoutCheckRestr;
				} else {
					if ( xGlobal.bDTCFinished == TRUE ) {
						/*If DTC already updated the memory then can go*/
						pxNFee->xControl.eState = redoutCheckRestr;
					} else {
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
					}
				}
				break;

			case redoutCheckRestr:

				/*The Meb My have sent a message to inform the finish of the update of the image*/
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/* Wait until both buffers are empty  */
				vWaitUntilBufferEmpty( pxNFee->ucSPWId );
				/* Guard time that HW MAYBE need, this will be used during the development, will be removed in some future version*/
				OSTimeDlyHMSM(0, 0, 0, xDefaults.usiGuardNFEEDelay);

				pxNFee->xControl.eState = redoutConfigureTrans;

				break;


			case redoutConfigureTrans:

				/* Reset the memory control variables thats is used in the transmission*/
				vResetMemCCDFEE( pxNFee );

				//todo: Pegar com o Fran�a qual como ler esse registrador
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				//if pxNFee->xChannel.xRmap.xRmapMemConfigArea.sync_sel ; //todo: aqui ser� preciso alterar o mapa do RMAP (sensor_sel)
				xTrans.side = sLeft; //todo: Hardcoded por enquanto

				/* Check which CCD should be send due to the configured readout order*/
				ucEL = (xGlobal.ucEP0_3 + 1) % 4;
				xTrans.ucCcdNumber = pxNFee->xControl.ucROutOrder[ ucEL ];

				/* Get the memory map values for this next readout*/
				xTrans.xCcdMapLocal[0] = &pxNFee->xMemMap.xCcd[ xTrans.ucCcdNumber ].xLeft;
				xTrans.xCcdMapLocal[1] = &pxNFee->xMemMap.xCcd[ xTrans.ucCcdNumber ].xRight;

				/* Check if need to change the memory */
				if ( ucEL == 0 )
					xTrans.ucMemory = (unsigned char) (( *pxNFee->xControl.pActualMem + 1 ) % 2) ; /* Select the other memory*/
				else
					xTrans.ucMemory = (unsigned char) ( *pxNFee->xControl.pActualMem );

				/*For now is HardCoded, for a complete half CCD*/
				xTrans.ulAddrIni = 0; /*This will be the offset*/
				xTrans.ulAddrFinal = pxNFee->xMemMap.xCommon.usiTotalBytes;
				xTrans.ulTotalBlocks = pxNFee->xMemMap.xCommon.usiNTotalBlocks;
				/* For now is fixed by this define, but at any moment it could change*/
				xTrans.ulSMD_MAX_BLOCKS = SDMA_MAX_BLOCKS;

				/* (re)Configuring the size of the double buffer to the HW DataPacket*/
				vSetDoubleBufferLeftSize( xTrans.ulSMD_MAX_BLOCKS, pxNFee->ucSPWId );
				vSetDoubleBufferRightSize( xTrans.ulSMD_MAX_BLOCKS, pxNFee->ucSPWId );

				/* Enable IRQ and clear the Double Buffer */
				bEnableDbBuffer(&pxNFee->xChannel.xFeeBuffer);


				/* Update DataPacket with the information of actual readout information*/
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = xTrans.ucCcdNumber;
				switch (pxNFee->xControl.eMode) {
					case sFullPattern:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePattern;
						break;
					case sWinPattern:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowingPattern;
						break;
					case sFullImage:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImage;
						break;
					case sWindowing:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowing;
						break;
					case sParTrap1:
					case sParTrap2:
					case sSerialTrap1:
					case sSerialTrap2:
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage )
							fprintf(fp,"\nNFEE-%hu Task: CRITICAL NEED to UPDATE ucFeeMode in the xDpktDataPacketConfig (Data Packet) \n", pxNFee->ucId);
						#endif
						break;
					default:
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage )
							fprintf(fp,"\nNFEE-%hu Task: Mode not recognized: xDpktDataPacketConfig (Data Packet) \n", pxNFee->ucId);
						#endif
						break;
				}

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
							xTrans.bDmaReturn[ ucSideFromMSG ] = bPrepareDoubleBuffer( xTrans.xCcdMapLocal[ucSideFromMSG], xTrans.ucMemory, pxNFee->ucId, pxNFee, ucSideFromMSG, xTrans );
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
						vQCmdFEEinPreLoadBuffer( pxNFee, uiCmdFEE.ulWord );//todo: fazer um leitor
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
						vQCmdFEEinReadoutTrans( pxNFee, uiCmdFEE.ulWord );//todo: � preciso avaliar!!!!!!!!!!!!!
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
				/* Debug purposes only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\nEnd of transmission NFEE-%hhu -> CCD %hhu\n", pxNFee->ucId, xTrans.ucCcdNumber);
					fprintf(fp,"Memory used: %u\n", xTrans.ucMemory);
				}
				#endif

				xTrans.bFinal[0] = FALSE;
				xTrans.bFinal[1] = FALSE;
				vResetMemCCDFEE(pxNFee);

				/*Check if need to back to the previous mode: On or StandBy*/
				pxNFee->xControl.eState = redoutWaitBeforeSyncSignal;
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


				//todo: o valor do uliCurrentMode, vai para qual registrador? ccd_mode_config? l� nao apenas indica para onde deve ir o FEE?
				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				/*ccd_mode_config[3:0]*/
				/*Trying to save some processing*/
				if (xTrans.bFirstT == TRUE) {
					xTrans.bFirstT = FALSE;
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

/* Threat income command while the Fee is on Readout Mode mode*/
void vQCmdFEEinPreLoadBuffer( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;
				break;
			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eState = sOn_Enter;

				break;
			case M_FEE_ON:
				/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					#endif
				}
				break;
			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					#endif
				}
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif

				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPinPreLoadBuffer( pxNFeeP, cmd );//todo: Tiago

				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: CRITICAL! Don't expect to receive sync before finish the transmission (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}

/* Threat income command while the Fee is on Readout Mode mode*/
void vQCmdFEEinReadoutTrans( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;
				break;
			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eState = sOn_Enter;

				break;
			case M_FEE_ON:
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					}
					#endif
				}

				break;
			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					#endif
				}
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif

				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPinReadoutTrans( pxNFeeP, cmd );//todo: dizem que nao vao enviar comando durante a transmissao, ignorar?

				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: CRITICAL! Don't expect to receive sync before finish the transmission (in redoutTransmission)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
				}
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
			case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sConfig;
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
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
					#endif
				}
				break;
			case M_FEE_ON_FORCED:

				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eState = sOn_Enter;

				break;

			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					#endif
				}
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"\nNFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPReadoutSync( pxNFeeP, cmd ); // todo: Precisa criar fluxo para RMAP
				break;
			case M_BEFORE_SYNC:
				/*Do nothing for now*/
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

			case M_FEE_ON_FORCED:

				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eState = sOn_Enter;
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
			case M_BEFORE_SYNC:
				/*Do nothing*/
				break;
			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				/* Warning */
					pxNFeeP->xControl.bWatingSync = TRUE;
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


/* Threat income command while the Fee is in Standby mode*/
void vQCmdFEEinStandBy( TNFee *pxNFeeP, unsigned int cmd ) {
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

			case M_FEE_ON:
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sWaitSync;
				break;
			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sOn_Enter;
				break;

			case M_FEE_FULL:
			case M_FEE_FULL_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sFullImage;
				/* Real State */
				pxNFeeP->xControl.eState = sFullImage_Enter;
				break;

			case M_FEE_WIN:
			case M_FEE_WIN_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sWindowing;
				/* Real State */
				pxNFeeP->xControl.eState = sWindowing_Enter;
				break;

			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_1_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sParTrap1;
				/* Real State */
				pxNFeeP->xControl.eState = sParTrap1_Enter;
				break;

			case M_FEE_PAR_TRAP_2:
			case M_FEE_PAR_TRAP_2_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sParTrap2;
				/* Real State */
				pxNFeeP->xControl.eState = sParTrap2_Enter;
				break;

			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_1_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sSerialTrap1;
				/* Real State */
				pxNFeeP->xControl.eState = sSerialTrap1_Enter;
				break;

			case M_FEE_SERIAL_TRAP_2:
			case M_FEE_SERIAL_TRAP_2_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sSerialTrap2;
				/* Real State */
				pxNFeeP->xControl.eState = sSerialTrap2_Enter;
				break;

			case M_FEE_RMAP:

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPinStandBy( pxNFeeP, cmd );

				break;

			case M_BEFORE_SYNC:
				/*Do nothing*/
				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				/*DO nothing for now*/
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, uiCmdFEEL.ucByte[1], pxNFeeP->ucId);
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed in this mode (StandBy, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
				}
				#endif
				break;
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
			case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sStandby_Enter;
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

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPinModeOn( pxNFeeP, cmd );

				break;
			case M_BEFORE_SYNC:
				/*Do nothing*/
				break;
			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				/*DO nothing for now*/
				break;
			case M_FEE_DMA_ACCESS:
				pxNFeeP->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, uiCmdFEEL.ucByte[1], pxNFeeP->ucId);
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
			case M_FEE_ON:
			case M_FEE_ON_FORCED:
			case M_FEE_RUN:
			case M_FEE_RUN_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.eMode = sConfig;
				/* Real State */
				pxNFeeP->xControl.eState = sOn_Enter;
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
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, uiCmdFEEL.ucByte[1], pxNFeeP->ucId);
				break;
			case M_BEFORE_SYNC:
			case M_SYNC:
			case M_PRE_MASTER:
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
	}
}

/* Threat income command while the Fee is in Config. mode*/
void vQCmdFEEinWaitingMemUpdate( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;
				break;

			case M_FEE_CAN_ACCESS_NEXT_MEM:
				pxNFeeP->xControl.eState = redoutCheckRestr;
				break;

			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eState = sOn_Enter;
				break;

			case M_FEE_ON:
				/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					#endif
				}
				break;

			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					#endif
				}
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif

				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPinWaitingMemUpdate( pxNFeeP, cmd );//todo: Tiago
				break;

			case M_BEFORE_SYNC:
				/*Do nothing for now*/
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
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			fprintf(fp,"NFEE %hhu Task:  Wrong FEE id (Config)\n", pxNFeeP->ucId);
		}
		#endif
	}
}



void vQCmdWaitBeforeSyncSignal( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sConfig;
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
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eState = sOn_Enter;

				break;

			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandBy; //todo: Trocar para Mode_on
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					#endif
				}
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
					fprintf(fp,"\nNFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPBeforeSync( pxNFeeP, cmd ); // todo: Precisa criar fluxo para RMAP
				break;

			case M_BEFORE_SYNC:
				if ( pxNFeeP->xControl.eNextMode != pxNFeeP->xControl.eLastMode )
					pxNFeeP->xControl.eState = redoutCheckDTCUpdate; /*Is time to start the preparation of the double buffer in order to transmit data just after sync arrives*/
				else
					pxNFeeP->xControl.eState = redoutWaitSync; /*Received some command to change the mode, just go wait sync to change*/
				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: CRITICAL! Something went wrong, no expected sync before the 'Before Sync Signal'  \n", pxNFeeP->ucId);
				}
				#endif
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

void vSendMessageNUCModeFeeChange( unsigned char usIdFee, unsigned short int mode  ) {
	INT8U error_code, i;
	char cHeader[8] = "!F:%hhu:";
	char cBufferL[128] = "";

	sprintf( cBufferL, "%s%hhu:%hu", cHeader, usIdFee, mode );


	/* Should send message to the NUc to inform the FEE mode */
	OSMutexPend(xMutexTranferBuffer, 0, &error_code); /*Blocking*/
	if (error_code == OS_ERR_NONE) {
		/* Got the Mutex */
		/*For now, will only get the first, not the packet that is waiting for longer time*/
		for( i = 0; i < N_128_SENDER; i++)
		{
            if ( xBuffer128_Sender[i].bInUse == FALSE ) {
                /* Locate a filled PreParsed variable in the array*/
            	/* Perform a copy to a local variable */
            	memcpy(xBuffer128_Sender[i].buffer_128, cBufferL, 128);
                xBuffer128_Sender[i].bInUse = TRUE;
                xBuffer128_Sender[i].bPUS = FALSE;
                break;
            }
		}
		OSMutexPost(xMutexTranferBuffer);
	} else {
		/* Couldn't get Mutex. (Should not get here since is a blocking call without timeout)*/
		vFailGetxMutexSenderBuffer128();
	}
}

void vSetDoubleBufferRightSize( unsigned char ucLength, unsigned char ucId ) {

	switch (ucId) {
		case 0:
			bFeebCh1SetBufferSize( ucLength, 1);
			break;
		case 1:
			bFeebCh2SetBufferSize( ucLength, 1);
			break;
		case 2:
			bFeebCh3SetBufferSize( ucLength, 1);
			break;
		case 3:
			bFeebCh4SetBufferSize( ucLength, 1);
			break;
		case 4:
			bFeebCh5SetBufferSize( ucLength, 1);
			break;
		case 5:
			bFeebCh6SetBufferSize( ucLength, 1);
			break;
		case 6:
			bFeebCh7SetBufferSize( ucLength, 1);
			break;
		case 7:
			bFeebCh8SetBufferSize( ucLength, 1);
			break;
		default:
			break;
	}
}

void vSetDoubleBufferLeftSize( unsigned char ucLength, unsigned char ucId ) {

	switch (ucId) {
		case 0:
			bFeebCh1SetBufferSize( ucLength, 0);
			break;
		case 1:
			bFeebCh2SetBufferSize( ucLength, 0);
			break;
		case 2:
			bFeebCh3SetBufferSize( ucLength, 0);
			break;
		case 3:
			bFeebCh4SetBufferSize( ucLength, 0);
			break;
		case 4:
			bFeebCh5SetBufferSize( ucLength, 0);
			break;
		case 5:
			bFeebCh6SetBufferSize( ucLength, 0);
			break;
		case 6:
			bFeebCh7SetBufferSize( ucLength, 0);
			break;
		case 7:
			bFeebCh8SetBufferSize( ucLength, 0);
			break;
		default:
			break;
	}
}

/* todo: Adicionar Timeout e colocar a tarefa para sleep*/
void vWaitUntilBufferEmpty( unsigned char ucId ) {

	switch (ucId) {
		case 0:
			while ( (bFeebGetCh1LeftFeeBusy()== TRUE) || (bFeebGetCh1RightFeeBusy()== TRUE)  ) {}
			break;
		case 1:
			while ( (bFeebGetCh2LeftFeeBusy()== TRUE) || (bFeebGetCh2RightFeeBusy()== TRUE)  ) {}
			break;
		case 2:
			while ( (bFeebGetCh3LeftFeeBusy()== TRUE) || (bFeebGetCh3RightFeeBusy()== TRUE)  ) {}
			break;
		case 3:
			while ( (bFeebGetCh4LeftFeeBusy()== TRUE) || (bFeebGetCh4RightFeeBusy()== TRUE)  ) {}
			break;
		case 4:
			while ( (bFeebGetCh5LeftFeeBusy()== TRUE) || (bFeebGetCh5RightFeeBusy()== TRUE)  ) {}
			break;
		case 5:
			while ( (bFeebGetCh6LeftFeeBusy()== TRUE) || (bFeebGetCh6RightFeeBusy()== TRUE)  ) {}
			break;
		case 6:
			//while ( (bFeebGetCh7LeftFeeBusy()== TRUE) || (bFeebGetCh7RightFeeBusy()== TRUE)  ) {}
			break;
		case 7:
			//while ( (bFeebGetCh8LeftFeeBusy()== TRUE) || (bFeebGetCh8RightFeeBusy()== TRUE)  ) {}
			break;
		default:
			break;
	}

}

inline unsigned long int uliReturnMaskR( unsigned char ucChannel ){
	unsigned long int uliOut;

	switch (ucChannel) {
		case 0:
			uliOut = LEDS_1R_MASK;
			break;
		case 1:
			uliOut = LEDS_2R_MASK;
			break;
		case 2:
			uliOut = LEDS_3R_MASK;
			break;
		case 3:
			uliOut = LEDS_4R_MASK;
			break;
		case 4:
			uliOut = LEDS_5R_MASK;
			break;
		case 5:
			uliOut = LEDS_6R_MASK;
			break;
		case 6:
			uliOut = LEDS_7R_MASK;
			break;
		case 7:
			uliOut = LEDS_8R_MASK;
			break;
		default:
			uliOut = LEDS_R_ALL_MASK;
			break;
	}
	return uliOut;
}


inline unsigned long int uliReturnMaskG( unsigned char ucChannel ){
	unsigned long int uliOut;

	switch (ucChannel) {
		case 0:
			uliOut = LEDS_1G_MASK;
			break;
		case 1:
			uliOut = LEDS_2G_MASK;
			break;
		case 2:
			uliOut = LEDS_3G_MASK;
			break;
		case 3:
			uliOut = LEDS_4G_MASK;
			break;
		case 4:
			uliOut = LEDS_5G_MASK;
			break;
		case 5:
			uliOut = LEDS_6G_MASK;
			break;
		case 6:
			uliOut = LEDS_7G_MASK;
			break;
		case 7:
			uliOut = LEDS_8G_MASK;
			break;
		default:
			uliOut = LEDS_G_ALL_MASK;
			break;
	}
	return uliOut;
}

/* Prepare the double buffer for the HW DataPacket*/
bool bPrepareDoubleBuffer( TCcdMemMap *xCcdMapLocal, unsigned char ucMem, unsigned char ucID, TNFee *pxNFee, unsigned char ucSide, TFEETransmission xTransL ) {
	bool  bDmaReturn;
	unsigned long ulLengthBlocks;

	bDmaReturn = FALSE;
	xCcdMapLocal->ulBlockI = 0;
	xCcdMapLocal->ulAddrI = xCcdMapLocal->ulOffsetAddr + xTransL.ulAddrIni;


	if ( (xCcdMapLocal->ulBlockI + xTransL.ulSMD_MAX_BLOCKS) >=  xTransL.ulTotalBlocks ) {
		ulLengthBlocks = xTransL.ulTotalBlocks - xCcdMapLocal->ulBlockI;
	} else {
		ulLengthBlocks = xTransL.ulSMD_MAX_BLOCKS;
	}

	vSetDoubleBufferLeftSize( (unsigned char)ulLengthBlocks, pxNFee->ucSPWId);
	vSetDoubleBufferRightSize( (unsigned char)ulLengthBlocks, pxNFee->ucSPWId );

	if (  ucMem == 0  ) {
		bDmaReturn = bSdmaDmaM1Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks; //todo: substituir SDMA_PIXEL_BLOCK_SIZE_BYTES por algo mais flexivel
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	} else {
		bDmaReturn = bSdmaDmaM2Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks; //todo: substituir SDMA_PIXEL_BLOCK_SIZE_BYTES por algo mais flexivel
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	}


	if ( (xCcdMapLocal->ulBlockI + xTransL.ulSMD_MAX_BLOCKS) >= xTransL.ulTotalBlocks ) {
		ulLengthBlocks = xTransL.ulTotalBlocks - xCcdMapLocal->ulBlockI;
	} else {
		ulLengthBlocks = xTransL.ulSMD_MAX_BLOCKS;
	}

	vSetDoubleBufferLeftSize( (unsigned char)ulLengthBlocks, pxNFee->ucSPWId );
	vSetDoubleBufferRightSize( (unsigned char)ulLengthBlocks, pxNFee->ucSPWId );


	if (  ucMem == 0  ) {
		bDmaReturn = bSdmaDmaM1Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks; //todo: substituir SDMA_PIXEL_BLOCK_SIZE_BYTES por algo mais flexivel
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	} else {
		bDmaReturn = bSdmaDmaM2Transfer((alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += SDMA_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks; //todo: substituir SDMA_PIXEL_BLOCK_SIZE_BYTES por algo mais flexivel
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	}

	return bDmaReturn;
}

/* This function send command for the NFEE Controller Queue that is responsible to schedule the DMA*/
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

/* This function send command request for the NFEE Controller Queue (with priority)*/
bool bSendRequestNFeeCtrl_Front( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
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
	error_codel = OSQPostFront(xNfeeSchedule, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailRequestDMA( ucValue );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}

	return bSuccesL;
}

/* This function send command request for the NFEE Controller Queue*/
bool bSendMSGtoMebTask( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_MEB_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPost(xMebQ, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailFromFEE();
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}
	return bSuccesL;
}


/* This function send command request for the NFEE Controller Queue*/
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

bool bDisableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {
	/* Disable RMAP channel */
	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteCmdEn = FALSE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {

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
	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);
	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);
	/* Start the module Double Buffer */
	bFeebStartCh(pxFeebCh);

	/*Enable IRQ of FEE Buffer*/
	bFeebGetWindowing(pxFeebCh);
	//pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
	pxFeebCh->xWindowingConfig.bMasking = xDefaults.bDataPacket;
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
	bFeebStartCh(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}



//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPBeforeSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	}
	#endif
	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);
	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			break;
		default:
			break;
	}
}



//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinWaitingMemUpdate( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	}
	#endif
	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);
	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			break;
		default:
			break;
	}
}


//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinModeOn( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	}
	#endif
	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);
	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			break;
		default:
			break;
	}
}


//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinStandBy( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	}
	#endif
	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);
	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			break;
		default:
			break;
	}
}

//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPWaitingSync( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	}
	#endif
	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);
	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			break;
		default:
			break;
	}
}


//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPReadoutSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	}
	#endif
	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);
	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			break;
		default:
			break;
	}
}



//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinReadoutTrans( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	}
	#endif
	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);
	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			break;
		default:
			break;
	}
}


//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinPreLoadBuffer( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;
	INT8U ucValueReg;
	INT32U ucValueMasked;
	INT32U ucValueMasked2;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"\nNFEE %hhu Task: RMAP msg received\n", pxNFeeP->ucId);
	}
	#endif
	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];
	ucValueReg = uliRmapReadReg(pxNFeeP->xChannel.xRmap.puliRmapChAddr,  ucADDRReg);
	switch (ucADDRReg) {
		case 0x40://0x00000000: ccd_seq_1_config
			break;
		default:
			break;
	}
}