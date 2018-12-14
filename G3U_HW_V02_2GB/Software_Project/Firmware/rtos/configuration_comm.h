/*
 * configuration_comm.h
 *
 *  Created on: 13/12/2018
 *      Author: Tiago-Low
 */

#ifndef CONFIGURATION_COMM_H_
#define CONFIGURATION_COMM_H_

#include <ucos_ii.h>

#define SIZE_RCV_BUFFER         64
#define TURNOFF_SEQUENCE        "?D|252;"
#define START_STATUS_SEQUENCE   "?S|9;"
#define CHANGE_MODE_SEQUENCE    "!U:&$=|&;"
#define SEPARATOR_CHAR          ':'
#define START_REQUEST_CHAR      '?'
#define START_REPLY_CHAR        '!'
#define FINAL_CHAR              ';'
#define SEPARATOR_CRC           '|'
#define SIZE_UCVALUES           32


typedef struct {
    unsigned char ucType; /* ?(request):0 or !(reply):1*/
    char cCommand;
    unsigned char ucNofBytes;
    unsigned short int usiValues[SIZE_UCVALUES]; /* Max size of parsed value is 6 digits, for now*/
    unsigned char ucCalculatedCRC8;
    unsigned char ucMessageCRC8;
} tPreParsed;

extern OS_EVENT *xSemCommInit;

#endif /* CONFIGURATION_COMM_H_ */
