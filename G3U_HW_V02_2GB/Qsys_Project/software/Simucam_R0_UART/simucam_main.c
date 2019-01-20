#include <sys/alt_stdio.h>
#include <ucos_ii.h>
#include "simucam_definitions.h"
#include "utils/initialization_simucam.h"
#include "utils/error_handler_simucam.h"
#include "utils/communication_configs.h"
#include "utils/configs_simucam.h"
#include "utils/test_module_simucam.h"
#include "utils/meb.h"
#include "rtos/tasks_configurations.h"
#include "rtos/initialization_task.h"


#include "includes.h"

#ifdef DEBUG_ON
    FILE* fp;
#endif

/*===== Global system variables ===========*/
unsigned short int usiIdCMD; /* Used in the communication with NUC*/

/* Indicates if there's free slots in the buffer of retransmission: xBuffer128, xBuffer64, xBuffer32 */
tInUseRetransBuffer xInUseRetrans;

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
/* For performance porpuses in the Time Out CHecker task */
unsigned char SemCount128;
unsigned char SemCount64;
unsigned char SemCount32;

OS_EVENT *xSemCountReceivedACK;
OS_EVENT *xSemCountPreParsed;
OS_EVENT *xMutexReceivedACK;
OS_EVENT *xMutexPreParsed;

OS_EVENT *xSemTimeoutChecker;

OS_EVENT *xSemCountSenderACK;
OS_EVENT *xMutexSenderACK;
/* -------------- Definition of Semaphores -------------- */


/* --------------- Definition of Queues ------------ */


/* -------------- Definition of Queues -------------- */


/* -------------- Definition of Stacks------------------ */
OS_STK    vInitialTask_stk[INITIALIZATION_TASK_SIZE];


/* Communication tasks */
OS_STK    vReceiverUartTask_stk[RECEIVER_TASK_SIZE];
OS_STK    vParserCommTask_stk[PARSER_TASK_SIZE];
OS_STK    vInAckHandlerTask_stk[IN_ACK_TASK_SIZE];
OS_STK    vOutAckHandlerTask_stk[OUT_ACK_TASK_SIZE];
OS_STK    vTimeoutCheckerTask_stk[TIMEOUT_CHECKER_SIZE];
OS_STK    senderTask_stk[SENDER_TASK_SIZE];
OS_STK    vStackMonitor_stk[STACK_MONITOR_SIZE];
/* -------------- Definition of Stacks------------------ */


/* --------------- Timers ------------------ */
OS_TMR  *xTimerRetransmission;
/* --------------- Timers ------------------ */

/*==================================================================================================*/


/*
 * Control of all Simucam application
 */
TSimucam_MEB xSimMebStruct;

/* Instanceatin and Initialization of the resources for the RTOS */
bool bResourcesInitRTOS( void )
{
	bool bSuccess = TRUE;
	INT8U err;

	/* This semaphore in the sincronization of the task receiver_com_task with sender_com_task*/
	xSemCommInit = OSSemCreate(0);
	if (!xSemCommInit) {
		vFailCreateSemaphoreResources();
		bSuccess = FALSE;
	}

	/* This mutex will protect the access of tx buffer, between SenderTask and Acks from ReceiverTask*/
	xTxUARTMutex = OSMutexCreate(PCP_MUTEX_TX_UART_PRIO, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexSResources(err);
		bSuccess = FALSE;
	}

	/* This mutex will protect the access of the (re)transmission "big" buffer of 128 characters*/
	xMutexBuffer128 = OSMutexCreate(PCP_MUTEX_B128_PRIO, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexSResources(err);
		bSuccess = FALSE;
	}

	/* This mutex will protect the access of the (re)transmission "medium" buffer of 64 characters*/
	xMutexBuffer64 = OSMutexCreate(PCP_MUTEX_B64_PRIO, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexSResources(err);
		bSuccess = FALSE;
	}

	/* This mutex will protect the access of the (re)transmission "small" buffer of 32 characters*/
	xMutexBuffer32 = OSMutexCreate(PCP_MUTEX_B32_PRIO, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexSResources(err);
		bSuccess = FALSE;
	}

	/* This semaphore will count the number of positions available in the "big" buffer of 128 characters*/
	SemCount128 = N_128;
	xSemCountBuffer128 = OSSemCreate(N_128);
	if (!xSemCountBuffer128) {
		SemCount128 = 0;
		vFailCreateSemaphoreResources();
		bSuccess = FALSE;
	}

	/* This semaphore will count the number of positions available in the "medium" buffer of 64 characters*/
	SemCount64 = N_64;
	xSemCountBuffer64 = OSSemCreate(N_64);
	if (!xSemCountBuffer64) {
		SemCount64 = 0;
		vFailCreateSemaphoreResources();
		bSuccess = FALSE;
	}

	/* This semaphore will count the number of positions available in the "small" buffer of 32 characters*/
	SemCount32 = N_32;
	xSemCountBuffer32 = OSSemCreate(N_32);
	if (!xSemCountBuffer32) {
		SemCount32 = 0;
		vFailCreateSemaphoreResources();
		bSuccess = FALSE;
	}


	/* Mutex and Semaphores to control the communication of FastReaderTask */
	xMutexReceivedACK = OSMutexCreate(PCP_MUTEX_RECEIVER_ACK, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexSResources(err);
		bSuccess = FALSE;
	}

	/* Mutex for Reader -> Parser*/
	xMutexPreParsed = OSMutexCreate(PCP_MUTEX_PrePareseds, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexSResources(err);
		bSuccess = FALSE;
	}

	xSemCountReceivedACK = OSSemCreate(0);
	if (!xSemCountReceivedACK) {
		vFailCreateSemaphoreResources();
		bSuccess = FALSE;
	}

	xSemCountPreParsed = OSSemCreate(0);
	if (!xSemCountPreParsed) {
		vFailCreateSemaphoreResources();
		bSuccess = FALSE;
	}

	/* Mutex and Semaphore to AckSenderTask*/
	xSemCountSenderACK = OSSemCreate(0);
	if (!xSemCountSenderACK) {
		vFailCreateSemaphoreResources();
		bSuccess = FALSE;
	}

	xMutexSenderACK = OSMutexCreate(PCP_MUTEX_SENDER_ACK, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexSResources(err);
		bSuccess = FALSE;
	}

	xSemTimeoutChecker = OSSemCreate(0);
	if (!xSemTimeoutChecker) {
		vFailCreateSemaphoreResources();
		bSuccess = FALSE;
	}


	/* Create the timer that will be used to count the timeout for the retransmission*/
	xTimerRetransmission = OSTmrCreate(	(INT32U         )DLY_TIMER,  /* 200 ticks = 200 millisec */
										(INT32U         )PERIOD_TIMER,
										(INT8U          )OS_TMR_OPT_PERIODIC,
										(OS_TMR_CALLBACK)vTimeoutCheck,
										(void          *)0,
										(INT8U         *)"timer timeout",
										(INT8U         *)&err);	
	if ( err != OS_ERR_NONE ) {
		vFailCreateTimerRetransmisison();
		bSuccess = FALSE;
	}

	return bSuccess;
}

