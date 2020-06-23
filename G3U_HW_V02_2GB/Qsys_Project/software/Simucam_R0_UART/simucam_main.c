#include <sys/alt_stdio.h>
#include <ucos_ii.h>
#include "simucam_definitions.h"
#include "utils/sync_handler.h"
#include "utils/initialization_simucam.h"
#include "utils/error_handler_simucam.h"
#include "utils/communication_configs.h"
#include "utils/configs_simucam.h"
#include "utils/configs_bind_channel_FEEinst.h"
#include "utils/test_module_simucam.h"
#include "utils/meb.h"
#include "utils/fee_controller.h"
#include "utils/data_controller.h"
#include "utils/pattern.h"
#include "rtos/tasks_configurations.h"
#include "rtos/initialization_task.h"
#include <sys/ioctl.h>

#include "includes.h"

#if DEBUG_ON
    FILE* fp;
#endif

/*===== Global system variables ===========*/
volatile unsigned short int usiIdCMD; /* Used in the communication with NUC*/

/* Indicates if there's free slots in the buffer of retransmission: xBuffer128, xBuffer64, xBuffer32 */
tInUseRetransBuffer xInUseRetrans;

txBuffer512 xBuffer512[N_512];
txBuffer128 xBuffer128[N_128];
txBuffer64 xBuffer64[N_64];
txBuffer32 xBuffer32[N_32];

//todo: Tiago Verificar se necessita ser volatil
tTMPusChar_Sender xBuffer128_Sender[N_128_SENDER];

volatile tPreParsed xPreParsed[N_PREPARSED_ENTRIES];
volatile txReceivedACK xReceivedACK[N_ACKS_RECEIVED];

volatile txSenderACKs xSenderACK[N_ACKS_SENDER];

volatile tTMPus xPus[N_PUS_PIPE];
/*===== Global system variables ===========*/

/*== Definition of some resources of RTOS - Semaphores - Stacks - Queues - Flags etc ==============*/

/* --------------- Definition of Semaphores ------------ */
/* Communication tasks (Receiver and Sender) */
OS_EVENT *xSemCommInit;
OS_EVENT *xTxUARTMutex; /*Mutex tx UART*/

OS_EVENT *xSemCountBuffer512;
OS_EVENT *xSemCountBuffer128;
OS_EVENT *xMutexBuffer128;
OS_EVENT *xSemCountBuffer64;
OS_EVENT *xMutexBuffer64;
OS_EVENT *xSemCountBuffer32;
OS_EVENT *xMutexBuffer32;

/* This Mutex Should protect the array xPus[N_PUS_PIPE]*/
OS_EVENT *xMutexPus;

/* For performance porpuses in the Time Out CHecker task */
volatile unsigned char SemCount512;
volatile unsigned char SemCount128;
volatile unsigned char SemCount64;
volatile unsigned char SemCount32;

OS_EVENT *xSemCountReceivedACK;
OS_EVENT *xSemCountPreParsed;
OS_EVENT *xMutexReceivedACK;
OS_EVENT *xMutexPreParsed;

OS_EVENT *xSemTimeoutChecker;

OS_EVENT *xSemCountSenderACK;
OS_EVENT *xMutexSenderACK;
OS_EVENT *xMutexDMAFTDI;
OS_EVENT *xMutexTranferBuffer;
/* -------------- Definition of Semaphores -------------- */


/* --------------- Definition of Queues ------------ */
/* This Queue will sync any FEE instance that needs to receive any command, including access to DMA */
/* The NUmber of Queue for the FEE is hardcoded :/ */
void *xFeeQueueTBL0[N_MSG_FEE];
void *xFeeQueueTBL1[N_MSG_FEE];
void *xFeeQueueTBL2[N_MSG_FEE];
void *xFeeQueueTBL3[N_MSG_FEE];
void *xFeeQueueTBL4[N_MSG_FEE];
void *xFeeQueueTBL5[N_MSG_FEE];
OS_EVENT *xFeeQ[N_OF_NFEE];		            /* Give access to the DMA by sincronization to a NFEE[i], and other commands */


/* This Queue will be used to Schadule the access of the DMA, The ISR of "empty Buffer" will send message to this Queue with the Number of FEE that rises the IRQ */
void *xNfeeScheduleTBL[N_OF_MSG_QUEUE];
OS_EVENT *xNfeeSchedule;				        /* Queue that will receive from the ISR the NFEE Number that has empty buffer, in order to grant acess to the DMA */

