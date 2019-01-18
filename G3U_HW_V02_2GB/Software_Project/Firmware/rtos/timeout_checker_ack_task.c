/*
 * timeout_ack_task.c
 *
 *  Created on: 28/12/2018
 *      Author: Tiago-Low
 */

#include "timeout_checker_ack_task.h"



void vTimeoutCheckerTaskv2(void *task_data) {
	INT8U ucErrorCode = 0;

    #ifdef DEBUG_ON
        debug(fp,"vTimeoutCheckerTask, enter task.\n");
    #endif   

    for (;;) {
        OSSemPend(xSemTimeoutChecker, 0, &ucErrorCode);
        if ( ucErrorCode == OS_NO_ERR ) {
            /* Just check the restransmission buffer */
            vCheck();
        } else {
            /* Should not get here, is a blocking semaphore for sync.*/
            vFailGetBlockingSemTimeoutTask();
        }
    }
}


void vCheck( void ) {
	INT8U ucErrorCode = 0;
    unsigned char ucHashVerification = 0;

    ucHashVerification = 0;
    ucHashVerification |= (( SemCount32 == N_32 ) << 2) | ( ( SemCount64 == N_64 ) << 1 ) | (( SemCount128 == N_128 ) << 0);

    /* Nothing in the (re)transmission buffer */
    if ( ucHashVerification == 0b00000111 )
        return;

    /* Try to get the Mutex of the UART */
	OSMutexPend(xTxUARTMutex, 0, &ucErrorCode); /* Blocking */

    if ( ucErrorCode != OS_NO_ERR ) {
        /* Should never get here, is a blocking operation */
		#ifdef DEBUG_ON
			debug(fp,"Should never get here. Trying to get xTxUARTMutex. (vCheck)\n");
		#endif
        return;
    }


    /* ---> At this point we have the Mutex of TX UART, let's try to get the mutex of all retransmission buffer. */

    /* There are any spot used in the xBuffer128? */
    if ( 0b00000001 == (0b00000001 & ucHashVerification ) )
        vCheckRetransmission128();
    else
        memset( xInUseRetrans.b128 , FALSE , sizeof(bool)*N_128); /* For consistency with SemCount128 */

        /* There are any spot used in the xBuffer64? */
    if ( 0b00000010 == (0b00000010 & ucHashVerification ) )
        vCheckRetransmission64();
    else
        memset( xInUseRetrans.b64 , FALSE , sizeof(bool)*N_64); /* For consistency with SemCount64 */

    /* There are any spot used in the xBuffer32? */
    if ( 0b00000100 == (0b00000100 & ucHashVerification ) )
        vCheckRetransmission32();
    else
        memset( xInUseRetrans.b32 , FALSE , sizeof(bool)*N_32); /* For consistency with SemCount32 */


    OSMutexPost(xTxUARTMutex);
    return;
}

inline void vCheckRetransmission128( void ) {
    INT8U ucErrorCodeL = 0;
    unsigned char ucIL = 0;
    unsigned char ucMax = 0;

    OSMutexAccept(xMutexBuffer128, &ucErrorCodeL); /* Just check the the mutex (non blocking) */
    if ( ucErrorCodeL != OS_NO_ERR ) {
        /* Could not get the Mutex at this time, not critical it will try again later */
        return;
    }
    

    /* ---> At this point we have access to the xBuffer128*/

    /* Search the one that if in use */
	for( ucIL = 0; ucIL < N_128; ucIL++)
	{
        /* Check if in use */
        if ( xInUseRetrans.b128[ucIL] == TRUE ) {

            if ( xBuffer128[ucIL].bSent == TRUE )
                if ( ++xBuffer128[ucIL].usiTimeOut > TIMEOUT_COUNT )
                    xBuffer128[ucIL].bSent = FALSE;

            if ( xBuffer128[ucIL].bSent == FALSE ) {
                puts(xBuffer128[ucIL].buffer);
                xBuffer128[ucIL].bSent = TRUE;
                xBuffer128[ucIL].usiTimeOut = 0;

                ucMax = ( xBuffer128[ucIL].usiId == 1 ) ? N_RETRIES_INI_INF : N_RETRIES_COMM;

                /* Check if already tried all the times */
                if ( ++xBuffer128[ucIL].ucNofRetries > ucMax ) {
                    /* Now it is a Free place */
                    xInUseRetrans.b128[ucIL] = FALSE;
                    SemCount128++;
                    ucErrorCodeL = OSSemPost(xSemCountBuffer128);
                    if ( ucErrorCodeL != OS_ERR_NONE ) {
                        SemCount128--;
                        vFailSetCountSemaphorexBuffer128(); /*Could not send back the semaphore, this is critical.*/
                    }                    
                }
            }   
        }
	}
    OSMutexPost(xMutexBuffer128);

    return;
}

