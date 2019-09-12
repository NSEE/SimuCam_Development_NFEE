/*
 * data_control_task.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */



#include "data_control_task.h"


//void vFTDIClear( void );
//void vFTDIAbort( void );
//alt_u8 ucGetError( void );
//alt_u16 usiFTDInDataLeftInBuffer( void );
//bool bFTDIDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes);
//bool bFTDIDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes);
//bool bFTDIRequestFullImage( alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight );
//bool bSendMSGtoSimMebTaskDTC( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
//void vRxBuffer0FullIRQHandler(void);
//void vRxBuffer1FullIRQHandler(void);
//void vRxLastBufferFullIRQHandler(void);
//void vRxEmptyBufferFullIRQHandler(void);
//void vRxCommErrorIRQHandler(void);

/* 0% Ready! */
void vDataControlTask(void *task_data) {
	tQMask uiCmdDTC;
	INT8U error_code;
	TNData_Control *pxDataC;
	unsigned char ucIL = 0;
	unsigned char ucFailCount = 0;
	unsigned short int usiNByterLeft = 0;
	bool bSuccess = FALSE;
	unsigned char ucSubReqIFEE = 0;
	unsigned char ucSubReqICCD = 0;
	unsigned char ucSubCCDSide = 0;
	unsigned char ucMemUsing = 0;
	bool bA, bB, bC, bD, bE;
	bool bDmaReturn = FALSE;
	TCcdMemMap *xCCDMemMapL;

	pxDataC = (TNData_Control *) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage )
        debug(fp,"Data Controller Task. (Task on)\n");
    #endif

    pxDataC->bUpdateComplete = TRUE;

	for (;;) {
//
//		switch (pxDataC->sMode) {
//			case sMebInit:
//				/* Starting the Data Controller */
//
//				pxDataC->sMode = sMebToConfig;
//				break;
//
//			case sMebToConfig:
//				/* Transition state */
//				#if DEBUG_ON
//				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
//					fprintf(fp,"NFEE Controller Task: Config Mode\n");
//				#endif
//
//				/* Anything that need be executed only once before the COnfig Mode
//				Should be put here!*/
//				pxDataC->usiEPn = 0;
//
//				/* Clear the CMD Queue */
//				error_code = OSQFlush(xQMaskDataCtrl);
//				if ( error_code != OS_NO_ERR ) {
//					vFailFlushQueueData();
//				}
//
//				pxDataC->sMode = sMebConfig;
//				break;
//
//			case sMebConfig:
//
//				uiCmdDTC.ulWord = (unsigned int)OSQPend(xQMaskDataCtrl, 0, &error_code); /* Blocking operation */
//				if ( error_code == OS_ERR_NONE ) {
//					/* Check if the command is for NFEE Controller */
//					if ( uiCmdDTC.ucByte[3] == M_DATA_CTRL_ADDR ) {
//						vPerformActionDTCConfig(uiCmdDTC.ulWord, pxDataC);
//					}
//				} else {
//					/* Should never get here (blocking operation), critical fail */
//					vCouldNotGetQueueMaskDataCtrl();
//				}
//				break;
//
//			case sMebToRun:
//				vEvtChangeDataControllerMode();
//				#if DEBUG_ON
//				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
//					fprintf(fp,"Data Controller Task: RUN Mode\n");
//				#endif
//				/* Anything that need be executed only once before the Run Mode
//				Should be put here!*/
//				pxDataC->sMode = sMebRun;
//				pxDataC->sRunMode = sSubInit;
//				break;
//
//			case sMebRun:
//
//				/* At this mode the DataController will always fill the memory in order
//				after master sync*/
//
//				switch (pxDataC->sRunMode) {
//					case sSubInit:
//
//						/*todo: For later use*/
//						pxDataC->sRunMode = sSubMemUpdated;
//						break;
//
//					case sSubMemUpdated:
//
//						/* Memory full updated, wait for MasterSync */
//
//						/* Indicates that at any moment the memory could be swaped in order to the NFEEs prepare the first packet to send in the next M. Sync */
//						pxDataC->bUpdateComplete = TRUE;
//						xGlobal.bDTCFinished = TRUE;
//						bSendMSGtoSimMebTaskDTC(Q_MEB_DATA_MEM_UPD_FIN, 0, 0); /*todo: Tratar retorno*/
//
//
//						#if DEBUG_ON
//						if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
//							fprintf(fp,"\nDTC: Mem. Updated\n");
//						}
//						#endif
//
//						uiCmdDTC.ulWord = (unsigned int)OSQPend(xQMaskDataCtrl, 0, &error_code); /* Blocking operation */
//						if ( error_code == OS_ERR_NONE ) {
//							/* Check if the command is for NFEE Controller */
//							if ( uiCmdDTC.ucByte[3] == M_DATA_CTRL_ADDR ) {
//								vPerformActionDTCRun(uiCmdDTC.ulWord, pxDataC);
//							}
//						} else {
//							/* Should never get here (blocking operation), critical fail */
//							vCouldNotGetQueueMaskDataCtrl();
//						}
//						break;
//
//					case sSubSetupEpoch:
//						/* Indicates that the memory update is not completed, at this moment just start */
//						pxDataC->bUpdateComplete = FALSE;
//						xGlobal.bDTCFinished = FALSE;
//						bSendMSGtoSimMebTaskDTC(Q_MEB_DATA_MEM_IN_USE, 0, 0); /*todo: Tratar retorno*/
//
//						/* todo: For now, this 'toca' implementation will always update all CCDs of all FEE.
//						   The next implementation we should avoid to update FEEs that are working with patterns, unless that has any LUT update */
//						/* All conditions will be put in intermediate variable for better visualization and validation, This is a critical point,
//						   do not try to optimize, there are no point at optimizing this operation that accours 1 time each 25s, let's keep the visibility */
//						for ( ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
//							bA = (*pxDataC->xReadOnlyFeeControl.pbEnabledNFEEs[ucIL]); /* Fee is enable? */
//							bB = TRUE; /* Is in pattern? (todo:Hard coded for now)*/
//							bC = TRUE; /* Updated LUT? */
//							bD = ( !bB || bC ); /* If in pattern, Need to be update? Had any LUT update?(todo:Hard coded for now) */
//							bE = TRUE; /* todo: Nay future implementation */
//							pxDataC->bInsgestionSchedule[ucIL] = ( bA && bD && bE );
//							if ( TRUE == pxDataC->bInsgestionSchedule[ucIL] ) {
//								/* Copy all data control of the NFEEs for consistency. If some RMAP command change the side or the size, it will only take effect
//								in the Next Master Sync. */
//								pxDataC->xCopyNfee[ucIL].xCcdInfo.usiHeight = pxDataC->xReadOnlyFeeControl.xNfee[ucIL]->xCcdInfo.usiHeight;
//								pxDataC->xCopyNfee[ucIL].xCcdInfo.usiHalfWidth = pxDataC->xReadOnlyFeeControl.xNfee[ucIL]->xCcdInfo.usiHalfWidth;
//								pxDataC->xCopyNfee[ucIL].xControl.eSide = pxDataC->xReadOnlyFeeControl.xNfee[ucIL]->xControl.eSide;
//								pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[0].xLeft.ulAddrI = pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[0].xLeft.ulOffsetAddr;
//								pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[0].xRight.ulAddrI = pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[0].xRight.ulOffsetAddr;
//								pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[1].xLeft.ulAddrI = pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[1].xLeft.ulOffsetAddr;
//								pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[1].xRight.ulAddrI = pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[1].xRight.ulOffsetAddr;
//								pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[2].xLeft.ulAddrI = pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[2].xLeft.ulOffsetAddr;
//								pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[2].xRight.ulAddrI = pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[2].xRight.ulOffsetAddr;
//								pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[3].xLeft.ulAddrI = pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[3].xLeft.ulOffsetAddr;
//								pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[3].xRight.ulAddrI = pxDataC->xCopyNfee[ucIL].xMemMap.xCcd[3].xRight.ulOffsetAddr;
//							}
//						}
//						ucSubReqIFEE = 0;
//						ucSubReqICCD = 0;
//						ucSubCCDSide = 0;
//						ucFailCount = 0;
//						ucMemUsing = (unsigned char) ( *pxDataC->pNextMem );
//
//						pxDataC->sRunMode = sSubRequest;
//						break;
//
//					case sSubRequest:
//
//						if ( TRUE == pxDataC->bInsgestionSchedule[ucSubReqIFEE] ) {
//							/* Send Clear command to the FTDI Control Block */
//							vFTDIClear();
//							/* Request command to the FTDI Control Block in order to request NUC through USB 3.0 protocol*/
//							bSuccess = bFTDIRequestFullImage( ucSubReqIFEE, ucSubReqICCD, ucSubCCDSide, pxDataC->usiEPn, pxDataC->xCopyNfee[ucSubReqIFEE].xCcdInfo.usiHalfWidth, pxDataC->xCopyNfee[ucSubReqIFEE].xCcdInfo.usiHeight );
//							if ( bSuccess == FALSE ) {
//								/* Fail */
//								vFailSendRequestDTController();
//								pxDataC->sRunMode = sSubMemUpdated;
//							} else {
//
//								#if DEBUG_ON
//								if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
//									fprintf(fp,"DTC: EP %hhu\n", pxDataC->usiEPn);
//									fprintf(fp,"DTC: Request to NUC: FEE %hhu, CCD %hhu (%hhux%hhu ), Side %hhu\n", ucSubReqIFEE, ucSubReqICCD, pxDataC->xCopyNfee[ucSubReqIFEE].xCcdInfo.usiHalfWidth, pxDataC->xCopyNfee[ucSubReqIFEE].xCcdInfo.usiHeight, ucSubCCDSide);
//								}
//								#endif
//
//								pxDataC->sRunMode = sSubWaitIRQBuffer;
//								if ( ucSubCCDSide == 0 ) {
//									xCCDMemMapL = &pxDataC->xCopyNfee[ucSubReqIFEE].xMemMap.xCcd[ucSubReqICCD].xLeft;
//								} else {
//									xCCDMemMapL = &pxDataC->xCopyNfee[ucSubReqIFEE].xMemMap.xCcd[ucSubReqICCD].xRight;
//								}
//								xCCDMemMapL->ulBlockI = 0;
//							}
//
//						} else {
//							/* There's no need to update the ucSubReqIFEE FEE */
//							/* Check the next value before increment */
//							if ( ucSubReqIFEE < ( N_OF_NFEE - 1 )  ) {
//								ucSubReqIFEE++;
//								ucSubReqICCD = 0;
//								ucSubCCDSide = 0;
//								ucFailCount = 0;
//							} else
//								pxDataC->sRunMode = sSubMemUpdated;
//						}
//						break;
//
//					case sSubWaitIRQBuffer:
//
//						uiCmdDTC.ulWord = (unsigned int)OSQPend(xQMaskDataCtrl, 0, &error_code); /* Blocking operation */
//						if ( error_code == OS_ERR_NONE ) {
//							/* Check if the command is for NFEE Controller */
//							if ( uiCmdDTC.ucByte[3] == M_DATA_CTRL_ADDR ) {
//								vPerformActionDTCFillingMem(uiCmdDTC.ulWord, pxDataC);
//							}
//						} else {
//							/* Should never get here (blocking operation), critical fail */
//							vCouldNotGetQueueMaskDataCtrl();
//						}
//						break;
//
//					case sSubScheduleDMA:
//
//						if ( ucMemUsing == 0 )
//							bDmaReturn = bFTDIDmaM1Transfer((alt_u32 *)xCCDMemMapL->ulAddrI, FTDI_BUFFER_SIZE_TRANSFER);
//						else
//							bDmaReturn = bFTDIDmaM2Transfer((alt_u32 *)xCCDMemMapL->ulAddrI, FTDI_BUFFER_SIZE_TRANSFER);
//
//						/* Check if was possible to schedule the transfer in the DMA*/
//						if ( bDmaReturn == TRUE ) {
//							/* Value of xCcdMapLocal->ulAddrI already set in the last iteration */
//							xCCDMemMapL->ulAddrI += FTDI_BUFFER_SIZE_TRANSFER;
//							pxDataC->sRunMode = sSubWaitIRQBuffer;
//						} else {
//							/* Try only 3 times and pops a critical failure */
//							if ( ucFailCount < 3 ) {
//								OSTimeDlyHMSM(0, 0, 0, 1);
//								ucFailCount++;
//							} else {
//								vFailFTDIDMASchedule();
//								pxDataC->sMode = sMebToConfig;
//							}
//						}
//
//						break;
//					case sSubLastPckt:
//
//						usiNByterLeft = usiFTDInDataLeftInBuffer();
//
//						if ( ucMemUsing == 0 )
//							bDmaReturn = bFTDIDmaM1Transfer((alt_u32 *)xCCDMemMapL->ulAddrI, usiNByterLeft);
//						else
//							bDmaReturn = bFTDIDmaM2Transfer((alt_u32 *)xCCDMemMapL->ulAddrI, usiNByterLeft);
//
//						/* Check if was possible to schedule the transfer in the DMA*/
//						if ( bDmaReturn == TRUE ) {
//							/* Value of xCcdMapLocal->ulAddrI already set in the last iteration */
//							xCCDMemMapL->ulAddrI += usiNByterLeft;
//							pxDataC->sRunMode = sSubWaitIRQBuffer;
//						} else {
//							/* Try only 3 times and pops a critical failure */
//							if ( ucFailCount < 3 ) {
//								OSTimeDlyHMSM(0, 0, 0, 1);
//								ucFailCount++;
//							} else {
//								vFailFTDIDMASchedule();
//								pxDataC->sMode = sMebToConfig;
//							}
//						}
//						break;
//
//				case sWaitForEmptyBufferIRQ:
//
//					/* Default: 0-> left; 1-> right; */
//					ucSubCCDSide = ( ucSubCCDSide + 1 ) % 2;
//
//					/* if 0 (Left) side, than it's a new CCD */
//					if ( ucSubCCDSide == 0 )
//						ucSubReqICCD = ( ucSubReqICCD + 1 ) % 4;
//
//					/* If CCd 0 than is a new FEE */
//					if ( ucSubReqICCD == 0 )
//						ucSubReqIFEE = ( ucSubReqIFEE + 1 ) % N_OF_NFEE;
//
//					/* if Fee = 0, than the update is completed */
//					if ( ucSubReqIFEE == 0 )
//						pxDataC->sRunMode = sSubMemUpdated;
//					else
//						pxDataC->sRunMode = sSubRequest;
//					break;
//
//				default:
//					#if DEBUG_ON
//					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
//						debug(fp,"NFEE Controller Task: Unknown SUB state in running mode.\n");
//					#endif
//					/* Back to Config Mode */
//					pxDataC->sMode = sMebToConfig;
//				}
//
//				break;
//		default:
//			#if DEBUG_ON
//			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
//				debug(fp,"NFEE Controller Task: Unknown state, backing to Config Mode.\n");
//			#endif
//			/* Back to Config Mode */
//			pxDataC->sMode = sMebToConfig;
//		}

		//todo: Implementação temporaria
		pxDataC->bUpdateComplete = TRUE;
		xGlobal.bDTCFinished = TRUE;
		OSTimeDlyHMSM(0, 0, 5, 0);
		error_code = OSQFlush(xQMaskDataCtrl);
		if ( error_code != OS_NO_ERR ) {
			vFailFlushQueueData();
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
			pxFeeCP->sRunMode = sSubScheduleDMA;
			break;

		case M_DATA_FTDI_BUFFER_LAST:
			pxFeeCP->sRunMode = sSubLastPckt;
			break;

		case M_DATA_FTDI_BUFFER_EMPTY:
			pxFeeCP->sRunMode = sWaitForEmptyBufferIRQ;
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
		case M_MASTER_SYNC:
			pxFeeCP->usiEPn++;
			xGlobal.bDTCFinished = FALSE;
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


/* This function send command to meb_sim task*/
bool bSendMSGtoSimMebTaskDTC( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_MEB_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Send message to xMebQ -> meb_sim task */
	bSuccesL = FALSE;
	error_codel = OSQPost(xMebQ, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMSGMebTask();
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}
	return bSuccesL;
}

/* ================================ MOCK das libs do HW hardware ========================= */
/* Mock */
void vRxBuffer0FullIRQHandler(void) {
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_FULL;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 0;

	/*Sync the Meb task and tell that has a PUS command waiting*/
	error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
	if (error_codel != OS_ERR_NONE) {
		vFailSendBufferFullIRQtoDTC();
	}
}

/* Mock */
void vRxBuffer1FullIRQHandler(void) {
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_FULL;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 0;

	/*Sync the Meb task and tell that has a PUS command waiting*/
	error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
	if (error_codel != OS_ERR_NONE) {
		vFailSendBufferFullIRQtoDTC();
	}
}

/* Mock */
void vRxLastBufferFullIRQHandler(void) {
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_LAST;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 0;

	/*Sync the Meb task and tell that has a PUS command waiting*/
	error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
	if (error_codel != OS_ERR_NONE) {
		vFailSendBufferLastIRQtoDTC();
	}
}

/* Mock */
void vRxEmptyBufferFullIRQHandler(void) {
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_EMPTY;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = 0;

	/*Sync the Meb task and tell that has a PUS command waiting*/
	error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
	if (error_codel != OS_ERR_NONE) {
		vFailSendBufferEmptyIRQtoDTC();
	}
	
}

/* Mock */
void vRxCommErrorIRQHandler(void) {
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = M_DATA_FTDI_ERROR;
	uiCmdtoSend.ucByte[1] = 0;
	uiCmdtoSend.ucByte[0] = ucFTDIGetError();

	/*Sync the Meb task and tell that has a PUS command waiting*/
	error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
	if (error_codel != OS_ERR_NONE) {
		vFailFtdiErrorIRQtoDTC();
	}
	
}

/* Mocsk */
//void vFTDIClear( void ){}
//void vFTDIAbort( void ){}
//alt_u8 ucGetError( void ){return 20;}
//alt_u16 usiFTDInDataLeftInBuffer( void ){return 20;}
//bool bFTDIDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes){return TRUE;}
//bool bFTDIDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes){return TRUE;}
//bool bFTDIRequestFullImage( alt_u8 ucFee, alt_u8 ucCCD, alt_u8 ucSide, alt_u16 usiEP, alt_u16 usiHalfWidth, alt_u16 usiHeight ){return TRUE;}
