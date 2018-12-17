#include <sys/alt_stdio.h>
#include "simucam_definitions.h"
#include "utils/initialization_simucam.h"
#include "utils/error_handler_simucam.h"
#include "rtos/simcam_tasks_configurations.h"
#include "rtos/configuration_comm.h"
#include "configs_simucam.h"
#include "rtos/initialization_task.h"
#include "includes.h"

#ifdef DEBUG_ON
    FILE* fp;
#endif


/*== Definition of some resources of RTOS - Semaphores - Stacks - Queues - Flags etc ==============*/

/* --------------- Definition of Semaphores ------------ */
/* Communication tasks (Receiver and Sender) */
OS_EVENT *xSemCommInit;
OS_EVENT *xTxUARTMutex; /*Mutex tx UART*/
/* -------------- Definition of Semaphores -------------- */


/* --------------- Definition of Queues ------------ */
/* Queue that Sender task consume in order to create the packet to send to NUC (Receiver and Sender) */
OS_EVENT *xQSenderTask;
void *xQSenderTaskTbl[SENDER_QUEUE_SIZE]; /*Storage for xQSenderTask*/

/* -------------- Definition of Queues -------------- */



/* -------------- Definition of Stacks------------------ */
OS_STK    vInitialTask_stk[INITIALIZATION_TASK_SIZE];
OS_STK    task2_stk[TASK_STACKSIZE];

/* Communication tasks */
OS_STK    receiverTask_stk[RECEIVER_TASK_SIZE];
OS_STK    senderTask_stk[SENDER_TASK_SIZE];
/* -------------- Definition of Stacks------------------ */

/*==================================================================================================*/





/* Instanceatin and Initialization of the resources for the RTOS */
bool bResourcesInitRTOS( void )
{
	bool bSuccess = TRUE;
	INT8U err;

	/* This semaphore in the sincronization of the task receiver_com_task with sender_com_task*/
	xSemCommInit = OSSemCreate(0);
	if (!xSemCommInit) {
		vFailCreateRTOSResources(xSemCommInit);
		bSuccess = FALSE;
	}

	/* This mutex will protect the access of tx buffer, between SenderTask and Acks from ReceiverTask*/
	xTxUARTMutex = OSMutexCreate(PCP_MUTEX_TEMP_PRIO, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateRTOSResources(err);
		bSuccess = FALSE;
	}

	xQSenderTask = OSQCreate(&xQSenderTaskTbl[0], SENDER_QUEUE_SIZE);
	if (!xQSenderTask) {
		vFailCreateRTOSResources(xQSenderTask);
		bSuccess = FALSE;
	}

	return bSuccess;
}





/* Entry point */
int main(void)
{
	INT8U error_code;
	bool bIniSimucamStatus = FALSE;
	char buffer_temp[100] = "";
	
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
		debug(fp, "Didn't load ETH configuration from SDCard. Default configuration will be loaded. (exit) \n");
		return -1;
	}

	/* If debug is enable, will print the eth configuration in the*/
	#ifdef DEBUG_ON
		vShowEthConfig();
	#endif


	/* This function creates all resources needed by the RTOS*/
	bIniSimucamStatus = bResourcesInitRTOS();
	if (bIniSimucamStatus == FALSE) {
		/* Default configuration for eth connection loaded */
		debug(fp, "Can't alocate resources for RTOS. (exit) \n");
		return -1;
	}

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
		vFailInitialization();
	}
  
	return 0;
}
