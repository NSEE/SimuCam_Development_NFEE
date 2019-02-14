/*
 * data_control_task.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */



#include "data_control_task.h"

/* 0% Ready! */
void vDataControlTask(void *task_data) {
	tQMask uiCmdDTC;
	INT8U error_code;
	TNData_Control *pxDataC;


	pxDataC = (TNData_Control *) task_data;

	#ifdef DEBUG_ON
        debug(fp,"Data Controller Task. (Task on)\n");
    #endif

    pxDataC->bUpdateComplete = TRUE;

    error_code = OSQFlush(xQMaskDataCtrl);
	if ( error_code != OS_NO_ERR ) {
		vFailFlushQueueData();
	}

	for (;;) {

		uiCmdDTC.ulWord = (unsigned int)OSQPend(xQMaskDataCtrl, 0, &error_code); /* Blocking operation */
		if ( error_code == OS_ERR_NONE ) {

			/* Check if the command is for NFEE Controller */
			if ( uiCmdDTC.ucByte[3] == M_DATA_CTRL_ADDR ) {

				/* todo: For now, do nothing */

			} else {

				/* todo: For now, do nothing */
			}
		}
		OSTimeDlyHMSM(0, 0, 5, 0); /*todo:Tirar depois do debug*/
	}

}
