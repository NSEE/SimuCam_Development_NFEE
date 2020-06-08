/*
 * receiver_uart_task.h
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#ifndef RECEIVER_UART_TASK_H_
#define RECEIVER_UART_TASK_H_

#include "../utils/communication_utils.h"
#include "../utils/communication_configs.h"



typedef enum { sRConfiguring = 0, sGetRxUart, sSendToParser, sSendToACKReceiver } tReaderStates;


void vReceiverUartTask(void *task_data);
bool bPreParser( char *buffer, tPreParsed *xPerParcedBuffer );
bool setPreParsedFreePos( tPreParsed *xPrePReader );
bool setPreAckSenderFreePos( tPreParsed *xPrePReader );
bool setPreAckReceiverFreePos( tPreParsed *xPrePReader );

/*Version 2*/
bool bPreParserV2( char *buffer, tPreParsed *xPerParcedBuffer );


#endif /* RECEIVER_UART_TASK_H_ */
