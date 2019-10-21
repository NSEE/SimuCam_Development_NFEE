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
	volatile INT8U ucRetries;
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

				/*0..4509*/
				pxNFee->xMemMap.xCommon.ulVStart = pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
				pxNFee->xMemMap.xCommon.ulVEnd = pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
				/*0..2294*/
				pxNFee->xMemMap.xCommon.ulHStart = pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;
				pxNFee->xMemMap.xCommon.ulHEnd = pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;



				bFeebGetMachineControl(&pxNFee->xChannel.xFeeBuffer);
				//pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
				pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bDataControllerEn = xDefaults.bDataPacket;
				pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = TRUE;
				pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
				bFeebSetMachineControl(&pxNFee->xChannel.xFeeBuffer);

				pxNFee->xControl.eState = sConfig_Enter;
				break;
			case sConfig_Enter:/* Transition */

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Config Mode\n", pxNFee->ucId);
				}
				#endif

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x00; /*Off*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
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

				ucRetries = 0;

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sInit;
				pxNFee->xControl.eMode = sConfig;
				pxNFee->xControl.eNextMode = sConfig;
				/* Real State */

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
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

				/*Clear the queue message for this FEE*/
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x00; /*On mode*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
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

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
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
				pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x04; /*sFeeStandBy*/
				bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

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

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
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

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sOn_Enter;
				pxNFee->xControl.eMode = sFullPattern;
				pxNFee->xControl.eNextMode = redoutWaitBeforeSyncSignal;
				/* Real State */
				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sWinPattern_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Windowing Pattern after Sync.\n", pxNFee->ucId);
				}
				#endif

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sOn_Enter;
				pxNFee->xControl.eMode = sWinPattern;
				pxNFee->xControl.eNextMode = redoutWaitBeforeSyncSignal;
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

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sFullImage;
				pxNFee->xControl.eNextMode = redoutWaitBeforeSyncSignal;
				/* Real State */

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sWindowing_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Windowing after Sync.\n", pxNFee->ucId);
				}
				#endif

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sWindowing;
				pxNFee->xControl.eNextMode = redoutWaitBeforeSyncSignal;
				/* Real State */

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sParTrap1_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Parallel Trap 1 after Sync.\n", pxNFee->ucId);
				}
				#endif

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sParTrap1;
				pxNFee->xControl.eNextMode = redoutWaitBeforeSyncSignal;
				/* Real State */

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sParTrap2_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Parallel Trap 2 after Sync.\n", pxNFee->ucId);
				}
				#endif

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sParTrap2;
				pxNFee->xControl.eNextMode = redoutWaitBeforeSyncSignal;
				/* Real State */

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sSerialTrap1_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Serial Trap 1 after Sync.\n", pxNFee->ucId);
				}
				#endif

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sSerialTrap1;
				pxNFee->xControl.eNextMode = redoutWaitBeforeSyncSignal;
				/* Real State */

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sSerialTrap2_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Serial Trap 2 after Sync.\n", pxNFee->ucId);
				}
				#endif

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sSerialTrap2;
				pxNFee->xControl.eNextMode = redoutWaitBeforeSyncSignal;
				/* Real State */

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;




/*============================== Readout Cycle Implementation ========================*/



			case redoutCycle_Enter:
				/* Debug only*/
//				#if DEBUG_ON
//				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
//					fprintf(fp,"N-%hu: redoutCycle_Enter\n", pxNFee->ucId);
//				}
//				#endif

				/* Indicates that this FEE will now need to use DMA*/
				pxNFee->xControl.bUsingDMA = TRUE;
				xTrans.bFirstT = TRUE;

				if (xGlobal.bJustBeforSync == FALSE)
					pxNFee->xControl.eState = redoutWaitBeforeSyncSignal;
				else
					pxNFee->xControl.eState = redoutCheckRestr;

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

