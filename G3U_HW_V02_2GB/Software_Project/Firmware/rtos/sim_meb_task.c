/*
 * sim_meb_task.c
 *
 *  Created on: 13/01/2019
 *      Author: TiagoLow
 */

#include "sim_meb_task.h"

/* All commands should pass through the MEB, it is the instance that hould know everything, 
and also know the self state and what is allowed to be performed or not */
int values[] = { 88, 56, 100, 2, 25 };

bool bLeftExists;
bool bRightExists;
bool poweron;

int cmpfunc (const void * a, const void * b) {
   return ( *(int*)a - *(int*)b );
}



void vSimMebTask(void *task_data) {
	TSimucam_MEB *pxMebC;
	unsigned char ucIL;
	volatile tQMask uiCmdMeb;
	INT8U error_code;
	pxMebC = (TSimucam_MEB *) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage )
        fprintf(fp,"MEB Controller Task. (Task on)\n");
    #endif


	for (;;) {
		switch ( pxMebC->eMode ) {
			case sMebInit:
				/* Turn on Meb */
				vMebInit( pxMebC );
				pxMebC->eMode = sMebToConfig;
				break;

			case sMebToConfig:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage )
					fprintf(fp,"MEB Task: Config Mode\n");
				#endif

				vEnterConfigRoutine( pxMebC );
				pxMebC->eMode = sMebConfig;
				break;

			case sMebToRun:

				bEnableIsoDrivers();
				bEnableLvdsBoard();

				pxMebC->ucActualDDR = 1;
				pxMebC->ucNextDDR = 0;

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage )
					fprintf(fp,"\nMEB Task: Going to Run Mode\n");
				#endif

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage )
					fprintf(fp,"MEB Task: First DTC will load at least one full sky from SSD.\n");
					fprintf(fp,"MEB Task: All other modules will wait until DTC finishes.\n");
				#endif

				/*Time to read, remover later*/ //todo: Remove later releases
				OSTimeDlyHMSM(0, 0, 3, 0);


				vSendCmdQToDataCTRL_PRIO( M_DATA_RUN_FORCED, 0, 0 );

				OSSemPend(xSemCommInit, 0, &error_code); /*Blocking*/
				if ( error_code == OS_ERR_NONE ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage )
						fprintf(fp,"MEB Task: FEE Controller and FEEs to RUN.\n");
					#endif


					/* Transition to Run Mode (Starting the Simulation) */
					vSendCmdQToNFeeCTRL_PRIO( M_NFC_RUN_FORCED, 0, 0 );

					/* Give time to DTC and NFEE controller to start all processe before the first master sync */
					OSTimeDlyHMSM(0, 0, 0, 250);
					//vSendMessageNUCModeMEBChange( 2 ); /*2: Running*/
					/* Give time to all tasks receive the command */
					//OSTimeDlyHMSM(0, 0, 0, pxMebC->usiDelaySyncReset);

					/* Clear the timecode of the channel SPW (for now is for spw channel) */
					for (ucIL = 0; ucIL < N_OF_NFEE; ++ucIL) {
						bSpwcClearTimecode(&pxMebC->xFeeControl.xNfee[ucIL].xChannel.xSpacewire);
						pxMebC->xFeeControl.xNfee[ucIL].xControl.ucTimeCode = 0;
					}
					/* Reset the Synchronization Provider Timecode - [rfranca] */
					vScomClearTimecode();

					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage )
						fprintf(fp,"\nMEB Task: Releasing Sync Module in 5 seconds");
						OSTimeDlyHMSM(0, 0, 5, 200);
					#endif

					/*This sequence start the HW sync module*/
					bSyncCtrReset();
					vSyncClearCounter();
					bStartSync();

					vEvtChangeMebMode();
					pxMebC->eMode = sMebRun;
				} else {
					/* Send Error to NUC */
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"MEB Task: CRITICAL! Could no receive the sync semaphore from DTC, backing to Config Mode\n");
					#endif
					pxMebC->eMode = sMebToConfig;
				}

				break;

			case sMebConfig:

/*				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"MEB Task: sMebConfig - Waiting for command.");
				#endif
				break;*/
				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					/* Threat the command received in the Queue Message */
					vPerformActionMebInConfig( uiCmdMeb.ulWord, pxMebC);
				} else {
					/* Should never get here (blocking operation), critical failure */
					vCouldNotGetCmdQueueMeb();
				}
				break;

			case sMebRun:

/*				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"MEB Task: sMebRun - Waiting for command.");
				#endif
				break;*/

				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Threat the command received in the Queue Message */
					vPerformActionMebInRunning( uiCmdMeb.ulWord, pxMebC);

				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetCmdQueueMeb();
				}			
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					debug(fp,"MEB Task: Unknown state, backing to Config Mode\n");
				#endif
				/* todo:Aplicar toda logica de mudança de esteado aqui */
				pxMebC->eMode = sMebToConfig;
		}
	}
}


void vPerformActionMebInRunning( unsigned int uiCmdParam, TSimucam_MEB *pxMebCLocal ) {
	tQMask uiCmdLocal;
	unsigned char ucIL =0;

	uiCmdLocal.ulWord = uiCmdParam;

	/* Check if the command is for MEB */
	if ( uiCmdLocal.ucByte[3] == M_MEB_ADDR ) {
		/* Parse the cmd that comes in the Queue */
		switch (uiCmdLocal.ucByte[2]) {
			/* Receive a PUS command */
			case Q_MEB_PUS:
				vPusMebTask( pxMebCLocal );
				break;
			case M_MASTER_SYNC:
				/* Perform memory SWAP */
				vSwapMemmory(pxMebCLocal);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\n============== Master Sync ==============\n\n");
					volatile TCommChannel *vpxCommFChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
					fprintf(fp,"Channels TimeCode = %d\n", vpxCommFChannel->xSpacewire.xSpwcTimecodeStatus.ucTime);
					vTimeCodeMissCounter(pxMebCLocal,vpxCommFChannel->xSpacewire.xSpwcTimecodeStatus.ucTime);
				}
				#endif

				vDebugSyncTimeCode(pxMebCLocal);
				break;
			case M_SYNC:
			case M_PRE_MASTER:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\n-------------- Sync --------------\n\n");
					volatile TCommChannel *vpxCommFChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
					fprintf(fp,"Channels TimeCode = %d\n", vpxCommFChannel->xSpacewire.xSpwcTimecodeStatus.ucTime);
					vTimeCodeMissCounter(pxMebCLocal,vpxCommFChannel->xSpacewire.xSpwcTimecodeStatus.ucTime);
				}
				#endif
				if (uiCmdLocal.ucByte[2] == M_PRE_MASTER)
				{
					for (int iCountFEE = 0; iCountFEE < N_OF_NFEE; iCountFEE++) {
						if (bStartImgWinInj[iCountFEE] == TRUE) {
							if ( bDpktContentErrInjStartInj(&pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket) ) {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
									fprintf(fp, "\nIMAGE AND WINDOW ERROR INJECTION START SUCCESS\n" );
								#endif
							} else {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
									fprintf(fp, "\nIMAGE AND WINDOW ERROR INJECTION START PROBLEM\n" );
								#endif
							}
							bStartImgWinInj[iCountFEE] = FALSE;
						}
						if (bStartDataPktInj[iCountFEE] == TRUE) {
							if ( bDpktHeaderErrInjStartInj(&pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket) ) {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
									fprintf(fp, "\nDATA HEADER ERROR INJECTION START SUCCESS\n" );
								#endif
							} else {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
									fprintf(fp, "\nDATA HEADER ERROR INJECTION START PROBLEM\n" );
								#endif
							}
							bStartDataPktInj[iCountFEE] = FALSE;
						}
					}
				}
				vDebugSyncTimeCode(pxMebCLocal);
				break;

			case Q_MEB_DATA_MEM_UPD_FIN:

				/*Check if is already the sync before Master Sync*/
				if ( xGlobal.bPreMaster == TRUE ) {
					/*Maybe have some FEE instances locked in reading queue, waiting for a message that DTC finishes the upload of the memory*/
					/*So, need to send them a message to inform*/
					/* Using QMASK send to NfeeControl that will foward */
					for (ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
						if ( TRUE == pxMebCLocal->xFeeControl.xNfee[ucIL].xControl.bUsingDMA ) {
							vSendCmdQToNFeeCTRL_GEN(ucIL, M_FEE_CAN_ACCESS_NEXT_MEM, 0, ucIL );
						}
					}
				}
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"MEB Task: Unknown command (%hhu)\n", uiCmdLocal.ucByte[2]);
				#endif
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
			fprintf(fp,"MEB Task: Command Ignored wrong address (ADDR= %hhu)\n", uiCmdLocal.ucByte[3]);
		#endif
	}
}

