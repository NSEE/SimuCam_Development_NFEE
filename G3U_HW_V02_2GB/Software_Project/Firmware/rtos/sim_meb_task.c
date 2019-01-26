/*
 * sim_meb_task.c
 *
 *  Created on: 13/01/2019
 *      Author: TiagoLow
 */


#include "sim_meb_task.h"

/* All commands should pass through the MEB, it is the instance that hould know everything, and also know the self state and what is allowed to be performed or not */

void vSimMebTask(void *task_data) {
	TSimucam_MEB *pxMebC;
	tQMask uiCmdMeb;
	INT8U error_code;

	pxMebC = (TSimucam_MEB *) task_data;

	#ifdef DEBUG_ON
        debug(fp,"Sim-Meb Controller Task. (Task on)\n");
    #endif

	for (;;) {
		switch ( pxMebC->eMode )
		{
			case sMebConfig:

				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Check if the command is for MEB */
					if ( uiCmdMeb.ucByte[3] == M_MEB_ADDR ) {
						/* Parse the cmd that comes in the Queue */
						switch (uiCmdMeb.ucByte[2]) {
							/* Receive a PUS command */
							case Q_MEB_PUS:
								vPusMebInTaskConfigMode( pxMebC );
								break;
							default:
								break;
						}
					} else {
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: Command Ignored. Not Addressed to Meb. ADDR= %ui\n", uiCmdMeb.ucByte[3]);
						#endif
					}

				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetCmdQueueMeb();
				}

				break;
			case sRun:
				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Check if the command is for MEB */
					if ( uiCmdMeb.ucByte[3] == M_MEB_ADDR ) {
						/* Parse the cmd that comes in the Queue */
						switch (uiCmdMeb.ucByte[2]) {
							/* Receive a PUS command */
							case Q_MEB_PUS:
								vPusMebInTaskRunningMode( pxMebC );
								break;
							default:
								break;
						}
					} else {
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: Command Ignored. Not Addressed to Meb. ADDR= %ui\n", uiCmdMeb.ucByte[3]);
						#endif
					}

				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetCmdQueueMeb();
				}			

				break;
			default:
				#ifdef DEBUG_ON
					debug(fp,"MEB Task: Unknow state, backing to Config Mode.\n");
				#endif
				
				/* todo:Aplicar toda logica de mudanÃ§a de esteado aqui */
				pxMebC->eMode = sMebConfig;
				break;
		}
	}
}

