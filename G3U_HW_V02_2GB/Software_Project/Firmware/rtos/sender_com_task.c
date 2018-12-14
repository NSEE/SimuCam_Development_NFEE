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
    int desligarEm = 0;

    eSenderMode = sConfiguringSender;
#ifdef DEBUG_ON
	debug(fp,"vSenderComTask\n");
#endif
    for (;;){
        
        switch (eSenderMode)
        {
            case sConfiguringSender:
                /* code */
                eSenderMode = sStartingConnSender;
#ifdef DEBUG_ON
	debug(fp,"sConfiguringSender\n");
#endif
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
                    OSTimeDlyHMSM(0, 0, 20, 0); /*Sleeps for 3 second*/
                }
#ifdef DEBUG_ON
	debug(fp,"sStartingConnSender\n");
#endif
                break;
            case sDummySender:
                /* code */
                eSenderMode = sDummySender;

                if (desligarEm <= 3) {
                    puts(TURNOFF_SEQUENCE);
                }
                desligarEm++;
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
