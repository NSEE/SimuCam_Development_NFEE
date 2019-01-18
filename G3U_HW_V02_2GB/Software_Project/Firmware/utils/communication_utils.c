/*
 * communication_utils.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#include "communication_utils.h"


/* Make sure that there is only 127 characters to send */
/* Always, ALWAYS send only an char[128] that you first did a memset(cBuffer,0,128), before put some string on it. */
bool bSendUART128v2 ( char *cBuffer, short int siIdMessage ) {
	INT8U ucErrorCode = 0;;
	INT8U ucRetries = 0;
	unsigned char ucIL = 0;
	bool bSuccessL = FALSE;
	

	bSuccessL = FALSE;
	ucRetries = 0;
	do
	{
		ucRetries++;
		OSSemPend(xSemCountBuffer128, TICKS_WAITING_FOR_SPACE, &ucErrorCode);
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_SEM_FOR_SPACE ) );

	/* Check if gets The semaphore, if yes means that are some space in the (re)transmission buffer */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* No space in the transmission buffer */
		vFailGetCountSemaphorexBuffer128(); /*Could not send back the semaphore, this is critical.*/
		return bSuccessL;
	}


	/* ---> At this point we know that there is some space in the buffer */


	/* Need to get the Mutex that protects xBuffer128 */
	ucRetries = 0;
	do
	{
		ucRetries++;
		OSMutexPend(xMutexBuffer128, TICKS_WAITING_MUTEX_RETRANS, &ucErrorCode); /* Wait X ticks = X ms */
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_MUTEX_RETRANS ) );	

	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex, so we need to give the semaphore back */
		#ifdef DEBUG_ON
			debug(fp,"Could not get the mutex xMutexBuffer128 that protect xBuffer128. (bSendUART128v2)\n");
		#endif
		error_code = OSSemPost(xSemCountBuffer128);
		if ( error_code != OS_ERR_NONE ) {
			vFailSetCountSemaphorexBuffer128(); /*Could not send back the semaphore, this is critical.*/
		}

		return bSuccessL;
	}
	

	/* ---> At this point we Have the mutex of the xBuffer128, and we can use it freely */


	bSuccess = TRUE;
	/* Search for space */
	for( ucIL = 0; ucIL < N_128; ucIL++)
	{
		if ( xInUseRetrans.b128[ucIL] == FALSE ) {
			/* Clear the buffer */
			memset(xBuffer128[ucIL].buffer, 0, 128);
			/* Making sure that will have some \0 */
			memcpy(xBuffer128[ucIL].buffer, cBuffer, 127);
			xBuffer128[ucIL].usiId = siIdMessage;
			xBuffer128[ucIL].ucNofRetries = 0;
			xBuffer128[ucIL].usiTimeOut = 0;
			xBuffer128[ucIL].bSent = FALSE;
			xInUseRetrans.b128[ucIL] = TRUE;
			break;
		}
	}
	SemCount128--; /* Sure that you get the semaphore */


	/* ---> Now try to get the Mutex that protects the TX of the UART to transmit the message */


	ucRetries = 0;
	do
	{
		ucRetries++;
		OSMutexPend(xTxUARTMutex, TICKS_WAITING_MUTEX_TX, &ucErrorCode); /* Wait X ticks = X ms */
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_MUTEX_TX ) );	

	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex of TX */
		/* That's ok, as the message was already put in the retransmission buffer it will be sent by the checker timeout task */
		#ifdef DEBUG_ON
			debug(fp,"Could not get the mutex xTxUARTMutex, but the message is already in the retransmission buffer. (bSendUART128v2)\n");
		#endif
		/* Indicates that this buffer already has a message that should be sent by the retransmission immediately */
		/* Free the Mutex of the xBuffer128 */
		OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
		return bSuccessL;
	}


	/* ---> At this point we have all resources to send the message */


	puts(xBuffer128[ucIL].buffer);
	xBuffer128[ucIL].bSent = TRUE;


	/* ---> Best scenario, giving the mutexes back in the inverse order to avoid deadlock */

	OSMutexPost(xTxUARTMutex);
	OSMutexPost(xMutexBuffer128);

	return bSuccessL;
}






