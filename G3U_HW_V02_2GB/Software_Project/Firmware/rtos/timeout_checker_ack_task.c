/*
 * timeout_ack_task.c
 *
 *  Created on: 28/12/2018
 *      Author: Tiago-Low
 */

#include "timeout_checker_ack_task.h"


/* Could impact in the overall performance of the system due to need many shared resources (many mutexes) */
void vTimeoutCheckerTask(void *task_data) {
    bool bFinished32 = FALSE;
    bool bFinished64 = FALSE;
    bool bFinished128 = FALSE;
	INT8U error_code;
    unsigned char ucCountRetries = 0;
    unsigned char i = 0, k =0;
	unsigned char ucRetransB32[N_32];
	unsigned char ucRetransB64[N_64];
	unsigned char ucRetransB128[N_128];

    #ifdef DEBUG_ON
        debug(fp,"vTimeoutCheckerTask, enter task.\n");
    #endif

    for (;;) {
        /* This semaphore is used to sync the Timer used for check timeout and this task that is for actualy implement the logic of the timeout for the communication*/
        OSSemPend(xSemTimeoutChecker, 0, &error_code);
        if ( error_code == OS_NO_ERR ) {
            /*  Time to check all the (re)transmission buffers in order to retransmit if any message got timeout*/

            /*  Writing 0xFF in the buffer to check after if there is any scheduled retransmission
                If there is some, the valur will be between 0 and <max buffer size>*/
            memset(ucRetransB32, 255, N_32);
            memset(ucRetransB64, 255, N_64);
            memset(ucRetransB128, 255, N_128);

            bFinished32=FALSE;
            bFinished64=FALSE;
            bFinished128=FALSE;
            ucCountRetries = 0;

            /* The mutex will not be blocking, so it will try for five times search in the three (re)transmission buffer */
            while ( ( ucCountRetries < 6 ) && ( (bFinished32==FALSE) || (bFinished64==FALSE) || (bFinished128==FALSE) ) ) {

                if ( bFinished32 == FALSE ) {
                    /* Check all positions of the (re)transmission buffer*/
                    OSMutexPend(xMutexBuffer32, 2, &error_code); /* Try to get the mutex (wait 2 ticks) */
                    if ( error_code == OS_ERR_NONE ) {
                        /*Search for the id*/
                        k = 0;
                        for(i = 0; i < N_32; i++)
                        {
                            if ( xBuffer32[i].usiId != 0 ) {
                                /* If isn't Zero, so there a message in this position of the (re)transmission buffer */

                                if ( xBuffer32[i].ucNofRetries < 1 ) {
                                    /* Reach the max number of retransmission. Clear the position. */
                                    xBuffer32[i].usiId = 0;
                                    error_code = OSSemPost(xSemCountBuffer32);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer32();
                                    }
                                } else {
                                    /* Check if there's timeout to retransmit */
                                    xBuffer32[i].usiTimeOut--;
                                    if ( xBuffer32[i].usiTimeOut < 1 ) {
                                        /* Schedule to retransmit */
                                        ucRetransB32[k] = i;
                                        k++;
                                    }
                                }
                            }
                        }
                        OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer32*/
                        bFinished32 = TRUE;
                    }
                }

                if ( bFinished64 == FALSE ) {
                    /* Check all positions of the (re)transmission buffer*/
                    OSMutexPend(xMutexBuffer64, 2, &error_code); /* Try to get the mutex (wait 2 ticks) */
                    if ( error_code == OS_ERR_NONE ) {
                        /*Search for the id*/
                        k = 0;
                        for(i = 0; i < N_64; i++)
                        {
                            if ( xBuffer64[i].usiId != 0 ) {
                                /* If isn't Zero, so there a message in this position of the (re)transmission buffer */

                                if ( xBuffer64[i].ucNofRetries < 1 ) {
                                    /* Reach the max number of retransmission. Clear the position. */
                                    xBuffer64[i].usiId = 0;
                                    error_code = OSSemPost(xSemCountBuffer64);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer64();
                                    }
                                } else {
                                    /* Check if there's timeout to retransmit */
                                    xBuffer64[i].usiTimeOut--;
                                    if ( xBuffer64[i].usiTimeOut < 1 ) {
                                        /* Schedule to retransmit */
                                        ucRetransB64[k] = i;
                                        k++;
                                    }
                                }
                            }
                        }
                        OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer32*/
                        bFinished64 = TRUE;
                    }
                }

                if ( bFinished128 == FALSE ) {
                    /* Check all positions of the (re)transmission buffer*/
                    OSMutexPend(xMutexBuffer128, 2, &error_code); /* Try to get the mutex (wait 2 ticks) */
                    if ( error_code == OS_ERR_NONE ) {
                        /*Search for the id*/
                        k = 0;
                        for(i = 0; i < N_128; i++)
                        {
                            if ( xBuffer128[i].usiId != 0 ) {
                                /* If isn't Zero, so there a message in this position of the (re)transmission buffer */

                                if ( xBuffer128[i].ucNofRetries < 1 ) {
                                    /* Reach the max number of retransmission. Clear the position. */
                                    xBuffer128[i].usiId = 0;
                                    error_code = OSSemPost(xSemCountBuffer128);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer128();
                                    }
                                } else {
                                    /* Check if there's timeout to retransmit */
                                    xBuffer128[i].usiTimeOut--;
                                    if ( xBuffer128[i].usiTimeOut < 1 ) {
                                        /* Schedule to retransmit */
                                        ucRetransB128[k] = i;
                                        k++;
                                    }
                                }
                            }
                        }
                        OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer32*/
                        bFinished128 = TRUE;
                    }
                }
                ucCountRetries++;
            }

            /*  Check if could not check some of the (re)transmission buffer*/
            if ( (bFinished32==FALSE) || (bFinished64==FALSE) || (bFinished128==FALSE) ) {
                /*  Could not check all (re)transmission buffer, only show message for now. There's no hard impact to thesystem
                    but we need to know that is accurring*/
                vCouldNotCheckBufferTimeOutFunction();
            }

            /*  ATTENTION: Deadlock "avoided", but keep checking if there's any problem related to dead lock*/
            /*  Retransmit could slow down the system in the worst case, because need to get more than one mutex at same time
                this also could impact in various task that need the mutex also, as this operation may be rare
                before try to get all mutexes, will check if there is anything in the scheduler buffers (ucRetransB32,ucRetransB64,ucRetransB128). */
                
            /*  Most part of the time this will be false, and many processing and kernell resources will be saved with this verification*/
            if ( (ucRetransB32[0] != 255) && (ucRetransB64[0] != 255) && (ucRetransB128[0] != 255) ) {

                /*  This operation will try to use the UART TX buffer, so after get the mutex it will remain for almost 3 or 4 ticks in the worst case.
                    In order to avoid that all the system lost the access to the communication for more time, and to minimize the priority inversion
                    if we can't get the mutex for the buffer32, buffer 64 or buffer128, we continue and in the next cycle of checkout it will try to re-send finaly. */                

                /*  Sleep for 50 ticks (50 milli) in the worst case*/
                OSMutexPend(xTxUARTMutex, 50, &error_code); /* Wait 50 ticks = 50 ms */
                if ( error_code == OS_NO_ERR ) {


                    if ( ucRetransB32[0] != 255 ) {
                        OSMutexPend(xMutexBuffer32, 1, &error_code); /* Try to get the mutex (wait 1 ticks) */
                        if ( error_code == OS_ERR_NONE ) {
                            k = 0;
                            do
                            {
                                i = ucRetransB32[k];
                                xBuffer32[i].ucNofRetries--;
                                xBuffer32[i].usiTimeOut = TIMEOUT_COUNT;
                                puts(xBuffer32[i].buffer);                                
                                k++;
                            } while ( ucRetransB32[k] != 255 );                       

                            OSMutexPost(xMutexBuffer32);
                        } else {
                            /*  Could not get the mutex for the buffer32. There is no big impact to the system. So next cycle it may be transmited.
                                This is not a reason to exit the execution of all Simucam.*/
                            vCouldNotRetransmitB32TimeoutTask();
                        }
                    }

                    if ( ucRetransB64[0] != 255 ) {
                        OSMutexPend(xMutexBuffer64, 1, &error_code); /* Try to get the mutex (wait 1 ticks) */
                        if ( error_code == OS_ERR_NONE ) {
                            k = 0;
                            do
                            {
                                i = ucRetransB64[k];
                                xBuffer64[i].ucNofRetries--;
                                xBuffer64[i].usiTimeOut = TIMEOUT_COUNT;
                                puts(xBuffer64[i].buffer);                                
                                k++;
                            } while ( ucRetransB64[k] != 255 );

                            OSMutexPost(xMutexBuffer64);
                        } else {
                            /*  Could not get the mutex for the buffer32. There is no big impact to the system. So next cycle it may be transmited.
                                This is not a reason to exit the execution of all Simucam.*/
                            vCouldNotRetransmitB64TimeoutTask();
                        }    
                    }

                    if ( ucRetransB128[0] != 255 ) {
                        OSMutexPend(xMutexBuffer128, 1, &error_code); /* Try to get the mutex (wait 1 ticks) */
                        if ( error_code == OS_ERR_NONE ) {
                            k = 0;
                            do
                            {
                                i = ucRetransB128[k];
                                xBuffer128[i].ucNofRetries--;
                                xBuffer128[i].usiTimeOut = TIMEOUT_COUNT;
                                puts(xBuffer128[i].buffer);                                
                                k++;
                            } while ( ucRetransB128[k] != 255 );

                            OSMutexPost(xMutexBuffer128);
                        } else {
                            /*  Could not get the mutex for the buffer32. There is no big impact to the system. So next cycle it may be transmited.
                                This is not a reason to exit the execution of all Simucam.*/
                            vCouldNotRetransmitB128TimeoutTask();
                        }
                    }                    
                    OSMutexPost(xTxUARTMutex);
                } else {
                    /*  Couldn't get access to the UART tx buffer, there is no big impact to the system. So next cycle it may be transmited.
                        This is not a reason to exit the execution of all Simucam.*/
                    vFailCouldNotRetransmitTimeoutTask();
                }
            }

        } else {
            /* Should not get here, is a blocking semaphore for sync.*/
            vFailGetBlockingSemTimeoutTask();
        }
    }
}
