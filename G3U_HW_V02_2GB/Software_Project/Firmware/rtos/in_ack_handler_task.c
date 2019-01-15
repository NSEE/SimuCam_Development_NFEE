/*
 * in_ack_handler_task.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */


#include "in_ack_handler_task.h"


void vInAckHandlerTask(void *task_data) {

	bool bFound = FALSE;
    bool bFinished32 = FALSE;
    bool bFinished64 = FALSE;
    bool bFinished128 = FALSE;
	INT8U error_code;
    INT8U ucReturnMutex;
	tReceiverACKState eReceiverAckState;
	static txReceivedACK xRAckLocal;
    unsigned char ucCountRetries = 0;
    unsigned char i = 0;

	#ifdef DEBUG_ON
		debug(fp,"vReceiverAckTask, enter task.\n");
	#endif

	eReceiverAckState = sRAConfiguring;

	for(;;){

		switch (eReceiverAckState) {
			case sRAConfiguring:
                /*For future implementations*/
                eReceiverAckState = sRAGettingACK;
				break;
            case sRAGettingACK:
                /* Waits the semaphore that indicates there are some ack message was received*/
                OSSemPend(xSemCountReceivedACK, 0, &error_code);
                if ( error_code == OS_ERR_NONE ) {

                    OSMutexPend(xMutexReceivedACK, 0, &error_code);
                    if ( error_code == OS_ERR_NONE ) {

                        /*Search for the ack*/
                        for(i = 0; i < N_ACKS_RECEIVED; i++)
                        {
                            
                            if ( xReceivedACK[i].cType != 0 ) {

                                /*  Is it a NACK? */
                                if ( xReceivedACK[i].cType != NACK_CHAR ) {
                                    /* Locate the message, copy for the local variable in order to free the mutex. */
                                    xRAckLocal = xReceivedACK[i];
                                    eReceiverAckState = sRACleanningBuffer;
                                    break;
                                } else {
                                    /*  Yes is a NACK, do nothing. The packet will be retransmited after timeout, since we can't know which message
                                        was not transmited, is too much expensive retransmit all "waiting ack" packets. So, do nothing, excet clear the pipe buffer*/
                                    #ifdef DEBUG_ON
                                        debug(fp,"NACK received.");
                                    #endif
                                    eReceiverAckState = sRAGettingACK;
                                }
                                xReceivedACK[i].cType = 0; /* indicates that this position now can be used by other message*/
                            }

                        }
                        OSMutexPost(xMutexReceivedACK);
                    } else {
                        /*  Should never get here, will wait without timeout for the semaphore.
                            But if some error accours we will do nothing but print in the console */
                        vFailGetMutexReceiverTask();
                    }

                } else {
                    /*  Should never get here, will wait without timeout for the semaphore.
                        But if some error accours we will do nothing but print in the console */
                    vFailGetCountSemaphoreReceiverTask();
                }
                break;
			case sRACleanningBuffer:
                /* Now a search will be performed in the three output buffer in order to find
                   the (re)transmission buffer identified by the id and erase it. */

                bFound = FALSE;
                bFinished32=FALSE;
                bFinished64=FALSE;
                bFinished128=FALSE;
                ucCountRetries = 0;
                /* The mutex will not be blocking, so it will try for five times search in the three (re)transmission buffer */
                while ( ( bFound == FALSE ) && ( ucCountRetries < 6 ) && ( (bFinished32==FALSE) || (bFinished64==FALSE) ||(bFinished128==FALSE) ) ) {

                    if ( (bFound == FALSE) && (bFinished32 == FALSE) ) {
                        /* Search in three (re)transmission buffer for the id*/
                        ucReturnMutex = OSMutexAccept(xMutexBuffer32, &error_code); /* Just check the the mutex (non blocking) */
                        if ( error_code == OS_NO_ERR ) {
                            /*Search for the id*/
                            for(i = 0; i < N_32; i++)
                            {
                                if ( xBuffer32[i].usiId == xRAckLocal.usiId ) {
                                    /* Free the buffer and indicate by setting usiId to Zero. Post in the count semaphore to indicate
                                    that is an free position in the (re)trasmission buffer. */
                                    xBuffer32[i].usiId = 0;
                                    bFound = TRUE;
                                    error_code = OSSemPost(xSemCountBuffer32);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer32();
                                    }
                                    break;
                                }
                            }
                            OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer32*/
                            bFinished32 = TRUE;
                        }
                    }


                    if ( (bFound == FALSE) && (bFinished64 == FALSE) ) {
                        /* Search in three (re)transmission buffer for the id*/
                        ucReturnMutex = OSMutexAccept(xMutexBuffer64, &error_code); /* Just check the the mutex (non blocking) */
                        if ( error_code == OS_NO_ERR ) {
                            /*Search for the id*/
                            for(i = 0; i < N_64; i++)
                            {
                                if ( xBuffer64[i].usiId == xRAckLocal.usiId ) {
                                    /* Free the buffer and indicate by setting usiId to Zero. Post in the count semaphore to indicate
                                    that is an free position in the (re)trasmission buffer. */
                                    xBuffer64[i].usiId = 0;

                                    bFound = TRUE;
                                    error_code = OSSemPost(xSemCountBuffer64);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer64();
                                    }
                                    break;
                                }
                            }
                            OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer64*/
                            bFinished64 = TRUE;
                        }
                    }

                    if ( (bFound == FALSE) && (bFinished128 == FALSE) ) {
                        /* Search in three (re)transmission buffer for the id*/
                        ucReturnMutex = OSMutexAccept(xMutexBuffer128, &error_code); /* Just check the the mutex (non blocking) */
                        if ( error_code == OS_NO_ERR ) {
                            /*Search for the id*/
                            for(i = 0; i < N_128; i++)
                            {
                                if ( xBuffer128[i].usiId == xRAckLocal.usiId ) {
                                    /* Free the buffer and indicate by setting usiId to Zero. Post in the count semaphore to indicate
                                    that is an free position in the (re)trasmission buffer. */
                                    xBuffer128[i].usiId = 0;
                                    bFound = TRUE;
                                    error_code = OSSemPost(xSemCountBuffer128);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer128();
                                    }
                                    break;
                                }
                            }
                            OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
                            bFinished128 = TRUE;
                        }
                    }
                    /* Check if finish the search, if not probably some mutex is in use, so put the task to sleep for some time*/
                    if ( ( bFound == FALSE ) && ( (bFinished32==FALSE) || (bFinished64==FALSE) ||(bFinished128==FALSE) )) {
                        OSTimeDly(5); /* Make this task sleep for 5 ticks*/
                        ucCountRetries++;
                    }
                }
                
                if (bFound == FALSE) {
                    /* Could not found the buffer with the id received in the ack packet*/
                    vFailFoundBufferRetransmission();
                }
                eReceiverAckState = sRAGettingACK;
				break;
			default:
				break;
		}
	}
}
