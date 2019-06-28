/*
 ************************************************************************************************
 *                                              NSEE
 *                                             Address
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


void vSyncResetTask( void ){
    unsigned short int usiResetDelayL = 0;
    INT8U iErrorCodeL = 0;

    for(;;){

        //receive delay time via qck
        usiResetDelayL = (unsigned short int) OSQPend(xQueueSyncReset, 0, &iErrorCodeL);

        // Reset the time code
        vResetTimeCode(&xMeb->xFeeControl);

        //Disable Sync
        bStopSync();

        // Reset the time code
        vResetTimeCode(&xMeb->xFeeControl);

        // Wait ufSynchDelay milliseconds
        OSTimeDlyHMSM(0, 0, 0, usiResetDelayL);
        
        //Enable Sync
        bStartSync();

        // Decrease Self Priority
        iErrorCodeL = OSTaskChangePrio(OS_PRIO_SELF, SYNC_RESET_LOW_PRIO);
    }
}


