/*
 ************************************************************************************************
 *                                              NSEE
 *                                              IMT
 *
 *                                       All Rights Reserved
 *
 *
 * Filename     : sync_reset_task.h
 * Programmer(s): Yuri Bunduki
 * Created on: Jun 27, 2019
 * Description  : Header file for the sync_reset task.
 ************************************************************************************************
 */
/*$PAGE*/

#ifndef RTOS_SYNC_RESET_TASK_H_
#define RTOS_SYNC_RESET_TASK_H_


/*
************************************************************************************************
*                                        INCLUDE FILES
************************************************************************************************
*/
#include "../utils/configs_simucam.h"
#include "../utils/meb.h"               /* To get task prio */
#include "../utils/sync_handler.h"      /* Get sync manipulation methods */
#include "tasks_configurations.h"

/*$PAGE*/

/*
************************************************************************************************
*                                        CONSTANTS & MACROS
************************************************************************************************
*/

void vSyncResetTask(void *task_data);

extern OS_EVENT *xQueueSyncReset;
extern OS_EVENT *xFeeQ[N_OF_NFEE];

/*$PAGE*/

#endif /* RTOS_SYNC_RESET_TASK_H_ */

