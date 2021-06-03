/*
 * out_ack_handler_task.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#include "out_ack_handler_task.h"


void vOutAckHandlerTask(void *task_data) {
	INT8U error_code;
	tSerderACKState eSenderAckState;
	static txSenderACKs xSAckLocal;
    char cBufferAck[16] = "";
    unsigned char crc = 0;

	#if DEBUG_ON
    if ( xDefaults.ucDebugLevel <= dlMajorMessage )
		fprintf(fp,"Out Ack Handler Task. (Task on)\n");
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
                eSenderAckState = sSAGettingACK;
                OSSemPend(xSemCountSenderACK, 0, &error_code);
                if ( error_code == OS_ERR_NONE ) {

                    OSMutexPend(xMutexSenderACK, 0, &error_code);
                    if ( error_code == OS_ERR_NONE ) {
                        /*Search for the ack*/
                        for(unsigned char i = 0; i < N_ACKS_SENDER; i++)
                            if ( xSenderACK[i].cType != 0 ) {
                                /* Locate the message, copy for the local variable in order to free the mutex. */
                                xSAckLocal = xSenderACK[i];
                                eSenderAckState = sSASending;
                                xSenderACK[i].cType = 0; /* indicates that this position now can be used by other message*/
                                break;
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
                /* First check if is an NACK packet that should be sent */
                if ( xSAckLocal.cType != '#' ) {
                    /* In this state has a parsed ack packet in the variable xSAckLocal
                    we just need to calc the crc8 and create the uart packet to send. */
                    sprintf(cBufferAck, ACK_SPRINTF, xSAckLocal.cCommand, xSAckLocal.usiId);
                    crc = ucCrc8wInit( cBufferAck , strlen(cBufferAck));
                    sprintf(cBufferAck, "%s|%hhu;", cBufferAck, crc);
                } else {
                    /* Nack */
                    sprintf(cBufferAck, "%s", NACK_SEQUENCE);
                }

                OSMutexPend(xTxUARTMutex, 100, &error_code); /* Wait max 100 ticks = 100 ms */
                if ( error_code == OS_NO_ERR ) {
                    puts(cBufferAck);
                    OSMutexPost(xTxUARTMutex);
                } else
                    vFailGetMutexTxUARTSenderTask(); /* Could not use the uart tx buffer to send the ack*/

                eSenderAckState = sSAGettingACK;
				break;

			default:
            	#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
		            fprintf(fp,"Critical: Default State. Should never get here.(vOutAckHandlerTask)\n");
	            #endif
                eSenderAckState = sSAGettingACK;
				}
		}
	}
}
