/*
 * data_control_task.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */



#include "data_control_task.h"


void vFTDIClear( void );
void vFTDIAbort( void );
bool bFTDIDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes);
bool bFTDIDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes);
bool bFTDIRequestFullImage( alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight );
void vRxBuffer0FullIRQHandler(void);
void vRxBuffer1FullIRQHandler(void);
void vRxLastBufferFullIRQHandler(void);
void vRxEmptyBufferFullIRQHandler(void);
void vRxCommErrorIRQHandler(void);



/* 0% Ready! */
void vDataControlTask(void *task_data) {
	tQMask uiCmdDTC;
	INT8U error_code;
	TNData_Control *pxDataC;
	unsigned char ucIL = 0;
	bool bSuccess = FALSE;
	unsigned char ucSubReqIFEE = 0;
	unsigned char ucSubReqICCD = 0;
	unsigned char ucMemUsing = 0;

	pxDataC = (TNData_Control *) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage )
        debug(fp,"Data Controller Task. (Task on)\n");
    #endif

    pxDataC->bUpdateComplete = TRUE;

	for (;;) {

		switch (pxDataC->sMode) {
			case sMebInit:
				/* Starting the Data Controller */

				/* Clear the CMD Queue */
				error_code = OSQFlush(xQMaskDataCtrl);
				if ( error_code != OS_NO_ERR ) {
					vFailFlushQueueData();
				}
				pxDataC->sMode = sMebToConfig;
				break;

			case sMebToConfig:
				/* Transition state */
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"NFEE Controller Task: Config Mode\n");
				#endif

				/* Anything that need be executed only once before the COnfig Mode
				Should be put here!*/

				pxDataC->sMode = sMebConfig;
				break;

			case sMebConfig:

				uiCmdDTC.ulWord = (unsigned int)OSQPend(xQMaskDataCtrl, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					/* Check if the command is for NFEE Controller */
					if ( uiCmdDTC.ucByte[3] == M_DATA_CTRL_ADDR ) {
						vPerformActionDTCConfig(uiCmdDTC.ulWord, pxDataC);
					}
				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetQueueMaskDataCtrl();
				}
				break;

			case sMebToRun:
				vEvtChangeDataControllerMode();
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"Data Controller Task: RUN Mode\n");
				#endif				
				/* Anything that need be executed only once before the Run Mode
				Should be put here!*/
				pxDataC->sMode = sMebRun;
				pxDataC->sRunMode = sSubInit;
				break;

			case sMebRun:

				/* At this mode the DataController will always fill the memory in order
				after master sync*/

				switch (pxDataC->sRunMode) {
					case sSubInit:

						/*todo: For later use*/
						pxDataC->sRunMode = sSubMemUpdated;
						break;

					case sSubMemUpdated:

						/* Memory full updated, wait for MasterSync */

						/* Indicates that at any moment the memory could be swaped in order to the NFEEs prepare the first packet to send in the next M. Sync */
						pxDataC->bUpdateComplete = TRUE;

						uiCmdDTC.ulWord = (unsigned int)OSQPend(xQMaskDataCtrl, 0, &error_code); /* Blocking operation */
						if ( error_code == OS_ERR_NONE ) {
							/* Check if the command is for NFEE Controller */
							if ( uiCmdDTC.ucByte[3] == M_DATA_CTRL_ADDR ) {
								vPerformActionDTCRun(uiCmdDTC.ulWord, pxDataC);
							}
						} else {
							/* Should never get here (blocking operation), critical fail */
							vCouldNotGetQueueMaskDataCtrl();
						}
						break;

					case sSubSetupEpoch:
						/* Indicates that the memory update is not completed, at this moment just start */
						pxDataC->bUpdateComplete = FALSE;

						/* todo: For now, this 'toca' implementation will always update all CCDs of all FEE.
						   The next implementation we should avoid to update FEEs that are working with patterns, unless that has any LUT update */
						for ( ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
							pxDataC->bInsgestionSchedule[ucIL] = TRUE;
						}
						
						ucSubReqIFEE = 0;
						ucSubReqICCD = 0;
						ucMemUsing = (unsigned char) ( *pxDataC->pNextMem );
						/* Copy all data control of the NFEEs for consistency. If some RMAP command change the side or the size, it will only take effect
						   in the Next Master Sync. */
						/* todo: In later version maybe merge with the for above. */
						for ( ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
							pxDataC->xCopyNfee[ucIL].xCcdInfo.usiHeight = pxDataC->xReadOnlyFeeControl.xNfee[ucSubReqIFEE]->xCcdInfo.usiHeight;
							pxDataC->xCopyNfee[ucIL].xCcdInfo.usiHalfWidth = pxDataC->xReadOnlyFeeControl.xNfee[ucSubReqIFEE]->xCcdInfo.usiHalfWidth;
							pxDataC->xCopyNfee[ucIL].xControl.eSide = pxDataC->xReadOnlyFeeControl.xNfee[ucSubReqIFEE]->xControl.eSide;
						}

						pxDataC->sRunMode = sSubRequest;
						break;

					case sSubRequest:

						if ( TRUE == pxDataC->bInsgestionSchedule[ucSubReqIFEE] ) {
							/* Send Clear command to the FTDI Control Block */
							vFTDIClear();
							/* Request command to the FTDI Control Block in order to request NUC through USB 3.0 protocol*/
							bSuccess = bFTDIRequestFullImage( ucSubReqIFEE, ucSubReqICCD, pxDataC->xCopyNfee[ucSubReqIFEE].xControl.eSide, pxDataC->usiEPn, pxDataC->xCopyNfee[ucSubReqIFEE].xCcdInfo.usiHalfWidth, pxDataC->xCopyNfee[ucSubReqIFEE].xCcdInfo.usiHeight );
							if ( bSuccess == FALSE ) {
								/* Fail */
								vFailSendRequestDTController();
								pxDataC->sRunMode = sSubMemUpdated;
							} else
								pxDataC->sRunMode = sSubFillingMem;

						} else {
							/* There's no need to update the ucSubReqIFEE FEE */
							/* Check the next value before increment */
							if ( ucSubReqIFEE < ( N_OF_NFEE - 1 )  ) {
								ucSubReqIFEE++;
								ucSubReqICCD = 0;
							} else
								pxDataC->sRunMode = sSubMemUpdated;
						}
						break;

					case sSubFillingMem:
					
						uiCmdDTC.ulWord = (unsigned int)OSQPend(xQMaskDataCtrl, 0, &error_code); /* Blocking operation */
						if ( error_code == OS_ERR_NONE ) {
							/* Check if the command is for NFEE Controller */
							if ( uiCmdDTC.ucByte[3] == M_DATA_CTRL_ADDR ) {
								vPerformActionDTCFillingMem(uiCmdDTC.ulWord, pxDataC);
							}
						} else {
							/* Should never get here (blocking operation), critical fail */
							vCouldNotGetQueueMaskDataCtrl();
						}

						break;

					case sSubLastPckt:
					
						/* Ao final da transmissão verificar se ainda tem que fazer requests */
						if ( ucSubReqIFEE < N_OF_NFEE ) {
							

						} else {
							/* Done all Requests for all NFEEs */
						}


						break;

				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						debug(fp,"NFEE Controller Task: Unknown SUB state in running mode.\n");
					#endif
					/* Back to Config Mode */
					pxDataC->sMode = sMebToConfig;
				}

				break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				debug(fp,"NFEE Controller Task: Unknown state, backing to Config Mode.\n");
			#endif
			/* Back to Config Mode */
			pxDataC->sMode = sMebToConfig;
		}
	}
}


