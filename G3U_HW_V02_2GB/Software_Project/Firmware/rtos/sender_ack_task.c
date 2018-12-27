/*
 * sender_ack_task.c
 *
 *  Created on: 26/12/2018
 *      Author: Tiago-Low
 */


#include "sender_ack_task.h"


void vSenderAckTask(void *task_data) {

	bool bSuccess = FALSE;
	INT8U error_code;
	tSerderACKState eSenderAckState;
	static txSenderACKs xSAckLocal;
    char cBufferAck[16] = "";
    unsigned char ucCountRetries = 0;
    unsigned char crc = 0;    

	#ifdef DEBUG_ON
		debug(fp,"vSenderAckTask, enter task.\n");
	#endif

	eSenderAckState = sSAConfiguring;

	for(;;){

		switch (eSenderAckState) {
			case sSAConfiguring:
                /*For future implementations*/
                eSenderAckState = sSAGettingACK;
				break;
            case sSAGettingACK:
                /* Waits the semaphore that indicates there are some ack message to send*/
                OSSemPend(xSemCountSenderACK, 0, &error_code);
                if ( error_code == OS_ERR_NONE ) {

                    OSMutexPend(xMutexSenderACK, 0, &error_code);
                    if ( error_code == OS_ERR_NONE ) {
                        /*Search for the ack*/
                        for(unsigned char i = 0; i < N_ACKS_SENDER; i++)
                        {
                            if ( xSenderACK[i].cType != 0 ) {
                                /* Locate the message, copy for the local variable in order to free the mutex. */
                                xSAckLocal = xSenderACK[i];
                                eSenderAckState = sSASending;
                                xSenderACK[i].cType = 0; /* indicates that this position now can be used by other message*/
                                break;
                            }
                        }                        
                        OSMutexPost(xMutexSenderACK);
                    } else {
                        /*  Should never get here, will wait without timeout for the semaphore.
                            But if some error accours we will do nothing but print in the console */
                        vFailGetMutexSenderTask();
                    }                    
                    
                } else {
                    /*  Should never get here, will wait without timeout for the semaphore.
                        But if some error accours we will do nothing but print in the console */
                    vFailGetCountSemaphoreSenderTask();
                }
                break;
			case sSASending:
                /* In this state has a parsed ack packet in the variable xSAckLocal
                   we just need to calc the crc8 and create the uart packet to send. */
                sprintf(cBufferAck, ACK_SPRINTF, xSAckLocal.cCommand, xSAckLocal.usiId);
                crc = ucCrc8wInit( cBufferAck , strlen(cBufferAck));
                sprintf(cBufferAck, "%s|%hhu;", cBufferAck, crc);

                bSuccees = FALSE;
                while ( ( bSuccees == FALSE ) && ( ucCountRetries < 6 ) ) {

                    OSMutexPend(xTxUARTMutex, 5, &error_code); /* Wait 5 ticks = 5 ms */

                    if ( error_code == OS_NO_ERR ) {
                        puts(cBufferAck);
                        OSMutexPost(xTxUARTMutex);  
                        bSuccess = TRUE;
                    }
                    ucCountRetries++;
                } 

                if (bSuccees == FALSE) {
                    /* Could not use the uart tx buffer to send the ack*/
                    vFailGetMutexTxUARTSenderTask();
                }
                eSenderAckState = sSAGettingACK;
				break;
			default:
				break;
		}
	}
}