/* Make sure that there is only 63 characters to send */
/* Always, ALWAYS send only an char[64] that you first did a memset(cBuffer,0,64), before put some string on it. */
bool bSendUART64v2 ( char *cBuffer, short int siIdMessage ) {
	INT8U ucErrorCode = 0;
	INT8U ucRetries = 0;
	unsigned char ucIL = 0;
	bool bSuccessL = FALSE;
	

	bSuccessL = FALSE;
	ucRetries = 0;
	do
	{
		ucRetries++;
		OSSemPend(xSemCountBuffer64, TICKS_WAITING_FOR_SPACE, &ucErrorCode);
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_SEM_FOR_SPACE ) );

	/* Check if gets The semaphore, if yes means that are some space in the (re)transmission buffer */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* No space in the transmission buffer */
		vFailGetCountSemaphorexBuffer64(); /*Could not send back the semaphore, this is critical.*/
		return bSuccessL;
	}


	/* ---> At this point we know that there is some space in the buffer */

	
	
	/* Need to get the Mutex that protects xBuffer64 */
	ucRetries = 0;
	do
	{
		ucRetries++;
		OSMutexPend(xMutexBuffer64, TICKS_WAITING_MUTEX_RETRANS, &ucErrorCode); /* Wait X ticks = X ms */
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_MUTEX_RETRANS ) );	

	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex, so we need to give the semaphore back */
		#ifdef DEBUG_ON
			debug(fp,"Could not get the mutex xMutexBuffer64 that protect xBuffer64. (bSendUART64v2)\n");
		#endif
		error_code = OSSemPost(xSemCountBuffer64);
		if ( error_code != OS_ERR_NONE ) {
			vFailSetCountSemaphorexBuffer64(); /*Could not send back the semaphore, this is critical.*/
		}

		return bSuccessL;
	}
	

	/* ---> At this point we Have the mutex of the xBuffer64, and we can use it freely */

	bSuccess = TRUE;
	for( ucIL = 0; ucIL < N_64; ucIL++)
	{
		if ( xInUseRetrans.b64[ucIL] == FALSE ) {
			/* Clear the buffer */
			memset(xBuffer64[ucIL].buffer, 0, 64);
			/* Making sure that will have some \0 */
			memcpy(xBuffer64[ucIL].buffer, cBuffer, 63);
			xBuffer64[ucIL].usiId = siIdMessage;
			xBuffer64[ucIL].ucNofRetries = 0;
			xBuffer64[ucIL].usiTimeOut = 0;
			xBuffer64[ucIL].bSent = FALSE;
			xInUseRetrans.b64[ucIL] = TRUE;
			break;
		}
	}
	SemCount64--; /* Sure that you get the semaphore */


	/* ---> Now try to get the Mutex that protects the TX of the UART to transmit the message */


	ucRetries = 0;
	do
	{
		ucRetries++;
		OSMutexPend(xTxUARTMutex, TICKS_WAITING_MUTEX_TX, &ucErrorCode); /* Wait X ticks = X ms */
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_MUTEX_TX ) );	

	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex of TX */
		/* That's ok, as the message was already put in the retransmission buffer it will be sent by the checker timeout task */
		#ifdef DEBUG_ON
			debug(fp,"Could not get the mutex xTxUARTMutex, but the message is already in the retransmission buffer. (bSendUART64v2)\n");
		#endif
		/* Indicates that this buffer already has a message that should be sent by the retransmission immediately */
		/* Free the Mutex of the xBuffer64 */
		OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer64 */
		return bSuccessL;
	}


	/* ---> At this point we have all resources to send the message */


	puts(xBuffer64[ucIL].buffer);
	xBuffer64[ucIL].bSent = TRUE;


	/* ---> Best scenario, giving the mutexes back in the inverse order to avoid deadlock */

	OSMutexPost(xTxUARTMutex);
	OSMutexPost(xMutexBuffer64);

	return bSuccessL;
}






/* Make sure that there is only 31 characters to send */
/* Always, ALWAYS send only an char[32] that you first did a memset(cBuffer,0,32), before put some string on it. */
bool bSendUART32v2 ( char *cBuffer, short int siIdMessage ) {
	INT8U ucErrorCode = 0;
	INT8U ucRetries = 0;
	unsigned char ucIL = 0;
	bool bSuccessL = FALSE;
	

	bSuccessL = FALSE;
	ucRetries = 0;
	do
	{
		ucRetries++;
		OSSemPend(xSemCountBuffer32, TICKS_WAITING_FOR_SPACE, &ucErrorCode);
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_SEM_FOR_SPACE ) );

	/* Check if gets The semaphore, if yes means that are some space in the (re)transmission buffer */
	if ( ucErrorCode != OS_NO_ERR ) {
		/* No space in the transmission buffer */
		vFailGetCountSemaphorexBuffer32(); /*Could not send back the semaphore, this is critical.*/
		return bSuccessL;
	}


	/* ---> At this point we know that there is some space in the buffer */


	/* Need to get the Mutex that protects xBuffer32 */
	ucRetries = 0;
	do
	{
		ucRetries++;
		OSMutexPend(xMutexBuffer32, TICKS_WAITING_MUTEX_RETRANS, &ucErrorCode); /* Wait X ticks = X ms */
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_MUTEX_RETRANS ) );	

	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex, so we need to give the semaphore back */
		#ifdef DEBUG_ON
			debug(fp,"Could not get the mutex xMutexBuffer32 that protect xBuffer64. (bSendUART32v2)\n");
		#endif
		error_code = OSSemPost(xSemCountBuffer32);
		if ( error_code != OS_ERR_NONE ) {
			vFailSetCountSemaphorexBuffer32(); /*Could not send back the semaphore, this is critical.*/
		}

		return bSuccessL;
	}
	

	/* ---> At this point we Have the mutex of the xBuffer64, and we can use it freely */


	bSuccess = TRUE;
	for( ucIL = 0; ucIL < N_32; ucIL++)
	{
		if ( xInUseRetrans.b32[ucIL] == FALSE ) {
			/* Clear the buffer */
			memset(xBuffer32[ucIL].buffer, 0, 32);
			/* Making sure that will have some \0 */
			memcpy(xBuffer32[ucIL].buffer, cBuffer, 31);
			xBuffer32[ucIL].usiId = siIdMessage;
			xBuffer32[ucIL].ucNofRetries = 0;
			xBuffer32[ucIL].usiTimeOut = 0;
			xBuffer32[ucIL].bSent = FALSE;
			xInUseRetrans.b32[ucIL] = TRUE;
			break;
		}
	}	
	SemCount32--; /* Sure that you get the semaphore */


	/* ---> Now try to get the Mutex that protects the TX of the UART to transmit the message */


	ucRetries = 0;
	do
	{
		ucRetries++;
		OSMutexPend(xTxUARTMutex, TICKS_WAITING_MUTEX_TX, &ucErrorCode); /* Wait X ticks = X ms */
	/* When get semaphore or retrie N Times */
	} while ( (ucErrorCode != OS_NO_ERR) && ( ucRetries++ < N_RET_MUTEX_TX ) );	

	if ( ucErrorCode != OS_NO_ERR ) {
		/* Could not get the mutex of TX */
		/* That's ok, as the message was already put in the retransmission buffer it will be sent by the checker timeout task */
		#ifdef DEBUG_ON
			debug(fp,"Could not get the mutex xTxUARTMutex, but the message is already in the retransmission buffer. (bSendUART32v2)\n");
		#endif
		/* Indicates that this buffer already has a message that should be sent by the retransmission immediately */
		/* Free the Mutex of the xBuffer64 */
		OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer64 */
		return bSuccessL;
	}


	/* ---> At this point we have all resources to send the message */

	puts(xBuffer32[ucIL].buffer);
	xBuffer32[ucIL].bSent = TRUE;

	/* ---> Best scenario, giving the mutexes back in the inverse order to avoid deadlock */

	OSMutexPost(xTxUARTMutex);
	OSMutexPost(xMutexBuffer32);

	return bSuccessL;
}















































