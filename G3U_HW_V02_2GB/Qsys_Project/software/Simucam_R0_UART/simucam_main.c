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

/*===== Global system variables ===========*/
unsigned short int usiIdCMD; /* Used in the comunication with NUC*/

txBuffer128 xBuffer128[N_128];
txBuffer64 xBuffer64[N_64];
txBuffer32 xBuffer32[N_32];

tPreParsed xPreParsed[N_PREPARSED_ENTRIES];
txReceivedACK xReceivedACK[N_ACKS_RECEIVED];

txSenderACKs xSenderACK[N_ACKS_SENDER];
/*===== Global system variables ===========*/

/*== Definition of some resources of RTOS - Semaphores - Stacks - Queues - Flags etc ==============*/

/* --------------- Definition of Semaphores ------------ */
/* Communication tasks (Receiver and Sender) */
OS_EVENT *xSemCommInit;
OS_EVENT *xTxUARTMutex; /*Mutex tx UART*/

OS_EVENT *xSemCountBuffer128;
OS_EVENT *xMutexBuffer128;
OS_EVENT *xSemCountBuffer64;
OS_EVENT *xMutexBuffer64;
OS_EVENT *xSemCountBuffer32;
OS_EVENT *xMutexBuffer32;

OS_EVENT *xSemCountReceivedACK;
OS_EVENT *xSemCountPreParsed;
OS_EVENT *xMutexReceivedACK;
OS_EVENT *xMutexPreParsed;

OS_EVENT *xSemCountSenderACK;
OS_EVENT *xMutexSenderACK;
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

	/* This mutex will protect the access of the (re)transmission "big" buffer of 128 characters*/
	xMutexBuffer128 = OSMutexCreate(PCP_MUTEX_B128_PRIO, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateRTOSResources(err);
		bSuccess = FALSE;
	}

	/* This mutex will protect the access of the (re)transmission "medium" buffer of 64 characters*/
	xMutexBuffer64 = OSMutexCreate(PCP_MUTEX_B64_PRIO, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateRTOSResources(err);
		bSuccess = FALSE;
	}

	/* This mutex will protect the access of the (re)transmission "small" buffer of 32 characters*/
	xMutexBuffer32 = OSMutexCreate(PCP_MUTEX_B32_PRIO, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateRTOSResources(err);
		bSuccess = FALSE;
	}

	/* This semaphore will count the number of positions available in the "big" buffer of 128 characters*/
	xSemCountBuffer128 = OSSemCreate(N_128);
	if (!xSemCountBuffer128) {
		vFailCreateRTOSResources(xSemCountBuffer128);
		bSuccess = FALSE;
	}

	/* This semaphore will count the number of positions available in the "medium" buffer of 64 characters*/
	xSemCountBuffer64 = OSSemCreate(N_64);
	if (!xSemCountBuffer64) {
		vFailCreateRTOSResources(xSemCountBuffer64);
		bSuccess = FALSE;
	}

	/* This semaphore will count the number of positions available in the "small" buffer of 32 characters*/
	xSemCountBuffer32 = OSSemCreate(N_32);
	if (!xSemCountBuffer32) {
		vFailCreateRTOSResources(xSemCountBuffer32);
		bSuccess = FALSE;
	}


	/* Mutex and Semaphores to control the comunication of FastReaderTask */
	xMutexReceivedACK = OSMutexCreate(PCP_MUTEX_RECEIVER_ACK, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateRTOSResources(err);
		bSuccess = FALSE;
	}

	/* Mutex for Reader -> Parser*/
	xMutexPreParsed = OSMutexCreate(PCP_MUTEX_PrePareseds, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateRTOSResources(err);
		bSuccess = FALSE;
	}

	xSemCountReceivedACK = OSSemCreate(0);
	if (!xSemCountReceivedACK) {
		vFailCreateRTOSResources(xSemCountReceivedACK);
		bSuccess = FALSE;
	}

	xSemCountPreParsed = OSSemCreate(0);
	if (!xSemCountPreParsed) {
		vFailCreateRTOSResources(xSemCountPreParsed);
		bSuccess = FALSE;
	}

	/* Mutex and Semaphore to AckSenderTask*/

	xSemCountSenderACK = OSSemCreate(0);
	if (!xSemCountSenderACK) {
		vFailCreateRTOSResources(xSemCountSenderACK);
		bSuccess = FALSE;
	}

	xMutexSenderACK = OSMutexCreate(PCP_MUTEX_SENDER_ACK, &err);
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

void vVariablesInitialization ( void ) {
	usiIdCMD = 0;
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
