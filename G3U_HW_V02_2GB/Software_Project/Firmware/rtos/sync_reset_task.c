/*
 ************************************************************************************************
 *                                              NSEE
 *                                              IMT
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : sync_reset_task.c
 * Programmer(s): Yuri Bunduki
 * Created on: Jun 27, 2019
 * Description  : Source file for the sync_reset task.
 ************************************************************************************************
 */
/*$PAGE*/

#include "sync_reset_task.h"


void vSyncResetTask( void *task_data ){
    TSimucam_MEB *pxMeb;
    pxMeb = (TSimucam_MEB *) task_data;
    unsigned int usiResetDelayL = 0;
    INT8U iErrorCodeL = 0;
    div_t xDlyAdjusted;
    volatile unsigned char ucIL;
    unsigned int usiPreSyncTimeDif = 200; /*Sum of all Delays*/
    /*xGlobal.bJustBeforSync = TRUE;*/



    for(;;){
        /* Suspend task because of it's high PRIO */
        OSTaskSuspend(SYNC_RESET_HIGH_PRIO);

        xGlobal.bSyncReset = TRUE;

        /* Receive delay time via qck */
        usiResetDelayL = (unsigned int) OSQPend(xQueueSyncReset, 200, &iErrorCodeL);

        if (iErrorCodeL == OS_ERR_NONE) {


        	/* Stop the Sync (Stopping the simulation) */
        	bStopSync();
        	vSyncClearCounter();
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"++++ Sync Stopped\n");
			}
			#endif


			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"++++ Force Reset Internals\n");
			}
			#endif
        	/* Send a message to the NFEE Controller forcing the mode */
        	vSendCmdQToNFeeCTRL_PRIO( M_NFC_CONFIG_RESET, 0, 0 );
        	vSendCmdQToDataCTRL_PRIO( M_DATA_CONFIG_FORCED, 0, 0 );
        	/* Give time to all tasks receive the command */
        	OSTimeDlyHMSM(0, 0, 0, 50);

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"++++ Setting all FEEs to mode ON\n");
			}
			#endif
            for (ucIL = 0; ucIL < N_OF_NFEE; ++ucIL) {

            	vSendCmdQToNFeeCTRL_GEN(ucIL, M_FEE_ON_FORCED, 0, ucIL );

            	/* Reset the time code */
                bSpwcClearTimecode(&pxMeb->xFeeControl.xNfee[ucIL].xChannel.xSpacewire);
                pxMeb->xFeeControl.xNfee[ucIL].xControl.ucTimeCode = 0;
            }

            /*Giving time to all FEE*/
            OSTimeDlyHMSM(0, 0, 0, 100);

        	/* Send a message to the NFEE Controller forcing the mode */
        	vSendCmdQToNFeeCTRL_PRIO( M_NFC_RUN_FORCED, 0, 0 );

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"++++ Restarting the sky to EP 0\n");
			}
			#endif

        	pxMeb->ucActualDDR = 1;
        	pxMeb->ucNextDDR = 0;

        	vSendCmdQToDataCTRL_PRIO( M_DATA_RUN_FORCED, 0, 0 );
        	OSTimeDlyHMSM(0, 0, 0, 50);


            /* Format the delay time */
            xDlyAdjusted = div ((usiResetDelayL - usiPreSyncTimeDif), 1000);

            /* Wait ufSynchDelay milliseconds adjusted minus the time needed for pre-sync*/
            OSTimeDlyHMSM(0, 0, xDlyAdjusted.quot, (xDlyAdjusted.rem));

            xGlobal.bSyncReset = FALSE;
            /* Enable Sync */
			bSyncCtrReset();
			vSyncClearCounter();
			bStartSync();
        } else{
            #if DEBUG_ON        //TODO verif se esta tudo certo com o erro
                if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
                    fprintf(fp,"Sync Reset: Sync Reset Error 3\n");
                }
            #endif
        }
    }
}
