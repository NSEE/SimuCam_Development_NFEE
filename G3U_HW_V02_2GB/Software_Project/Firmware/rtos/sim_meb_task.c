/*
 * sim_meb_task.c
 *
 *  Created on: 13/01/2019
 *      Author: TiagoLow
 */


#include "sim_meb_task.h"

/* All commands should pass through the MEB, it is the instance that hould know everything, 
and also know the self state and what is allowed to be performed or not */

void vSimMebTask(void *task_data) {
	TSimucam_MEB *pxMebC;
	unsigned char ucIL;
	volatile tQMask uiCmdMeb;
	INT8U error_code;


	pxMebC = (TSimucam_MEB *) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage )
        fprintf(fp,"Sim-Meb Controller Task. (Task on)\n");
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

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage )
					fprintf(fp,"MEB Task: Run Mode\n");
				#endif
				/* Transition to Run Mode (Starting the Simulation) */
				vSendCmdQToNFeeCTRL_PRIO( M_NFC_RUN_FORCED, 0, 0 );
				vSendCmdQToDataCTRL_PRIO( M_DATA_RUN_FORCED, 0, 0 );
				vSendMessageNUCModeMEBChange( 2 ); /*2: Running*/
				/* Give time to all tasks receive the command */
				OSTimeDlyHMSM(0, 0, 0, pxMebC->usiDelaySyncReset);

				/* Clear the timecode of the channel SPW (for now is for spw channel) */
				for (ucIL = 0; ucIL < N_OF_NFEE; ++ucIL) {
					bSpwcClearTimecode(&pxMebC->xFeeControl.xNfee[ucIL].xChannel.xSpacewire);
					pxMebC->xFeeControl.xNfee[ucIL].xControl.ucTimeCode = 0;
				}

				/*This sequence start the HW sync module*/
				bSyncCtrReset();
				vSyncClearCounter();
				bStartSync();

				vEvtChangeMebMode();
				pxMebC->eMode = sMebRun;
				break;

			case sMebConfig:

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"MEB Task: sMebConfig - Waiting for command.");
				#endif
				break;

				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					/* Threat the command received in the Queue Message */
					vPerformActionMebInConfig( uiCmdMeb.ulWord, pxMebC);
				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetCmdQueueMeb();
				}
				break;

			case sMebRun:

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"MEB Task: sMebRun - Waiting for command.");
				#endif
				break;

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
	unsigned char ucFeeInst;
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

			case M_PRE_MASTER:
				pxMebCLocal->xSwapControl.lastReadOut = TRUE;
				pxMebCLocal->xSwapControl.end = 0x00; /* 0x7F for N-FEE, need to adjust to F-FEE */
				vDebugSyncTimeCode(pxMebCLocal);
				break;

			case M_MASTER_SYNC:

				pxMebCLocal->xSwapControl.lastReadOut = FALSE;
				/* Perform memory SWAP */
				vSwapMemmory(pxMebCLocal);
				vDebugSyncTimeCode(pxMebCLocal);
				break;

			case M_SYNC:
				vDebugSyncTimeCode(pxMebCLocal);
				break;

			case Q_MEB_DATA_MEM_IN_USE:
				pxMebCLocal->xSwapControl.end = pxMebCLocal->xSwapControl.end | (0x01<<6);
				break;

			case Q_MEB_FEE_MEM_IN_USE:
				ucFeeInst = uiCmdLocal.ucByte[0];
				pxMebCLocal->xSwapControl.end = pxMebCLocal->xSwapControl.end | (0x01<<ucFeeInst);
				break;

			case Q_MEB_DATA_MEM_UPD_FIN:

				/*Check if is already the sync before Master Sync*/
				if ( xGlobal.bPreMaster == TRUE ) {

					/*Maybe have some FEE instances loked in reading queue, waiting for a message that DTC finishes the upload of the memory*/
					/*So, need to send them a message to inform*/
					/* Using QMASK send to NfeeControl that will foward */
					for (ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
						if ( TRUE == pxMebCLocal->xFeeControl.xNfee[ucIL].xControl.bUsingDMA ) {
							vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+ucIL), M_FEE_CAN_ACCESS_NEXT_MEM, 0, ucIL );
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
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
		fprintf(fp,"\n\nSync\n");
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			bSpwcGetTimecode(&pxMebCLocal->xFeeControl.xNfee[0].xChannel.xSpacewire);
			tCode = ( pxMebCLocal->xFeeControl.xNfee[0].xChannel.xSpacewire.xTimecode.ucCounter);
			tCodeNext = ( tCode ) % 4;
			fprintf(fp,"TC: %hhu ( %hhu )\n ", tCode, tCodeNext);
			bRmapGetMemConfigArea(&pxMebCLocal->xFeeControl.xNfee[0].xChannel.xRmap);
			ucFrameNumber = pxMebCLocal->xFeeControl.xNfee[0].xChannel.xRmap.xRmapMemConfigArea.uliFrameNumber;
			fprintf(fp,"MEB TASK:  Frame Number: %hhu \n ", ucFrameNumber);
		}
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
		fprintf(fp,"MEB Task: vPusMebTask");
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
	} else
		vCouldNotGetMutexMebPus();

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
	unsigned short int param1 =0;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage )
		fprintf(fp,"MEB Task: vPusType250conf - Command: %hhu.", xPusL->usiSubType);
	#endif

	param1 = xPusL->usiValues[0];

	switch (xPusL->usiSubType) {
		/* TC_SYNCH_SOURCE */
		case 29:
			bSyncCtrIntern(param1 == 0); /*True = Internal*/
			break;
		/* TC_SCAM_RUN */
		case 61:
			pxMebCLocal->eMode = sMebToRun;
			break;
		/* TC_SCAM_TURNOFF */
		case 62:
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

		/* TC_SCAM_CONFIG */
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
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteCmdEn = FALSE;
			bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);

			/* Change the configuration */
			bRmapGetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char)xPusL->usiValues[12];
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char)xPusL->usiValues[9];
			bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );


			/* Enable the RMAP interrupt */
			bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteCmdEn = TRUE;
			bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);

			/* todo: Need to treat all the returns */
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: RMAP KEY: %hu     L. ADDR: %hu (Change performed) \n\n", xPusL->usiValues[12] , xPusL->usiValues[9]);
			#endif
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
			vPusType251run(pxMebCLocal, xPusL);
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

	unsigned char ucShutDownI=0;

	switch (xPusL->usiSubType) {
		/* TC_SCAM_CONFIG */
		case 60:
			pxMebCLocal->eMode = sMebToConfig;
			break;
		/* TC_SCAM_TURNOFF */
		case 62:
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

		/* TC_SCAM_RUN */
		case 61:
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not allowed in this mode (RUN)\n\n" );
			#endif
	}
}