/*Critical function: In the worst case it makes the task sleep for 425 miliseconds due to retries */
bool bSendUART128 ( char *cBuffer, short int siIdMessage ) {
    INT8U ucErrorCodeSem;
	INT8U ucErrorCodeMutexRetrans;
	INT8U ucErrorCodeMutexTxUART;
	INT8U error_code;
	INT8U ucReturnMutexRetrans;
    unsigned char ucCountRetriesSem = 0;
	unsigned char ucCountRetriesMutexRetrans = 0;
	unsigned char ucCountRetriesMutexTxUART = 0;
	unsigned char i = 0;
	bool bSuccess = FALSE;
	char cLocalBuffer128[128] = "";


	/* Copy cBuffer to avoid problems of reentrancy*/
	memcpy(cLocalBuffer128, cBuffer, 127);
	bSuccess = FALSE;
	/* Do while for try to get semaphore of the (re)transmission 'big' buffer (128) */
	ucCountRetriesSem = 0;
	do
	{
		ucCountRetriesSem++;
		/* This semaphore tells if there's space available in the "big" buffer */
		OSSemPend(xSemCountBuffer128, TICKS_WAITING_FOR_SPACE, &ucErrorCodeSem);
		if ( ucErrorCodeSem == OS_NO_ERR ) {
			/* There is space on the 'big' buffer of (re)transmission, but first try to transmit the packet
			   only after successful then put in the retransmission buffer. Otherwise there is chance to fill the (re)transmission
			   buffer and don't send the message.*/
			ucCountRetriesMutexTxUART = 0;
			do
			{
				ucCountRetriesMutexTxUART++;
				/*This mutex protect the txUART buffer*/
				OSMutexPend(xTxUARTMutex, 5, &ucErrorCodeMutexTxUART); /* Wait 5 ticks = 5 ms */
				if ( ucErrorCodeMutexTxUART == OS_NO_ERR ) {
					/* 	Transmit the message to the NUC*/
					/* 	Trying the best scenario that is also get the mutex of the (re)transmission buffer
					   	if couldn't get, send the message any way as fast as possible to post the tx UART mutex
					   	and as soon as possible try to get the mutex of (re)transmission buffer.*/
					puts(cLocalBuffer128);
					/*OSMutexAccept => non blocking*/
					ucReturnMutexRetrans = OSMutexAccept(xMutexBuffer128, &ucErrorCodeMutexRetrans); /* Just check the the mutex (non blocking) */
					if ( ucErrorCodeMutexRetrans == OS_NO_ERR ) { 
						/*	Best scenario, could get the mutex at the first try*/
						for(i = 0; i < N_128; i++)
						{
							if ( xBuffer128[i].usiId == 0 ) {
								/* Found a free place */
								bSuccess = TRUE;
								memset(xBuffer128[i].buffer, 0, 128);
								memcpy(xBuffer128[i].buffer, cLocalBuffer128, 127);
								xBuffer128[i].usiId = siIdMessage;
								xBuffer128[i].ucNofRetries = N_RETRIES_COMM;
								xBuffer128[i].usiTimeOut = TIMEOUT_COUNT;
								break;
							}
						}

						OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
					}
					OSMutexPost(xTxUARTMutex);

					/*  The message was send for sure, but there no garantee that the message was copied to the (re)transmission buffer
						need check if bsuccess is true. */
					if ( bSuccess != TRUE ) {
						/* If not ok, try to get the mutex for 3 times */
						ucCountRetriesMutexRetrans = 0;
						do
						{
							ucCountRetriesMutexRetrans++;
							/*OSMutexPend => Blocking*/
							OSMutexPend(xMutexBuffer128, 5, &ucErrorCodeMutexRetrans); /*5 ticks = 5 miliseconds */
							if ( ucErrorCodeMutexRetrans == OS_NO_ERR ) {
								/* Got access to (re)transmission buffer */
								for(i = 0; i < N_128; i++)
								{
									if ( xBuffer128[i].usiId == 0 ) {
										/* Found a free place */
										bSuccess = TRUE;
										memset(xBuffer128[i].buffer, 0, 128);
										memcpy(xBuffer128[i].buffer, cLocalBuffer128, 127);										
										xBuffer128[i].usiId = siIdMessage;
										xBuffer128[i].ucNofRetries = N_RETRIES_COMM;
										xBuffer128[i].usiTimeOut = TIMEOUT_COUNT;
										break;
									}
								}
								OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
							}
						} while ((ucErrorCodeMutexRetrans!= OS_NO_ERR) && ( ucCountRetriesMutexRetrans < 4)); /* Try for 3 times*/
					}
				}
			} while ( (ucErrorCodeMutexTxUART!= OS_NO_ERR) && ( ucCountRetriesMutexTxUART < 4) ); /* Try for 3 times*/

			/* If was not possible to send the message or to copy the message to the (re)transmisison buffer*/
			if (bSuccess!=TRUE) {
				/*	Got the semaphore but could not send te message or write in the (re)transmisison buffer,
					so give the semaphore back in order to indicate that the position of the (re)transmission buffer
					was not consumed. Another task could try to use it.*/
				error_code = OSSemPost(xSemCountBuffer128);
				if ( error_code != OS_ERR_NONE ) {
					vFailSetCountSemaphorexBuffer128(); /*Could not send back the semaphore, this is critical.*/
				}
			}
		}
	} while ( (ucErrorCodeSem != OS_NO_ERR) && ( ucCountRetriesSem < 6)) ; /* Try for 5 times*/

	return bSuccess;
}



