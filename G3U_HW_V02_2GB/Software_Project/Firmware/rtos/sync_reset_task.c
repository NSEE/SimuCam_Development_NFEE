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
    unsigned short int usiResetDelayL = 0;
    INT8U iErrorCodeL = 0;
    div_t xDlyAdjusted;
    

    for(;;){
        /* Suspend task because of it's high PRIO */
        OSTaskSuspend(SYNC_RESET_HIGH_PRIO);

        /* Receive delay time via qck */
        usiResetDelayL = (unsigned short int) OSQPend(xQueueSyncReset, 0, &iErrorCodeL);
        
        if (iErrorCodeL == OS_ERR_NONE) {

            /* Format the delay time */
            xDlyAdjusted = div (usiResetDelayL, 1000);

            /* Disable Sync */
            iErrorCodeL = bStopSync();

            /* Reset the time code */ 
            vResetTimeCode(&pxMeb->xFeeControl);

            /* Wait ufSynchDelay milliseconds adjusted */ 
            OSTimeDlyHMSM(0, 0, xDlyAdjusted.quot, xDlyAdjusted.rem);

           /* Reseting swap memory mechanism */
            pxMeb->ucActualDDR = 0;
            pxMeb->ucNextDDR = 1;
            //pxMeb->xDataControl.usiEPn = 0; /* TODO: Discover and correct this */

            /* Enable Sync */
            bStartSync();
        } else{
            // TODO error statement
        }
        
    }
}

