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
    volatile unsigned char ucIL;
	unsigned char error_codel;
	tQMask uiCmdtoSend;
    unsigned short int usiPreSyncTimeDif = xDefaults.usiPreBtSync;
    uiCmdtoSend.ulWord = 0;
    xGlobal.bJustBeforSync = TRUE;


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
            for (ucIL = 0; ucIL < N_OF_NFEE; ++ucIL) { 
                bSpwcClearTimecode(&pxMeb->xFeeControl.xNfee[ucIL].xChannel.xSpacewire); 
                pxMeb->xFeeControl.xNfee[ucIL].xControl.ucTimeCode = 0; 
            }


            /* Wait ufSynchDelay milliseconds adjusted minus the time needed for pre-sync*/ 
            OSTimeDlyHMSM(0, 0, xDlyAdjusted.quot, (xDlyAdjusted.rem - usiPreSyncTimeDif));

            /* Sending pre-sync */
            
            uiCmdtoSend.ucByte[2] = M_BEFORE_SYNC;
            
            for( ucIL = 0; ucIL < N_OF_NFEE; ucIL++ ){
                uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucIL;
                error_codel = OSQPostFront(xFeeQ[ ucIL ], (void *)uiCmdtoSend.ulWord);
                if ( error_codel != OS_ERR_NONE ) {
                    vFailSendMsgSync( ucIL );
                }
            }
            /* Wait the rest of the time */
            OSTimeDlyHMSM(0,0,0,usiPreSyncTimeDif);

            /* Enable Sync */
            bStartSync();
        } else{
            #if DEBUG_ON        //TODO verif se esta tudo certo com o erro
                if ( xDefaults.usiDebugLevel <= dlMajorMessage ){
                    fprintf(fp,"Sync Reset: Sync Reset Error\n");
                }
            #endif
        }   
    }
}