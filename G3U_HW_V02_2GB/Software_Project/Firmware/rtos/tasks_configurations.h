/* simcam_tasks_priorities.h
 *
 *  Created on: 28/11/2018
 *      Author: Tiago-Low
 */

#ifndef SIMCAM_TASKS_PRIORITIES_H_
#define SIMCAM_TASKS_PRIORITIES_H_

#include "../simucam_definitions.h"
#include "../utils/fee_controller.h"


/* Definition of Task Priorities */
/* Maximum of tasks configured in BSP is 32
 * The minimal priority configured in the BSP is 40 (but just 32 tasks!!!)
 * 0 -> MAX PRIORITY
 * 40 -> MIN PRIORITY  */
#define INITIALIZATION_TASK_PRIO        1
#define INITIALIZATION_TASK_PRIO_FAIL   39
#define RECEIVER_TASK_PRIO              36 	/* Never sleep - starving task (do not up the priority of this task)*/
#define TIMEOUT_CHECKER_PRIO            35
#define RESERVED_FOR_TIMER              29  /* This timer will be used for retransmission purposes (THIS WILL NOT BE USED IN THE CODE, IS JUST TO REMEMBER THAT OS_TASK_TMR_PRIO IS 29)*/
#define PARSER_TASK_PRIO				28
#define OUT_ACK_TASK_PRIO				27
#define SENDER_TASK_PRIO                26
#define IN_ACK_TASK_PRIO				25

#define PCP_MUTEX_PrePareseds           13   /* MUTEX Reader -> PARSER task*/
#define PCP_MUTEX_B32_PRIO              12   /* MUTEX Buffer TX char[32]*/
#define PCP_MUTEX_B64_PRIO              11   /* MUTEX Buffer TX char[64]*/
#define PCP_MUTEX_B128_PRIO             10   /* MUTEX Buffer TX char[128]*/
#define PCP_MUTEX_B128_PRIO_SENDER      9   /* MUTEX Buffer TX char[128]*/
#define PCP_MUTEX_RECEIVER_ACK          8   /* MUTEX Reader -> Ack receiver control*/
#define PCP_MUTEX_SENDER_ACK            7   /* MUTEX Reader -> Ack receiver control*/
#define PCP_MUTEX_TX_UART_PRIO          6   /* MUTEX TX UART*/

/*  Sync reset task will have a very high priority
 *  but will be suspended when not in use [bndky]
 */
#define SYNC_RESET_HIGH_PRIO            2

/* Main application priority */
/* FEE 19 .. 24 */
#define NFEE_TASK_BASE_PRIO             19
#define DATA_COTROL_TASK_PRIO           18
#define FEE_COTROL_TASK_PRIO            17
#define MEB_TASK_PRIO                   16
#define PCP_MUTEX_PUS_QUEUE             15
#define LUT_TASK_PRIO            		14
#define PCP_MUTEX_DMA_1                 5
//#define PCP_MUTEX_DMA_0                 4

#define STACK_MONITOR_TASK_PRIO			3   /* High*/

/* --------------- Timers ------------------ */
#define PERIOD_TIMER        4   /* In the BSP the Hz of the timer is 500 milli, period = 2 give me 2 sec */
#define DLY_TIMER           10 /* (ticks: 1 tick == 1 millisec) */
/* --------------- Timers ------------------ */


/* Definition of Task Stack size */
#if (STACK_MONITOR == 1)
/*    #define   TASK_STACKSIZE          1024*2
    #define   FEE_TASK_STACKSIZE      1024*2*/
	#define   TASK_STACKSIZE          1024
    #define   FEE_TASK_STACKSIZE      1024
    #define   HEAVY_TASK_STACKSIZE    1536
    #define   TINY_TASK_STACKSIZE     512   /*[bndky]*/
#else
    #define   TASK_STACKSIZE          1536//1024
    #define   FEE_TASK_STACKSIZE      1536//1024
    #define   HEAVY_TASK_STACKSIZE    2048//1536
    #define   TINY_TASK_STACKSIZE     512   /*[bndky]*/
#endif

/* Are equal only during the development */
#define INITIALIZATION_TASK_SIZE    TASK_STACKSIZE
#define RECEIVER_TASK_SIZE          HEAVY_TASK_STACKSIZE
#define PARSER_TASK_SIZE            HEAVY_TASK_STACKSIZE
#define IN_ACK_TASK_SIZE            TASK_STACKSIZE
#define OUT_ACK_TASK_SIZE           TASK_STACKSIZE
#define SENDER_TASK_SIZE            TASK_STACKSIZE
#define TIMEOUT_CHECKER_SIZE        TASK_STACKSIZE
#define STACK_MONITOR_SIZE          TASK_STACKSIZE
#define FEE_CONTROL_STACK_SIZE      HEAVY_TASK_STACKSIZE
#define DATA_CONTROL_STACK_SIZE     FEE_TASK_STACKSIZE /*todo: Maybe should increase in later versions*/
#define FEES_STACK_SIZE             FEE_TASK_STACKSIZE
#define MEB_STACK_SIZE              FEE_TASK_STACKSIZE /*todo: Maybe should increase in later versions*/
#define SYNC_RESET_STACK_SIZE       TINY_TASK_STACKSIZE /*[bndky]*/
#define LUT_STACK_SIZE             TINY_TASK_STACKSIZE

