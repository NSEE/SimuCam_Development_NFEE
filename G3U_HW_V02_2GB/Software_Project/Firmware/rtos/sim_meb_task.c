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

bool poweron;

volatile TImgWinContentErr *vpxImgWinContentErr = NULL;
volatile TDataPktError *vpxDataPktError = NULL;

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

				/*Send Event Log*/
				vSendEventLog(0,1,0,1,1);

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
						fprintf(fp,"\nMEB Task: Releasing Sync Module in 5 seconds\n");
					#endif

					OSTimeDlyHMSM(0, 0, 5, 200);

					/* [rfranca] */
					if (sInternal == pxMebC->eSync) {
						bSyncCtrIntern(TRUE); /*TRUE = Internal*/
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage )
							fprintf(fp,"\nMEB Task: Sync Module Released\n");
						#endif
					} else {
						bSyncCtrIntern(FALSE); /*TRUE = Internal*/
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage )
							fprintf(fp,"\nMEB Task: Waiting external Sync signal\n");
						#endif
					}

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
		volatile TCommChannel *vpxCommAChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		switch (uiCmdLocal.ucByte[2]) {
			/* Receive a PUS command */
			case Q_MEB_PUS:
				vPusMebTask( pxMebCLocal );
				break;
			/* Master Sync */
			case M_MASTER_SYNC:
				/* Perform memory SWAP */
				vSwapMemmory(pxMebCLocal);
				vTimeCodeMissCounter(pxMebCLocal);
				vDebugSyncTimeCode(pxMebCLocal);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\n============== Master Sync ==============\n\n");
					fprintf(fp,"Channels TimeCode = %d\n", (alt_u8)vpxCommAChannel->xSpacewire.xSpwcTimecodeStatus.ucTime);
				}
				#endif
				break;
			/* Normal Sync */
			case M_SYNC:
				vTimeCodeMissCounter(pxMebCLocal);
				vDebugSyncTimeCode(pxMebCLocal);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\n-------------- Sync --------------\n\n");
					fprintf(fp,"Channels TimeCode = %d\n", (alt_u8)vpxCommAChannel->xSpacewire.xSpwcTimecodeStatus.ucTime);
				}
				#endif
				break;
			/* Last Sync */
			case M_PRE_MASTER:
				vTimeCodeMissCounter(pxMebCLocal);
				vDebugSyncTimeCode(pxMebCLocal);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\n-------------- Sync --------------\n\n");
					fprintf(fp,"Channels TimeCode = %d\n", (alt_u8)vpxCommAChannel->xSpacewire.xSpwcTimecodeStatus.ucTime);
				}
				#endif
				for (int iCountFEE = 0; iCountFEE < N_OF_NFEE; iCountFEE++) {
					if (TRUE == pxMebCLocal->xFeeControl.xNfee[iCountFEE].xImgWinContentErr.bStartLeftErrorInj) {
						bDpktGetLeftContentErrInj(&pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket);
						if (TRUE == pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket.xDpktLeftContentErrInj.bInjecting) {
							bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket, eDpktCcdSideE);
						}
						if (bDpktContentErrInjStartInj(&pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket, eDpktCcdSideE)) {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
								fprintf(fp, "MEB Task: [FEE %u] Image and window error injection started (left side)\n", iCountFEE);
							#endif
						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
								fprintf(fp, "MEB Task: [FEE %u] Image and window error injection could not start (left side)\n", iCountFEE);
							#endif
						}
						pxMebCLocal->xFeeControl.xNfee[iCountFEE].xImgWinContentErr.bStartLeftErrorInj = FALSE;
					}
					if (TRUE == pxMebCLocal->xFeeControl.xNfee[iCountFEE].xImgWinContentErr.bStartRightErrorInj) {
						bDpktGetRightContentErrInj(&pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket);
						if (TRUE == pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket.xDpktRightContentErrInj.bInjecting) {
							bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket, eDpktCcdSideF);
						}
						if (bDpktContentErrInjStartInj(&pxMebCLocal->xFeeControl.xNfee[iCountFEE].xChannel.xDataPacket, eDpktCcdSideF)) {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
								fprintf(fp, "MEB Task: [FEE %u] Image and window error injection started (right side)\n", iCountFEE);
							#endif
						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
								fprintf(fp, "MEB Task: [FEE %u] Image and window error injection could not start (right side)\n", iCountFEE);
							#endif
						}
						pxMebCLocal->xFeeControl.xNfee[iCountFEE].xImgWinContentErr.bStartRightErrorInj = FALSE;
					}
					if (TRUE == pxMebCLocal->xFeeControl.xNfee[iCountFEE].xDataPktError.bStartErrorInj) {
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
						pxMebCLocal->xFeeControl.xNfee[iCountFEE].xDataPktError.bStartErrorInj = FALSE;
					}
				}
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
				vPusMebInTaskConfigMode(pxMebCLocal, &xPusLocal);
				break;
			case sMebRun:
			case sMebToRun:
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
	unsigned short int param1 = 0;
	alt_u32 ulEP, ulStart, ulPx, ulLine;
	unsigned char ucFeeInstL;
	unsigned char ucDTSourceL;
	alt_u16 usiCfgPxColX       = 0;
	alt_u16 usiCfgPxRowY       = 0;
	alt_u16 usiCfgPxSide       = 0;
	alt_u16 usiCfgCountFrames  = 0;
	alt_u16 usiCfgFramesActive = 0;
	alt_u16 usiCfgPxValue      = 0;
	bool bPixelAlreadyExist = FALSE;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage )
		fprintf(fp,"MEB Task: vPusType250conf - Command: %hhu.", xPusL->usiSubType);
	#endif


	switch (xPusL->usiSubType) {
		/* TC_SYNCH_SOURCE */
		case 29:
			/* Set sync source */
			param1 = xPusL->usiValues[0];
			if (0 == param1) {
				/*TRUE = Internal*/
				vChangeSyncSource( pxMebCLocal, sInternal );
			} else {
				vChangeSyncSource( pxMebCLocal, sExternal );
			}
			break;
		/*case 34:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
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
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			bRmapGetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingIdEn = xPusL->usiValues[1];
			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
				fprintf(fp, "usiValues[1]: %hu;\n", xPusL->usiValues[1] );
				fprintf(fp, "ucFeeInstL : %hu;\n", ucFeeInstL           );
			}
			#endif
		break;
		/* TC_SCAMxx_RMAP_ECHO_DISABLE */
		case 37:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			bRmapGetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = FALSE;
			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
				fprintf(fp, "ucFeeInstL : %hu;\n", ucFeeInstL           );
			}
			#endif
		break;

		/* TC_SCAM_FEE_HK_UPDATE_VALUE [bndky] */
		case 58:
			vSendHKUpdate(pxMebCLocal, xPusL);
			break;
		/* TC_SCAM_ERR_OFF */
		case 53:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"TC_SCAM_ERR_OFF\n");
				#endif
				bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
				bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);

				bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
				bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

				/* Force the stop of any ongoing SpW Codec Errors */
				bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
				bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

				/* Stop and correct SpW Destination Address Error */
				if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
					xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
					bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
					bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				}

				bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.bTriggerErr = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.ucErrorId = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.uliValue = 0;
				bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

				bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
				bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);

				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bTxDisabled = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingPkts = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingData = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.ucFrameNum = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiSequenceCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiNRepeat = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiDataCnt = 0;

				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bTxDisabled = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingPkts = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingData = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.ucFrameNum = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiSequenceCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiNRepeat = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiDataCnt = 0;

				bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
				bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

				bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError.ucErrorCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError.bStartErrorInj = FALSE;

				bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideE);
				bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideF);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.ucLeftErrorCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.ucRightErrorCnt = 0;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.bStartLeftErrorInj = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.bStartRightErrorInj = FALSE;
			break;
		/* TC_SCAMXX_SPW_ERR_TRIG */
		case 46:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure SpaceWire errors while in MEB Config. Mode \n" );
			}
			#endif
			break;
		/* TC_SCAMXX_RMAP_ERR_TRIG */
		case 47:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure RMAP errors while in MEB Config. Mode \n" );
			}
			#endif
			break;
		/* TC_SCAMXX_TICO_ERR_TRIG */
		case 48:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure TimeCode errors while in MEB Config. Mode \n" );
			}
			#endif
			break;
		/* TC_SCAM_IMAGE_ERR_MISS_PKT_TRIG */
		case 49:
		/* TC_SCAM_IMAGE_ERR_NOMOREPKT_TRIG */
		case 50:
		/* TC_SCAM_IMAGE_ERR_MISSDATA_TRIG */
		case 67:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure Image Transmission errors while in MEB Config. Mode \n" );
			}
			#endif
			break;
		/* TC_SCAM_WIN_ERR_MISS_PKT_TRIG */
		case 51:
		/* TC_SCAM_WIN_ERR_NOMOREPKT_TRIG */
		case 52:
		/* TC_SCAM_WIN_ERR_MISSDATA_TRIG */
		case 72:
		/* TC_SCAM_WIN_ERR_DISABLE_WIN_PROG */
		case 63:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure Windowing Transmission errors while in MEB Config. Mode \n" );
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

		/* TC_SCAM_FEE_TIME_CONFIG */
		case 64:
			ulEP = (alt_u32)( (alt_u32)(xPusL->usiValues[0] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[1] & 0x0000ffff) );
			ulStart = (alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) );
			ulPx = (alt_u32)( (alt_u32)(xPusL->usiValues[4] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[5] & 0x0000ffff) );
			ulLine = (alt_u32)( (alt_u32)(xPusL->usiValues[6] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[7] & 0x0000ffff) );
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
			//bSyncConfigNFeeSyncPeriod( (alt_u16)ulEP ); // Change to update usiEP em xMeb for STATUS REPORT
			if (bSyncConfigNFeeSyncPeriod( (alt_u16)ulEP ) == TRUE) {
				pxMebCLocal->usiEP = (alt_u16)ulEP;
			}


			for (ucFeeInstL = 0; ucFeeInstL < N_OF_NFEE; ucFeeInstL++) {
				bDpktGetPixelDelay(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktPixelDelay.uliStartDelay = uliPxDelayCalcPeriodMs( ulStart );
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktPixelDelay.uliAdcDelay = uliPxDelayCalcPeriodNs( ulPx );
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktPixelDelay.uliLineDelay = uliPxDelayCalcPeriodNs( ulLine );
				bDpktSetPixelDelay(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			}

			break;

	/* TC_SCAM_FEE_DATA_SOURCE */
	case 70:
		ucFeeInstL = (unsigned char)xPusL->usiValues[0];
		ucDTSourceL = (unsigned char)xPusL->usiValues[1];
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
			fprintf(fp,"MEB Task: DATA_SOURCE ucFeeInstL= %hhu, ucDTSourceL= %hhu\n",ucFeeInstL,ucDTSourceL  );
		#endif
		vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_DT_SOURCE, ucDTSourceL, ucDTSourceL );
		break;

	/* TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG */
	case 73:
		ucFeeInstL = (unsigned char)xPusL->usiValues[0];

		usiCfgPxColX       = xPusL->usiValues[1];
		usiCfgPxRowY       = xPusL->usiValues[2];
		usiCfgPxSide       = xPusL->usiValues[3];
		usiCfgCountFrames  = xPusL->usiValues[4];
		usiCfgFramesActive = xPusL->usiValues[5];
		usiCfgPxValue      = xPusL->usiValues[6];

		bPixelAlreadyExist = FALSE;

		vpxImgWinContentErr = &(pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr);

		if (usiCfgFramesActive == 0) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: invalid frames active parameter (0)\n", ucFeeInstL);
			}
			#endif
		} else if (100 <= (vpxImgWinContentErr->ucLeftErrorCnt + vpxImgWinContentErr->ucRightErrorCnt)) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Already have 100 content errors \n", ucFeeInstL);
			}
			#endif
			break;
		} else {
			/* Side: 0 = Left; 1 = Right; 2 = Both */
			if ((usiCfgPxSide == 0) || (usiCfgPxSide == 2)) {
				bPixelAlreadyExist = FALSE;
				if (vpxImgWinContentErr->ucLeftErrorCnt > 0){
					for (int iSeekEquals = 0; iSeekEquals < vpxImgWinContentErr->ucLeftErrorCnt; iSeekEquals++) {
						if  ( (vpxImgWinContentErr->xLeftErrorList[iSeekEquals].usiPxColX == usiCfgPxColX) && (vpxImgWinContentErr->xLeftErrorList[iSeekEquals].usiPxRowY == usiCfgPxRowY)) {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp, "MEB Task: [FEE %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Left Position X, Y already exists\n", ucFeeInstL);
							}
							#endif
							bPixelAlreadyExist = TRUE;
							break;
						}
					}
				}
				if (FALSE == bPixelAlreadyExist) {
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiPxColX       = usiCfgPxColX;
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiPxRowY       = usiCfgPxRowY;
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiCountFrames  = usiCfgCountFrames;
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiFramesActive = usiCfgCountFrames + usiCfgFramesActive - 1;
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiPxValue      = usiCfgPxValue;

					vpxImgWinContentErr->ucLeftErrorCnt++;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG LEFT: %u\n", ucFeeInstL, vpxImgWinContentErr->ucLeftErrorCnt);
					}
					#endif
				}
			}
			/* Side: 0 = Left; 1 = Right; 2 = Both */
			if ( (usiCfgPxSide == 1) || (usiCfgPxSide == 2)){
				bPixelAlreadyExist = FALSE;
				if (vpxImgWinContentErr->ucRightErrorCnt > 0){
					for (int iSeekEquals = 0; iSeekEquals < vpxImgWinContentErr->ucRightErrorCnt; iSeekEquals++) {
						if  ( (vpxImgWinContentErr->xRightErrorList[iSeekEquals].usiPxColX == usiCfgPxColX) && (vpxImgWinContentErr->xRightErrorList[iSeekEquals].usiPxRowY == usiCfgPxRowY)) {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp, "MEB Task: [FEE %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Right Position X, Y already exists\n", ucFeeInstL);
							}
							#endif
							bPixelAlreadyExist = TRUE;
							break;
						}
					}
				}
				if (FALSE == bPixelAlreadyExist) {
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiPxColX       = usiCfgPxColX;
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiPxRowY       = usiCfgPxRowY;
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiCountFrames  = usiCfgCountFrames;
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiFramesActive = usiCfgCountFrames + usiCfgFramesActive - 1;
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiPxValue      = usiCfgPxValue;

					vpxImgWinContentErr->ucRightErrorCnt++;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG RIGHT: %u\n", ucFeeInstL, vpxImgWinContentErr->ucRightErrorCnt);
					}
					#endif
				}
			}
		}
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			fprintf(fp, "MEB Task: [FEE %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG\n", ucFeeInstL);
		}
		#endif
		break;

	/* TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG_FINISH */
	case 74:
		ucFeeInstL = (unsigned char)xPusL->usiValues[0];
		vpxImgWinContentErr = &(pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr);

		usiCfgPxSide = xPusL->usiValues[1];

		/* Side: 0 = Left; 1 = Right; 2 = Both */
		if ((0 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
			qsort((TImgWinContentErrData *)(vpxImgWinContentErr->xLeftErrorList), vpxImgWinContentErr->ucLeftErrorCnt, sizeof(TImgWinContentErrData), iCompareImgWinContent);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] Image and window content error list sorted (left side)\n", ucFeeInstL);
			}
			#endif

			if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideE)) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Image and window content error list cleared (left side)\n", ucFeeInstL);
				}
				#endif
				if (bDpktContentErrInjOpenList(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideE)) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] Image and window content error list opened (left side)\n", ucFeeInstL);
					}
					#endif
					if (vpxImgWinContentErr->ucLeftErrorCnt > 0) {
						for (int iListCount=0; iListCount < vpxImgWinContentErr->ucLeftErrorCnt; iListCount++) {
							ucDpktContentErrInjAddEntry( &pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket,
														 eDpktCcdSideE,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiCountFrames,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiFramesActive,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxColX,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxRowY,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxValue);
//							#if DEBUG_ON
//							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
//								fprintf(fp, "\nHW LEFT ucDpktContentErrInjAddEntry Data\n" );
//								fprintf(fp, "HW Position X :%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxColX);
//								fprintf(fp, "HW Position Y :%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxRowY);
//								fprintf(fp, "HW Start Frame:%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiCountFrames);
//								fprintf(fp, "HW Stop  Frame:%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiFramesActive);
//								fprintf(fp, "HW Pixel Value:%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxValue);
//							}
//							#endif
						}
					}
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] Finished adding image and window content error list to HW (left side)\n", ucFeeInstL);
					}
					#endif
					if (bDpktContentErrInjCloseList(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideE)){
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "MEB Task: [FEE %u] Image and window content error list closed (left side)\n", ucFeeInstL);
						}
						#endif
					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "MEB Task: [FEE %u] Image and window content error list closing problems (left side)\n", ucFeeInstL);
						}
						#endif
					}
					bDpktGetLeftContentErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] Image and window content number of entries = %u (left side)\n", ucFeeInstL, (alt_u8)pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktLeftContentErrInj.ucErrorsCnt);
					}
					#endif
				}
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Image and window content error list clear problem (left side)\n", ucFeeInstL);
				}
				#endif
			}
		}

		/* Side: 0 = Left; 1 = Right; 2 = Both */
		if ((1 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
			qsort((TImgWinContentErrData *)(vpxImgWinContentErr->xRightErrorList), vpxImgWinContentErr->ucRightErrorCnt, sizeof(TImgWinContentErrData), iCompareImgWinContent);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] Image and window content error list sorted (right side)\n", ucFeeInstL);
			}
			#endif

			if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideF)) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Image and window content error list cleared (right side)\n", ucFeeInstL);
				}
				#endif
				if (bDpktContentErrInjOpenList(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideF)) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] Image and window content error list opened (right side)\n", ucFeeInstL);
					}
					#endif
					if (vpxImgWinContentErr->ucRightErrorCnt > 0) {
						for (int iListCount=0; iListCount < vpxImgWinContentErr->ucRightErrorCnt; iListCount++) {
							ucDpktContentErrInjAddEntry( &pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket,
														 eDpktCcdSideF,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiCountFrames,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiFramesActive,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiPxColX,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiPxRowY,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiPxValue);
//							#if DEBUG_ON
//							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
//								fprintf(fp, "\nHW RIGHT ucDpktContentErrInjAddEntry Data\n" );
//								fprintf(fp, "HW Position X :%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiPxColX);
//								fprintf(fp, "HW Position Y :%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiPxRowY);
//								fprintf(fp, "HW Start Frame:%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiCountFrames);
//								fprintf(fp, "HW Stop  Frame:%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiFramesActive);
//								fprintf(fp, "HW Pixel Value:%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiPxValue);
//							}
//							#endif
						}
					}
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] Finished adding image and window content error list to HW (right side)\n", ucFeeInstL);
					}
					#endif
					if (bDpktContentErrInjCloseList(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideF)){
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "MEB Task: [FEE %u] Image and window content error list closed (right side)\n", ucFeeInstL);
						}
						#endif
					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "MEB Task: [FEE %u] Image and window content error list closing problems (right side)\n", ucFeeInstL);
						}
						#endif
					}
					bDpktGetRightContentErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] Image and window content number of entries = %u (right side)\n", ucFeeInstL, (alt_u8)pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRightContentErrInj.ucErrorsCnt);
					}
					#endif
				}
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Image and window content error list clear problem (right side)\n", ucFeeInstL);
				}
				#endif
			}
		}

		break;

	/* TC_SCAMxx_IMGWIN_CONTENT_ERR_CLEAR */
	case 75:
		ucFeeInstL = (unsigned char)xPusL->usiValues[0];
		vpxImgWinContentErr = &(pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr);

		usiCfgPxSide = xPusL->usiValues[1];

		/* Side: 0 = Left; 1 = Right; 2 = Both */
		if ((0 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
			if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideE)) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Image and window error list cleared (left side)\n", ucFeeInstL);
				}
				#endif

			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Image and window error list not cleared in HW (left side)\n", ucFeeInstL);
				}
				#endif
			}
			vpxImgWinContentErr->ucLeftErrorCnt = 0;
		}

		/* Side: 0 = Left; 1 = Right; 2 = Both */
		if ((1 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
			if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideF)) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Image and window error list cleared (right side)\n", ucFeeInstL);
				}
				#endif

			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Image and window error list not cleared in HW (right side)\n", ucFeeInstL);
				}
				#endif
			}
			vpxImgWinContentErr->ucRightErrorCnt = 0;
		}

		break;

	/* TC_SCAMxx_DATA_PKT_ERR_CONFIG */
	case 78:
		ucFeeInstL = (unsigned char)xPusL->usiValues[0];
		vpxDataPktError = &(pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError);

		alt_u16 usiCfgFrameCounter    = xPusL->usiValues[1];
		alt_u16 usiCfgSequenceCounter = xPusL->usiValues[2];
		alt_u16 usiCfgFieldId         = xPusL->usiValues[3];
		alt_u16 usiCfgFieldValue      = xPusL->usiValues[4];

		if (10 >= vpxDataPktError->ucErrorCnt) {
			vpxDataPktError->xErrorList[vpxDataPktError->ucErrorCnt].usiFrameCounter    = usiCfgFrameCounter;
			vpxDataPktError->xErrorList[vpxDataPktError->ucErrorCnt].usiSequenceCounter = usiCfgSequenceCounter;
			vpxDataPktError->xErrorList[vpxDataPktError->ucErrorCnt].usiFieldId         = usiCfgFieldId;
			vpxDataPktError->xErrorList[vpxDataPktError->ucErrorCnt].usiFieldValue      = usiCfgFieldValue;
			vpxDataPktError->ucErrorCnt++;
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] Data packet error added to list. Number of entries = %u\n", ucFeeInstL, vpxDataPktError->ucErrorCnt);
			}
			#endif
			break;
		} else {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] Data packet error list already have 10 entries\n", ucFeeInstL);
			}
			#endif
			break;
		}

	/* TC_SCAMxx_DATA_PKT_ERR_CONFIG_FINISH */
	case 79:
		ucFeeInstL = (unsigned char)xPusL->usiValues[0];
		vpxDataPktError = &(pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError);

		if (vpxDataPktError->ucErrorCnt > 0){
			qsort ((TDataPktErrorData *)(vpxDataPktError->xErrorList), vpxDataPktError->ucErrorCnt, sizeof(TDataPktErrorData), iCompareDataPktError);
		}
		if (bDpktHeaderErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket)) {
			if (bDpktHeaderErrInjOpenList(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket)) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] Data packet error list opened\n", ucFeeInstL);
				}
				#endif
				for (int iListCount = 0 ; iListCount < vpxDataPktError->ucErrorCnt; iListCount++){
					ucDpktHeaderErrInjAddEntry(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket,
												vpxDataPktError->xErrorList[iListCount].usiFrameCounter,
												vpxDataPktError->xErrorList[iListCount].usiSequenceCounter,
												vpxDataPktError->xErrorList[iListCount].usiFieldId,
												vpxDataPktError->xErrorList[iListCount].usiFieldValue);

				}
				if (&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket){
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] Data packet error list closed. Finished adding errors to HW\n", ucFeeInstL);
					}
					#endif
				}
			}
		} else {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] Data packet error list clear problem\n", ucFeeInstL);
			}
			#endif
		}
		break;

	/* TC_SCAMxx_DATA_PKT_ERR_CLEAR */
	case 80:
		ucFeeInstL = (unsigned char)xPusL->usiValues[0];
		vpxDataPktError = &(pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError);

		if (bDpktHeaderErrInjClearEntries(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket)) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] Data packet error list cleared\n", ucFeeInstL);
			}
			#endif
			vpxDataPktError->ucErrorCnt = 0;
		} else {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] Data packet error list clear problem\n", ucFeeInstL);
			}
			#endif
		}
		break;
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
	unsigned char ucFeeInstL;

	ucFeeInstL = (unsigned char)xPusL->usiValues[0];
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

			/* todo: For now we can only update the Logical Address and the RMAP Key */

			/* Disable the RMAP interrupt */
			bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteConfigEn = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteWindowEn = FALSE;
			bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);

			/* Change the configuration */
			bRmapGetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap );
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char)xPusL->usiValues[6];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char)xPusL->usiValues[3];
			bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap );

			bSpwcEnableTimecodeTrans(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire, xPusL->usiValues[5] == 1 );

			bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
			if ( xPusL->usiValues[7] == 0 ) { /*Auto Start*/
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
			} else {
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
			}

			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv( (unsigned char)xPusL->usiValues[2] );

			bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);

			bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xPusL->usiValues[4]; /*Dest Node*/
			bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

			/* Enable the RMAP interrupt */
			bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteConfigEn = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteWindowEn = TRUE;
			bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);

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
	unsigned char ucFeeInstL;
	unsigned char ucDTSourceL;
	unsigned char ucShutDownI = 0;
	alt_u16 usiCfgPxSide       = 0;

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
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			bRmapGetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingIdEn = xPusL->usiValues[1];
			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
				fprintf(fp, "usiValues[1]: %hu;\n", xPusL->usiValues[1] );
				fprintf(fp, "ucFeeInstL : %hu;\n", ucFeeInstL           );
			}
			#endif
		break;
		/* TC_SCAMxx_RMAP_ECHO_DISABLE */
		case 37:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			bRmapGetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = FALSE;
			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
				fprintf(fp, "ucFeeInstL : %hu;\n", ucFeeInstL           );
			}
			#endif
		break;
		/* TC_SCAMXX_SPW_ERR_TRIG */
		case 46:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			/* Disconnect Error Injection */
			switch (xPusL->usiValues[3])
			{

				/* Exchange Level Error: Parity Error */
				case 0:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
						xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
						pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdParity;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Parity Error\n" );
					}
					#endif
					break;

				/* Exchange Level Error: Disconnect Error */
				case 1:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
						xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
						pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdDiscon;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Disconnect Error\n" );
					}
					#endif
					break;

				/* Exchange Level Error: Escape Sequence Error */
				case 2:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
						xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
						pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdEscape;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Escape Sequence Error\n" );
					}
					#endif
					break;

				/* Exchange Level Error: Character Sequence Error */
				case 3:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
						xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
						pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdChar;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Character Sequence Error\n" );
					}
					#endif
					break;

				/* Exchange Level Error: Credit Error */
				case 4:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
						xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
						pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdCredit;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Character Sequence Error\n" );
					}
					#endif
					break;

				/* Network Level Error: EEP Received */
				case 5:
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
						xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
						pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Inject selected SpW Error */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = xPusL->usiValues[2];
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = xPusL->usiValues[1];
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Network Level Error - EEP Received\n" );
					}
					#endif
					break;

				/* Network Level Error: Invalid Destination Address */
				case 6:
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
						xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
						pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					}
					/* Inject selected SpW Error */
					bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr = pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = (alt_u8)xPusL->usiValues[1];
					bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
					xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = TRUE;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Network Level Error - Invalid Destination Address\n" );
					}
					#endif
					break;

				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Invalid Error\n" );
					}
					#endif
					break;
			}
			break;
		/* TC_SCAMXX_RMAP_ERR_TRIG */
		case 47:
				ucFeeInstL = (unsigned char)xPusL->usiValues[0];
				bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.bTriggerErr = TRUE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.ucErrorId   = xPusL->usiValues[1];
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.uliValue    = (alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) );
				bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				#if DEBUG_ON
					fprintf(fp, "TC_SCAMxx_RMAP_ERR_TRIG\n" );
				#endif
			break;
		/* TC_SCAMXX_TICO_ERR_TRIG */
		case 48:
				ucFeeInstL = (unsigned char)xPusL->usiValues[0];

				switch (xPusL->usiValues[5]) {

				/* Time-Code Missing Error */
				case 0:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					bSpwcGetTimecodeStatus(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					xTimeCodeErrInj.bMissTC = TRUE;
					xTimeCodeErrInj.bFEE_NUMBER[ucFeeInstL]  = TRUE;
					xTimeCodeErrInj.usiMissCount[ucFeeInstL] = xPusL->usiValues[4];
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Time-Code Missing Error\n" );
					}
					#endif
					break;

				/* Wrong Time-Code Error */
				case 1:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = xPusL->usiValues[1];
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					bSpwcGetTimecodeStatus(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					xTimeCodeErrInj.bWrongTC = TRUE;
					xTimeCodeErrInj.bFEE_WRONG_NUMBER[ucFeeInstL] = TRUE;
					xTimeCodeErrInj.usiWrongCount[ucFeeInstL] = xPusL->usiValues[4];
					xTimeCodeErrInj.usiWrongOffSet[ucFeeInstL] = xPusL->usiValues[1];
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Wrong Time-Code Error\n" );
					}
					#endif
					break;

				/* Unexpected Time-Code Error */
				case 2:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = uliTimecodeCalcDelayMs((alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) ));
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					xTimeCodeErrInj.usiWrongCount[ucFeeInstL] =   xPusL->usiValues[4];
					xTimeCodeErrInj.bUxp = TRUE;
					xTimeCodeErrInj.bFEEUxp[ucFeeInstL] = TRUE;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Unexpected Time-Code Error\n" );
					}
					#endif
					break;

				/* Jitter on Time-Code Error */
				case 3:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = uliTimecodeCalcDelayMs((alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) ));
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
					xTimeCodeErrInj.bFEEJitter[ucFeeInstL] = TRUE;
					xTimeCodeErrInj.bJitter = TRUE;
					xTimeCodeErrInj.usiJitterCount[ucFeeInstL] = xPusL->usiValues[4];
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Jitter on Time-Code Error\n" );
					}
					#endif
					break;

				/* Invalid Error Code */
				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Invalid Error\n" );
					}
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
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingPkts = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bTxDisabled = FALSE;
			break;

		/* TC_SCAM_IMAGE_ERR_NOMOREPKT_TRIG */
		case 50:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bTxDisabled = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			break;

		/* TC_SCAM_WIN_ERR_MISS_PKT_TRIG */
		case 51:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingPkts = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bTxDisabled = FALSE;
			/* Enable Window List */
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"\nTC_SCAM_WIN_ERR_MISS_PKT_TRIG\n");
			#endif
			break;

		/* TC_SCAM_WIN_ERR_NOMOREPKT_TRIG */
		case 52:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bTxDisabled = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			/* Enable Window List */
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"\n TC_SCAM_WIN_ERR_NOMOREPKT_TRIG\n");
			#endif
			break;

		/* TC_SCAM_ERR_OFF */
		case 53:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"TC_SCAM_ERR_OFF\n");
			#endif
			bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
			bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);

			bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
			bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

			bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.bTriggerErr = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.ucErrorId = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.uliValue = 0;
			bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);

			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bTxDisabled = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.ucFrameNum = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiSequenceCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiNRepeat = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiDataCnt = 0;

			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bTxDisabled = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.ucFrameNum = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiSequenceCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiNRepeat = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiDataCnt = 0;

			bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
			bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

			/* Force the stop of any ongoing SpW Codec Errors */
			bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
			bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

			/* Stop and correct SpW Destination Address Error */
			if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
				xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
				bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
				bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			}

			bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError.ucErrorCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError.bStartErrorInj = FALSE;

			bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideE);
			bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideF);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.ucLeftErrorCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.ucRightErrorCnt = 0;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.bStartLeftErrorInj = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.bStartRightErrorInj = FALSE;
			break;
		/* TC_SCAM_WIN_ERR_DISABLE_WIN_PROG */
		case 63:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = FALSE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			/* Disable others windowing errors */
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bTxDisabled = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingData = FALSE;
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_DISABLE_WIN_PROG:%i\n", pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn);
			#endif
			break;

		/* TC_SCAM_IMAGE_ERR_MISSDATA_TRIG */
		case 67:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingData = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bTxDisabled = FALSE;
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

		/* TC_SCAM_FEE_DATA_SOURCE */
		case 70:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			ucDTSourceL = (unsigned char)xPusL->usiValues[1];
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"MEB Task: DATA_SOURCE ucFeeInstL= %hhu, ucDTSourceL= %hhu\n",ucFeeInstL,ucDTSourceL  );
			#endif
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_DT_SOURCE, ucDTSourceL, ucDTSourceL );
			break;

		/* TC_SCAM_WIN_ERR_MISSDATA_TRIG */
		case 72:
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingData = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bTxDisabled = FALSE;
			/* Enable Window List */
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_MISSDATA_TRIG\n" );
			#endif
			break;

		case 76: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_START_INJ */
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			vpxImgWinContentErr = &(pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr);

			usiCfgPxSide = xPusL->usiValues[1];

			/* Side: 0 = Left; 1 = Right; 2 = Both */
			if ((0 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
				vpxImgWinContentErr->bStartLeftErrorInj = TRUE;

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp, "MEB Task: [FEE %u] Image and window content error injection scheduled (left side)\n", ucFeeInstL);
				#endif
			}

			/* Side: 0 = Left; 1 = Right; 2 = Both */
			if ((1 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
				vpxImgWinContentErr->bStartRightErrorInj = TRUE;

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp, "MEB Task: [FEE %u] Image and window content error injection scheduled (right side)\n", ucFeeInstL);
				#endif
			}

			break;

		case 77: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_STOP_INJ */
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];

			usiCfgPxSide = xPusL->usiValues[1];

			/* Side: 0 = Left; 1 = Right; 2 = Both */
			if ((0 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
				if ( bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideE) ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "MEB Task: [FEE %u] Image and window error injection stopped (left side)\n", ucFeeInstL);
					#endif
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "MEB Task: [FEE %u] Image and window error was not injecting or injection had finished (left side)\n", ucFeeInstL);
					#endif
				}
			}

			/* Side: 0 = Left; 1 = Right; 2 = Both */
			if ((1 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
				if ( bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideF) ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "MEB Task: [FEE %u] Image and window error injection stopped (right side)\n", ucFeeInstL);
					#endif
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp, "MEB Task: [FEE %u] Image and window error was not injecting or injection had finished (right side)\n", ucFeeInstL);
					#endif
				}
			}

			break;

		case 81: /* TC_SCAMxx_DATA_PKT_ERR_START_INJ */
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			vpxDataPktError = &(pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError);

			vpxDataPktError->bStartErrorInj = TRUE;

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: [FEE %u] Data packet error injection scheduled\n", ucFeeInstL);
			#endif

			break;

		case 82: /* TC_SCAMxx_DATA_PKT_ERR_STOP_INJ */
			ucFeeInstL = (unsigned char)xPusL->usiValues[0];
			if ( bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[xPusL->usiValues[0]].xChannel.xDataPacket) ) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp, "MEB Task: [FEE %u] Data packet error injection stopped\n", ucFeeInstL);
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp, "MEB Task: [FEE %u] Data packet error was not injecting or injection had finished\n", ucFeeInstL);
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
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_CONFIG, 0, ucFeeInstL );
			break;
		/* TC_SCAM_FEE_STANDBY_ENTER */
		case 2:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_STANDBY, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_FULLIMAGE_ENTER */
		case 3:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_FULL, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_WINDOWING _ENTER */
		case 4:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_WIN, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_FULLIMAGE_PATTERN_ENTER */
		case 5:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_FULL_PATTERN, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_WINDOWING_PATTERN_ENTER */
		case 6:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_WIN_PATTERN, 0, ucFeeInstL );
			break;
		/* NFEE_ON */
		case 11:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_ON, 0, ucFeeInstL );
			break;
		case 12:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_PAR_TRAP_1, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_PARALLEL_TRAP_PUMP_2_ENTER */
		case 13:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_PAR_TRAP_2, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_SERIAL_TRAP_PUMP_1_ENTER */
		case 14:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(ucFeeInstL, M_FEE_SERIAL_TRAP_1, 0, ucFeeInstL );
			break;
		/* NFEE_RUNNING_SERIAL_TRAP_PUMP_2_ENTER */
		case 15:
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
	unsigned char ucFeeInstL;

	ucFeeInstL = (unsigned char)xPusL->usiValues[0];
	switch (xPusL->usiSubType) {
		case 3: /* TC_SCAM_SPW_LINK_ENABLE */
			bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
			if (bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire)){
				vSendEventLog(ucFeeInstL + 1, 0, 0, 0, 1);
			} else {
				vSendEventLog(ucFeeInstL + 1, 0, 0, 0, 3);
			}
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.bChannelEnable = TRUE;
//			bSetPainelLeds( LEDS_OFF , uliReturnMaskR( pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].ucSPWId ) );
//			bSetPainelLeds( LEDS_ON , uliReturnMaskG( pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].ucSPWId ) );

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: Link enable (NFEE-%hu)\n\n", ucFeeInstL);
			#endif
			break;

		case 4: /* TC_SCAM_SPW_LINK_DISABLE */
			bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bDisconnect = TRUE;
			if (bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire)) {
				vSendEventLog(ucFeeInstL + 1, 0, 0, 1, 1);
			} else {
				vSendEventLog(ucFeeInstL + 1, 0, 0, 1, 3);
			}
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.bChannelEnable = FALSE;
//			bSetPainelLeds( LEDS_OFF , uliReturnMaskG( pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].ucSPWId ) );
//			bSetPainelLeds( LEDS_ON , uliReturnMaskR( pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].ucSPWId ) );

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: Link disable (NFEE-%hu)\n\n", ucFeeInstL);
			#endif
			break;

		case 5: /* TC_SCAM_SPW_LINK_RESET */
			/* todo:Do nothing, don't know what is reset spw link */
			break;

		case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */

			/* todo: For now we can only update the Logical Address and the RAMP Key */
			if ( pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.eMode == sConfig ) {
				/* Disable the RMAP interrupt */
				bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteConfigEn = FALSE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteWindowEn = FALSE;
				bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);

				/* Change the configuration */
				bRmapGetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap );
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char)xPusL->usiValues[12];
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char)xPusL->usiValues[9];
				bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap );

				bSpwcEnableTimecodeTrans(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire, xPusL->usiValues[11] == 1 );

				bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
				if ( xPusL->usiValues[7] == 0 ) { /*Auto Start*/
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
				} else {
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
					pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.bLinkStart = TRUE;
				}

				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv( (unsigned char)xPusL->usiValues[8] );

				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = xPusL->usiValues[10]; /*Dest Node*/

				bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);


				/* Enable the RMAP interrupt */
				bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteConfigEn = TRUE;
				pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteWindowEn = TRUE;
				bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xRmap);

			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage )
					fprintf(fp,"MEB Task: NFEE-%hu is not in the Config Mode ( Changes not performed )\n\n", ucFeeInstL);
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
	unsigned char ucFeeInstL;

	/* Stop the Sync (Stopping the simulation) */
	bStopSync();
	bClearSync();
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

	/* Disable all errors */
	for (ucFeeInstL = 0; ucFeeInstL < N_OF_NFEE; ucFeeInstL++) {

		bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
		bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xSpacewire);

		bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
		bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

		bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.bTriggerErr = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.ucErrorId = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktRmapErrInj.uliValue = 0;
		bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

		bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
		bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xFeeBuffer);

		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bTxDisabled = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingPkts = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.bMissingData = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.ucFrameNum = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiSequenceCnt = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiNRepeat = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlFull.usiDataCnt = 0;

		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bTxDisabled = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingPkts = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.bMissingData = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.ucFrameNum = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiSequenceCnt = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiNRepeat = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xControl.xErrorSWCtrlWin.usiDataCnt = 0;

		bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
		bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

		/* Force the stop of any ongoing SpW Codec Errors */
		bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
		bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);

		/* Stop and correct SpW Destination Address Error */
		if (TRUE == xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn){
			xSpacewireErrInj[ucFeeInstL].bDestinationErrorEn = FALSE;
			bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
			pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xSpacewireErrInj[ucFeeInstL].ucOriginalDestAddr;
			bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
		}

		bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket);
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError.ucErrorCnt = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xDataPktError.bStartErrorInj = FALSE;

		bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideE);
		bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xChannel.xDataPacket, eDpktCcdSideF);
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.ucLeftErrorCnt = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.ucRightErrorCnt = 0;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.bStartLeftErrorInj = FALSE;
		pxMebCLocal->xFeeControl.xNfee[ucFeeInstL].xImgWinContentErr.bStartRightErrorInj = FALSE;

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
	 *   -- 1st key: Y position
	 *   -- 2nd key: X position
	 */

	TImgWinContentErrData *pxImgWinA = (TImgWinContentErrData *)cvpImgWinA;
	TImgWinContentErrData *pxImgWinB = (TImgWinContentErrData *)cvpImgWinB;

	/* 1st key (Y position) compare */
	if (pxImgWinA->usiPxRowY > pxImgWinB->usiPxRowY) {
		/* (ImgWinA > ImgWinB) : (return > 0) */
		iCompResult = 1;
	} else if (pxImgWinA->usiPxRowY < pxImgWinB->usiPxRowY) {
		/* (ImgWinA < ImgWinB) : (return > 0) */
		iCompResult = -1;
	} else {
		/* 1st key (Y position) is the same */
		/* 2nd key (X position) compare */
		if (pxImgWinA->usiPxColX > pxImgWinB->usiPxColX) {
			/* (ImgWinA > ImgWinB) : (return > 0) */
			iCompResult = 1;
		} else if (pxImgWinA->usiPxColX < pxImgWinB->usiPxColX) {
			/* (ImgWinA < ImgWinB) : (return > 0) */
			iCompResult = -1;
		} else {
			/* 2nd key (X position) is the same */
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

	TDataPktErrorData *pxDataPktErrA = (TDataPktErrorData *)cvpDataPktErrA;
	TDataPktErrorData *pxDataPktErrB = (TDataPktErrorData *)cvpDataPktErrB;

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

void vTimeCodeMissCounter(TSimucam_MEB * pxMebCLocal) {
	if (xTimeCodeErrInj.bMissTC == TRUE) {
		for ( int i = 0; i < 8; i++ ) {
			if ( xTimeCodeErrInj.bFEE_NUMBER[i] == TRUE ) {
				if ( xTimeCodeErrInj.usiMissCount[i] == 0 ){
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
					pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
					xTimeCodeErrInj.bFEE_NUMBER[i] = FALSE;
				} else {
					xTimeCodeErrInj.usiMissCount[i]--;
				}
			}
		}
		xTimeCodeErrInj.bMissTC = (
				xTimeCodeErrInj.bFEE_NUMBER[0] |
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
