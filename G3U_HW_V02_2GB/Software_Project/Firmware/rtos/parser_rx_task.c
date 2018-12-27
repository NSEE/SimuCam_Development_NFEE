/*
 * parser_rx_task.c
 *
 *  Created on: 19/12/2018
 *      Author: Tiago-Low
 */


#include "parser_rx_task.h"


/* If any packet come arrive to this task, means that:
 * - Is a command (Reply or Request)
 * - The CRC is right
 * -  */
void vParserRXTask(void *task_data){

	bool bSuccess = FALSE;
	INT8U error_code;
	tParserStates eParserMode;
	static tPreParsed PreParsedLocal;

	#ifdef DEBUG_ON
		debug(fp,"vParserRXTask, enter task.\n");
	#endif

	eParserMode = sConfiguring;

	for(;;){

		switch (eParserMode) {
			case sConfiguring:
				/*For future implementations*/
				eParserMode = sWaitingConn;
				break;
			case sWaitingConn:

				bSuccess = FALSE;
				eParserMode = sWaitingConn;

				OSSemPend(xSemCountPreParsed, 0, &error_code); /*Blocking*/
				if ( error_code == OS_ERR_NONE ) {
					/* There's command waiting to be threat */

					/* Should post the semaphore to the Sender Task stop to send the Initialization message (Request Status) */
					error_code = OSSemPost(xSemCommInit);
                    if ( error_code == OS_ERR_NONE ) {

                    	bSuccess = getPreParsedPacket(&PreParsedLocal); /*Blocking*/
                    	if (bSuccess == TRUE) {
                    		/* PreParsed Content copied to the local variable */
                            if ( PreParsedLocal.cType == START_REPLY_CHAR )
                            	eParserMode = sReplyParsing;
                            else
                            	eParserMode = sRequestParsing;
                    	} else {
							/* Semaphore was post by some task but has no message in the PreParsedBuffer*/
							vNoContentInPreParsedBuffer();
						}
                    } else {
						/*  Could not post the semaphore that indicates that NUC is connected and send a message.
							this a very IMPORTANT signalization!*/
                    	bSuccess = bTrySendSemaphoreCommInit();
						if (bSuccess == TRUE) {
							vFailSendxSemCommInit();
						}
                    }
				} else {
					vFailGetCountSemaphorePreParsedBuffer();
				}

				break;
			case sWaitingMessage:

				bSuccess = FALSE;
				eParserMode = sWaitingMessage;

				OSSemPend(xSemCountPreParsed, 0, &error_code); /*Blocking*/
				if ( error_code == OS_ERR_NONE ) {
					/* There's command waiting to be threat */

					bSuccess = getPreParsedPacket(&PreParsedLocal); /*Blocking*/
					if (bSuccess == TRUE) {
						/* PreParsed Content copied to the local variable */
						if ( PreParsedLocal.cType == START_REPLY_CHAR )
							eParserMode = sReplyParsing;
						else
							eParserMode = sRequestParsing;
					} else {
						/* Semaphore was post by some task but has no message in the PreParsedBuffer*/
						vNoContentInPreParsedBuffer();
					}
 
				} else {
					vFailGetCountSemaphorePreParsedBuffer();
				}
				break;				
			case sRequestParsing:
				/* Final parssing after identify that is a request packet */
				/* ATTENTION: In order to avoid overhead of process the response to NUC of simple Requests 
				   will be threat here, and send from here the parser_rx.*/
			   	switch (PreParsedLocal.cType)
				{
					case ETH_CMD: /*NUC requested the ETH Configuration*/
							vSendEthConf();
							eParserMode = sWaitingMessage;
						break;
					default:
						eParserMode = sWaitingMessage;
						break;
				}
				break;
			case sReplyParsing:
                switch (PreParsedLocal.cType)
                {
                    case NUC_STATUS_CMD: /*Status from NUC*/

						eParserMode = sWaitingMessage;
                        break;
                    case POWER_OFF_CMD: /*Shut down command from SGSE*/

						eParserMode = sWaitingMessage;
                        break;
                    case PUS_CMD: /*PUS command to MEB*/

						eParserMode = sWaitingMessage;
                        break;
                    case HEART_BEAT_CMD: /*Heart beating (NUC are you there?)*/

						eParserMode = sWaitingMessage;
                        break;
                    default:
						eParserMode = sWaitingMessage;
                        break;
                }
				break;
            case sHandlingError:
                
                eReceiverMode = tErrorHandlerFunc (&PreParsedLocal);
                break;				
			default:
				break;
		}
	}
}

bool getPreParsedPacket( tPreParsed *xPreParsedParser ) {
    bool bSuccess = FALSE;
    INT8U error_code;

	OSMutexPend(xMutexPreParsed, 0, &error_code); /*Blocking*/
	if (error_code == OS_ERR_NONE) {
		/* Got the Mutex */
		/*For now, will only get the first, not the packet that is waiting for longer time*/
		for(unsigned char i = 0; i < N_PREPARSED_ENTRIES; i++)
		{
            if ( xPreParsed[i].cType != 0 ) {
                /* Locate a filled PreParsed variable in the array*/
            	/* Perform a copy to a local variable */
            	(*xPreParsedParser) = xPreParsed[i];
                bSuccess = TRUE;
                xPreParsed[i].cType = 0;
                break;
            }
		}
		OSMutexPost(xMutexPreParsed);
	} else {
		/* Couldn't get Mutex. (Should not get here since is a blocking call without timeout)*/
		vFailGetxMutexPreParsedParserRxTask();
	}
	return bSuccess;
}

boolean bTrySendSemaphoreCommInit( void ) {
	unsigned char ucCountRetries = 0;
	bool bSuccess = FALSE;

	#ifdef DEBUG_ON
		debug(fp,"Can't post semaphore to SenderTask. Trying more 10 times.\n");
	#endif

	ucCountRetries = 0;
	do
	{
		ucCountRetries++;
		OSTimeDly(50); /* 50 ticks -> 50 ms -> context switch */
		error_code = OSSemPost(xSemCommInit);
	} while ((error_code != OS_ERR_NONE) && (ucCountRetries < 11));

	if ( error_code == OS_ERR_NONE ) {
		bSuccess = TRUE;
	}

	return bSuccess;
}

