/*
 * defaults.c
 *
 *  Created on: 29 de set de 2020
 *      Author: rfranca
 */

#include "defaults.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
volatile bool vbDefaultsReceived = FALSE;
volatile alt_u32 vuliExpectedDefaultsQtd = 1;
volatile alt_u32 vuliReceivedDefaultsQtd = 0;
volatile TDeftMebDefaults vxDeftMebDefaults;
volatile TDeftFeeDefaults vxDeftFeeDefaults[N_OF_NFEE];
volatile TDeftNucDefaults vxDeftNucDefaults;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vClearMebDefault() {

	vxDeftMebDefaults.xDebug.ucReadOutOrder[0] = 0;
	vxDeftMebDefaults.xDebug.ucReadOutOrder[1] = 1;
	vxDeftMebDefaults.xDebug.ucReadOutOrder[2] = 2;
	vxDeftMebDefaults.xDebug.ucReadOutOrder[3] = 3;
	vxDeftMebDefaults.xDebug.usiOverScanSerial = 0;
	vxDeftMebDefaults.xDebug.usiPreScanSerial  = 0;
	vxDeftMebDefaults.xDebug.usiOLN            = 300;
	vxDeftMebDefaults.xDebug.usiCols           = 2295;
	vxDeftMebDefaults.xDebug.usiRows           = 4510;
	vxDeftMebDefaults.xDebug.usiSyncPeriod     = 6250;
	vxDeftMebDefaults.xDebug.usiPreBtSync      = 200;
	vxDeftMebDefaults.xDebug.bBufferOverflowEn = TRUE;
	vxDeftMebDefaults.xDebug.ulStartDelay      = 0;
	vxDeftMebDefaults.xDebug.ulSkipDelay       = 110000;
	vxDeftMebDefaults.xDebug.ulLineDelay       = 90000;
	vxDeftMebDefaults.xDebug.ulADCPixelDelay   = 333;
	vxDeftMebDefaults.xDebug.ucRmapKey         = 209;
	vxDeftMebDefaults.xDebug.ucLogicalAddr     = 81;
	vxDeftMebDefaults.xDebug.bSpwLinkStart     = FALSE;
	vxDeftMebDefaults.xDebug.usiLinkNFEE0      = 0;
	vxDeftMebDefaults.xDebug.usiDebugLevel     = 4;
	vxDeftMebDefaults.xDebug.usiPatternType    = 0;
	vxDeftMebDefaults.xDebug.usiGuardNFEEDelay = 50;
	vxDeftMebDefaults.xDebug.usiDataProtId     = 240;
	vxDeftMebDefaults.xDebug.usiDpuLogicalAddr = 80;
	vxDeftMebDefaults.xDebug.usiSpwPLength     = 32140;
	vxDeftMebDefaults.ucSyncSource             = 0;
	vxDeftMebDefaults.usiExposurePeriod        = 25000;
	vxDeftMebDefaults.bEventReport             = FALSE;
	vxDeftMebDefaults.bLogReport               = FALSE;

}