//				#if DEBUG_ON
//				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
//					fprintf(fp,"N-%hu: redoutCheckDTCUpdate\n", pxNFee->ucId);
//				}
//				#endif

				/*Check if is needed wait the update of the memory, need only in the last readout cycle */
				if ( xGlobal.bPreMaster == FALSE ) {
					pxNFee->xControl.eState = redoutCheckRestr;
				} else {
					if ( (xGlobal.bDTCFinished == TRUE) || (xGlobal.bJustBeforSync == TRUE) ) {
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

//				#if DEBUG_ON
//				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
//					fprintf(fp,"N-%hu: redoutCheckRestr\n", pxNFee->ucId);
//				}
//				#endif

				/*The Meb My have sent a message to inform the finish of the update of the image*/
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/* Wait until both buffers are empty  */
				vWaitUntilBufferEmpty( pxNFee->ucSPWId );
				/* Guard time that HW MAYBE need, this will be used during the development, will be removed in some future version*/
				OSTimeDlyHMSM(0, 0, 0, min_sim(xDefaults.usiGuardNFEEDelay,5)); //todo: For now fixed in 5 ms

				/*Reset Fee Buffer every Master Sync*/
				if ( xGlobal.bPreMaster == TRUE ) {
					/* Stop the module Double Buffer */
					bFeebStopCh(&pxNFee->xChannel.xFeeBuffer);
					/* Clear all buffer form the Double Buffer */
					bFeebClrCh(&pxNFee->xChannel.xFeeBuffer);
					/* Start the module Double Buffer */
					bFeebStartCh(&pxNFee->xChannel.xFeeBuffer);
				}

				pxNFee->xControl.eState = redoutConfigureTrans;

				break;


			case redoutConfigureTrans:
//				#if DEBUG_ON
//				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
//					fprintf(fp,"N-%hu: redoutConfigureTrans\n", pxNFee->ucId);
//				}
//				#endif

				/* Reset the memory control variables thats is used in the transmission*/
				vResetMemCCDFEE( pxNFee );


				pxNFee->xControl.bUsingDMA = TRUE;
				/*Since the default value of SensorSel Reg is both, need check if is some of Windowing Mode, otherwise overwrite with left*/
				if ( (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucSensorSel == eRmapSenSelEFBoth) ) { //both
					if ( (pxNFee->xControl.eMode == sWindowing) || (pxNFee->xControl.eMode == sWinPattern)){
						xTrans.side = sBoth;
					} else {
						xTrans.side = sLeft; /*sLeft = 0*/
						pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucSensorSel = eRmapSenSelELeft;
					}
				} else {
					if ( pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucSensorSel == eRmapSenSelELeft ) {
						xTrans.side = sLeft; /*sLeft = 0*/
					} else {
						// todo: error if a reserved value is used [rfranca]
						xTrans.side = sRight; /*sRight = 1*/
					}
				}

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
				bEnableDbBuffer(pxNFee, &pxNFee->xChannel.xFeeBuffer);


				/* Update DataPacket with the information of actual readout information*/
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				bFeebGetMachineControl(&pxNFee->xChannel.xFeeBuffer);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucCcdNumber = xTrans.ucCcdNumber;
				switch (pxNFee->xControl.eMode) {
					case sFullPattern:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePattern;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						break;
					case sWinPattern:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowingPattern;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = TRUE;
						break;
					case sFullImage:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImage;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						break;
					case sWindowing:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowing;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = TRUE;
						break;
					case sParTrap1:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktParallelTrapPumping1;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						break;
					case sParTrap2:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktParallelTrapPumping2;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						break;
					case sSerialTrap1:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktSerialTrapPumping1;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						break;
					case sSerialTrap2:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktSerialTrapPumping2;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						break;
					default:
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage )
							fprintf(fp,"\nNFEE-%hu Task: Mode not recognized: xDpktDataPacketConfig (Data Packet). Configuring On Mode.\n", pxNFee->ucId);
						#endif
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						break;
				}
				bFeebSetMachineControl(&pxNFee->xChannel.xFeeBuffer);
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

				ucRetries = 0;

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

						if ( (xTrans.bDmaReturn[0] == TRUE) && (xTrans.bDmaReturn[1] == TRUE) ) {

							pxNFee->xControl.eState = redoutWaitSync;
							pxNFee->xControl.eNextMode = redoutTransmission;

							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
								fprintf(fp,"\nNFEE-%hu Task: D. B. prepared, Side %u\n", pxNFee->ucId, ucSideFromMSG);
							}
							#endif
						} else {

							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
								fprintf(fp,"NFEE-%hu Task: CRITICAL! Could not prepare the double buffer.\n", pxNFee->ucId);
							}
							#endif

							if ( ucRetries > 9) {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
									fprintf(fp,"NFEE-%hu Task: CRITICAL! D. B. Requested more than 3 times.\n", pxNFee->ucId);
									fprintf(fp,"NFEE %hhu Task: Ending the simulation.\n", pxNFee->ucId);
								}
								#endif

								/*Back to Config*/
								pxNFee->xControl.bWatingSync = FALSE;
								pxNFee->xControl.eLastMode = sInit;
								pxNFee->xControl.eMode = sConfig;
								pxNFee->xControl.eState = sConfig_Enter;

								ucRetries = 0;

							} else {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
									fprintf(fp,"NFEE %hhu Task: Retry D.B. request.\n", pxNFee->ucId);
								}
								#endif

								/* Stop the module Double Buffer */
								bFeebStopCh(&pxNFee->xChannel.xFeeBuffer);
								/* Clear all buffer form the Double Buffer */
								bFeebClrCh(&pxNFee->xChannel.xFeeBuffer);
								/* Start the module Double Buffer */
								bFeebStartCh(&pxNFee->xChannel.xFeeBuffer);

								bSendRequestNFeeCtrl_Front( M_NFC_DMA_REQUEST, ucSideFromMSG, pxNFee->ucId);


							}

							ucRetries++;

						}
					} else {
						/* Is not access to DMA, so we need to check what is this received command */
						vQCmdFEEinPreLoadBuffer( pxNFee, uiCmdFEE.ulWord );
					}
					/* Send message telling to controller that is not using the DMA any more */
					bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, ucSideFromMSG, pxNFee->ucId);
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

						xTrans.bFinal[ucSideFromMSG] = FALSE;

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
							/* Giving the mutex back*/
							OSMutexPost(xDma[xTrans.ucMemory].xMutexDMA);

							/* Send message telling to controller that is not using the DMA any more */
							bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, ucSideFromMSG, pxNFee->ucId);

							/* Last Packet scheduled?*/
							if ( (xTrans.bFinal[0] == TRUE) && (xTrans.bFinal[1] == TRUE) ) {
								/* Changing the FEE state */
								pxNFee->xControl.eState = redoutEndSch;
							}
						} else {
							/* If you could not get the mutex sem. */

						}
					} else {
						/* Is not an access DMA command, check what is?*/
						vQCmdFEEinReadoutTrans( pxNFee, uiCmdFEE.ulWord );
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
					fprintf(fp,"NFEE-%hu Task: End of transmission -> CCD %hhu; Mem Used:%u\n", pxNFee->ucId, xTrans.ucCcdNumber, xTrans.ucMemory);
				}
				#endif

				xTrans.bFinal[0] = FALSE;
				xTrans.bFinal[1] = FALSE;
				vResetMemCCDFEE(pxNFee);


				if ((xGlobal.bJustBeforSync == TRUE)) {
					pxNFee->xControl.eState = redoutCheckRestr;
				} else {
					pxNFee->xControl.eState = redoutWaitBeforeSyncSignal;
				}
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

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				if (xTrans.bFirstT == TRUE) {
					xTrans.bFirstT = FALSE;
					bRmapGetMemConfigArea(&pxNFee->xChannel.xRmap);
					switch ( pxNFee->xControl.eMode ) {

						case sOn: /*0x0*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0x0) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x0;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sFullPattern: /*0x1*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0x1) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x1;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sWinPattern:/*0x2*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0x2) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x2;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sStandBy: /*0x4*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0x4) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x4;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sFullImage:/*0x6*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0x6) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x6;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sWindowing:/*0x5*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0x5) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x5;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sParTrap1:/*0x9*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0x9) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0x9;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sParTrap2:/*0xA*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0xA) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0xA;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sSerialTrap1:/*0xB*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0xB) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0xB;
								bRmapSetMemConfigArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sSerialTrap2:/*0xC*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode != 0xC) {
								pxNFee->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->ucOpMode = 0xC;
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
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				pxNFeeP->xControl.eState = sOn_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_ON:
				/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
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
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
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

			case M_BEFORE_SYNC:
				/*Do nothing*/
				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: CRITICAL! Don't expect to receive sync before finish the transmission (in redoutPreparingDB)\n", pxNFeeP->ucId);
					fprintf(fp,"NFEE %hhu Task: Ending the simulation.\n", pxNFeeP->ucId);
				}
				#endif
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				break;
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_2:
			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_2:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Unexpected command for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}

