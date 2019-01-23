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
		break; /*todo:Tirar depois do debug*/
	}

}