/* Global variables already initialized with zero. But better safe than I'm sorry. */
void vVariablesInitialization ( void ) {
	unsigned char ucIL = 0;

	usiIdCMD = 2;

	memset( xInUseRetrans.b128 , FALSE , sizeof(xInUseRetrans.b128));
	memset( xInUseRetrans.b64 , FALSE , sizeof(xInUseRetrans.b64));
	memset( xInUseRetrans.b32 , FALSE , sizeof(xInUseRetrans.b32));
	
	for( ucIL = 0; ucIL < N_128; ucIL++)
	{
		memset( xBuffer128[ucIL].buffer, 0, 128);
		xBuffer128[ucIL].bSent = FALSE;
		xBuffer128[ucIL].usiId = 0;
		xBuffer128[ucIL].usiTimeOut = 0;
		xBuffer128[ucIL].ucNofRetries = 0;
	}

	for( ucIL = 0; ucIL < N_64; ucIL++)
	{
		memset( xBuffer64[ucIL].buffer, 0, 64);
		xBuffer64[ucIL].bSent = FALSE;
		xBuffer64[ucIL].usiId = 0;
		xBuffer64[ucIL].usiTimeOut = 0;
		xBuffer64[ucIL].ucNofRetries = 0;
	}

	for( ucIL = 0; ucIL < N_32; ucIL++)
	{
		memset( xBuffer32[ucIL].buffer, 0, 32);
		xBuffer32[ucIL].bSent = FALSE;
		xBuffer32[ucIL].usiId = 0;
		xBuffer32[ucIL].usiTimeOut = 0;
		xBuffer32[ucIL].ucNofRetries = 0;
	}	
/* todo: Need start this variable also, but not now

tPreParsed xPreParsed[N_PREPARSED_ENTRIES];
txReceivedACK xReceivedACK[N_ACKS_RECEIVED];

txSenderACKs xSenderACK[N_ACKS_SENDER];

*/




}



/* Entry point */
int main(void)
{
	INT8U error_code;
	bool bIniSimucamStatus = FALSE;
	
	OSInit();

	/* Debug device initialization - JTAG USB */
	#ifdef DEBUG_ON
		fp = fopen(JTAG_UART_0_NAME, "r+");
	#endif	

	#ifdef DEBUG_ON
		debug(fp, "Main entry point.\n");
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
		#ifdef DEBUG_ON
			debug(fp, "Didn't load ETH configuration from SDCard. Default configuration will be loaded. (exit) \n");
		#endif
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
		debug(fp, "Can't allocate resources for RTOS. (exit) \n");
		return -1;
	}

	/* Start the structure of control of the Simucam Application, including all FEEs instances */
	vSimucamStructureInit( &xSimMebStruct );

	vVariablesInitialization();

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
		/* Some error occurs in the creation of the Initialization Task */
		vFailInitialization();
	}
  
	return 0;
}
