/*
 * out_ack_handler_task.h
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#ifndef OUT_ACK_HANDLER_TASK_H_
#define OUT_ACK_HANDLER_TASK_H_

#include "../utils/communication_configs.h"

typedef enum { sSAConfiguring = 0, sSAGettingACK, sSASending } tSerderACKState;

void vOutAckHandlerTask(void *task_data);

#endif /* OUT_ACK_HANDLER_TASK_H_ */