/*Critical function: In the worst case it makes the task sleep for 425 miliseconds due to retries */
bool bSendUART64 ( char *cBuffer, short int siIdMessage ) {
    INT8U ucErrorCodeSem;
	INT8U ucErrorCodeMutexRetrans;
	INT8U ucErrorCodeMutexTxUART;
	INT8U error_code;
	INT8U ucReturnMutexRetrans;
    unsigned char ucCountRetriesSem = 0;
	unsigned char ucCountRetriesMutexRetrans = 0;
	unsigned char ucCountRetriesMutexTxUART = 0;
	unsigned char i = 0;
	bool bSuccess = FALSE;
	char cLocalBuffer64[64];


	/* Copy cBuffer to avoid problems of reentrancy*/
	memcpy(cLocalBuffer64, cBuffer, strlen(cBuffer));
	bSuccess = FALSE;
	/* Do while for try to get semaphore of the (re)transmission 'big' buffer (128) */
	ucCountRetriesSem = 0;
	do
	{
		ucCountRetriesSem++;
		/* This semaphore tells if there's space available in the "big" buffer */
		OSSemPend(xSemCountBuffer64, TICKS_WAITING_FOR_SPACE, &ucErrorCodeSem);
		if ( ucErrorCodeSem == OS_NO_ERR ) {
			/* There is space on the 'big' buffer of (re)transmission, but first try to transmit the packet
			   only after successful then put in the retransmission buffer. Otherwise there is chance to fill the (re)transmission
			   buffer and don't send the message.*/
			ucCountRetriesMutexTxUART = 0;
			do
			{
				ucCountRetriesMutexTxUART++;
				/*This mutex protect the txUART buffer*/
				OSMutexPend(xTxUARTMutex, 5, &ucErrorCodeMutexTxUART); /* Wait 5 ticks = 5 ms */
				if ( ucErrorCodeMutexTxUART == OS_NO_ERR ) {
					/* 	Transmit the message to the NUC*/
					/* 	Trying the best scenario that is also get the mutex of the (re)transmission buffer
					   	if couldn't get, send the message any way as fast as possible to post the tx UART mutex
					   	and as soon as possible try to get the mutex of (re)transmission buffer.*/
					puts(cLocalBuffer64);
					/*OSMutexAccept => non blocking*/
					ucReturnMutexRetrans = OSMutexAccept(xMutexBuffer64, &ucErrorCodeMutexRetrans); /* Just check the the mutex (non blocking) */
					if ( ucErrorCodeMutexRetrans == OS_NO_ERR ) { 
						/*	Best scenario, could get the mutex at the first try*/
						for(i = 0; i < N_64; i++)
						{
							if ( xBuffer64[i].usiId == 0 ) {
								/* Found a free place */
								bSuccess = TRUE;
								memcpy(xBuffer64[i].buffer, cLocalBuffer64, 64);
								xBuffer64[i].usiId = siIdMessage;
								xBuffer64[i].ucNofRetries = N_RETRIES_COMM;
								xBuffer64[i].usiTimeOut = TIMEOUT_COUNT;
								break;
							}
						}

						OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer128*/
					}
					OSMutexPost(xTxUARTMutex);

					/*  The message was send for sure, but there no garantee that the message was copied to the (re)transmission buffer
						need check if bsuccess is true. */
					if ( bSuccess != TRUE ) {
						/* If not ok, try to get the mutex for 3 times */
						ucCountRetriesMutexRetrans = 0;
						do
						{
							ucCountRetriesMutexRetrans++;
							/*OSMutexPend => Blocking*/
							OSMutexPend(xMutexBuffer64, 5, &ucErrorCodeMutexRetrans); /*5 ticks = 5 miliseconds */
							if ( ucErrorCodeMutexRetrans == OS_NO_ERR ) {
								/* Got access to (re)transmission buffer */
								for(i = 0; i < N_64; i++)
								{
									if ( xBuffer64[i].usiId == 0 ) {
										/* Found a free place */
										bSuccess = TRUE;
										memcpy(xBuffer64[i].buffer, cLocalBuffer64, 64);
										xBuffer64[i].usiId = siIdMessage;
										xBuffer64[i].ucNofRetries = N_RETRIES_COMM;
										xBuffer64[i].usiTimeOut = TIMEOUT_COUNT;
										break;
									}
								}
								OSMutexPost(xMutexBuffer64); /* Free the Mutex after use the xBuffer64*/
							}
						} while ((ucErrorCodeMutexRetrans!= OS_NO_ERR) && ( ucCountRetriesMutexRetrans < 4)); /* Try for 3 times*/
					}
				}
			} while ( (ucErrorCodeMutexTxUART!= OS_NO_ERR) && ( ucCountRetriesMutexTxUART < 4) ); /* Try for 3 times*/

			/* If was not possible to send the message or to copy the message to the (re)transmisison buffer*/
			if (bSuccess!=TRUE) {
				/*	Got the semaphore but could not send te message or write in the (re)transmisison buffer,
					so give the semaphore back in order to indicate that the position of the (re)transmission buffer
					was not consumed. Another task could try to use it.*/
				error_code = OSSemPost(xSemCountBuffer64);
				if ( error_code != OS_ERR_NONE ) {
					vFailSetCountSemaphorexBuffer64(); /*Could not send back the semaphore, this is critical.*/
				}
			}
		}
	} while ( (ucErrorCodeSem != OS_NO_ERR) && ( ucCountRetriesSem < 6)) ; /* Try for 5 times*/

	return bSuccess;
}

