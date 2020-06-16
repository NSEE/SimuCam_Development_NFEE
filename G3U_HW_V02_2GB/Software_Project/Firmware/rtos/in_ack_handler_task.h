/*
 * in_ack_handler_task.h
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#ifndef IN_ACK_HANDLER_TASK_H_
#define IN_ACK_HANDLER_TASK_H_

#include "../utils/communication_configs.h"


typedef enum { sRAConfiguring = 0, sRAGettingACK, sRACleanningBuffer } tReceiverACKState;

void vInAckHandlerTask(void *task_data);
void vInAckHandlerTaskV2(void *task_data);
bool bCheckInAck32( txReceivedACK *xRecAckL , bool *bFinished );
bool bCheckInAck64( txReceivedACK *xRecAckL , bool *bFinished );
bool bCheckInAck128( txReceivedACK *xRecAckL , bool *bFinished );
bool bCheckInAck512( txReceivedACK *xRecAckL , bool *bFinished );

#endif /* IN_ACK_HANDLER_TASK_H_ */
