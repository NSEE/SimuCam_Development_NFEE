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
	INT8U error_code;

	pxFeeC = (TNFee_Control *) task_data;

	#ifdef DEBUG_ON
        debug(fp,"NFee Controller Task. (Task on)\n");
    #endif

	for (;;) {

		/* Tem os mesmos estados que o SIMUCAM : Config e Running */
		/* No config ou a Meb ira configurar sozinha os FEEs e os controladores ou irá passar a mensagem completa sem usar a QueueMask */
		/* No modo Running o NFEE control só utiliza o Queue MAsk pois é mais rapido e só transmite no Qmask tbm */

		OSTimeDlyHMSM(0, 0, 0, 500); /*todo:Tirar depois do debug*/
	}

}
