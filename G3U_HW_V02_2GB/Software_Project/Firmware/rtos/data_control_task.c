/*
 * data_control_task.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */



#include "data_control_task.h"


void vDataControlTask(void *task_data) {
	bool bSuccess = FALSE;
	TNData_Control *pxDataC;
	INT8U error_code;


	pxDataC = (TNData_Control *) task_data;

	#ifdef DEBUG_ON
        debug(fp,"Data Controller Task. (Task on)\n");
    #endif

    pxDataC->bUpdateComplete = TRUE;
	for (;;) {
		OSTimeDlyHMSM(0, 0, 10, 0);; /*todo:Tirar depois do debug*/
	}

}
