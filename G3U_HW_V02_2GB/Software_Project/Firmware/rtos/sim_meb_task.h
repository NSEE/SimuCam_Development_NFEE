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
#include "../utils/feeV2.h"
#include "../utils/ccd.h"
#include "../utils/meb.h"
#include "../utils/events_handler.h"
#include "../utils/sync_handler.h"
#include "../driver/sync/sync.h"
#include "../driver/comm/rmap/rmap.h"
#include "../driver/comm/comm_channel.h"
#include "../driver/ctrl_io_lvds/ctrl_io_lvds.h"
#include "fee_taskV2.h"


void vSimMebTask(void *task_data);

void vDebugSyncTimeCode( TSimucam_MEB *pxMebCLocal );

void vPusMebTask( TSimucam_MEB *pxMebCLocal );

/* This function should treat the PUS command in the Config Mode, need check all the things that is possible to update in this mode */
void vPusMebInTaskConfigMode( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL );

/* This function should treat the PUS command in the Running Mode, need check all the things that is possible to update in this mode */
void vPusMebInTaskRunningMode( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL );

void vPusType250conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL );
void vPusType251conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL );
void vPusType252conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL );

void vPusType250run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL );
void vPusType251run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL );
void vPusType252run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL );


void vMebChangeToConfig( TSimucam_MEB *pxMebCLocal );
void vMebChangeToRunning( TSimucam_MEB *pxMebCLocal );
void vSendCmdQToNFeeCTRL_GEN( unsigned char usiFeeInstP,unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );

void vMebInit(TSimucam_MEB *pxMebCLocal);
//void vReleaseSyncMessages(void);
void vSwapMemmory(TSimucam_MEB *pxMebCLocal);
void vEnterConfigRoutine( TSimucam_MEB *pxMebCLocal );
void vSendMessageNUCModeMEBChange(  unsigned short int mode  );

void vPerformActionMebInConfig( unsigned int uiCmdParam, TSimucam_MEB *pxMebCLocal );
void vPerformActionMebInRunning( unsigned int uiCmdParam, TSimucam_MEB *pxMebCLocal );


#endif /* SIM_MEB_TASK_H_ */
