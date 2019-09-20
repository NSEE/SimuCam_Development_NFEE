/*
 * data_control_task.h
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */

#ifndef NFEE_CONTROL_TASK_H_
#define NFEE_CONTROL_TASK_H_

#include "../utils/events_handler.h"
#include "tasks_configurations.h"
#include "../simucam_definitions.h"
#include "../utils/feeV2.h"
#include "../utils/fee_controller.h"
#include "../utils/queue_commands_list.h"
#include "../utils/error_handler_simucam.h"
#include "../api_driver/simucam_dma/simucam_dma.h"


void vNFeeControlTask(void *task_data);
void vPerformActionNFCConfig( unsigned int uiCmdParam,  TNFee_Control *pxFeeCP );
void vPerformActionNFCRunning( unsigned int uiCmdParam, TNFee_Control *pxFeeCP );
bool bSendCmdQToNFeeInst( unsigned char ucFeeInstP, unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bSendCmdQToNFeeInst_Prio( unsigned char ucFeeInstP, unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );

#endif /* NFEE_CONTROL_TASK_H_ */
