/*
 * simucam.c
 *
 *  Created on: 20/10/2018
 *      Author: TiagoLow
 */

#include <stdio.h>

/* MicroC/OS-II definitions */
#include "includes.h"

/* Simple Socket Server definitions */
#include "simple_socket_server.h"
#include "alt_error_handler.h"

/* Nichestack definitions */
#include "ipport.h"
#include "libport.h"
#include "osport.h"

#include "utils/initialization_simucam.h"
#include "utils/test_module_simucam.h"
#include "utils/error_handler_simucam.h"
#include "rtos/rtos_tasks.h"

/* SDCard Libs */
#include "utils/sdcard_file_manager.h"




/* Definition of task stack for the initial task which will initialize the NicheStack
 * TCP/IP Stack and then initialize the rest of the Simple Socket Server example tasks.
 */
OS_STK    SSSInitialTaskStk[TASK_STACKSIZE];

/* Declarations for creating a task with TK_NEWTASK.
 * All tasks which use NicheStack (those that use sockets) must be created this way.
 * TK_OBJECT macro creates the static task object used by NicheStack during operation.
 * TK_ENTRY macro corresponds to the entry point, or defined function name, of the task.
 * inet_taskinfo is the structure used by TK_NEWTASK to create the task.
 */
TK_OBJECT(to_ssstask);
TK_ENTRY(SSSSimpleSocketServerTask);

struct inet_taskinfo ssstask = {
      &to_ssstask,
      "simple socket server",
      SSSSimpleSocketServerTask,
      4,
      APP_STACK_SIZE,
};

/* SSSInitialTask will initialize the NicheStack
 * TCP/IP Stack and then initialize the rest of the Simple Socket Server example
 * RTOS structures and tasks.
 */
void SSSInitialTask(void *task_data)
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

  printf("\nSimple Socket Server starting up\n");

  /* Create the main simple socket server task. */
  TK_NEWTASK(&ssstask);

  /*create os data structures [yb] */
  SSSCreateOSDataStructs();
  SimucamCreateOSQ();
  DataCreateOSQ();

  /* create the other tasks */
  SSSCreateTasks();

  /* Application Specific Task Launching Code Block End */

  /*This task is deleted because there is no need for it to run again */
  error_code = OSTaskDel(OS_PRIO_SELF);
  alt_uCOSIIErrorHandler(error_code, 0);

  while (1); /* Correct Program Flow should never get here */
}

/* Main creates a single task, SSSInitialTask, and starts task scheduler.
 */


int main (int argc, char* argv[], char* envp[])
{
  INT8U error_code;
  /* Clear the RTOS timer */
  OSTimeSet(0);
  bool bIniSimucamStatus = TRUE;
  unsigned char mac_addr[6];

  /**********************************************
   *          Block of Simucam Initialization	*
   **********************************************/

  /* Initialization of basic HW */
  vInitSimucamBasicHW();

  /* Test of some critical IPCores HW interfaces in the Simucam */
  bIniSimucamStatus = bTestSimucamCriticalHW();
  if (bIniSimucamStatus == FALSE) {
	  vFailTestCriticasParts();
	  return -1;
  }




  /* Log file Initialization in the SDCard */
  bIniSimucamStatus = bInitializeSDCard();
  if (bIniSimucamStatus == FALSE) {
	  //vFailTestCriticasParts();
	  return -1;
  }
  vJustAWriteTest();
  return 0;
  /* Load default value from SDCard
   * - Get Fixed IP Address
   * - Get Op. mode of Simucam
   * - Get default for each Fee-simlator
   */


  /* Get MAC Address from RTC module */
  memset(mac_addr,0, 6);
  bIniSimucamStatus = RTCC_SPI_R_MAC(mac_addr);
  if (bIniSimucamStatus == FALSE) {
	  vFailGetMacRTC();
	  return -1;
  }

  /* Socket server initialization for debug, not control */


  /* Run second batch of tests: RAM, SPW (internal functionalities) */


  /* Fill and prepare the RAM memory for operation (Pattern, pre-loaded image etc)
   * Zerar toda memoria
   * Zerar buffer SPW
   * Conf time code
   * */


  /* Sign with Leds or display that the Simucam is ready to operate */



  Init_Simucam_Tasks();

  /* SSSInitialTask will initialize the NicheStack
   * TCP/IP Stack and then initialize the rest of the Simple Socket Server example
   * RTOS structures and tasks.
   */
  error_code = OSTaskCreateExt(SSSInitialTask,
                             NULL,
                             (void *)&SSSInitialTaskStk[TASK_STACKSIZE],
                             SSS_INITIAL_TASK_PRIORITY,
                             SSS_INITIAL_TASK_PRIORITY,
                             SSSInitialTaskStk,
                             TASK_STACKSIZE,
                             NULL,
                             0);
  alt_uCOSIIErrorHandler(error_code, 0);



  /*
   * As with all MicroC/OS-II designs, once the initial thread(s) and
   * associated RTOS resources are declared, we start the RTOS. That's it!
   */
  OSStart();


  while(1); /* Correct Program Flow never gets here. */

  return -1;
}

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/