void vPerformActionMebInConfig( unsigned int uiCmdParam, TSimucam_MEB *pxMebCLocal ) {
	tQMask uiCmdLocal;

	uiCmdLocal.ulWord = uiCmdParam;

#if DEBUG_ON
if ( xDefaults.usiDebugLevel <= dlMinorMessage )
	fprintf(fp,"MEB Task: vPerformActionMebInConfig - CMD.ulWord:0x%08x ",uiCmdLocal.ulWord );
#endif

	/* Check if the command is for MEB */
	if ( uiCmdLocal.ucByte[3] == M_MEB_ADDR ) {

		/* Parse the cmd that comes in the Queue */
		switch ( uiCmdLocal.ucByte[2] ) {
			/* Receive a PUS command */
			case Q_MEB_PUS:
				vPusMebTask( pxMebCLocal );
				break;

			case M_SYNC:
			case M_PRE_MASTER:
			case M_MASTER_SYNC:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"MEB Task: WARNING Should not have sync in Meb Config Mode (Check it please)");
				#endif
				break;
			case Q_MEB_DATA_MEM_UPD_FIN:
				break;

			default:

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"MEB Task: Unknown command for the Config Mode (Queue xMebQ, cmd= %hhu)\n", uiCmdLocal.ucByte[2]);
				#endif
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
			fprintf(fp,"MEB Task: Command Ignored wrong address (ADDR= %hhu)\n", uiCmdLocal.ucByte[3]);
		#endif
	}
}


void vDebugSyncTimeCode( TSimucam_MEB *pxMebCLocal ) {
	INT8U ucFrameNumber;
	unsigned char tCode;
	unsigned char tCodeNext;


	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		bSpwcGetTimecodeStatus(&pxMebCLocal->xFeeControl.xNfee[0].xChannel.xSpacewire);
		tCode = ( pxMebCLocal->xFeeControl.xNfee[0].xChannel.xSpacewire.xSpwcTimecodeStatus.ucTime);
		tCodeNext = ( tCode ) % 4;
		fprintf(fp,"TC: %hhu ( %hhu )\n ", tCode, tCodeNext);
		bRmapGetRmapMemCfgArea(&pxMebCLocal->xFeeControl.xNfee[0].xChannel.xRmap);
		ucFrameNumber = pxMebCLocal->xFeeControl.xNfee[0].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucFrameNumber;
		fprintf(fp,"MEB TASK:  Frame Number: %hhu \n ", ucFrameNumber);
	}
	#endif
}




void vPusMebTask( TSimucam_MEB *pxMebCLocal ) {
	bool bSuccess;
	INT8U error_code;
	unsigned char ucIL;
	static tTMPus xPusLocal;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage )
		fprintf(fp,"MEB Task: vPusMebTask\n");
	#endif

	bSuccess = FALSE;
	OSMutexPend(xMutexPus, 2, &error_code);
	if ( error_code == OS_ERR_NONE ) {
	    /*Search for the PUS command*/
	    for(ucIL = 0; ucIL < N_PUS_PIPE; ucIL++)
	    {
            if ( xPus[ucIL].bInUse == TRUE ) {
                /* Need to check if the performance is the same as memcpy*/
            	xPusLocal = xPus[ucIL];
            	xPus[ucIL].bInUse = FALSE;
            	bSuccess = TRUE;
                break;
            }
	    }
	    OSMutexPost(xMutexPus);
	} else {
		vCouldNotGetMutexMebPus();
	}

	if ( bSuccess == TRUE ) {
		switch (pxMebCLocal->eMode) {
			case sMebConfig:
			case sMebToConfig:
				vSendEventLog(0,1,0,0,1);
				vPusMebInTaskConfigMode(pxMebCLocal, &xPusLocal);
				break;
			case sMebRun:
			case sMebToRun:
				vSendEventLog(0,1,0,1,1);
				vPusMebInTaskRunningMode(pxMebCLocal, &xPusLocal);
				break;
			default:
				break;
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage )
			fprintf(fp,"MEB Task: vPusMebTask - Don't found Pus command in xPus.");
		#endif
	}
}