bool bClearFeeDefault(alt_u8 ucFee) {
	bool bStatus = FALSE;

	if (N_OF_NFEE > ucFee) {

		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiVStart                    = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiVEnd                      = 0x119D    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiChargeInjectionWidth      = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiChargeInjectionGap        = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiParallelToiPeriod         = 0x0465    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiParallelClkOverlap        = 0x00FA    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd      = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd      = 0x01      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd      = 0x02      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd      = 0x03      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiNFinalDump                = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiHEnd                      = 0x08F6    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bChargeInjectionEn           = FALSE     ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bTriLevelClkEn               = FALSE     ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bImgClkDir                   = FALSE     ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bRegClkDir                   = FALSE     ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiPacketSize                = 0x7D8C    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiIntSyncPeriod             = 0x186A    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliTrapPumpingDwellCounter   = 0x000030D4;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bSyncSel                     = FALSE     ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucSensorSel                  = 0x03      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bDigitiseEn                  = TRUE      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bDGEn                        = FALSE     ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bCcdReadEn                   = TRUE      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucConvDly                    = 0x0F      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bHighPrecisionHkEn           = FALSE     ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd1WinListPtr            = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd1PktorderListPtr       = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd1WinListLength         = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd1WinSizeX               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd1WinSizeY               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg8ConfigReserved         = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd2WinListPtr            = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd2PktorderListPtr       = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd2WinListLength         = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd2WinSizeX               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd2WinSizeY               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg11ConfigReserved        = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd3WinListPtr            = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd3PktorderListPtr       = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd3WinListLength         = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd3WinSizeX               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd3WinSizeY               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg14ConfigReserved        = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd4WinListPtr            = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd4PktorderListPtr       = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd4WinListLength         = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd4WinSizeX               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd4WinSizeY               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg17ConfigReserved        = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcdVodConfig              = 0x0CCC    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd1VrdConfig             = 0x0E65    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd2VrdConfig0             = 0x65      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd2VrdConfig1             = 0x0E      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd3VrdConfig             = 0x0E65    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd4VrdConfig             = 0x0E65    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdVgdConfig0              = 0x0C      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdVgdConfig1              = 0xCC      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcdVogConfig              = 0x019A    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcdIgHiConfig             = 0x0CCC    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcdIgLoConfig             = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucTrkHldHi                   = 0x04      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucTrkHldLo                   = 0x0E      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg21ConfigReserved0       = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdModeConfig              = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg21ConfigReserved1       = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bClearErrorFlag              = FALSE     ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliReg22ConfigReserved       = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd1LastEPacket           = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd1LastFPacket           = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd2LastEPacket           = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg23ConfigReserved        = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd2LastFPacket           = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd3LastEPacket           = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd3LastFPacket           = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg24ConfigReserved        = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd4LastEPacket           = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd4LastFPacket           = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiSurfaceInversionCounter   = 0x0064    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg25ConfigReserved        = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiReadoutPauseCounter       = 0x07D0    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiTrapPumpingShuffleCounter = 0x03E8    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense1                     = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense2                     = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense3                     = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense4                     = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense5                     = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense6                     = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1Ts                        = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2Ts                        = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3Ts                        = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4Ts                        = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt1                          = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt2                          = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt3                          = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt4                          = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt5                          = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiZeroDiffAmp                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VodMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VogMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VrdMonE                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VodMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VogMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VrdMonE                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VodMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VogMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VrdMonE                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VodMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VogMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VrdMonE                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVccd                          = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVrclkMon                      = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiViclk                         = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVrclkLow                      = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi5vbPosMon                     = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi5vbNegMon                     = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi3v3bMon                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi2v5aMon                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi3v3dMon                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi2v5dMon                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi1v5dMon                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi5vrefMon                      = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVccdPosRaw                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVclkPosRaw                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVan1PosRaw                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVan3NegMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVan2PosRaw                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVdigRaw                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVdigRaw2                      = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiViclkLow                      = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VrdMonF                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VddMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VgdMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VrdMonF                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VddMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VgdMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VrdMonF                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VddMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VgdMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VrdMonF                   = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VddMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VgdMon                    = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiIgHiMon                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiIgLoMon                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTsenseA                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTsenseB                       = 0xFFFF    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucSpwStatusSpwStatusReserved     = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucReg32HkReserved                = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiReg33HkReserved               = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucOpMode                         = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.uliErrorFlagsErrorFlagsReserved  = 0x00000000;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucFpgaMinorVersion               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucFpgaMajorVersion               = 0x00      ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiBoardId                       = 0x0000    ;
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.uliReg35HkReserved               = 0x00000000;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bDisconnect                               = FALSE     ;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart                                = FALSE     ;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart                                = TRUE      ;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.ucTxDivCnt                                = 1         ;
		vxDeftFeeDefaults[ucFee].bTimecodebTransEn                                        = 1         ;
		vxDeftFeeDefaults[ucFee].ucRmapLogicAddr                                          = 0x51      ;
		vxDeftFeeDefaults[ucFee].ucRmapKey                                                = 0xD1      ;

		bStatus = TRUE;
	}

	return (bStatus);
}

