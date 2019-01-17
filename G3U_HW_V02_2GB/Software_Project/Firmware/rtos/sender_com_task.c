/*
 * sender_com.c
 *
 *  Created on: 11/12/2018
 *      Author: Tiago-Low
 */

#include "sender_com_task.h"

OS_STK_DATA data;

void vSenderComTask(void *task_data)
{
    tSenderStates eSenderMode;
    bool bSuccess;
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

                #ifdef DEBUG_ON
                    debug(fp,"Preparing the Start Sequence.\n");
                #endif

                /* id of the first message will be 1 */
                bSuccess = bSendStatusFirstTime(START_STATUS_SEQUENCE, 1);
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
                #ifdef DEBUG_ON
                    debug(fp,"sDummySender\n");

                    OSTaskStkChk( IN_ACK_TASK_PRIO , &data);
                    fprintf(fp, "In_ack  total=%4ld,  free=%4ld, used=%4ld.\n", data.OSFree + data.OSUsed, data.OSFree, data.OSUsed);

                    OSTaskStkChk( OUT_ACK_TASK_PRIO , &data);
                    fprintf(fp, "Out_ack  total=%4ld,  free=%4ld, used=%4ld.\n", data.OSFree + data.OSUsed, data.OSFree, data.OSUsed);

                    OSTaskStkChk( RECEIVER_TASK_PRIO , &data);
                    fprintf(fp, "Receiver  total=%4ld,  free=%4ld, used=%4ld.\n", data.OSFree + data.OSUsed, data.OSFree, data.OSUsed);

                    OSTaskStkChk( PARSER_TASK_PRIO , &data);
                    fprintf(fp, "Parser_comm  total=%4ld,  free=%4ld, used=%4ld.\n", data.OSFree + data.OSUsed, data.OSFree, data.OSUsed);                                                            
                #endif



                

				OSTimeDlyHMSM(0, 0, 0, 1); /*Sleeps for 3 second*/

                break;
            default:
#ifdef DEBUG_ON
	debug(fp,"sender default\n");
#endif
                break;
        }

    }


}