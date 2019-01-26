/*
 * fee_task.h
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#ifndef FEE_TASK_H_
#define FEE_TASK_H_

#include "../simucam_definitions.h"
#include "tasks_configurations.h"
#include "../utils/ccd.h"
#include "../utils/fee.h"
#include "../utils/meb.h"
#include "../driver/comm/spw_controller/spw_controller.h"
#include "../driver/comm/comm_channel.h"
#include "../utils/queue_commands_list.h"

void vFeeTask(void *task_data);
void vFeeTask0(void *task_data);
void vQCmdFEEinConfig( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinStandBy( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinFullPattern( TNFee *pxNFeeP, unsigned int cmd );
bool bDisableSPWChannel( TSpwcChannel *xSPW );
bool bEnableSPWChannel( TSpwcChannel *xSPW );
bool bDisableRmapIRQ( TRmapChannel *pxRmapCh );
bool bEnableRmapIRQ( TRmapChannel *pxRmapCh );
bool bEnableDbBuffer( TFeebChannel *pxFeebCh );
bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh );

#ifdef DEBUG_ON
	void vPrintUARTNFee( TNFee *pxNFee );
	void vPrintConsoleNFee( TNFee *pxNFee );
#endif


#endif /* FEE_TASK_H_ */