void vPusType251run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned short int usiFeeInstL;

	usiFeeInstL = xPusL->usiValues[0];
	switch (xPusL->usiSubType) {
		/* TC_SCAM_FEE_CONFIG_ENTER */
		case 1:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_CONFIG, 0, usiFeeInstL );
			break;
		/* TC_SCAM_FEE_STANDBY_ENTER */
		case 2:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_STANDBY, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_FULLIMAGE_ENTER */
		case 3:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_FULL, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_WINDOWING _ENTER */
		case 4:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_WIN, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_FULLIMAGE_PATTERN_ENTER */
		case 5:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_FULL_PATTERN, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_WINDOWING_PATTERN_ENTER */
		case 6:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_WIN_PATTERN, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_PARALLEL_TRAP_PUMP_1_ENTER */
		case 12:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_PAR_TRAP_1, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_PARALLEL_TRAP_PUMP_2_ENTER */
		case 13:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_PAR_TRAP_2, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_SERIAL_TRAP_PUMP_1_ENTER */
		case 14:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_SERIAL_TRAP_1, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_SERIAL_TRAP_PUMP_2_ENTER */
		case 15:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_SERIAL_TRAP_2, 0, usiFeeInstL );
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
			bSpwcGetLink(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bLinkStart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bAutostart = TRUE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bDisconnect = FALSE;
			bSpwcSetLink(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: Link enable (NFEE-%hu)\n\n", usiFeeInstL);
			#endif
			break;

		case 4: /* TC_SCAM_SPW_LINK_DISABLE */
			bSpwcGetLink(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bLinkStart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bAutostart = FALSE;
			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bDisconnect = TRUE;
			bSpwcSetLink(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
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
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteCmdEn = FALSE;
				bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);

				/* Change the configuration */
				bRmapGetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char)xPusL->usiValues[12];
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char)xPusL->usiValues[9];
				bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );


				/* Enable the RMAP interrupt */
				bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
				pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapIrqControl.bWriteCmdEn = TRUE;
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


void vSendCmdQToNFeeCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}
}

void vSendCmdQToNFeeCTRL_PRIO( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPostFront(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}
}


/* Send to FEEs using the NFEE Controller */
void vSendCmdQToNFeeCTRL_GEN( unsigned char ADDR,unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}
}


void vSendCmdQToDataCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/*Send a command to other entities (Data Controller) */
	error_codel = OSQPost(xQMaskDataCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgDataCTRL();
	}
}

void vSendCmdQToDataCTRL_PRIO( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/*Send a command to other entities (Data Controller) */
	error_codel = OSQPostFront(xQMaskDataCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}
}


void vMebInit(TSimucam_MEB *pxMebCLocal) {
	INT8U errorCodeL;

	pxMebCLocal->ucActualDDR = 0;
	pxMebCLocal->ucNextDDR = 1;
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

	/* Stop the Sync (Stopping the simulation) */
	bStopSync();
	vSyncClearCounter();

	/* Give time to all tasks receive the command */
	OSTimeDlyHMSM(0, 0, 0, 5);

	pxMebCLocal->ucActualDDR = 0;
	pxMebCLocal->ucNextDDR = 1;
	/* Transition to Config Mode (Ending the simulation) */
	/* Send a message to the NFEE Controller forcing the mode */
	vSendCmdQToNFeeCTRL_PRIO( M_NFC_CONFIG_FORCED, 0, 0 );
	vSendCmdQToDataCTRL_PRIO( M_DATA_CONFIG_FORCED, 0, 0 );

	vSendMessageNUCModeMEBChange( 1 ); /*1: Config*/

	/* Give time to all tasks receive the command */
	OSTimeDlyHMSM(0, 0, 0, 250);

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