/* This Queue is the fast way to comunicate with NFEE Controller task, the communication will be done by sending ints using MASKs*/
void *xQMaskCMDNFeeCtrlTBL[N_OF_MSG_QUEUE_MASK];
OS_EVENT *xQMaskFeeCtrl;

/* This Queue is the fast way to comunicate with NFEE Controller task, the communication will be done by sending ints using MASKs*/
void *xQMaskCMDNDataCtrlTBL[N_OF_MSG_QUEUE_MASK];
OS_EVENT *xQMaskDataCtrl;

/* Comunication and syncronization of the Meb Task */
void *xMebQTBL[N_OF_MEB_MSG_QUEUE];
OS_EVENT *xMebQ;

/* Sync Reset comm queue [bndky] */
void *xQueueSyncResetTBL[N_MESG_SYNCRST];
OS_EVENT *xQueueSyncReset;

/* Queue to comunicate with the LUT Handler */
void *xLutQTBL[N_OF_LUT_MSG_QUEUE];
OS_EVENT *xLutQ;
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

OS_STK    vSyncReset_stk[SYNC_RESET_STACK_SIZE]; /*[bndky]*/

/* Main application Tasks */
OS_STK    vNFeeControlTask_stk[FEE_CONTROL_STACK_SIZE];
OS_STK    vDataControlTask_stk[DATA_CONTROL_STACK_SIZE];
OS_STK    vSimMebTask_stk[MEB_STACK_SIZE];
OS_STK    vFeeTask0_stk[FEES_STACK_SIZE];
OS_STK    vFeeTask1_stk[FEES_STACK_SIZE];
OS_STK    vFeeTask2_stk[FEES_STACK_SIZE];
OS_STK    vFeeTask3_stk[FEES_STACK_SIZE];
OS_STK    vFeeTask4_stk[FEES_STACK_SIZE];
OS_STK    vFeeTask5_stk[FEES_STACK_SIZE];
OS_STK    vLUT_stk[LUT_STACK_SIZE];
/* -------------- Definition of Stacks------------------ */


/* --------------- Timers ------------------ */
OS_TMR *xTimerRetransmission;
/* --------------- Timers ------------------ */

/*==================================================================================================*/


/*
 * Control of all Simucam application
 */
TSimucam_MEB xSimMeb; /* Struct */
tDmaSim xDma[2];		  /* Control of the DMA */

