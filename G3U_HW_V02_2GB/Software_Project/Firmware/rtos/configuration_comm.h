/*
 * configuration_comm.h
 *
 *  Created on: 13/12/2018
 *      Author: Tiago-Low
 */

#ifndef CONFIGURATION_COMM_H_
#define CONFIGURATION_COMM_H_

#include <ucos_ii.h>
#include <stdlib.h>

/*======= Delimiters - UART==========*/
#define SEPARATOR_CHAR          ':'
#define START_REQUEST_CHAR      '?'
#define START_REPLY_CHAR        '!'
/*======= Delimiters - UART==========*/
/*======= Type of commands - UART==========*/
#define ACK_CHAR                '@'
#define NACK_CHAR               '#'
#define FINAL_CHAR              ';'
#define SEPARATOR_CRC           '|'
/*======= Type of commands - UART==========*/
/*======= Set of commands - UART==========*/
#define ETH_CMD                 'C'
#define NUC_STATUS_CMD          'S'
#define POWER_OFF_CMD           'D'
#define PUS_CMD                 'P'
#define HEART_BEAT_CMD          'H'
/*======= Set of commands - UART==========*/
/*======= Standards messages - UART==========*/
#define NACK_SEQUENCE           "#|54;"
#define TURNOFF_SEQUENCE        "?D|252;"
#define START_STATUS_SEQUENCE   "?S|9;"
/*======= Standards messages - UART==========*/
#define CHANGE_MODE_SEQUENCE    65000
#define SIZE_RCV_BUFFER         64
#define SIZE_UCVALUES           32

typedef enum { eNoError = 0, eBadFormatInit, eCRCErrorInit, eSemErrorInit, eBadFormat, eCRCError } tErrorReceiver;

/*Struct used to parse the received command through UART*/
typedef struct {
    tErrorReceiver ucErrorFlag;
    char cType; /* ?(request):0 or !(reply):1*/
    char cCommand;
    unsigned char ucNofBytes;
    unsigned short int usiValues[SIZE_UCVALUES]; /*The first is always, ALWAYS the id of the command. Max size of parsed value is 6 digits, for now*/
    unsigned char ucCalculatedCRC8;
    unsigned char ucMessageCRC8;
} tPreParsed;

/*Semaphore that Receiver inform Sender that receive the initialization packet*/
extern OS_EVENT *xSemCommInit;

/*Struct that the Sender task use to process the command and fill the command*/
typedef struct {
    char ucType; /* ?(request):0 or !(reply):1*/
    char cCommand;
    void *pxStruct; /*Pointer for any generic struct that holds information about the command*/
} tCommandSender;

typedef struct {
    unsigned char ucSize;
    unsigned char ucStart;
    unsigned char ucEnd;

} tFifoSender;
tCommandSender *xQSenderTaskTbl[SENDER_QUEUE_SIZE]; /*Can hold upto N command to process : N = SENDER_QUEUE_SIZE*/


#endif /* CONFIGURATION_COMM_H_ */
