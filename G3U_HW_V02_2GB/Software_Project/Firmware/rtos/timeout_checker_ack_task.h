/*
 * timeout_ack_task.h
 *
 *  Created on: 28/12/2018
 *      Author: Tiago-Low
 */

#ifndef TIMEOUT_ACK_TASK_H_
#define TIMEOUT_ACK_TASK_H_

#include "tasks_configurations.h"
#include "../utils/communication_configs.h"
#include "../utils/communication_utils.h"


void vTimeoutCheckerTask(void *task_data);
void vTimeoutCheckerTaskv2(void *task_data);
void vCheck( void );
void vCheckRetransmission512( void );
void vCheckRetransmission128( void );
void vCheckRetransmission64( void );
void vCheckRetransmission32( void );

#endif /* TIMEOUT_ACK_TASK_H_ */