/* This function should treat the PUS command in the Config Mode, need check all the things that is possible to update in this mode */
/* In the Config Mode the MEb takes control and change all values freely */
void vPusMebInTaskConfigMode( TSimucam_MEB *pxMebCLocal ) {
	unsigned char i;
	unsigned short int usiFeeInstL;
	static tTMPus xPusLocal;
	bool bSuccess = FALSE;
	INT8U error_code;

	bSuccess = FALSE;
	OSMutexPend(xMutexPus, 1, &error_code);
	if ( error_code == OS_ERR_NONE ) {

	    /*Search for the PUS command*/
	    for(i = 0; i < N_PUS_PIPE; i++)
	    {
            if ( xPus[i].bInUse == TRUE ) {
                /* Need to check if the performance is the same as memcpy*/
            	xPusLocal = xPus[i];
            	xPus[i].bInUse = FALSE;
            	bSuccess = TRUE;
                break;
            }
	    }
	    OSMutexPost(xMutexPus);
	} else {
		vCouldNotGetMutexMebPus();
	}

	/* PUS command Retrieved*/
	if ( bSuccess == TRUE ) {

		switch (xPusLocal.usiType) {
			case 250: /* srv-Type = 250 */
				switch ( xPusLocal.usiSubType )
				{
					case 60: /* TC_SCAM_CONFIG */
						#ifdef DEBUG_ON
							debug(fp,"MEB Task: MEB already in the Config Mode\n");
						#endif
						break;


					case 61: /* TC_SCAM_RUN */

						vMebChangeToRunning( pxMebCLocal );
						OSTimeDlyHMSM(0,0,0,20);
						bStartSync();

						break;
					case 62: /* TC_SCAM_TURNOFF */
						#ifdef DEBUG_ON
							debug(fp,"MEB Task: Turnning OFF \n");
						#endif

						/* todo:Enviar emnsagens para a meb, e a meb distribui a mensagem */
						/* todo:Enviar Sinalizar Led quando puder desligar */

						break;
					default:
						#ifdef DEBUG_ON
							fprintf(fp, "MEB Task: Default - TC arrived-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xPusLocal.usiType, xPusLocal.usiSubType, xPusLocal.usiPusId );
						#endif
						break;
				}
				break;
			case 251: /* srv-Type = 251 */
				usiFeeInstL = xPusLocal.usiValues[0]; /* 0 is the NFEE instance */

				switch ( xPusLocal.usiSubType )
				{
					case 1: /* TC_SCAM_FEE_CONFIG_ENTER */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"WARNING: NFEE-%hu is already in Config Mode \n\n", usiFeeInstL);
						#endif

						/* Build a function to send this command to the FEE instance */

						break;
					case 2: /* TC_SCAM_FEE_STANDBY_ENTER */
					case 5: /* TC_SCAM_FEE_CALIBRATION_TEST_ENTER */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"WARNING: Can't change NFEE mode while MEB is in Config Mode. \n\n");
						#endif

							/* Do nothing */

						break;
					default:
						#ifdef DEBUG_ON
							fprintf(fp, "MEB Task: Default - TC arrived-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xPusLocal.usiType, xPusLocal.usiSubType, xPusLocal.usiPusId );
						#endif
						break;
				}
				break;
			case 252: /* srv-Type = 252 */
				usiFeeInstL = xPusLocal.usiValues[0]; /* 0 is the NFEE instance */


				switch ( xPusLocal.usiSubType )
				{
					case 3: /* TC_SCAM_SPW_LINK_ENABLE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_ENABLE \n");
							fprintf(fp,"WARNING: Can't operate the Link while Meb is is Config mode \n\n");
						#endif

						/* todo: Usar as funï¿½ï¿½es de configuraï¿½ï¿½o disponibilizadas pelo Franï¿½a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configuraï¿½ï¿½es tranquilamente  */

						break;
					case 4: /* TC_SCAM_SPW_LINK_DISABLE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_DISABLE \n");
							fprintf(fp,"WARNING: Can't operate the Link while Meb is is Config mode \n\n");
						#endif

						/* todo: Usar as funï¿½ï¿½es de configuraï¿½ï¿½o disponibilizadas pelo Franï¿½a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configuraï¿½ï¿½es tranquilamente  */

						break;
					case 5: /* TC_SCAM_SPW_LINK_RESET */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_RESET \n");
							fprintf(fp,"WARNING: Can't operate the Link while Meb is is Config mode \n\n");
						#endif

						/* todo: Usar as funï¿½ï¿½es de configuraï¿½ï¿½o disponibilizadas pelo Franï¿½a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configuraï¿½ï¿½es tranquilamente  */

						break;
					case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_RMAP_CONFIG_UPDATE \n");
						#endif
							/* todo: Usar libs do Franï¿½a para atualizar o link com os valores abaixo*/
							/*
						xPusLocal.usiValues[2];
						xPusLocal.usiValues[3];
						xPusLocal.usiValues[4];
						xPusLocal.usiValues[5];
						xPusLocal.usiValues[6];
						xPusLocal.usiValues[7];
							*/

						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucKey = (unsigned char)xPusLocal.usiValues[12];
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char)xPusLocal.usiValues[9];

						/*todo:Back todo: Tratar retorno*/
						//bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap );

						/*
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
*/
						break;
					default:
						#ifdef DEBUG_ON
							fprintf(fp, "MEB Task: Default - TC arrived-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xPusLocal.usiType, xPusLocal.usiSubType, xPusLocal.usiPusId );
						#endif

						break;
				}
				break;
			default:
				break;
		}

	}

}


