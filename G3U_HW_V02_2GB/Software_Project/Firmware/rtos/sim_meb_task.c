/*
 * sim_meb_task.c
 *
 *  Created on: 13/01/2019
 *      Author: TiagoLow
 */


#include "sim_meb_task.h"


void vSimMebTask(void *task_data) {
	TSimucam_MEB *pxMebC;
	unsigned int uiCmdMeb = 0;
	INT8U error_code;

	pxMebC = (TSimucam_MEB *) task_data;

	#ifdef DEBUG_ON
        debug(fp,"Sim-Meb Controller Task. (Task on)\n");
    #endif

	for (;;) {

		switch ( pxMebC->eMode )
		{
			case sMebConfig:

				uiCmdMeb = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Parse the cmd that comes in the Queue */
					switch (uiCmdMeb) {
						/* Receive a PUS command */
						case Q_MEB_PUS:
							vPusMebInTaskConfigMode( pxMebC );
							break;
						default:
							break;
					}

				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetCmdQueueMeb();
				}

				break;
			case sRun:
				/* code */
				break;
			default:
				break;
		}
	}
}

/* This function should treat the PUS command in the Config Mode, need check all the things that is possible to update in this mode */
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
						#ifdef DEBUG_ON
							debug(fp,"MEB Task: Changing to RUN Mode\n");
						#endif

							vEvtChangeMebMode(pxMebCLocal->eMode, sRun);
							pxMebCLocal->eMode = sRun;
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
							fprintf(fp,"     -> FEE_CONFIG_ENTER \n");
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
						#endif

						/* todo: Usar as fun��es de configura��o disponibilizadas pelo Fran�a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configura��es tranquilamente  */

						break;
					case 4: /* TC_SCAM_SPW_LINK_DISABLE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_ENABLE \n");
						#endif

						/* todo: Usar as fun��es de configura��o disponibilizadas pelo Fran�a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configura��es tranquilamente  */

						break;
					case 5: /* TC_SCAM_SPW_LINK_RESET */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_ENABLE \n");
						#endif

						/* todo: Usar as fun��es de configura��o disponibilizadas pelo Fran�a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configura��es tranquilamente  */

						break;
					case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_RMAP_CONFIG_UPDATE \n");
						#endif
							/* todo: Usar libs do Fran�a para atualizar o link com os valores abaixo*/
						xPusLocal.usiValues[2];
						xPusLocal.usiValues[3];
						xPusLocal.usiValues[4];
						xPusLocal.usiValues[5];
						xPusLocal.usiValues[6];
						xPusLocal.usiValues[7];

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

	/*todo: URGENTE: Passar todos os FEE para modo de configura��o  */
	/*todo: URGENTE: Data Controller e NFEE COntroller tamb�m  */


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
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> FEE_CONFIG_ENTER \n");
						#endif

						/* Build a function to send this command to the FEE instance */
						 /* Using QMASK send to NfeeControl that will foward */

						break;
					case 2: /* TC_SCAM_FEE_STANDBY_ENTER */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> FEE_STANDBY_ENTER \n");
						#endif

						/* Using QMASK send to NfeeControl that will foward */

						break;
					case 5: /* TC_SCAM_FEE_CALIBRATION_TEST_ENTER */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> FEE_STANDBY_ENTER \n");
						#endif

						/* Using QMASK send to NfeeControl that will foward */

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

						/* todo: Usar as fun��es de configura��o disponibilizadas pelo Fran�a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configura��es tranquilamente  */

						break;
					case 4: /* TC_SCAM_SPW_LINK_DISABLE */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_ENABLE \n");
						#endif

						/* todo: Usar as fun��es de configura��o disponibilizadas pelo Fran�a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configura��es tranquilamente  */

						break;
					case 5: /* TC_SCAM_SPW_LINK_RESET */
						#ifdef DEBUG_ON
							fprintf(fp,"MEB Task: CMD to NFEE-%hu \n", usiFeeInstL);
							fprintf(fp,"     -> TC_SCAM_SPW_LINK_ENABLE \n");
						#endif

						/* todo: Usar as fun��es de configura��o disponibilizadas pelo Fran�a  */
						/* todo: Como a Meb esta em config ela pode operar todas as configura��es tranquilamente  */

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


