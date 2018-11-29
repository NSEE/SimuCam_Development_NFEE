/*
 * initialization_task.c
 *
 *  Created on: 27/11/2018
 *      Author: Tiago-Low
 *
 * This file contains the implementation of the initial task of the SIMUCAM. The NicheStack and the net_main should
 * be started from a task because it has to run after OS_Start.
 */

#include "initialization_task.h"

TK_OBJECT(to_DebugTask);
TK_ENTRY(vSocketServerDebugTask);

struct inet_taskinfo xNetTaskDebug = {
      &to_DebugTask,
      "Debug Socket Server",
      vSocketServerDebugTask,
      SOCKET_DEBUG_TASK_PRIO,
      APP_STACK_SIZE,
};


/*  */
void vInitialTask(void *task_data)
{
  INT8U error_code;

  /*
   * Initialize Altera NicheStack TCP/IP Stack - Nios II Edition specific code.
   * NicheStack is initialized from a task, so that RTOS will have started, and
   * I/O drivers are available.  Two tasks are created:
   *    "Inet main"  task with priority 2
   *    "clock tick" task with priority 3
   */
  alt_iniche_init();
  netmain();

  /* Wait for the network stack to be ready before proceeding.
   * iniche_net_ready indicates that TCP/IP stack is ready, and IP address is obtained.
   */
  while (!iniche_net_ready)
    TK_SLEEP(1);

  /* Now that the stack is running, perform the application initialization steps */

  /* Application Specific Task Launching Code Block Begin */

  printf("\n Server starting up\n");

  /* Create the debug socket socket server task. */
  TK_NEWTASK(&xNetTaskDebug);

  /*create os data structures [yb] */
  //SSSCreateOSDataStructs();
  //SimucamCreateOSQ();
  //DataCreateOSQ();

  /* TIAGO - Aqui será criado as outras tasks */
  //SSSCreateTasks();

  /* Application Specific Task Launching Code Block End */

  /*This task is deleted because there is no need for it to run again */
  error_code = OSTaskDel(OS_PRIO_SELF); // OS_PRIO_SELF = Means task self priority
  alt_uCOSIIErrorHandler(error_code, 0);

  for(;;); /* Correct Program Flow should never get here */
}
