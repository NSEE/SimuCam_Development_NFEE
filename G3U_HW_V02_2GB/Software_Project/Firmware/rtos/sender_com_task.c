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
    OS_STK_DATA data;
    bool bSuccess;
    int desligarEm = 0;

    eSenderMode = sConfiguringSender;

    #ifdef DEBUG_ON
        debug(fp,"Sender Comm Task. (Task on)\n");
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

                #ifdef DEBUG_ON
                    debug(fp,"Preparing the Start Sequence.\n");
                #endif

                /* id of the first message will be 1 */
                bSuccess = bSendUART32v2(START_STATUS_SEQUENCE, 1);
                if ( bSuccess == TRUE ) {
                    eSenderMode = sDummySender;
                    #ifdef DEBUG_ON
                        debug(fp,"Success, start message in the retransmission buffer.\n");
                    #endif                    
                } else {
                    #ifdef DEBUG_ON
                        debug(fp,"Fail, try again in 5 seconds.\n");
                    #endif 
                    eSenderMode = sStartingConnSender;
                    OSTimeDlyHMSM(0, 0, 5, 0); /*Sleeps for 5 second*/
                }
                break;


            case sReadingQueue:

                //pPointer = OSQPend(xQSenderTask, 0, &error_code);

                

                break;
            case sDummySender:
                /* code */
                eSenderMode = sDummySender;
                /*
                #ifdef DEBUG_ON
                    debug(fp,"sDummySender\n");

                    OSTaskStkChk( IN_ACK_TASK_PRIO , &data);
                    fprintf(fp, "In_ack  total=%4ld,  free=%4ld, used=%4ld.\n", data.OSFree + data.OSUsed, data.OSFree, data.OSUsed);

                    OSTaskStkChk( OUT_ACK_TASK_PRIO , pdata);
                    fprintf(fp, "Out_ack  total=%4ld,  free=%4ld, used=%4ld.\n", pdata->OSFree + pdata->OSUsed, pdata->OSFree, pdata->OSUsed);

                    OSTaskStkChk( RECEIVER_TASK_PRIO , pdata);
                    fprintf(fp, "Receiver  total=%4ld,  free=%4ld, used=%4ld.\n", pdata->OSFree + pdata->OSUsed, pdata->OSFree, pdata->OSUsed);

                    OSTaskStkChk( PARSER_TASK_PRIO , pdata);
                    fprintf(fp, "Parser_comm  total=%4ld,  free=%4ld, used=%4ld.\n",  pdata->OSFree + pdata->OSUsed, pdata->OSFree, pdata->OSUsed);

                    OSTaskStkChk( TIMEOUT_CHECKER_PRIO , pdata);
                    fprintf(fp, "Timeoutchecker  total=%4ld,  free=%4ld, used=%4ld.\n",  pdata->OSFree + pdata->OSUsed, pdata->OSFree, pdata->OSUsed);

                    OSTaskStkChk( SENDER_TASK_PRIO , pdata);
                    fprintf(fp, "Sender  total=%4ld,  free=%4ld, used=%4ld.\n",  pdata->OSFree + pdata->OSUsed, pdata->OSFree, pdata->OSUsed);

                #endif
                */

                #ifdef DEBUG_ON
                    debug(fp,"sDummySender\n");
                #endif

				OSTimeDlyHMSM(0, 0, 5, 0); /*Sleeps for 3 second*/

                break;
            default:
                #ifdef DEBUG_ON
                    debug(fp,"Sender default\n");
                #endif
                eSenderMode = sDummySender;
                break;
        }

    }


}
