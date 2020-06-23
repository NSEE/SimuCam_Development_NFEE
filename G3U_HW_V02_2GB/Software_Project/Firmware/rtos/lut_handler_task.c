/*
 * lut_handler_task.c
 *
 *  Created on: 17 de mar de 2020
 *      Author: Tiago-note
 */

#include "lut_handler_task.h"



void vLutHandlerTask(void *task_data) {
	TSimucam_MEB *pxMebC;
	unsigned char ucIL;
	INT8U error_code;
	tQMask uiCmdFEE;
	INT8U ucIReq = 0;
	bool bSuccess = FALSE;
	bool bDmaReturn = FALSE;

	/* Fee Instance Data Structure */
	pxMebC = (TSimucam_MEB *) task_data;


	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
		fprintf(fp,"LUT Handler Task. (Task on)\n");
	}
	#endif

	for(;;){

		switch (pxMebC->xLut.eState) {
			case sInitLut:

				/* Clear RMAP Windowing Area and set memory offset for the RMAP codec [rfranca] */
				for (ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
					bWindClearWindowingArea(pxMebC->xLut.ucDdrNumber, pxMebC->xLut.ulInitialAddr[ucIL], pxMebC->xLut.ulSize);
					bWindSetWindowingAreaOffset(ucIL, pxMebC->xLut.ucDdrNumber, pxMebC->xLut.ulInitialAddr[ucIL]);
				}

				pxMebC->xLut.eState = sRunLut;
				break;
			case sConfigLut:

				/*Use only if needed.*/

				break;

			case sRunLut:

				/*Wait for message in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xLutQ , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdLUTCmd( pxMebC, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"LUT Handler Task: Can't get cmd from Queue (sRunLut) \n");
					}
					#endif
				}

				break;

			case stoRequestFTDI:
				ucIReq = 0;

				OSMutexPend(xMutexDMAFTDI, 0, &error_code); /* Try to get mutex that protects the xPus buffer. Wait max 10 ticks = 10 ms */
				if ( error_code == OS_NO_ERR ) {
					pxMebC->xLut.eState = sRequestFTDI;
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"\nLUT Handle Task: CRITICAL error, could not get mutex, for NFEE %u\n", ucIReq);
					}
					#endif
				}

				break;

			case sRequestFTDI:

				if ( ucIReq < N_OF_NFEE ) {
					if ( pxMebC->xLut.bUpdatedRam[ucIReq] == TRUE ) {

						vFtdiAbortOperation();
						vFtdiClearModule();
						vFtdiStartModule();

						/*Request send LUT to the NUC*/
						vFtdiResetLutWinArea();
						bWindCopyCcdXWindowingConfig(ucIReq);
						bSuccess = bFtdiTransmitLutWinArea(ucIReq, pxMebC->xFeeControl.xNfee[ucIReq].xCcdInfo.usiHalfWidth, pxMebC->xFeeControl.xNfee[ucIReq].xCcdInfo.usiHeight, pxMebC->xLut.ulSize);
						if ( bSuccess == TRUE ) {

							if (pxMebC->xLut.ucDdrNumber == 0) {
								bDmaReturn = bSdmaFtdiDmaTransfer(eDdr2Memory1, (alt_u32 *)pxMebC->xLut.ulInitialAddr[ucIReq], (alt_u32)pxMebC->xLut.ulSize, eSdmaTxFtdi);
							} else {
								bDmaReturn = bSdmaFtdiDmaTransfer(eDdr2Memory2, (alt_u32 *)pxMebC->xLut.ulInitialAddr[ucIReq], (alt_u32)pxMebC->xLut.ulSize, eSdmaTxFtdi);
							}

							if ( bDmaReturn == TRUE ) {

								pxMebC->xLut.eState = sWaitingIRQFinish;
								ucIReq++;
							} else {
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
									fprintf(fp,"\nLUT Handle Task: DMA Schedule fail, for NFEE %u\n", ucIReq);
								}
								#endif
							}

						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"\nLUT Handle Task: Request to send LUT fail, for NFEE %u\n", ucIReq);
							}
							#endif
						}

					} else {
						ucIReq++;
					}

				} else {
					pxMebC->xLut.eState = sFinishedFTDI;
				}

				break;

			case sWaitingIRQFinish:

				/*Wait for message in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xLutQ , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdLUTWaitIRQFinish( pxMebC, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"LUT Handler Task: Can't get cmd from Queue (sWaitingIRQFinish) \n");
					}
					#endif
				}

				break;

			case sFinishedFTDI:

				OSMutexPost(xMutexDMAFTDI);

				for (ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {

					/*Cleaning all configs and possible updates*/
					pxMebC->xLut.bUpdatedRam[ucIL] = FALSE;
					pxMebC->xLut.bFakingLUT[ucIL] = FALSE;
				}

				vFtdiResetLutWinArea();

				pxMebC->xLut.eState = sRunLut;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					debug(fp,"LUT Handler Task: Unknown state\n");
				#endif
				/* todo:Aplicar toda logica de mudança de esteado aqui */
				pxMebC->eMode = sRunLut;
				break;

		}
	}
}

void vQCmdLUTCmd( TSimucam_MEB *pxMebCP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucNFEENumber = 0;

	uiCmdFEEL.ulWord = cmd;


	switch (uiCmdFEEL.ucByte[2]) {

		case M_LUT_UPDATE:

			ucNFEENumber = uiCmdFEEL.ucByte[0];

			if ( pxMebCP->xLut.bFakingLUT[ucNFEENumber] == FALSE ) {
				pxMebCP->xLut.bUpdatedRam[ucNFEENumber] = TRUE;
			}

			break;

		case M_BEFORE_MASTER:

			pxMebCP->xLut.eState = stoRequestFTDI;
			break;

		case M_LUT_FTDI_BUFFER_FINISH:
			break;

		case M_LUT_FTDI_ERROR:
			vFtdiAbortOperation();
			vFtdiClearModule();
			vFtdiStartModule();
			break;

		case M_BEFORE_SYNC:
		case M_SYNC:
		case M_PRE_MASTER:
		case M_MASTER_SYNC:
			/*DO nothing for now*/
			break;

		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"LUT Task: Unexpected command. \n");
			}
			#endif
			break;
	}
}

void vQCmdLUTWaitIRQFinish( TSimucam_MEB *pxMebCP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucNFEENumber = 0;

	uiCmdFEEL.ulWord = cmd;


	switch (uiCmdFEEL.ucByte[2]) {

		case M_LUT_UPDATE:

			ucNFEENumber = uiCmdFEEL.ucByte[0];

			if ( pxMebCP->xLut.bFakingLUT[ucNFEENumber] == FALSE ) {
				pxMebCP->xLut.bUpdatedRam[ucNFEENumber] = TRUE;
			}

			break;

		case M_LUT_FTDI_BUFFER_FINISH:
			pxMebCP->xLut.eState = sRequestFTDI;
			break;

		case M_LUT_FTDI_ERROR:
			vFtdiAbortOperation();
			vFtdiClearModule();
			vFtdiStartModule();
			pxMebCP->xLut.eState = sRequestFTDI;
			break;

		case M_BEFORE_MASTER:
		case M_BEFORE_SYNC:
		case M_SYNC:
		case M_PRE_MASTER:
		case M_MASTER_SYNC:
			/*DO nothing for now*/
			break;

		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"LUT Task: Unexpected command. \n");
			}
			#endif
	}
}
