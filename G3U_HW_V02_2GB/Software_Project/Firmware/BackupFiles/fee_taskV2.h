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

/* HK values enum [bndky] */

enum FeeHKValues{
    usiTouSense1 = 0, usiTouSense2, usiTouSense3, usiTouSense4, usiTouSense5, usiTouSense6,
    usiCcd1Ts, usiCcd2Ts, usiCcd3Ts, usiCcd4Ts, usiPrt1, usiPrt2, usiPrt3, usiPrt4, usiPrt5,
    usiZeroDiffAmp, usiCcd1VodMon, usiCcd1VogMon, usiCcd1VrdMonE, usiCcd2VodMon, usiCcd2VogMon,
    usiCcd2VrdMonE, usiCcd3VodMon, usiCcd3VogMon, usiCcd3VrdMonE, usiCcd4VodMon, usiCcd4VogMon,
    usiCcd4VrdMonE, usiVccd, usiVrclkMon, usiViclk, usiVrclkLow, usi5vbPosMon, usi5vbNegMon,
    usi3v3bMon, usi2v5aMon, usi3v3dMon, usi2v5dMon, usi1v5dMon, usi5vrefMon, usiVccdPosRaw,
    usiVclkPosRaw, usiVan1PosRaw, usiVan3NegMon, usiVan2PosRaw, usiVdigRaw, usiVdigRaw2,
    usiViclkLow, usiCcd1VrdMonF, usiCcd1VddMon, usiCcd1VgdMon, usiCcd2VrdMonF, usiCcd2VddMon,
    usiCcd2VgdMon, usiCcd3VrdMonF, usiCcd3VddMon, usiCcd3VgdMon, usiCcd4VrdMonF, usiCcd4VddMon,
    usiCcd4VgdMon, usiIgHiMon, usiIgLoMon, usiTsenseA, usiTsenseB
} EFeeHKValues;

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
void vUpdateFeeHKValue ( TNFee *pxNFeeP, unsigned short int usiID,  alt_u32 uliValue); /* [bndky] */



#endif /* RTOS_FEE_TASKV2_H_ */