/* Instanceatin and Initialization of the resources for the RTOS */
bool bResourcesInitRTOS( void ) {
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
	SemCount512 = N_512;
	xSemCountBuffer512 = OSSemCreate(N_512);
	if (!xSemCountBuffer512) {
		SemCount512 = 0;
		vFailCreateSemaphoreResources();
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

	xMutexTranferBuffer = OSMutexCreate(PCP_MUTEX_B128_PRIO_SENDER, &err);
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

	xNfeeSchedule = OSQCreate(&xNfeeScheduleTBL[0], N_OF_MSG_QUEUE);
	if ( xNfeeSchedule == NULL ) {
		vFailCreateScheduleQueue();
		bSuccess = FALSE;		
	}

	xFeeQ[0] = OSQCreate(&xFeeQueueTBL0[0], N_MSG_FEE);
	if ( xFeeQ[0] == NULL ) {
		vFailCreateNFEEQueue( 0 );
		bSuccess = FALSE;		
	}

	xFeeQ[1] = OSQCreate(&xFeeQueueTBL1[0], N_MSG_FEE);
	if ( xFeeQ[1] == NULL ) {
		vFailCreateNFEEQueue( 1 );
		bSuccess = FALSE;		
	}

	xFeeQ[2] = OSQCreate(&xFeeQueueTBL2[0], N_MSG_FEE);
	if ( xFeeQ[2] == NULL ) {
		vFailCreateNFEEQueue( 2 );
		bSuccess = FALSE;		
	}
	
	xFeeQ[3] = OSQCreate(&xFeeQueueTBL3[0], N_MSG_FEE);
	if ( xFeeQ[3] == NULL ) {
		vFailCreateNFEEQueue( 3 );
		bSuccess = FALSE;		
	}

	xFeeQ[4] = OSQCreate(&xFeeQueueTBL4[0], N_MSG_FEE);
	if ( xFeeQ[4] == NULL ) {
		vFailCreateNFEEQueue( 4 );
		bSuccess = FALSE;		
	}

	xFeeQ[5] = OSQCreate(&xFeeQueueTBL5[0], N_MSG_FEE);
	if ( xFeeQ[5] == NULL ) {
		vFailCreateNFEEQueue( 5 );
		bSuccess = FALSE;		
	}


	/* Syncronization (no THE sync) of the meb and signalization that has to wakeup */
	xMebQ = OSQCreate(&xMebQTBL[0], N_OF_MEB_MSG_QUEUE);
	if ( xMebQ == NULL ) {
		vFailCreateMebQueue( );
		bSuccess = FALSE;		
	}

	/* Syncronization (no THE sync) of the meb and signalization that has to wakeup */
	xLutQ = OSQCreate(&xLutQTBL[0], N_OF_LUT_MSG_QUEUE);
	if ( xLutQ == NULL ) {
		vFailCreateLUTQueue( );
		bSuccess = FALSE;
	}


	/* Mutex and Semaphores to control the communication of FastReaderTask */
	xMutexPus = OSMutexCreate(PCP_MUTEX_PUS_QUEUE, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexSPUSQueueMeb(err);
		bSuccess = FALSE;
	}


	/* This Queue is the fast way to comunicate with NFEE Controller task, the communication will be done by sending ints using MASKs*/
	xQMaskFeeCtrl = OSQCreate(&xQMaskCMDNFeeCtrlTBL[0], N_OF_MSG_QUEUE_MASK);
	if ( xQMaskFeeCtrl == NULL ) {
		vCouldNotCreateQueueMaskNfeeCtrl( );
		bSuccess = FALSE;		
	}

	/* This Queue is the fast way to comunicate with NFEE Controller task, the communication will be done by sending ints using MASKs*/
	xQMaskDataCtrl = OSQCreate(&xQMaskCMDNDataCtrlTBL[0], N_OF_MSG_QUEUE_MASK);
	if ( xQMaskDataCtrl == NULL ) {
		vCouldNotCreateQueueMaskDataCtrl( );
		bSuccess = FALSE;		
	}
/*
	xDma[0].xMutexDMA = OSMutexCreate(PCP_MUTEX_DMA_0, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexDMA();
		bSuccess = FALSE;
	}
*/
	xMutexDMAFTDI = OSMutexCreate(PCP_MUTEX_DMA_1, &err);
	if ( err != OS_ERR_NONE ) {
		vFailCreateMutexDMA();
		bSuccess = FALSE;
	}	

	/* Create the sync reset control comm queue [bndky] */
	xQueueSyncReset = OSQCreate(&xQueueSyncResetTBL[0], N_MESG_SYNCRST);		//TODO Change to define
	if (!xQueueSyncReset) {
		//vFailCreateSemaphoreResources(); TODO create error msg
		bSuccess = FALSE;
	}

	return bSuccess;
}

/* Global variables already initialized with zero. But better safe than sorry. */
void vVariablesInitialization ( void ) {
	unsigned char ucIL = 0;

	usiIdCMD = 2;

	memset( (void *)xInUseRetrans.b512 , FALSE , sizeof(xInUseRetrans.b512));
	memset( (void *)xInUseRetrans.b128 , FALSE , sizeof(xInUseRetrans.b128));
	memset( (void *)xInUseRetrans.b64 , FALSE , sizeof(xInUseRetrans.b64));
	memset( (void *)xInUseRetrans.b32 , FALSE , sizeof(xInUseRetrans.b32));
	


	for( ucIL = 0; ucIL < N_128_SENDER; ucIL++)
	{
		xBuffer128_Sender[ucIL].bInUse = FALSE;
		xBuffer128_Sender[ucIL].bPUS = FALSE;
		xBuffer128_Sender[ucIL].ucNofValues = 0;
		xBuffer128_Sender[ucIL].usiCat = 0;
		xBuffer128_Sender[ucIL].usiPid = 0;
		xBuffer128_Sender[ucIL].usiSubType = 0;
		xBuffer128_Sender[ucIL].usiType = 0;
		memset( (void *)xBuffer128_Sender[ucIL].buffer_128, 0, 128);
	}

	for( ucIL = 0; ucIL < N_128; ucIL++)
	{
		memset( (void *)xBuffer128[ucIL].buffer, 0, 128);
		xBuffer128[ucIL].bSent = FALSE;
		xBuffer128[ucIL].usiId = 0;
		xBuffer128[ucIL].usiTimeOut = 0;
		xBuffer128[ucIL].ucNofRetries = 0;
	}

	for( ucIL = 0; ucIL < N_64; ucIL++)
	{
		memset( (void *)xBuffer64[ucIL].buffer, 0, 64);
		xBuffer64[ucIL].bSent = FALSE;
		xBuffer64[ucIL].usiId = 0;
		xBuffer64[ucIL].usiTimeOut = 0;
		xBuffer64[ucIL].ucNofRetries = 0;
	}

	for( ucIL = 0; ucIL < N_32; ucIL++)
	{
		memset( (void *)xBuffer32[ucIL].buffer, 0, 32);
		xBuffer32[ucIL].bSent = FALSE;
		xBuffer32[ucIL].usiId = 0;
		xBuffer32[ucIL].usiTimeOut = 0;
		xBuffer32[ucIL].ucNofRetries = 0;
	}


	for( ucIL = 0; ucIL < N_PUS_PIPE; ucIL++)
	{
		xPus[ucIL].bInUse = FALSE;
		xPus[ucIL].ucNofValues = 0;
		memset( (void *)xPus[ucIL].usiValues, 0, sizeof(xPus[ucIL].usiValues));
	}

	for( ucIL = 0; ucIL < N_PREPARSED_ENTRIES; ucIL++)
	{
		xPreParsed[ucIL].cCommand = 0;
		xPreParsed[ucIL].cType = 0;
		xPreParsed[ucIL].ucCalculatedCRC8 = 0;
		xPreParsed[ucIL].ucErrorFlag = eNoError;
		xPreParsed[ucIL].ucMessageCRC8 = 0;
		xPreParsed[ucIL].ucNofBytes = 0;
		memset( (void *)xPreParsed[ucIL].usiValues, 0, sizeof(xPreParsed[ucIL].usiValues));
	}

	for( ucIL = 0; ucIL < N_ACKS_RECEIVED; ucIL++)
	{
		xReceivedACK[ucIL].cCommand = 0;
		xReceivedACK[ucIL].cType = 0;
		xReceivedACK[ucIL].usiId = 0;
	}

	for( ucIL = 0; ucIL < N_ACKS_SENDER; ucIL++)
	{
		xSenderACK[ucIL].cCommand = 0;
		xSenderACK[ucIL].cType = 0;
		xSenderACK[ucIL].usiId = 0;
	}
}

void vFillMemmoryPattern( TSimucam_MEB *xSimMebL );
void bInitFTDI(void);

/* Entry point */
int main(void)
{
	INT8U error_code;
	bool bIniSimucamStatus = FALSE;
	
	/* Debug device initialization - JTAG USB */
	#if DEBUG_ON
		fp = fopen(JTAG_UART_0_NAME, "r+");
	#endif	

	#if DEBUG_ON
		debug(fp, "Main entry point.\n");
	#endif

	/* Initialization of core HW */
	if (bInitSimucamCoreHW()){
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "SimuCam Release: %s\n", SIMUCAM_RELEASE);
		fprintf(fp, "SimuCam HW Version: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		fprintf(fp, "SimuCam FW Version: %s.%s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION, SIMUCAM_FW_VERSION);
		fprintf(fp, "\n");
#endif
	} else {
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "CRITICAL HW FAILURE: Hardware TimeStamp or System ID does not match the expected! SimuCam will be halted.\n");
		fprintf(fp, "CRITICAL HW FAILURE: Expected HW release: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		fprintf(fp, "CRITICAL HW FAILURE: SimuCam will be halted.\n");
		fprintf(fp, "\n");
#endif
		while (1) {}
	}

	OSInit();

	/* Test of some critical IPCores HW interfaces in the Simucam */
	bIniSimucamStatus = bTestSimucamCriticalHW();
	if (bIniSimucamStatus == FALSE) {
		vFailTestCriticasParts();
		return -1;
	}

	/* Initialization of basic HW */
	vInitSimucamBasicHW();

	/* Log file Initialization in the SDCard */
	bIniSimucamStatus = bInitializeSDCard();
	if (bIniSimucamStatus == FALSE) {
		vFailSDCard();
		return -1;
	}

	bIniSimucamStatus = vLoadDebugConfs();
	/*Check if the debug level was loaded */
	if ( (xDefaults.usiDebugLevel < 0) || (xDefaults.usiDebugLevel > 8) ) {
		#if DEBUG_ON
			debug(fp, "Didn't load Debug level from SDCard, setting to 4, Main messages and Main Progress.\n");
		#endif
		xDefaults.usiDebugLevel = 4;
	}
	if (bIniSimucamStatus == FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "Didn't load DEBUG configuration from SDCard. Default configuration will be loaded. \n");
		}
		#endif
		vCriticalErrorLedPanel();
		return -1;
	}

	/* Hard-coded DEBUG configurations due to dificulties in acessing the SD card. TODO: Remove later. */
	xDefaults.usiSyncPeriod     = 6250; /* ms */
	xDefaults.usiRows           = 4510;
	xDefaults.usiOLN            = 50;
	xDefaults.usiCols           = 2295;
	xDefaults.usiPreScanSerial  = 0;
	xDefaults.usiOverScanSerial = 0;
	xDefaults.ulStartDelay      = 0; /* ms */
	xDefaults.ulSkipDelay       = 110000; /* ns */
	xDefaults.ulLineDelay       = 90000; /* ns */
	xDefaults.ulADCPixelDelay   = 333; /* ns */
	xDefaults.bBufferOverflowEn = FALSE;
	xDefaults.ucRmapKey         = 209; /* 0xD1 */
	xDefaults.ucLogicalAddr     = 81; /* 0x51 */
	xDefaults.bSpwLinkStart     = FALSE;
	xDefaults.usiLinkNFEE0      = 0;
	xDefaults.usiGuardNFEEDelay = 50; /* ms */
	xDefaults.usiDebugLevel     = 4; /* Main Progress and main messages (ex. Syncs, state changes) */
	xDefaults.usiPatternType    = 0; /* Official URD */
	xDefaults.usiDataProtId     = 240; /* 0xF0 */
	xDefaults.usiDpuLogicalAddr = 80; /* 0x50 */
	xDefaults.ucReadOutOrder[0] = 0;
	xDefaults.ucReadOutOrder[1] = 1;
	xDefaults.ucReadOutOrder[2] = 2;
	xDefaults.ucReadOutOrder[3] = 3;
	xDefaults.usiSpwPLength     = 32140; /* 32k LESIA */
	xDefaults.usiPreBtSync      = 200; /* ms */

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		vShowDebugConfig();
	}
	#endif

	/* Load the Binding configuration ( FEE instance <-> SPWChannel ) */
	bIniSimucamStatus = vCHConfs();
	if (bIniSimucamStatus == FALSE) {
		/* Default configuration for eth connection loaded */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "Didn't load the bind configuration of the FEEs. \n");
		}
		#endif
		vCriticalErrorLedPanel();
		return -1;
	}

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
		fprintf(fp, "\nFEE binding Loaded from SDCard \n");
		fprintf(fp, "FEE 0 - Channel %hhu \n", xDefaultsCH.ucFEEtoChanell[0]);
		fprintf(fp, "FEE 1 - Channel %hhu \n", xDefaultsCH.ucFEEtoChanell[1]);
		fprintf(fp, "FEE 2 - Channel %hhu \n", xDefaultsCH.ucFEEtoChanell[2]);
		fprintf(fp, "FEE 3 - Channel %hhu \n", xDefaultsCH.ucFEEtoChanell[3]);
		fprintf(fp, "FEE 4 - Channel %hhu \n", xDefaultsCH.ucFEEtoChanell[4]);
		fprintf(fp, "FEE 5 - Channel %hhu \n", xDefaultsCH.ucFEEtoChanell[5]);
		fprintf(fp, "Channel 0 - FEE %hhu \n", xDefaultsCH.ucChannelToFEE[0]);
		fprintf(fp, "Channel 1 - FEE %hhu \n", xDefaultsCH.ucChannelToFEE[1]);
		fprintf(fp, "Channel 2 - FEE %hhu \n", xDefaultsCH.ucChannelToFEE[2]);
		fprintf(fp, "Channel 3 - FEE %hhu \n", xDefaultsCH.ucChannelToFEE[3]);
		fprintf(fp, "Channel 4 - FEE %hhu \n", xDefaultsCH.ucChannelToFEE[4]);
		fprintf(fp, "Channel 5 - FEE %hhu \n", xDefaultsCH.ucChannelToFEE[5]);
	}
	#endif

	bIniSimucamStatus = vLoadDefaultETHConf();
	if (bIniSimucamStatus == FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "Didn't load ETH configuration from SDCard. \n");
		}
		#endif
		vFailReadETHConf();
		return -1;
	}


	/* If debug is enable, will print the eth configuration in the*/
	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		vShowEthConfig();
	}
	#endif


	/* This function creates all resources needed by the RTOS*/
	bIniSimucamStatus = bResourcesInitRTOS();
	if (bIniSimucamStatus == FALSE) {
		/* Default configuration for eth connection loaded */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "Can't allocate resources for RTOS. (exit) \n");
		}
		#endif
		vFailInitRTOSResources();
		return -1;
	}

	vVariablesInitialization();

	/* Start the structure of control of the Simucam Application, including all FEEs instances */
	vSimucamStructureInit( &xSimMeb );

	bInitSync();

	bInitFTDI();

	//vFillMemmoryPattern( &xSimMeb ); //todo: To remove

	bSetPainelLeds( LEDS_OFF , LEDS_ST_ALL_MASK );
	bSetPainelLeds( LEDS_ON , LEDS_POWER_MASK );

	xGlobal.bSyncReset = FALSE;

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
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
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
		return -1;
	}
  
	return 0;
}