inline void vCheckRetransmission64( void ) {
    INT8U ucErrorCodeL = 0;
    unsigned char ucIL = 0;

    OSMutexAccept(xMutexBuffer64, &ucErrorCodeL); /* Just check the the mutex (non blocking) */
    if ( ucErrorCodeL != OS_NO_ERR ) {
        /* Could not get the Mutex at this time, not critical it will try again later */
        return;
    }
    

    /* ---> At this point we have access to the xBuffer64*/

    /* Search the one that if in use */
	for( ucIL = 0; ucIL < N_64; ucIL++)
	{
        /* Check if in use */
        if ( xInUseRetrans.b64[ucIL] == TRUE ) {

            if ( xBuffer64[ucIL].bSent == TRUE )
                if ( ++xBuffer64[ucIL].usiTimeOut > TIMEOUT_COUNT )
                    xBuffer64[ucIL].bSent = FALSE;

            if ( xBuffer64[ucIL].bSent == FALSE ) {
                puts(xBuffer64[ucIL].buffer);
                xBuffer64[ucIL].bSent = TRUE;
                xBuffer64[ucIL].usiTimeOut = 0;
                /* Check if already tried all the times */
                if ( ++xBuffer64[ucIL].ucNofRetries > N_RETRIES_COMM ) {
                    /* Now it is a Free place */
                    xInUseRetrans.b64[ucIL] = FALSE;
                    SemCount64++;
                    ucErrorCodeL = OSSemPost(xSemCountBuffer64);
                    if ( ucErrorCodeL != OS_ERR_NONE ) {
                        SemCount64--;
                        vFailSetCountSemaphorexBuffer64(); /*Could not send back the semaphore, this is critical.*/
                    }                    
                }
            }   
        }
	}
    OSMutexPost(xMutexBuffer64);

    return;
}


inline void vCheckRetransmission32( void ) {
    INT8U ucErrorCodeL = 0;
    unsigned char ucIL = 0;

    OSMutexAccept(xMutexBuffer32, &ucErrorCodeL); /* Just check the the mutex (non blocking) */
    if ( ucErrorCodeL != OS_NO_ERR ) {
        /* Could not get the Mutex at this time, not critical it will try again later */
        return;
    }
    

    /* ---> At this point we have access to the xBuffer32*/

    /* Search the one that if in use */
	for( ucIL = 0; ucIL < N_32; ucIL++)
	{
        /* Check if in use */
        if ( xInUseRetrans.b32[ucIL] == TRUE ) {

            if ( xBuffer32[ucIL].bSent == TRUE )
                if ( ++xBuffer32[ucIL].usiTimeOut > TIMEOUT_COUNT )
                    xBuffer32[ucIL].bSent = FALSE;

            if ( xBuffer32[ucIL].bSent == FALSE ) {
                puts(xBuffer32[ucIL].buffer);
                xBuffer32[ucIL].bSent = TRUE;
                xBuffer32[ucIL].usiTimeOut = 0;
                /* Check if already tried all the times */
                if ( ++xBuffer32[ucIL].ucNofRetries > N_RETRIES_COMM ) {
                    /* Now it is a Free place */
                    xInUseRetrans.b32[ucIL] = FALSE;
                    SemCount32++;
                    ucErrorCodeL = OSSemPost(xSemCountBuffer32);
                    if ( ucErrorCodeL != OS_ERR_NONE ) {
                        SemCount32--;
                        vFailSetCountSemaphorexBuffer32(); /*Could not send back the semaphore, this is critical.*/
                    }                    
                }
            }   
        }
	}
    OSMutexPost(xMutexBuffer32);

    return;
}




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
                    but we need to know that is occourring*/
                vCouldNotCheckBufferTimeOutFunction();
            }

            /*  ATTENTION: Deadlock "avoided", but keep checking if there's any problem related to dead lock*/
            /*  Retransmit could slow down the system in the worst case, because need to get more than one mutex at same time
                this also could impact in various task that need the mutex also, as this operation may be rare
                before try to get all mutexes, will check if there is anything in the scheduler buffers (ucRetransB32,ucRetransB64,ucRetransB128). */
                
            /*  Most part of the time this will be false, and many processing and kernell resources will be saved with this verification*/
            if ( (ucRetransB32[0] != 255) || (ucRetransB64[0] != 255) || (ucRetransB128[0] != 255) ) {

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
