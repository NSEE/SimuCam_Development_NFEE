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
                    	}
                    } else {
                    	eParserMode = sHandlingError;
                        xPreParsedBuffer.ucErrorFlag = eSemErrorInit;
                    }
				} else {
					#ifdef DEBUG_ON
						debug(fp,"Erro trying to get xSemCountPreParsed.\n");
					#endif
				}

				break;
			case sRequestParsing:
			   switch (xPreParsedBuffer.cType)
				{
					case ETH_CMD: /*NUC requested the ETH Configuration*/


						break;
					default:
						break;
				}
				break;
			case sReplyParsing:
                switch (xPreParsedBuffer.cType)
                {
                    case NUC_STATUS_CMD: /*Status from NUC*/

                        break;
                    case POWER_OFF_CMD: /*Shut down command from SGSE*/

                        break;
                    case PUS_CMD: /*PUS command to MEB*/

                        break;
                    case HEART_BEAT_CMD: /*Heart beating (NUC are you there?)*/

                        break;
                    default:
                        break;
                }
				break;
			default:
				break;
		}
	}
}

bool getPreParsedPacket( tPreParsed *xPreParsedParser ){
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
	}
	return bSuccess;
}

unsigned short int usiGetIdCMD ( void ) {

    if ( usiIdCMD > 65534 )
        usiIdCMD = 1;
    else
        usiIdCMD++;

    return usiIdCMD;
}