/* -------------- Definition of Stacks------------------ */
extern OS_STK    vInitialTask_stk[INITIALIZATION_TASK_SIZE];
extern OS_STK    vStackMonitor_stk[STACK_MONITOR_SIZE];

/* Communication tasks */
extern OS_STK    vReceiverUartTask_stk[RECEIVER_TASK_SIZE];
extern OS_STK    vParserCommTask_stk[PARSER_TASK_SIZE];
extern OS_STK    vInAckHandlerTask_stk[IN_ACK_TASK_SIZE];
extern OS_STK    vOutAckHandlerTask_stk[OUT_ACK_TASK_SIZE];
extern OS_STK    vTimeoutCheckerTask_stk[TIMEOUT_CHECKER_SIZE];
extern OS_STK    senderTask_stk[SENDER_TASK_SIZE];


/* Main application Tasks */
extern OS_STK    vNFeeControlTask_stk[FEE_CONTROL_STACK_SIZE];
extern OS_STK    vDataControlTask_stk[DATA_CONTROL_STACK_SIZE];
extern OS_STK    vSimMebTask_stk[MEB_STACK_SIZE];
extern OS_STK    vFeeTask0_stk[FEES_STACK_SIZE];
extern OS_STK    vFeeTask1_stk[FEES_STACK_SIZE];
extern OS_STK    vFeeTask2_stk[FEES_STACK_SIZE];
extern OS_STK    vFeeTask3_stk[FEES_STACK_SIZE];
extern OS_STK    vFeeTask4_stk[FEES_STACK_SIZE];
extern OS_STK    vFeeTask5_stk[FEES_STACK_SIZE];
extern OS_STK    vSyncReset_stk[SYNC_RESET_STACK_SIZE]; /*[bndky]*/
extern OS_STK    vLUT_stk[LUT_STACK_SIZE];
/* -------------- Definition of Stacks------------------ */




/* -------------- Definition of Queues--------------------*/
/* This Queue will sync any FEE instance that needs to receive any command, including access to DMA */
extern OS_EVENT *xFeeQ[N_OF_NFEE];		            /* Give access to the DMA by sincronization to a NFEE[i], and other commands */
//extern OS_EVENT *xWaitSyncQFee[N_OF_NFEE];		    /* Sync from Sync signal */

/* This Queue will be used to Schadule the access of the DMA, The ISR of "empty Buffer" will send message to this Queue with the Number of FEE that rises the IRQ */
extern void *xNfeeScheduleTBL[N_OF_MSG_QUEUE];
extern OS_EVENT *xNfeeSchedule;				        /* Queue that will receive from the ISR the NFEE Number that has empty buffer, in order to grant acess to the DMA */

/* This Queue is the fast way to comunicate with NFEE Controller task, the communication will be done by sending ints using MASKs*/
extern void *xQMaskCMDNFeeCtrlTBL[N_OF_MSG_QUEUE_MASK];
extern OS_EVENT *xQMaskFeeCtrl;

/* This Queue is the fast way to comunicate with NFEE Controller task, the communication will be done by sending ints using MASKs*/
extern void *xQMaskCMDNDataCtrlTBL[N_OF_MSG_QUEUE_MASK];
extern OS_EVENT *xQMaskDataCtrl;
/* -------------- Definition of Queues--------------------*/




/*---------------Semaphore and Mutex ---------------------*/
extern  OS_EVENT *xTxUARTMutex;


/*  Before access the any buffer for transmission the task should check in the Count Semaphore if has resource available
    if there is buffer free, the task should try to get the mutex in order to protect the integrity of the buffer */
extern OS_EVENT *xMutexBuffer128;
extern OS_EVENT *xMutexBuffer64;
extern OS_EVENT *xMutexBuffer32;

extern OS_EVENT *xSemCountBuffer512;
extern OS_EVENT *xSemCountBuffer128;
extern OS_EVENT *xSemCountBuffer64;
extern OS_EVENT *xSemCountBuffer32;



extern OS_EVENT *xSemCountReceivedACK;
extern OS_EVENT *xSemCountPreParsed;

extern OS_EVENT *xMutexReceivedACK;
extern OS_EVENT *xMutexPreParsed;

extern OS_EVENT *xSemTimeoutChecker;

extern OS_EVENT *xSemCountSenderACK;
extern OS_EVENT *xMutexSenderACK;

OS_EVENT *xMutexTranferBuffer;
extern OS_EVENT *xMutexDMAFTDI;

/* Struct for the DMA control */
typedef struct Dma{
    OS_EVENT *xMutexDMA;
    void (*pDmaTranfer)(alt_u32, alt_u16, alt_u8, alt_u8);
}tDmaSim;

extern tDmaSim xDma[2];

/*---------------Semaphore and Mutex ---------------------*/

/* --------------- Timers ------------------ */
extern OS_TMR *xTimerRetransmission;
/* --------------- Timers ------------------ */


extern unsigned short int usiGetIdCMD ( void );

#endif /* SIMCAM_TASKS_PRIORITIES_H_ */