/*Critical function: In the worst case it makes the task sleep for 425 miliseconds due to retries */
bool bSendUART32 ( char *cBuffer, short int siIdMessage ) {
    INT8U ucErrorCodeSem;
	INT8U ucErrorCodeMutexRetrans;
	INT8U ucErrorCodeMutexTxUART;
	INT8U error_code;
	INT8U ucReturnMutexRetrans;
    unsigned char ucCountRetriesSem = 0;
	unsigned char ucCountRetriesMutexRetrans = 0;
	unsigned char ucCountRetriesMutexTxUART = 0;
	unsigned char i = 0;
	bool bSuccess = FALSE;
	char cLocalBuffer32[32];


	/* Copy cBuffer to avoid problems of reentrancy*/
	memcpy(cLocalBuffer32, cBuffer, strlen(cBuffer));
	bSuccess = FALSE;
	/* Do while for try to get semaphore of the (re)transmission 'big' buffer (128) */
	ucCountRetriesSem = 0;
	do
	{
		ucCountRetriesSem++;
		/* This semaphore tells if there's space available in the "big" buffer */
		OSSemPend(xSemCountBuffer32, TICKS_WAITING_FOR_SPACE, &ucErrorCodeSem);
		if ( ucErrorCodeSem == OS_NO_ERR ) {
			/* There is space on the 'big' buffer of (re)transmission, but first try to transmit the packet
			   only after successful then put in the retransmission buffer. Otherwise there is chance to fill the (re)transmission
			   buffer and don't send the message.*/
			ucCountRetriesMutexTxUART = 0;
			do
			{
				ucCountRetriesMutexTxUART++;
				/*This mutex protect the txUART buffer*/
				OSMutexPend(xTxUARTMutex, 5, &ucErrorCodeMutexTxUART); /* Wait 5 ticks = 5 ms */
				if ( ucErrorCodeMutexTxUART == OS_NO_ERR ) {
					/* 	Transmit the message to the NUC*/
					/* 	Trying the best scenario that is also get the mutex of the (re)transmission buffer
					   	if couldn't get, send the message any way as fast as possible to post the tx UART mutex
					   	and as soon as possible try to get the mutex of (re)transmission buffer.*/
					puts(cLocalBuffer32);
					/*OSMutexAccept => non blocking*/
					ucReturnMutexRetrans = OSMutexAccept(xMutexBuffer32, &ucErrorCodeMutexRetrans); /* Just check the the mutex (non blocking) */
					if ( ucErrorCodeMutexRetrans == OS_NO_ERR ) { 
						/*	Best scenario, could get the mutex at the first try*/
						for(i = 0; i < N_32; i++)
						{
							if ( xBuffer32[i].usiId == 0 ) {
								/* Found a free place */
								bSuccess = TRUE;
								memcpy(xBuffer32[i].buffer, cLocalBuffer32, 32);
								xBuffer32[i].usiId = siIdMessage;
								xBuffer32[i].ucNofRetries = N_RETRIES_COMM;
								xBuffer32[i].usiTimeOut = TIMEOUT_COUNT;
								break;
							}
						}

						OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer32*/
					}
					OSMutexPost(xTxUARTMutex);

					/*  The message was send for sure, but there no garantee that the message was copied to the (re)transmission buffer
						need check if bsuccess is true. */
					if ( bSuccess != TRUE ) {
						/* If not ok, try to get the mutex for 3 times */
						ucCountRetriesMutexRetrans = 0;
						do
						{
							ucCountRetriesMutexRetrans++;
							/*OSMutexPend => Blocking*/
							OSMutexPend(xMutexBuffer32, 5, &ucErrorCodeMutexRetrans); /*5 ticks = 5 miliseconds */
							if ( ucErrorCodeMutexRetrans == OS_NO_ERR ) {
								/* Got access to (re)transmission buffer */
								for(i = 0; i < N_32; i++)
								{
									if ( xBuffer32[i].usiId == 0 ) {
										/* Found a free place */
										bSuccess = TRUE;
										memcpy(xBuffer32[i].buffer, cLocalBuffer32, 32);
										xBuffer32[i].usiId = siIdMessage;
										xBuffer32[i].ucNofRetries = N_RETRIES_COMM;
										xBuffer32[i].usiTimeOut = TIMEOUT_COUNT;
										break;
									}
								}
								OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer32*/
							}
						} while ((ucErrorCodeMutexRetrans!= OS_NO_ERR) && ( ucCountRetriesMutexRetrans < 4)); /* Try for 3 times*/
					}
				}
			} while ( (ucErrorCodeMutexTxUART!= OS_NO_ERR) && ( ucCountRetriesMutexTxUART < 4) ); /* Try for 3 times*/

			/* If was not possible to send the message or to copy the message to the (re)transmisison buffer*/
			if (bSuccess!=TRUE) {
				/*	Got the semaphore but could not send te message or write in the (re)transmisison buffer,
					so give the semaphore back in order to indicate that the position of the (re)transmission buffer
					was not consumed. Another task could try to use it.*/
				error_code = OSSemPost(xSemCountBuffer32);
				if ( error_code != OS_ERR_NONE ) {
					vFailSetCountSemaphorexBuffer64(); /*Could not send back the semaphore, this is critical.*/
				}
			}
		}
	} while ( (ucErrorCodeSem != OS_NO_ERR) && ( ucCountRetriesSem < 6)) ; /* Try for 5 times*/

	return bSuccess;
}

