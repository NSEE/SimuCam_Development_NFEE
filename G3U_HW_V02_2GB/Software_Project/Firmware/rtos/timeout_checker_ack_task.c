/*
 * timeout_ack_task.c
 *
 *  Created on: 28/12/2018
 *      Author: Tiago-Low
 */

#include "timeout_checker_ack_task.h"


void vTimeoutCheckerTaskv2(void *task_data) {
	INT8U ucErrorCode = 0;

    #if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage )
        fprintf(fp,"vTimeoutCheckerTask, enter task.\n");
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
    ucHashVerification |= ( ( SemCount512 == N_512 ) << 3) | (( SemCount32 == N_32 ) << 2) | ( ( SemCount64 == N_64 ) << 1 ) | (( SemCount128 == N_128 ) << 0);

    /* Nothing in the (re)transmission buffer */
    if ( ucHashVerification == 0b00001111 )
        return;

    /* Try to get the Mutex of the UART */
	OSMutexPend(xTxUARTMutex, 0, &ucErrorCode); /* Blocking */
    if ( ucErrorCode != OS_NO_ERR ) {
        /* Should never get here, is a blocking operation */
		#if DEBUG_ON
    	if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
			fprintf(fp,"Should never get here. Trying to get xTxUARTMutex. (vCheck)\n");
		#endif
        return;
    }


    /* ---> At this point we have the Mutex of TX UART, let's try to get the mutex of all retransmission buffer. */


    /* There are any spot used in the xBuffer128? */
    if ( 0b00000001 != (0b00000001 & ucHashVerification ) )
        vCheckRetransmission128();
    else
    	memset( xInUseRetrans.b128 , FALSE , sizeof(xInUseRetrans.b128)); /* For consistency with SemCount128 */


        /* There are any spot used in the xBuffer64? */
    if ( 0b00000010 != (0b00000010 & ucHashVerification ) )
        vCheckRetransmission64();
    else
        memset( xInUseRetrans.b64 , FALSE , sizeof(xInUseRetrans.b64)); /* For consistency with SemCount64 */

    /* There are any spot used in the xBuffer32? */
    if ( 0b00000100 != (0b00000100 & ucHashVerification ) )
        vCheckRetransmission32();
    else
    	memset( xInUseRetrans.b32 , FALSE , sizeof(xInUseRetrans.b32)); /* For consistency with SemCount32 */


    /* There are any spot used in the xBuffer512? */
    if ( 0b000001000 != (0b00001000 & ucHashVerification ) )
        vCheckRetransmission512();
    else
    	memset( xInUseRetrans.b512 , FALSE , sizeof(xInUseRetrans.b512)); /* For consistency with SemCountb512 */



    OSMutexPost(xTxUARTMutex);

    return;
}

inline void vCheckRetransmission512( void ) {
    INT8U ucErrorCodeL = 0;
    unsigned char ucIL = 0;
    unsigned char ucRetMutex = 0;


    ucRetMutex = OSMutexAccept(xMutexBuffer128, &ucErrorCodeL); /* Just check the the mutex (non blocking) */
    if ( (ucErrorCodeL != OS_NO_ERR) || ( ucRetMutex == 0 ) ) {
        /* Could not get the Mutex at this time, not critical it will try again later */
    	OSMutexPost(xMutexBuffer128);
    	return;
    }


    /* ---> At this point we have access to the xBuffer128*/

    /* Search the one that if in use */
	for( ucIL = 0; ucIL < N_512; ucIL++) {
        /* Check if in use */
        if ( xInUseRetrans.b512[ucIL] == TRUE ) {

            if ( xBuffer512[ucIL].bSent == TRUE )
                if ( ++xBuffer512[ucIL].usiTimeOut > TIMEOUT_COUNT )
                	xBuffer512[ucIL].bSent = FALSE;

            if ( xBuffer512[ucIL].bSent == FALSE ) {
                puts(xBuffer512[ucIL].buffer);
                xBuffer512[ucIL].bSent = TRUE;
                xBuffer512[ucIL].usiTimeOut = 0;

                /* Check if already tried all the times */
                if ( ++xBuffer512[ucIL].ucNofRetries > N_RETRIES_COMM ) {
                    /* Now it is a Free place */
                    xInUseRetrans.b512[ucIL] = FALSE;
                    SemCount512++;
                    ucErrorCodeL = OSSemPost(xSemCountBuffer512);
                    if ( ucErrorCodeL != OS_ERR_NONE ) {
                    	SemCount512--;
                    	vFailSetCountSemaphorexBuffer512(); /*Could not send back the semaphore, this is critical.*/
                    }
                }
            }
        }
	}
    OSMutexPost(xMutexBuffer128);

    return;
}


inline void vCheckRetransmission128( void ) {
    INT8U ucErrorCodeL = 0;
    unsigned char ucIL = 0;
    unsigned char ucRetMutex = 0;


    ucRetMutex = OSMutexAccept(xMutexBuffer128, &ucErrorCodeL); /* Just check the the mutex (non blocking) */
    if ( (ucErrorCodeL != OS_NO_ERR) || ( ucRetMutex == 0 ) ) {
        /* Could not get the Mutex at this time, not critical it will try again later */
    	OSMutexPost(xMutexBuffer128);
    	return;
    }

    /* ---> At this point we have access to the xBuffer128*/

    /* Search the one that if in use */
	for( ucIL = 0; ucIL < N_128; ucIL++) {
        /* Check if in use */
        if ( xInUseRetrans.b128[ucIL] == TRUE ) {

            if ( xBuffer128[ucIL].bSent == TRUE )
                if ( ++xBuffer128[ucIL].usiTimeOut > TIMEOUT_COUNT )
                    xBuffer128[ucIL].bSent = FALSE;

            if ( xBuffer128[ucIL].bSent == FALSE ) {
                puts(xBuffer128[ucIL].buffer);
                xBuffer128[ucIL].bSent = TRUE;
                xBuffer128[ucIL].usiTimeOut = 0;

                /* Check if already tried all the times */
                if ( ++xBuffer128[ucIL].ucNofRetries > N_RETRIES_COMM ) {
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
    unsigned char ucRetMutex = 0;


    ucRetMutex = OSMutexAccept(xMutexBuffer64, &ucErrorCodeL); /* Just check the the mutex (non blocking) */
    if ( (ucErrorCodeL != OS_NO_ERR) || ( ucRetMutex == 0 ) ) {
        /* Could not get the Mutex at this time, not critical it will try again later */
    	OSMutexPost(xMutexBuffer64);
    	return;
    }

    /* ---> At this point we have access to the xBuffer64*/

    /* Search the one that if in use */
	for( ucIL = 0; ucIL < N_64; ucIL++) {
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
    unsigned char ucMax = 0;
    unsigned char ucRetMutex = 0;


    ucRetMutex = OSMutexAccept(xMutexBuffer32, &ucErrorCodeL); /* Just check the the mutex (non blocking) */
    if ( (ucErrorCodeL != OS_NO_ERR) || ( ucRetMutex == 0 ) ) {
        /* Could not get the Mutex at this time, not critical it will try again later */
    	OSMutexPost(xMutexBuffer32);
    	return;
    }

    /* ---> At this point we have access to the xBuffer32*/

    /* Search the one that if in use */
	for( ucIL = 0; ucIL < N_32; ucIL++) {
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

                ucMax = ( xBuffer32[ucIL].usiId == 1 ) ? N_RETRIES_INI_INF : N_RETRIES_COMM;

                if ( ++xBuffer32[ucIL].ucNofRetries > ucMax ) {
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
