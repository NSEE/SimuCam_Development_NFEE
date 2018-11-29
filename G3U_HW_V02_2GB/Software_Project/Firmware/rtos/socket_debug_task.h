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
#include "../network_utilities.h"
#include "../utils/configs_simucam.h"



extern struct inet_taskinfo xNetTaskDebug;


void vSocketHandleAccept(int listen_socket, SSSConn* conn);
void vHandleReceive(SSSConn* conn);
void vResetConnection(SSSConn* conn);

#endif /* SOCKET_DEBUG_TASK_H_ */
