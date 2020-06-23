/*
 * fee_taskV2.c
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */


#include "fee_taskV3.h"



void vFeeTaskV3(void *task_data) {
	TNFee *pxNFee;
	INT8U error_code;
	volatile INT8U ucRetries;
	float fTimesSyncL, fDiffL;
	tQMask uiCmdFEE;
	volatile TFEETransmission xTrans;
	unsigned char ucEL = 0, ucSideFromMSG = 0;


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

				/*0..4559*/
				pxNFee->xMemMap.xCommon.ulVStart = pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
				pxNFee->xMemMap.xCommon.ulVEnd = pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;
				/*0..2294*/
				pxNFee->xMemMap.xCommon.ulHStart = 0;
				pxNFee->xMemMap.xCommon.ulHEnd = pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;

				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdVStart = pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdVEnd = pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

				pxNFee->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFee->xMemMap.xCommon.ulHEnd;
				pxNFee->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFee->xMemMap.xCommon.ulVStart;
				pxNFee->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFee->xMemMap.xCommon.ulVEnd;

				bFeebGetMachineControl(&pxNFee->xChannel.xFeeBuffer);
				//pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
				pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bBufferOverflowEn = xDefaults.bBufferOverflowEn;
				pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = TRUE;
				pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bReadoutEn = TRUE;
				pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
				bFeebSetMachineControl(&pxNFee->xChannel.xFeeBuffer);

				pxNFee->xCopyRmap.bCopyDigitaliseEn = pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn;
				pxNFee->xCopyRmap.bCopyReadoutEn = pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bReadoutEn;

				/* Clear all FEE Machine Statistics */
				bFeebClearMachineStatistics(&pxNFee->xChannel.xFeeBuffer);

				pxNFee->xControl.eState = sConfig_Enter;
				break;

			case sConfig_Enter:/* Transition */

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Config Mode\n", pxNFee->ucId);
				}
				#endif

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x00; /*Off*/
				bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

				/* Disable the link SPW */
				bDisableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = FALSE;
//				bSetPainelLeds( LEDS_OFF , uliReturnMaskG( pxNFee->ucSPWId ) );
//				bSetPainelLeds( LEDS_ON , uliReturnMaskR( pxNFee->ucSPWId ) );

				/* Disable RMAP interrupts */
				bDisableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucSPWId);

				/* Reset Channel DMAs */
				bSdmaResetCommDma(pxNFee->ucSPWId, eSdmaLeftBuffer, TRUE);
				bSdmaResetCommDma(pxNFee->ucSPWId, eSdmaRightBuffer, TRUE);

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
				pxNFee->xControl.bTransientMode = TRUE;

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

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

				/*Restore time delays*/
				bDpktGetPixelDelay(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliAdcDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliStartDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliSkipDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliSkipDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliLineDelay;
				bDpktSetPixelDelay(&pxNFee->xChannel.xDataPacket);


				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = sConfig;
				break;

			case sConfig:

				/*Wait for message in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinConfig( pxNFee, uiCmdFEE.ulWord );
				} else {
					/* Send Error to NUC */
					vLogSendErrorChars(54,10+ pxNFee->ucId,error_code,1);
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
				bRmapGetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x00; /*On mode*/
				bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

				/* Reset Channel DMAs */
				bSdmaResetCommDma(pxNFee->ucSPWId, eSdmaLeftBuffer, TRUE);
				bSdmaResetCommDma(pxNFee->ucSPWId, eSdmaRightBuffer, TRUE);

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Enable RMAP interrupts */
				bEnableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucId);

				/* Enable the link SPW */
				bEnableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = TRUE;
//				bSetPainelLeds( LEDS_OFF , uliReturnMaskR( pxNFee->ucSPWId ) );
//				bSetPainelLeds( LEDS_ON , uliReturnMaskG( pxNFee->ucSPWId ) );

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

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

				/*Restore time delays*/
				bDpktGetPixelDelay(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliAdcDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliStartDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliSkipDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliSkipDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliLineDelay;
				bDpktSetPixelDelay(&pxNFee->xChannel.xDataPacket);

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
					/* Send Error to NUC */
					vLogSendErrorChars(54,10+ pxNFee->ucId,error_code,1);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;


			case sStandby_Enter:

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				bRmapGetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
				pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x04; /*sFeeStandBy*/
				bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);

				/* [rfranca] */
				/* removed for Tiago in 15/12 */
				/*
				bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
				bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);
				 */

				/* Disable IRQ and clear the Double Buffer */
				bDisAndClrDbBuffer(&pxNFee->xChannel.xFeeBuffer);

				/* Disable RMAP interrupts */
				bEnableRmapIRQ(&pxNFee->xChannel.xRmap, pxNFee->ucId);

				/* Enable the link SPW */
				bEnableSPWChannel( &pxNFee->xChannel.xSpacewire );
				pxNFee->xControl.bChannelEnable = TRUE;
//				bSetPainelLeds( LEDS_OFF , uliReturnMaskR( pxNFee->ucSPWId ) );
//				bSetPainelLeds( LEDS_ON , uliReturnMaskG( pxNFee->ucSPWId ) );


				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Standby\n", pxNFee->ucId);
				}
				#endif

				pxNFee->xControl.xTrap.bEnabled = FALSE;
				pxNFee->xControl.bUsingDMA = FALSE;

				pxNFee->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = pxNFee->xControl.eMode;
				pxNFee->xControl.eMode = sStandBy;
				pxNFee->xControl.eNextMode = sStandBy;

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

				/*Restore time delays*/
				bDpktGetPixelDelay(&pxNFee->xChannel.xDataPacket);
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliAdcDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliStartDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliSkipDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliSkipDelay;
				pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliLineDelay;
				bDpktSetPixelDelay(&pxNFee->xChannel.xDataPacket);

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = sStandBy;
				break;


			case sStandBy:
				/*Wait for commands in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinStandBy( pxNFee, uiCmdFEE.ulWord );
				} else {
					/* Send Error to NUC */
					vLogSendErrorChars(54,10+ pxNFee->ucId,error_code,1);
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
					/* Send Error to NUC */
					vLogSendErrorChars(54,81,error_code,1);
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
					fprintf(fp,"NFEE-%hu Task: Going to FullImage Pattern.\n", pxNFee->ucId);
				}
				#endif

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sOn_Enter;
				pxNFee->xControl.eMode = sFullPattern;
				pxNFee->xControl.eNextMode = sFullPattern;
				/* Real State */

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;

			case sWinPattern_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"NFEE-%hu Task: Going to Windowing Pattern.\n", pxNFee->ucId);
				}
				#endif

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, pxNFee->xControl.eState );

				pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucSensorSel = eRmapSenSelEFBoth;

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sOn_Enter;
				pxNFee->xControl.eMode = sWinPattern;
				pxNFee->xControl.eNextMode = sWinPattern;
				/* Real State */

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

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
				pxNFee->xControl.eNextMode = sFullImage;
				/* Real State */

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

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

				pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucSensorSel = eRmapSenSelEFBoth;

				/* Real Fee State (graph) */
				pxNFee->xControl.eLastMode = sStandby_Enter;
				pxNFee->xControl.eMode = sWindowing;
				pxNFee->xControl.eNextMode = sWindowing;
				/* Real State */

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

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
				pxNFee->xControl.eNextMode = sParTrap1;
				/* Real State */

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = TRUE;


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
				pxNFee->xControl.eNextMode = sParTrap2;
				/* Real State */

				pxNFee->xControl.xTrap.bEnabledSerial = FALSE;
				pxNFee->xControl.xTrap.bEnabled = TRUE;

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
				pxNFee->xControl.eNextMode = sSerialTrap1;
				/* Real State */

				pxNFee->xControl.xTrap.bEnabledSerial = TRUE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

				/*Copy time delays*/
				bDpktGetPixelDelay(&pxNFee->xChannel.xDataPacket);
				pxNFee->xControl.xTrap.xRestoreDelays.uliAdcDelay = pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay;
				pxNFee->xControl.xTrap.xRestoreDelays.uliStartDelay = pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay;
				pxNFee->xControl.xTrap.xRestoreDelays.uliSkipDelay = pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliSkipDelay;
				pxNFee->xControl.xTrap.xRestoreDelays.uliLineDelay = pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay;

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
				pxNFee->xControl.eNextMode = sSerialTrap2;
				/* Real State */

				pxNFee->xControl.xTrap.bEnabledSerial = TRUE;
				pxNFee->xControl.xTrap.bEnabled = FALSE;

				/*Copy time delays*/
				bDpktGetPixelDelay(&pxNFee->xChannel.xDataPacket);
				pxNFee->xControl.xTrap.xRestoreDelays.uliAdcDelay = pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay;
				pxNFee->xControl.xTrap.xRestoreDelays.uliStartDelay = pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay;
				pxNFee->xControl.xTrap.xRestoreDelays.uliSkipDelay = pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliSkipDelay;
				pxNFee->xControl.xTrap.xRestoreDelays.uliLineDelay = pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay;

				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.eState = redoutCycle_Enter;
				break;




