/*
 * sim_meb_task.c
 *
 *  Created on: 13/01/2019
 *      Author: TiagoLow
 */


#include "sim_meb_task.h"

/* All commands should pass through the MEB, it is the instance that hould know everything, and also know the self state and what is allowed to be performed or not */

void vSimMebTask(void *task_data) {
	TSimucam_MEB *pxMebC;
	unsigned char tCode;
	unsigned char tCodeNext;
	unsigned char ucIL;
	tQMask uiCmdMeb;
	INT8U error_code;
	INT8U ucFrameNumber;

	pxMebC = (TSimucam_MEB *) task_data;

	#if DEBUG_ON
        debug(fp,"Sim-Meb Controller Task. (Task on)\n");
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
					debug(fp,"MEB Task: Config Mode\n");
				#endif

				/* Stop the Sync (Stopping the simulation) */
				bStopSync();
				vSyncClearCounter();

				/* If any Task is locked waiting Sync, should be released */
				vReleaseSyncMessages();

				/* Give time to all tasks receive the command */
				OSTimeDlyHMSM(0, 0, 0, 10);

				/* Transition to Config Mode (Ending the simulation) */
				/* Send a message to the NFEE Controller forcing the mode */
				vSendCmdQToNFeeCTRL_PRIO( M_NFC_CONFIG_FORCED, 0, 0 );
				vSendCmdQToDataCTRL_PRIO( M_DATA_CONFIG_FORCED, 0, 0 );

				/* Give time to all tasks receive the command */
				OSTimeDlyHMSM(0, 0, 0, 250);

				pxMebC->eMode = sMebConfig;
				break;


			case sMebToRun:
				#if DEBUG_ON
					debug(fp,"MEB Task: Run Mode\n");
				#endif
				/* Transition to Run Mode (Starting the Simulation) */
				vSendCmdQToNFeeCTRL_PRIO( M_NFC_RUN_FORCED, 0, 0 );
				vSendCmdQToDataCTRL_PRIO( M_DATA_RUN_FORCED, 0, 0 );

				/* Give time to all tasks receive the command */
				OSTimeDlyHMSM(0, 0, 0, pxMebC->usiDelaySyncReset);


				/* Clear the timecode of the channel SPW (for now is for spw channel) */
				for (ucIL = 0; ucIL < N_OF_NFEE; ++ucIL) {
					bSpwcClearTimecode(&pxMebC->xFeeControl.xNfee[ucIL].xChannel.xSpacewire);
					pxMebC->xFeeControl.xNfee[ucIL].xControl.ucTimeCode = 0;
				}

				bSyncCtrReset();
				vSyncClearCounter();
				bStartSync();

				vEvtChangeMebMode();
				pxMebC->eMode = sMebRun;
				break;


			case sMebConfig:

				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Check if the command is for MEB */
					if ( uiCmdMeb.ucByte[3] == M_MEB_ADDR ) {
						/* Parse the cmd that comes in the Queue */
						switch ( uiCmdMeb.ucByte[2] ) {
							/* Receive a PUS command */
							case Q_MEB_PUS:
								vPusMebTask( pxMebC );
								break;
							case M_MASTER_SYNC:
								#if DEBUG_ON
									fprintf(fp,"MEB Task: WARNING Should not have sync in Meb Config Mode (Check it please)");
								#endif
								break;
							default:
								#if DEBUG_ON
									fprintf(fp,"MEB Task: Unknown command for the Config Mode (Queue xMebQ, cmd= %hhu)\n", uiCmdMeb.ucByte[2]);
								#endif
								break;
						}
					} else {
						#if DEBUG_ON
							fprintf(fp,"MEB Task: Command Ignored wrong address (ADDR= %hhu)\n", uiCmdMeb.ucByte[3]);
						#endif
					}
				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetCmdQueueMeb();
				}

				break;

			case sMebRun:
				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Check if the command is for MEB */
					if ( uiCmdMeb.ucByte[3] == M_MEB_ADDR ) {
						/* Parse the cmd that comes in the Queue */
						switch (uiCmdMeb.ucByte[2]) {
							/* Receive a PUS command */
							case Q_MEB_PUS:
								vPusMebTask( pxMebC );
								break;
							case M_MASTER_SYNC:
								/* Perform memory SWAP */
								vSwapMemmory(pxMebC);
							case M_SYNC:
								#if DEBUG_ON
									bSpwcGetTimecode(&pxMebC->xFeeControl.xNfee[0].xChannel.xSpacewire);
									tCode = ( pxMebC->xFeeControl.xNfee[0].xChannel.xSpacewire.xTimecode.ucCounter);
									tCodeNext = ( tCode ) % 4;

									fprintf(fp,"\n\nMEB TASK:  TC: %hhu ( %hhu )\n ", tCode, tCodeNext);


									bRmapGetMemConfigArea(&pxMebC->xFeeControl.xNfee[0].xChannel.xRmap);
									ucFrameNumber = pxMebC->xFeeControl.xNfee[0].xChannel.xRmap.xRmapMemConfigArea.uliFrameNumber;

									//bRmapSetMemConfigArea(&pxMebC->xFeeControl.xNfee[0].xChannel.xRmap);

									fprintf(fp,"MEB TASK:  Frame Number: %hhu \n ", ucFrameNumber);

								#endif

								break;
							default:
								#if DEBUG_ON
									fprintf(fp,"MEB Task: Unknown command (%hhu)\n", uiCmdMeb.ucByte[2]);
								#endif
								break;
						}
					} else {
						#if DEBUG_ON
							fprintf(fp,"MEB Task: Command Ignored wrong address (ADDR= %hhu)\n", uiCmdMeb.ucByte[3]);
						#endif
					}

				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetCmdQueueMeb();
				}			
				break;

			default:
				#if DEBUG_ON
					debug(fp,"MEB Task: Unknow state, backing to Config Mode\n");
				#endif
				
				/* todo:Aplicar toda logica de mudança de esteado aqui */
				pxMebC->eMode = sMebToConfig;
				break;
		}
	}
}

