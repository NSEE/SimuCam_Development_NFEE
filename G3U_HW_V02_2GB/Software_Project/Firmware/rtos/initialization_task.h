/*
 * initialization_task.h
 *
 *  Created on: 27/11/2018
 *      Author: Tiago-Low
 */

#ifndef INITIALIZATION_TASK_H_
#define INITIALIZATION_TASK_H_

#include <ucos_ii.h>
#include "tasks_configurations.h"
#include "nfee_control_taskV3.h"
#include "data_control_taskV2.h"
#include "fee_taskV3.h"
#include "sim_meb_task.h"
#include "sender_com_task.h"
#include "receiver_uart_task.h"
#include "parser_comm_task.h"
#include "in_ack_handler_task.h"
#include "out_ack_handler_task.h"
#include "timeout_checker_ack_task.h"
#include "stack_monitor_task.h"
#include "../utils/meb.h"
#include "../utils/error_handler_simucam.h"
#include "sync_reset_task.h"    /* bndky */
#include "lut_handler_task.h"

void vInitialTask(void *task_data);


#endif /* INITIALIZATION_TASK_H_ */
