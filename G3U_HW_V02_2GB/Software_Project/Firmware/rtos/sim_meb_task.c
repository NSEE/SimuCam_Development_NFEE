/*
 * sim_meb_task.c
 *
 *  Created on: 13/01/2019
 *      Author: TiagoLow
 */


#include "sim_meb_task.h"


void vSimMebTask(void *task_data) {
	bool bSuccess = FALSE;
	TSimucam_MEB * pxMebC;
	INT8U error_code;

	pxMebC = (TSimucam_MEB *) task_data;

	#ifdef DEBUG_ON
        debug(fp,"Sim Meb Controller Task. (Task on)\n");
    #endif

	for (;;) {
		break; /*todo:Tirar depois do debug*/
	}

}
