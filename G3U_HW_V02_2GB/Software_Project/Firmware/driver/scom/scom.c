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

	vpxRmapMemArea->xRmapMemAreaConfig.usiVStart                    = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiVEnd                      = 0x119D    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiChargeInjectionWidth      = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiChargeInjectionGap        = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiParallelToiPeriod         = 0x0465    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiParallelClkOverlap        = 0x00FA    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd      = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd      = 0x01      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd      = 0x02      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd      = 0x03      ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiNFinalDump                = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiHEnd                      = 0x08F6    ;
	vpxRmapMemArea->xRmapMemAreaConfig.bChargeInjectionEn           = FALSE     ;
	vpxRmapMemArea->xRmapMemAreaConfig.bTriLevelClkEn               = FALSE     ;
	vpxRmapMemArea->xRmapMemAreaConfig.bImgClkDir                   = FALSE     ;
	vpxRmapMemArea->xRmapMemAreaConfig.bRegClkDir                   = FALSE     ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiPacketSize                = 0x7D8C    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiIntSyncPeriod             = 0x186A    ;
	vpxRmapMemArea->xRmapMemAreaConfig.uliTrapPumpingDwellCounter   = 0x000030D4;
	vpxRmapMemArea->xRmapMemAreaConfig.bSyncSel                     = FALSE     ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucSensorSel                  = 0x03      ;
	vpxRmapMemArea->xRmapMemAreaConfig.bDigitiseEn                  = TRUE      ;
	vpxRmapMemArea->xRmapMemAreaConfig.bDGEn                        = FALSE     ;
	vpxRmapMemArea->xRmapMemAreaConfig.bCcdReadEn                   = TRUE      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucConvDly                    = 0x0F      ;
	vpxRmapMemArea->xRmapMemAreaConfig.bHighPrecisionHkEn           = FALSE     ;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd1WinListPtr            = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd1PktorderListPtr       = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1WinListLength         = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd1WinSizeX               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd1WinSizeY               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg8ConfigReserved         = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd2WinListPtr            = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd2PktorderListPtr       = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2WinListLength         = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2WinSizeX               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2WinSizeY               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg11ConfigReserved        = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd3WinListPtr            = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd3PktorderListPtr       = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3WinListLength         = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd3WinSizeX               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd3WinSizeY               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg14ConfigReserved        = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd4WinListPtr            = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.uliCcd4PktorderListPtr       = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4WinListLength         = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd4WinSizeX               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd4WinSizeY               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg17ConfigReserved        = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcdVodConfig              = 0x0CCC    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1VrdConfig             = 0x0E65    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2VrdConfig0             = 0x65      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcd2VrdConfig1             = 0x0E      ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3VrdConfig             = 0x0E65    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4VrdConfig             = 0x0E65    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdVgdConfig0              = 0x0E      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdVgdConfig1              = 0xCF      ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcdVogConfig              = 0x019A    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcdIgHiConfig             = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcdIgLoConfig             = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucTrkHldHi                   = 0x04      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucTrkHldLo                   = 0x0E      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg21ConfigReserved0       = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCcdModeConfig              = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg21ConfigReserved1       = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.bClearErrorFlag              = FALSE     ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucRCfg1                      = 0x07      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucRCfg2                      = 0x0B      ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucCdsclpLo                   = 0x09      ;
	vpxRmapMemArea->xRmapMemAreaConfig.uliReg22ConfigReserved       = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1LastEPacket           = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd1LastFPacket           = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2LastEPacket           = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg23ConfigReserved        = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd2LastFPacket           = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3LastEPacket           = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd3LastFPacket           = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg24ConfigReserved        = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4LastEPacket           = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiCcd4LastFPacket           = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiSurfaceInversionCounter   = 0x0064    ;
	vpxRmapMemArea->xRmapMemAreaConfig.ucReg25ConfigReserved        = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiReadoutPauseCounter       = 0x07D0    ;
	vpxRmapMemArea->xRmapMemAreaConfig.usiTrapPumpingShuffleCounter = 0x03E8    ;

}

void vScomSoftRstMemAreaHk(void){

	volatile TRmapMemArea *vpxRmapMemArea = (TRmapMemArea *)(SCOM_RMAP_MEM_BASE_ADDR);

	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense1                    = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense2                    = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense3                    = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense4                    = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense5                    = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiTouSense6                    = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1Ts                       = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2Ts                       = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3Ts                       = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4Ts                       = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt1                         = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt2                         = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt3                         = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt4                         = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiPrt5                         = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiZeroDiffAmp                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VodMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VogMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VrdMonE                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VodMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VogMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VrdMonE                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VodMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VogMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VrdMonE                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VodMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VogMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VrdMonE                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVccd                         = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVrclkMon                     = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiViclk                        = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVrclkLow                     = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usi5vbPosMon                    = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usi5vbNegMon                    = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usi3v3bMon                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usi2v5aMon                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usi3v3dMon                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usi2v5dMon                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usi1v5dMon                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usi5vrefMon                     = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVccdPosRaw                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVclkPosRaw                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVan1PosRaw                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVan3NegMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVan2PosRaw                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVdigRaw                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiVdigRaw2                     = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiViclkLow                     = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VrdMonF                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VddMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd1VgdMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VrdMonF                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VddMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd2VgdMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VrdMonF                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VddMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd3VgdMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VrdMonF                  = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VddMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiCcd4VgdMon                   = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiIgHiMon                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiIgLoMon                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiTsenseA                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.usiTsenseB                      = 0xFFFF    ;
	vpxRmapMemArea->xRmapMemAreaHk.ucSpwStatusSpwStatusReserved    = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaHk.ucReg32HkReserved               = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaHk.usiReg33HkReserved              = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaHk.ucOpMode                        = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaHk.uliErrorFlagsErrorFlagsReserved = 0x00000000;
	vpxRmapMemArea->xRmapMemAreaHk.ucFpgaMinorVersion              = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaHk.ucFpgaMajorVersion              = 0x00      ;
	vpxRmapMemArea->xRmapMemAreaHk.usiBoardId                      = 0x0000    ;
	vpxRmapMemArea->xRmapMemAreaHk.uliReg35HkReserved              = 0x00000000;

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
	vpxScomChannel->xSDataPacketConfig.usiPacketLength     = xDefaults.usiSpwPLength;
	vpxScomChannel->xSDataPacketConfig.ucFeeMode           = 1u; /* N-FEE On Mode */
	vpxScomChannel->xSDataPacketConfig.ucCcdNumber         = 0;
	vpxScomChannel->xSDataPacketConfig.ucProtocolId        = xDefaults.usiDataProtId;
	vpxScomChannel->xSDataPacketConfig.ucLogicalAddr       = xDefaults.ucLogicalAddr;
	vpxScomChannel->xSMachineControl.bStop                 = TRUE;
	vpxScomChannel->xSMachineControl.bClear                = TRUE;
	vpxScomChannel->xSMachineControl.bStart                = TRUE;
	vScomSoftRstMemAreaConfig();
	vScomSoftRstMemAreaHk();

}

//! [public functions]

//! [private functions]
//! [private functions]
