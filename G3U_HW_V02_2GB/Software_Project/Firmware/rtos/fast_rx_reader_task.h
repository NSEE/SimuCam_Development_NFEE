/*
 * fast_rx_reader_task.h
 *
 *  Created on: 19/12/2018
 *      Author: Tiago-Low
 */

#ifndef FAST_RX_READER_TASK_H_
#define FAST_RX_READER_TASK_H_

#include "../simucam_definitions.h"
#include "../utils/configs_simucam.h"
#include "configuration_comm.h"
#include "../utils/crc8.h"
#include "../utils/configs_simucam.h"
#include <string.h>
#include <ctype.h>


typedef enum { sRConfiguring = 0, sRPiping, sRReceiving, sSendToParser, sSendToACKReceiver, sHandlingError } tReaderStates;


void vFastReaderRX(void *task_data);
bool bPreParser( char *buffer, tPreParsed *xPerParcedBuffer );
bool setPreParsedFreePos( tPreParsed *xPrePReader );
bool setPreAckSenderFreePos( tPreParsed *xPrePReader );
bool setPreAckReceiverFreePos( tPreParsed *xPrePReader );


#endif /* FAST_RX_READER_TASK_H_ */
