/*
 * receiver_ack_task.h
 *
 *  Created on: 26/12/2018
 *      Author: Tiago-Low
 */

#ifndef RECEIVER_ACK_TASK_H_
#define RECEIVER_ACK_TASK_H_

#include "../simucam_definitions.h"
#include "configuration_comm.h"
#include "../utils/crc8.h"
#include <string.h>
#include <ctype.h>


typedef enum { sRAConfiguring = 0, sRAGettingACK, sRACleanningBuffer } tReceiverACKState;

void vReceiverAckTask(void *task_data);

#endif /* RECEIVER_ACK_TASK_H_ */
