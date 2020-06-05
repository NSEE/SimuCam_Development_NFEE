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
	unsigned char ucIL;
	static tTMPus xTmPusL;
	static tTMPus xTcPusL;
	static tPreParsed PreParsedLocal;

	uint uRTCAL;
	uint uCLT;

	unsigned int uiEPinMilliSeconds;
	unsigned int uiRTinMilliSeconds;

    #if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMajorMessage )
			fprintf(fp,"Parser Comm Task. (Task on)\n");
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
				} else
					vFailGetCountSemaphorePreParsedBuffer();
				break;

			case sRequestParsing:
				/* Final parssing after identify that is a request packet */
				/* ATTENTION: In order to avoid overhead of process the response to NUC of simple Requests
				   will be threat here, and send from here the parser_rx.*/
			   	switch (PreParsedLocal.cCommand)
				{
					case ETH_CMD: /*NUC requested the ETH Configuration*/
						vSendEthConf();

						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
							fprintf(fp,"\n__________ Load Completed, Simucam is ready to be used _________ \n\n");
						}
						#endif


						eParserMode = sWaitingMessage;
						break;

                    case PUS_CMD: /*PUS command to MEB - TC*/
						#if DEBUG_ON
                    	if ( xDefaults.usiDebugLevel <= dlMinorMessage )
							fprintf(fp, "\nParser Task: TC-> pid: %hu; pcat: %hu; srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", PreParsedLocal.usiValues[1], PreParsedLocal.usiValues[2], PreParsedLocal.usiValues[3], PreParsedLocal.usiValues[4], PreParsedLocal.usiValues[5] );
						#endif
						/* Loading the values to the variable that will be used for the state that perform
						the action from PUS command*/
						xTcPusL.usiCat	= PreParsedLocal.usiValues[2];
						xTcPusL.usiType = PreParsedLocal.usiValues[3];
						xTcPusL.usiSubType = PreParsedLocal.usiValues[4];
						xTcPusL.usiPusId = PreParsedLocal.usiValues[5];
						xTcPusL.ucNofValues = 0; /* Don't assume that has values */
						eParserMode = sPusHandling;
                        break;

					default:
						eParserMode = sWaitingMessage;
				}
				break;
			case sReplyParsing:
				eParserMode = sWaitingMessage;
                switch ( xTcPusL.usiType ) {
                    case NUC_STATUS_CMD: /*Status from NUC*/
						/*todo*/
                        break;

                    case HEART_BEAT_CMD: /*Heart beating (NUC are you there?)*/
						/*todo*/
                        break;

                    default:
						eParserMode = sWaitingMessage;
                }
				break;
			case sPusHandling:
			/* This state identify the command of PUS, if the command is for any FEE than will be send to
			MEB_Task than foward to the FEE using the queue internal command*/
				eParserMode = sWaitingMessage;
				/*Check the type of the PUS command*/
                switch ( xTcPusL.usiType ) {
                    case 17: /* srv-Type = 17 */
						switch ( xTcPusL.usiSubType ) {
							case 1: /* TC_SCAM_TEST_CONNECTION */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMajorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_TEST_CONNECTION\n");
								#endif

								/* Reply with the TM of connection */
								vTMPusTestConnection( xTcPusL.usiPusId );
								break;

							default:
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
								#endif
								eParserMode = sWaitingMessage;
						}
                        break;

                    case 250: /* srv-Type = 250 */
						switch ( xTcPusL.usiSubType ) {
							case 70: /*Data source*/
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[6];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];

//								#if DEBUG_ON
//								if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
//									fprintf(fp,"Parser Task: TC_DATA_SOURCE\n");
//								#endif

								bSendMessagePUStoMebTask(&xTcPusL);
								break;
							case 29: /* TC_SYNCH_SOURCE */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SYNCH_SOURCE\n");
								#endif
								/*source*/
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[6];
								xTcPusL.ucNofValues++;
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;


							case 31: /* TC_SYNCH_RESET [bndky]*/
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SYNCH_RESET\n");
								#endif
								/* Get the value */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[6];
								xTcPusL.ucNofValues++;
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;
							case 34:
								usiFeeInstL = PreParsedLocal.usiValues[6];
								if ( usiFeeInstL <= N_OF_NFEE ) {
									tTMPus xTmPusL;
									bRmapGetRmapMemCfgArea(&xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
									xTmPusL.usiPusId = xTcPusL.usiPusId;
									xTmPusL.usiPid = xTcPusL.usiPusId;
									xTmPusL.usiCat = xTcPusL.usiCat;
									xTmPusL.usiType = 250;
									xTmPusL.usiSubType = 35;
									xTmPusL.ucNofValues = 0;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = usiFeeInstL;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVStart;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiVEnd;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiChargeInjectionWidth;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiChargeInjectionGap;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiParallelToiPeriod;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiParallelClkOverlap;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiNFinalDump;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiHEnd;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bChargeInjectionEn;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bTriLevelClkEn;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bImgClkDir;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bRegClkDir;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiPacketSize;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiIntSyncPeriod;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliTrapPumpingDwellCounter >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliTrapPumpingDwellCounter;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bSyncSel;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucSensorSel;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDigitiseEn;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bDGEn;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bCcdReadEn;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg5ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd1WinListPtr >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd1WinListPtr;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd1PktorderListPtr >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd1PktorderListPtr;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd1WinListLength;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd1WinSizeX;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd1WinSizeY;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg8ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd2WinListPtr >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd2WinListPtr;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd2PktorderListPtr >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd2PktorderListPtr;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd2WinListLength;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd2WinSizeX;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd2WinSizeY;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg11ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd3WinListPtr >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd3WinListPtr;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd3PktorderListPtr >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd3PktorderListPtr;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd3WinListLength;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd3WinSizeX;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd3WinSizeY;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg14ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd4WinListPtr >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd4WinListPtr;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd4PktorderListPtr >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd4PktorderListPtr;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd4WinListLength;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd4WinSizeX;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd4WinSizeY;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg17ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcdVodConfig;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd1VrdConfig;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd2VrdConfig0;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd2VrdConfig1;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd3VrdConfig;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd4VrdConfig;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdVgdConfig0;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdVgdConfig1;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcdVogConfig;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcdIgHiConfig;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcdIgLoConfig;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiReg21ConfigReserved0;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcdModeConfig;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg21ConfigReserved1;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.bClearErrorFlag;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliReg22ConfigReserved >> 16;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliReg22ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd1LastEPacket;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd1LastFPacket;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd2LastEPacket;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg23ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd2LastFPacket;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd3LastEPacket;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd3LastFPacket;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg24ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd4LastEPacket;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd4LastFPacket;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiSurfaceInversionCounter;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucReg25ConfigReserved;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiReadoutPauseCounter;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiTrapPumpingShuffleCounter;
									xTmPusL.ucNofValues++;
									vSendPusTM512(xTmPusL);
									// Change to R3
									//bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								}
								break;
							case 36:
								usiFeeInstL = PreParsedLocal.usiValues[6];
								if ( usiFeeInstL <= N_OF_NFEE ) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
									xTcPusL.ucNofValues++;
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								}
								break;
							case 37:
								usiFeeInstL = PreParsedLocal.usiValues[6];
								if ( usiFeeInstL <= N_OF_NFEE ) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
									xTcPusL.ucNofValues++;
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								}
								break;
							case 49: /* TC_SCAM_IMAGE_ERR_MISS_PKT_TRIG  */

								usiFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( usiFeeInstL <= N_OF_NFEE ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* SQ */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* N repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								}
								break;

							case 67: /* TC_SCAM_IMAGE_ERR_MISSDATA_TRIG  */
								usiFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( usiFeeInstL <= N_OF_NFEE ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* SQ */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* N repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;
									/* StartByte */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								}
								break;

							case 50: /* TC_SCAM_IMAGE_ERR_NOMOREPKT_TRIG  */
								usiFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( usiFeeInstL <= N_OF_NFEE ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								}
								break;

							case 53: /* TC_SCAM_ERR_OFF  */
								usiFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( usiFeeInstL <= N_OF_NFEE ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								}
								break;

							case 58: /* Update HK [bndky] */

								usiFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( usiFeeInstL > N_OF_NFEE ) {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMajorMessage )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								/* todo: Enviar mensagem de erro se aplicavel */
								} else {
									
									xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
									xTcPusL.ucNofValues++;
									/* HK ID */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* HK Value */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								}
								break;

							case 59: /* TC_SCAM_RESET */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_RESET\n");
								#endif
								/*Send the command to NUC in order to reset the NUC*/
								vSendReset();
								
								OSTimeDlyHMSM(0,0,3,0);
								vRstcHoldSimucamReset(0);
								break;

							case 60: /* TC_SCAM_CONFIG */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_CONFIG\n");
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 61: /* TC_SCAM_RUN */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_RUN\n");
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 66: /* TC_SCAM_TURNOFF */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_TURNOFF\n");
								#endif
								/*Send the command to NUC in order to shutdown the NUC*/
								vSendTurnOff();
								/* Send to Meb the shutdown command */
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 64: /* TC_SCAM_FEE_TIME_CONFIG */

								/* EP */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[6];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
								xTcPusL.ucNofValues++;
								/* DELTA_START */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
								xTcPusL.ucNofValues++;
								/* DELTA_PX  */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[10];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[11];
								xTcPusL.ucNofValues++;
								/* DELTA_LINE  */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[12];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[13];
								xTcPusL.ucNofValues++;

								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);

								break;

							default:
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
								#endif							
								eParserMode = sWaitingMessage;
						}
                        break;

                    case 251: /* srv-Type = 251 */
					/*Commands of these srv-Type (251), are to simulation FEE instances*/
						usiFeeInstL = PreParsedLocal.usiValues[6];
						if ( usiFeeInstL > N_OF_NFEE ) {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage )
								fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
							#endif
							/* todo: Enviar mensagem de erro se aplicavel */
						} else {
							xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
							xTcPusL.ucNofValues++;

							switch ( xTcPusL.usiSubType ) {
								case 1: /* TC_SCAM_FEE_CONFIG_ENTER */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: TC_SCAM_FEE_CONFIG_ENTER (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;

								case 2: /* TC_SCAM_FEE_STANDBY_ENTER */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: TC_SCAM_FEE_STANDBY_ENTER (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 3: /* NFEE_RUNNING_FULLIMAGE  */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_FULLIMAGE (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 4: /* NFEE_RUNNING_WINDOWING  */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_WINDOWING (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 5: /* NFEE_RUNNING_FULLIMAGE_PATTERN */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_FULLIMAGE_PATTERN (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 6: /* NFEE_RUNNING_WINDOWING_PATTERN  */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_WINDOWING_PATTERN (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 11: /* NFEE_RUNNING_ON  */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_ON (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 12: /* NFEE_RUNNING_PARALLEL_TRAP_PUMP_1  */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_PARALLEL_TRAP_PUMP_1 (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 13: /* NFEE_RUNNING_PARALLEL_TRAP_PUMP_2  */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_PARALLEL_TRAP_PUMP_2 (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 14: /* NFEE_RUNNING_SERIAL_TRAP_PUMP_1  */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_SERIAL_TRAP_PUMP_1 (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 15: /* NFEE_RUNNING_SERIAL_TRAP_PUMP_2  */
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: NFEE_RUNNING_SERIAL_TRAP_PUMP_2 (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								default:
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
									#endif							
									eParserMode = sWaitingMessage;
							}
						}
                        break;

					case 252: /* srv-Type = 252 */
						usiFeeInstL = PreParsedLocal.usiValues[6];
						xTcPusL.usiValues[xTcPusL.ucNofValues] = usiFeeInstL;
						xTcPusL.ucNofValues++;

						switch ( xTcPusL.usiSubType ) {					
							case 3: /* TC_SCAM_SPW_LINK_ENABLE */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: TC_SCAM_SPW_LINK_ENABLE (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 4: /* TC_SCAM_SPW_LINK_DISABLE */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: TC_SCAM_SPW_LINK_DISABLE (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 5: /* TC_SCAM_SPW_LINK_RESET */
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: TC_SCAM_SPW_LINK_RESET (FEESIM_INSTANCE: %hu)\n", usiFeeInstL );
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */

								for ( ucIL = 0; ucIL < 6; ucIL++) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7+ucIL];
									xTcPusL.ucNofValues++; /*todo: Will be needed for future command, don't remove until you sure it will not be used anymore*/
								}

								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
									fprintf(fp, "Parser Task: TC_SCAM_SPW_RMAP_CONFIG_UPDATE:\n" );
									fprintf(fp, "- FEESIM_INSTANCE: %hu;\n", usiFeeInstL );
									fprintf(fp, "- MODE: %hu;\n", PreParsedLocal.usiValues[7] );
									fprintf(fp, "- LINK_SPEED: %hu;\n", PreParsedLocal.usiValues[8] );
									fprintf(fp, "- LOGICAL_ADDR: 0x%02X;\n", PreParsedLocal.usiValues[9] );
									fprintf(fp, "- DEST_NODE_ADDR: 0x%02X;\n", PreParsedLocal.usiValues[10] );
									fprintf(fp, "- TIME_CODE_GEN: %hu;\n", PreParsedLocal.usiValues[11] );
									fprintf(fp, "- RMAP_KEY: 0x%02X;\n", PreParsedLocal.usiValues[12] );
								}
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							default:
								#if DEBUG_ON
								if ( xDefaults.usiDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
								#endif							
								eParserMode = sWaitingMessage;
						}
                        break;
					case 254: /* srv-Type = 254 */
						switch ( xTcPusL.usiSubType ) {
							case 3:
								xTmPusL.usiPusId = xTcPusL.usiPusId;
								xTmPusL.usiPid = xTcPusL.usiPusId;
								xTmPusL.usiCat = xTcPusL.usiCat;
								xTmPusL.usiType = 254;
								xTmPusL.usiSubType = 4;
								xTmPusL.ucNofValues = 0;
								xTmPusL.usiValues[xTmPusL.ucNofValues] = xSimMeb.eMode; /* MEB operation MODE */
								xTmPusL.ucNofValues++;
								uiEPinMilliSeconds = (xSimMeb.ucEP * 1000);
								xTmPusL.usiValues[xTmPusL.ucNofValues] = uiEPinMilliSeconds >> 16; 	/* EP in Milliseconds 1� Word */
								xTmPusL.ucNofValues++;
								xTmPusL.usiValues[xTmPusL.ucNofValues] = uiEPinMilliSeconds;		/* EP in Milliseconds 2� Word */
								xTmPusL.ucNofValues++;
								xTmPusL.usiValues[xTmPusL.ucNofValues] = xSimMeb.eSync;				/* Sync Source				  */
								xTmPusL.ucNofValues++;
								vSendPusTM128(xTmPusL);
								break;
							case 8:
								usiFeeInstL = PreParsedLocal.usiValues[6];
								if ( usiFeeInstL <= N_OF_NFEE ) {
									unsigned short int usiSPWStatusTotal;
									unsigned short int usiSPWRunning;
									unsigned short int usiSPWConnecting;
									unsigned short int usiSPWStarted;

									tTMPus xTmPusL;
									xTmPusL.usiPusId = xTcPusL.usiPusId;
									xTmPusL.usiPid = xTcPusL.usiPusId;
									xTmPusL.usiCat = xTcPusL.usiCat;
									xTmPusL.usiType = 254;
									xTmPusL.usiSubType = 9;
									xTmPusL.ucNofValues = 0;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = usiFeeInstL;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xControl.eMode;
									xTmPusL.ucNofValues++;
									bSpwcGetLinkStatus(&xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
									if (xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkStatus.bRunning == true) {
										usiSPWRunning = 0b001;
									} else {
										usiSPWRunning = 0;
									}
									if (xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkStatus.bConnecting == true) {
										usiSPWConnecting = 0b010;
									} else {
										usiSPWConnecting = 0;
									}
									if (xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xSpwcLinkStatus.bStarted == true) {
										usiSPWStarted = 0b100;
									} else {
										usiSPWStarted = 0;
									}
									usiSPWStatusTotal = usiSPWRunning^usiSPWConnecting^usiSPWStarted;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=usiSPWStatusTotal;
									xTmPusL.ucNofValues++;

									bDpktGetPixelDelay(&xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
									bDpktGetPacketConfig(&xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket);
									if (xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdVStart > xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdVEnd )
									{
										uCLT = 0;
										uRTCAL = 0;
									}
									else
									{
										uCLT = (xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdVEnd - xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xDataPacket.xDpktDataPacketConfig.usiCcdVStart) + 1;
										uRTCAL = ( (xDefaults.ulStartDelay * 1000000)  +
										uCLT *
										xSimMeb.xFeeControl.xNfee[usiFeeInstL].xCcdInfo.usiHalfWidth*
										xDefaults.ulADCPixelDelay+
										uCLT*
										xDefaults.ulLineDelay+
										( (xSimMeb.xFeeControl.xNfee[usiFeeInstL].xCcdInfo.usiHeight + xSimMeb.xFeeControl.xNfee[usiFeeInstL].xCcdInfo.usiOLN ) - uCLT)* // Version with OverScan
										xDefaults.ulSkipDelay);
										uiRTinMilliSeconds = (uRTCAL / 1000);
									}
									xTmPusL.usiValues[xTmPusL.ucNofValues] = uiRTinMilliSeconds >> 16; 	/* RT in Milliseconds 1� Word */
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = uiRTinMilliSeconds;		/* RT in Milliseconds 2� Word */
									xTmPusL.ucNofValues++;
									bFeebGetMachineStatistics(&xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer);
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliIncomingPktsCnt >> 16; /*Incoming packets 1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliIncomingPktsCnt; /*Incoming packets 2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliOutgoingPktsCnt >> 16; /*Outgoing packets 1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliOutgoingPktsCnt; /*Outgoing packets 2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwEepCnt >> 16; /*Number of EEP's  1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwEepCnt ; /*Number of EEP's  2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwLinkCreditErrCnt >> 16; /*Number of Credit Errors  1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwLinkCreditErrCnt; /*Number of Credit Errors  2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwLinkDisconnectCnt >> 16; /*Number of Disconnect Errors  1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwLinkDisconnectCnt; /*Number of Disconnect Errors  2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwLinkEscapeErrCnt >> 16; /*Number of Escape Errors  1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwLinkEscapeErrCnt; /*Number of Escape Errors  2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwLinkParityErrCnt >> 16; /*Number of Parity Errors  1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=xSimMeb.xFeeControl.xNfee[usiFeeInstL].xChannel.xFeeBuffer.xFeebMachineStatistics.uliSpwLinkParityErrCnt; /*Number of Parity Errors  2 Word*/
									xTmPusL.ucNofValues++;
									vSendPusTM128(xTmPusL);
									//bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", usiFeeInstL );
									#endif
								}
								break;
							default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMinorMessage )
								fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
							#endif
							eParserMode = sWaitingMessage;
						}
						break;
                    default:
						eParserMode = sWaitingMessage;
                }
				break;				
			default:
				eParserMode = sWaitingMessage;
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
    bool bSuccess;
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