void vFillMemmoryPattern( TSimucam_MEB *xSimMebL ) {
	alt_u8 mem_number;
	alt_u32 mem_offset;
	alt_u8 ccd_number;
	alt_u8 ccd_side;
	alt_u32 width_cols;
	alt_u32 height_rows;
	alt_u8 NFee_i;


#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
		debug(fp, "\nStart to fill the memory with Pattern.\n");
	}
#endif

	/* memory 0 and 1*/
	for ( mem_number = 0; mem_number < 1; mem_number++ ){
		/* n NFEE */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
			fprintf(fp, "Memory %i\n",mem_number);
		}
		#endif
		for( NFee_i = 0; NFee_i < N_OF_NFEE; NFee_i++ ) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp, "--NFEE %i\n", NFee_i);
			}
			#endif
			/* 4 CCDs */
			height_rows = xSimMebL->xFeeControl.xNfee[NFee_i].xCcdInfo.usiHeight + xSimMebL->xFeeControl.xNfee[NFee_i].xCcdInfo.usiOLN;
			width_cols = xSimMebL->xFeeControl.xNfee[NFee_i].xCcdInfo.usiHalfWidth + xSimMebL->xFeeControl.xNfee[NFee_i].xCcdInfo.usiSOverscanN + xSimMebL->xFeeControl.xNfee[NFee_i].xCcdInfo.usiSPrescanN;
			for( ccd_number = 0; ccd_number < 4; ccd_number++ ) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp, "-----CCD %i\n", ccd_number);
				}
				#endif

				bSetPainelLeds( LEDS_OFF , LEDS_ST_ALL_MASK );
				bSetPainelLeds( LEDS_ON , (LEDS_ST_1_MASK << ccd_number) );

				for( ccd_side = 0; ccd_side < 2; ccd_side++ ) {
					if (ccd_side == 0){
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
							fprintf(fp, "------Left side\n");
						}
						#endif
						mem_offset = xSimMebL->xFeeControl.xNfee[NFee_i].xMemMap.xCcd[ccd_number].xLeft.ulOffsetAddr;
					} else {
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
							fprintf(fp, "------Right side\n");
						}
						#endif
						mem_offset = xSimMebL->xFeeControl.xNfee[NFee_i].xMemMap.xCcd[ccd_number].xRight.ulOffsetAddr;
					}
					pattern_createPattern(mem_number, mem_offset, ccd_number, ccd_side, width_cols, height_rows);
				}
			}
		}
	}

#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
	debug(fp, "\nMemory Filled\n");
	}
#endif

}

void bInitFTDI(void){

	vFtdiIrqRxHccdReceivedEn(TRUE);
	vFtdiIrqRxHccdCommErrEn(TRUE);
	vFtdiIrqTxLutFinishedEn(TRUE);
	vFtdiIrqTxLutCommErrEn(TRUE);
	vFtdiIrqGlobalEn(TRUE);
	bFtdiRxIrqInit();
	bFtdiTxIrqInit();

}