/*Critical function: In the worst case it makes the task sleep for 425 miliseconds due to retries */
bool bSendStatusFirstTime ( char *cBuffer, short int siIdMessage ) {
    INT8U ucErrorCodeSem;
	INT8U ucErrorCodeMutexRetrans;
	INT8U ucErrorCodeMutexTxUART;
	INT8U error_code;
	INT8U ucReturnMutexRetrans;
    unsigned char ucCountRetriesSem = 0;
	unsigned char ucCountRetriesMutexRetrans = 0;
	unsigned char ucCountRetriesMutexTxUART = 0;
	unsigned char i = 0;
	bool bSuccess = FALSE;
	char cLocalBuffer32[32];


	/* Copy cBuffer to avoid problems of reentrancy*/
	memcpy(cLocalBuffer32, cBuffer, strlen(cBuffer));
	bSuccess = FALSE;
	/* Do while for try to get semaphore of the (re)transmission 'big' buffer (128) */
	ucCountRetriesSem = 0;
	do
	{
		ucCountRetriesSem++;
		/* This semaphore tells if there's space available in the "big" buffer */
		OSSemPend(xSemCountBuffer32, TICKS_WAITING_FOR_SPACE, &ucErrorCodeSem);
		if ( ucErrorCodeSem == OS_NO_ERR ) {
			/* There is space on the 'big' buffer of (re)transmission, but first try to transmit the packet
			   only after successful then put in the retransmission buffer. Otherwise there is chance to fill the (re)transmission
			   buffer and don't send the message.*/
			ucCountRetriesMutexTxUART = 0;
			do
			{
				ucCountRetriesMutexTxUART++;
				/*This mutex protect the txUART buffer*/
				OSMutexPend(xTxUARTMutex, 5, &ucErrorCodeMutexTxUART); /* Wait 5 ticks = 5 ms */
				if ( ucErrorCodeMutexTxUART == OS_NO_ERR ) {
					/* 	Transmit the message to the NUC*/
					/* 	Trying the best scenario that is also get the mutex of the (re)transmission buffer
					   	if couldn't get, send the message any way as fast as possible to post the tx UART mutex
					   	and as soon as possible try to get the mutex of (re)transmission buffer.*/
					puts(cLocalBuffer32);
					/*OSMutexAccept => non blocking*/
					ucReturnMutexRetrans = OSMutexAccept(xMutexBuffer32, &ucErrorCodeMutexRetrans); /* Just check the the mutex (non blocking) */
					if ( ucErrorCodeMutexRetrans == OS_NO_ERR ) { 
						/*	Best scenario, could get the mutex at the first try*/
						for(i = 0; i < N_32; i++)
						{
							if ( xBuffer32[i].usiId == 0 ) {
								/* Found a free place */
								bSuccess = TRUE;
								memcpy(xBuffer32[i].buffer, cLocalBuffer32, 32);
								xBuffer32[i].usiId = siIdMessage;
								xBuffer32[i].ucNofRetries = N_RETRIES_INI_INF;
								xBuffer32[i].usiTimeOut = TIMEOUT_COUNT;
								break;
							}
						}

						OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer32*/
					}
					OSMutexPost(xTxUARTMutex);

					/*  The message was send for sure, but there no garantee that the message was copied to the (re)transmission buffer
						need check if bsuccess is true. */
					if ( bSuccess != TRUE ) {
						/* If not ok, try to get the mutex for 3 times */
						ucCountRetriesMutexRetrans = 0;
						do
						{
							ucCountRetriesMutexRetrans++;
							/*OSMutexPend => Blocking*/
							OSMutexPend(xMutexBuffer32, 5, &ucErrorCodeMutexRetrans); /*5 ticks = 5 miliseconds */
							if ( ucErrorCodeMutexRetrans == OS_NO_ERR ) {
								/* Got access to (re)transmission buffer */
								for(i = 0; i < N_32; i++)
								{
									if ( xBuffer32[i].usiId == 0 ) {
										/* Found a free place */
										bSuccess = TRUE;
										memcpy(xBuffer32[i].buffer, cLocalBuffer32, 32);
										xBuffer32[i].usiId = siIdMessage;
										xBuffer32[i].ucNofRetries = N_RETRIES_INI_INF;
										xBuffer32[i].usiTimeOut = TIMEOUT_COUNT;
										break;
									}
								}
								OSMutexPost(xMutexBuffer32); /* Free the Mutex after use the xBuffer32*/
							}
						} while ((ucErrorCodeMutexRetrans!= OS_NO_ERR) && ( ucCountRetriesMutexRetrans < 4)); /* Try for 3 times*/
					}
				}
			} while ( (ucErrorCodeMutexTxUART!= OS_NO_ERR) && ( ucCountRetriesMutexTxUART < 4) ); /* Try for 3 times*/

			/* If was not possible to send the message or to copy the message to the (re)transmisison buffer*/
			if (bSuccess!=TRUE) {
				/*	Got the semaphore but could not send te message or write in the (re)transmisison buffer,
					so give the semaphore back in order to indicate that the position of the (re)transmission buffer
					was not consumed. Another task could try to use it.*/
				error_code = OSSemPost(xSemCountBuffer32);
				if ( error_code != OS_ERR_NONE ) {
					vFailSetCountSemaphorexBuffer64(); /*Could not send back the semaphore, this is critical.*/
				}
			}
		}
	} while ( (ucErrorCodeSem != OS_NO_ERR) && ( ucCountRetriesSem < 6)) ; /* Try for 5 times*/

	return bSuccess;
}



