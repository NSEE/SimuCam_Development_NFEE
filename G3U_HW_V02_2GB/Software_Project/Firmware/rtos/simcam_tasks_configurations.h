/*
 * simcam_tasks_priorities.h
 *
 *  Created on: 28/11/2018
 *      Author: Tiago-Low
 */

#ifndef SIMCAM_TASKS_PRIORITIES_H_
#define SIMCAM_TASKS_PRIORITIES_H_

/*
   * Initialize Altera NicheStack TCP/IP Stack - Nios II Edition specific code.
   * NicheStack is initialized from a task, so that RTOS will have started, and
   * I/O drivers are available.  Two tasks are created:
   *    "Inet main"  task with priority 2
   *    "clock tick" task with priority 3
*/

/* 0 -> MAX PRIORITY
 * 55 -> MIN PRIORITY  */
#define INITIALIZATION_TASK_PRIO 6
#define SOCKET_DEBUG_TASK_PRIO 5
#define SOCKET_PUS_TASK_PRIO 4



/* Definition of Task Stack size for tasks not using Nichestack */
#define   TASK_STACKSIZE       2048


#endif /* SIMCAM_TASKS_PRIORITIES_H_ */