/* This function should treat the PUS command in the Config Mode, need check all the things that is possible to update in this mode */
/* In the Config Mode the MEb takes control and change all values freely */
void vPusMebInTaskConfigMode( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {

	switch (xPusL->usiType) {
		/* srv-Type = 250 */
		case 250:
			vPusType250conf(pxMebCLocal, xPusL);
			break;
		/* srv-Type = 251 */
		case 251:
			vPusType251conf(pxMebCLocal, xPusL);
			break;
		/* srv-Type = 252 */
		case 252:
			vPusType252conf(pxMebCLocal, xPusL);
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Srv-Type not allowed in this mode (CONFIG)\n\n" );
			#endif
	}
}

void vPusType250conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned char ucShutDownI = 0;
	unsigned short int param1 =0;
	unsigned short int usiFeeInstL;
	alt_u32 ulEP, ulStart, ulPx, ulLine;
	unsigned char ucFeeInstL;
	unsigned char ucDTSourceL;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage )
		fprintf(fp,"MEB Task: vPusType250conf - Command: %hhu.", xPusL->usiSubType);
	#endif


	switch (xPusL->usiSubType) {
		/* TC_SYNCH_SOURCE */
		case 29:
			/* Disable all sync IRQs [rfranca] */
			bSyncIrqEnableError(FALSE);
			bSyncIrqEnableBlankPulse(FALSE);
			bSyncIrqEnableMasterPulse(FALSE);
			bSyncIrqEnableNormalPulse(FALSE);
			bSyncIrqEnableLastPulse(FALSE);
			bSyncPreIrqEnableBlankPulse(FALSE);
			bSyncPreIrqEnableMasterPulse(FALSE);
			bSyncPreIrqEnableNormalPulse(FALSE);
			bSyncPreIrqEnableLastPulse(FALSE);
			/* Set sync source */
			param1 = xPusL->usiValues[0];
			bSyncCtrIntern(param1 == 0); /*TRUE = Internal*/
			/* Clear all sync IRQ Flags [rfranca] */
			bSyncIrqFlagClrError(TRUE);
			bSyncIrqFlagClrBlankPulse(TRUE);
			bSyncIrqFlagClrMasterPulse(TRUE);
			bSyncIrqFlagClrNormalPulse(TRUE);
			bSyncIrqFlagClrLastPulse(TRUE);
			bSyncPreIrqFlagClrBlankPulse(TRUE);
			bSyncPreIrqFlagClrMasterPulse(TRUE);
			bSyncPreIrqFlagClrNormalPulse(TRUE);
			bSyncPreIrqFlagClrLastPulse(TRUE);
			/* Enable relevant sync IRQs [rfranca] */
			bSyncIrqEnableMasterPulse(TRUE);
			bSyncIrqEnableNormalPulse(TRUE);
			bSyncIrqEnableLastPulse(TRUE);
			bSyncPreIrqEnableBlankPulse(TRUE);
			bSyncPreIrqEnableMasterPulse(TRUE);
			break;
		/*case 34:
			usiFeeInstL = xPusL->usiValues[0];
			char teste[32];
			memset(teste,0,32);
			teste[0] = xPusL->usiPusId;
			teste[1] = 0x043;
			teste[2] = 0x044;
			teste[3] = 0x045;
			teste[4] = 0x046;
			fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
			bSendUART512v2(teste,xPusL->usiPusId);
			break;*/
		/* TC_SCAMxx_RMAP_ECHO_ENABLE */
		case 36:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingIdEn = xPusL->usiValues[1];
			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
				fprintf(fp, "usiValues[1]: %hu;\n", xPusL->usiValues[1] );
				fprintf(fp, "usiFeeInstL : %hu;\n", usiFeeInstL 		);
			}
			#endif
		break;
		/* TC_SCAMxx_RMAP_ECHO_DISABLE */
		case 37:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = FALSE;
			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
				fprintf(fp, "usiFeeInstL : %hu;\n", usiFeeInstL 		);
			}
			#endif
		break;
		/* TC_SCAM_WIN_ERR_MISS_PKT_TRIG */
		case 51:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = FALSE;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"\nTC_SCAM_WIN_ERR_MISS_PKT_TRIG\n");
			#endif
			break;
		/* TC_SCAM_WIN_ERR_NOMOREPKT_TRIG  */
		case 52:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"\n TC_SCAM_WIN_ERR_NOMOREPKT_TRIG\n");
			#endif
			break;
		/* TC_SCAM_FEE_HK_UPDATE_VALUE [bndky] */
		case 58:
			vSendHKUpdate(pxMebCLocal, xPusL);
			break;
		/* TC_SCAM_IMAGE_ERR_MISS_PKT_TRIG */
		case 49:
		/* TC_SCAM_IMAGE_ERR_NOMOREPKT_TRIG  */
		case 50:
		/* TC_SCAM_ERR_OFF */
		case 53:
			usiFeeInstL = xPusL->usiValues[0];
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"TC_SCAM_ERR_OFF\n");
				#endif
				bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = 0;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
				bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);

				bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
				bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);

				bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.bTriggerErr = FALSE;
				bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);

				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = FALSE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = FALSE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = FALSE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = 0;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiSequenceCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiNRepeat = 0;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiDataCnt = 0;

				bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
				bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);

				bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
				bDpktHeaderErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
				usiDataPktCount = 0;

				bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
				bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
				usiLeftImageWindowContentErr_Count = 0;
				usiRightImageWindowContentErr_Count = 0;
				bLeftExists = FALSE;
				bRightExists = FALSE;
			break;
		/* TC_SCAM_IMAGE_ERR_MISSDATA_TRIG */
		case 67:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure error while in MEB Config. Mode \n" );
			}
			#endif
			break;


		/* TC_SCAM_RUN */
		case 61:
			pxMebCLocal->eMode = sMebToRun;
			break;
		/* TC_SCAM_TURNOFF */
		case 66:
			/*todo: Do nothing for now */
			/* Animate LED */
			/* Wait for N seconds */
			for (ucShutDownI = 0; ucShutDownI < N_SEC_WAIT_SHUTDOWN; ucShutDownI++) {

				bSetPainelLeds( LEDS_OFF , LEDS_ST_ALL_MASK );
				bSetPainelLeds( LEDS_ON , (LEDS_ST_1_MASK << ( ucShutDownI % 4 )) );

				OSTimeDlyHMSM(0,0,1,0);
			}

			/* Sinalize that can safely shutdown the Simucam */
			bSetPainelLeds( LEDS_ON , LEDS_ST_ALL_MASK );
			break;
		/* TC_SCAM_WIN_ERR_ENABLE_WIN_PROG */
		case 62:
			usiFeeInstL = xPusL->usiValues[0];
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_ENABLE_WIN_PROG:%i\n", pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn);
			#endif
			break;
		case 63:
			usiFeeInstL = xPusL->usiValues[0];
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = FALSE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_DISABLE_WIN_PROG:%i\n", pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn);
			#endif
			break;
		/* TC_SCAM_FEE_TIME_CONFIG */
		case 64:
			ulEP= (alt_u32)( (alt_u32)(xPusL->usiValues[0] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[1] & 0x0000ffff) );
			ulStart= (alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) );
			ulPx= (alt_u32)( (alt_u32)(xPusL->usiValues[4] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[5] & 0x0000ffff) );
			ulLine= (alt_u32)( (alt_u32)(xPusL->usiValues[6] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[7] & 0x0000ffff) );
			xDefaults.ulLineDelay = ulLine;
			xDefaults.ulADCPixelDelay = ulPx;
			xDefaults.ulStartDelay = ulStart;

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "---TIME_CONFIG: EP: %lu (ms)\n", ulEP);
				fprintf(fp, "---TIME_CONFIG: Start Delay: %lu (ms)\n", ulStart);
				fprintf(fp, "---TIME_CONFIG: Px Delay: %lu (ns)\n", ulPx);
				fprintf(fp, "---TIME_CONFIG: Line Delay: %lu (ns)\n", ulLine);
			}
			#endif

			/*Configure EP*/
			//bSyncConfigNFeeSyncPeriod( (alt_u16)ulEP ); // Change to update ucEP em xMeb for STATUS REPORT
			if (bSyncConfigNFeeSyncPeriod( (alt_u16)ulEP ) == TRUE) {
				pxMebCLocal->ucEP = ( (float) ulEP/1000);
			}


			for (usiFeeInstL=0; usiFeeInstL < N_OF_NFEE; usiFeeInstL++) {
				bDpktGetPixelDelay(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay = uliPxDelayCalcPeriodMs( ulStart );
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay = uliPxDelayCalcPeriodNs( ulPx );
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay = uliPxDelayCalcPeriodNs( ulLine );
				bDpktSetPixelDelay(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
			}

			break;

		/*Data Source*/
		case 70:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			ucDTSourceL = (unsigned char)xPusL->usiValues[1];
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_DT_SOURCE, ucDTSourceL, ucFeeInstL );
			break;

		case 72:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (alt_u8)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = FALSE;
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_MISSDATA_TRIG\n" );
			#endif
			break;

		case 73: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG */
			usiFeeInstL = xPusL->usiValues[0];
			alt_u16 usiFramesActive = xPusL->usiValues[5];
			if (usiFramesActive == 0) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "\nTC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: invalid frames active parameter (0)\n");
				}
				#endif
			} else if ((usiLeftImageWindowContentErr_Count + usiRightImageWindowContentErr_Count) >= 100) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "\nTC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Already have 100 content errors \n" );
				}
				#endif
				break;
			} else {
				/* Side: 0 = Left; 1 = Right; 2 = Both */
				if ((xPusL->usiValues[3] == 0) || (xPusL->usiValues[3] == 2)) {
					//Left = 0
					if (usiLeftImageWindowContentErr_Count > 0){
						for (int iSeekEquals = 0; iSeekEquals < usiLeftImageWindowContentErr_Count; iSeekEquals++) {
							if  ( (xLeftImageWindowContentErr[iSeekEquals].usiPxColX == xPusL->usiValues[1]) && (xLeftImageWindowContentErr[iSeekEquals].usiPxRowY == xPusL->usiValues[2])) {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
									fprintf(fp, "\nnTC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Left Position X, Y already exists.\n");
								}
								#endif
								bLeftExists = TRUE;
								break;
							} else {
								bLeftExists = FALSE;
							}
						}
					}
					if (bLeftExists == FALSE) {
						xLeftImageWindowContentErr[usiLeftImageWindowContentErr_Count].usiPxColX 		= xPusL->usiValues[1];
						xLeftImageWindowContentErr[usiLeftImageWindowContentErr_Count].usiPxRowY 		= xPusL->usiValues[2];
						xLeftImageWindowContentErr[usiLeftImageWindowContentErr_Count].usiCountFrames	= xPusL->usiValues[4];
						xLeftImageWindowContentErr[usiLeftImageWindowContentErr_Count].usiFramesActive	= xPusL->usiValues[4] + xPusL->usiValues[5] - 1;
						xLeftImageWindowContentErr[usiLeftImageWindowContentErr_Count].usiPxValue		= xPusL->usiValues[6];

						usiLeftImageWindowContentErr_Count++;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "\nTC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG LEFT: %i\n", usiLeftImageWindowContentErr_Count);
						}
						#endif
					}
				}
				if ( (xPusL->usiValues[3] == 1) || (xPusL->usiValues[3] == 2)){
					//Right = 1
					if (usiRightImageWindowContentErr_Count > 0){
						for (int iSeekEquals = 0; iSeekEquals < usiRightImageWindowContentErr_Count; iSeekEquals++) {
							if  ( (xRightImageWindowContentErr[iSeekEquals].usiPxColX == xPusL->usiValues[1]) && (xRightImageWindowContentErr[iSeekEquals].usiPxRowY == xPusL->usiValues[2])) {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
									fprintf(fp, "\nnTC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Right Position X, Y already exists.\n");
								}
								#endif
								bRightExists = TRUE;
								break;
							} else {
								bRightExists = FALSE;
							}
						}
					}
					if (bRightExists == FALSE) {
						xRightImageWindowContentErr[usiRightImageWindowContentErr_Count].usiPxColX 			= xPusL->usiValues[1];
						xRightImageWindowContentErr[usiRightImageWindowContentErr_Count].usiPxRowY 			= xPusL->usiValues[2];
						xRightImageWindowContentErr[usiRightImageWindowContentErr_Count].usiCountFrames		= xPusL->usiValues[4];
						xRightImageWindowContentErr[usiRightImageWindowContentErr_Count].usiFramesActive	= xPusL->usiValues[4] + xPusL->usiValues[5] - 1;
						xRightImageWindowContentErr[usiRightImageWindowContentErr_Count].usiPxValue			= xPusL->usiValues[6];

						usiRightImageWindowContentErr_Count++;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "\nTC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG RIGHT: %i\n", usiRightImageWindowContentErr_Count);
						}
						#endif
					}
				}
			}
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "\nTC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG\n" );
			}
			#endif
			break;
		case 74: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG_FINISH */
				usiFeeInstL = xPusL->usiValues[0];
				qsort (xLeftImageWindowContentErr, usiLeftImageWindowContentErr_Count, sizeof(TImageWindowContentErr), iCompareImgWinContent);
				qsort (xRightImageWindowContentErr, usiRightImageWindowContentErr_Count, sizeof(TImageWindowContentErr), iCompareImgWinContent);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "\nSW List Order Success\n" );
				}
				#endif
				if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket)) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "\nHW list cleared successfully\n" );
					}
					#endif
					if (bDpktContentErrInjOpenList(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket)) {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "\nHW list opening successfully\n" );
						}
						#endif
						if (usiLeftImageWindowContentErr_Count > 0)
						for (int iListCount=0; iListCount<usiLeftImageWindowContentErr_Count; iListCount++) {
							ucDpktContentErrInjAddEntry( &pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket,
														 0,
														 xLeftImageWindowContentErr[iListCount].usiCountFrames,
														 xLeftImageWindowContentErr[iListCount].usiFramesActive,
														 xLeftImageWindowContentErr[iListCount].usiPxColX,
														 xLeftImageWindowContentErr[iListCount].usiPxRowY,
														 xLeftImageWindowContentErr[iListCount].usiPxValue);
							 #if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp, "\nHW LEFT ucDpktContentErrInjAddEntry Data\n" );
								fprintf(fp, "HW Position X :%i\n", xLeftImageWindowContentErr[iListCount].usiPxColX);
								fprintf(fp, "HW Position Y :%i\n", xLeftImageWindowContentErr[iListCount].usiPxRowY);
								fprintf(fp, "HW Start Frame:%i\n", xLeftImageWindowContentErr[iListCount].usiCountFrames);
								fprintf(fp, "HW Stop  Frame:%i\n", xLeftImageWindowContentErr[iListCount].usiFramesActive);
								fprintf(fp, "HW Pixel Value:%i\n", xLeftImageWindowContentErr[iListCount].usiPxValue);
							}
							#endif
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "\nHW Left list error add successfully\n" );
						}
						#endif
						if (usiRightImageWindowContentErr_Count > 0)
						for (int iListCount=0; iListCount<usiRightImageWindowContentErr_Count; iListCount++) {
							ucDpktContentErrInjAddEntry( &pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket,
														 1,
														 xRightImageWindowContentErr[iListCount].usiCountFrames,
														 xRightImageWindowContentErr[iListCount].usiFramesActive,
														 xRightImageWindowContentErr[iListCount].usiPxColX,
														 xRightImageWindowContentErr[iListCount].usiPxRowY,
														 xRightImageWindowContentErr[iListCount].usiPxValue);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp, "\nHW RIGHT ucDpktContentErrInjAddEntry Data\n" );
								fprintf(fp, "HW Position X :%i\n", xRightImageWindowContentErr[iListCount].usiPxColX);
								fprintf(fp, "HW Position Y :%i\n", xRightImageWindowContentErr[iListCount].usiPxRowY);
								fprintf(fp, "HW Start Frame:%i\n", xRightImageWindowContentErr[iListCount].usiCountFrames);
								fprintf(fp, "HW Stop  Frame:%i\n", xRightImageWindowContentErr[iListCount].usiFramesActive);
								fprintf(fp, "HW Pixel Value:%i\n", xRightImageWindowContentErr[iListCount].usiPxValue);
							}
							#endif
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "\nHW Right list error add successfully\n" );
						}
						#endif
						if (bDpktContentErrInjCloseList(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket)){
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp, "\nHW Close list successfully\n" );
							}
							#endif
						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp, "\nHW Close list problem\n" );
							}
							#endif
						}
						bDpktGetLeftContentErrInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
						bDpktGetRightContentErrInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "\nTotal Entry Left:%i\n", pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket.xDpktLeftContentErrInj.ucErrorsCnt  );
							fprintf(fp, "Total Entry Right:%i\n", pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket.xDpktRightContentErrInj.ucErrorsCnt);
						}
						#endif
					}
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "\nHW Clear list problem\n" );
					}
					#endif
				}
				//qsort (xDataPKTErr, usiDataPktCount, sizeof(TDataPktError), iCompareDataPktError);

			break;
		case 75: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_CLEAR  */
				ucFeeInstL = xPusL->usiValues[0];
				if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket)) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "\nClear HW IMAGE AND WINDOW LIST SUCCESS\n" );
					}
					#endif

				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "\nClear HW IMAGE AND WINDOW LIST PROBLEM\n" );
					}
					#endif
				}
				usiLeftImageWindowContentErr_Count = 0;
				usiRightImageWindowContentErr_Count = 0;
				bLeftExists = FALSE;
				bRightExists = FALSE;
			break;
		/* TC_SCAM_CONFIG */

		case 78: /* TC_SCAMxx_DATA_PKT_ERR_CONFIG  */
			ucFeeInstL = xPusL->usiValues[0];
			if (usiDataPktCount < 10) {
				xDataPKTErr[usiDataPktCount].usiFrameCounter 		= xPusL->usiValues[1];
				xDataPKTErr[usiDataPktCount].usiSequenceCounter 	= xPusL->usiValues[2];
				xDataPKTErr[usiDataPktCount].usiFieldId 			= xPusL->usiValues[3];
				xDataPKTErr[usiDataPktCount].usiFieldValue 		= xPusL->usiValues[4];
				usiDataPktCount++;
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "\nDATA PKT ADD TO LIST: %i \n", usiDataPktCount);
				}
				#endif
				break;
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "\nDATA PKT ERROR:  Already have 10 header errors \n");
				}
				#endif
				break;
			}
		case 79: /* TC_SCAMxx_DATA_PKT_ERR_CONFIG_FINISH  */
			ucFeeInstL = xPusL->usiValues[0];
			if (usiDataPktCount > 0){
				qsort (xDataPKTErr, usiDataPktCount, sizeof(TDataPktError), iCompareDataPktError);
			}
			if (bDpktHeaderErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket)) {
				if (bDpktHeaderErrInjOpenList(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket)) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "\nOPEN HW DATA HEADER LIST SUCCESS\n" );
					}
					#endif
					for (int n=0; n<usiDataPktCount; n++){
						ucDpktHeaderErrInjAddEntry(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket,
													xDataPKTErr[n].usiFrameCounter,
													xDataPKTErr[n].usiSequenceCounter,
													xDataPKTErr[n].usiFieldId,
													xDataPKTErr[n].usiFieldValue);

					}
					usiDataPktCount = 0;
					if (&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket){
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "\nALL DATA ADD TO HW LIST\nHW LIST CLOSE\n" );
						}
						#endif
					}
				}
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "\nClear DATA HEADER LIST PROBLEM\n" );
				}
				#endif
			}
			break;
		case 80: /* TC_SCAMxx_DATA_PKT_ERR_CLEAR  */
				ucFeeInstL = xPusL->usiValues[0];
				if (bDpktHeaderErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket)) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "\nHeader data list was cleared\n" );
					}
					#endif
					usiDataPktCount = 0;
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "\nCLEAR DATA HEADER LIST PROBLEM\n" );
					}
					#endif
				}
			break;
		case 60:
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Command not allowed in this mode\n\n" );
			}
			#endif
	}
}




