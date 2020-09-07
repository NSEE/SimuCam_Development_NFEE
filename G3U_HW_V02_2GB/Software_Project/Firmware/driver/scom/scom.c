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

	vpxRmapMemArea->xRmapMemAreaConfig.usiVStart = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiVEnd = 4539;
	vpxRmapMemArea->xRmapMemAreaConfig.usiChargeInjectionWidth = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiChargeInjectionGap = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiParallelToiPeriod = 0x0465;
	vpxRmapMemArea->xRmapMemAreaConfig.usiParallelClkOverlap = 0x00FA;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd = 1;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd = 2;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd = 3;
	vpxRmapMemArea->xRmapMemAreaConfig.usiNFinalDump = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiHEnd = 2294;
	vpxRmapMemArea->xRmapMemAreaConfig.bChargeInjectionEn = FALSE;
	vpxRmapMemArea->xRmapMemAreaConfig.bTriLevelClkEn = FALSE;
	vpxRmapMemArea->xRmapMemAreaConfig.bImgClkDir = FALSE;
	vpxRmapMemArea->xRmapMemAreaConfig.bRegClkDir = FALSE;
	vpxRmapMemArea->xRmapMemAreaConfig.usiPacketSize = 32140;
	vpxRmapMemArea->xRmapMemAreaConfig.usiIntSyncPeriod = 6250;
	vpxRmapMemArea->xRmapMemAreaConfig.uliTrapPumpingDwellCounter = 250000;
	vpxRmapMemArea->xRmapMemAreaConfig.bSyncSel = FALSE;
	vpxRmapMemArea->xRmapMemAreaConfig.ucSensorSel = 3;
	vpxRmapMemArea->xRmapMemAreaConfig.bDigitiseEn = TRUE;
	vpxRmapMemArea->xRmapMemAreaConfig.bDGEn = FALSE;
	vpxRmapMemArea->xRmapMemAreaConfig.bCcdReadEn = TRUE;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg5ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd1WinListPtr = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd1PktorderListPtr = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1WinListLength = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd1WinSizeX = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd1WinSizeY = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg8ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd2WinListPtr = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd2PktorderListPtr = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2WinListLength = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2WinSizeX = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2WinSizeY = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg11ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd3WinListPtr = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd3PktorderListPtr = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3WinListLength = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd3WinSizeX = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd3WinSizeY = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg14ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd4WinListPtr = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd4PktorderListPtr = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4WinListLength = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd4WinSizeX = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd4WinSizeY = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg17ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcdVodConfig = 3276;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1VrdConfig = 3685;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2VrdConfig0 = 101;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2VrdConfig1 = 14;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3VrdConfig = 3685;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4VrdConfig = 3685;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdVgdConfig0 = 12;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdVgdConfig1 = 204;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcdVogConfig = 410;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcdIgHiConfig = 3276;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcdIgLoConfig = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiReg21ConfigReserved0 = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdModeConfig = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg21ConfigReserved1 = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.bClearErrorFlag = FALSE;
	vpxRmapMemArea->xRmapMemAreaConfig.uliReg22ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1LastEPacket = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1LastFPacket = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2LastEPacket = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg23ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2LastFPacket = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3LastEPacket = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3LastFPacket = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg24ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4LastEPacket = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4LastFPacket = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiSurfaceInversionCounter = 100;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg25ConfigReserved = 0;
	vpxRmapMemArea->xRmapMemAreaConfig.usiReadoutPauseCounter = 2000;
	vpxRmapMemArea->xRmapMemAreaConfig.usiTrapPumpingShuffleCounter = 1000;

}

void vScomSoftRstMemAreaHk(void){

	volatile TRmapMemArea *vpxRmapMemArea = (TRmapMemArea *)(SCOM_RMAP_MEM_BASE_ADDR);

	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense1 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense2 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense3 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense4 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense5 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense6 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1Ts = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2Ts = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3Ts = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4Ts = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt1 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt2 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt3 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt4 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt5 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiZeroDiffAmp = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VodMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VogMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VrdMonE = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VodMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VogMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VrdMonE = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VodMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VogMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VrdMonE = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VodMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VogMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VrdMonE = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVccd = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVrclkMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiViclk = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVrclkLow = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usi5vbPosMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usi5vbNegMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usi3v3bMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usi2v5aMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usi3v3dMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usi2v5dMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usi1v5dMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usi5vrefMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVccdPosRaw = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVclkPosRaw = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVan1PosRaw = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVan3NegMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVan2PosRaw = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVdigRaw = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiVdigRaw2 = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiViclkLow = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VrdMonF = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VddMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VgdMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VrdMonF = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VddMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VgdMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VrdMonF = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VddMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VgdMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VrdMonF = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VddMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VgdMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiIgHiMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiIgLoMon = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiTsenseA = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.usiTsenseB = 0xFFFF;
	vpxRmapMemArea->xRmapMemAreaHk.ucSpwStatusSpwStatusReserved = 0;
	vpxRmapMemArea->xRmapMemAreaHk.ucReg32HkReserved = 0;
	vpxRmapMemArea->xRmapMemAreaHk.usiReg33HkReserved = 0;
	vpxRmapMemArea->xRmapMemAreaHk.ucOpMode = 0;
	vpxRmapMemArea->xRmapMemAreaHk.uliErrorFlagsErrorFlagsReserved = 0;
	vpxRmapMemArea->xRmapMemAreaHk.ucFpgaMinorVersion = 0;
	vpxRmapMemArea->xRmapMemAreaHk.ucFpgaMajorVersion = 0;
	vpxRmapMemArea->xRmapMemAreaHk.usiBoardId = 0;
	vpxRmapMemArea->xRmapMemAreaHk.uliReg35HkReserved = 0;

}

void vScomInit(void){

	volatile TScomChannel *vpxScomChannel = (TScomChannel *) (SCOM_BASE_ADDR);

	vpxScomChannel->xSScomChannel.uliDevBaseAddr           = (alt_u32)(SCOM_BASE_ADDR);
	vpxScomChannel->xSSpwcDevAddr.uliSpwcBaseAddr          = (alt_u32)(SCOM_BASE_ADDR);
	vpxScomChannel->xSSpwcLinkConfig.bDisconnect           = FALSE;
	vpxScomChannel->xSSpwcLinkConfig.bLinkStart            = xDefaults.bSpwLinkStart;
	vpxScomChannel->xSSpwcLinkConfig.bAutostart            = TRUE;
	vpxScomChannel->xSSpwcLinkConfig.ucTxDivCnt            = 1;
	vpxScomChannel->xSSpwcTimecodeConfig.bClear            = TRUE;
	vpxScomChannel->xSSpwcTimecodeConfig.bEnable           = TRUE;
	vpxScomChannel->xSRmapDevAddr.uliRmapBaseAddr          = (alt_u32)(SCOM_BASE_ADDR);
	vpxScomChannel->xSRmapCodecConfig.ucLogicalAddress     = xDefaults.ucLogicalAddr;
	vpxScomChannel->xSRmapCodecConfig.ucKey                = xDefaults.ucRmapKey;
	vpxScomChannel->xSRmapMemConfig.uliWinAreaOffHighDword = 0;
	vpxScomChannel->xSRmapMemConfig.uliWinAreaOffLowDword  = 0;
	vpxScomChannel->xSRmapMemAreaPrt.puliRmapAreaPrt       = (TRmapMemArea *)(SCOM_RMAP_MEM_BASE_ADDR);
	
	vScomSoftRstMemAreaConfig();
	vScomSoftRstMemAreaHk();

}

//! [public functions]

//! [private functions]
//! [private functions]
