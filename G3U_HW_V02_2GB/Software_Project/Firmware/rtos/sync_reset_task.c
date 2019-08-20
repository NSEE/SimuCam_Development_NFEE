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

    

    for(;;){

        /* receive delay time via qck */
        usiResetDelayL = (unsigned short int) OSQPend(xQueueSyncReset, 0, &iErrorCodeL);
        
        if (iErrorCodeL == OS_ERR_NONE) {

            /* Disable Sync */
            bStopSync();

            /* Reset the time code */ 
            vResetTimeCode(&pxMeb->xFeeControl);

            /* Wait ufSynchDelay milliseconds */ 
            OSTimeDlyHMSM(0, 0, 0, usiResetDelayL);

           /* Reseting swap memory mechanism */
            pxMeb->ucActualDDR = 0;
            pxMeb->ucNextDDR = 1;
            //pxMeb->xDataControl.usiEPn = 0; /* TODO: Discover and correct this */

            /* Enable Sync */
            bStartSync();

            /* Decrease Self Priority */
            iErrorCodeL = OSTaskChangePrio(OS_PRIO_SELF, SYNC_RESET_LOW_PRIO);
        } else{
            //TODO error statement
        }
        
    }
}