void vPusType251conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage )
		fprintf(fp, "MEB Task: Can't change the mode of the NFEE while MEB is Config mode\n\n" );
	#endif
}

void vPusType252conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned short int usiFeeInstL;

	usiFeeInstL = xPusL->usiValues[0];
	switch (xPusL->usiSubType) {
		case 3: /* TC_SCAM_SPW_LINK_ENABLE */
		case 4: /* TC_SCAM_SPW_LINK_DISABLE */
		case 5: /* TC_SCAM_SPW_LINK_RESET */
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage )
				fprintf(fp,"MEB Task: Can't perform this operation in the Link while Meb is Config mode \n\n");
			#endif
			break;
		case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */

			/* todo: For now we can only update the Logical Address and the RAMP Key */

			/* Disable the RMAP interrupt */
			bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteConfigEn = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteWindowEn = FALSE;
			bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);

			/* Change the configuration */
			bRmapGetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char)xPusL->usiValues[6];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char)xPusL->usiValues[3];
			bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );

			bSpwcEnableTimecodeTrans(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire, xPusL->usiValues[5] == 1 );

			bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
			if ( xPusL->usiValues[7] == 0 ) { /*Auto Start*/
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
			} else {
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
			}

			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv( (unsigned char)xPusL->usiValues[2] );

			bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);

			bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xPusL->usiValues[4]; /*Dest Node*/
			bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);

			/* Enable the RMAP interrupt */
			bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteConfigEn = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteWindowEn = TRUE;
			bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);

			/* todo: Need to treat all the returns */
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: RMAP KEY: %hu     L. ADDR: %hu (Change performed) \n\n", xPusL->usiValues[6] , xPusL->usiValues[3]);
			#endif
			break;
		case 78:
			qsort(values, 5, sizeof(int), cmpfunc);
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not allowed in this mode\n\n" );
			#endif
	}
}

