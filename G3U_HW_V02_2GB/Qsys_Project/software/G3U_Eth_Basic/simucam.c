/*
 * simucam.c
 *
 *  Created on: 20/10/2018
 *      Author: TiagoLow
 */


#include "simucam_defs_vars_structs_includes.h"

/* Simple Socket Server definitions */

#include "utils/initialization_simucam.h"
#include "utils/test_module_simucam.h"
#include "utils/error_handler_simucam.h"
#include "rtos/simcam_tasks_configurations.h"
#include "rtos/initialization_task.h"
#include "rtos/rtos_tasks.h"

/* SDCard Libs */
#include "utils/sdcard_file_manager.h"
#include "utils/configs_simucam.h"
#include "simple_socket_server.h"




/* Definition of task stack for the initial task which will initialize the NicheStack
 * TCP/IP Stack and then initialize the rest of the Simple Socket Server example tasks.
 */
OS_STK    InitialTaskStk[TASK_STACKSIZE];


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
    printf("iniche_ready %i", iniche_net_ready);


  /* Now that the stack is running, perform the application initialization steps */

  /* Application Specific Task Launching Code Block Begin */

  printf("\nSimple Socket Server starting up\n");

  /* Create the main simple socket server task. */
  TK_NEWTASK(&ssstask);

  /*create os data structures */
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




int main (int argc, char* argv[], char* envp[])
{
  INT8U error_code;
  /* Clear the RTOS timer */
  OSTimeSet(0);
  bool bIniSimucamStatus = FALSE;

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

  bIniSimucamStatus = vLoadDefaultETHConf();
  if (bIniSimucamStatus == FALSE) {
	  //Carregou o default;
	  printf("Carregou o arquivo padrao!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
	  return -1;
  }


  printf("Verificando configurações \n");
  printf("ETH \n");
  printf("MAC: %x : %x : %x : %x : %x : %x \n", xConfEth.ucMAC[0], xConfEth.ucMAC[1], xConfEth.ucMAC[2], xConfEth.ucMAC[3], xConfEth.ucMAC[4], xConfEth.ucMAC[5] );
  printf("IP: %i . %i . %i . %i \n",xConfEth.ucIP[0], xConfEth.ucIP[1], xConfEth.ucIP[2], xConfEth.ucIP[3] );
  printf("GTW: %i . %i . %i . %i \n",xConfEth.ucGTW[0], xConfEth.ucGTW[1], xConfEth.ucGTW[2], xConfEth.ucGTW[3] );
  printf("Sub: %i . %i . %i . %i \n",xConfEth.ucSubNet[0], xConfEth.ucSubNet[1], xConfEth.ucSubNet[2], xConfEth.ucSubNet[3] );
  printf("Porta Debug: %i\n", xConfEth.siPortDebug );
  printf("Porta PUS: %i\n", xConfEth.siPortPUS );


  error_code = OSTaskCreateExt(vInitialTask,
                             NULL,
                             (void *)&InitialTaskStk[TASK_STACKSIZE],
                             INITIALIZATION_TASK_PRIO,
                             INITIALIZATION_TASK_PRIO,
                             InitialTaskStk,
                             TASK_STACKSIZE,
                             NULL,
                             0);


/*
  error_code = OSTaskCreateExt(SSSInitialTask,
                             NULL,
                             (void *)&SSSInitialTaskStk[TASK_STACKSIZE],
                             SSS_INITIAL_TASK_PRIORITY,
                             SSS_INITIAL_TASK_PRIORITY,
                             SSSInitialTaskStk,
                             TASK_STACKSIZE,
                             NULL,
                             0);
*/
  alt_uCOSIIErrorHandler(error_code,0);


  /* Load default value from SDCard
   * - Get Fixed IP Address
   * - Get Op. mode of Simucam
   * - Get default for each Fee-simlator
   */


 /* Socket server initialization for debug, not control */


  /* Run second batch of tests: RAM, SPW (internal functionalities) */


  /* Fill and prepare the RAM memory for operation (Pattern, pre-loaded image etc)
   * Zerar toda memoria
   * Zerar buffer SPW
   * Conf time code
   * */


  /* Sign with Leds or display that the Simucam is ready to operate */

  Init_Simucam_Tasks();


  /*
   * As with all MicroC/OS-II designs, once the initial thread(s) and
   * associated RTOS resources are declared, we start the RTOS. That's it!
   */
  OSStart();


  while(1); /* Correct Program Flow never gets here. */

  return -1;
}
