/*
 * parser_rx_task.h
 *
 *  Created on: 19/12/2018
 *      Author: Tiago-Low
 */

#ifndef PARSER_RX_TASK_H_
#define PARSER_RX_TASK_H_

#include "../simucam_definitions.h"
#include "../utils/configs_simucam.h"
#include "configuration_comm.h"
#include "../utils/crc8.h"
#include "../utils/configs_simucam.h"
#include <string.h>
#include <ctype.h>

typedef enum { sConfiguring = 0, sWaitingConn, sRequestParsing, sReplyParsing, sHandlingError } tParserStates;


void vParserRXTask(void *task_data);

#endif /* PARSER_RX_TASK_H_ */
