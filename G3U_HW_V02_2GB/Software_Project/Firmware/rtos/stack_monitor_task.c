/*
 * stack_monitor_task.c
 *
 *  Created on: 20/01/2019
 *      Author: Tiago-note
 */

#include "stack_monitor_task.h"

#define RS232	0

#if (RS232 == 1) /* So use the serial to export the report */

void vStackMonitor(void *task_data) {
	INT8U ucErrorCode = 0;
	OS_STK_DATA data;
	char cBuffer[128];

    #if DEBUG_ON
        debug(fp,"vStackMonitor, enter task.\n");
    #endif

    for (;;) {

    	printf( "=========== STACK MONITOR =================\n" );
    	printf( " Task           Total               Free             In use  \n" );

    	ucErrorCode = OSTaskStkChk( RECEIVER_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE ) {

    		printf( " %s           %4ld              %4ld              %4ld  \n",
    				"RECEIVER_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		printf( " Could not get RECEIVER_TASK stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( TIMEOUT_CHECKER_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		printf( " %s           %4ld              %4ld              %4ld  \n",
    				"TIMEOUT_CHECKER",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		printf( " Could not get TIMEOUT_CHECKER stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( PARSER_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		printf( " %s           %4ld              %4ld              %4ld  \n",
    				"PARSER_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		printf( " Could not get PARSER_TASK stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( OUT_ACK_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		printf( " %s           %4ld              %4ld              %4ld  \n",
    				"OUT_ACK_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		printf( " Could not get OUT_ACK_TASK stack \n" );
    	}



    	ucErrorCode = OSTaskStkChk( SENDER_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		printf( " %s           %4ld              %4ld              %4ld  \n",
    				"SENDER_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		printf( " Could not get SENDER_TASK stack \n" );
    	}



    	ucErrorCode = OSTaskStkChk( IN_ACK_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		printf( " %s           %4ld              %4ld              %4ld  \n",
    				"IN_ACK_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		printf( " Could not get IN_ACK_TASK stack \n" );
    	}

    	printf( "\n" );

    	OSTimeDlyHMSM(0, 0, 0, 20);
    }
}

#else
#if DEBUG_ON
void vStackMonitor(void *task_data) {
	INT8U ucErrorCode = 0;
	OS_STK_DATA data;


        debug(fp,"vStackMonitor, enter task.\n");


    for (;;) {

    	fprintf(fp, "=========== STACK MONITOR =================\n" );
    	fprintf(fp, " Task           Total               Free             In use  \n" );

    	ucErrorCode = OSTaskStkChk( RECEIVER_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"RECEIVER_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get RECEIVER_TASK stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( TIMEOUT_CHECKER_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"TIMEOUT_CHECKER",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get TIMEOUT_CHECKER stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( PARSER_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"PARSER_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get PARSER_TASK stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( OUT_ACK_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"OUT_ACK_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get OUT_ACK_TASK stack \n" );
    	}



    	ucErrorCode = OSTaskStkChk( SENDER_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"SENDER_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get SENDER_TASK stack \n" );
    	}



    	ucErrorCode = OSTaskStkChk( IN_ACK_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"IN_ACK_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get IN_ACK_TASK stack \n" );
    	}

 
    	ucErrorCode = OSTaskStkChk( INITIALIZATION_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"INITI_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get INIT_TASK stack \n" );
    	}



    	ucErrorCode = OSTaskStkChk( NFEE_TASK_BASE_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"FEE_TASK-0",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get FEE_TASK - 0 stack \n" );
    	}



    	ucErrorCode = OSTaskStkChk( NFEE_TASK_BASE_PRIO+1 , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"FEE_TASK-1",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get FEE_TASK - 1 stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( NFEE_TASK_BASE_PRIO+2 , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"FEE_TASK-2",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get FEE_TASK - 2 stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( NFEE_TASK_BASE_PRIO+3 , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"FEE_TASK-3",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get FEE_TASK - 3 stack \n" );
    	}



    	ucErrorCode = OSTaskStkChk( NFEE_TASK_BASE_PRIO+4 , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"FEE_TASK-4",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get FEE_TASK - 4 stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( NFEE_TASK_BASE_PRIO+5 , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"FEE_TASK-5",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get FEE_TASK - 5 stack \n" );
    	}

    	ucErrorCode = OSTaskStkChk( DATA_COTROL_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"DATA_COTROL",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get DATA_COTROL stack \n" );
    	}


    	ucErrorCode = OSTaskStkChk( FEE_COTROL_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"FEE_COTROL",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get FEE_COTROL stack \n" );
    	}

    	ucErrorCode = OSTaskStkChk( MEB_TASK_PRIO , &data);
    	if ( ucErrorCode == OS_ERR_NONE  ) {

    		fprintf(fp, " %s           %4ld              %4ld              %4ld  \n",
    				"MEB_TASK",
    				data.OSFree + data.OSUsed,
                    data.OSFree,
                    data.OSUsed );

    	} else {
    		fprintf(fp, " Could not get MEB_TASK stack \n" );
    	}		


    	fprintf(fp, "\n" );

    	OSTimeDlyHMSM(0, 0, 10, 0);
    }
}
#endif
#endif

