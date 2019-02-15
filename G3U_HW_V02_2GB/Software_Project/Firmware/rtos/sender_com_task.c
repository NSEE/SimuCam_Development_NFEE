/*
 * sender_com.c
 *
 *  Created on: 11/12/2018
 *      Author: Tiago-Low
 */

#include "sender_com_task.h"


OS_STK_DATA *pdata;

void vSenderComTask(void *task_data)
{
    tSenderStates eSenderMode;
    bool bSuccess;

    eSenderMode = sConfiguringSender;

    #if DEBUG_ON
    if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
        debug(fp,"Sender Comm Task. (Task on)\n");
    }
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

                #if DEBUG_ON
            	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
                    debug(fp,"Preparing the Start Sequence.\n");
            	}
                #endif

                /* id of the first message will be 1 */
                bSuccess = bSendUART32v2(START_STATUS_SEQUENCE, 1);
                if ( bSuccess == TRUE ) {
                    eSenderMode = sDummySender;
                    #if DEBUG_ON
                    if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
                        debug(fp,"Success, start message in the retransmission buffer.\n");
                    }
                    #endif                    
                } else {
                    #if DEBUG_ON
                	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
                        debug(fp,"Fail, try again in 5 seconds.\n");
                	}
                    #endif 
                    eSenderMode = sStartingConnSender;
                    OSTimeDlyHMSM(0, 0, 5, 0); /*Sleeps for 5 second*/
                }
                break;


            case sReadingQueue:

                break;
            case sDummySender:
                /* code */
                eSenderMode = sDummySender;

                #if DEBUG_ON
                if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
                    debug(fp,"Working...\n");
                }
                #endif

				OSTimeDlyHMSM(0, 0, 25, 0); /*Sleeps for 3 second*/

                break;
            default:
                #if DEBUG_ON
            	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
                    debug(fp,"Sender default\n");
            	}
                #endif
                eSenderMode = sDummySender;
                break;
        }

    }


}
