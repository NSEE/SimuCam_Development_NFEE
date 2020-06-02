/*
 * communication_configs.h
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#ifndef COMMUNICATION_CONFIGS_H_
#define COMMUNICATION_CONFIGS_H_

#include "../simucam_definitions.h"
#include "error_handler_simucam.h"
#include "../rtos/tasks_configurations.h"
#include "crc8.h"
#include <ucos_ii.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>



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
#define ALL_INI_CHAR            "?!@#"
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
#define TURNOFF_SPRINTF         "?D:%hu"
#define RESET_SPRINTF         	"?R:%hu"
#define LOG_SPRINTF             "?L:%hu:%s"
#define LOG_SPRINTFERROR        "!L:%hu:%s"
//#define PUS_TM_SPRINTF          "!P:%hu:%hu:%hu:%hu:%hu:%hu%s|%hhu;"
#define PUS_TM_SPRINTF          "!P:%hu:%hu:%hu:%hu:%hu:%hu"
#define PUS_ADDER_SPRINTF       "%s:%hu"
/*======= Formats of Commands- UART==========*/
/*======= Standards messages - UART==========*/
#define NACK_SEQUENCE           "#|54;"
#define START_STATUS_SEQUENCE   "?S:1|38;"
/*======= Standards messages - UART==========*/
#define SIZE_RCV_BUFFER         128
#define SIZE_UCVALUES           32

typedef enum { eNoError = 0, eBadFormatInit, eCRCErrorInit, eSemErrorInit, eBadFormat, eCRCError } tErrorReceiver;


/*Semaphore that Receiver inform Sender that receive the initialization packet*/
extern OS_EVENT *xSemCommInit;

extern volatile unsigned short int usiIdCMD;

/*================================== Reader UART ================================*/

/* This structure will be used to send TM PUS packets through UART */
#define SIZE_TM_PUS_VALUES     128
#define N_PUS_PIPE     16
typedef struct {
    tErrorReceiver ucErrorFlag;
    bool bInUse;
    unsigned short int usiPid;
    unsigned short int usiCat;
    unsigned short int usiType;
    unsigned short int usiSubType;
    unsigned short int usiPusId;
    unsigned char ucNofValues;
    unsigned short int usiValues[SIZE_TM_PUS_VALUES];
} tTMPus;


typedef struct {
    bool bPUS;
    bool bInUse;
    unsigned short int usiPid;
    unsigned short int usiCat;
    unsigned short int usiType;
    unsigned short int usiSubType;
    unsigned short int usiPusId;
    unsigned char ucNofValues;
    unsigned char buffer_128[128];
    unsigned short int usiValues[SIZE_TM_PUS_VALUES];
} tTMPusChar_Sender;



#define N_OF_MEB_MSG_QUEUE      32
#define N_OF_LUT_MSG_QUEUE      8

/* This Queue will synchronize the MEB task for any action that it should be aware (PUS, CHANGES in the FEE) */
extern void *xMebQTBL[N_OF_MEB_MSG_QUEUE];
extern OS_EVENT *xMebQ;
extern OS_EVENT *xMutexPus;
extern volatile tTMPus xPus[N_PUS_PIPE];

extern void *xLutQTBL[N_OF_LUT_MSG_QUEUE];
extern OS_EVENT *xLutQ;


/*Struct used to parse the received command through UART*/
#define N_PREPARSED_ENTRIES     32
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
extern volatile tPreParsed xPreParsed[N_PREPARSED_ENTRIES];
extern volatile tPreParsed xPreParsedReader;

#define N_ACKS_RECEIVED        32
typedef struct {
    char cType; /* If Zero is empty and available*/
    char cCommand;
    unsigned short int usiId;
} txReceivedACK;

extern OS_EVENT *xSemCountReceivedACK;
extern OS_EVENT *xMutexReceivedACK;
extern volatile txReceivedACK xReceivedACK[N_ACKS_RECEIVED];


