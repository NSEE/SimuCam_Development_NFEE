/*
 * data_control_task.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */



#include "nfee_control_task.h"


void vNFeeControlTask(void *task_data) {
	bool bSuccess = FALSE;
	TNFee_Control * pxFeeC;
	tQMask uiCmdNFC;
	INT8U error_code;

	pxFeeC = (TNFee_Control *) task_data;

	#ifdef DEBUG_ON
        debug(fp,"NFee Controller Task. (Task on)\n");
    #endif

	for (;;) {

		/* todo: Tem os mesmos estados que o SIMUCAM : Config e Running */
		/* todo: No config ou a Meb ira configurar sozinha os FEEs e os controladores ou ir� passar a mensagem completa sem usar a QueueMask */
		/* todo: No modo Running o NFEE control s� utiliza o Queue MAsk pois � mais rapido e s� transmite no Qmask tbm */

		
		switch (pxFeeC->eMode)
		{
			case sMebConfig:
				
				uiCmdNFC.ulWord = (unsigned int)OSQPend(xQMaskCMDNFeeCtrlTBL, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Check if the command is for NFEE Controller */
					if ( uiCmdNFC.ucByte[3] == M_FEE_CTRL_ADDR ) {
						/* Parse the cmd that comes in the Queue */
						switch (uiCmdNFC.ucByte[2]) {
							/* Receive a PUS command */
							case XXXXX:
								//vPusMebInTaskConfigMode( pxMebC );
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
					vCouldNotGetQueueMaskNfeeCtrl();
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
