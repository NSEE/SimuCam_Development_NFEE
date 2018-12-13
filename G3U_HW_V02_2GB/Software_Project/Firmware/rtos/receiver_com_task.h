/*
 * receiver_com.h
 *
 *  Created on: 11/12/2018
 *      Author: Tiago-Low
 */

#ifndef RECEIVER_COM_H_
#define RECEIVER_COM_H_

#include "../simucam_definitions.h"
#include "configuration_comm.h"
#include "../utils/crc8.h"
#include <string.h>

typedef enum { sConfiguring = 0, sPiping, sWaitingConn, sReceiving, sParsing, sSendingMEB , sHandlingError } tReceiverStates;

void vReceiverComTask(void *task_data);
bool bPreParser( char *buffer, tPreParsed *xPerParcedBuffer );



#endif /* RECEIVER_COM_H_ */
