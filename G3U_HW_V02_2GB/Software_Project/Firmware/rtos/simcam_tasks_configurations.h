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
#define RECEIVER_TASK_PRIO              16
#define SENDER_TASK_PRIO                15



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

#endif /* SIMCAM_TASKS_PRIORITIES_H_ */
