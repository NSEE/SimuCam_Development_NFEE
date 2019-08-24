/*
 * fee_taskV2.c
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */


#include "fee_taskV2.h"


typedef struct FEETransmission{
	bool bFirstT;
	bool lastReadOut;
	unsigned long ulAddrIni;	/* (byte) Initial transmission data, calculated after */
	unsigned long ulAddrFinal;
	unsigned long ulTotalBlocks;
	unsigned long ulSMD_MAX_BLOCKS;
	tNFeeSide side;
	unsigned char ucMemory;
} TFEETransmission;


void vFeeTask(void *task_data) {
	TNFee *pxNFee;
	INT8U error_code;
	tQMask uiCmdFEE;
	TFEETransmission xTrans;

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

				/* Send to Meb Task that is not using RAM */
				bSendMSGtoMebTask( Q_MEB_FEE_MEM_TRAN_FIN, 0, pxNFee->ucId);

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

				if (xTrans.lastReadOut == TRUE) {
					/* Check any parameter or restriction that may have to transmit the data */
					pxNFee->xControl.eState = redoutCheckRestr;
				} else {

				}

				break;


			case redoutCheckRestr:

				/* Indicates that this FEE will now need to use DMA*/
				pxNFee->xControl.bUsingDMA = TRUE;

				/* Wait until both buffers are empty  */
				vWaitUntilBufferEmpty( pxNFee->ucSPWId );
				/* Guard time that HW MAYBE need, this will be used during the development, will be removed in some future version*/
				OSTimeDlyHMSM(0, 0, 0, xDefaults.usiGuardNFEEDelay);




				break;


			case redoutConfigureTrans:


				break;


			case redoutPreLoadBuffer:
				break;


			case redoutTransmission:
				break;


			case redoutEndSch:
				break;


			case redoutCycle_Out:
				pxNFee->xControl.bUsingDMA = FALSE;
				/* Send message telling to controller that is not using the DMA any more */
				bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFee->ucId);
				/* Send to Meb Task that is not using RAM */
				bSendMSGtoMebTask( Q_MEB_FEE_MEM_TRAN_FIN, 0, pxNFee->ucId);

				/* Real State */
				pxNFee->xControl.eState = pxNFee->xControl.eLastMode;
				break;


			case redoutWaitSync:
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
