/*
 * sender_com.c
 *
 *  Created on: 11/12/2018
 *      Author: Tiago-Low
 */

#include "sender_com_task.h"


void vSenderComTask(void *task_data)
{
    bool bSucess = FALSE;
    tSenderStates eSenderMode;

    eSenderMode = sConfiguringSender;

    for (;;){
        
        switch (eSenderMode)
        {
            case sConfiguringSender:
                /* code */
                eSenderMode = sStartingConnSender;
                break;
            case sStartingConnSender:
                /* code */

                /*  This semaphore will return a non-zero value if the NUC communicate with the MEB 
                    vReceiverComTask is responsible to send this semaphore.
                    OSSemAccept -> Non blocking Pend*/
                if ( OSSemAccept(xSemCommInit) ) {
                    eSenderMode = sDummySender;
                } else {
                    /* Asking for NUC the status */
                    puts(START_STATUS_SEQUENCE);
                    OSTimeDlyHMSM(0, 0, 3, 0); /*Sleeps for 3 second*/
                }

                break;
            case sDummySender:
                /* code */
                eSenderMode = sDummySender;
                break;
            default:
                break;
        }

    }




}