void vClearNucDefault() {

	vxDeftNucDefaults.xEthernet.siPortPUS   = 17000;
	vxDeftNucDefaults.xEthernet.bDHCP       = FALSE;
	vxDeftNucDefaults.xEthernet.ucIP[0]     = 192;
	vxDeftNucDefaults.xEthernet.ucIP[1]     = 168;
	vxDeftNucDefaults.xEthernet.ucIP[2]     = 0;
	vxDeftNucDefaults.xEthernet.ucIP[3]     = 5;
	vxDeftNucDefaults.xEthernet.ucSubNet[0] = 255;
	vxDeftNucDefaults.xEthernet.ucSubNet[1] = 255;
	vxDeftNucDefaults.xEthernet.ucSubNet[2] = 255;
	vxDeftNucDefaults.xEthernet.ucSubNet[3] = 0;
	vxDeftNucDefaults.xEthernet.ucGTW[0]    = 192;
	vxDeftNucDefaults.xEthernet.ucGTW[1]    = 168;
	vxDeftNucDefaults.xEthernet.ucGTW[2]    = 0;
	vxDeftNucDefaults.xEthernet.ucGTW[3]    = 1;
	vxDeftNucDefaults.xEthernet.ucDNS[0]    = 8;
	vxDeftNucDefaults.xEthernet.ucDNS[1]    = 8;
	vxDeftNucDefaults.xEthernet.ucDNS[2]    = 8;
	vxDeftNucDefaults.xEthernet.ucDNS[3]    = 8;
	vxDeftNucDefaults.xEthernet.ucPID       = 112;

}

bool bSetMebDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {
	/* ucReadOutOrder[0] */
	case 0:
		vxDeftMebDefaults.xDebug.ucReadOutOrder[0] = (alt_u8) uliDefaultValue;
		break;
	/* ucReadOutOrder[1] */
	case 1:
		vxDeftMebDefaults.xDebug.ucReadOutOrder[1] = (alt_u8) uliDefaultValue;
		break;
	/* ucReadOutOrder[2] */
	case 2:
		vxDeftMebDefaults.xDebug.ucReadOutOrder[2] = (alt_u8) uliDefaultValue;
		break;
	/* ucReadOutOrder[3] */
	case 3:
		vxDeftMebDefaults.xDebug.ucReadOutOrder[3] = (alt_u8) uliDefaultValue;
		break;
	/* usiOverScanSerial */
	case 4:
		vxDeftMebDefaults.xDebug.usiOverScanSerial = (alt_u16) uliDefaultValue;
		break;
	/* usiPreScanSerial */
	case 5:
		vxDeftMebDefaults.xDebug.usiPreScanSerial = (alt_u16) uliDefaultValue;
		break;
	/* usiOLN */
	case 6:
		vxDeftMebDefaults.xDebug.usiOLN = (alt_u16) uliDefaultValue;
		break;
	/* usiCols */
	case 7:
		vxDeftMebDefaults.xDebug.usiCols = (alt_u16) uliDefaultValue;
		break;
	/* usiRows */
	case 8:
		vxDeftMebDefaults.xDebug.usiRows = (alt_u16) uliDefaultValue;
		break;
	/* usiSyncPeriod */
	case 9:
		vxDeftMebDefaults.xDebug.usiSyncPeriod = (alt_u16) uliDefaultValue;
		break;
	/* usiPreBtSync */
	case 10:
		vxDeftMebDefaults.xDebug.usiPreBtSync = (alt_u16) uliDefaultValue;
		break;
	/* bBufferOverflowEn */
	case 11:
		vxDeftMebDefaults.xDebug.bBufferOverflowEn = (bool) uliDefaultValue;
		break;
	/* ulStartDelay */
	case 12:
		vxDeftMebDefaults.xDebug.ulStartDelay = (alt_u32) uliDefaultValue;
		break;
	/* ulSkipDelay */
	case 13:
		vxDeftMebDefaults.xDebug.ulSkipDelay = (alt_u32) uliDefaultValue;
		break;
	/* ulLineDelay */
	case 14:
		vxDeftMebDefaults.xDebug.ulLineDelay = (alt_u32) uliDefaultValue;
		break;
	/* ulADCPixelDelay */
	case 15:
		vxDeftMebDefaults.xDebug.ulADCPixelDelay = (alt_u32) uliDefaultValue;
		break;
	/* ucRmapKey */
	case 16:
		vxDeftMebDefaults.xDebug.ucRmapKey = (alt_u16) uliDefaultValue;
		break;
	/* ucLogicalAddr */
	case 17:
		vxDeftMebDefaults.xDebug.ucLogicalAddr = (alt_u16) uliDefaultValue;
		break;
	/* bSpwLinkStart */
	case 18:
		vxDeftMebDefaults.xDebug.bSpwLinkStart = (bool) uliDefaultValue;
		break;
	/* usiLinkNFEE0 */
	case 19:
		vxDeftMebDefaults.xDebug.usiLinkNFEE0 = (alt_u16) uliDefaultValue;
		break;
	/* usiDebugLevel */
	case 20:
		vxDeftMebDefaults.xDebug.usiDebugLevel = (alt_u16) uliDefaultValue;
		break;
	/* usiPatternType */
	case 21:
		vxDeftMebDefaults.xDebug.usiPatternType = (alt_u16) uliDefaultValue;
		break;
	/* usiGuardNFEEDelay */
	case 22:
		vxDeftMebDefaults.xDebug.usiGuardNFEEDelay = (alt_u16) uliDefaultValue;
		break;
	/* usiDataProtId */
	case 23:
		vxDeftMebDefaults.xDebug.usiDataProtId = (alt_u16) uliDefaultValue;
		break;
	/* usiDpuLogicalAddr */
	case 24:
		vxDeftMebDefaults.xDebug.usiDpuLogicalAddr = (alt_u16) uliDefaultValue;
		break;
	/* usiSpwPLength */
	case 25:
		vxDeftMebDefaults.xDebug.usiSpwPLength = (alt_u16) uliDefaultValue;
		break;
	/* Sync_Source */
	case 26:
		vxDeftMebDefaults.ucSyncSource = (alt_u8) uliDefaultValue;
		break;
	/* EP */
	case 27:
		vxDeftMebDefaults.usiExposurePeriod = (alt_u32) uliDefaultValue;
		break;
	/* EventReport */
	case 28:
		vxDeftMebDefaults.bEventReport = (alt_u8) uliDefaultValue;
		break;
	/* LogReport */
	case 29:
		vxDeftMebDefaults.bLogReport = (alt_u8) uliDefaultValue;
		break;
	/* Reserved Value - Number of defaults to be received */
	case DEFT_NUC_DEFS_ID_RESERVED:
		vuliExpectedDefaultsQtd = uliDefaultValue + 1;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return (bStatus);
}