/* This function should treat the PUS command in the Running Mode, need check all the things that is possible to update in this mode */
void vPusMebInTaskRunningMode( TSimucam_MEB *pxMebCLocal ) {
	unsigned char i;
	unsigned short int usiFeeInstL;
	static tTMPus xPusLocal;
	bool bSuccess = FALSE;
	INT8U error_code;

	bSuccess = FALSE;
	OSMutexPend(xMutexPus, 1, &error_code);
	if ( error_code == OS_ERR_NONE ) {

	    /*Search for the PUS command*/
	    for(i = 0; i < N_PUS_PIPE; i++)
	    {
            if ( xPus[i].bInUse == TRUE ) {
                /* Need to check if the performance is the same as memcpy*/
            	xPusLocal = xPus[i];
            	xPus[i].bInUse = FALSE;
            	bSuccess = TRUE;
                break;
            }
	    }
	    OSMutexPost(xMutexPus);
	} else {
		vCouldNotGetMutexMebPus();
	}

	/* PUS command Retrieved*/
	if ( bSuccess == TRUE ) {

		switch (xPusLocal.usiType) {
			case 250: /* srv-Type = 250 */
				switch ( xPusLocal.usiSubType )
				{
					case 60: /* TC_SCAM_CONFIG */
						#ifdef DEBUG_ON
							debug(fp,"MEB Task: Changing to Config Mode\n");
						#endif

						vEvtChangeMebMode(pxMebCLocal->eMode, sMebConfig);
						pxMebCLocal->eMode = sMebConfig;

	/*todo: URGENTE: Passar todos os FEE para modo de configuraï¿½ï¿½o  */
	/*todo: URGENTE: Data Controller e NFEE COntroller tambï¿½m  */

						vSendCmdQToNFeeCTRL( M_NFC_CONFIG, 0, 0 );
						OSTimeDlyHMSM(0,0,0,10);
						/* Stop Sync Generation */
						bStopSync();
						/* Clear all time code */
						for ( i=0 ; i<N_OF_NFEE; i++ ){
							bSpwcClearTimecode(&pxMebCLocal->xFeeControl.xNfee[i].xChannel.xSpacewire);
						}

						break;

					case 61: /* TC_SCAM_RUN */
						#ifdef DEBUG_ON
							debug(fp,"MEB Task: MEB already in the RUN Mode\n");
						#endif

						/* Do nothing */

						break;


					case 62: /* TC_SCAM_TURNOFF */
						#ifdef DEBUG_ON
							debug(fp,"MEB Task: Turnning OFF \n");
						#endif

						/* todo:Enviar emnsagens para a meb, e a meb distribui a mensagem */
						/* todo:Enviar Sinalizar Led quando puder desligar */

						break;
					default:
						#ifdef DEBUG_ON
							fprintf(fp, "MEB Task: Default - TC arrived-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xPusLocal.usiType, xPusLocal.usiSubType, xPusLocal.usiPusId );
						#endif
						break;
				}
				break;
			case 251: /* srv-Type = 251 */
				usiFeeInstL = xPusLocal.usiValues[0]; /* 0 is the NFEE instance */

				switch ( xPusLocal.usiSubType )
				{
					case 1: /* TC_SCAM_FEE_CONFIG_ENTER */
						#ifdef DEBUG_ON
							fprintf(fp,"\nMEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> FEE_CONFIG_ENTER \n\n");
						#endif

						vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_CONFIG, 0, usiFeeInstL );
						/* Build a function to send this command to the FEE instance */
						 /* Using QMASK send to NfeeControl that will forward */

						break;
					case 2: /* TC_SCAM_FEE_STANDBY_ENTER */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> FEE_STANDBY_ENTER \n");
						#endif

						/* Using QMASK send to NfeeControl that will foward */
						vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_STANDBY, 0, usiFeeInstL );

						break;
					case 5: /* TC_SCAM_FEE_CALIBRATION_TEST_ENTER */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_FEE_CALIBRATION_TEST_ENTER \n");
						#endif

						/* Using QMASK send to NfeeControl that will foward */
						vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_FULL_PATTERN, 0, usiFeeInstL );

						break;
					default:
						#ifdef DEBUG_ON
							fprintf(fp, "MEB Task: Default - TC arrived-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xPusLocal.usiType, xPusLocal.usiSubType, xPusLocal.usiPusId );
						#endif
						break;
				}
				break;
			case 252: /* srv-Type = 252 */
				usiFeeInstL = xPusLocal.usiValues[0]; /* 0 is the NFEE instance */


				switch ( xPusLocal.usiSubType )
				{
					case 3: /* TC_SCAM_SPW_LINK_ENABLE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_ENABLE \n");
						#endif

						/* todo: Usar as funï¿½ï¿½es de configuraï¿½ï¿½o disponibilizadas pelo Franï¿½a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configuraï¿½ï¿½es tranquilamente  */

						bSpwcGetLink(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bLinkStart = FALSE;
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bAutostart = TRUE;
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bDisconnect = FALSE;
						bSpwcSetLink(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);


						break;
					case 4: /* TC_SCAM_SPW_LINK_DISABLE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_DISABLE \n");
						#endif

						/* todo: Usar as funï¿½ï¿½es de configuraï¿½ï¿½o disponibilizadas pelo Franï¿½a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configuraï¿½ï¿½es tranquilamente  */
						/* Disable the link SPW */
						//todo: tratar retorno

						bSpwcGetLink(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bLinkStart = FALSE;
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bAutostart = FALSE;
						pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire.xLinkConfig.bDisconnect = TRUE;
						bSpwcSetLink(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xSpacewire);

						break;
					case 5: /* TC_SCAM_SPW_LINK_RESET */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_RESET \n");
						#endif

						/* todo: Usar as funï¿½ï¿½es de configuraï¿½ï¿½o disponibilizadas pelo Franï¿½a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configuraï¿½ï¿½es tranquilamente  */

						break;
					case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_RMAP_CONFIG_UPDATE \n");
							fprintf(fp,"WARNING: Operation Forbiden in Meb Running Mode. \n\n");
						#endif

						/* Do nothing */
						/* Return a PUS error? */

						break;
					default:
						#ifdef DEBUG_ON
							fprintf(fp, "MEB Task: Default - TC arrived-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xPusLocal.usiType, xPusLocal.usiSubType, xPusLocal.usiPusId );
						#endif

						break;
				}
				break;
			default:
				break;
		}
	}
}

void vSendCmdQToNFeeCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}

}

