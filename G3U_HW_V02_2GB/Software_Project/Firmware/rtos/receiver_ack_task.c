/*
 * receiver_ack_task.c
 *
 *  Created on: 26/12/2018
 *      Author: Tiago-Low
 */


#include "receiver_ack_task.h"

void vReceiverAckTask(void *task_data) {

	bool bFound = FALSE;
    bool bFinished32 = FALSE;
    bool bFinished64 = FALSE;
    bool bFinished128 = FALSE;
	INT8U error_code;
    INT8U ucReturnMutex;
	tReceiverACKState eReceiverAckState;
	static txReceivedACK xRAckLocal;
    char cBufferAck[16] = "";
    unsigned char ucCountRetries = 0;
    unsigned char crc = 0; 
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
                                /* Locate the message, copy for the local variable in order to free the mutex. */
                                xRAckLocal = xReceivedACK[i];
                                eReceiverAckState = sRACleanningBuffer;
                                xReceivedACK[i].cType = 0; /* indicates that this position now can be used by other message*/
                                break;
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
                /* The mutex will not be blocking, so it will try for five times search in the three (re)transmission buffer */
                while ( ( bFound == FALSE ) && ( ucCountRetries < 6 ) && ( (bFinished32==FALSE) || (bFinished64==FALSE) ||(bFinished128==FALSE) ) ) {

                    if ( (bFound == FALSE) && (bFinished32 == FALSE) ) {
                        /* Search in three (re)transmission buffer for the id*/
                        ucReturnMutex = OSMutexAccept(xMutexBuffer32, &error_code); /* Just check the the mutex (non blocking) */
                        if ( ucReturnMutex != 0 ) { /* Returning zero = Mutex not available */
                            /*Search for the id*/
                            for(i = 0; i < N_32; i++)
                            {
                                if ( xBuffer32[i].usiId == xRAckLocal.usiId ) {
                                    /* Free the buffer and indicate by setting usiId to Zero. Post in the count semaphore to indicate
                                    that is an free position in the (re)trasmission buffer. */
                                    xBuffer32[i].usiId = 0;
                                    memset(xBuffer32[i].buffer, 0, 32);
                                    OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer32*/
                                    
                                    bFound = TRUE;
                                    error_code = OSSemPost(xSemCountBuffer32);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer32();
                                    }
                                    break;
                                }
                            }
                            bFinished32 = TRUE;
                        }
                    }


                    if ( (bFound == FALSE) && (bFinished64 == FALSE) ) {
                        /* Search in three (re)transmission buffer for the id*/
                        ucReturnMutex = OSMutexAccept(xMutexBuffer64, &error_code); /* Just check the the mutex (non blocking) */
                        if ( ucReturnMutex != 0 ) { /* Returning zero = Mutex not available */
                            /*Search for the id*/
                            for(i = 0; i < N_64; i++)
                            {
                                if ( xBuffer64[i].usiId == xRAckLocal.usiId ) {
                                    /* Free the buffer and indicate by setting usiId to Zero. Post in the count semaphore to indicate
                                    that is an free position in the (re)trasmission buffer. */
                                    xBuffer64[i].usiId = 0;
                                    memset(xBuffer64[i].buffer, 0, 64);
                                    OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer64*/
                                    
                                    bFound = TRUE;
                                    error_code = OSSemPost(xSemCountBuffer64);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer64();
                                    }
                                    break;
                                }
                            }
                            bFinished64 = TRUE;
                        }
                    }

                    if ( (bFound == FALSE) && (bFinished128 == FALSE) ) {
                        /* Search in three (re)transmission buffer for the id*/
                        ucReturnMutex = OSMutexAccept(xMutexBuffer128, &error_code); /* Just check the the mutex (non blocking) */
                        if ( ucReturnMutex != 0 ) { /* Returning zero = Mutex not available */
                            /*Search for the id*/
                            for(i = 0; i < N_128; i++)
                            {
                                if ( xBuffer128[i].usiId == xRAckLocal.usiId ) {
                                    /* Free the buffer and indicate by setting usiId to Zero. Post in the count semaphore to indicate
                                    that is an free position in the (re)trasmission buffer. */
                                    xBuffer128[i].usiId = 0;
                                    memset(xBuffer128[i].buffer, 0, 128);
                                    OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
                                    
                                    bFound = TRUE;
                                    error_code = OSSemPost(xSemCountBuffer128);
                                    if ( error_code != OS_ERR_NONE ) {
                                        vFailSetCountSemaphorexBuffer128();
                                    }
                                    break;
                                }
                            }
                            bFinished128 = TRUE;
                        }
                    }
                    ucCountRetries++;
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