/*
 * initialization_task.c
 *
 *  Created on: 27/11/2018
 *      Author: Tiago-Low
 *
 */

#include "initialization_task.h"

void vInitialTask(void *task_data)
{
	INT8U error_code = OS_ERR_NONE;

	#if ( STACK_MONITOR == 1)
		OSStatInit();
	#endif

/* ================== All the task that need syncronization should be started first ========================= */

	/* Create the first NFEE 0 Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[0],
									(void *)&vFeeTask0_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO,
									NFEE_TASK_BASE_PRIO,
									vFeeTask0_stk,
									FEES_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[0],
									(void *)&vFeeTask0_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO,
									NFEE_TASK_BASE_PRIO,
									vFeeTask0_stk,
									FEES_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
			vCoudlNotCreateNFee0Task();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);


	/* Create the first NFEE 1 Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[1],
									(void *)&vFeeTask1_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+1,
									NFEE_TASK_BASE_PRIO+1,
									vFeeTask1_stk,
									FEES_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[1],
									(void *)&vFeeTask1_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+1,
									NFEE_TASK_BASE_PRIO+1,
									vFeeTask1_stk,
									FEES_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
			printErrorTask( error_code );
		#endif
			vCoudlNotCreateNFee1Task();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);


	/* Create the first NFEE 2 Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[2],
									(void *)&vFeeTask2_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+2,
									NFEE_TASK_BASE_PRIO+2,
									vFeeTask2_stk,
									FEES_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[2],
									(void *)&vFeeTask2_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+2,
									NFEE_TASK_BASE_PRIO+2,
									vFeeTask2_stk,
									FEES_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		//* Can't create Task */
		#if DEBUG_ON
			printErrorTask( error_code );
		#endif
			vCoudlNotCreateNFee2Task();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);


	/* Create the first NFEE 3 Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[3],
									(void *)&vFeeTask3_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+3,
									NFEE_TASK_BASE_PRIO+3,
									vFeeTask3_stk,
									FEES_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[3],
									(void *)&vFeeTask3_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+3,
									NFEE_TASK_BASE_PRIO+3,
									vFeeTask3_stk,
									FEES_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
			printErrorTask( error_code );
		#endif
			vCoudlNotCreateNFee3Task();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);


	/* Create the first NFEE 4 Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[4],
									(void *)&vFeeTask4_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+4,
									NFEE_TASK_BASE_PRIO+4,
									vFeeTask4_stk,
									FEES_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[4],
									(void *)&vFeeTask4_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+4,
									NFEE_TASK_BASE_PRIO+4,
									vFeeTask4_stk,
									FEES_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
			printErrorTask( error_code );
		#endif
			vCoudlNotCreateNFee4Task();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);


	/* Create the first NFEE 5 Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[5],
									(void *)&vFeeTask5_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+5,
									NFEE_TASK_BASE_PRIO+5,
									vFeeTask5_stk,
									FEES_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vFeeTaskV3,
									&xSimMeb.xFeeControl.xNfee[5],
									(void *)&vFeeTask5_stk[FEES_STACK_SIZE-1],
									NFEE_TASK_BASE_PRIO+5,
									NFEE_TASK_BASE_PRIO+5,
									vFeeTask5_stk,
									FEES_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
			printErrorTask( error_code );
		#endif
			vCoudlNotCreateNFee5Task();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);

	
	/* Create the first Data Controller Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vDataControlTaskV2,
									&xSimMeb.xDataControl,
									(void *)&vDataControlTask_stk[DATA_CONTROL_STACK_SIZE-1],
									DATA_COTROL_TASK_PRIO,
									DATA_COTROL_TASK_PRIO,
									vDataControlTask_stk,
									DATA_CONTROL_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vDataControlTaskV2,
									&xSimMeb.xDataControl,
									(void *)&vDataControlTask_stk[DATA_CONTROL_STACK_SIZE-1],
									DATA_COTROL_TASK_PRIO,
									DATA_COTROL_TASK_PRIO,
									vDataControlTask_stk,
									DATA_CONTROL_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
			vCoudlNotCreateDataControllerTask();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);



	/* Create the first NFee Controller Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vNFeeControlTaskV3,
									&xSimMeb.xFeeControl,
									(void *)&vNFeeControlTask_stk[FEE_CONTROL_STACK_SIZE-1],
									FEE_COTROL_TASK_PRIO,
									FEE_COTROL_TASK_PRIO,
									vNFeeControlTask_stk,
									FEE_CONTROL_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vNFeeControlTaskV3,
									&xSimMeb.xFeeControl,
									(void *)&vNFeeControlTask_stk[FEE_CONTROL_STACK_SIZE-1],
									FEE_COTROL_TASK_PRIO,
									FEE_COTROL_TASK_PRIO,
									vNFeeControlTask_stk,
									FEE_CONTROL_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
			vCoudlNotCreateNFeeControllerTask();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);



	/* Create the LUT handler task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vLutHandlerTask,
									&xSimMeb,
									(void *)&vLUT_stk[LUT_STACK_SIZE-1],
									LUT_TASK_PRIO,
									LUT_TASK_PRIO,
									vLUT_stk,
									LUT_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vLutHandlerTask,
									&xSimMeb,
									(void *)&vLUT_stk[LUT_STACK_SIZE-1],
									LUT_TASK_PRIO,
									LUT_TASK_PRIO,
									vLUT_stk,
									LUT_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
			vCoudlNotCreateNFeeControllerTask();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);



	/* Create the first Meb Controller Task */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vSimMebTask,
									&xSimMeb,
									(void *)&vSimMebTask_stk[MEB_STACK_SIZE-1],
									MEB_TASK_PRIO,
									MEB_TASK_PRIO,
									vSimMebTask_stk,
									MEB_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vSimMebTask,
									&xSimMeb,
									(void *)&vSimMebTask_stk[MEB_STACK_SIZE-1],
									MEB_TASK_PRIO,
									MEB_TASK_PRIO,
									vSimMebTask_stk,
									MEB_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
			vCoudlNotCreateMebTask();
	}


	OSTimeDlyHMSM(0, 0, 0, 1500);



	/* Create the task that is responsible to send the ack to NUC of the incomming messages */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vTimeoutCheckerTaskv2,
									NULL,
									(void *)&vTimeoutCheckerTask_stk[TIMEOUT_CHECKER_SIZE-1],
									TIMEOUT_CHECKER_PRIO,
									TIMEOUT_CHECKER_PRIO,
									vTimeoutCheckerTask_stk,
									TIMEOUT_CHECKER_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vTimeoutCheckerTaskv2,
									NULL,
									(void *)&vTimeoutCheckerTask_stk[TIMEOUT_CHECKER_SIZE-1],
									TIMEOUT_CHECKER_PRIO,
									TIMEOUT_CHECKER_PRIO,
									vTimeoutCheckerTask_stk,
									TIMEOUT_CHECKER_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task for receive comm packets */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
		vFailTimeoutCheckerTaskCreate();
	}


	OSTimeDlyHMSM(0, 0, 0, 200);


	/* Create the task that is responsible to send the ack to NUC of the incomming messages */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vOutAckHandlerTask,
									NULL,
									(void *)&vOutAckHandlerTask_stk[OUT_ACK_TASK_SIZE-1],
									OUT_ACK_TASK_PRIO,
									OUT_ACK_TASK_PRIO,
									vOutAckHandlerTask_stk,
									OUT_ACK_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vOutAckHandlerTask,
									NULL,
									(void *)&vOutAckHandlerTask_stk[OUT_ACK_TASK_SIZE-1],
									OUT_ACK_TASK_PRIO,
									OUT_ACK_TASK_PRIO,
									vOutAckHandlerTask_stk,
									OUT_ACK_TASK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task for receive comm packets */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
		vFailOutAckHandlerTaskCreate();
	}


	OSTimeDlyHMSM(0, 0, 0, 200);


	/* Create the task that is responsible to handle incomming ack packet */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vInAckHandlerTaskV2,
									NULL,
									(void *)&vInAckHandlerTask_stk[IN_ACK_TASK_SIZE-1],
									IN_ACK_TASK_PRIO,
									IN_ACK_TASK_PRIO,
									vInAckHandlerTask_stk,
									IN_ACK_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vInAckHandlerTaskV2,
									NULL,
									(void *)&vInAckHandlerTask_stk[IN_ACK_TASK_SIZE-1],
									IN_ACK_TASK_PRIO,
									IN_ACK_TASK_PRIO,
									vInAckHandlerTask_stk,
									IN_ACK_TASK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task for receive comm packets */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
		vFailInAckHandlerTaskCreate();
	}


	OSTimeDlyHMSM(0, 0, 0, 200);


	/* Create the task that is responsible to parse all received messages */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vParserCommTask,
									NULL,
									(void *)&vParserCommTask_stk[PARSER_TASK_SIZE-1],
									PARSER_TASK_PRIO,
									PARSER_TASK_PRIO,
									vParserCommTask_stk,
									PARSER_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CHK + OS_TASK_OPT_STK_CLR);
	#else
		error_code = OSTaskCreateExt(vParserCommTask,
									NULL,
									(void *)&vParserCommTask_stk[PARSER_TASK_SIZE-1],
									PARSER_TASK_PRIO,
									PARSER_TASK_PRIO,
									vParserCommTask_stk,
									PARSER_TASK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task for receive comm packets */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
		vFailParserCommTaskCreate();
	}


	OSTimeDlyHMSM(0, 0, 0, 200);


	/* READ: Create the task that is responsible to READ UART buffer */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vReceiverUartTask,
									NULL,
									(void *)&vReceiverUartTask_stk[RECEIVER_TASK_SIZE-1],
									RECEIVER_TASK_PRIO,
									RECEIVER_TASK_PRIO,
									vReceiverUartTask_stk,
									RECEIVER_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CHK + OS_TASK_OPT_STK_CLR);
	#else
		error_code = OSTaskCreateExt(vReceiverUartTask,
									NULL,
									(void *)&vReceiverUartTask_stk[RECEIVER_TASK_SIZE-1],
									RECEIVER_TASK_PRIO,
									RECEIVER_TASK_PRIO,
									vReceiverUartTask_stk,
									RECEIVER_TASK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task for receive comm packets */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
		vFailReceiverCreate();
	}


	OSTimeDlyHMSM(0, 0, 0, 200);


	/* Create Sync-Reset Task [bndky] */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vSyncResetTask,
									&xSimMeb,
									(void *)&vSyncReset_stk[SYNC_RESET_STACK_SIZE-1],
									SYNC_RESET_HIGH_PRIO,
									SYNC_RESET_HIGH_PRIO,
									vSyncReset_stk,
									SYNC_RESET_STACK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vSyncResetTask,
									&xSimMeb,
									(void *)&vSyncReset_stk[SYNC_RESET_STACK_SIZE-1],
									SYNC_RESET_HIGH_PRIO,
									SYNC_RESET_HIGH_PRIO,
									vSyncReset_stk,
									SYNC_RESET_STACK_SIZE,
									NULL,
									0);
	#endif

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
		vFailSyncResetCreate();
	}

	OSTimeDlyHMSM(0, 0, 0, 200);


	/* SEND: Create the task that is responsible to SEND UART packets */
	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vSenderComTask,
									NULL,
									(void *)&senderTask_stk[SENDER_TASK_SIZE-1],
									SENDER_TASK_PRIO,
									SENDER_TASK_PRIO,
									senderTask_stk,
									SENDER_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR | OS_TASK_OPT_STK_CHK);
	#else
		error_code = OSTaskCreateExt(vSenderComTask,
									NULL,
									(void *)&senderTask_stk[SENDER_TASK_SIZE-1],
									SENDER_TASK_PRIO,
									SENDER_TASK_PRIO,
									senderTask_stk,
									SENDER_TASK_SIZE,
									NULL,
									0);
	#endif



	OSTimeDlyHMSM(0, 0, 0, 200);



	#if ( STACK_MONITOR == 1)
		error_code = OSTaskCreateExt(vStackMonitor,
									NULL,
									(void *)&vStackMonitor_stk[STACK_MONITOR_SIZE-1],
									STACK_MONITOR_TASK_PRIO,
									STACK_MONITOR_TASK_PRIO,
									vStackMonitor_stk,
									STACK_MONITOR_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR | OS_TASK_OPT_STK_CHK);
	#endif


	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
		fprintf(fp,"\n__________ Waiting NUC load _________ \n\n");
	}
	#endif



	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task for sender comm packets */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );
		}
		#endif
		vFailSenderCreate();
	}

	/*	This is the timer that's trigger the task that implements the timeout/retransmission logic*/
	OSTmrStart ((OS_TMR *)xTimerRetransmission, (INT8U  *)&error_code);
	if ( error_code != OS_ERR_NONE) {
		/*	Could not create the timer that syncs the task that is responsible to retransmit the packets*/
		vFailStartTimerRetransmission();
	}


	OSTimeDlyHMSM(0, 0, 1, 0);


	/* Delete the Initialization Task  */
	error_code = OSTaskDel(OS_PRIO_SELF); /* OS_PRIO_SELF = Means task self priority */
	if ( error_code != OS_ERR_NONE) {
		/*	Can't delete the initialization task, the problem is that the priority of this
			is that the PRIO is so high that will cause starvation if not deleted */
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			printErrorTask( error_code );		
		}
		#endif
		vFailDeleteInitialization();
		/*	To not exit the intire application, the PRIO of this task will be lowered*/
		OSTaskChangePrio( INITIALIZATION_TASK_PRIO , INITIALIZATION_TASK_PRIO_FAIL );

		for(;;) { /* Correct Program Flow should never get here */
			OSTaskDel(OS_PRIO_SELF); /* Try to delete it self */
			OSTimeDlyHMSM(0,0,10,0); /* 1 sec */
		}
	}

}