void vPusMebTask( TSimucam_MEB *pxMebCLocal ) {
	bool bSuccess;
	INT8U error_code;
	unsigned char ucIL;
	static tTMPus xPusLocal;

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

	if ( bSuccess ) {

		switch (pxMebCLocal->eMode) {
			case sMebConfig:
				vPusMebInTaskConfigMode(pxMebCLocal, &xPusLocal);
				break;
			case sMebRun:
				vPusMebInTaskRunningMode(pxMebCLocal, &xPusLocal);
				break;
			default:
				break;
		}
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
				fprintf(fp, "MEB Task: Srv-Type not allowed in this mode (CONFIG)\n\n" );
			#endif
			break;
	}
}

void vPusType250conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {

	switch (xPusL->usiSubType) {
		/* TC_SCAM_RUN */
		case 61:
			pxMebCLocal->eMode = sMebToRun;
			break;
		/* TC_SCAM_TURNOFF */
		case 62:
			/*todo: Do nothing for now */
			break;
		/* TC_SCAM_CONFIG */
		case 60:
		default:
			#if DEBUG_ON
				fprintf(fp, "MEB Task: Command not allowed in this mode\n\n" );
			#endif
			break;
	}
}

void vPusType251conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	#if DEBUG_ON
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
				fprintf(fp,"MEB Task: RMAP KEY: %hu     L. ADDR: %hu (Change performed) \n\n", xPusL->usiValues[12] , xPusL->usiValues[9]);
			#endif

			break;
		default:
			#if DEBUG_ON
				fprintf(fp, "MEB Task: Command not allowed in this mode\n\n" );
			#endif
			break;
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
				fprintf(fp, "MEB Task: Srv-Type not allowed in this mode (RUN)\n\n" );
			#endif
			break;
	}
}


void vPusType250run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {

	switch (xPusL->usiSubType) {
		/* TC_SCAM_CONFIG */
		case 60:
			pxMebCLocal->eMode = sMebToConfig;
			break;
		/* TC_SCAM_TURNOFF */
		case 62:
			/*todo: Do nothing for now */
			break;
		/* TC_SCAM_RUN */
		case 61:
		default:
			#if DEBUG_ON
				fprintf(fp, "MEB Task: Command not allowed in this mode (RUN)\n\n" );
			#endif
			break;
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
		/* TC_SCAM_FEE_CALIBRATION_TEST_ENTER */
		case 5:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_FULL_PATTERN, 0, usiFeeInstL );
			break;
		case 0:
		case 3:
		case 4:
		case 6:
		default:
			#if DEBUG_ON
				fprintf(fp, "MEB Task: Command not implemented yet (SubType:%hu)\n\n",xPusL->usiSubType );
			#endif
			break;
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
				fprintf(fp,"MEB Task: Link disable (NFEE-%hu)\n\n", usiFeeInstL);
			#endif

			break;

		case 5: /* TC_SCAM_SPW_LINK_RESET */
			/* todo:Do nothing, don't know what is reset spw link */
			break;

		case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */

			/* todo: For now we can only update the Logical Address and the RAMP Key */
			if ( pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xControl.eMode == sFeeConfig ) {
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
					fprintf(fp,"MEB Task: NFEE-%hu is not in the Config Mode ( Changes not performed )\n\n", usiFeeInstL);
				#endif
			}

			/* todo: Need to treat all the returns */
			#if DEBUG_ON
				fprintf(fp,"MEB Task: RMAP KEY: %hu     L. ADDR: %hu (Change performed) \n\n", xPusL->usiValues[12] , xPusL->usiValues[9]);
			#endif
			break;
		default:
			#if DEBUG_ON
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

/* After stop the Sync signal generation, maybe some FEE task could be locked waiting for this signal. So we send to everyone, and after that they will flush the queue */
void vReleaseSyncMessages(void) {
	unsigned char ucIL;
	unsigned char error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ulWord = 0;
	uiCmdtoSend.ucByte[2] = M_SYNC;
	/* MasterSync? */

	for( ucIL = 0; ucIL < N_OF_NFEE; ucIL++ ){
		uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucIL;
		error_codel = OSQPost(xWaitSyncQFee[ ucIL ], (void *)uiCmdtoSend.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendMsgSync( ucIL );
		}
	}
}

