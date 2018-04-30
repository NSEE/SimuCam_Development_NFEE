/*
 * rtos_tasks.h
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

#ifndef RTOS_TASKS_H_
#define RTOS_TASKS_H_

	#include "system.h"
	#include "alt_types.h"
	#include <altera_msgdma.h>

	#define SIMUCAM_TASK_STACKSIZE 2048

	#define MEM_DMA_TASK_PRIORITY 15
	#define SPW_A_TASK_PRIORITY   20
	#define SPW_B_TASK_PRIORITY   21
	#define SPW_C_TASK_PRIORITY   22
	#define SPW_D_TASK_PRIORITY   23
	#define SPW_E_TASK_PRIORITY   24
	#define SPW_F_TASK_PRIORITY   25
	#define SPW_G_TASK_PRIORITY   26
	#define SPW_H_TASK_PRIORITY   27
	#define LOG_TASK_PRIORITY     28
	
	extern alt_msgdma_dev *DMADev;

	void Init_Simucam_Tasks(void);

#endif /* RTOS_TASKS_H_ */