/*============================== Readout Cycle Implementation ========================*/



			case redoutCycle_Enter:

				/* Indicates that this FEE will now need to use DMA*/
				pxNFee->xControl.bUsingDMA = TRUE;
				xTrans.bFirstT = TRUE;
				pxNFee->xControl.bTransientMode = TRUE;

				pxNFee->xControl.xTrap.bPumping = FALSE;
				pxNFee->xControl.xTrap.bEmiting = FALSE;


				if (xGlobal.bJustBeforSync == FALSE)
					pxNFee->xControl.eState = redoutWaitBeforeSyncSignal;
				else
					pxNFee->xControl.eState = redoutCheckRestr;

				break;

				/*Pre Sync*/
			case redoutWaitBeforeSyncSignal:


				/*Will wait for the Before sync signal, probably in this state it will need to treat many RMAP commands*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdWaitBeforeSyncSignal( pxNFee, uiCmdFEE.ulWord );
				} else {
					/* Send Error to NUC */
					vLogSendErrorChars(54,10+ pxNFee->ucId,error_code,1);
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

				/*The Meb My have sent a message to inform the finish of the update of the image*/
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				/* Wait until both buffers are empty  */
				vWaitUntilBufferEmpty( pxNFee->ucSPWId );
				/* Guard time that HW MAYBE need, this will be used during the development, will be removed in some future version*/
				OSTimeDlyHMSM(0, 0, 0, min_sim(xDefaults.usiGuardNFEEDelay,2)); //todo: For now fixed in 2 ms


				if (pxNFee->xControl.xTrap.bEnabled == TRUE) {
					/*TRAP Flow*/

					if ( TRUE == pxNFee->xControl.xTrap.bPumping ){
						/*|Count the cicle and check if is to go to emmiting*/

						pxNFee->xControl.xTrap.ucICountSyncs++;

						if ( pxNFee->xControl.xTrap.ucICountSyncs >= pxNFee->xControl.xTrap.usiNofSyncstoWait ){
							/*Already wait for all syncs*/

							pxNFee->xControl.xTrap.bEmiting = TRUE;
							pxNFee->xControl.xTrap.bPumping = FALSE;
							pxNFee->xControl.eState = redoutConfigureTrans;

						} else {
							/*Still wait for more syncs*/
							pxNFee->xControl.eState = redoutWaitBeforeSyncSignal;
						}


					} else {

						if ( TRUE == pxNFee->xControl.xTrap.bEmiting ) {
						/*Finishes the cicle, start a new one*/


							pxNFee->xControl.xTrap.bPumping = FALSE;
							pxNFee->xControl.xTrap.bEmiting = FALSE;

							/*Will check if is Master and if is to start all over again*/
							pxNFee->xControl.eState = redoutCheckRestr;
						} else {
							/*Not pumping and not emiting, then starting a new cicle*/
							/*Reset Fee Buffer every Master Sync*/
							if ( xGlobal.bPreMaster == TRUE ) {

								bRmapGetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
								pxNFee->xControl.xTrap.usiSH = pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiTrapPumpingShuffleCounter;
								// *20 ns (time unit from RAMP map config sheet)
								pxNFee->xControl.xTrap.uliDT = 20*pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliTrapPumpingDwellCounter;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);

								pxNFee->xControl.xTrap.dTotalWait = CHARGE_TIME+((900+pxNFee->xControl.xTrap.uliDT)*pxNFee->xControl.xTrap.usiSH-6.5)*0.000001;

								fTimesSyncL = pxNFee->xControl.xTrap.dTotalWait / DEFAULT_SYNC_TIME;

								fDiffL = fTimesSyncL - (int)fTimesSyncL;

								if ( fDiffL == 0) {
									/*Ecxatly the sync modulos modulus*/
									pxNFee->xControl.xTrap.usiNofSyncstoWait = (unsigned short int)fTimesSyncL;
								} else {
									pxNFee->xControl.xTrap.usiNofSyncstoWait = (unsigned short int)fTimesSyncL + 1;
								}

								pxNFee->xControl.xTrap.ucICountSyncs = 0;

								/* Update DataPacket with the information of actual readout information*/
								bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
								switch (pxNFee->xControl.eMode) {
									case sParTrap1:
										pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktParallelTrapPumping1Pump;
										break;
									case sParTrap2:
										pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktParallelTrapPumping2Pump;
										break;
									default:
										#if DEBUG_ON
										if ( xDefaults.usiDebugLevel <= dlMajorMessage )
											fprintf(fp,"\nNFEE-%hu Task: Mode not recognized: xDpktDataPacketConfig (Data Packet). Configuring On Mode.\n", pxNFee->ucId);
										#endif
										pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
										break;
								}
								bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);


								pxNFee->xControl.xTrap.bEmiting = FALSE;
								pxNFee->xControl.xTrap.bPumping = TRUE;
								pxNFee->xControl.eState = redoutWaitBeforeSyncSignal;

								/* Stop the module Double Buffer */
								bFeebStopCh(&pxNFee->xChannel.xFeeBuffer);
								/* Clear all buffer form the Double Buffer */
								bFeebClrCh(&pxNFee->xChannel.xFeeBuffer);
								/* Start the module Double Buffer */
								bFeebStartCh(&pxNFee->xChannel.xFeeBuffer);
							} else {
								pxNFee->xControl.eState = redoutWaitBeforeSyncSignal;
							}

						}

					}


				} else if ( pxNFee->xControl.xTrap.bEnabledSerial == TRUE ) {

					bRmapGetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
					pxNFee->xControl.xTrap.usiSH = pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiTrapPumpingShuffleCounter;
					// *20 ns (time unit from RAMP map config sheet)
					pxNFee->xControl.xTrap.uliDT = 20*pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliTrapPumpingDwellCounter;
					bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);

					/*Modify time delays*/
					bDpktGetPixelDelay(&pxNFee->xChannel.xDataPacket);
					pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay = uliPxDelayCalcPeriodMs( (alt_u32)(CHARGE_TIME * 1000) );
					pxNFee->xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay = pxNFee->xControl.xTrap.xRestoreDelays.uliLineDelay + uliPxDelayCalcPeriodNs( pxNFee->xControl.xTrap.uliDT + pxNFee->xControl.xTrap.usiSH );
					bDpktSetPixelDelay(&pxNFee->xChannel.xDataPacket);


					/* Update DataPacket with the information of actual readout information*/
					bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
					switch (pxNFee->xControl.eMode) {
						case sSerialTrap1:
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktSerialTrapPumping1;
							break;
						case sSerialTrap2:
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktSerialTrapPumping2;
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage )
								fprintf(fp,"\nNFEE-%hu Task: Mode not recognized: xDpktDataPacketConfig (Data Packet). Configuring On Mode.\n", pxNFee->ucId);
							#endif
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
							break;
					}
					bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);

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

				} else {
					/*Normal Flow*/
					
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
				}

				break;


			case redoutConfigureTrans:

				/*If is master sync, check if need to configure error*/
				if ( xGlobal.bPreMaster == TRUE ) {
					vApplyRmap(pxNFee);

					/*Check if this FEE is in Full*/
					if ( (pxNFee->xControl.eMode == sFullPattern) || (pxNFee->xControl.eMode == sFullImage)) {
						/*Check if there is any type of error enabled*/
						//bErrorInj = pxNFee->xControl.xErrorSWCtrl.bMissingData || pxNFee->xControl.xErrorSWCtrl.bMissingPkts || pxNFee->xControl.xErrorSWCtrl.bTxDisabled;

						bDpktGetErrorInjection(&pxNFee->xChannel.xDataPacket);
						pxNFee->xChannel.xDataPacket.xDpktErrorInjection.bMissingData = pxNFee->xControl.xErrorSWCtrl.bMissingData;
						pxNFee->xChannel.xDataPacket.xDpktErrorInjection.bMissingPkts = pxNFee->xControl.xErrorSWCtrl.bMissingPkts;
						pxNFee->xChannel.xDataPacket.xDpktErrorInjection.bTxDisabled = pxNFee->xControl.xErrorSWCtrl.bTxDisabled;
						pxNFee->xChannel.xDataPacket.xDpktErrorInjection.ucFrameNum = pxNFee->xControl.xErrorSWCtrl.ucFrameNum;
						pxNFee->xChannel.xDataPacket.xDpktErrorInjection.usiDataCnt = pxNFee->xControl.xErrorSWCtrl.usiDataCnt;
						pxNFee->xChannel.xDataPacket.xDpktErrorInjection.usiNRepeat = pxNFee->xControl.xErrorSWCtrl.usiNRepeat;
						pxNFee->xChannel.xDataPacket.xDpktErrorInjection.usiSequenceCnt = pxNFee->xControl.xErrorSWCtrl.usiSequenceCnt;
						bDpktSetErrorInjection(&pxNFee->xChannel.xDataPacket);
					}
				}

				/* Reset the memory control variables thats is used in the transmission*/
				vResetMemCCDFEE( pxNFee );

				pxNFee->xControl.bUsingDMA = TRUE;
				/*Since the default value of SensorSel Reg is both, need check if is some of Windowing Mode, otherwise overwrite with left*/
				if ( (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucSensorSel == eRmapSenSelEFBoth) ) { //both
					if ( (pxNFee->xControl.eMode == sWindowing) || (pxNFee->xControl.eMode == sWinPattern)){
						xTrans.side = sBoth;
					} else {
						xTrans.side = sLeft; /*sLeft = 0*/
						pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucSensorSel = eRmapSenSelELeft;
					}
				} else {
					if ( pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucSensorSel == eRmapSenSelELeft ) {
						xTrans.side = sLeft; /*sLeft = 0*/
					} else {
						// todo: error if a reserved value is used [rfranca]
						xTrans.side = sRight; /*sRight = 1*/
					}
				}

				/* Check which CCD should be send due to the configured readout order*/
				ucEL = (xGlobal.ucEP0_3 + 1) % 4;
				if (pxNFee->xControl.xTrap.bEnabled == TRUE)
					xTrans.ucCcdNumber = pxNFee->xControl.ucROutOrder[ 0 ]; /*Always get the first CCD*/
				else
					xTrans.ucCcdNumber = pxNFee->xControl.ucROutOrder[ ucEL ];

				/* Get the memory map values for this next readout*/
				xTrans.xCcdMapLocal[0] = &pxNFee->xMemMap.xCcd[ xTrans.ucCcdNumber ].xLeft;
				xTrans.xCcdMapLocal[1] = &pxNFee->xMemMap.xCcd[ xTrans.ucCcdNumber ].xRight;

				xTrans.xCcdMapLocal[0]->ulAddrI = xTrans.xCcdMapLocal[0]->ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST;
				xTrans.xCcdMapLocal[1]->ulAddrI = xTrans.xCcdMapLocal[1]->ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST;

				/* Check if need to change the memory */
				if ( ucEL == 0 )
					xTrans.ucMemory = (unsigned char) (( *pxNFee->xControl.pActualMem + 1 ) % 2) ; /* Select the other memory*/
				else
					xTrans.ucMemory = (unsigned char) ( *pxNFee->xControl.pActualMem );

				/* Tells to HW where is the packet oder list (before the image)*/
				bWindCopyMebWindowingParam(xTrans.xCcdMapLocal[0]->ulOffsetAddr, xTrans.ucMemory, pxNFee->ucId);

				/*For now is HardCoded, for a complete half CCD*/
				xTrans.ulAddrIni = 0; /*This will be the offset*/
				xTrans.ulAddrFinal = pxNFee->xMemMap.xCommon.usiTotalBytes;
				xTrans.ulTotalBlocks = pxNFee->xMemMap.xCommon.usiNTotalBlocks;
				/* For now is fixed by this define, but at any moment it could change*/
				//xTrans.ulSMD_MAX_BLOCKS = FEEB_MAX_BLOCKS;

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
						if ( pxNFee->xControl.eDataSource == dsPattern ) {
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePatternMode;
							pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						} else if ( pxNFee->xControl.eDataSource == dsSSD ) {
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImageSsdMode;
							pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
								fprintf(fp,"\nNFEE-%hu Task: Window Stack is not an option for Full Image Mode. Configuring Pattern instead!\n", pxNFee->ucId);
							#endif
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePatternMode;
							pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						}
						break;
					case sWindowing:
						if ( pxNFee->xControl.eDataSource == dsPattern ) {
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowingPatternMode;
							pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = TRUE;
						} else if ( pxNFee->xControl.eDataSource == dsSSD ) {
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowingSsdImgMode;
							pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = TRUE;
						} else {
							pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowingSsdWinMode;
							pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = TRUE;
						}

						break;
					case sParTrap1:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktParallelTrapPumping1Data;
						pxNFee->xChannel.xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
						break;
					case sParTrap2:
						pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktParallelTrapPumping2Data;
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

				ucRetries = 0;
				pxNFee->xControl.ucTransmited = 0;

				pxNFee->xControl.eState = redoutPreLoadBuffer;
				break;


			case redoutPreLoadBuffer:

				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* First Check if is access to the DMA (priority) */
					if ( uiCmdFEE.ucByte[2] == M_FEE_DMA_ACCESS ) {

						ucSideFromMSG = uiCmdFEE.ucByte[1];

						if (  xTrans.ucMemory == 0  ) {
							xTrans.bDmaReturn[ ucSideFromMSG ] = bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)xTrans.xCcdMapLocal[ucSideFromMSG]->ulAddrI, (alt_u32)xTrans.ulTotalBlocks, ucSideFromMSG, pxNFee->ucSPWId);

							if ( xTrans.bDmaReturn[ ucSideFromMSG ] == FALSE ) {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
									fprintf(fp,"\nNFEE-%hu Task: DMA Schedule fail, Side %u\n", pxNFee->ucId, ucSideFromMSG);
								}
								#endif
							}
						} else {
							xTrans.bDmaReturn[ ucSideFromMSG ] = bSdmaCommDmaTransfer(eDdr2Memory2, (alt_u32 *)xTrans.xCcdMapLocal[ucSideFromMSG]->ulAddrI, (alt_u32)xTrans.ulTotalBlocks*2, ucSideFromMSG, pxNFee->ucSPWId);

							if ( xTrans.bDmaReturn[ ucSideFromMSG ] == FALSE ) {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
									fprintf(fp,"\nNFEE-%hu Task: DMA Schedule fail, Side %u\n", pxNFee->ucId, ucSideFromMSG);
								}
								#endif
							}
						}

						if ( (xTrans.bDmaReturn[0] == TRUE) && (xTrans.bDmaReturn[1] == TRUE) ) {

							pxNFee->xControl.eState = redoutWaitSync;
							//pxNFee->xControl.eNextMode = redoutTransmission;

							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
								fprintf(fp,"NFEE-%hu Task: DMA Scheduled, Side %u\n", pxNFee->ucId, ucSideFromMSG);
							}
							#endif
						} else {

							if ( xTrans.bDmaReturn[ ucSideFromMSG ] == FALSE ) {

								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
									fprintf(fp,"NFEE-%hu Task: CRITICAL! Could not prepare the double buffer.\n", pxNFee->ucId);
								}
								#endif

								if ( ucRetries > 9) {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
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
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
										fprintf(fp,"NFEE %hhu Task: Retry DMA Scheduled request.\n", pxNFee->ucId);
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
							} else {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
									fprintf(fp,"NFEE-%hu Task: DMA Scheduled, Side %u\n", pxNFee->ucId, ucSideFromMSG);
								}
								#endif
							}
						}
					} else {
						/* Is not access to DMA, so we need to check what is this received command */
						vQCmdFEEinPreLoadBuffer( pxNFee, uiCmdFEE.ulWord );
					}

				} else {
					/* Send Error to NUC */
					vLogSendErrorChars(54,81,error_code,1);
					/* Error while trying to read from the Queue*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}

				break;


			case redoutTransmission:
				/*Will wait for the Before sync signal, probably in this state it will need to treat many RMAP commands*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdWaitFinishingTransmission( pxNFee, uiCmdFEE.ulWord );
				} else {
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

				xTrans.bDmaReturn[0] = FALSE;
				xTrans.bDmaReturn[1] = FALSE;
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


				if ( pxNFee->xControl.eNextMode == sOn_Enter ) {
					bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
					pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
					bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);
				} else if ( pxNFee->xControl.eNextMode == sStandby_Enter ) {
					bDpktGetPacketConfig(&pxNFee->xChannel.xDataPacket);
					pxNFee->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
					bDpktSetPacketConfig(&pxNFee->xChannel.xDataPacket);
				}

				/* Real State */
				pxNFee->xControl.eState = pxNFee->xControl.eNextMode;

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
					/* Send Error to NUC */
					vLogSendErrorChars(54,10+ pxNFee->ucId,error_code,1);
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
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
					switch ( pxNFee->xControl.eMode ) {

						case sOn: /*0x0*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0x0) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x0;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sFullPattern: /*0x1*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0x1) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x1;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sWinPattern:/*0x2*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0x2) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x2;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sStandBy: /*0x4*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0x4) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x4;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sFullImage:/*0x6*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0x6) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x6;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sWindowing:/*0x5*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0x5) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x5;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sParTrap1:/*0x9*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0x9) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0x9;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sParTrap2:/*0xA*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0xA) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0xA;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sSerialTrap1:/*0xB*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0xB) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0xB;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
							}
							break;
						case sSerialTrap2:/*0xC*/
							if (pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode != 0xC) {
								pxNFee->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucOpMode = 0xC;
								bRmapSetRmapMemCfgArea(&pxNFee->xChannel.xRmap);
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
			case M_FEE_DT_SOURCE:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
				}
				#endif
				break;
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
					pxNFeeP->xControl.eState = redoutPreLoadBuffer; /*Will stay until master sync*/
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

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
					pxNFeeP->xControl.eState = redoutPreLoadBuffer; /*Will stay until master sync*/
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
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

			case M_BEFORE_MASTER:
				vApplyRmap(pxNFeeP);
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
void vQCmdWaitFinishingTransmission( TNFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	unsigned char error_code;

	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_DT_SOURCE:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;

			case M_FEE_TRANS_FINISHED_L:

				if (pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucSensorSel == eRmapSenSelEFBoth) {

					pxNFeeP->xControl.ucTransmited++;
					if ( pxNFeeP->xControl.ucTransmited == 2 )
						pxNFeeP->xControl.eState = redoutEndSch;

				} else
					pxNFeeP->xControl.eState = redoutEndSch;

				break;

			case M_FEE_TRANS_FINISHED_D:
				if (pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucSensorSel == eRmapSenSelEFBoth) {

					pxNFeeP->xControl.ucTransmited++;
					if ( pxNFeeP->xControl.ucTransmited == 2 )
						pxNFeeP->xControl.eState = redoutEndSch;

				} else
					pxNFeeP->xControl.eState = redoutEndSch;

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
					pxNFeeP->xControl.eState = redoutTransmission; /*Will stay until master sync*/
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
					pxNFeeP->xControl.eState = redoutTransmission; /*Will stay until master sync*/
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
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

			case M_BEFORE_MASTER:
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

				if ( pxNFeeP->xControl.xTrap.bEnabledSerial == TRUE ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
						fprintf(fp,"NFEE %hhu Task: Could not finish the readout of vStar to vEnd in a entire sync. Please check the values of vStart and vEnd.\n", pxNFeeP->ucId);
					}
					#endif
				}


				pxNFeeP->xControl.eState = redoutConfigureTrans;
				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				/*

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
				*/

				/* [rfranca] *//*
				bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
				pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);*/

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
			case M_FEE_DT_SOURCE:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
				}
				#endif
				break;
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
					pxNFeeP->xControl.eState = redoutWaitSync; /*Will stay until master sync*/
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
					pxNFeeP->xControl.eState = redoutWaitSync; /*Will stay until master sync*/
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
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
			case M_BEFORE_MASTER:
			case M_BEFORE_SYNC:
				/*Do nothing for now*/
				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				/* Warning */
					pxNFeeP->xControl.eState = redoutTransmission;
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
			case M_BEFORE_MASTER:
				vApplyRmap(pxNFeeP);
				break;
			case M_BEFORE_SYNC:
				/*Do nothing*/
				break;
			case M_SYNC:
			case M_PRE_MASTER:
				break;
			case M_MASTER_SYNC:
				/*This block of code is used only for the On-Standby transitions, that will be done only in the master sync*/
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
			case M_FEE_DT_SOURCE:
				if ( uiCmdFEEL.ucByte[0] == 0 )
					pxNFeeP->xControl.eDataSource = dsPattern;
				else if ( uiCmdFEEL.ucByte[0] == 1 )
					pxNFeeP->xControl.eDataSource = dsSSD;
				else
					pxNFeeP->xControl.eDataSource = dsWindowStack;
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

			case M_FEE_ON:
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sOn_Enter;

				pxNFeeP->xControl.eState = sStandBy; /*Will stay until master sync*/
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
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sFullImage_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sStandBy;
				break;

			case M_FEE_WIN:
			case M_FEE_WIN_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sWindowing_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sStandBy;
				break;

			case M_FEE_PAR_TRAP_1:
			case M_FEE_PAR_TRAP_1_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sParTrap1_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sStandBy;
				break;

			case M_FEE_PAR_TRAP_2:
			case M_FEE_PAR_TRAP_2_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sParTrap2_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sStandBy;
				break;

			case M_FEE_SERIAL_TRAP_1:
			case M_FEE_SERIAL_TRAP_1_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sSerialTrap1_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sStandBy;
				break;

			case M_FEE_SERIAL_TRAP_2:
			case M_FEE_SERIAL_TRAP_2_FORCED:
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sStandby_Enter;
				pxNFeeP->xControl.eMode = sStandBy;
				pxNFeeP->xControl.eNextMode = sSerialTrap2_Enter;
				/* Real State */
				pxNFeeP->xControl.eState = sStandBy;
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

			case M_BEFORE_MASTER:
				/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/

				vApplyRmap(pxNFeeP);

				if ( pxNFeeP->xControl.eNextMode != pxNFeeP->xControl.eMode ) {
					pxNFeeP->xControl.eState =  pxNFeeP->xControl.eNextMode;

					if ( pxNFeeP->xControl.eNextMode == sOn_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else if ( pxNFeeP->xControl.eNextMode == sFullImage_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImageSsdMode;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else if ( pxNFeeP->xControl.eNextMode == sWindowing_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowingSsdImgMode;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else if ( pxNFeeP->xControl.eNextMode == sParTrap1_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktParallelTrapPumping1Data;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else if ( pxNFeeP->xControl.eNextMode == sParTrap2_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktParallelTrapPumping2Data;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else if ( pxNFeeP->xControl.eNextMode == sSerialTrap1_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktSerialTrapPumping1;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else if ( pxNFeeP->xControl.eNextMode == sSerialTrap2_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktSerialTrapPumping2;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					}
				}
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
			case M_FEE_DT_SOURCE:

				if ( uiCmdFEEL.ucByte[0] == 0 )
					pxNFeeP->xControl.eDataSource = dsPattern;
				else if ( uiCmdFEEL.ucByte[0] == 1 )
					pxNFeeP->xControl.eDataSource = dsSSD;
				else
					pxNFeeP->xControl.eDataSource = dsWindowStack;
				break;

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
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sStandby_Enter;
				/* Real State - only change on master */
				pxNFeeP->xControl.eState = sOn;
				break;


			case M_FEE_FULL_PATTERN:
			case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */

				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sFullPattern_Enter;
				/* Real State - only change on master*/
				pxNFeeP->xControl.eState = sOn;

				break;
			case M_FEE_WIN_PATTERN:
			case M_FEE_WIN_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */
				pxNFeeP->xControl.bWatingSync = TRUE;

				/* Real Fee State (graph) */
				pxNFeeP->xControl.eLastMode = sOn_Enter;
				pxNFeeP->xControl.eMode = sOn;
				pxNFeeP->xControl.eNextMode = sWinPattern_Enter;
				/* Real State - only change on master*/
				pxNFeeP->xControl.eState = sOn;
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
			case M_BEFORE_MASTER:
				/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/

				vApplyRmap(pxNFeeP);

				if ( pxNFeeP->xControl.eNextMode != pxNFeeP->xControl.eMode ) {
					pxNFeeP->xControl.eState =  pxNFeeP->xControl.eNextMode;

					if ( pxNFeeP->xControl.eNextMode == sStandby_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktStandby;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else if ( pxNFeeP->xControl.eNextMode == sFullPattern_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImagePattern;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					} else if ( pxNFeeP->xControl.eNextMode == sWinPattern_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktWindowingPattern;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					}
				}
				break;
			case M_BEFORE_SYNC:
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
			case M_FEE_DT_SOURCE:
				if ( uiCmdFEEL.ucByte[0] == 0 )
					pxNFeeP->xControl.eDataSource = dsPattern;
				else if ( uiCmdFEEL.ucByte[0] == 1 )
					pxNFeeP->xControl.eDataSource = dsSSD;
				else
					pxNFeeP->xControl.eDataSource = dsWindowStack;
				break;

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
				/* Real State - keep in the same state until master sync - wait for master sync to change*/
				pxNFeeP->xControl.eState = sConfig;
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
				/*Do nothing for now*/
				break;

			case M_BEFORE_MASTER:
				/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/
				if ( pxNFeeP->xControl.eNextMode != pxNFeeP->xControl.eMode ) {
					pxNFeeP->xControl.eState =  pxNFeeP->xControl.eNextMode;

					if ( pxNFeeP->xControl.eNextMode == sOn_Enter ) {
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
					}
				}
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
			case M_FEE_DT_SOURCE:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
				}
				#endif
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
					pxNFeeP->xControl.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

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
					pxNFeeP->xControl.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
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

			case M_BEFORE_MASTER:
				vApplyRmap(pxNFeeP);
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
			case M_FEE_DT_SOURCE:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.eLastMode = sInit;
				pxNFeeP->xControl.eMode = sConfig;
				pxNFeeP->xControl.eNextMode = sConfig;
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
					pxNFeeP->xControl.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
					}
					#endif
				}
				break;

			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
					pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

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

			case M_BEFORE_MASTER:
				vApplyRmap(pxNFeeP);

				if ( pxNFeeP->xControl.eNextMode == pxNFeeP->xControl.eLastMode )
					pxNFeeP->xControl.eState = redoutCycle_Out; /*Is time to start the preparation of the double buffer in order to transmit data just after sync arrives*/
				else
					pxNFeeP->xControl.eState = redoutCheckDTCUpdate; /*Received some command to change the mode, just go wait sync to change*/
				break;

			case M_BEFORE_SYNC:
				/*The transiction back will be performed only in the master sync signal*/
				/*Check if need to wait the pre master sync signal in order to change the state */
				//if ( pxNFeeP->xControl.eNextMode == pxNFeeP->xControl.eMode )
					pxNFeeP->xControl.eState = redoutCheckDTCUpdate; /*Is time to start the preparation of the double buffer in order to transmit data just after sync arrives*/
				//else
				//	pxNFeeP->xControl.eState = redoutWaitSync; /*Received some command to change the mode, just go wait sync to change*/
				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				if ( pxNFeeP->xControl.xTrap.bEnabled == FALSE ) {
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
				}

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

	pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength;
}

/* Initializing the the values of the HK memory area, only during dev*/
void vInitialConfig_RmapMemHKArea( TNFee *pxNFeeP ) {

	bRmapGetRmapMemHkArea(&pxNFeeP->xChannel.xRmap);
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense1 = 0xFF00;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense2 = 0xFF01;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense3 = 0xFF02;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense4 = 0xFF03;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense5 = 0xFF04;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense6 = 0xFF05;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1Ts = 0xFF06;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2Ts = 0xFF07;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3Ts = 0xFF08;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4Ts = 0xFF09;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt1 = 0xFF0A;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt2 = 0xFF0B;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt3 = 0xFF0C;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt4 = 0xFF0D;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt5 = 0xFF0E;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiZeroDiffAmp = 0xFF0F;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VodMon = 0xFF10;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VogMon = 0xFF11;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VrdMonE = 0xFF12;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VodMon = 0xFF13;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VogMon = 0xFF14;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VrdMonE = 0xFF15;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VodMon = 0xFF16;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VogMon = 0xFF17;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VrdMonE = 0xFF18;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VodMon = 0xFF19;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VogMon = 0xFF1A;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VrdMonE = 0xFF1B;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVccd = 0xFF1C;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVrclkMon = 0xFF1D;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiViclk = 0xFF1E;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVrclkLow = 0xFF1F;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vbPosMon = 0xFF20;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vbNegMon = 0xFF21;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi3v3bMon = 0xFF22;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi2v5aMon = 0xFF23;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi3v3dMon = 0xFF24;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi2v5dMon = 0xFF25;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi1v5dMon = 0xFF26;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vrefMon = 0xFF27;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVccdPosRaw = 0xFF28;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVclkPosRaw = 0xFF29;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan1PosRaw = 0xFF2A;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan3NegMon = 0xFF2B;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan2PosRaw = 0xFF2C;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVdigRaw = 0xFF2D;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVdigRaw2 = 0xFF2E;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiViclkLow = 0xFF2F;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VrdMonF = 0xFF30;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VddMon = 0xFF31;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VgdMon = 0xFF32;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VrdMonF = 0xFF33;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VddMon = 0xFF34;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VgdMon = 0xFF35;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VrdMonF = 0xFF36;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VddMon = 0xFF37;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VgdMon = 0xFF38;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VrdMonF = 0xFF39;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VddMon = 0xFF3A;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VgdMon = 0xFF3B;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiIgHiMon = 0xFF3C;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiIgLoMon = 0xFF3D;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTsenseA = 0xFF3E;
	pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTsenseB = 0xFF3F;
	bRmapSetRmapMemHkArea(&pxNFeeP->xChannel.xRmap);
}

/**
 * @name vUpdateFeeHKValue
 * @author bndky
 * @brief Update RMAP HK function for simulated FEE
 * @ingroup rtos
 *
 * @param 	[in]	TNFee 			*pxNFeeP
 * @param	[in]	alt_u8 	        ucRmapHkID (0 - 66)
 * @param	[in]	alt_u32			uliRawValue
 *
 * @retval void
 **/
void vUpdateFeeHKValue ( TNFee *pxNFeeP, alt_u8 ucRmapHkID, alt_u32 uliRawValue ){
	
	/* Load current values */
	bRmapGetRmapMemHkArea(&pxNFeeP->xChannel.xRmap);

	/* Switch case to assign value to register */
	switch(ucRmapHkID){
		case eRmapHkTouSense1:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense1 = (alt_u16)uliRawValue;
		break;
		case eRmapHkTouSense2:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense2 = (alt_u16)uliRawValue;
		break;
		case eRmapHkTouSense3:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense3 = (alt_u16)uliRawValue;
		break;
		case eRmapHkTouSense4:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense4 = (alt_u16)uliRawValue;
		break;
		case eRmapHkTouSense5:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense5 = (alt_u16)uliRawValue;
		break;
		case eRmapHkTouSense6:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense6 = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd1Ts:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1Ts = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd2Ts:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2Ts = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd3Ts:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3Ts = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd4Ts:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4Ts = (alt_u16)uliRawValue;
		break;
		case eRmapHkPrt1:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt1 = (alt_u16)uliRawValue;
		break;
		case eRmapHkPrt2:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt2 = (alt_u16)uliRawValue;
		break;
		case eRmapHkPrt3:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt3 = (alt_u16)uliRawValue;
		break;
		case eRmapHkPrt4:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt4 = (alt_u16)uliRawValue;
		break;
		case eRmapHkPrt5:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt5 = (alt_u16)uliRawValue;
		break;
		case eRmapHkZeroDiffAmp:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiZeroDiffAmp = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd1VodMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VodMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd1VogMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VogMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd1VrdMonE:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VrdMonE = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd2VodMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VodMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd2VogMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VogMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd2VrdMonE:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VrdMonE = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd3VodMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VodMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd3VogMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VogMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd3VrdMonE:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VrdMonE = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd4VodMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VodMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd4VogMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VogMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd4VrdMonE:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VrdMonE = (alt_u16)uliRawValue;
		break;
		case eRmapHkVccd:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVccd = (alt_u16)uliRawValue;
		break;
		case eRmapHkVrclkMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVrclkMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkViclk:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiViclk = (alt_u16)uliRawValue;
		break;
		case eRmapHkVrclkLow:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVrclkLow = (alt_u16)uliRawValue;
		break;
		case eRmapHk5vbPosMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vbPosMon = (alt_u16)uliRawValue;
		break;
		case eRmapHk5vbNegMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vbNegMon = (alt_u16)uliRawValue;
		break;
		case eRmapHk3v3bMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi3v3bMon = (alt_u16)uliRawValue;
		break;
		case eRmapHk2v5aMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi2v5aMon = (alt_u16)uliRawValue;
		break;
		case eRmapHk3v3dMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi3v3dMon = (alt_u16)uliRawValue;
		break;
		case eRmapHk2v5dMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi2v5dMon = (alt_u16)uliRawValue;
		break;
		case eRmapHk1v5dMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi1v5dMon = (alt_u16)uliRawValue;
		break;
		case eRmapHk5vrefMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vrefMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkVccdPosRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVccdPosRaw = (alt_u16)uliRawValue;
		break;
		case eRmapHkVclkPosRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVclkPosRaw = (alt_u16)uliRawValue;
		break;
		case eRmapHkVan1PosRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan1PosRaw = (alt_u16)uliRawValue;
		break;
		case eRmapHkVan3NegMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan3NegMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkVan2PosRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan2PosRaw = (alt_u16)uliRawValue;
		break;
		case eRmapHkVdigRaw:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVdigRaw = (alt_u16)uliRawValue;
		break;
		case eRmapHkVdigRaw2:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVdigRaw2 = (alt_u16)uliRawValue;
		break;
		case eRmapHkViclkLow:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiViclkLow = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd1VrdMonF:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VrdMonF = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd1VddMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VddMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd1VgdMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VgdMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd2VrdMonF:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VrdMonF = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd2VddMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VddMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd2VgdMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VgdMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd3VrdMonF:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VrdMonF = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd3VddMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VddMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd3VgdMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VgdMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd4VrdMonF:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VrdMonF = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd4VddMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VddMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkCcd4VgdMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VgdMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkIgHiMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiIgHiMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkIgLoMon:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiIgLoMon = (alt_u16)uliRawValue;
		break;
		case eRmapHkTsenseA:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTsenseA = (alt_u16)uliRawValue;
		break;
		case eRmapHkTsenseB:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTsenseB = (alt_u16)uliRawValue;
		break;
		case eRmapHkFpgaMinVer:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucFpgaMinorVersion = (alt_u8)uliRawValue;
		break;
		case eRmapHkFpgaMajVer:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucFpgaMajorVersion = (alt_u8)uliRawValue;
		break;
		case eRmapHkBoardId:
			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiBoardId = (alt_u16)uliRawValue;
		break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage )
				fprintf(fp, "HK update: HK ID out of bounds: %u;\n", ucRmapHkID );
			#endif
		break;
	}

	bRmapSetRmapMemHkArea(&pxNFeeP->xChannel.xRmap);

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

	if (  ucMem == 0  ) {
		bDmaReturn = bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks*2, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += FEEB_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks; //todo: substituir FEEB_PIXEL_BLOCK_SIZE_BYTES por algo mais flexivel
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	} else {
		bDmaReturn = bSdmaCommDmaTransfer(eDdr2Memory2, (alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks*2, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += FEEB_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks; //todo: substituir FEEB_PIXEL_BLOCK_SIZE_BYTES por algo mais flexivel
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	}


	if ( (xCcdMapLocal->ulBlockI + xTransL.ulSMD_MAX_BLOCKS) >= xTransL.ulTotalBlocks ) {
		ulLengthBlocks = xTransL.ulTotalBlocks - xCcdMapLocal->ulBlockI;
	} else {
		ulLengthBlocks = xTransL.ulSMD_MAX_BLOCKS;
	}

	if (  ucMem == 0  ) {
		bDmaReturn = bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks*2, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += FEEB_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks; //todo: substituir FEEB_PIXEL_BLOCK_SIZE_BYTES por algo mais flexivel
			xCcdMapLocal->ulBlockI += ulLengthBlocks;
		} else
			return bDmaReturn;
	} else {
		bDmaReturn = bSdmaCommDmaTransfer(eDdr2Memory2, (alt_u32 *)xCcdMapLocal->ulAddrI, (alt_u16)ulLengthBlocks*2, ucSide, pxNFee->ucSPWId);
		if ( bDmaReturn == TRUE ) {
			xCcdMapLocal->ulAddrI += FEEB_PIXEL_BLOCK_SIZE_BYTES*ulLengthBlocks; //todo: substituir FEEB_PIXEL_BLOCK_SIZE_BYTES por algo mais flexivel
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
		/* Send Error to NUC */
		vLogSendErrorChars(54,20,0,1);
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
	error_codel = OSQPostFront(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		/* Send Error to NUC */
		vLogSendErrorChars(54,20,0,1);
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
		/* Send Error to NUC */
		vLogSendErrorChars(54,20,0,1);
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
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		/* Send Error to NUC */
		vLogSendErrorChars(54,20,0,1);
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
	pxRmapCh->xRmapIrqControl.bWriteConfigEn = FALSE;
	pxRmapCh->xRmapIrqControl.bWriteWindowEn = FALSE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {

	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteConfigEn = TRUE;
	pxRmapCh->xRmapIrqControl.bWriteWindowEn = TRUE;
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
	xSPW->xSpwcLinkConfig.bLinkStart = xDefaults.bSpwLinkStart;
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
	//bFeebGetMachineControl(pxFeebCh);
	//pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
	//pxFeebCh->xFeebMachineControl.bBufferOverflowEn = xDefaults.bBufferOverflowEn;
	//pxFeebCh->xFeebMachineControl.bDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
	//pxFeebCh->xFeebMachineControl.bReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
	//bFeebSetMachineControl(pxFeebCh);

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

inline void vApplyRmap( TNFee *pxNFeeP ) {
	bool bTemp;

	bTemp = (pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd || pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize || pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder || pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase || pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd ) ;

	/*Something update*/
	if ( TRUE == bTemp ){

		if ( TRUE == pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd ) {
			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = FALSE;

			pxNFeeP->xMemMap.xCommon.ulVStart = pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart;
			pxNFeeP->xMemMap.xCommon.ulVEnd = pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd;
			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdVStart = pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart;
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdVEnd = pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

		}

		if ( TRUE == pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize ) {
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = FALSE;

			bDpktGetPacketConfig(&pxNFeeP->xChannel.xDataPacket);
			pxNFeeP->xChannel.xDataPacket.xDpktDataPacketConfig.usiPacketLength = pxNFeeP->xCopyRmap.usiCopyPacketLength;
			bDpktSetPacketConfig(&pxNFeeP->xChannel.xDataPacket);

		}

		if ( TRUE == pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase ) {
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = FALSE;

			bFeebGetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bDigitaliseEn = pxNFeeP->xCopyRmap.bCopyDigitaliseEn;
			pxNFeeP->xChannel.xFeeBuffer.xFeebMachineControl.bReadoutEn = pxNFeeP->xCopyRmap.bCopyReadoutEn;
			bFeebSetMachineControl(&pxNFeeP->xChannel.xFeeBuffer);

		}

		if ( TRUE == pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder ) {
			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = FALSE;

			pxNFeeP->xControl.ucROutOrder[0] = pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0];
			pxNFeeP->xControl.ucROutOrder[1] = pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1];
			pxNFeeP->xControl.ucROutOrder[2] = pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2];
			pxNFeeP->xControl.ucROutOrder[3] = pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3];

		}

		if ( TRUE == pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd ) {
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = FALSE;

			pxNFeeP->xMemMap.xCommon.ulHEnd = pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd;
		}

	}

}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinModeOn( TNFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucADDRReg;

	uiCmdFEEL.ulWord = cmd;
	ucADDRReg = uiCmdFEEL.ucByte[1];

	switch (ucADDRReg) {
		case 0x00:// reg_0_config (v_start and v_end)

			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = TRUE;

			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]

			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = TRUE;

			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = TRUE;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = TRUE;

			pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = TRUE;

			pxNFeeP->xCopyRmap.bCopyDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
			pxNFeeP->xCopyRmap.bCopyReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
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
			pxNFeeP->xMemMap.xCommon.ulHStart = 0;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig ) {
				case eRmapModeOn: /*Mode On*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Already in this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case eRmapCcdModeFullPatt: /*Full Image Pattern Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;

					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sOn_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sFullPattern_Enter;
					/* Real State - only change on master*/
					pxNFeeP->xControl.eState = sOn;
					break;
				case eRmapCcdModeWindPatt: /*Windowing-Pattern-Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;

					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sOn_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sWinPattern_Enter;
					/* Real State - only change on master*/
					pxNFeeP->xControl.eState = sOn;
					break;
				case eRmapCcdModeStandby: /*Stand-By-Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;

					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sOn_Enter;
					pxNFeeP->xControl.eMode = sOn;
					pxNFeeP->xControl.eNextMode = sStandby_Enter;
					/* Real State - only change on master */
					pxNFeeP->xControl.eState = sOn;

					break;
				case eRmapCcdModeFullImg: /*Full Image Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case eRmapCcdModeWindowing: /*Windowing-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case eRmapCcdModePerformance: /*Performance test mode -windowing*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeImmediateOn: /*Immediate On-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Already in this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case eRmapCcdModeParallelTrap1: /*Parallel trap pumping mode 1 - Full-Image*/
				case eRmapCcdModeParallelTrap2: /*Parallel trap pumping mode 2 - Full-Image*/
				case eRmapCcdModeSerialTrap1: /*Serial trap pumping mode 1- Full Image*/
				case eRmapCcdModeSerialTrap2: /*Serial trap pumping mode 2- Full Image*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Mode On)\n\n");
					}
					#endif
					break;
				case eRmapCcdModeReserved0: /*Reserved*/
				case eRmapCcdModeReserved1: /*Reserved*/
				case eRmapCcdModeReserved2: /*Reserved*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig);
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
			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = TRUE;

			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;
			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = TRUE;

			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = TRUE;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = TRUE;

			pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]
			//todo: Tiago sync_sel[0] not implemented yet
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = TRUE;

			pxNFeeP->xCopyRmap.bCopyDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
			pxNFeeP->xCopyRmap.bCopyReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
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
			pxNFeeP->xMemMap.xCommon.ulHStart = 0;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig ) {
				case eRmapModeOn: /*Mode On*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullPatt: /*Full Image Pattern Mode*/
				case eRmapCcdModeWindPatt: /*Windowing-Pattern-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeStandby: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
							fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
						#endif
					}
					break;
				case eRmapCcdModeFullImg: /*Full Image Mode*/
				case eRmapCcdModeWindowing: /*Windowing-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModePerformance: /*Performance test mode -windowing*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeImmediateOn: /*Immediate On-Mode*/
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
				case eRmapCcdModeParallelTrap1: /*Parallel trap pumping mode 1 - Full-Image*/
				case eRmapCcdModeParallelTrap2: /*Parallel trap pumping mode 2 - Full-Image*/
				case eRmapCcdModeSerialTrap1: /*Serial trap pumping mode 1- Full Image*/
				case eRmapCcdModeSerialTrap2: /*Serial trap pumping mode 2- Full Image*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeReserved0: /*Reserved*/
				case eRmapCcdModeReserved1: /*Reserved*/
				case eRmapCcdModeReserved2: /*Reserved*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig);
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
			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = TRUE;

			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = TRUE;

			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = TRUE;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = TRUE;

			pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]
			//todo: Tiago sync_sel[0] not implemented yet
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = TRUE;

			pxNFeeP->xCopyRmap.bCopyDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
			pxNFeeP->xCopyRmap.bCopyReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
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
			pxNFeeP->xMemMap.xCommon.ulHStart = 0;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig ) {
				case eRmapModeOn: /*Mode On*/
					/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullPatt: /*Full Image Pattern Mode*/
				case eRmapCcdModeWindPatt: /*Windowing-Pattern-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeStandby: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullImg: /*Full Image Mode*/
				case eRmapCcdModeWindowing: /*Windowing-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModePerformance: /*Performance test mode -windowing*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeImmediateOn: /*Immediate On-Mode*/
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
				case eRmapCcdModeParallelTrap1: /*Parallel trap pumping mode 1 - Full-Image*/
				case eRmapCcdModeParallelTrap2: /*Parallel trap pumping mode 2 - Full-Image*/
				case eRmapCcdModeSerialTrap1: /*Serial trap pumping mode 1- Full Image*/
				case eRmapCcdModeSerialTrap2: /*Serial trap pumping mode 2- Full Image*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeReserved0: /*Reserved*/
				case eRmapCcdModeReserved1: /*Reserved*/
				case eRmapCcdModeReserved2: /*Reserved*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig);
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
			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = TRUE;

			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = TRUE;

			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = TRUE;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = TRUE;

			pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]
			//todo: Tiago sync_sel[0] not implemented yet
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = TRUE;

			pxNFeeP->xCopyRmap.bCopyDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
			pxNFeeP->xCopyRmap.bCopyReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
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
			pxNFeeP->xMemMap.xCommon.ulHStart = 0;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig ) {
				case eRmapModeOn: /*Mode On*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sStandBy;
					pxNFeeP->xControl.eNextMode = sOn_Enter;

					pxNFeeP->xControl.eState = sStandBy; /*Will stay until master sync*/

					break;
				case eRmapCcdModeFullPatt: /*Full Image Pattern Mode*/
				case eRmapCcdModeWindPatt: /*Windowing-Pattern-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Stand-By Mode)\n\n");
					}
					#endif
					break;
				case eRmapCcdModeStandby: /*Stand-By-Mode*/
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Already in this mode. (Stand-By Mode)\n\n");
					}
					#endif
					break;
				case eRmapCcdModeFullImg: /*Full Image Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sStandBy;
					pxNFeeP->xControl.eNextMode = sFullImage_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sStandBy;
					break;
				case eRmapCcdModeWindowing: /*Windowing-Mode*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sStandBy;
					pxNFeeP->xControl.eNextMode = sWindowing_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sStandBy;
					break;
				case eRmapCcdModePerformance: /*Performance test mode -windowing*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeImmediateOn: /*Immediate On-Mode*/
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
				case eRmapCcdModeParallelTrap1: /*Parallel trap pumping mode 1 - Full-Image*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sStandBy;
					pxNFeeP->xControl.eNextMode = sParTrap1_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sStandBy;
					break;
				case eRmapCcdModeParallelTrap2: /*Parallel trap pumping mode 2 - Full-Image*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sStandBy;
					pxNFeeP->xControl.eNextMode = sParTrap2_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sStandBy;
					break;
				case eRmapCcdModeSerialTrap1: /*Serial trap pumping mode 1- Full Image*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sStandBy;
					pxNFeeP->xControl.eNextMode = sSerialTrap1_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sStandBy;
					break;
				case eRmapCcdModeSerialTrap2: /*Serial trap pumping mode 2- Full Image*/
					pxNFeeP->xControl.bWatingSync = TRUE;
					/* Real Fee State (graph) */
					pxNFeeP->xControl.eLastMode = sStandby_Enter;
					pxNFeeP->xControl.eMode = sStandBy;
					pxNFeeP->xControl.eNextMode = sSerialTrap2_Enter;
					/* Real State */
					pxNFeeP->xControl.eState = sStandBy;
					break;
				case eRmapCcdModeReserved0: /*Reserved*/
				case eRmapCcdModeReserved1: /*Reserved*/
				case eRmapCcdModeReserved2: /*Reserved*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig);
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
			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = TRUE;

			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;
			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = TRUE;

			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = TRUE;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = TRUE;

			pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]
			//todo: Tiago sync_sel[0] not implemented yet
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = TRUE;

			pxNFeeP->xCopyRmap.bCopyDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
			pxNFeeP->xCopyRmap.bCopyReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
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
			pxNFeeP->xMemMap.xCommon.ulHStart = 0;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig ) {
				case eRmapModeOn: /*Mode On*/
				case eRmapCcdModeFullPatt: /*Full Image Pattern Mode*/
				case eRmapCcdModeWindPatt: /*Windowing-Pattern-Mode*/
				case eRmapCcdModeStandby: /*Stand-By-Mode*/
				case eRmapCcdModeFullImg: /*Full Image Mode*/
				case eRmapCcdModeWindowing: /*Windowing-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Can't perform this command, already processing a changing action.\n\n");
					}
					#endif
					break;
				case eRmapCcdModePerformance: /*Performance test mode -windowing*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeImmediateOn: /*Immediate On-Mode*/
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
				case eRmapCcdModeParallelTrap1: /*Parallel trap pumping mode 1 - Full-Image*/
				case eRmapCcdModeParallelTrap2: /*Parallel trap pumping mode 2 - Full-Image*/
				case eRmapCcdModeSerialTrap1: /*Serial trap pumping mode 1- Full Image*/
				case eRmapCcdModeSerialTrap2: /*Serial trap pumping mode 2- Full Image*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Can't perform this command, already processing a changing action.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeReserved0: /*Reserved*/
				case eRmapCcdModeReserved1: /*Reserved*/
				case eRmapCcdModeReserved2: /*Reserved*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig);
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
			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = TRUE;

			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = TRUE;

			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = TRUE;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = TRUE;

			pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]
			//todo: Tiago sync_sel[0] not implemented yet
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = TRUE;

			pxNFeeP->xCopyRmap.bCopyDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
			pxNFeeP->xCopyRmap.bCopyReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
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
			pxNFeeP->xMemMap.xCommon.ulHStart = 0;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig ) {
				case eRmapModeOn: /*Mode On*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutWaitSync; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullPatt: /*Full Image Pattern Mode*/
				case eRmapCcdModeWindPatt: /*Windowing-Pattern-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeStandby: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutWaitSync; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullImg: /*Full Image Mode*/
				case eRmapCcdModeWindowing: /*Windowing-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModePerformance: /*Performance test mode -windowing*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeImmediateOn: /*Immediate On-Mode*/
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
				case eRmapCcdModeParallelTrap1: /*Parallel trap pumping mode 1 - Full-Image*/
				case eRmapCcdModeParallelTrap2: /*Parallel trap pumping mode 2 - Full-Image*/
				case eRmapCcdModeSerialTrap1: /*Serial trap pumping mode 1- Full Image*/
				case eRmapCcdModeSerialTrap2: /*Serial trap pumping mode 2- Full Image*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeReserved0: /*Reserved*/
				case eRmapCcdModeReserved1: /*Reserved*/
				case eRmapCcdModeReserved2: /*Reserved*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig);
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
			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = TRUE;

			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = TRUE;

			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = TRUE;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = TRUE;

			pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = TRUE;

			pxNFeeP->xCopyRmap.bCopyDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
			pxNFeeP->xCopyRmap.bCopyReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
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
			pxNFeeP->xMemMap.xCommon.ulHStart = 0;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig ) {
				case eRmapModeOn: /*Mode On*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutTransmission; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullPatt: /*Full Image Pattern Mode*/
				case eRmapCcdModeWindPatt: /*Windowing-Pattern-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeStandby: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutTransmission; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullImg: /*Full Image Mode*/
				case eRmapCcdModeWindowing: /*Windowing-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModePerformance: /*Performance test mode -windowing*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeImmediateOn: /*Immediate On-Mode*/
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
				case eRmapCcdModeParallelTrap1: /*Parallel trap pumping mode 1 - Full-Image*/
				case eRmapCcdModeParallelTrap2: /*Parallel trap pumping mode 2 - Full-Image*/
				case eRmapCcdModeSerialTrap1: /*Serial trap pumping mode 1- Full Image*/
				case eRmapCcdModeSerialTrap2: /*Serial trap pumping mode 2- Full Image*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeReserved0: /*Reserved*/
				case eRmapCcdModeReserved1: /*Reserved*/
				case eRmapCcdModeReserved2: /*Reserved*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig);
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
			pxNFeeP->xCopyRmap.xbRmapChanges.bvStartvEnd = TRUE;

			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVStart = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulVEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;

			break;
		case 0x04:// reg_1_config
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"RMAP Reg (%hhu): Cmd not implemented in this version.\n\n", ucADDRReg);
			}
			#endif
			break;
		case 0x08:// reg_2_config -> ccd_readout_order[7:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bReadoutOrder = TRUE;

			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[0] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[1] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[2] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
			pxNFeeP->xCopyRmap.xCopyControl.ucROutOrder[3] = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
			//val = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder;
			break;
		case 0x0C:// reg_3_config
			pxNFeeP->xCopyRmap.xbRmapChanges.bhEnd = TRUE;
			pxNFeeP->xCopyRmap.xCopyMemMap.xCommon.ulHEnd = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
			break;
		case 0x10:// reg_4_config -> packet_size[15:0]
			pxNFeeP->xCopyRmap.xbRmapChanges.bPacketSize = TRUE;

			pxNFeeP->xCopyRmap.usiCopyPacketLength = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
			break;
		case 0x14:// reg_5_config -> sync_sel[0] , sensor_sel[1:0], digitise_en[0]

			//todo: Tiago sync_sel[0] not implemented yet
			pxNFeeP->xCopyRmap.xbRmapChanges.bSyncSenSelDigitase = TRUE;

			pxNFeeP->xCopyRmap.bCopyDigitaliseEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
			pxNFeeP->xCopyRmap.bCopyReadoutEn = pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
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
			pxNFeeP->xMemMap.xCommon.ulHStart = 0;

			switch ( pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig ) {
				case eRmapModeOn: /*Mode On*/
					/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
					if (( pxNFeeP->xControl.eMode == sFullPattern ) || (pxNFeeP->xControl.eMode == sWinPattern)) {

						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutPreLoadBuffer; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;

					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullPatt: /*Full Image Pattern Mode*/
				case eRmapCcdModeWindPatt: /*Windowing-Pattern-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeStandby: /*Stand-By-Mode*/
					if (( pxNFeeP->xControl.eMode == sFullImage ) || (pxNFeeP->xControl.eMode == sWindowing) || (pxNFeeP->xControl.eMode == sParTrap1) || (pxNFeeP->xControl.eMode == sParTrap2) || (pxNFeeP->xControl.eMode == sSerialTrap1) || (pxNFeeP->xControl.eMode == sSerialTrap2)){
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.eState = redoutPreLoadBuffer; /*Will stay until master sync*/
						pxNFeeP->xControl.eNextMode = pxNFeeP->xControl.eLastMode;
					} else {
						bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
						bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
					}
					break;
				case eRmapCcdModeFullImg: /*Full Image Mode*/
				case eRmapCcdModeWindowing: /*Windowing-Mode*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModePerformance: /*Performance test mode -windowing*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Performance test mode not implemented.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeImmediateOn: /*Immediate On-Mode*/
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
				case eRmapCcdModeParallelTrap1: /*Parallel trap pumping mode 1 - Full-Image*/
				case eRmapCcdModeParallelTrap2: /*Parallel trap pumping mode 2 - Full-Image*/
				case eRmapCcdModeSerialTrap1: /*Serial trap pumping mode 1- Full Image*/
				case eRmapCcdModeSerialTrap2: /*Serial trap pumping mode 2- Full Image*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
					}
					#endif
					break;
				case eRmapCcdModeReserved0: /*Reserved*/
				case eRmapCcdModeReserved1: /*Reserved*/
				case eRmapCcdModeReserved2: /*Reserved*/
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP Mode op: Reserved.\n\n");
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					bDpktGetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					pxNFeeP->xChannel.xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
					bDpktSetPacketErrors(&pxNFeeP->xChannel.xDataPacket);
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"RMAP ccd_mode_config (%hhu): Mode not defined, keeping in the same mode.\n\n", pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig);
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

