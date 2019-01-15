/*
 * sender_com.c
 *
 *  Created on: 11/12/2018
 *      Author: Tiago-Low
 */

#include "sender_com_task.h"


void vSenderComTask(void *task_data)
{
    tSenderStates eSenderMode;
    int desligarEm = 0;

    eSenderMode = sConfiguringSender;

    #ifdef DEBUG_ON
        debug(fp,"vSenderComTask, enter task.\n");
    #endif

    for (;;){
        
        switch (eSenderMode)
        {
            case sConfiguringSender:
                /* For future implementations. */
                eSenderMode = sStartingConnSender;
                break;
            case sStartingConnSender:

                /*  This semaphore will return a non-zero value if the NUC communicate with the MEB 
                    vReceiverComTask is responsible to send this semaphore.
                    OSSemAccept -> Non blocking Pend*/
                if ( OSSemAccept(xSemCommInit) ) {
                    eSenderMode = sDummySender;
                } else {
					#ifdef DEBUG_ON
						debug(fp,"Sending start sequence\n");
					#endif
                    /* Asking for NUC the status */
                    puts(START_STATUS_SEQUENCE);
                    OSTimeDlyHMSM(0, 0, 5, 0); /*Sleeps for 5 second*/
                }

                break;


            case sReadingQueue:

                //pPointer = OSQPend(xQSenderTask, 0, &error_code);

                

                break;
            case sDummySender:
                /* code */
                eSenderMode = sDummySender;


#ifdef DEBUG_ON
	debug(fp,"sDummySender\n");
#endif
				OSTimeDlyHMSM(0, 0, 10, 0); /*Sleeps for 3 second*/
                break;
            default:
#ifdef DEBUG_ON
	debug(fp,"sender default\n");
#endif
                break;
        }

    }




}
