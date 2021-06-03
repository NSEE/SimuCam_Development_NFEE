/*
 * scom.c
 *
 *  Created on: 28/07/2020
 *      Author: rfranca
 */

#include "scom.h"

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

void vScomClearTimecode(void){

	volatile TScomChannel *vpxScomChannel = (TScomChannel *) (SCOM_BASE_ADDR);
	vpxScomChannel->xSSpwcTimecodeConfig.bClear = TRUE;

}

void vScomSoftRstMemAreaConfig(void){

	volatile TRmapMemArea *vpxRmapMemArea = (TRmapMemArea *)(SCOM_RMAP_MEM_BASE_ADDR);

	vpxRmapMemArea->xRmapMemAreaConfig = cxDefaultsRmapMemAreaConfig;

}

void vScomSoftRstMemAreaHk(void){

	volatile TRmapMemArea *vpxRmapMemArea = (TRmapMemArea *)(SCOM_RMAP_MEM_BASE_ADDR);

	vpxRmapMemArea->xRmapMemAreaHk = cxDefaultsRmapMemAreaHk;

}

void vScomInit(void){

	volatile TScomChannel *vpxScomChannel = (TScomChannel *) (SCOM_BASE_ADDR);

	vpxScomChannel->xSScomChannel.uliDevBaseAddr           = (alt_u32)(SCOM_BASE_ADDR);
	vpxScomChannel->xSSpwcDevAddr.uliSpwcBaseAddr          = (alt_u32)(SCOM_BASE_ADDR);
	vpxScomChannel->xSSpwcLinkConfig.bDisconnect           = FALSE;
	vpxScomChannel->xSSpwcLinkConfig.bLinkStart            = FALSE;
	vpxScomChannel->xSSpwcLinkConfig.bAutostart            = TRUE;
	vpxScomChannel->xSSpwcLinkConfig.ucTxDivCnt            = 1;
	vpxScomChannel->xSSpwcTimecodeConfig.bClear            = TRUE;
	vpxScomChannel->xSSpwcTimecodeConfig.bEnable           = TRUE;
	vpxScomChannel->xSRmapDevAddr.uliRmapBaseAddr          = (alt_u32)(SCOM_BASE_ADDR);
	vpxScomChannel->xSRmapCodecConfig.ucLogicalAddress     = 81; /* 0x51 */
	vpxScomChannel->xSRmapCodecConfig.ucKey                = 209; /* 0xD1 */
	vpxScomChannel->xSRmapMemConfig.uliWinAreaOffHighDword = 0;
	vpxScomChannel->xSRmapMemConfig.uliWinAreaOffLowDword  = 0;
	vpxScomChannel->xSRmapMemAreaPrt.puliRmapAreaPrt       = (TRmapMemArea *)(SCOM_RMAP_MEM_BASE_ADDR);
	vpxScomChannel->xSDataPacketConfig.usiPacketLength     = 32140; /* 32k LESIA */
	vpxScomChannel->xSDataPacketConfig.ucFeeMode           = 1u; /* N-FEE On Mode */
	vpxScomChannel->xSDataPacketConfig.ucCcdNumber         = 0;
	vpxScomChannel->xSDataPacketConfig.ucProtocolId        = 240; /* 0xF0 */
	vpxScomChannel->xSDataPacketConfig.ucLogicalAddr       = 80; /* 0x50 */
	vpxScomChannel->xSMachineControl.bStop                 = TRUE;
	vpxScomChannel->xSMachineControl.bClear                = TRUE;
	vpxScomChannel->xSMachineControl.bStart                = TRUE;
	vScomSoftRstMemAreaConfig();
	vScomSoftRstMemAreaHk();

}

//! [public functions]

//! [private functions]
//! [private functions]
