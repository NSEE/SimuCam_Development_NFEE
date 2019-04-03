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
#include "../api_driver/simucam_dma/simucam_dma.h"
#include "../driver/comm/data_packet/data_packet.h"
#include "../driver/comm/rmap/rmap.h"

void vFeeTask(void *task_data);
void vQCmdFEEinConfig( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinStandBy( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinFullPattern( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinWaitingSync( TNFee *pxNFeeP, unsigned int cmd );
bool bDisableSPWChannel( TSpwcChannel *xSPW );
bool bEnableSPWChannel( TSpwcChannel *xSPW );
bool bDisableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId );
bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId );
bool bEnableDbBuffer( TFeebChannel *pxFeebCh );
bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh );
bool bSendRequestNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bSendGiveBackNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
void vQCmdFeeRMAPinFullPattern( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinStandBy( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPWaitingSync( TNFee *pxNFeeP, unsigned int cmd );
void vLoadCtemp(void);
bool bPrepareDoubleBuffer( TCcdMemMap *xCcdMapLocal, unsigned char ucMem, unsigned char ucID, TNFee *pxNFee, unsigned char ucSide );
void vWaitUntilBufferEmpty( unsigned char ucId );
void vSetDoubleBufferLeftSize( unsigned char ucLength, unsigned char ucId );
void vSetDoubleBufferRightSize( unsigned char ucLength, unsigned char ucId );


#if DEBUG_ON
	void vPrintConsoleNFee( TNFee *pxNFee );
#endif


#endif /* FEE_TASK_H_ */
