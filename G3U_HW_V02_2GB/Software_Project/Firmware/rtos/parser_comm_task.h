/*
 * parser_comm_task.h
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#ifndef PARSER_COMM_TASK_H_
#define PARSER_COMM_TASK_H_

#include "../driver/comm/comm.h"
#include "../utils/queue_commands_list.h"
#include "../utils/communication_configs.h"
#include "../utils/communication_utils.h"
#include "../utils/log_manager_simucam.h"
#include "../driver/reset/reset.h"
#include "../utils/fee_controller.h"
#include "../utils/meb.h"
#include "../utils/defaults.h"

typedef enum { sConfiguring = 0, sWaitingMessage, sRequestParsing, sReplyParsing, sPusHandling, sHandlingError } tParserStates;

void vParserCommTask(void *task_data);
bool getPreParsedPacket( tPreParsed *xPreParsedParser );
unsigned short int usiGetIdCMD ( void );
bool bSendMessagePUStoMebTask( tTMPus *xPusL );

#endif /* PARSER_COMM_TASK_H_ */
