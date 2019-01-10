/*
 * simcam_tasks_priorities.h
 *
 *  Created on: 28/11/2018
 *      Author: Tiago-Low
 */

#ifndef SIMCAM_TASKS_PRIORITIES_H_
#define SIMCAM_TASKS_PRIORITIES_H_

#include "../simucam_definitions.h"


/* Definition of Task Priorities */
/* Maximum of tasks configured in BSP is 32
 * The minimal priority configured in the BSP is 40 (but just 32 tasks!!!)
 * 0 -> MAX PRIORITY
 * 40 -> MIN PRIORITY  */
#define INITIALIZATION_TASK_PRIO        1
#define INITIALIZATION_TASK_PRIO_FAIL   39
#define RECEIVER_TASK_PRIO              30 	/* Never sleep - starving task (do not up the priority of this task)*/
#define TIMEOUT_CHECKER_PRIO            28
#define RESERVED_FOR_TIMER              27  /* This timer will be used for retransmission purposes (THIS WILL NOT BE USED IN THE CODE, IS JUST TO REMEMBER THAT OS_TASK_TMR_PRIO IS 18)*/
#define PARSER_TASK_PRIO				26
#define OUT_ACK_TASK_PRIO				25
#define SENDER_TASK_PRIO                24
#define IN_ACK_TASK_PRIO				23

#define PCP_MUTEX_PrePareseds           9   /* MUTEX Reader -> PARSER task*/
#define PCP_MUTEX_B32_PRIO              8   /* MUTEX Buffer TX char[32]*/
#define PCP_MUTEX_B64_PRIO              7   /* MUTEX Buffer TX char[64]*/
#define PCP_MUTEX_B128_PRIO             6   /* MUTEX Buffer TX char[128]*/
#define PCP_MUTEX_RECEIVER_ACK          5   /* MUTEX Reader -> Ack receiver control*/
#define PCP_MUTEX_SENDER_ACK            4   /* MUTEX Reader -> Ack receiver control*/
#define PCP_MUTEX_TX_UART_PRIO          3   /* MUTEX TX UART*/



/* --------------- Timers ------------------ */
#define PERIOD_TIMER        5   /* In the BSP the Hz of the timer is 200 milli, period = 5 give me 1 sec */
#define DLY_TIMER           200 /* (ticks: 1 tick == 1 millisec) */
/* --------------- Timers ------------------ */


/* Definition of Task Stack size */
#if defined(STACK_MONITOR)
    #define   TASK_STACKSIZE       2048
#else
    #define   TASK_STACKSIZE       2048*4
#endif

#define INITIALIZATION_TASK_SIZE    TASK_STACKSIZE
#define RECEIVER_TASK_SIZE          TASK_STACKSIZE
#define PARSER_TASK_SIZE            TASK_STACKSIZE
#define IN_ACK_TASK_SIZE            TASK_STACKSIZE
#define OUT_ACK_TASK_SIZE           TASK_STACKSIZE
#define SENDER_TASK_SIZE            TASK_STACKSIZE
#define TIMEOUT_CHECKER_SIZE        TASK_STACKSIZE



/* -------------- Definition of Stacks------------------ */
extern OS_STK    vInitialTask_stk[INITIALIZATION_TASK_SIZE];


/* Communication tasks */
extern OS_STK    vReceiverUartTask_stk[RECEIVER_TASK_SIZE];
extern OS_STK    vParserCommTask_stk[PARSER_TASK_SIZE];
extern OS_STK    vInAckHandlerTask_stk[IN_ACK_TASK_SIZE];
extern OS_STK    vOutAckHandlerTask_stk[OUT_ACK_TASK_SIZE];
extern OS_STK    vTimeoutCheckerTask_stk[TIMEOUT_CHECKER_SIZE];
extern OS_STK    senderTask_stk[SENDER_TASK_SIZE];

/* -------------- Definition of Stacks------------------ */




/* -------------- Definition of Queues--------------------*/


/* -------------- Definition of Queues--------------------*/




/*---------------Semaphore and Mutex ---------------------*/
extern OS_EVENT *xTxUARTMutex;


/*  Before access the any buffer for transmission the task should check in the Count Semaphore if has resource available
    if there is buffer free, the task should try to get the mutex in order to protect the integrity of the buffer */
extern OS_EVENT *xMutexBuffer128;
extern OS_EVENT *xMutexBuffer64;
extern OS_EVENT *xMutexBuffer32;

extern OS_EVENT *xSemCountBuffer128;
extern OS_EVENT *xSemCountBuffer64;
extern OS_EVENT *xSemCountBuffer32;



extern OS_EVENT *xSemCountReceivedACK;
extern OS_EVENT *xSemCountPreParsed;

extern OS_EVENT *xMutexReceivedACK;
extern OS_EVENT *xMutexPreParsed;

extern OS_EVENT *xSemTimeoutChecker;

extern OS_EVENT *xSemCountSenderACK;
extern OS_EVENT *xMutexSenderACK;
/*---------------Semaphore and Mutex ---------------------*/

/* --------------- Timers ------------------ */
extern OS_TMR  *xTimerRetransmission;
/* --------------- Timers ------------------ */


extern unsigned short int usiGetIdCMD ( void );

#endif /* SIMCAM_TASKS_PRIORITIES_H_ */