bool bSetFeeDefaultValues(alt_u8 ucFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {
	/* usiVStart */
	case 1000:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiVStart = (alt_u16) uliDefaultValue;
		break;
	/* usiVEnd */
	case 1001:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiVEnd = (alt_u16) uliDefaultValue;
		break;
	/* usiChargeInjectionWidth */
	case 1002:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiChargeInjectionWidth = (alt_u16) uliDefaultValue;
		break;
	/* usiChargeInjectionGap */
	case 1003:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiChargeInjectionGap = (alt_u16) uliDefaultValue;
		break;
	/* usiParallelToiPeriod */
	case 1004:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiParallelToiPeriod = (alt_u16) uliDefaultValue;
		break;
	/* usiParallelClkOverlap */
	case 1005:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiParallelClkOverlap = (alt_u16) uliDefaultValue;
		break;
	/* ucCcdReadoutOrder1stCcd */
	case 1006:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd = (alt_u8) uliDefaultValue;
		break;
	/* ucCcdReadoutOrder2ndCcd */
	case 1007:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd = (alt_u8) uliDefaultValue;
		break;
	/* ucCcdReadoutOrder3rdCcd */
	case 1008:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd = (alt_u8) uliDefaultValue;
		break;
	/* ucCcdReadoutOrder4thCcd */
	case 1009:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd = (alt_u8) uliDefaultValue;
		break;
	/* usiNFinalDump */
	case 1010:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiNFinalDump = (alt_u16) uliDefaultValue;
		break;
	/* usiHEnd */
	case 1011:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiHEnd = (alt_u16) uliDefaultValue;
		break;
	/* bChargeInjectionEn */
	case 1012:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bChargeInjectionEn = (alt_u8) uliDefaultValue;
		break;
	/* bTriLevelClkEn */
	case 1013:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bTriLevelClkEn = (alt_u8) uliDefaultValue;
		break;
	/* bImgClkDir */
	case 1014:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bImgClkDir = (alt_u8) uliDefaultValue;
		break;
	/* bRegClkDir */
	case 1015:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bRegClkDir = (alt_u8) uliDefaultValue;
		break;
	/* usiPacketSize */
	case 1016:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiPacketSize = (alt_u16) uliDefaultValue;
		break;
	/* usiIntSyncPeriod */
	case 1017:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiIntSyncPeriod = (alt_u16) uliDefaultValue;
		break;
	/* uliTrapPumpingDwellCounter */
	case 1018:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliTrapPumpingDwellCounter = (alt_u32) uliDefaultValue;
		break;
	/* bSyncSel */
	case 1019:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bSyncSel = (alt_u8) uliDefaultValue;
		break;
	/* ucSensorSel */
	case 1020:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucSensorSel = (alt_u8) uliDefaultValue;
		break;
	/* bDigitiseEn */
	case 1021:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bDigitiseEn = (alt_u8) uliDefaultValue;
		break;
	/* bDGEn */
	case 1022:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bDGEn = (alt_u8) uliDefaultValue;
		break;
	/* bCcdReadEn */
	case 1023:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bCcdReadEn = (alt_u8) uliDefaultValue;
		break;
//	/* ucReg5ConfigReserved */
//	case 1024:
//		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg5ConfigReserved = (alt_u8) uliDefaultValue;
//		break;
	/* uliCcd1WinListPtr */
	case 1025:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd1WinListPtr = (alt_u32) uliDefaultValue;
		break;
	/* uliCcd1PktorderListPtr */
	case 1026:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd1PktorderListPtr = (alt_u32) uliDefaultValue;
		break;
	/* usiCcd1WinListLength */
	case 1027:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd1WinListLength = (alt_u16) uliDefaultValue;
		break;
	/* ucCcd1WinSizeX */
	case 1028:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd1WinSizeX = (alt_u8) uliDefaultValue;
		break;
	/* ucCcd1WinSizeY */
	case 1029:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd1WinSizeY = (alt_u8) uliDefaultValue;
		break;
	/* ucReg8ConfigReserved */
	case 1030:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg8ConfigReserved = (alt_u8) uliDefaultValue;
		break;
	/* uliCcd2WinListPtr */
	case 1031:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd2WinListPtr = (alt_u32) uliDefaultValue;
		break;
	/* uliCcd2PktorderListPtr */
	case 1032:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd2PktorderListPtr = (alt_u32) uliDefaultValue;
		break;
	/* usiCcd2WinListLength */
	case 1033:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd2WinListLength = (alt_u16) uliDefaultValue;
		break;
	/* ucCcd2WinSizeX */
	case 1034:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd2WinSizeX = (alt_u8) uliDefaultValue;
		break;
	/* ucCcd2WinSizeY */
	case 1035:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd2WinSizeY = (alt_u8) uliDefaultValue;
		break;
	/* ucReg11ConfigReserved */
	case 1036:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg11ConfigReserved = (alt_u8) uliDefaultValue;
		break;
	/* uliCcd3WinListPtr */
	case 1037:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd3WinListPtr = (alt_u32) uliDefaultValue;
		break;
	/* uliCcd3PktorderListPtr */
	case 1038:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd3PktorderListPtr = (alt_u32) uliDefaultValue;
		break;
	/* usiCcd3WinListLength */
	case 1039:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd3WinListLength = (alt_u16) uliDefaultValue;
		break;
	/* ucCcd3WinSizeX */
	case 1040:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd3WinSizeX = (alt_u8) uliDefaultValue;
		break;
	/* ucCcd3WinSizeY */
	case 1041:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd3WinSizeY = (alt_u8) uliDefaultValue;
		break;
	/* ucReg14ConfigReserved */
	case 1042:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg14ConfigReserved = (alt_u8) uliDefaultValue;
		break;
	/* uliCcd4WinListPtr */
	case 1043:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd4WinListPtr = (alt_u32) uliDefaultValue;
		break;
	/* uliCcd4PktorderListPtr */
	case 1044:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliCcd4PktorderListPtr = (alt_u32) uliDefaultValue;
		break;
	/* usiCcd4WinListLength */
	case 1045:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd4WinListLength = (alt_u16) uliDefaultValue;
		break;
	/* ucCcd4WinSizeX */
	case 1046:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd4WinSizeX = (alt_u8) uliDefaultValue;
		break;
	/* ucCcd4WinSizeY */
	case 1047:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd4WinSizeY = (alt_u8) uliDefaultValue;
		break;
	/* ucReg17ConfigReserved */
	case 1048:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg17ConfigReserved = (alt_u8) uliDefaultValue;
		break;
	/* usiCcdVodConfig */
	case 1049:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcdVodConfig = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1VrdConfig */
	case 1050:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd1VrdConfig = (alt_u16) uliDefaultValue;
		break;
	/* ucCcd2VrdConfig0 */
	case 1051:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd2VrdConfig0 = (alt_u8) uliDefaultValue;
		break;
	/* ucCcd2VrdConfig1 */
	case 1052:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcd2VrdConfig1 = (alt_u8) uliDefaultValue;
		break;
	/* usiCcd3VrdConfig */
	case 1053:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd3VrdConfig = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4VrdConfig */
	case 1054:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd4VrdConfig = (alt_u16) uliDefaultValue;
		break;
	/* ucCcdVgdConfig0 */
	case 1055:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdVgdConfig0 = (alt_u8) uliDefaultValue;
		break;
	/* ucCcdVgdConfig1 */
	case 1056:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdVgdConfig1 = (alt_u8) uliDefaultValue;
		break;
	/* usiCcdVogConfig */
	case 1057:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcdVogConfig = (alt_u16) uliDefaultValue;
		break;
	/* usiCcdIgHiConfig */
	case 1058:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcdIgHiConfig = (alt_u16) uliDefaultValue;
		break;
	/* usiCcdIgLoConfig */
	case 1059:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcdIgLoConfig = (alt_u16) uliDefaultValue;
		break;
	/* usiReg21ConfigReserved0 */
//	case 1060:
//		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiReg21ConfigReserved0 = (alt_u16) uliDefaultValue;
//		break;
//	/* ucCcdModeConfig */
	case 1061:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucCcdModeConfig = (alt_u8) uliDefaultValue;
		break;
	/* ucReg21ConfigReserved1 */
	case 1062:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg21ConfigReserved1 = (alt_u8) uliDefaultValue;
		break;
	/* bClearErrorFlag */
	case 1063:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.bClearErrorFlag = (alt_u8) uliDefaultValue;
		break;
	/* uliReg22ConfigReserved */
	case 1064:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.uliReg22ConfigReserved = (alt_u32) uliDefaultValue;
		break;
	/* usiCcd1LastEPacket */
	case 1065:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd1LastEPacket = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1LastFPacket */
	case 1066:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd1LastFPacket = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd2LastEPacket */
	case 1067:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd2LastEPacket = (alt_u16) uliDefaultValue;
		break;
	/* ucReg23ConfigReserved */
	case 1068:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg23ConfigReserved = (alt_u8) uliDefaultValue;
		break;
	/* usiCcd2LastFPacket */
	case 1069:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd2LastFPacket = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3LastEPacket */
	case 1070:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd3LastEPacket = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3LastFPacket */
	case 1071:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd3LastFPacket = (alt_u16) uliDefaultValue;
		break;
	/* ucReg24ConfigReserved */
	case 1072:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg24ConfigReserved = (alt_u8) uliDefaultValue;
		break;
	/* usiCcd4LastEPacket */
	case 1073:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd4LastEPacket = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4LastFPacket */
	case 1074:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiCcd4LastFPacket = (alt_u16) uliDefaultValue;
		break;
	/* usiSurfaceInversionCounter */
	case 1075:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiSurfaceInversionCounter = (alt_u16) uliDefaultValue;
		break;
	/* ucReg25ConfigReserved */
	case 1076:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.ucReg25ConfigReserved = (alt_u8) uliDefaultValue;
		break;
	/* usiReadoutPauseCounter */
	case 1077:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiReadoutPauseCounter = (alt_u16) uliDefaultValue;
		break;
	/* usiTrapPumpingShuffleCounter */
	case 1078:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaConfig.usiTrapPumpingShuffleCounter = (alt_u16) uliDefaultValue;
		break;
	/* usiTouSense1 */
	case 2000:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense1 = (alt_u16) uliDefaultValue;
		break;
	/* usiTouSense2 */
	case 2001:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense2 = (alt_u16) uliDefaultValue;
		break;
	/* usiTouSense3 */
	case 2002:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense3 = (alt_u16) uliDefaultValue;
		break;
	/* usiTouSense4 */
	case 2003:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense4 = (alt_u16) uliDefaultValue;
		break;
	/* usiTouSense5 */
	case 2004:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense5 = (alt_u16) uliDefaultValue;
		break;
	/* usiTouSense6 */
	case 2005:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTouSense6 = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1Ts */
	case 2006:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1Ts = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd2Ts */
	case 2007:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2Ts = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3Ts */
	case 2008:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3Ts = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4Ts */
	case 2009:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4Ts = (alt_u16) uliDefaultValue;
		break;
	/* usiPrt1 */
	case 2010:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt1 = (alt_u16) uliDefaultValue;
		break;
	/* usiPrt2 */
	case 2011:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt2 = (alt_u16) uliDefaultValue;
		break;
	/* usiPrt3 */
	case 2012:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt3 = (alt_u16) uliDefaultValue;
		break;
	/* usiPrt4 */
	case 2013:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt4 = (alt_u16) uliDefaultValue;
		break;
	/* usiPrt5 */
	case 2014:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiPrt5 = (alt_u16) uliDefaultValue;
		break;
	/* usiZeroDiffAmp */
	case 2015:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiZeroDiffAmp = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1VodMon */
	case 2016:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VodMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1VogMon */
	case 2017:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VogMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1VrdMonE */
	case 2018:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VrdMonE = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd2VodMon */
	case 2019:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VodMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd2VogMon */
	case 2020:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VogMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd2VrdMonE */
	case 2021:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VrdMonE = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3VodMon */
	case 2022:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VodMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3VogMon */
	case 2023:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VogMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3VrdMonE */
	case 2024:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VrdMonE = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4VodMon */
	case 2025:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VodMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4VogMon */
	case 2026:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VogMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4VrdMonE */
	case 2027:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VrdMonE = (alt_u16) uliDefaultValue;
		break;
	/* usiVccd */
	case 2028:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVccd = (alt_u16) uliDefaultValue;
		break;
	/* usiVrclkMon */
	case 2029:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVrclkMon = (alt_u16) uliDefaultValue;
		break;
	/* usiViclk */
	case 2030:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiViclk = (alt_u16) uliDefaultValue;
		break;
	/* usiVrclkLow */
	case 2031:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVrclkLow = (alt_u16) uliDefaultValue;
		break;
	/* usi5vbPosMon */
	case 2032:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi5vbPosMon = (alt_u16) uliDefaultValue;
		break;
	/* usi5vbNegMon */
	case 2033:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi5vbNegMon = (alt_u16) uliDefaultValue;
		break;
	/* usi3v3bMon */
	case 2034:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi3v3bMon = (alt_u16) uliDefaultValue;
		break;
	/* usi2v5aMon */
	case 2035:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi2v5aMon = (alt_u16) uliDefaultValue;
		break;
	/* usi3v3dMon */
	case 2036:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi3v3dMon = (alt_u16) uliDefaultValue;
		break;
	/* usi2v5dMon */
	case 2037:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi2v5dMon = (alt_u16) uliDefaultValue;
		break;
	/* usi1v5dMon */
	case 2038:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi1v5dMon = (alt_u16) uliDefaultValue;
		break;
	/* usi5vrefMon */
	case 2039:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usi5vrefMon = (alt_u16) uliDefaultValue;
		break;
	/* usiVccdPosRaw */
	case 2040:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVccdPosRaw = (alt_u16) uliDefaultValue;
		break;
	/* usiVclkPosRaw */
	case 2041:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVclkPosRaw = (alt_u16) uliDefaultValue;
		break;
	/* usiVan1PosRaw */
	case 2042:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVan1PosRaw = (alt_u16) uliDefaultValue;
		break;
	/* usiVan3NegMon */
	case 2043:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVan3NegMon = (alt_u16) uliDefaultValue;
		break;
	/* usiVan2PosRaw */
	case 2044:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVan2PosRaw = (alt_u16) uliDefaultValue;
		break;
	/* usiVdigRaw */
	case 2045:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVdigRaw = (alt_u16) uliDefaultValue;
		break;
	/* usiVdigRaw2 */
	case 2046:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiVdigRaw2 = (alt_u16) uliDefaultValue;
		break;
	/* usiViclkLow */
	case 2047:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiViclkLow = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1VrdMonF */
	case 2048:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VrdMonF = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1VddMon */
	case 2049:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VddMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd1VgdMon */
	case 2050:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd1VgdMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd2VrdMonF */
	case 2051:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VrdMonF = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd2VddMon */
	case 2052:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VddMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd2VgdMon */
	case 2053:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd2VgdMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3VrdMonF */
	case 2054:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VrdMonF = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3VddMon */
	case 2055:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VddMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd3VgdMon */
	case 2056:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd3VgdMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4VrdMonF */
	case 2057:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VrdMonF = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4VddMon */
	case 2058:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VddMon = (alt_u16) uliDefaultValue;
		break;
	/* usiCcd4VgdMon */
	case 2059:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiCcd4VgdMon = (alt_u16) uliDefaultValue;
		break;
	/* usiIgHiMon */
	case 2060:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiIgHiMon = (alt_u16) uliDefaultValue;
		break;
	/* usiIgLoMon */
	case 2061:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiIgLoMon = (alt_u16) uliDefaultValue;
		break;
	/* usiTsenseA */
	case 2062:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTsenseA = (alt_u16) uliDefaultValue;
		break;
	/* usiTsenseB */
	case 2063:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiTsenseB = (alt_u16) uliDefaultValue;
		break;
	/* ucSpwStatusSpwStatusReserved */
	case 2064:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucSpwStatusSpwStatusReserved = (alt_u8) uliDefaultValue;
		break;
	/* ucReg32HkReserved */
	case 2065:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucReg32HkReserved = (alt_u8) uliDefaultValue;
		break;
	/* usiReg33HkReserved */
	case 2066:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiReg33HkReserved = (alt_u16) uliDefaultValue;
		break;
	/* ucOpMode */
	case 2067:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucOpMode = (alt_u8) uliDefaultValue;
		break;
	/* uliErrorFlagsErrorFlagsReserved */
	case 2068:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.uliErrorFlagsErrorFlagsReserved = (alt_u32) uliDefaultValue;
		break;
	/* ucFpgaMinorVersion */
	case 2069:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucFpgaMinorVersion = (alt_u8) uliDefaultValue;
		break;
	/* ucFpgaMajorVersion */
	case 2070:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.ucFpgaMajorVersion = (alt_u8) uliDefaultValue;
		break;
	/* usiBoardId */
	case 2071:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.usiBoardId = (alt_u16) uliDefaultValue;
		break;
	/* uliReg35HkReserved */
	case 2072:
		vxDeftFeeDefaults[ucFee].xRmapMem.xRmapMemAreaHk.uliReg35HkReserved = (alt_u16) uliDefaultValue;
		break;
	/* SPW_LinkStart */
	case 3000:
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart = (bool) uliDefaultValue;
		break;
	/* SPW_Autostart */
	case 3001:
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart = (bool) uliDefaultValue;
		break;
	/* SPW_LinkSpeed */
	case 3002:
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv((alt_u8) uliDefaultValue);
		break;
	/* TimeCode Enable */
	case 3003:
		vxDeftFeeDefaults[ucFee].bTimecodebTransEn = (bool) uliDefaultValue;
		break;
	/* ucLogicalAddr */
	case 3004:
		vxDeftFeeDefaults[ucFee].ucRmapLogicAddr = (alt_u8) uliDefaultValue;
		break;
	/* ucKey	 */
	case 3005:
		vxDeftFeeDefaults[ucFee].ucRmapKey = (alt_u8) uliDefaultValue;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return (bStatus);
}

bool bSetNucDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {
	/* TcpServerPort */
	case 10000:
		vxDeftNucDefaults.xEthernet.siPortPUS = (alt_u16) uliDefaultValue;
		break;
	/* DHCPv4Enable */
	case 10001:
		vxDeftNucDefaults.xEthernet.bDHCP = (bool) uliDefaultValue;
		break;
	/* IPv4Address */
	case 10002:
		vxDeftNucDefaults.xEthernet.ucIP[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4Subnet */
	case 10003:
		vxDeftNucDefaults.xEthernet.ucSubNet[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4Gateway */
	case 10004:
		vxDeftNucDefaults.xEthernet.ucGTW[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4DNS */
	case 10005:
		vxDeftNucDefaults.xEthernet.ucDNS[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PusHpPid */
	case 10006:
		vxDeftNucDefaults.xEthernet.ucPID = (alt_u8) uliDefaultValue;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return (bStatus);
}

bool bSetDefaultValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = FALSE;

	if (0 == usiMebFee) { /* MEB or NUC Default */

		if (((DEFT_MEB_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_FEE_DEFS_ID_LOWER_LIM > usiDefaultId)) || (DEFT_NUC_DEFS_ID_RESERVED == usiDefaultId)) {

			/* Default ID is a MEB Default */
			bStatus = bSetMebDefaultValues(usiDefaultId, uliDefaultValue);

		} else if (DEFT_NUC_DEFS_ID_LOWER_LIM <= usiDefaultId) {

			/* Default ID is a NUC Default */
			bStatus = bSetNucDefaultValues(usiDefaultId, uliDefaultValue);

		}

	} else if ((N_OF_NFEE + 1) >= usiMebFee) { /* FEE Default */

		if ((DEFT_FEE_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_NUC_DEFS_ID_LOWER_LIM > usiDefaultId)) {

			/* Default ID is a FEE Default */
			bStatus = bSetFeeDefaultValues(usiMebFee - 1, usiDefaultId, uliDefaultValue);

		}

	}

	if (TRUE == bStatus) {
		vuliReceivedDefaultsQtd++;
	}

	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
