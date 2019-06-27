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


    for(;;){


    // Stop all transmission

    // Put all NFEE in Stand-by mode, if not in Config mode

    // Reset the time code
    //vResetTimeCode(&xMeb->xFeeControl);

    // Wait ufSynchDelay milliseconds

    // Release a synchronization signal

    // Start new cycle


        //receive delay time via qck
        OSPend(xSemSyncReset);

        vResetTimeCode(&xMeb->xFeeControl);
        OSTimeDlyHMSM(0, 0, 0, pxMebC->usiDelaySyncReset);
    }
}


