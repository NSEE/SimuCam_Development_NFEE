/*
 * fee_task1.h
 *
 *  Created on: 22/03/2019
 *      Author: Tiago-note
 */

#ifndef FEE_TASK1_H_
#define FEE_TASK1_H_

#include "fee_task.h"
#include "../simucam_definitions.h"
#include "tasks_configurations.h"
#include "../utils/ccd.h"
#include "../utils/fee.h"
#include "../utils/meb.h"
#include "../driver/comm/spw_controller/spw_controller.h"
#include "../driver/comm/comm_channel.h"
#include "../utils/queue_commands_list.h"
#include "../api_driver/simucam_dma/simucam_dma.h"
#include "../driver/comm/data_packet/data_packet.h"
#include "../driver/comm/rmap/rmap.h"

void vFeeTask1(void *task_data);


#endif /* FEE_TASK1_H_ */
