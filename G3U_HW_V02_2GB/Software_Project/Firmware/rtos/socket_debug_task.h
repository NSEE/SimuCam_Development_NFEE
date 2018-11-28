/*
 * socket_debug_task.h
 *
 *  Created on: 27/11/2018
 *      Author: Tiago-Low
 */

#ifndef SOCKET_DEBUG_TASK_H_
#define SOCKET_DEBUG_TASK_H_

#include "../simucam_defs_vars_structs_includes.h"
#include "simcam_tasks_configurations.h"


extern struct inet_taskinfo xNetTaskDebug;

extern TK_OBJECT(to_DebugTask);
extern TK_ENTRY(vSocketServerDebugTask);

#endif /* SOCKET_DEBUG_TASK_H_ */