/* Send to FEEs using the NFEE Controller */
void vSendCmdQToNFeeCTRL_GEN( unsigned char ADDR,unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}

}


void vSendCmdQToDataCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPost(xQMaskDataCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgDataCTRL();
	}

}

void vMebChangeToConfig( TSimucam_MEB *pxMebCLocal ) {
	vEvtChangeMebMode(pxMebCLocal->eMode, sMebConfig);
	pxMebCLocal->eMode = sMebConfig;

/*todo: URGENTE: Passar todos os FEE para modo de configuraï¿½ï¿½o  */
/*todo: URGENTE: Data Controller e NFEE COntroller tambï¿½m  */

	vSendCmdQToNFeeCTRL( M_NFC_CONFIG, 0, 0 );
	vSendCmdQToDataCTRL( M_DATA_CONFIG, 0, 0 );

	/*todo: Para a geração do Sync  */


}

void vMebChangeToRunning( TSimucam_MEB *pxMebCLocal ) {
	#ifdef DEBUG_ON
		debug(fp,"MEB Task: Changing to RUN Mode\n");
	#endif

	vEvtChangeMebMode(pxMebCLocal->eMode, sRun);
	pxMebCLocal->eMode = sRun;

	vSendCmdQToNFeeCTRL( M_NFC_RUN, 0, 0 );
	vSendCmdQToDataCTRL( M_DATA_RUN, 0, 0 );


}
