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

	#define SIMUCAM_TASK_STACKSIZE 2048

	#define SPW_A_TASK_PRIORITY 10
	#define SPW_B_TASK_PRIORITY 11
	#define SPW_C_TASK_PRIORITY 12
	#define SPW_D_TASK_PRIORITY 13
	#define SPW_E_TASK_PRIORITY 14
	#define SPW_F_TASK_PRIORITY 15
	#define SPW_G_TASK_PRIORITY 16
	#define SPW_H_TASK_PRIORITY 17
	#define LOG_TASK_PRIORITY   18

	void Init_Log_Task(void);
	void Init_SPW_A_Task(void);
	void Init_SPW_B_Task(void);
	void Init_SPW_C_Task(void);
	void Init_SPW_D_Task(void);
	void Init_SPW_E_Task(void);
	void Init_SPW_F_Task(void);
	void Init_SPW_G_Task(void);
	void Init_SPW_H_Task(void);
	void Init_Simucam_Tasks(void);

#endif /* RTOS_TASKS_H_ */
