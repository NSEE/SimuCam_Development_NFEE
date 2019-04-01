/*
 * fee_task3.h
 *
 *  Created on: 29/03/2019
 *      Author: TiagoLow
 */

#ifndef FEE_TASK3_H_
#define FEE_TASK3_H_

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

extern const char *cTemp[64];

void vFeeTask3(void *task_data);

#endif /* FEE_TASK3_H_ */
