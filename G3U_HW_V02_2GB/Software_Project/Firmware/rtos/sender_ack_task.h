/*
 * sender_ack_task.h
 *
 *  Created on: 26/12/2018
 *      Author: Tiago-Low
 */

#ifndef SENDER_ACK_TASK_H_
#define SENDER_ACK_TASK_H_

#include "../simucam_definitions.h"
#include "configuration_comm.h"
#include "../utils/configs_simucam.h"
#include <string.h>
#include <ctype.h>


typedef enum { sSAConfiguring = 0, sSAGettingACK, sSASending } tSerderACKState;

void vSenderAckTask(void *task_data);

#endif /* SENDER_ACK_TASK_H_ */