/* This function should treat the PUS command in the Running Mode, need check all the things that is possible to update in this mode */
void vPusMebInTaskRunningMode( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {

	switch (xPusL->usiType) {
		/* srv-Type = 250 */
		case 250:
			vPusType250run(pxMebCLocal, xPusL);
			break;
		/* srv-Type = 251 */
		case 251:
			if ( xGlobal.bSyncReset == FALSE ) {
				vPusType251run(pxMebCLocal, xPusL);
			}
			break;
		/* srv-Type = 252 */
		case 252:
			vPusType252run(pxMebCLocal, xPusL);
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Srv-Type not allowed in this mode (RUN)\n\n" );
			#endif
	}
}


void vPusType250run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned short int usiFeeInstL;
	unsigned char ucFeeInstL;
	unsigned char ucDTSourceL;
	unsigned char ucShutDownI=0;

	switch (xPusL->usiSubType) {
		/* TC_SCAMxx_SYNCH_RST [bndky] */
		case 31:
			if ( xGlobal.bSyncReset == FALSE ) {
				/* Send the wait time info to the sync reset function*/
				vSyncReset( xPusL->usiValues[0], &(pxMebCLocal->xFeeControl)  );
			}
		break;
		/* TC_SCAMxx_RMAP_ECHO_ENABLE */
		case 36:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingIdEn = xPusL->usiValues[1];
			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
				fprintf(fp, "usiValues[1]: %hu;\n", xPusL->usiValues[1] );
				fprintf(fp, "usiFeeInstL : %hu;\n", usiFeeInstL 		);
			}
			#endif
		break;
		/* TC_SCAMxx_RMAP_ECHO_DISABLE */
		case 37:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = FALSE;
			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
				fprintf(fp, "usiFeeInstL : %hu;\n", usiFeeInstL 		);
			}
			#endif
		break;
		case 46: /* TC_SCAMXX_SPW_ERR_TRIG */
			usiFeeInstL = xPusL->usiValues[0];
			/* Disconnect Error Injection */
			switch (xPusL->usiValues[3])
			{
				case 1:
					/* SPW Disable */
					bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bDisconnect = TRUE;
					bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.bChannelEnable = FALSE;

					/* SPW Enable */
					bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
					bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.bChannelEnable = TRUE;
					#if DEBUG_ON
						fprintf(fp, "ERROR INJECTION: SPW Disconnect\n\n" );
					#endif
				break;
				case 5:
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = TRUE;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = xPusL->usiValues[2];
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = xPusL->usiValues[1];
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
						fprintf(fp, "ERROR INJECTION: EEP received\n\n" );
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "Invalid SPW error type\n\n" );
					#endif
			}
			break;
		case 47: /* TC_SCAMXX_RMAP_ERR_TRIG */
				usiFeeInstL = xPusL->usiValues[0];
				bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.bTriggerErr = xPusL->usiValues[1];
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.ucErrorId   = xPusL->usiValues[2];
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.uliValue    = (alt_u32)( (alt_u32)(xPusL->usiValues[3] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[4] & 0x0000ffff) );
				bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
				#if DEBUG_ON
					fprintf(fp, "\nERROR INJECTION: RMAP ERROR\n" );
				#endif
			break;
		case 48: /* TC_SCAMXX_TICO_ERR_TRIG */
				usiFeeInstL = xPusL->usiValues[0];

				switch (xPusL->usiValues[5]) {

				/* Time-Code Missing Error */
				case 0:
					if (xPusL->usiValues[4] > 0)
					{
						bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
						bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
						bSpwcGetTimecodeStatus(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
						fprintf(fp, "\nTIMECODE:%i\n", pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeStatus.ucTime );
						xTimeCodeErrInj.bFEE_NUMBER[usiFeeInstL]  = TRUE;
						if (xPusL->usiValues[4] == 1)
							xTimeCodeErrInj.usiMissCount[usiFeeInstL] = 75;
						else
							xTimeCodeErrInj.usiMissCount[usiFeeInstL] = (pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeStatus.ucTime + xPusL->usiValues[4]);
						xTimeCodeErrInj.bMissTC = TRUE;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
							fprintf(fp, "\nERROR INJECTION: MISSING TIMECODE ON\n" );
						#endif
					} else
					{
						bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
						bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
							fprintf(fp, "\nERROR INJECTION: MISSING TIMECODE OFF\n" );
						#endif
					}
					break;

				/* Wrong Time-Code Error */
				case 1:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = xPusL->usiValues[1];
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "\nERROR INJECTION: WRONG TIMECODE ON\n" );
					#endif
					bSpwcGetTimecodeStatus(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					xTimeCodeErrInj.bWrongTC = TRUE;
					xTimeCodeErrInj.bFEE_WRONG_NUMBER[usiFeeInstL] = TRUE;
					xTimeCodeErrInj.usiWrongCount[usiFeeInstL] = xPusL->usiValues[4];
					xTimeCodeErrInj.usiWrongOffSet[usiFeeInstL] = xPusL->usiValues[1];
					break;

				/* Unexpected Time-Code Error */
				case 2:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = TRUE;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = uliTimecodeCalcDelayMs((alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) ));
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					xTimeCodeErrInj.usiWrongCount[usiFeeInstL] =   xPusL->usiValues[4];
					xTimeCodeErrInj.bUxp = TRUE;
					xTimeCodeErrInj.bFEEUxp[usiFeeInstL] = TRUE;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "\nERROR INJECTION: UNEXPECTED TIMECODE\n");
					#endif
					break;

				/* Jitter on Time-Code Error */
				case 3:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = FALSE;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = TRUE;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = uliTimecodeCalcDelayMs((alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) ));
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
					xTimeCodeErrInj.bFEEJitter[usiFeeInstL] = TRUE;
					xTimeCodeErrInj.bJitter = TRUE;
					xTimeCodeErrInj.usiJitterCount[usiFeeInstL] = xPusL->usiValues[4];
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "\nERROR INJECTION: JITTER TIMECODE\n" );
					#endif
					break;

				/* Invalid Error Code */
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "\nINVALID TIMECODE ERROR\n" );
					#endif
					break;
				}

			break;
		/* TC_SCAM_FEE_HK_UPDATE_VALUE [bndky] */
		case 58:
			vSendHKUpdate(pxMebCLocal, xPusL);
			break;

		/* TC_SCAM_IMAGE_ERR_MISS_PKT_TRIG */
		case 49:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = FALSE;
			break;

		/* TC_SCAM_IMAGE_ERR_NOMOREPKT_TRIG  */
		case 50:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			break;
		/* TC_SCAM_WIN_ERR_MISS_PKT_TRIG */
		case 51:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = FALSE;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"\nTC_SCAM_WIN_ERR_MISS_PKT_TRIG\n");
			#endif
			break;
		/* TC_SCAM_WIN_ERR_NOMOREPKT_TRIG  */
		case 52:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"\n TC_SCAM_WIN_ERR_NOMOREPKT_TRIG\n");
			#endif
			break;
		/* TC_SCAM_ERR_OFF */
		case 53:
			usiFeeInstL = xPusL->usiValues[0];
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"TC_SCAM_ERR_OFF\n");
			#endif
			bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = 0;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
			bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);

			bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
			bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);

			bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.bTriggerErr = FALSE;
			bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);

			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = 0;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiSequenceCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiNRepeat = 0;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiDataCnt = 0;

			bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
			bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);

			bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
			bDpktHeaderErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
			usiDataPktCount = 0;

			bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
			bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
			usiLeftImageWindowContentErr_Count = 0;
			usiRightImageWindowContentErr_Count = 0;
			bLeftExists = FALSE;
			bRightExists = FALSE;
			break;
		/* TC_SCAM_WIN_ERR_ENABLE_WIN_PROG */
		case 62:
			usiFeeInstL = xPusL->usiValues[0];
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_ENABLE_WIN_PROG:%i\n", pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn);
			#endif
			break;
		/* TC_SCAM_WIN_ERR_DISABLE_WIN_PROG */
		case 63:
			usiFeeInstL = xPusL->usiValues[0];
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = FALSE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
			#if DEBUG_ON
			fprintf(fp, "\nTC_SCAM_WIN_ERR_DISABLE_WIN_PROG:%i\n", pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn);
			#endif

			break;
		/* TC_SCAM_IMAGE_ERR_MISSDATA_TRIG */
		case 67:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = FALSE;
			break;

		/* TC_SCAM_CONFIG */
		case 60:
			if ( xGlobal.bSyncReset == FALSE ) {
				pxMebCLocal->eMode = sMebToConfig;
			}
			break;
		/* TC_SCAM_TURNOFF */
		case 66:
			/*todo: Do nothing for now */
			/* Force all go to Config Mode */
			vEnterConfigRoutine(pxMebCLocal);

			/* Animate LED */
			/* Wait for N seconds */
			for (ucShutDownI = 0; ucShutDownI < N_SEC_WAIT_SHUTDOWN; ucShutDownI++) {

				bSetPainelLeds( LEDS_OFF , LEDS_ST_ALL_MASK );
				bSetPainelLeds( LEDS_ON , (LEDS_ST_1_MASK << ( ucShutDownI % 4 )) );

				OSTimeDlyHMSM(0,0,1,0);
			}

			/* Sinalize that can safely shutdown the Simucam */
			bSetPainelLeds( LEDS_ON , LEDS_ST_ALL_MASK );
			break;

		/* TC_SCAM_FEE_TIME_CONFIG */
		case 64:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not allowed in this mode (RUN)\n" );
			#endif
			break;

		/*Data Source*/
		case 70:

			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			ucDTSourceL = (unsigned char)xPusL->usiValues[1];
