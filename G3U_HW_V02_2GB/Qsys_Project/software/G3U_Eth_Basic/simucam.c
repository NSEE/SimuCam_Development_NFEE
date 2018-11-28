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




/* Definition of task stack for the initial task which will initialize the NicheStack
 * TCP/IP Stack and then initialize the rest of the Simple Socket Server example tasks.
 */
OS_STK    InitialTaskStk[TASK_STACKSIZE];

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


  /* Load default value from SDCard
   * - Get Fixed IP Address
   * - Get Op. mode of Simucam
   * - Get default for each Fee-simlator
   */


  /* Get MAC Address from RTC module */
  memset(mac_addr,0, 6);
  //bIniSimucamStatus = RTCC_SPI_R_MAC(mac_addr);
  if (bIniSimucamStatus == FALSE) {
//	  vFailGetMacRTC();
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

  //Init_Simucam_Tasks();


  /*
   * As with all MicroC/OS-II designs, once the initial thread(s) and
   * associated RTOS resources are declared, we start the RTOS. That's it!
   */
  OSStart();


  while(1); /* Correct Program Flow never gets here. */

  return -1;
}