void vSendEthConf ( void ) {
    char cBufferETH[128] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

    usiIdCMDLocal = usiGetIdCMD();

    sprintf(cBufferETH, ETH_SPRINTF, ETH_CMD, usiIdCMDLocal, xConfEth.bDHCP,
                        xConfEth.ucIP[0], xConfEth.ucIP[1], xConfEth.ucIP[2], xConfEth.ucIP[3],
                        xConfEth.ucSubNet[0], xConfEth.ucSubNet[1], xConfEth.ucSubNet[2], xConfEth.ucSubNet[3],
                        xConfEth.ucGTW[0], xConfEth.ucGTW[1], xConfEth.ucGTW[2], xConfEth.ucGTW[3],
                        xConfEth.ucDNS[0], xConfEth.ucDNS[1], xConfEth.ucDNS[2], xConfEth.ucDNS[3],
                        xConfEth.siPortPUS);
    crc = ucCrc8wInit( cBufferETH , strlen(cBufferETH));
    sprintf(cBufferETH, "%s|%hhu;", cBufferETH, crc );

	bSuccees = bSendUART128(cBufferETH, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendEthConfUART();
	}
}

void vSendTurnOff ( void ) {
    char cBufferTurnOff[32] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

    usiIdCMDLocal = usiGetIdCMD();

	/* Creating the packet with the CRC */
    sprintf(cBufferTurnOff, TURNOFF_SPRINTF, usiIdCMDLocal);
    crc = ucCrc8wInit( cBufferTurnOff , strlen(cBufferTurnOff));
    sprintf(cBufferTurnOff, "%s|%hhu;", cBufferTurnOff, crc );

	bSuccees = bSendUART32(cBufferTurnOff, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendTurnOff();
	}
}