//			#if DEBUG_ON
//			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
//				fprintf(fp,"MEB Task: DATA_SOURCE ucFeeInstL= %hhu, ucDTSourceL= %hhu\n",ucFeeInstL,ucDTSourceL  );
//			#endif

			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_DT_SOURCE, ucDTSourceL, ucDTSourceL );
			break;

		case 61:
		/* TC_SCAM_WIN_ERR_MISSDATA_TRIG */
		case 72:
			usiFeeInstL = xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingData = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.xErrorSWCtrl.bTxDisabled = FALSE;
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_MISSDATA_TRIG\n" );
			#endif
			break;

		case 76: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_START_INJ */
			usiFeeInstL = xPusL->usiValues[0];
			bDpktGetRightContentErrInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
			bDpktGetLeftContentErrInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket);
			if ((pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket.xDpktRightContentErrInj.bInjecting == FALSE) || (pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket.xDpktLeftContentErrInj.bInjecting == FALSE)) {
				bStartImgWinInj[usiFeeInstL] = TRUE;
			} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "\nERROR: You are already in data injection mode. Command cannot be overridden.\n" );
					#endif
			}
			break;
		case 77: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_STOP_INJ */
			usiFeeInstL = xPusL->usiValues[0];
			if ( bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket) ) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp, "\nIMAGE AND WINDOW ERROR INJECTION STOP SUCCESS\n" );
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp, "\nIMAGE AND WINDOW ERROR INJECTION STOP PROBLEM\n" );
				#endif
			}
			break;
		case 81: /* TC_SCAMxx_DATA_PKT_ERR_START_INJ */
			usiFeeInstL = xPusL->usiValues[0];
			bStartDataPktInj[usiFeeInstL] = TRUE;
			break;
		case 82: /* TC_SCAMxx_DATA_PKT_ERR_STOP_INJ */
			usiFeeInstL = xPusL->usiValues[0];
			if ( bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket) ) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp, "\nDATA HEADER ERROR INJECTION STOP SUCCESS\n" );
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp, "\nDATA HEADER ERROR INJECTION STOP PROBLEM\n" );
				#endif
			}
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not allowed in this mode (RUN)\n\n" );
			#endif
	}
}

