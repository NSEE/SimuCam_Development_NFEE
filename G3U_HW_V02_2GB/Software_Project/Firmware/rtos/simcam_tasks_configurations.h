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
/* 0 -> MAX PRIORITY
 * 55 -> MIN PRIORITY  */
#define INITIALIZATION_TASK_PRIO        1
#define INITIALIZATION_TASK_PRIO_FAIL   20
#define RECEIVER_TASK_PRIO              18
#define SENDER_TASK_PRIO                17
#define PCP_MUTEX_PrePareseds           9   /* MUTEX Reader -> PARSER task*/
#define PCP_MUTEX_B32_PRIO              8   /* MUTEX Buffer TX char[32]*/
#define PCP_MUTEX_B64_PRIO              7   /* MUTEX Buffer TX char[64]*/
#define PCP_MUTEX_B128_PRIO             6   /* MUTEX Buffer TX char[128]*/
#define PCP_MUTEX_RECEIVER_ACK          5   /* MUTEX Reader -> Ack receiver control*/
#define PCP_MUTEX_SENDER_ACK            4   /* MUTEX Reader -> Ack receiver control*/
#define PCP_MUTEX_TX_UART_PRIO          3   /* MUTEX TX UART*/




/* Definition of Task Stack size */
#if defined(STACK_MONITOR)
    #define   TASK_STACKSIZE       2048
#else
    #define   TASK_STACKSIZE       2048*4
#endif

#define INITIALIZATION_TASK_SIZE TASK_STACKSIZE
#define RECEIVER_TASK_SIZE TASK_STACKSIZE
#define SENDER_TASK_SIZE TASK_STACKSIZE



/* -------------- Definition of Stacks------------------ */
extern OS_STK    vInitialTask_stk[INITIALIZATION_TASK_SIZE];
extern OS_STK    task2_stk[TASK_STACKSIZE];

/* Communication tasks */
extern OS_STK    receiverTask_stk[RECEIVER_TASK_SIZE];
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

extern OS_EVENT *xSemCountSenderACK;
extern OS_EVENT *xMutexSenderACK;
/*---------------Semaphore and Mutex ---------------------*/


extern unsigned short int usiGetIdCMD ( void );

#endif /* SIMCAM_TASKS_PRIORITIES_H_ */