#define N_ACKS_SENDER        N_PREPARSED_ENTRIES
typedef struct {
    char cType; /* If Zero is empty and available*/
    char cCommand;
    unsigned short int usiId;
} txSenderACKs;

extern OS_EVENT *xSemCountSenderACK;
extern OS_EVENT *xMutexSenderACK;
extern OS_EVENT *xMutexTranferBuffer;
extern volatile txSenderACKs xSenderACK[N_ACKS_SENDER];


/*================================== Reader UART ================================*/

/* ============ Session to save the messages waiting for ack or for (re)transmiting ================ */
#define N_RETRIES_INI_INF       250
#define N_RETRIES_COMM          1       /* N + 1 */
#define INTERVAL_RETRIES        3000    /* Milliseconds */
#define TIMEOUT_COMM            5000    /* Milliseconds */
#define TIMEOUT_COUNT           1//( (unsigned short int) TIMEOUT_COMM / INTERVAL_RETRIES)

#define N_RET_MUTEX_TX                  2
#define N_RET_MUTEX_RETRANS             4
#define N_RET_SEM_FOR_SPACE             2
#define TICKS_WAITING_MUTEX_TX          20     /* Ticks */
#define TICKS_WAITING_MUTEX_RETRANS     50     /* Ticks */
#define TICKS_WAITING_FOR_SPACE         20    /* Ticks */

#define MAX_RETRIES_ACK_IN              40


#define N_512   16
typedef struct {
    char buffer[512];
    bool bSent;     /* Indicates if it was already transmited */
    unsigned short int usiId; /* If Zero is empty and available*/
    short int usiTimeOut; /*seconds*/
    unsigned char ucNofRetries;
} txBuffer512;

#define N_128   32
typedef struct {
    char buffer[128];
    bool bSent;     /* Indicates if it was already transmited */
    unsigned short int usiId; /* If Zero is empty and available*/
    short int usiTimeOut; /*seconds*/
    unsigned char ucNofRetries;
} txBuffer128;

#define N_64   8
typedef struct {
    char buffer[64];
    bool bSent;     /* Indicates if it was already transmited */
    unsigned short int usiId; /* If Zero is empty and available*/
    short int usiTimeOut; /*seconds*/
    unsigned char ucNofRetries;
} txBuffer64;

#define N_32   8
typedef struct {
    char buffer[32];
    bool bSent;     /* Indicates if it was already transmited */
    unsigned short int usiId; /* If Zero is empty and available*/
    short int usiTimeOut; /*seconds*/
    unsigned char ucNofRetries;
} txBuffer32;

/* This struct was made to perform some operation of verification faster */
typedef struct {
	bool b512[N_512];
    bool b128[N_128];
    bool b64[N_64];
    bool b32[N_32];
} tInUseRetransBuffer;


/*  Before access the any buffer for transmission the task should check in the Count Semaphore if has resource available
    if there is buffer free, the task should try to get the mutex in order to protect the integrity of the buffer */
extern volatile unsigned char SemCount512;
extern volatile unsigned char SemCount128;
extern OS_EVENT *xSemCountBuffer128;
extern OS_EVENT *xSemCountBuffer512;
extern OS_EVENT *xMutexBuffer128;
extern txBuffer128 xBuffer128[N_128];
extern txBuffer512 xBuffer512[N_512];

extern volatile unsigned char SemCount64;
extern OS_EVENT *xSemCountBuffer64;
extern OS_EVENT *xMutexBuffer64;
extern txBuffer64 xBuffer64[N_64];

extern volatile unsigned char SemCount32;
extern OS_EVENT *xSemCountBuffer32;
extern OS_EVENT *xMutexBuffer32;
extern txBuffer32 xBuffer32[N_32];

#define N_128_SENDER   24
extern tTMPusChar_Sender xBuffer128_Sender[N_128_SENDER];

/* ============ Session to save the messages waiting for ack or for (re)transmiting ================ */
extern tInUseRetransBuffer xInUseRetrans;



#endif /* COMMUNICATION_CONFIGS_H_ */
