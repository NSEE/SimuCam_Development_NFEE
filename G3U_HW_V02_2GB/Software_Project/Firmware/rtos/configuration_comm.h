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
#define FINAL_CHAR              ';'
#define SEPARATOR_CRC           '|'
/*======= Delimiters - UART==========*/
/*======= Type of commands - UART==========*/
#define ACK_CHAR                '@'
#define NACK_CHAR               '#'
#define START_REQUEST_CHAR      '?'
#define START_REPLY_CHAR        '!'
/*======= Type of commands - UART==========*/
/*======= Set of commands - UART==========*/
#define ETH_CMD                 'C'
#define NUC_STATUS_CMD          'S'
#define POWER_OFF_CMD           'D'
#define PUS_CMD                 'P'
#define HEART_BEAT_CMD          'H'
/*======= Set of commands - UART==========*/
/*======= Formats of Commands - UART==========*/
#define ETH_SPRINTF             "!%c:%hu:%hu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hhu:%hu" /*id,dhcp,ip,sub,gw,dns,port*/
#define ACK_SPRINTF             "@%c:%hu"
/*======= Formats of Commands- UART==========*/
/*======= Standards messages - UART==========*/
#define NACK_SEQUENCE           "#|54;"
#define TURNOFF_SEQUENCE        "?D|252;"
#define START_STATUS_SEQUENCE   "?S|9;"
/*======= Standards messages - UART==========*/
#define CHANGE_MODE_SEQUENCE    65000
#define SIZE_RCV_BUFFER         64
#define SIZE_UCVALUES           32

typedef enum { eNoError = 0, eBadFormatInit, eCRCErrorInit, eSemErrorInit, eBadFormat, eCRCError } tErrorReceiver;


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

extern unsigned short int usiIdCMD;


/*================================== Reader UART ================================*/

/*Struct used to parse the received command through UART*/
#define N_PREPARSED_ENTRIES     4
typedef struct {
    tErrorReceiver ucErrorFlag;
    char cType; /* ?(request):0 or !(reply):1*/
    char cCommand;
    unsigned char ucNofBytes;
    unsigned short int usiValues[SIZE_UCVALUES]; /*The first is always, ALWAYS the id of the command. Max size of parsed value is 6 digits, for now*/
    unsigned char ucCalculatedCRC8;
    unsigned char ucMessageCRC8;
} tPreParsed;

extern OS_EVENT *xSemCountPreParsed;
extern OS_EVENT *xMutexPreParsed;
extern tPreParsed xPreParsed[N_PREPARSED_ENTRIES];
extern tPreParsed xPreParsedReader;

#define N_ACKS_RECEIVED        4
typedef struct {
    char cType;
    char cCommand;
    unsigned short int usiId;
} txReceivedACK;

extern OS_EVENT *xSemCountReceivedACK;
extern OS_EVENT *xMutexReceivedACK;
extern txReceivedACK xReceivedACK[N_ACKS_RECEIVED];


#define N_ACKS_SENDER        N_PREPARSED_ENTRIES
typedef struct {
    char cType;
    char cCommand;
    unsigned short int usiId;
} txSenderACKs;

extern OS_EVENT *xSemCountSenderACK;
extern OS_EVENT *xMutexSenderACK;
extern txSenderACKs xSenderACK[N_ACKS_SENDER];


/*================================== Reader UART ================================*/

/* ============ Session to save the messages waiting for ack or for (re)transmiting ================ */
#define N_RETRIES_COMM          3
#define INTERVAL_RETRIES        1000    /* Milliseconds */
#define TIMEOUT_COMM            3000    /* Milliseconds */
#define TIMEOUT_COUNT           ( (unsigned short int) TIMEOUT_COMM / INTERVAL_RETRIES)

#define TICKS_WAITING_FOR_SPACE 200     /* Ticks */

#define N_128   2
typedef struct {
    char buffer[128];
    unsigned short int usiId; /* If Zero is empty and available*/
    unsigned short int usiTimeOut;
    unsigned char ucNofRetries;
} txBuffer128;

#define N_64   4
typedef struct {
    char buffer[64];
    unsigned short int usiId; /* If Zero is empty and available*/
    unsigned short int usiTimeOut;
    unsigned char ucNofRetries;
} txBuffer64;

#define N_32   8
typedef struct {
    char buffer[32];
    unsigned short int usiId; /* If Zero is empty and available*/
    unsigned short int usiTimeOut;
    unsigned char ucNofRetries;
} txBuffer32;

/*  Before access the any buffer for transmission the task should check in the Count Semaphore if has resource available
    if there is buffer free, the task should try to get the mutex in order to protect the integrity of the buffer */

extern OS_EVENT *xSemCountBuffer128;
extern OS_EVENT *xMutexBuffer128;
extern txBuffer128 xBuffer128[N_128];

extern OS_EVENT *xSemCountBuffer64;
extern OS_EVENT *xMutexBuffer64;
extern txBuffer64 xBuffer64[N_64];

extern OS_EVENT *xSemCountBuffer32;
extern OS_EVENT *xMutexBuffer32;
extern txBuffer32 xBuffer32[N_32];

/* ============ Session to save the messages waiting for ack or for (re)transmiting ================ */



#endif /* CONFIGURATION_COMM_H_ */
