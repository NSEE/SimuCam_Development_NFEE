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

	/* READ: Create the task that is responsible to READ UART buffer */
	#if STACK_MONITOR
		error_code = OSTaskCreateExt(vReceiverUartTask,
									NULL,
									(void *)&vReceiverUartTask_stk[RECEIVER_TASK_SIZE-1],
									RECEIVER_TASK_PRIO,
									RECEIVER_TASK_PRIO,
									vReceiverUartTask_stk,
									RECEIVER_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CLR);


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
		#ifdef DEBUG_ON
			printErrorTask( error_code );		
		#endif
		vFailReceiverCreate();
	}


	/* Create the task that is responsible to parse all received messages */
	#if STACK_MONITOR
		error_code = OSTaskCreateExt(vParserCommTask,
									NULL,
									(void *)&vParserCommTask_stk[PARSER_TASK_SIZE-1],
									PARSER_TASK_PRIO,
									PARSER_TASK_PRIO,
									vParserCommTask_stk,
									PARSER_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CLR);


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
		#ifdef DEBUG_ON
			printErrorTask( error_code );
		#endif
		vFailParserCommTaskCreate();
	}


	/* Create the task that is responsible to handle incomming ack packet */
	#if STACK_MONITOR
		error_code = OSTaskCreateExt(vInAckHandlerTask,
									NULL,
									(void *)&vInAckHandlerTask_stk[IN_ACK_TASK_SIZE-1],
									IN_ACK_TASK_PRIO,
									IN_ACK_TASK_PRIO,
									vInAckHandlerTask_stk,
									IN_ACK_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CLR);


	#else
		error_code = OSTaskCreateExt(vInAckHandlerTask,
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
		#ifdef DEBUG_ON
			printErrorTask( error_code );
		#endif
		vFailInAckHandlerTaskCreate();
	}



	/* Create the task that is responsible to send the ack to NUC of the incomming messages */
	#if STACK_MONITOR
		error_code = OSTaskCreateExt(vOutAckHandlerTask,
									NULL,
									(void *)&vOutAckHandlerTask_stk[OUT_ACK_TASK_SIZE-1],
									OUT_ACK_TASK_PRIO,
									OUT_ACK_TASK_PRIO,
									vOutAckHandlerTask_stk,
									OUT_ACK_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CLR);


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
		#ifdef DEBUG_ON
			printErrorTask( error_code );
		#endif
		vFailOutAckHandlerTaskCreate();
	}




	/* SEND: Create the task that is responsible to SEND UART packets */
	#if STACK_MONITOR
		error_code = OSTaskCreateExt(vSenderComTask,
									NULL,
									(void *)&senderTask_stk[SENDER_TASK_SIZE-1],
									SENDER_TASK_PRIO,
									SENDER_TASK_PRIO,
									senderTask_stk,
									SENDER_TASK_SIZE,
									NULL,
									OS_TASK_OPT_STK_CLR + OS_TASK_OPT_STK_CLR);


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

	if ( error_code != OS_ERR_NONE) {
		/* Can't create Task for sender comm packets */
		#ifdef DEBUG_ON
			printErrorTask( error_code );		
		#endif
		vFailSenderCreate();
	}


	/* Delete the Initialization Task  */
	error_code = OSTaskDel(OS_PRIO_SELF); /* OS_PRIO_SELF = Means task self priority */
	if ( error_code != OS_ERR_NONE) {
		/*	Can't delete the initialization task, the problem is that the priority of this
			is that the PRIO is so high that will cause starvation if not deleted */
		#ifdef DEBUG_ON
			printErrorTask( error_code );		
		#endif
		vFailDeleteInitialization();
		/*	To not exit the intire application, the PRIO of this task will be lowered*/
		OSTaskChangePrio( INITIALIZATION_TASK_PRIO , INITIALIZATION_TASK_PRIO_FAIL );
	}

	for(;;) { /* Correct Program Flow should never get here */
		OSTaskDel(OS_PRIO_SELF); /* Try to delete it self */
		OSTimeDlyHMSM(0,0,10,0); /* 1 sec */
	}
		
	 
}
