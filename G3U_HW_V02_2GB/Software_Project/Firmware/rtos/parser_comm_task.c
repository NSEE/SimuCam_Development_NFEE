/*
 * parser_comm_task.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */


#include "parser_comm_task.h"


void vParserCommTask(void *task_data) {
	unsigned short int usiFeeInstL;
	bool bSuccess = FALSE;
	INT8U error_code;
	tParserStates eParserMode;
	static tTMPus xTcPusL;
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
				eParserMode = sWaitingMessage;
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
                    case PUS_CMD: /*PUS command to MEB - TC*/

						#ifdef DEBUG_ON
							memset(cPUSDebug,0,128);
							sprintf(cPUSDebug, "\nParser Task: TC-> pid: %hu; pcat: %hu; srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", PreParsedLocal.usiValues[1], PreParsedLocal.usiValues[2], PreParsedLocal.usiValues[3], PreParsedLocal.usiValues[4], PreParsedLocal.usiValues[5]);
							debug(fp, cPUSDebug );
						#endif
	
						xTcPusL.usiCat	= PreParsedLocal.usiValues[2];
						xTcPusL.usiType = PreParsedLocal.usiValues[3];
						xTcPusL.usiSubType = PreParsedLocal.usiValues[4];
						xTcPusL.usiPusId = PreParsedLocal.usiValues[5];
						xTcPusL.ucNofValues = 0; /* Don't assume that has values */

						eParserMode = sPusHandling;
                        break;						
					default:
						eParserMode = sWaitingMessage;
						break;
				}
				break;
			case sReplyParsing:
				eParserMode = sWaitingMessage;
                switch ( xTcPusL.usiType )
                {
                    case NUC_STATUS_CMD: /*Status from NUC*/

						
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
				
                switch ( xTcPusL.usiType )
                {
                    case 17: /* srv-Type = 17 */
						switch ( xTcPusL.usiSubType )
						{
							case 1: /* TC_SCAM_TEST_CONNECTION */
								#ifdef DEBUG_ON
									debug(fp,"Parser Task: TC_SCAM_TEST_CONNECTION\n");
								#endif

								/* Reply with the TM os connection */
								vTMPusTestConnection( xTcPusL.usiPusId );

								break;
							default:
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
									debug(fp, cPUSDebug );
								#endif
								eParserMode = sWaitingMessage;
								break;
						}
                        break;


                    case 250: /* srv-Type = 250 */
						switch ( xTcPusL.usiSubType )
						{
							case 59: /* TC_SCAM_RESET */
								#ifdef DEBUG_ON
									debug(fp,"Parser Task: TC_SCAM_RESET\n");
								#endif
								vSendReset();
								/*Just Reset the Simucam, what do with the NUC?*/
								OSTimeDlyHMSM(0,0,3,0);
								vRstcSimucamReset( 5000 );

								break;
							case 60: /* TC_SCAM_CONFIG */
								#ifdef DEBUG_ON
									debug(fp,"Parser Task: TC_SCAM_CONFIG\n");
								#endif
								bSendMessagePUStoMebTask(&xTcPusL);

								break;
							case 61: /* TC_SCAM_RUN */
								#ifdef DEBUG_ON
									debug(fp,"Parser Task: TC_SCAM_RUN\n");
								#endif
								bSendMessagePUStoMebTask(&xTcPusL);

								break;
							case 62: /* TC_SCAM_TURNOFF */
								#ifdef DEBUG_ON
									debug(fp,"Parser Task: TC_SCAM_TURNOFF\n");
								#endif
								vSendTurnOff();

								/* Send to Meb the shutdown command */
								bSendMessagePUStoMebTask(&xTcPusL);

								break;
							default:
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
									debug(fp, cPUSDebug );
								#endif							
								eParserMode = sWaitingMessage;
								break;
						}
                        break;


                    case 251: /* srv-Type = 251 */
						usiFeeInstL = PreParsedLocal.usiValues[6];

						if ( usiFeeInstL > N_OF_NFEE ) {
							#ifdef DEBUG_ON
								memset(cPUSDebug,0,128);
								sprintf(cPUSDebug, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
								debug(fp, cPUSDebug );
							#endif
							/* todo: Enviar mensagem de erro se aplicavel */
						} else {
							xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
							xTcPusL.ucNofValues++;

							switch ( xTcPusL.usiSubType )
							{
								case 1: /* TC_SCAM_FEE_CONFIG_ENTER */
									#ifdef DEBUG_ON
										memset(cPUSDebug,0,128);
										sprintf(cPUSDebug, "Parser Task: TC_SCAM_FEE_CONFIG_ENTER (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
										debug(fp, cPUSDebug );
									#endif							
									bSendMessagePUStoMebTask(&xTcPusL);

									break;
								case 2: /* TC_SCAM_FEE_STANDBY_ENTER */
									#ifdef DEBUG_ON
										memset(cPUSDebug,0,128);
										sprintf(cPUSDebug, "Parser Task: TC_SCAM_FEE_STANDBY_ENTER (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
										debug(fp, cPUSDebug );
									#endif
									bSendMessagePUStoMebTask(&xTcPusL);

									break;
								case 5: /* TC_SCAM_FEE_CALIBRATION_TEST_ENTER */
									#ifdef DEBUG_ON
										memset(cPUSDebug,0,128);
										sprintf(cPUSDebug, "Parser Task: TC_SCAM_FEE_CALIBRATION_TEST_ENTER (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
										debug(fp, cPUSDebug );
									#endif
									bSendMessagePUStoMebTask(&xTcPusL);

									break;
								default:
									#ifdef DEBUG_ON
										memset(cPUSDebug,0,128);
										sprintf(cPUSDebug, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
										debug(fp, cPUSDebug );
									#endif							
									eParserMode = sWaitingMessage;
									break;
							}
						}
                        break;


					case 252: /* srv-Type = 252 */
						usiFeeInstL = PreParsedLocal.usiValues[6];
						xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
						xTcPusL.ucNofValues++;

						switch ( xTcPusL.usiSubType )
						{					
							case 3: /* TC_SCAM_SPW_LINK_ENABLE */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Parser Task: TC_SCAM_SPW_LINK_ENABLE (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif
								bSendMessagePUStoMebTask(&xTcPusL);

								break;
							case 4: /* TC_SCAM_SPW_LINK_DISABLE */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Parser Task: TC_SCAM_SPW_LINK_DISABLE (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif
								bSendMessagePUStoMebTask(&xTcPusL);

								break;
							case 5: /* TC_SCAM_SPW_LINK_RESET */
								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Parser Task: TC_SCAM_SPW_LINK_RESET (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									debug(fp, cPUSDebug );
								#endif
								bSendMessagePUStoMebTask(&xTcPusL);

								break;
							case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[10];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[11];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[12];
								xTcPusL.ucNofValues++;


								#ifdef DEBUG_ON
									memset(cPUSDebug,0,128);
									sprintf(cPUSDebug, "Parser Task: TC_SCAM_SPW_RMAP_CONFIG_UPDATE:\n");
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
									sprintf(cPUSDebug, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
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
    unsigned char i;

	OSMutexPend(xMutexPreParsed, 0, &error_code); /*Blocking*/
	if (error_code == OS_ERR_NONE) {
		/* Got the Mutex */
		/*For now, will only get the first, not the packet that is waiting for longer time*/
		for( i = 0; i < N_PREPARSED_ENTRIES; i++)
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

/* Search for some free location in the xPus array to put the full command to send to the meb task */
bool bSendMessagePUStoMebTask( tTMPus *xPusL ) {
    bool bSuccess = FALSE;
    INT8U error_code;
    tQMask xCdmLocal;
    unsigned char i = 0;

    bSuccess = FALSE;
    xCdmLocal.ulWord = 0;
    OSMutexPend(xMutexPus, 10, &error_code); /* Try to get mutex that protects the xPus buffer. Wait max 10 ticks = 10 ms */
    if ( error_code == OS_NO_ERR ) {

        for(i = 0; i < N_PUS_PIPE; i++)
        {
            if ( xPus[i].bInUse == FALSE ) {
                /* Locate a free place*/
                /* Need to check if the performance is the same as memcpy*/
            	xPus[i] = (*xPusL);
            	xPus[i].bInUse = TRUE;

            	/* Build the command to Meb using the Mask Queue */
            	xCdmLocal.ucByte[3] = M_MEB_ADDR;
            	xCdmLocal.ucByte[2] = Q_MEB_PUS;

            	/* Sync the Meb task and tell that has a PUS command waiting */
            	error_code = OSQPost(xMebQ, (void *)xCdmLocal.ulWord);
                if ( error_code != OS_ERR_NONE ) {
                	vFailSendPUStoMebTask();
                	xPus[i].bInUse = FALSE;
                } else
                    bSuccess = TRUE;
                break;
            }
        }
        OSMutexPost(xMutexPus);
    }

    return bSuccess;
}
