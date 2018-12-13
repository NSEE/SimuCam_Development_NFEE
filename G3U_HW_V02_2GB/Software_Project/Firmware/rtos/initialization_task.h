/*
 * initialization_task.h
 *
 *  Created on: 27/11/2018
 *      Author: Tiago-Low
 */

#ifndef INITIALIZATION_TASK_H_
#define INITIALIZATION_TASK_H_

#include "simcam_tasks_configurations.h"
#include "rtos/sender_com_task.h"
#include "rtos/receiver_com_task.h"
#include "error_handler_simucam.h"

void vInitialTask(void *task_data);


#endif /* INITIALIZATION_TASK_H_ */
