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

    }

}



















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
                eReceiverAckState = sRAGettingACK;
                /* Waits the semaphore that indicates there are some ack message was received*/
                OSSemPend(xSemCountReceivedACK, 0, &error_code);
                if ( error_code == OS_ERR_NONE ) {

                    OSMutexPend(xMutexReceivedACK, 0, &error_code);
                    if ( error_code == OS_ERR_NONE ) {

                        /*Search for the ack*/
                        for(i = 0; i < N_ACKS_RECEIVED; i++)
                        {
                            if ( xReceivedACK[i].cType != 0 ) {

                                /*  Nack don't get here */
                                xRAckLocal = xReceivedACK[i];
                                xReceivedACK[i].cType = 0; /* indicates that this position now can be used by other message*/
                                eReceiverAckState = sRACleanningBuffer;
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
                        OSTimeDly(3); /* Make this task sleep for 3 ticks*/
                        ucCountRetries++;
                        #ifdef DEBUG_ON
                            /* Debug:remove */
                            debug(fp, "Temp. Debug: Retrying again. ucCountRetries++; \n");
                            fprintf( fp, " bFound = %d , bFinished32 = %d , bFinished64 = %d , bFinished128 = %d  \n", bFound, bFinished32, bFinished64, bFinished128 );
                        #endif                      
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



void vInAckHandlerTaskV2(void *task_data) {

	bool bFound = FALSE;
    bool bFinished32 = FALSE;
    bool bFinished64 = FALSE;
    bool bFinished128 = FALSE;
	INT8U error_code;
    INT8U ucReturnMutex;
	tReceiverACKState eReceiverAckState;
	static txReceivedACK xRAckLocal;
    unsigned char ucHashVerification = 0;
    unsigned char ucCountRetries = 0;
    unsigned char i = 0;

    #ifdef DEBUG_ON
        debug(fp,"In Ack Handler Task. (Task on)\n");
    #endif    

	eReceiverAckState = sRAConfiguring;

	for(;;){

		switch (eReceiverAckState) {
			case sRAConfiguring:
                /*For future implementations*/
                eReceiverAckState = sRAGettingACK;
				break;
            case sRAGettingACK:
                eReceiverAckState = sRAGettingACK;
                /* Waits the semaphore that indicates there are some ack message was received*/
                OSSemPend(xSemCountReceivedACK, 0, &error_code);
                if ( error_code == OS_ERR_NONE ) {

                    OSMutexPend(xMutexReceivedACK, 0, &error_code);
                    if ( error_code == OS_ERR_NONE ) {

                        /*Search for the ack*/
                        for(i = 0; i < N_ACKS_RECEIVED; i++)
                        {
                            if ( xReceivedACK[i].cType != 0 ) {

                                /*  Nack don't get here */
                                xRAckLocal = xReceivedACK[i];
                                xReceivedACK[i].cType = 0; /* indicates that this position now can be used by other message*/
                                eReceiverAckState = sRACleanningBuffer;
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
                
                ucHashVerification = 0;
                ucHashVerification |= (( SemCount32 == N_32 ) << 2) | ( ( SemCount64 == N_64 ) << 1 ) | (( SemCount128 == N_128 ) << 0);

                bFound = FALSE;
                bFinished32=FALSE;
                bFinished64=FALSE;
                bFinished128=FALSE;
                ucCountRetries = 0;
                do
                {
                    ucCountRetries++;

                    /* There are any spot used in the xBuffer128? */
                    if ( 0b00000001 == (0b00000001 & ucHashVerification ) )
                        bFound = bCheckInAck128( &xRAckLocal, &bFinished128  );
                    else
                        bFinished128 = TRUE;

                    /* There are any spot used in the xBuffer64? */
                    if ( 0b00000010 == (0b00000010 & ucHashVerification ) )
                        bFound = bCheckInAck64( &xRAckLocal, &bFinished64 );]
                    else
                        bFinished64 = TRUE;

                    /* There are any spot used in the xBuffer32? */
                    if ( 0b00000100 == (0b00000100 & ucHashVerification ) )
                        bFound = bCheckInAck32( &xRAckLocal, &bFinished32  );
                    else
                        bFinished32 = TRUE;

                } while ( ((ucCountRetries++ < MAX_RETRIES_ACK_IN) && (bFound == FALSE) && ((bFinished32 == FALSE) | (bFinished64 == FALSE) | (bFinished128 == FALSE))) );
                
                if (bFound == FALSE) {
                    /* Could not found the buffer with the id received in the ack packet*/
                    vFailFoundBufferRetransmission();
                }

                eReceiverAckState = sRAGettingACK;
				break;
			default:
                #ifdef DEBUG_ON
		            debug(fp,"Critical: Default State. Should never get here.(vInAckHandlerTaskV2)\n");
	            #endif
                eReceiverAckState = sRAGettingACK;
				break;
		}
	}
}


bool bCheckInAck128( txReceivedACK *xRecAckL , bool *bFinished ) {
	bool bFound = FALSE;
	INT8U error_code;
    unsigned char ucIL = 0;

    bFound = FALSE;
    OSSemPend(xMutexBuffer128, 1, &error_code); /* Mas wait 1 tick = 1 ms */
    if ( error_code != OS_NO_ERR )
        return bFound;

    /* ---> At this point we have access to xBuffer128 */

    for(ucIL = 0; ucIL < N_128; ucIL++)
    {
        if ( xBuffer128[ucIL].usiId == xRecAckL.usiId ) {
            bFound = TRUE;
            /* Free the slot with the index ucIL */
            xInUseRetrans.b128[ucIL] = FALSE;
            SemCount128++;
            error_code = OSSemPost(xSemCountBuffer128);
            if ( error_code != OS_ERR_NONE ) {
                SemCount128--;
                vFailSetCountSemaphorexBuffer128();
            }
            break            
        }
    }
    OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
    (*bFinished) = TRUE;

    return bFound;
}


bool bCheckInAck64( txReceivedACK *xRecAckL , bool *bFinished ) {
	bool bFound = FALSE;
	INT8U error_code;
    unsigned char ucIL = 0;

    bFound = FALSE;
    OSSemPend(xMutexBuffer64, 1, &error_code); /* Mas wait 1 tick = 1 ms */
    if ( error_code != OS_NO_ERR )
        return bFound;

    /* ---> At this point we have access to xBuffer128 */

    for(ucIL = 0; ucIL < N_64; ucIL++)
    {
        if ( xBuffer64[ucIL].usiId == xRecAckL.usiId ) {
            bFound = TRUE;
            /* Free the slot with the index ucIL */
            xInUseRetrans.b64[ucIL] = FALSE;
            SemCount64++;
            error_code = OSSemPost(xSemCountBuffer64);
            if ( error_code != OS_ERR_NONE ) {
                SemCount64--;
                vFailSetCountSemaphorexBuffer64();
            }
            break            
        }
    }
    OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer128*/
    (*bFinished) = TRUE;

    return bFound;
}



bool bCheckInAck32( txReceivedACK *xRecAckL , bool *bFinished ) {
	bool bFound = FALSE;
	INT8U error_code;
    unsigned char ucIL = 0;

    bFound = FALSE;
    OSSemPend(xMutexBuffer32, 1, &error_code); /* Mas wait 1 tick = 1 ms */
    if ( error_code != OS_NO_ERR )
        return bFound;

    /* ---> At this point we have access to xBuffer128 */

    for(ucIL = 0; ucIL < N_32; ucIL++)
    {
        if ( xBuffer32[ucIL].usiId == xRecAckL.usiId ) {
            bFound = TRUE;
            /* Free the slot with the index ucIL */
            xInUseRetrans.b32[ucIL] = FALSE;
            SemCount32++;
            error_code = OSSemPost(xSemCountBuffer32);
            if ( error_code != OS_ERR_NONE ) {
                SemCount32--;
                vFailSetCountSemaphorexBuffer32();
            }
            break            
        }
    }
    OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer128*/
    (*bFinished) = TRUE;

    return bFound;
}
