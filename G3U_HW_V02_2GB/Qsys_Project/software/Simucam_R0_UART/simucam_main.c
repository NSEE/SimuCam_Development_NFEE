#include <stdio.h>
#include "simucam_definitions.h"
#include "utils/error_handler_simucam.h"
#include "rtos/simcam_tasks_configurations.h"
#include "rtos/configuration_comm.h"
#include "rtos/initialization_task.h"
#include "includes.h"

#ifdef DEBUG_ON
    FILE* fp;
#endif


/*== Definition of some resources of RTOS - Semaphores - Stacks - Queues - Flags etc ==============*/

/* --------------- Definition of Semaphores ------------ */
/* Communication tasks (Receiver and Sender) */
OS_EVENT *xSemCommInit;
/* -------------- Definition of Semaphores -------------- */


/* -------------- Definition of Stacks------------------ */
OS_STK    vInitialTask_stk[INITIALIZATION_TASK_SIZE];
OS_STK    task2_stk[TASK_STACKSIZE];

/* Communication tasks */
OS_STK    receiverTask_stk[RECEIVER_TASK_SIZE];
OS_STK    senderTask_stk[SENDER_TASK_SIZE];
/* -------------- Definition of Stacks------------------ */

/*==================================================================================================*/





/* Instanceatin and Initialization of the resources for the RTOS */
void vResourcesInitRTOS( void )
{
	/* This semaphore in the sincronization of the task receiver_com_task with sender_com_task*/
	xSemCommInit = OSSemCreate(0);
}





/* Entry point */
int main(void)
{
	INT8U error_code;
	bool bIniSimucamStatus = FALSE;
	
	/* Clear the RTOS timer */
	OSTimeSet(0);

	/* Debug device initialization - JTAG USB */
	#ifdef DEBUG_ON
		fp = fopen(JTAG_UART_0_NAME, "r+");
	#endif	
	

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
		vFailTestCriticasParts();
		return -1;
	}

	bIniSimucamStatus = vLoadDefaultETHConf();
	if (bIniSimucamStatus == FALSE) {
		/* Default configuration for eth connection loaded */
		debug(fp, "Didn't load ETH configuration from SDCard. Default configuration will be loaded. \n");
		return -1;
	}

	/* If debug is enable, will print the eth configuration in the*/
	#ifdef DEBUG_ON
		vShowEthConfig();
	#endif


	/* This function creates all resources needed by the RTOS*/
	vResourcesInitRTOS();


	/* Creating the initialization task*/
	#if STACK_MONITOR
		error_code = OSTaskCreateExt(vInitialTask,
									NULL,
									(void *)&vInitialTask_stk[INITIALIZATION_TASK_SIZE-1],
									INITIALIZATION_TASK_PRIO,
									INITIALIZATION_TASK_PRIO,
									vInitialTask_stk,
									INITIALIZATION_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CLR);
	#else
		error_code = OSTaskCreateExt(vInitialTask,
									NULL,
									(void *)&vInitialTask_stk[INITIALIZATION_TASK_SIZE-1],
									INITIALIZATION_TASK_PRIO,
									INITIALIZATION_TASK_PRIO,
									vInitialTask_stk,
									INITIALIZATION_TASK_SIZE,
									NULL,
									0);
	#endif


	if ( error_code == OS_ERR_NONE ) {
		/* Start the scheduler (start the Real Time Application) */
		OSStart();
	} else {
		/* Some error ocours in the creation of the Initialization Task */
		#ifdef DEBUG_ON
			printErrorTask( error_code );		
		#endif
		vFailInitialization();
	}
  
	return 0;
}