void vSendLog ( const char * cDataIn ) {
    char cBufferLog[128] = "";
    unsigned char crc = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

    usiIdCMDLocal = usiGetIdCMD();

	/* Creating the packet with the CRC */
    sprintf(cBufferLog, LOG_SPRINTF, usiIdCMDLocal, cDataIn);
    crc = ucCrc8wInit( cBufferLog , strlen(cBufferLog));
    sprintf(cBufferLog, "%s|%hhu;", cBufferLog, crc );

	bSuccees = bSendUART128(cBufferLog, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendLog();
	}
}

unsigned short int usiGetIdCMD ( void ) {
    if ( usiIdCMD > 65534 )
        usiIdCMD = 2;
    else
        usiIdCMD++;
    return usiIdCMD;
}

inline short int siPosStr( char *buffer, char cValue) {
    char cTempChar[2] = "";
    cTempChar[0] = cValue; /* This step was add for performance. The command strcspn needs "" (const char *) */
    return strcspn(buffer, cTempChar);
}


void vTimeoutCheck (void *p_arg)
{
	INT8U error_code;

	/* Time to check the (re)transmission buffers, posting a semaphore to sync the task that will threat timeout logic (vTimeoutCheckerTask) */
	error_code = OSSemPost(xSemTimeoutChecker);
	if ( error_code != OS_ERR_NONE ) {
		vFailPostBlockingSemTimeoutTask();
	}
}

/* Send through a medium buffer */
void vSendPusTM64 ( tTMPus xPcktPus ) {
    char cBufferPus[64] = "";
    unsigned char crc = 0;
	unsigned char ucIL = 0;
    unsigned short int  usiIdCMDLocal;
	bool bSuccees = FALSE;

    usiIdCMDLocal = usiGetIdCMD();

	/* Start with the beginning of the PUS header values */
	sprintf(cBufferPus, PUS_TM_SPRINTF, usiIdCMDLocal, xPcktPus.usiPid, xPcktPus.usiCat, xPcktPus.usiType, xPcktPus.usiSubType, xPcktPus.usiPusId );
	/* Add how many parameters need to send in the command */
	for(ucIL = 0; ucIL < xPcktPus.ucNofValues; ucIL++)
	{
		sprintf(cBufferPus, PUS_ADDER_SPRINTF, cBufferPus, xPcktPus.usiValues[ucIL] );
	}
	/* Calculate the crc, append it and finish the string with ";" character */
    crc = ucCrc8wInit( cBufferPus , strlen(cBufferPus));
    sprintf(cBufferPus, "%s|%hhu;", cBufferPus, crc );

	bSuccees = bSendUART64(cBufferPus, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendTMPusCommand( cBufferPus );
	}
}

/* Send through a big buffer */
void vSendPusTM128 ( tTMPus xPcktPus ) {
    char cBufferPus[128] = "";
    unsigned char crc = 0;
	unsigned char ucIL = 0;
    unsigned short int usiIdCMDLocal;
	bool bSuccees = FALSE;

    usiIdCMDLocal = usiGetIdCMD();

	/* Start with the beginning of the PUS header values */
	sprintf(cBufferPus, PUS_TM_SPRINTF, usiIdCMDLocal, xPcktPus.usiPid, xPcktPus.usiCat, xPcktPus.usiType, xPcktPus.usiSubType, xPcktPus.usiPusId );
	/* Add how many parameters need to send in the command */
	for(ucIL = 0; ucIL < xPcktPus.ucNofValues; ucIL++)
	{
		sprintf(cBufferPus, PUS_ADDER_SPRINTF, cBufferPus, xPcktPus.usiValues[ucIL] );
	}
	/* Calculate the crc, append it and finish the string with ";" character */
    crc = ucCrc8wInit( cBufferPus , strlen(cBufferPus));
    sprintf(cBufferPus, "%s|%hhu;", cBufferPus, crc );

	bSuccees = bSendUART128(cBufferPus, usiIdCMDLocal);

	if ( bSuccees != TRUE ) {
		/*	Message wasn't send or could not insert in the (re)transmission buffer
			this will not be returned, because the system should keep working, an error function shoudl be called
			in order to print a message in the console, and maybe further implementation in the future*/
			vCouldNotSendTMPusCommand( cBufferPus );
	}
}



/* TM_SCAM_TEST_CONNECTION */
/* 
hp-pck-type		hp-pid		hp-pcat		hp-srv-type		hp-srv-subtype
0				64			0			17				2
*/
void vTMPusTestConnection( unsigned short int usiPusId ) {
	tTMPus xTmPusL;

	/* For now is hardcoded after full release of the pus I will create defines */
	xTmPusL.usiPusId = usiPusId;
	xTmPusL.usiPid = 64;
	xTmPusL.usiCat = 0;
	xTmPusL.usiType = 17;
	xTmPusL.usiSubType = 2;

	vSendPusTM64( xTmPusL );
}
