/*
 * lut_handler_task.h
 *
 *  Created on: 17 de mar de 2020
 *      Author: Tiago-note
 */

#ifndef RTOS_LUT_HANDLER_TASK_H_
#define RTOS_LUT_HANDLER_TASK_H_


#include "../simucam_definitions.h"
#include "tasks_configurations.h"
#include "../utils/lut_handler.h"
#include "../utils/meb.h"
#include "../utils/queue_commands_list.h"
#include "../api_driver/simucam_dma/simucam_dma.h"
#include "../driver/comm/data_packet/data_packet.h"
#include "../driver/comm/windowing/windowing.h"
#include "../utils/communication_configs.h"
#include "../utils/error_handler_simucam.h"
#include "../driver/ftdi/ftdi.h"

void vLutHandlerTask(void *task_data);
void vQCmdLUTCmd( TSimucam_MEB *pxMebCP, unsigned int cmd );
void vQCmdLUTWaitIRQFinish( TSimucam_MEB *pxMebCP, unsigned int cmd );



#endif /* RTOS_LUT_HANDLER_TASK_H_ */
