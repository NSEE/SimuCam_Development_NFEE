/*
 * parser_comm_task.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */


#include "parser_comm_task.h"


void vParserCommTask(void *task_data) {
	unsigned short int usiTypeL;
	unsigned short int usiSubTypeL;
	unsigned short int usiPUSidL;
	unsigned short int usiFeeInstL;
	bool bSuccess = FALSE;
	INT8U error_code;
	tParserStates eParserMode;
	tTMPus xTmPusL;
	static tPreParsed PreParsedLocal;
	#ifdef DEBUG_ON
		char cPUSDebug[128];
	#endif

    #ifdef DEBUG_ON
        debug(fp,"Parser Comm Task. (Task on)\n");
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
                    	} else {
							/* Semaphore was post by some task but has no message in the PreParsedBuffer*/
							vNoContentInPreParsedBuffer();
						}
                    } else {
						/*  Could not post the semaphore that indicates that NUC is connected and send a message.
							this a very IMPORTANT signalization!*/
                    	bSuccess = bTrySendSemaphoreCommInit();
						if (bSuccess == TRUE) {
							vFailSendxSemCommInit();
						}
                    }
				} else {
					vFailGetCountSemaphorePreParsedBuffer();
				}

				break;
			case sWaitingMessage:

				bSuccess = FALSE;
				eParserMode = sWaitingMessage;

				OSSemPend(xSemCountPreParsed, 0, &error_code); /*Blocking*/
				if ( error_code == OS_ERR_NONE ) {
					/* There's command waiting to be threat */

					bSuccess = getPreParsedPacket(&PreParsedLocal); /*Blocking*/
					if (bSuccess == TRUE) {
						/* PreParsed Content copied to the local variable */
						if ( PreParsedLocal.cType == START_REPLY_CHAR )
							eParserMode = sReplyParsing;
						else
							eParserMode = sRequestParsing;
					} else {
						/* Semaphore was post by some task but has no message in the PreParsedBuffer*/
						vNoContentInPreParsedBuffer();
					}

				} else {
					vFailGetCountSemaphorePreParsedBuffer();
				}
				break;
			case sRequestParsing:
				/* Final parssing after identify that is a request packet */
				/* ATTENTION: In order to avoid overhead of process the response to NUC of simple Requests
				   will be threat here, and send from here the parser_rx.*/
			   	switch (PreParsedLocal.cCommand)
				{
					case ETH_CMD: /*NUC requested the ETH Configuration*/
						vSendEthConf();
						eParserMode = sWaitingMessage;
						break;
                    case POWER_OFF_CMD: /*Shut down command from SGSE*/
						vSendTurnOff();
						eParserMode = sWaitingMessage;
                        break;						
                    case PUS_CMD: /*PUS command to MEB - TC*/

						#ifdef DEBUG_ON
							debug(fp,"PUS Received:\n");
							memset(cPUSDebug,0,128);
							sprintf(cPUSDebug, "TC-> pid: %hu; pcat: %hu; srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", PreParsedLocal.usiValues[1], PreParsedLocal.usiValues[2], PreParsedLocal.usiValues[3], PreParsedLocal.usiValues[4], PreParsedLocal.usiValues[5]);
							debug(fp, cPUSDebug );
						#endif
	
						usiTypeL = PreParsedLocal.usiValues[3];
						usiSubTypeL = PreParsedLocal.usiValues[4];
						usiPUSidL = PreParsedLocal.usiValues[5];

						eParserMode = sPusHandling;
                        break;						
					default:
						eParserMode = sWaitingMessage;
						break;
				}
				break;
			case sReplyParsing:
				eParserMode = sWaitingMessage;
                switch ( usiTypeL )
                {
                    case NUC_STATUS_CMD: /*Status from NUC*/

						
                        break;
                    case POWER_OFF_CMD: /*Shut down command from SGSE*/
						vSendTurnOff();
						
						
                        break;
                    case HEART_BEAT_CMD: /*Heart beating (NUC are you there?)*/

						
                        break;
                    default:
						eParserMode = sWaitingMessage;
                        break;
                }
				break;
			case sPusHandling:
				eParserMode = sWaitingMessage;
				
                switch ( usiTypeL )
                {
                    case 17: /* srv-Type = 17 */
						switch ( usiSubTypeL )
						{
							case 1: /* TC_SCAM_TEST_CONNECTION */
								#ifdef DEBUG_ON
									debug(fp,"TC_SCAM_TEST_CONNECTION\n");
								#endif

								/* Reply with the TM os connection */
								vTMPusTestConnection( usiPUSidL );

								break;
							default:
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", usiTypeL, usiSubTypeL, usiPUSidL );
									debug(fp, cPUSDebug );
								#endif
								eParserMode = sWaitingMessage;
								break;
						}
                        break;
                    case 250: /* srv-Type = 250 */
						switch ( usiSubTypeL )
						{
							case 59: /* TC_SCAM_RESET */
								#ifdef DEBUG_ON
									debug(fp,"TC_SCAM_RESET\n");
								#endif

								
								break;
							case 60: /* TC_SCAM_CONFIG */
								#ifdef DEBUG_ON
									debug(fp,"TC_SCAM_CONFIG\n");
								#endif


								break;
							case 61: /* TC_SCAM_RUN */
								#ifdef DEBUG_ON
									debug(fp,"TC_SCAM_RUN\n");
								#endif


								break;
							default:
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", usiTypeL, usiSubTypeL, usiPUSidL );
									debug(fp, cPUSDebug );
								#endif							
								eParserMode = sWaitingMessage;
								break;
						}
                        break;
                    case 251: /* srv-Type = 251 */
						usiFeeInstL = PreParsedLocal.usiValues[6];

						switch ( usiSubTypeL )
						{
							case 1: /* TC_SCAM_FEE_CONFIG_ENTER */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "TC_SCAM_FEE_CONFIG_ENTER-> Fee Instance: %hu;\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif							


								break;
							case 2: /* TC_SCAM_FEE_STANDBY_ENTER */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "TC_SCAM_FEE_STANDBY_ENTER-> Fee Instance: %hu;\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif


								break;
							case 3: /* TC_SCAM_FEE_CALIBRATION_ENTER */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "TC_SCAM_FEE_CALIBRATION_ENTER-> Fee Instance: %hu;\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif


								break;
							default:
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", usiTypeL, usiSubTypeL, usiPUSidL );
									debug(fp, cPUSDebug );
								#endif							
								eParserMode = sWaitingMessage;
								break;
						}
                        break;
					case 252: /* srv-Type = 252 */
						usiFeeInstL = PreParsedLocal.usiValues[6];

						switch ( usiSubTypeL )
						{					
							case 3: /* TC_SCAM_SPW_LINK_ENABLE */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "TC_SCAM_SPW_LINK_ENABLE-> FEESIM_INSTANCE: %hu;\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif


								break;
							case 4: /* TC_SCAM_SPW_LINK_DISABLE */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "TC_SCAM_SPW_LINK_DISABLE-> FEESIM_INSTANCE: %hu;\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif


								break;
							case 5: /* TC_SCAM_SPW_LINK_RESET */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "TC_SCAM_SPW_LINK_RESET-> FEESIM_INSTANCE: %hu;\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif


								break;
							case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "TC_SCAM_SPW_RMAP_CONFIG_UPDATE->\n");
									debug(fp, cPUSDebug );
									sprintf(cPUSDebug, "- FEESIM_INSTANCE: %hu;\n", usiFeeInstL );
									debug(fp, cPUSDebug );
									sprintf(cPUSDebug, "- MODE: %hu;\n", PreParsedLocal.usiValues[7] );
									debug(fp, cPUSDebug );
									sprintf(cPUSDebug, "- LINK_SPEED: %hu;\n", PreParsedLocal.usiValues[8] );
									debug(fp, cPUSDebug );
									sprintf(cPUSDebug, "- LOGICAL_ADDR: 0x%02X;\n", PreParsedLocal.usiValues[9] );
									debug(fp, cPUSDebug );
									sprintf(cPUSDebug, "- DEST_NODE_ADDR: 0x%02X;\n", PreParsedLocal.usiValues[10] );
									debug(fp, cPUSDebug );
									sprintf(cPUSDebug, "- TIME_CODE_GEN: %hu;\n", PreParsedLocal.usiValues[11] );
									debug(fp, cPUSDebug );
									sprintf(cPUSDebug, "- RMAP_KEY: 0x%02X;\n", PreParsedLocal.usiValues[12] );
									debug(fp, cPUSDebug );
								#endif



								break;
							default:
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", usiTypeL, usiSubTypeL, usiPUSidL );
									debug(fp, cPUSDebug );
								#endif							
								eParserMode = sWaitingMessage;
								break;
						}
                        break;
                    default:
						eParserMode = sWaitingMessage;
                        break;
                }
				break;				
			default:
				eParserMode = sWaitingMessage;
				break;
		}
	}
}

bool getPreParsedPacket( tPreParsed *xPreParsedParser ) {
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
	} else {
		/* Couldn't get Mutex. (Should not get here since is a blocking call without timeout)*/
		vFailGetxMutexPreParsedParserRxTask();
	}
	return bSuccess;
}

bool bTrySendSemaphoreCommInit( void ) {
	bool bSuccess = FALSE;
	unsigned char ucCountRetries = 0;
	INT8U error_code;

	#ifdef DEBUG_ON
		debug(fp,"Can't post semaphore to SenderTask. Trying more 10 times.\n");
	#endif

	ucCountRetries = 0;
	do
	{
		ucCountRetries++;
		OSTimeDly(50); /* 50 ticks -> 50 ms -> context switch */
		error_code = OSSemPost(xSemCommInit);
	} while ((error_code != OS_ERR_NONE) && (ucCountRetries < 11));

	if ( error_code == OS_ERR_NONE ) {
		bSuccess = TRUE;
	}

	return bSuccess;
}