/* Threat income command while the Fee is on Readout Mode mode*/
void vQCmdFEEinReadoutTrans( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	unsigned char error_code;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				pxNFeeP->xControl.eState = sOn_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_ON:
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

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

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
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

			case M_BEFORE_SYNC:
				/* Stop the module Double Buffer */
				bFeebStopCh(&pxNFeeP->xChannel.xFeeBuffer);
				/* Clear all buffer form the Double Buffer */
				bFeebClrCh(&pxNFeeP->xChannel.xFeeBuffer);
				/* Start the module Double Buffer */
				bFeebStartCh(&pxNFeeP->xChannel.xFeeBuffer);

				/*The Meb My have sent a message to inform the finish of the update of the image*/
				error_code = OSQFlush( xFeeQ[ pxNFeeP->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				pxNFeeP->xControl.eState = redoutConfigureTrans;
				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: CRITICAL! Don't expect to receive sync before finish the transmission (in redoutTransmission)\n", pxNFeeP->ucId);
					fprintf(fp,"NFEE %hhu Task: Ending the simulation.\n", pxNFeeP->ucId);
				}
				#endif
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				break;
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_2:
			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_2:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
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
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_ON:
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					/* If a transition to On was requested when the FEE is waiting to go to Calibration,
					 * configure the hardware to not send any data in the next sync */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
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
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				pxNFeeP->xControl.eState = sOn_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;

			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
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
					fprintf(fp,"\nNFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPReadoutSync( pxNFeeP, cmd ); // todo: Precisa criar fluxo para RMAP
				break;
			case M_BEFORE_SYNC:
				/*Do nothing for now*/

				if ( pxNFeeP->xControl.eLastMode == pxNFeeP->xControl.eNextMode ) {
					/* If a transition to On was requested when the FEE is waiting to go to Calibration,
					 * configure the hardware to not send any data in the next sync */

					/* rfranca */
					/*
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					*/
 				}

				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				/* Warning */
					pxNFeeP->xControl.eState = pxNFeeP->xControl.eNextMode;
				break;

			case M_FEE_DMA_ACCESS:
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_2:
			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_2:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Unexpected command for this mode \n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}

/*Not in use for now*/
/* Threat income command while the Fee is waiting for sync*/
void vQCmdFEEinWaitingSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;

			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				pxNFeeP->xControl.eState = sOn_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
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
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_STANDBY:
			case M_FEE_ON:
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_2:
			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_2:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed, already processing a changing action (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
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
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eNextMode = sConfig;
				/* Real State */
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				break;

			case M_FEE_ON:
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sWaitSync;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				break;
			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sOn_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

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
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN_PATTERN:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Unexpected command for this mode (StandBy, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
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
			case M_NFC_CONFIG_RESET:
				/*Do nothing*/
				break;
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eNextMode = sConfig;
				/* Real State */
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				break;
			case M_FEE_STANDBY:
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sStandby_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sWaitSync;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

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
			case M_FEE_FULL:
			case M_FEE_WIN:
			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_2:
			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_2:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Unexpected command for this mode (ON, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
				}
				#endif
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
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE %hhu Task: Already in Config Mode (Config)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_ON_FORCED:
				break;
			case M_FEE_ON:
			case M_FEE_RUN:
			case M_FEE_RUN_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sOn_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

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
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_2:
			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_2:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Unexpected command for this mode (Config, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
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
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;

			case M_FEE_CAN_ACCESS_NEXT_MEM:
				pxNFeeP->xControl.eState = redoutCheckRestr;
				break;

			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				pxNFeeP->xControl.eState = sOn_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;

			case M_FEE_ON:
				/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
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
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
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
					fprintf(fp,"NFEE %hhu Task: CRITICAL! Sync arrive and still waiting for DTC complete the memory update. (Readout Cycle)\n", pxNFeeP->ucId);
					fprintf(fp,"NFEE %hhu Task: Ending the simulation.\n", pxNFeeP->ucId);
				}
				#endif
				/*Back to Config*/
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				break;
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_2:
			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_2:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Unexpected command for in this mode (Readout Cycle, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
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
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_ON:
				if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

					pxNFeeP->xControl.bWatingSync = TRUE;
					/* If a transition to On was requested when the FEE is waiting to go to Calibration,
					 * configure the hardware to not send any data in the next sync */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
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
				pxNFeeP->xControl.eLastMode = sConfig_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sOn_Enter;
				pxNFeeP->xControl.eState = sOn_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				/*don't need side*/
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;

			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					pxNFeeP->xControl.eState = redoutWaitSync;

					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
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
					fprintf(fp,"NFEE %hhu Task: Ending the simulation.\n", pxNFeeP->ucId);
				}
				#endif
				/*Back to Config*/
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eState = sConfig_Enter;

				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

				break;

			case M_FEE_DMA_ACCESS:
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
				break;
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_2:
			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_2:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task: Unexpected command for this mode \n", pxNFeeP->ucId);
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
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucProtocolId = xDefaults.usiDataProtId; /* 0xF0 ou  0x02*/
	pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xDefaults.usiDpuLogicalAddr;
	bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
}

/* Initializing the the values of the HK memory area, only during dev*/
void vInitialConfig_RmapMemHKArea( TNFee *pxNFeeP ) {

	bRmapGetRmapMemHKArea(&pxNFeeP->xChannel.xRmap);
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense1 = 0xFF00;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense2 = 0xFF01;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense3 = 0xFF02;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense4 = 0xFF03;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense5 = 0xFF04;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense6 = 0xFF05;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1Ts = 0xFF06;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2Ts = 0xFF07;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3Ts = 0xFF08;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4Ts = 0xFF09;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt1 = 0xFF0A;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt2 = 0xFF0B;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt3 = 0xFF0C;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt4 = 0xFF0D;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt5 = 0xFF0E;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiZeroDiffAmp = 0xFF0F;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VodMon = 0xFF10;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VogMon = 0xFF11;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VrdMonE = 0xFF12;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VodMon = 0xFF13;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VogMon = 0xFF14;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VrdMonE = 0xFF15;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VodMon = 0xFF16;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VogMon = 0xFF17;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VrdMonE = 0xFF18;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VodMon = 0xFF19;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VogMon = 0xFF1A;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VrdMonE = 0xFF1B;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVccd = 0xFF1C;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVrclkMon = 0xFF1D;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiViclk = 0xFF1E;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVrclkLow = 0xFF1F;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi5vbPosMon = 0xFF20;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi5vbNegMon = 0xFF21;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi3v3bMon = 0xFF22;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi2v5aMon = 0xFF23;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi3v3dMon = 0xFF24;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi2v5dMon = 0xFF25;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi1v5dMon = 0xFF26;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi5vrefMon = 0xFF27;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVccdPosRaw = 0xFF28;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVclkPosRaw = 0xFF29;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVan1PosRaw = 0xFF2A;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVan3NegMon = 0xFF2B;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVan2PosRaw = 0xFF2C;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVdigRaw = 0xFF2D;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVdigRaw2 = 0xFF2E;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiViclkLow = 0xFF2F;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VrdMonF = 0xFF30;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VddMon = 0xFF31;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VgdMon = 0xFF32;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VrdMonF = 0xFF33;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VddMon = 0xFF34;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VgdMon = 0xFF35;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VrdMonF = 0xFF36;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VddMon = 0xFF37;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VgdMon = 0xFF38;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VrdMonF = 0xFF39;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VddMon = 0xFF3A;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VgdMon = 0xFF3B;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiIgHiMon = 0xFF3C;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiIgLoMon = 0xFF3D;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTsenseA = 0xFF3E;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTsenseB = 0xFF3F;
	bRmapSetRmapMemHKArea(&pxNFeeP->xChannel.xRmap);
}

/**
 * @name vUpdateFeeHKValue
 * @author bndky
 * @brief Update HK function for simulated FEE
 * @ingroup rtos
 *
 * @param 	[in]	TNFee 			*FeeInstance
 * @param	[in]	usi 	usiID		(0 - 63)
 * @param	[in]	alt_u32			fValue
 *
 * @retval void
 **/
void vUpdateFeeHKValue ( TNFee *pxNFeeP, unsigned short int usiID,  alt_u32 uliValue){
	
	unsigned short int usiValue;
	/* Approx. float to usi */
	usiValue = (unsigned short int) uliValue;

	/* Load current values */
	bRmapGetRmapMemHKArea(&pxNFeeP->xChannel.xRmap);

	/* TODO: Verif which HK is 32bit, future, for now all regs are 16bit */
	/* Switch case to assign value to register */
	switch(usiID){
		case usiTouSense1:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense1 = usiValue;
		break;
		case usiTouSense2:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense2 = usiValue;
		break;
		case usiTouSense3:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense3 = usiValue;
		break;
		case usiTouSense4:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense4 = usiValue;
		break;
		case usiTouSense5:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense5 = usiValue;
		break;
		case usiTouSense6:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTouSense6 = usiValue;
		break;
		case usiCcd1Ts:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1Ts = usiValue;
		break;
		case usiCcd2Ts:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2Ts = usiValue;
		break;
		case usiCcd3Ts:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3Ts = usiValue;
		break;
		case usiCcd4Ts:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4Ts = usiValue;
		break;
		case usiPrt1:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt1 = usiValue;
		break;
		case usiPrt2:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt2 = usiValue;
		break;
		case usiPrt3:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt3 = usiValue;
		break;
		case usiPrt4:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt4 = usiValue;
		break;
		case usiPrt5:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiPrt5 = usiValue;
		break;
		case usiZeroDiffAmp:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiZeroDiffAmp = usiValue;
		break;
		case usiCcd1VodMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VodMon = usiValue;
		break;
		case usiCcd1VogMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VogMon = usiValue;
		break;
		case usiCcd1VrdMonE:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VrdMonE = usiValue;
		break;
		case usiCcd2VodMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VodMon = usiValue;
		break;
		case usiCcd2VogMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VogMon = usiValue;
		break;
		case usiCcd2VrdMonE:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VrdMonE = usiValue;
		break;
		case usiCcd3VodMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VodMon = usiValue;
		break;
		case usiCcd3VogMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VogMon = usiValue;
		break;
		case usiCcd3VrdMonE:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VrdMonE = usiValue;
		break;
		case usiCcd4VodMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VodMon = usiValue;
		break;
		case usiCcd4VogMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VogMon = usiValue;
		break;
		case usiCcd4VrdMonE:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VrdMonE = usiValue;
		break;
		case usiVccd:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVccd = usiValue;
		break;
		case usiVrclkMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVrclkMon = usiValue;
		break;
		case usiViclk:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiViclk = usiValue;
		break;
		case usiVrclkLow:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVrclkLow = usiValue;
		break;
		case usi5vbPosMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi5vbPosMon = usiValue;
		break;
		case usi5vbNegMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi5vbNegMon = usiValue;
		break;
		case usi3v3bMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi3v3bMon = usiValue;
		break;
		case usi2v5aMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi2v5aMon = usiValue;
		break;
		case usi3v3dMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi3v3dMon = usiValue;
		break;
		case usi2v5dMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi2v5dMon = usiValue;
		break;
		case usi1v5dMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi1v5dMon = usiValue;
		break;
		case usi5vrefMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usi5vrefMon = usiValue;
		break;
		case usiVccdPosRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVccdPosRaw = usiValue;
		break;
		case usiVclkPosRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVclkPosRaw = usiValue;
		break;
		case usiVan1PosRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVan1PosRaw = usiValue;
		break;
		case usiVan3NegMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVan3NegMon = usiValue;
		break;
		case usiVan2PosRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVan2PosRaw = usiValue;
		break;
		case usiVdigRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVdigRaw = usiValue;
		break;
		case usiVdigRaw2:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiVdigRaw2 = usiValue;
		break;
		case usiViclkLow:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiViclkLow = usiValue;
		break;
		case usiCcd1VrdMonF:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VrdMonF = usiValue;
		break;
		case usiCcd1VddMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VddMon = usiValue;
		break;
		case usiCcd1VgdMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd1VgdMon = usiValue;
		break;
		case usiCcd2VrdMonF:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VrdMonF = usiValue;
		break;
		case usiCcd2VddMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VddMon = usiValue;
		break;
		case usiCcd2VgdMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd2VgdMon = usiValue;
		break;
		case usiCcd3VrdMonF:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VrdMonF = usiValue;
		break;
		case usiCcd3VddMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VddMon = usiValue;
		break;
		case usiCcd3VgdMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd3VgdMon = usiValue;
		break;
		case usiCcd4VrdMonF:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VrdMonF = usiValue;
		break;
		case usiCcd4VddMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VddMon = usiValue;
		break;
		case usiCcd4VgdMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiCcd4VgdMon = usiValue;
		break;
		case usiIgHiMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiIgHiMon = usiValue;
		break;
		case usiIgLoMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiIgLoMon = usiValue;
		break;
		case usiTsenseA:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTsenseA = usiValue;
		break;
		case usiTsenseB:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliHkAreaBaseAddr->usiTsenseB = usiValue;
		break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage )
				fprintf(fp, "HK update: HK ID out of bounds: %hu;\n", usiID );
			#endif
		break;
	}

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
	unsigned char ucIcounter;

	ucIcounter = 0;
	switch (ucId) {
		case 0:
			while ( ((bFeebGetCh1LeftFeeBusy()== TRUE) || (bFeebGetCh1RightFeeBusy()== TRUE)) && (ucIcounter<10) ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 1:
			while ( ((bFeebGetCh2LeftFeeBusy()== TRUE) || (bFeebGetCh2RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 2:
			while ( ((bFeebGetCh3LeftFeeBusy()== TRUE) || (bFeebGetCh3RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 3:
			while ( ((bFeebGetCh4LeftFeeBusy()== TRUE) || (bFeebGetCh4RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 4:
			while ( ((bFeebGetCh5LeftFeeBusy()== TRUE) || (bFeebGetCh5RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 5:
			while ( ((bFeebGetCh6LeftFeeBusy()== TRUE) || (bFeebGetCh6RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
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

//#if DEBUG_ON
//if ( xDefaults.usiDebugLevel <= dlMajorMessage )
//	fprintf(fp,"\nDoubleBufferP \n");
//#endif

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
	xSPW->xSpwcLinkConfig.bLinkStart = FALSE;
	xSPW->xSpwcLinkConfig.bAutostart = FALSE;
	xSPW->xSpwcLinkConfig.bDisconnect = TRUE;
	bSpwcSetLink(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableSPWChannel( TSpwcChannel *xSPW ) {
	/* Enable SPW channel */
	bSpwcGetLink(xSPW);
	xSPW->xSpwcLinkConfig.bLinkStart = FALSE;
	xSPW->xSpwcLinkConfig.bAutostart = TRUE;
	xSPW->xSpwcLinkConfig.bDisconnect = FALSE;
	bSpwcSetLink(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableDbBuffer( TNFee *pxNFeeP, TFeebChannel *pxFeebCh ) {
	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);
	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);
	/* Start the module Double Buffer */
	bFeebStartCh(pxFeebCh);

	/*Enable IRQ of FEE Buffer*/
	bFeebGetMachineControl(pxFeebCh);
	//pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
	pxFeebCh->xFeebMachineControl.bDataControllerEn = xDefaults.bDataPacket;
	pxFeebCh->xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
	bFeebSetMachineControl(pxFeebCh);

	/*Enable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xFeebIrqControl.bLeftBufferEmptyEn = TRUE;
	pxFeebCh->xFeebIrqControl.bRightBufferEmptyEn = TRUE;
	bFeebSetIrqControl(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}


bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh ) {

	/*Disable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xFeebIrqControl.bLeftBufferEmptyEn = FALSE;
	pxFeebCh->xFeebIrqControl.bRightBufferEmptyEn = FALSE;
	bFeebSetIrqControl(pxFeebCh);

	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);

	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);
	bFeebStartCh(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}


/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinModeOn( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];

	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)
			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder1stCcd;
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiPacketSize;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);


			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet

			/*Enable IRQ of FEE Buffer*/
			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			break;
		case 0x18:// reg_6_config
		case 0x1C:// reg_7_config
		case 0x20:// reg_8_config
		case 0x24:// reg_9_config
		case 0x28:// reg_10_config
		case 0x2C:// reg_11_config
		case 0x30:// reg_12_config
		case 0x34:// reg_13_config
		case 0x38:// reg_14_config
		case 0x3C:// reg_15_config
		case 0x40:// reg_16_config
		case 0x44:// reg_17_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x48:// reg_18_config
		case 0x4C:// reg_19_config
		case 0x50:// reg_20_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x54:// reg_21_config -> h_start[11:0], ccd_mode_config[3:0], reg_21_config_reserved[2:0], clear_error_flag(0)
			pxNFeeP->xMemMap.xCommon.ulHStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig ) {
				case 0x00: /*Mode On*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Already in this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case 0x01: /*Full Image Pattern Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;

					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sOn_Enter;
					pxNFeeP->xControl.eMode = sFullPattern;
					/* Real State */
					pxNFeeP->xControl.eState = sFullPattern_Enter;
					break;
				case 0x02: /*Windowing-Pattern-Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;

					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sOn_Enter;
					pxNFeeP->xControl.eMode = sWinPattern;
					/* Real State */
					pxNFeeP->xControl.eState = sWinPattern_Enter;
					break;
				case 0x04: /*Stand-By-Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;

					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sOn_Enter;
					pxNFeeP->xControl.eMode = sStandBy;
					pxNFeeP->xControl.eNextMode = sStandby_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sWaitSync;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					break;
				case 0x05: /*Windowing-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case 0x06: /*Full Image Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case 0x07: /*Performance test mode -windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x08: /*Slow Readout-Windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Slow Readout-Windowing Mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x09: /*Parallel trap pumping mode 1 - Full-Image*/
				case 0x0A: /*Parallel trap pumping mode 2 - Full-Image*/
				case 0x0B: /*Serial trap pumping mode 1- Full Image*/
				case 0x0C: /*Serial trap pumping mode 2- Full Image*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case 0x0D: /*Immediate On-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Already in this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case 0x0E: /*Reserved*/
				case 0x0F: /*Reserved*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig);
					}
					#endif
			}
			break;
		case 0x58:// reg_22_config
		case 0x5C:// reg_23_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Reserved area.\n\n", ucADDRReg);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not recognised.\n\n", ucADDRReg);
			}
			#endif
			break;
	}
}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPBeforeSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];

	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)
			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder1stCcd;
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiPacketSize;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);


			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet

			/*Enable IRQ of FEE Buffer*/
			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			break;
		case 0x18:// reg_6_config
		case 0x1C:// reg_7_config
		case 0x20:// reg_8_config
		case 0x24:// reg_9_config
		case 0x28:// reg_10_config
		case 0x2C:// reg_11_config
		case 0x30:// reg_12_config
		case 0x34:// reg_13_config
		case 0x38:// reg_14_config
		case 0x3C:// reg_15_config
		case 0x40:// reg_16_config
		case 0x44:// reg_17_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x48:// reg_18_config
		case 0x4C:// reg_19_config
		case 0x50:// reg_20_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x54:// reg_21_config -> h_start[11:0], ccd_mode_config[3:0], reg_21_config_reserved[2:0], clear_error_flag(0)
			pxNFeeP->xMemMap.xCommon.ulHStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig ) {
				case 0x00: /*Mode On*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						/* If a transition to On was requested when the FEE is waiting to go to Calibration,
						 * configure the hardware to not send any data in the next sync */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

						pxNFeeP->xControl.eState = redoutWaitSync;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x01: /*Full Image Pattern Mode*/
				case 0x02: /*Windowing-Pattern-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x04: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
						pxNFeeP->xControl.eState = redoutWaitSync;

						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
							fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
						#endif
					}
					break;
				case 0x05: /*Windowing-Mode*/
				case 0x06: /*Full Image Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x07: /*Performance test mode -windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x08: /*Slow Readout-Windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Slow Readout-Windowing Mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x09: /*Parallel trap pumping mode 1 - Full-Image*/
				case 0x0A: /*Parallel trap pumping mode 2 - Full-Image*/
				case 0x0B: /*Serial trap pumping mode 1- Full Image*/
				case 0x0C: /*Serial trap pumping mode 2- Full Image*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x0D: /*Immediate On-Mode*/
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eLastMode = sConfig_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sOn_Enter;
					pxNFeeP->xControl.eState = sOn_Enter;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					/*don't need side*/
					bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
					break;
				case 0x0E: /*Reserved*/
				case 0x0F: /*Reserved*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig);
					}
					#endif
					break;
			}
			break;
		case 0x58:// reg_22_config
		case 0x5C:// reg_23_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Reserved area.\n\n", ucADDRReg);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not recognised.\n\n", ucADDRReg);
			}
			#endif
			break;
		}
}


/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinWaitingMemUpdate( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];

	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)
			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder1stCcd;
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiPacketSize;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);


			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet

			/*Enable IRQ of FEE Buffer*/
			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			break;
		case 0x18:// reg_6_config
		case 0x1C:// reg_7_config
		case 0x20:// reg_8_config
		case 0x24:// reg_9_config
		case 0x28:// reg_10_config
		case 0x2C:// reg_11_config
		case 0x30:// reg_12_config
		case 0x34:// reg_13_config
		case 0x38:// reg_14_config
		case 0x3C:// reg_15_config
		case 0x40:// reg_16_config
		case 0x44:// reg_17_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x48:// reg_18_config
		case 0x4C:// reg_19_config
		case 0x50:// reg_20_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x54:// reg_21_config -> h_start[11:0], ccd_mode_config[3:0], reg_21_config_reserved[2:0], clear_error_flag(0)
			pxNFeeP->xMemMap.xCommon.ulHStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig ) {
				case 0x00: /*Mode On*/
					/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
						pxNFeeP->xControl.eState = redoutWaitSync;

						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x01: /*Full Image Pattern Mode*/
				case 0x02: /*Windowing-Pattern-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x04: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
						pxNFeeP->xControl.eState = redoutWaitSync;

						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x05: /*Windowing-Mode*/
				case 0x06: /*Full Image Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x07: /*Performance test mode -windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x08: /*Slow Readout-Windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Slow Readout-Windowing Mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x09: /*Parallel trap pumping mode 1 - Full-Image*/
				case 0x0A: /*Parallel trap pumping mode 2 - Full-Image*/
				case 0x0B: /*Serial trap pumping mode 1- Full Image*/
				case 0x0C: /*Serial trap pumping mode 2- Full Image*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x0D: /*Immediate On-Mode*/
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eLastMode = sConfig_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sOn_Enter;
					pxNFeeP->xControl.eState = sOn_Enter;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					/*don't need side*/
					bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
					break;
				case 0x0E: /*Reserved*/
				case 0x0F: /*Reserved*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig);
					}
					#endif
					break;
			}
			break;
		case 0x58:// reg_22_config
		case 0x5C:// reg_23_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Reserved area.\n\n", ucADDRReg);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not recognised.\n\n", ucADDRReg);
			}
			#endif
			break;
	}
}


/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinStandBy( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];

	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)
			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder1stCcd;
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiPacketSize;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);


			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet

			/*Enable IRQ of FEE Buffer*/
			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			break;
		case 0x18:// reg_6_config
		case 0x1C:// reg_7_config
		case 0x20:// reg_8_config
		case 0x24:// reg_9_config
		case 0x28:// reg_10_config
		case 0x2C:// reg_11_config
		case 0x30:// reg_12_config
		case 0x34:// reg_13_config
		case 0x38:// reg_14_config
		case 0x3C:// reg_15_config
		case 0x40:// reg_16_config
		case 0x44:// reg_17_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x48:// reg_18_config
		case 0x4C:// reg_19_config
		case 0x50:// reg_20_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x54:// reg_21_config -> h_start[11:0], ccd_mode_config[3:0], reg_21_config_reserved[2:0], clear_error_flag(0)
			pxNFeeP->xMemMap.xCommon.ulHStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig ) {
				case 0x00: /*Mode On*/
					pxNFeeP->xControl.bWatingSync = TRUE;

					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sOn_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sWaitSync;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					break;
				case 0x01: /*Full Image Pattern Mode*/
				case 0x02: /*Windowing-Pattern-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Stand-By Mode)\n\n");
					}
					#endif
					break;
				case 0x04: /*Stand-By-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Already in this mode. (Stand-By Mode)\n\n");
					}
					#endif
					break;
				case 0x05: /*Windowing-Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sWindowing;
					/* Real State */
					pxNFeeP->xControl.eState = sWindowing_Enter;
					break;
				case 0x06: /*Full Image Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sFullImage;
					/* Real State */
					pxNFeeP->xControl.eState = sFullImage_Enter;
					break;
				case 0x07: /*Performance test mode -windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x08: /*Slow Readout-Windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Slow Readout-Windowing Mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x09: /*Parallel trap pumping mode 1 - Full-Image*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sParTrap1;
					/* Real State */
					pxNFeeP->xControl.eState = sParTrap1_Enter;
					break;
				case 0x0A: /*Parallel trap pumping mode 2 - Full-Image*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sParTrap2;
					/* Real State */
					pxNFeeP->xControl.eState = sParTrap2_Enter;
					break;
				case 0x0B: /*Serial trap pumping mode 1- Full Image*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sSerialTrap1;
					/* Real State */
					pxNFeeP->xControl.eState = sSerialTrap1_Enter;
					break;
				case 0x0C: /*Serial trap pumping mode 2- Full Image*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sSerialTrap2;
					/* Real State */
					pxNFeeP->xControl.eState = sSerialTrap2_Enter;
					break;
				case 0x0D: /*Immediate On-Mode*/
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sOn_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sOn_Enter;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					break;
				case 0x0E: /*Reserved*/
				case 0x0F: /*Reserved*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig);
					}
					#endif
			}
			break;
		case 0x58:// reg_22_config
		case 0x5C:// reg_23_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Reserved area.\n\n", ucADDRReg);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not recognised.\n\n", ucADDRReg);
			}
			#endif
			break;
		}

}


/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPWaitingSync( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];

	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)
			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder1stCcd;
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiPacketSize;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);


			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet

			/*Enable IRQ of FEE Buffer*/
			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			break;
		case 0x18:// reg_6_config
		case 0x1C:// reg_7_config
		case 0x20:// reg_8_config
		case 0x24:// reg_9_config
		case 0x28:// reg_10_config
		case 0x2C:// reg_11_config
		case 0x30:// reg_12_config
		case 0x34:// reg_13_config
		case 0x38:// reg_14_config
		case 0x3C:// reg_15_config
		case 0x40:// reg_16_config
		case 0x44:// reg_17_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x48:// reg_18_config
		case 0x4C:// reg_19_config
		case 0x50:// reg_20_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x54:// reg_21_config -> h_start[11:0], ccd_mode_config[3:0], reg_21_config_reserved[2:0], clear_error_flag(0)
			pxNFeeP->xMemMap.xCommon.ulHStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig ) {
				case 0x00: /*Mode On*/
				case 0x01: /*Full Image Pattern Mode*/
				case 0x02: /*Windowing-Pattern-Mode*/
				case 0x04: /*Stand-By-Mode*/
				case 0x05: /*Windowing-Mode*/
				case 0x06: /*Full Image Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Can't perform this command, already processing a changing action.\n\n");
					}
					#endif
					break;
				case 0x07: /*Performance test mode -windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x08: /*Slow Readout-Windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Slow Readout-Windowing Mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x09: /*Parallel trap pumping mode 1 - Full-Image*/
				case 0x0A: /*Parallel trap pumping mode 2 - Full-Image*/
				case 0x0B: /*Serial trap pumping mode 1- Full Image*/
				case 0x0C: /*Serial trap pumping mode 2- Full Image*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Can't perform this command, already processing a changing action.\n\n");
					}
					#endif
					break;
				case 0x0D: /*Immediate On-Mode*/
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eLastMode = sConfig_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sOn_Enter;
					pxNFeeP->xControl.eState = sOn_Enter;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					/*don't need side*/
					bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
					break;
				case 0x0E: /*Reserved*/
				case 0x0F: /*Reserved*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig);
					}
					#endif
			}
			break;
		case 0x58:// reg_22_config
		case 0x5C:// reg_23_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Reserved area.\n\n", ucADDRReg);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not recognised.\n\n", ucADDRReg);
			}
			#endif
			break;
	}
}


//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPReadoutSync( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];

	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)
			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder1stCcd;
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiPacketSize;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);


			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet

			/*Enable IRQ of FEE Buffer*/
			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			break;
		case 0x18:// reg_6_config
		case 0x1C:// reg_7_config
		case 0x20:// reg_8_config
		case 0x24:// reg_9_config
		case 0x28:// reg_10_config
		case 0x2C:// reg_11_config
		case 0x30:// reg_12_config
		case 0x34:// reg_13_config
		case 0x38:// reg_14_config
		case 0x3C:// reg_15_config
		case 0x40:// reg_16_config
		case 0x44:// reg_17_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x48:// reg_18_config
		case 0x4C:// reg_19_config
		case 0x50:// reg_20_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x54:// reg_21_config -> h_start[11:0], ccd_mode_config[3:0], reg_21_config_reserved[2:0], clear_error_flag(0)
			pxNFeeP->xMemMap.xCommon.ulHStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig ) {
				case 0x00: /*Mode On*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						/* If a transition to On was requested when the FEE is waiting to go to Calibration,
						 * configure the hardware to not send any data in the next sync */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

						pxNFeeP->xControl.eState = redoutWaitSync;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x01: /*Full Image Pattern Mode*/
				case 0x02: /*Windowing-Pattern-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x04: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
						pxNFeeP->xControl.eState = redoutWaitSync;

						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x05: /*Windowing-Mode*/
				case 0x06: /*Full Image Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x07: /*Performance test mode -windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x08: /*Slow Readout-Windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Slow Readout-Windowing Mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x09: /*Parallel trap pumping mode 1 - Full-Image*/
				case 0x0A: /*Parallel trap pumping mode 2 - Full-Image*/
				case 0x0B: /*Serial trap pumping mode 1- Full Image*/
				case 0x0C: /*Serial trap pumping mode 2- Full Image*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x0D: /*Immediate On-Mode*/
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eLastMode = sConfig_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sOn_Enter;
					pxNFeeP->xControl.eState = sOn_Enter;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					/*don't need side*/
					bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
					break;
				case 0x0E: /*Reserved*/
				case 0x0F: /*Reserved*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig);
					}
					#endif
			}
			break;
		case 0x58:// reg_22_config
		case 0x5C:// reg_23_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Reserved area.\n\n", ucADDRReg);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not recognised.\n\n", ucADDRReg);
			}
			#endif
			break;
	}
}



//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinReadoutTrans( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];


	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)
			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder1stCcd;
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiPacketSize;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);


			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet

			/*Enable IRQ of FEE Buffer*/
			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			break;
		case 0x18:// reg_6_config
		case 0x1C:// reg_7_config
		case 0x20:// reg_8_config
		case 0x24:// reg_9_config
		case 0x28:// reg_10_config
		case 0x2C:// reg_11_config
		case 0x30:// reg_12_config
		case 0x34:// reg_13_config
		case 0x38:// reg_14_config
		case 0x3C:// reg_15_config
		case 0x40:// reg_16_config
		case 0x44:// reg_17_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x48:// reg_18_config
		case 0x4C:// reg_19_config
		case 0x50:// reg_20_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x54:// reg_21_config -> h_start[11:0], ccd_mode_config[3:0], reg_21_config_reserved[2:0], clear_error_flag(0)
			pxNFeeP->xMemMap.xCommon.ulHStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig ) {
				case 0x00: /*Mode On*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x01: /*Full Image Pattern Mode*/
				case 0x02: /*Windowing-Pattern-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x04: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x05: /*Windowing-Mode*/
				case 0x06: /*Full Image Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x07: /*Performance test mode -windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x08: /*Slow Readout-Windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Slow Readout-Windowing Mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x09: /*Parallel trap pumping mode 1 - Full-Image*/
				case 0x0A: /*Parallel trap pumping mode 2 - Full-Image*/
				case 0x0B: /*Serial trap pumping mode 1- Full Image*/
				case 0x0C: /*Serial trap pumping mode 2- Full Image*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x0D: /*Immediate On-Mode*/
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eLastMode = sConfig_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sOn_Enter;
					pxNFeeP->xControl.eState = sOn_Enter;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					/*don't need side*/
					bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
					break;
				case 0x0E: /*Reserved*/
				case 0x0F: /*Reserved*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig);
					}
					#endif
			}
			break;
		case 0x58:// reg_22_config
		case 0x5C:// reg_23_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Reserved area.\n\n", ucADDRReg);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not recognised.\n\n", ucADDRReg);
			}
			#endif
			break;
	}
}


//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinPreLoadBuffer( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];

	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)
			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiVEnd;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder1stCcd;
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiPacketSize;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);


			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet

			/*Enable IRQ of FEE Buffer*/
			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->bDigitiseEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			break;
		case 0x18:// reg_6_config
		case 0x1C:// reg_7_config
		case 0x20:// reg_8_config
		case 0x24:// reg_9_config
		case 0x28:// reg_10_config
		case 0x2C:// reg_11_config
		case 0x30:// reg_12_config
		case 0x34:// reg_13_config
		case 0x38:// reg_14_config
		case 0x3C:// reg_15_config
		case 0x40:// reg_16_config
		case 0x44:// reg_17_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x48:// reg_18_config
		case 0x4C:// reg_19_config
		case 0x50:// reg_20_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x54:// reg_21_config -> h_start[11:0], ccd_mode_config[3:0], reg_21_config_reserved[2:0], clear_error_flag(0)
			pxNFeeP->xMemMap.xCommon.ulHStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->usiHStart;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig ) {
				case 0x00: /*Mode On*/
					/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
						pxNFeeP->xControl.eState = redoutWaitSync;

						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x01: /*Full Image Pattern Mode*/
				case 0x02: /*Windowing-Pattern-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x04: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
						pxNFeeP->xControl.eState = redoutWaitSync;

						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case 0x05: /*Windowing-Mode*/
				case 0x06: /*Full Image Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x07: /*Performance test mode -windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x08: /*Slow Readout-Windowing*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Slow Readout-Windowing Mode not implemented.\n\n");
					}
					#endif
					break;
				case 0x09: /*Parallel trap pumping mode 1 - Full-Image*/
				case 0x0A: /*Parallel trap pumping mode 2 - Full-Image*/
				case 0x0B: /*Serial trap pumping mode 1- Full Image*/
				case 0x0C: /*Serial trap pumping mode 2- Full Image*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case 0x0D: /*Immediate On-Mode*/
					pxNFeeP->xControl.bWatingSync = FALSE;
					pxNFeeP->xControl.eLastMode = sConfig_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sOn_Enter;
					pxNFeeP->xControl.eState = sOn_Enter;

					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

					/*don't need side*/
					bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
					break;
				case 0x0E: /*Reserved*/
				case 0x0F: /*Reserved*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaAddr.puliConfigAreaBaseAddr->ucCcdModeConfig);
					}
					#endif
					break;
			}
			break;
		case 0x58:// reg_22_config
		case 0x5C:// reg_23_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Reserved area.\n\n", ucADDRReg);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not recognised.\n\n", ucADDRReg);
			}
			#endif
			break;
	}
}
