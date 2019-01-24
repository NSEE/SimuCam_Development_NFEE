/*
 * sim_meb_task.h
 *
 *  Created on: 13/01/2019
 *      Author: TiagoLow
 */

#ifndef SIM_MEB_TASK_H_
#define SIM_MEB_TASK_H_

#include "../simucam_definitions.h"
#include "../utils/communication_configs.h"
#include "../utils/queue_commands_list.h"
#include "../utils/fee.h"
#include "../utils/ccd.h"
#include "../utils/meb.h"
#include "../utils/events_handler.h"


void vSimMebTask(void *task_data);

/* This function should treat the PUS command in the Config Mode, need check all the things that is possible to update in this mode */
void vPusMebInTaskConfigMode( TSimucam_MEB *pxMebCLocal );

/* This function should treat the PUS command in the Running Mode, need check all the things that is possible to update in this mode */
void vPusMebInTaskRunningMode( TSimucam_MEB *pxMebCLocal );
void vSendCmdQToNFeeCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );


#endif /* SIM_MEB_TASK_H_ */
