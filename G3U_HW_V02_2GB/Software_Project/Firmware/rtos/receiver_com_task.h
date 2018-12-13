/*
 * receiver_com.h
 *
 *  Created on: 11/12/2018
 *      Author: Tiago-Low
 */

#ifndef RECEIVER_COM_H_
#define RECEIVER_COM_H_

#include "../simucam_definitions.h"
#include "../utils/crc8.h"
#include <string.h>

typedef enum { sConfiguring = 0, sPiping, sWaitingConn, sReceiving, sParsing, sSendingMEB , sHandlingError } tReceiverStates;
#define SIZE_RCV_BUFFER         64
#define CHANGE_MODE_SEQUENCE    "{!};&"
#define SEPARATOR_CHAR          ':'
#define START_REQUEST_CHAR      '?'
#define START_REPLY_CHAR        '!'
#define FINAL_CHAR              ';'
#define SEPARATOR_CRC           '|'
#define SIZE_UCVALUES            32

typedef struct {
    unsigned char ucType; /* ?(request):0 or !(reply):1*/
    char cCommand;
    unsigned short int usiValues[SIZE_UCVALUES]; /* Max size of parsed value is 6 digits, for now*/
    unsigned char ucCalculatedCRC8;
    unsigned char ucMessageCRC8;
} tPreParsed;



void vReceiverComTask(void *task_data);
bool vPreParser( const char *buffer, tPreParsed *xPerParcedBuffer );


#endif /* RECEIVER_COM_H_ */
