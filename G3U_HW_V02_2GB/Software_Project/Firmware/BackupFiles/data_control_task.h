/*
 * data_control_task.h
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */

#ifndef DATA_CONTROL_TASK_H_
#define DATA_CONTROL_TASK_H_

#include "tasks_configurations.h"
#include "../simucam_definitions.h"
#include "../utils/data_controller.h"
#include "../utils/queue_commands_list.h"
#include "../utils/communication_configs.h"
#include "../utils/events_handler.h"
#include "../driver/ftdi/ftdi.h"
#include "../api_driver/simucam_dma/simucam_dma.h"


void vDataControlTask(void *task_data);

bool bSendMSGtoSimMebTaskDTC( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
void vPerformActionDTCConfig( unsigned int uiCmdParam, TNData_Control *pxFeeCP );
void vPerformActionDTCRun( unsigned int uiCmdParam, TNData_Control *pxFeeCP );
void vPerformActionDTCFillingMem( unsigned int uiCmdParam, TNData_Control *pxFeeCP );


#endif /* DATA_CONTROL_TASK_H_ */
