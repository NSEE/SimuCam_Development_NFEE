/*
 * data_control_task.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */



#include "data_control_task.h"

/* 0% Ready! */
void vDataControlTask(void *task_data) {
	tQMask uiCmdDTC;
	INT8U error_code;
	TNData_Control *pxDataC;
	unsigned char ucIL = 0;

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
						xDataControlL->bUpdateComplete = TRUE;

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
						/* Indicates that the memory update is not completed, at this moment is just begging */
						xDataControlL->bUpdateComplete = FALSE;

						for ( ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
							xDataControlL->bInsgestionSchedule[ucIL] = (*xDataControlL->xReadOnlyFeeControl.pbEnabledNFEEs[ucIL]
							if ( TRUE == (*xDataControlL->xReadOnlyFeeControl.pbEnabledNFEEs[ucIL]) ) {
								xDataControlL->bInsgestionSchedule[ucIL] = TRUE;
							}
						}
						


						break;

					case sSubRequest:
					
						break;

					case sSubFillingMem:
					
						break;

					case sSubLastPckt:
					
						break;

				default:
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						debug(fp,"NFEE Controller Task: Unknown SUB state in running mode.\n");
					#endif
					/* Back to Config Mode */
					pxDataC->sMode = sMebtoConfig;
				}

				break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				debug(fp,"NFEE Controller Task: Unknown state, backing to Config Mode.\n");
			#endif
			/* Back to Config Mode */
			pxDataC->sMode = sMebtoConfig;
		}
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

