/*
 * in_ack_handler_task.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */


#include "in_ack_handler_task.h"


void vInAckHandlerTaskV2(void *task_data) {

	bool bFound = FALSE;
    bool bFinished32 = FALSE;
    bool bFinished64 = FALSE;
    bool bFinished128 = FALSE;
    bool bFinished512 = FALSE;
	INT8U error_code;
	tReceiverACKState eReceiverAckState;
	static txReceivedACK xRAckLocal;
    unsigned char ucHashVerification = 0;
    unsigned char ucCountRetries = 0;
    unsigned char i = 0;

    #if DEBUG_ON
    if ( xDefaults.usiDebugLevel <= dlMajorMessage )
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
                    	OSSemPost(xSemCountReceivedACK);
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
                ucHashVerification |=  (( SemCount512 == N_512 ) << 3) | (( SemCount32 == N_32 ) << 2) | ( ( SemCount64 == N_64 ) << 1 ) | (( SemCount128 == N_128 ) << 0);

                bFound = FALSE;
                bFinished32=FALSE;
                bFinished64=FALSE;
                bFinished128=FALSE;
                bFinished512=FALSE;
                ucCountRetries = 0;
                do
                {
                    ucCountRetries++;

                    /* There are any spot used in the xBuffer128? */
                    if ( 0b00000001 != (0b00000001 & ucHashVerification ) )
                        bFound = bCheckInAck128( &xRAckLocal, &bFinished128  );
                    else
                        bFinished128 = TRUE;

                    /* There are any spot used in the xBuffer64? */
                    if ( (0b00000010 != (0b00000010 & ucHashVerification )) && (bFound ==FALSE ) )
                        bFound = bCheckInAck64( &xRAckLocal, &bFinished64 );
                    else
                        bFinished64 = TRUE;

                    /* There are any spot used in the xBuffer32? */
                    if ( (0b00000100 != (0b00000100 & ucHashVerification ) ) && (bFound ==FALSE ) )
                        bFound = bCheckInAck32( &xRAckLocal, &bFinished32  );
                    else
                        bFinished32 = TRUE;

                    /* There are any spot used in the xBuffer32? */
                    if ( (0b00001000 != (0b00001000 & ucHashVerification ) ) && (bFound ==FALSE ) )
                        bFound = bCheckInAck512( &xRAckLocal, &bFinished512  );
                    else
                        bFinished512 = TRUE;

                } while ( ((ucCountRetries++ < MAX_RETRIES_ACK_IN) && (bFound == FALSE) && ((bFinished32 == FALSE) | (bFinished64 == FALSE) | (bFinished128 == FALSE)| (bFinished512 == FALSE) )) );
                
                if (bFound == FALSE) {
                    /* Could not found the buffer with the id received in the ack packet*/
                    vFailFoundBufferRetransmission();
                }

                eReceiverAckState = sRAGettingACK;
				break;

			default:
                #if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly)
		            debug(fp,"Critical: Default State. Should never get here.(vInAckHandlerTaskV2)\n");
	            #endif
                eReceiverAckState = sRAGettingACK;
		}
	}
}


bool bCheckInAck512( txReceivedACK *xRecAckL , bool *bFinished ) {
	bool bFound = FALSE;
	INT8U error_code;
    unsigned char ucIL = 0;

    bFound = FALSE;
    *bFinished = FALSE;
//    OSMutexPend(xMutexBuffer128, 0, &error_code); /* Mas wait 1 tick = 1 ms */
//    if ( error_code != OS_NO_ERR )
//        return bFound;

    /* ---> At this point we have access to xBuffer128 */

    for(ucIL = 0; ucIL < N_512; ucIL++)
    {
        if ( xBuffer512[ucIL].usiId == xRecAckL->usiId ) {
            bFound = TRUE;
            /* Free the slot with the index ucIL */
            xInUseRetrans.b512[ucIL] = FALSE;
            SemCount512++;
            error_code = OSSemPost(xSemCountBuffer512);
            if ( error_code != OS_ERR_NONE ) {
                SemCount512--;
                vFailSetCountSemaphorexBuffer512();
            }
            break;
        }
    }
    //OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
    (*bFinished) = TRUE;

    return bFound;
}


bool bCheckInAck128( txReceivedACK *xRecAckL , bool *bFinished ) {
	bool bFound = FALSE;
	INT8U error_code;
    unsigned char ucIL = 0;

    bFound = FALSE;
    *bFinished = FALSE;
//    OSMutexPend(xMutexBuffer128, 0, &error_code); /* Mas wait 1 tick = 1 ms */
//    if ( error_code != OS_NO_ERR )
//        return bFound;

    /* ---> At this point we have access to xBuffer128 */

    for(ucIL = 0; ucIL < N_128; ucIL++)
    {
        if ( xBuffer128[ucIL].usiId == xRecAckL->usiId ) {
            bFound = TRUE;
            /* Free the slot with the index ucIL */
            xInUseRetrans.b128[ucIL] = FALSE;
            SemCount128++;
            error_code = OSSemPost(xSemCountBuffer128);
            if ( error_code != OS_ERR_NONE ) {
                SemCount128--;
                vFailSetCountSemaphorexBuffer128();
            }
            break;
        }
    }
    //OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
    (*bFinished) = TRUE;

    return bFound;
}


bool bCheckInAck64( txReceivedACK *xRecAckL , bool *bFinished ) {
	bool bFound = FALSE;
	INT8U error_code;
    unsigned char ucIL = 0;

    bFound = FALSE;
    *bFinished = FALSE;
//    OSMutexPend(xMutexBuffer64, 0, &error_code); /* Mas wait 1 tick = 1 ms */
//    if ( error_code != OS_NO_ERR )
//        return bFound;

    /* ---> At this point we have access to xBuffer128 */

    for(ucIL = 0; ucIL < N_64; ucIL++)
    {
        if ( xBuffer64[ucIL].usiId == xRecAckL->usiId ) {
            bFound = TRUE;
            /* Free the slot with the index ucIL */
            xInUseRetrans.b64[ucIL] = FALSE;
            SemCount64++;
            error_code = OSSemPost(xSemCountBuffer64);
            if ( error_code != OS_ERR_NONE ) {
                SemCount64--;
                vFailSetCountSemaphorexBuffer64();
            }
            break;
        }
    }
    //OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer128*/
    (*bFinished) = TRUE;

    return bFound;
}



bool bCheckInAck32( txReceivedACK *xRecAckL , bool *bFinished ) {
	bool bFound = FALSE;
	INT8U error_code;
    unsigned char ucIL = 0;

    bFound = FALSE;
    *bFinished = FALSE;
//    OSMutexPend(xMutexBuffer32, 0, &error_code); /* Mas wait 1 tick = 1 ms */
//    if ( error_code != OS_NO_ERR )
//        return bFound;

    /* ---> At this point we have access to xBuffer128 */

    for(ucIL = 0; ucIL < N_32; ucIL++)
    {
        if ( xBuffer32[ucIL].usiId == xRecAckL->usiId ) {
            bFound = TRUE;
            /* Free the slot with the index ucIL */
            xInUseRetrans.b32[ucIL] = FALSE;
            SemCount32++;
            error_code = OSSemPost(xSemCountBuffer32);
            if ( error_code != OS_ERR_NONE ) {
                SemCount32--;
                vFailSetCountSemaphorexBuffer32();
            }
            break;
        }
    }
    //OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xMutexBuffer32*/
    (*bFinished) = TRUE;

    return bFound;
}
