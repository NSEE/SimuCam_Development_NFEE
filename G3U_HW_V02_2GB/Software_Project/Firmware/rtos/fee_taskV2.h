/*
 * fee_taskV2.h
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */

#ifndef RTOS_FEE_TASKV2_H_
#define RTOS_FEE_TASKV2_H_


#include "../simucam_definitions.h"
#include "tasks_configurations.h"
#include "../utils/ccd.h"
#include "../utils/feeV2.h"
#include "../utils/meb.h"
#include "../driver/comm/spw_controller/spw_controller.h"
#include "../driver/comm/comm_channel.h"
#include "../utils/queue_commands_list.h"
#include "../api_driver/simucam_dma/simucam_dma.h"
#include "../driver/comm/data_packet/data_packet.h"
#include "../driver/comm/rmap/rmap.h"
#include "../driver/leds/leds.h"
#include "../utils/communication_configs.h"
#include "../utils/error_handler_simucam.h"

void vFeeTaskV2(void *task_data);
void vQCmdFEEinPreLoadBuffer( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinReadoutTrans( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinReadoutSync( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinWaitingSync( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinStandBy( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinOn( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinConfig( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinWaitingMemUpdate( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdWaitBeforeSyncSignal( TNFee *pxNFeeP, unsigned int cmd );
void vInitialConfig_RMAPCodecConfig( TNFee *pxNFeeP );
void vInitialConfig_DpktPacket( TNFee *pxNFeeP );
void vInitialConfig_RmapMemHKArea( TNFee *pxNFeeP );
void vSendMessageNUCModeFeeChange( unsigned char usIdFee, unsigned short int mode );
void vSetDoubleBufferLeftSize( unsigned char ucLength, unsigned char ucId );
void vSetDoubleBufferRightSize( unsigned char ucLength, unsigned char ucId );
void vWaitUntilBufferEmpty( unsigned char ucId );
unsigned long int uliReturnMaskR( unsigned char ucChannel );
unsigned long int uliReturnMaskG( unsigned char ucChannel );
bool bPrepareDoubleBuffer( TCcdMemMap *xCcdMapLocal, unsigned char ucMem, unsigned char ucID, TNFee *pxNFee, unsigned char ucSide, TFEETransmission xTransL );
bool bSendGiveBackNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bSendRequestNFeeCtrl_Front( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bSendRequestNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bSendMSGtoMebTask( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh );
bool bEnableDbBuffer( TNFee *pxNFeeP, TFeebChannel *pxFeebCh );
bool bEnableSPWChannel( TSpwcChannel *xSPW );
bool bDisableSPWChannel( TSpwcChannel *xSPW );
bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId );
bool bDisableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId );
void vQCmdFeeRMAPWaitingSync( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinStandBy( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinModeOn( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinWaitingMemUpdate( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPBeforeSync( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPReadoutSync( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinReadoutTrans( TNFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinPreLoadBuffer( TNFee *pxNFeeP, unsigned int cmd );




#endif /* RTOS_FEE_TASKV2_H_ */