void vPusType251run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned char ucFeeInstL;

	ucFeeInstL = (unsigned char)xPusL->usiValues[0];
	switch (xPusL->usiSubType) {
		/* TC_SCAM_FEE_CONFIG_ENTER */
		case 1:
			/* Using QMASK send to NfeeControl that will foward */
			vSendEventLog(ucFeeInstL+1,1,2,0,1);
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_CONFIG, 0, ucFeeInstL );
			break;
		/* TC_SCAM_FEE_STANDBY_ENTER */
		case 2:
			vSendEventLog(ucFeeInstL+1,1,2,1,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_STANDBY, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_FULLIMAGE_ENTER */
		case 3:
			vSendEventLog(ucFeeInstL+1,1,2,2,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_FULL, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_WINDOWING _ENTER */
		case 4:
			vSendEventLog(ucFeeInstL+1,1,2,3,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_WIN, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_FULLIMAGE_PATTERN_ENTER */
		case 5:
			vSendEventLog(ucFeeInstL+1,1,2,4,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_FULL_PATTERN, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_WINDOWING_PATTERN_ENTER */
		case 6:
			vSendEventLog(ucFeeInstL+1,1,2,5,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_WIN_PATTERN, 0, ucFeeInstL );
			break;
		/* NFEE_ON */
		case 11:
			vSendEventLog(ucFeeInstL+1,1,2,6,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_ON, 0, ucFeeInstL );
			break;
		case 12:
			vSendEventLog(ucFeeInstL+1,1,2,7,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_PAR_TRAP_1, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_PARALLEL_TRAP_PUMP_2_ENTER */
		case 13:
			vSendEventLog(ucFeeInstL+1,1,2,8,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_PAR_TRAP_2, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_SERIAL_TRAP_PUMP_1_ENTER */
		case 14:
			vSendEventLog(ucFeeInstL+1,1,2,9,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_SERIAL_TRAP_1, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_SERIAL_TRAP_PUMP_2_ENTER */
		case 15:
			vSendEventLog(ucFeeInstL+1,1,2,10,1);
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_SERIAL_TRAP_2, 0, ucFeeInstL );
			break;
		case 0:
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not implemented yet (SubType:%hu)\n\n",xPusL->usiSubType );
			#endif
	}
}

void vPusType252run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned short int usiFeeInstL;

	usiFeeInstL = xPusL->usiValues[0];
	switch (xPusL->usiSubType) {
		case 3: /* TC_SCAM_SPW_LINK_ENABLE */
			bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
			if (bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire)){
				vSendEventLog(usiFeeInstL+1,0,0,0,1);
			} else {
				vSendEventLog(usiFeeInstL+1,0,0,0,3);
			}
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.bChannelEnable = TRUE;
//			bSetPainelLeds( LEDS_OFF , uliReturnMaskR( pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].ucSPWId ) );
//			bSetPainelLeds( LEDS_ON , uliReturnMaskG( pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].ucSPWId ) );

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: Link enable (NFEE-%hu)\n\n", usiFeeInstL);
			#endif
			break;

		case 4: /* TC_SCAM_SPW_LINK_DISABLE */
			bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bDisconnect = TRUE;
			if (bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire)) {
				vSendEventLog(usiFeeInstL+1,0,0,1,1);
			} else {
				vSendEventLog(usiFeeInstL+1,0,0,1,3);
			}
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.bChannelEnable = FALSE;
//			bSetPainelLeds( LEDS_OFF , uliReturnMaskG( pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].ucSPWId ) );
//			bSetPainelLeds( LEDS_ON , uliReturnMaskR( pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].ucSPWId ) );

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: Link disable (NFEE-%hu)\n\n", usiFeeInstL);
			#endif
			break;

		case 5: /* TC_SCAM_SPW_LINK_RESET */
			/* todo:Do nothing, don't know what is reset spw link */
			break;

		case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */

			/* todo: For now we can only update the Logical Address and the RAMP Key */
			if ( pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.eMode == sConfig ) {
				/* Disable the RMAP interrupt */
				bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteConfigEn = FALSE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteWindowEn = FALSE;
				bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);

				/* Change the configuration */
				bRmapGetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char)xPusL->usiValues[12];
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char)xPusL->usiValues[9];
				bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );

				bSpwcEnableTimecodeTrans(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire, xPusL->usiValues[11] == 1 );

				bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
				if ( xPusL->usiValues[7] == 0 ) { /*Auto Start*/
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
				} else {
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
					pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
				}

				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv( (unsigned char)xPusL->usiValues[8] );

				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = xPusL->usiValues[10]; /*Dest Node*/

				bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);


				/* Enable the RMAP interrupt */
				bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteConfigEn = TRUE;
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteWindowEn = TRUE;
				bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);

			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage )
					fprintf(fp,"MEB Task: NFEE-%hu is not in the Config Mode ( Changes not performed )\n\n", usiFeeInstL);
				#endif
			}

			/* todo: Need to treat all the returns */
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: RMAP KEY: %hu     L. ADDR: %hu (Change performed) \n\n", xPusL->usiValues[12] , xPusL->usiValues[9]);
			#endif
			break;

		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage )
				fprintf(fp, "MEB Task: Command not allowed in this mode (RUN)\n\n" );
			#endif
			break;
	}
}




void vMebInit(TSimucam_MEB *pxMebCLocal) {
	INT8U errorCodeL;

	pxMebCLocal->ucActualDDR = 1;
	pxMebCLocal->ucNextDDR = 0;
	/* Flush all communication Queues */
	errorCodeL = OSQFlush(xMebQ);
	if ( errorCodeL != OS_NO_ERR ) {
		vFailFlushMEBQueue();
	}
}

/* Swap memory reference */
void vSwapMemmory(TSimucam_MEB *pxMebCLocal) {

	pxMebCLocal->ucActualDDR = (pxMebCLocal->ucActualDDR + 1) % 2 ;
	pxMebCLocal->ucNextDDR = (pxMebCLocal->ucNextDDR + 1) % 2 ;

}

