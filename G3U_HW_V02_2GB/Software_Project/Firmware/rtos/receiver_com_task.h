/*
 * receiver_com.h
 *
 *  Created on: 11/12/2018
 *      Author: Tiago-Low
 */

#ifndef RECEIVER_COM_H_
#define RECEIVER_COM_H_

#include "../simucam_definitions.h"
#include "../utils/configs_simucam.h"
#include "configuration_comm.h"
#include "../utils/crc8.h"
#include "../utils/configs_simucam.h"
#include <string.h>
#include <ctype.h>

typedef enum { sConfiguring = 0, sPiping, sWaitingConn, sReceiving, sInitPreParsing, sPreParsing, sRequestParsing, sReplyParsing, sSendingMEB , sHandlingError } tReceiverStates;

void vReceiverComTask(void *task_data);
bool bPreParser( char *buffer, tPreParsed *xPerParcedBuffer );
short int siPosStr( char *buffer, char cValue);
tReceiverStates tErrorHandlerFunc( tPreParsed *xPerParcedBuffer );
bool bSendNack ( void );
unsigned short int usiGetIdCMD ( void );


#endif /* RECEIVER_COM_H_ */
