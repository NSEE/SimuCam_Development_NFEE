/*
 * communication_utils.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#include "communication_utils.h"





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
	char cLocalBuffer128[128];


	/* Copy cBuffer to avoid problems of reentrancy*/
	memcpy(cLocalBuffer128, cBuffer, 128);
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
					if ( ucReturnMutexRetrans != 0 ) { /* Returning zero = Mutex not available */
						/*	Best scenario, could get the mutex at the first try*/
						for(i = 0; i < N_128; i++)
						{
							if ( xBuffer128[i].usiId == 0 ) {
								/* Found a free place */
								bSuccess = TRUE;
								memcpy(xBuffer128[i].buffer, cLocalBuffer128, 128);
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
										memcpy(xBuffer128[i].buffer, cLocalBuffer128, 128);
										xBuffer128[i].usiId = siIdMessage;
										xBuffer128[i].ucNofRetries = N_RETRIES_COMM;
										xBuffer128[i].usiTimeOut = TIMEOUT_COUNT;
										break;
									}
								}
								OSMutexPost(xMutexBuffer128); /* Free the Mutex after use the xBuffer128*/
							}
						} while ((ucErrorCodeMutexRetrans!= OS_NO_ERR) || ( ucCountRetriesMutexRetrans < 4)); /* Try for 3 times*/
					}
				}
			} while ( (ucErrorCodeMutexTxUART!= OS_NO_ERR) || ( ucCountRetriesMutexTxUART < 4) ); /* Try for 3 times*/

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
	} while ( (ucErrorCodeSem != OS_NO_ERR) || ( ucCountRetriesSem < 6)) ; /* Try for 5 times*/

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


unsigned short int usiGetIdCMD ( void ) {
    if ( usiIdCMD > 65534 )
        usiIdCMD = 1;
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