/*This sequence is used more than one place, so it becomes a function*/
void vEnterConfigRoutine( TSimucam_MEB *pxMebCLocal ) {
	unsigned short int usiFeeInstL;


	/* Stop the Sync (Stopping the simulation) */
	bStopSync();
	vSyncClearCounter();

	/* Give time to all tasks receive the command */
	OSTimeDlyHMSM(0, 0, 0, 5);

	pxMebCLocal->ucActualDDR = 1;
	pxMebCLocal->ucNextDDR = 0;
	/* Transition to Config Mode (Ending the simulation) */
	/* Send a message to the NFEE Controller forcing the mode */
	vSendCmdQToNFeeCTRL_PRIO( M_NFC_CONFIG_FORCED, 0, 0 );
	vSendCmdQToDataCTRL_PRIO( M_DATA_CONFIG_FORCED, 0, 0 );

	//vSendMessageNUCModeMEBChange( 1 ); /*1: Config*/

	/* Give time to all tasks receive the command */
	OSTimeDlyHMSM(0, 0, 0, 250);

	for (usiFeeInstL=0; usiFeeInstL<N_OF_NFEE; usiFeeInstL++) {
		bDpktGetTransmissionErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
		pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktTransmissionErrInj.bMissingDataEn = FALSE;
		pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktTransmissionErrInj.bMissingPktsEn = FALSE;
		pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktTransmissionErrInj.bTxDisabledEn = FALSE;
		pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktTransmissionErrInj.ucFrameNum = 0;
		pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktTransmissionErrInj.usiDataCnt = 0;
		pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktTransmissionErrInj.usiNRepeat = 0;
		pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktTransmissionErrInj.usiSequenceCnt = 0;
		bDpktSetTransmissionErrInj(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
	}

	bDisableIsoDrivers();
	bDisableLvdsBoard();
}

void vSendMessageNUCModeMEBChange(  unsigned short int mode  ) {
	INT8U error_code, i;
	char cHeader[8] = "!M:%hhu:";
	char cBufferL[128] = "";

	sprintf( cBufferL, "%s%hu", cHeader, mode );


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

/**
 * @name vSendHKUpdate
 * @author bndky
 * @brief Prepare the data and send to updateHK fukction
 * @ingroup rtos
 *
 * @param 	[in]	TSimucam_MEB 	*pxMebCLocal
 * @param	[in]	tTMPus 			*xPusL
 *
 * @retval void
 **/
void vSendHKUpdate(TSimucam_MEB *pxMebCLocal, tTMPus *xPusL){
	union HkValue u_HKValue;
	
	/* converting from usi to uli */
	u_HKValue.usiValues[0] = xPus->usiValues[3];
	u_HKValue.usiValues[1] = xPus->usiValues[2];

	vUpdateFeeHKValue(&pxMebCLocal->xFeeControl.xNfee[xPus->usiValues[0]], (alt_u8)xPus->usiValues[1], u_HKValue.uliValue);

}

/* ImgWin Content Error Sort Function */
int iCompareImgWinContent (const void *cvpImgWinA, const void *cvpImgWinB) {
	int iCompResult = 0;
	/*
	 * Compare function need to return:
	 *   -- (return > 0) if (ImgWinA > ImgWinB)
	 *   -- (return == 0) if (ImgWinA == ImgWinB)
	 *   -- (return < 0) if (ImgWinA < ImgWinB)
	 */

	/*
	 * Content need to be sorted as:
	 *   -- 1st key: X position
	 *   -- 2nd key: Y position
	 */

	TImageWindowContentErr *pxImgWinA = (TImageWindowContentErr *)cvpImgWinA;
	TImageWindowContentErr *pxImgWinB = (TImageWindowContentErr *)cvpImgWinB;

	/* 1st key (X position) compare */
	if (pxImgWinA->usiPxColX > pxImgWinB->usiPxColX) {
		/* (ImgWinA > ImgWinB) : (return > 0) */
		iCompResult = 1;
	} else if (pxImgWinA->usiPxColX < pxImgWinB->usiPxColX) {
		/* (ImgWinA < ImgWinB) : (return > 0) */
		iCompResult = -1;
	} else {
		/* 1st key (X position) is the same */
		/* 2nd key (Y position) compare */
		if (pxImgWinA->usiPxRowY > pxImgWinB->usiPxRowY) {
			/* (ImgWinA > ImgWinB) : (return > 0) */
			iCompResult = 1;
		} else if (pxImgWinA->usiPxRowY < pxImgWinB->usiPxRowY) {
			/* (ImgWinA < ImgWinB) : (return > 0) */
			iCompResult = -1;
		} else {
			/* 2nd key (Y position) is the same */
			/* (ImgWinA == ImgWinB) : (return == 0) */
			iCompResult = 0;
		}
	}

    return (iCompResult);
}

/* Data Packet Error Sort Function */
int iCompareDataPktError (const void *cvpDataPktErrA, const void *cvpDataPktErrB) {
	int iCompResult = 0;
	/*
	 * Compare function need to return:
	 *   -- (return > 0) if (DataPktErrA > DataPktErrB)
	 *   -- (return == 0) if (DataPktErrA == DataPktErrB)
	 *   -- (return < 0) if (DataPktErrA < DataPktErrB)
	 */

	/*
	 * Content need to be sorted as:
	 *   -- 1st key: Frame Number
	 *   -- 2nd key: Sequence Counter
	 */

	TDataPktError *pxDataPktErrA = (TDataPktError *)cvpDataPktErrA;
	TDataPktError *pxDataPktErrB = (TDataPktError *)cvpDataPktErrB;

	/* 1st key (Frame Number) compare */
	if (pxDataPktErrA->usiFrameCounter > pxDataPktErrB->usiFrameCounter) {
		/* (DataPktErrA > DataPktErrB) : (return > 0) */
		iCompResult = 1;
	} else if (pxDataPktErrA->usiFrameCounter < pxDataPktErrB->usiFrameCounter) {
		/* (DataPktErrA < DataPktErrB) : (return > 0) */
		iCompResult = -1;
	} else {
		/* 1st key (Frame Number) is the same */
		/* 2nd key (Sequence Counter) compare */
		if (pxDataPktErrA->usiSequenceCounter > pxDataPktErrB->usiSequenceCounter) {
			/* (DataPktErrA > DataPktErrB) : (return > 0) */
			iCompResult = 1;
		} else if (pxDataPktErrA->usiSequenceCounter < pxDataPktErrB->usiSequenceCounter) {
			/* (DataPktErrA < DataPktErrB) : (return > 0) */
			iCompResult = -1;
		} else {
			/* 2nd key (Sequence Counter) is the same */
			/* (DataPktErrA == DataPktErrB) : (return == 0) */
			iCompResult = 0;
		}
	}

    return (iCompResult);
}

void vTimeCodeMissCounter(TSimucam_MEB * pxMebCLocal, alt_u8 usiTimeCode) {
	if (xTimeCodeErrInj.bMissTC == TRUE) {
		for (int i = 0; i < 8; i++) {
			if (xTimeCodeErrInj.bFEE_NUMBER[i] == TRUE) {
				if ((xTimeCodeErrInj.usiMissCount[i] == usiTimeCode) || (xTimeCodeErrInj.usiMissCount[i] == 75) ){
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
					xTimeCodeErrInj.bFEE_NUMBER[i] = FALSE;
				}
			}
		}
		xTimeCodeErrInj.bMissTC = (xTimeCodeErrInj.bFEE_NUMBER[0] |
								 xTimeCodeErrInj.bFEE_NUMBER[1] |
								 xTimeCodeErrInj.bFEE_NUMBER[2] |
								 xTimeCodeErrInj.bFEE_NUMBER[3] |
								 xTimeCodeErrInj.bFEE_NUMBER[4] |
								 xTimeCodeErrInj.bFEE_NUMBER[5] |
								 xTimeCodeErrInj.bFEE_NUMBER[6] |
								 xTimeCodeErrInj.bFEE_NUMBER[7] );
	}

	if (xTimeCodeErrInj.bWrongTC == TRUE) {
			for (int i = 0; i < 8; i++) {
				if (xTimeCodeErrInj.bFEE_WRONG_NUMBER[i] == TRUE) {
					if ((xTimeCodeErrInj.usiWrongCount[i] == 0)  ){
						bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
						pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = 0;
						pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
						pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
						pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
						bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
						xTimeCodeErrInj.bFEE_WRONG_NUMBER[i] = FALSE;
					} else {
						xTimeCodeErrInj.usiWrongCount[i]--;
					}
				}
			}
			xTimeCodeErrInj.bWrongTC = (	 xTimeCodeErrInj.bFEE_WRONG_NUMBER[0] |
										 xTimeCodeErrInj.bFEE_WRONG_NUMBER[1] |
										 xTimeCodeErrInj.bFEE_WRONG_NUMBER[2] |
										 xTimeCodeErrInj.bFEE_WRONG_NUMBER[3] |
										 xTimeCodeErrInj.bFEE_WRONG_NUMBER[4] |
										 xTimeCodeErrInj.bFEE_WRONG_NUMBER[5] |
										 xTimeCodeErrInj.bFEE_WRONG_NUMBER[6] |
										 xTimeCodeErrInj.bFEE_WRONG_NUMBER[7] );
		}

	if (xTimeCodeErrInj.bUxp == TRUE)  {
		for (int i = 0; i < 8; i++) {
			if (xTimeCodeErrInj.usiUxpCount[i] > 0) {
				xTimeCodeErrInj.usiUxpCount[i]--;
			} else {
				bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
				pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
				pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
				pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = 0;
				bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
				xTimeCodeErrInj.bFEEUxp[i] = FALSE;
			}
		}
		xTimeCodeErrInj.bUxp = (	 xTimeCodeErrInj.bFEEUxp[0] |
										 xTimeCodeErrInj.bFEEUxp[1] |
										 xTimeCodeErrInj.bFEEUxp[2] |
										 xTimeCodeErrInj.bFEEUxp[3] |
										 xTimeCodeErrInj.bFEEUxp[4] |
										 xTimeCodeErrInj.bFEEUxp[5] |
										 xTimeCodeErrInj.bFEEUxp[6] |
										 xTimeCodeErrInj.bFEEUxp[7] );
	}

	if (xTimeCodeErrInj.bJitter == TRUE)  {
			for (int i = 0; i < 8; i++) {
				if (xTimeCodeErrInj.usiJitterCount[i] > 0) {
					xTimeCodeErrInj.usiJitterCount[i]--;
				} else {
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
					pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
					pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = 0;
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
					xTimeCodeErrInj.bFEEJitter[i] = FALSE;
				}
			}
			xTimeCodeErrInj.bJitter   = (	 xTimeCodeErrInj.bFEEJitter[0] |
											 xTimeCodeErrInj.bFEEJitter[1] |
											 xTimeCodeErrInj.bFEEJitter[2] |
											 xTimeCodeErrInj.bFEEJitter[3] |
											 xTimeCodeErrInj.bFEEJitter[4] |
											 xTimeCodeErrInj.bFEEJitter[5] |
											 xTimeCodeErrInj.bFEEJitter[6] |
											 xTimeCodeErrInj.bFEEJitter[7] );
		}

}

/* After stop the Sync signal generation, maybe some FEE task could be locked waiting for this signal. So we send to everyone, and after that they will flush the queue */
/* Don't need this function anymore... for now
void vReleaseSyncMessages(void) {
	unsigned char ucIL;
	unsigned char error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ulWord = 0;
	uiCmdtoSend.ucByte[2] = M_SYNC;

	for( ucIL = 0; ucIL < N_OF_NFEE; ucIL++ ){
		uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucIL;
		error_codel = OSQPost(xWaitSyncQFee[ ucIL ], (void *)uiCmdtoSend.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendMsgSync( ucIL );
		}
	}
}
*/
