#include <stdio.h>
#include "string.h"
#include "simucam_definitions.h"
#include "error_handler_simucam.h"
#include "rtos/simcam_tasks_configurations.h"
#include "includes.h"

#ifdef DEBUG_ON
    FILE* fp;
#endif

/* Prints "Hello World" and sleeps for three seconds */
void task1(void* pdata)
{
	char p[20];
	char entrada[100];
	int size1, size2;

	while (1)
	{
		//fwrite( "tarefa 1 \r\n", strlen("tarefa 1 \r\n"),1 , fp  );
		//fseek( fp, 0, SEEK_SET );
		//fread(entrada,  5, 1  , fp);

		scanf("%c%c",&entrada[0],&entrada[1]);

		//p[0] = getc(fp);

		//fwrite( "chegou: \r\n", strlen("chegou: \r\n"),1 , fp  );
		//fwrite( p, 2,1 , fp  );
		//printf("%s",entrada);
		//gets(p);


		printf("Hello from task1 p= %c%c \n", entrada[0],entrada[1]);
		fwrite( "Hello from task1\n", strlen("Hello from task1\n"),1 , fp  );
		OSTimeDlyHMSM(0, 0, 3, 0);
	}
}
/* Prints "Hello World" and sleeps for three seconds */
void task2(void* pdata)
{
  while (1)
  { 
	  //fseek( fp, 0, SEEK_SET );
	  //fwrite( "tarefa 2 \r\n", strlen("tarefa 2 \r\n"),1 , fp  );
	  //fprintf(fp , "tarefa 2 \r\n" );
	  printf("Hello from task2\n");
	  fwrite( "Hello from task2\n", strlen("Hello from task2\n"),1 , fp  );
	  OSTimeDlyHMSM(0, 0, 3, 0);
  }
}
/* The main function creates two task and starts multi-tasking */
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