void vPerformActionDTCFillingMem( unsigned int uiCmdParam, TNData_Control *pxFeeCP ) {
	tQMask uiCmdLocal;

	uiCmdLocal.ulWord = uiCmdParam;

	switch (uiCmdLocal.ucByte[2]) {
		case M_DATA_CONFIG_FORCED:
		case M_DATA_CONFIG:
			vFTDIAbort();
			pxFeeCP->sMode = sMebToConfig;
			break;

		case M_DATA_RUN_FORCED:
		case M_DATA_RUN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
				debug(fp,"Data Controller Task: DTC already in the Running Mode\n");
			}
			#endif
			/* Do nothing for now */
			break;
		case M_SYNC:
			
			/* todo: If a MasterSync arrive before finish the memory filling, throw some error. Need to check later what to do */
			/* For now, critical failure! */
			vCriticalFailUpdateMemoreDTController();
			/* Stop the simulation for the Data Controller */
			pxFeeCP->sMode = sMebToConfig;

			break;

		case M_DATA_FTDI_BUFFER_FULL:

			break;

		case M_DATA_FTDI_BUFFER_LAST:

			break;

		case M_DATA_FTDI_BUFFER_EMPTY:

			break;

		case M_DATA_FTDI_ERROR:

			/* todo: What is the reason of failure? Can we keep going? */
			vCommunicationErrorUSB3DTController();

			/* todo: depends on error perform another action than go to Config Mode */
			pxFeeCP->sMode = sMebToConfig;
			break;

		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				debug(fp,"Data Controller Task: Unknown Command.\n");
			#endif
	}
}

void vPerformActionDTCRun( unsigned int uiCmdParam, TNData_Control *pxFeeCP ) {
	tQMask uiCmdLocal;

	uiCmdLocal.ulWord = uiCmdParam;

	switch (uiCmdLocal.ucByte[2]) {
		case M_DATA_CONFIG_FORCED:
		case M_DATA_CONFIG:

			pxFeeCP->sMode = sMebToConfig;
			break;

		case M_DATA_RUN_FORCED:
		case M_DATA_RUN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
				debug(fp,"Data Controller Task: DTC already in the Running Mode\n");
			}
			#endif
			/* Do nothing for now */
			break;
		case M_SYNC:
			pxFeeCP->sRunMode = sSubSetupEpoch;
			break;			
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				debug(fp,"Data Controller Task: Unknown Command.\n");
			#endif
	}
}

void vPerformActionDTCConfig( unsigned int uiCmdParam, TNData_Control *pxFeeCP ) {
	tQMask uiCmdLocal;

	uiCmdLocal.ulWord = uiCmdParam;

	switch (uiCmdLocal.ucByte[2]) {
		case M_DATA_CONFIG_FORCED:
		case M_DATA_CONFIG:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
				debug(fp,"Data Controller Task: DTC already in the Config Mode\n");
			}
			#endif
			/* Do nothing for now */
			break;

		case M_DATA_RUN_FORCED:
		case M_DATA_RUN:
			pxFeeCP->sMode = sMebToRun;
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				debug(fp,"Data Controller Task: Unknown Command.\n");
			#endif
	}
}

/* Moc */
void vRxBuffer0FullIRQHandler(void) {


}

/* Moc */
void vRxBuffer1FullIRQHandler(void) {

	
}

/* Moc */
void vRxLastBufferFullIRQHandler(void) {

	
}

/* Moc */
void vRxEmptyBufferFullIRQHandler(void) {

	
}

/* Moc */
void vRxCommErrorIRQHandler(void) {

	
}

/* Mocs */
void vFTDIClear( void ){}
void vFTDIAbort( void ){}
bool bFTDIDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes){return TRUE;}
bool bFTDIDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes){return TRUE;}
bool bFTDIRequestFullImage( alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight ){return TRUE;}
