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
    INT8U error_code;
    tTMPusChar_Sender cTMPusOrChar;
    tTMPus cTMPusL;
    char bufferL[128];


    eSenderMode = sConfiguringSender;

    #if DEBUG_ON
    if ( xDefaults.usiDebugLevel <= dlMajorMessage )
        fprintf(fp,"Sender Comm Task. (Task on)\n");
    #endif

    for (;;){
        
        switch (eSenderMode) {
            case sConfiguringSender:
                /* For future implementations. */
                eSenderMode = sStartingConnSender;
                break;

            case sStartingConnSender:
                /*  This semaphore will return a non-zero value if the NUC communicate with the MEB 
                    vReceiverComTask is responsible to send this semaphore.
                    OSSemAccept -> Non blocking Pend*/
                #if DEBUG_ON
            	if ( xDefaults.usiDebugLevel <= dlMinorMessage )
                    fprintf(fp,"Preparing the Start Sequence.\n");
                #endif

                /* id of the first message will be 1 */
                bSuccess = bSendUART32v2(START_STATUS_SEQUENCE, 1);
                if ( bSuccess == TRUE ) {
                    eSenderMode = sDummySender;
                    #if DEBUG_ON
                    if ( xDefaults.usiDebugLevel <= dlMinorMessage )
                        fprintf(fp,"Success, start message in the retransmission buffer.\n");
                    #endif                    
                } else {
                    #if DEBUG_ON
                	if ( xDefaults.usiDebugLevel <= dlMinorMessage )
                        fprintf(fp,"Fail, try again in 5 seconds.\n");
                    #endif 
                    eSenderMode = sStartingConnSender;
                    OSTimeDlyHMSM(0, 0, 5, 0); /*Sleeps for 5 second*/
                }
                break;

            case sReadingQueue:

            	bSuccess = FALSE;

				OSSemPend(xSemCountSenderACK, 0, &error_code); /*Blocking*/
				if ( error_code == OS_ERR_NONE ) {
					/* There's command waiting to be threat */
					bSuccess = getBufferSendPUSorChar(&cTMPusOrChar); /*Blocking*/
					if (bSuccess == TRUE) {

						if ( cTMPusOrChar.bPUS == TRUE) {

							cTMPusL.ucNofValues = cTMPusOrChar.ucNofValues;
							cTMPusL.usiCat = cTMPusOrChar.usiCat;
							cTMPusL.usiPid = cTMPusOrChar.usiPid;
							cTMPusL.usiPusId = cTMPusOrChar.usiPusId;
							cTMPusL.usiSubType = cTMPusOrChar.usiSubType;
							cTMPusL.usiType = cTMPusOrChar.usiType;
							for (int ucI = 0; ucI < cTMPusL.ucNofValues; ucI++) {
								cTMPusL.usiValues[ucI] = cTMPusOrChar.usiValues[ucI];
							}

							eSenderMode = sSendingPUS;

						} else {

							memcpy(bufferL, cTMPusOrChar.buffer_128, 128);
							eSenderMode = sSendingInternalCMD;
						}

					} else {
						/* Semaphore was post by some task but has no message in the PreParsedBuffer*/
						vNoContentInSenderBuffer();
					}
				} else
					vFailGetCountSemaphoreSenderBuffer();
                break;

            case sSendingPUS:
            	vSendPusTM128(cTMPusL);
            	eSenderMode = sReadingQueue;
            	break;

            case sSendingInternalCMD:
            	vSendBufferChar128(bufferL);
            	eSenderMode = sReadingQueue;
                break;

            case sDummySender:
                /* code */
                eSenderMode = sDummySender;
                #if DEBUG_ON
                if ( xDefaults.usiDebugLevel <= dlMinorMessage )
                    fprintf(fp,"Working...\n");
                #endif

				OSTimeDlyHMSM(0, 0, 25, 0); /*Sleeps for 3 second*/
                break;

            default:
                #if DEBUG_ON
            	if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
                    fprintf(fp,"Sender default\n");
                #endif
                eSenderMode = sDummySender;
        }
    }
}

bool getBufferSendPUSorChar( tTMPusChar_Sender *cBuffer ) {
    bool bSuccess = FALSE;
    INT8U error_code;
    unsigned char i;
//xBuffer128_Sender
	OSMutexPend(xMutexTranferBuffer, 0, &error_code); /*Blocking*/
	if (error_code == OS_ERR_NONE) {
		/* Got the Mutex */
		/*For now, will only get the first, not the packet that is waiting for longer time*/
		for( i = 0; i < N_128_SENDER; i++)
		{
            if ( xBuffer128_Sender[i].bInUse == TRUE ) {
                /* Locate a filled PreParsed variable in the array*/
            	/* Perform a copy to a local variable */
            	(*cBuffer) = xBuffer128_Sender[i];
                bSuccess = TRUE;
                xBuffer128_Sender[i].bInUse = FALSE;
                xBuffer128_Sender[i].ucNofValues = 0;
                break;
            }
		}
		OSMutexPost(xMutexTranferBuffer);
	} else {
		/* Couldn't get Mutex. (Should not get here since is a blocking call without timeout)*/
		vFailGetxMutexSenderBuffer128();
	}
	return bSuccess;
}
