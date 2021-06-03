/*
 * rmap_mem_area.h
 *
 *  Created on: 12 de abr de 2020
 *      Author: rfranca
 */

#ifndef DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_
#define DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_

#include "../../../simucam_definitions.h"

//! [constants definition]
enum RmapConfigRegsAddr {
	eRmapConfigReg0Addr  = 0x00000000, /* RMAP Area Config Register 0 */
	eRmapConfigReg1Addr  = 0x00000004, /* RMAP Area Config Register 1 */
	eRmapConfigReg2Addr  = 0x00000008, /* RMAP Area Config Register 2 */
	eRmapConfigReg3Addr  = 0x0000000C, /* RMAP Area Config Register 3 */
	eRmapConfigReg4Addr  = 0x00000010, /* RMAP Area Config Register 4 */
	eRmapConfigReg5Addr  = 0x00000014, /* RMAP Area Config Register 5 */
	eRmapConfigReg6Addr  = 0x00000018, /* RMAP Area Config Register 6 */
	eRmapConfigReg7Addr  = 0x0000001C, /* RMAP Area Config Register 7 */
	eRmapConfigReg8Addr  = 0x00000020, /* RMAP Area Config Register 8 */
	eRmapConfigReg9Addr  = 0x00000024, /* RMAP Area Config Register 9 */
	eRmapConfigReg10Addr = 0x00000028, /* RMAP Area Config Register 10 */
	eRmapConfigReg11Addr = 0x0000002C, /* RMAP Area Config Register 11 */
	eRmapConfigReg12Addr = 0x00000030, /* RMAP Area Config Register 12 */
	eRmapConfigReg13Addr = 0x00000034, /* RMAP Area Config Register 13 */
	eRmapConfigReg14Addr = 0x00000038, /* RMAP Area Config Register 14 */
	eRmapConfigReg15Addr = 0x0000003C, /* RMAP Area Config Register 15 */
	eRmapConfigReg16Addr = 0x00000040, /* RMAP Area Config Register 16 */
	eRmapConfigReg17Addr = 0x00000044, /* RMAP Area Config Register 17 */
	eRmapConfigReg18Addr = 0x00000048, /* RMAP Area Config Register 18 */
	eRmapConfigReg19Addr = 0x0000004C, /* RMAP Area Config Register 19 */
	eRmapConfigReg20Addr = 0x00000050, /* RMAP Area Config Register 20 */
	eRmapConfigReg21Addr = 0x00000054, /* RMAP Area Config Register 21 */
	eRmapConfigReg22Addr = 0x00000058, /* RMAP Area Config Register 22 */
	eRmapConfigReg23Addr = 0x0000005C, /* RMAP Area Config Register 23 */
	eRmapConfigReg24Addr = 0x00000060, /* RMAP Area Config Register 24 */
	eRmapConfigReg25Addr = 0x00000064, /* RMAP Area Config Register 25 */
	eRmapConfigReg26Addr = 0x00000068  /* RMAP Area Config Register 26 */
} ERmapConfigRegsAddr;
//! [constants definition]

//! [public module structs definition]

/* RMAP Area Config Register Struct */
typedef struct RmapMemAreaConfig {
	alt_u32 usiVStart; /* V Start Config Field */
	alt_u32 usiVEnd; /* V End Config Field */
	alt_u32 usiChargeInjectionWidth; /* Charge Injection Width Config Field */
	alt_u32 usiChargeInjectionGap; /* Charge Injection Gap Config Field */
	alt_u32 usiParallelToiPeriod; /* Parallel Toi Period Config Field */
	alt_u32 usiParallelClkOverlap; /* Parallel Clock Overlap Config Field */
	alt_u32 ucCcdReadoutOrder1stCcd; /* CCD Readout Order Config Field (1st CCD) */
	alt_u32 ucCcdReadoutOrder2ndCcd; /* CCD Readout Order Config Field (2nd CCD) */
	alt_u32 ucCcdReadoutOrder3rdCcd; /* CCD Readout Order Config Field (3rd CCD) */
	alt_u32 ucCcdReadoutOrder4thCcd; /* CCD Readout Order Config Field (4th CCD) */
	alt_u32 usiNFinalDump; /* N Final Dump Config Field */
	alt_u32 usiHEnd; /* H End Config Field */
	bool bChargeInjectionEn; /* Charge Injection Enable Config Field */
	bool bTriLevelClkEn; /* Tri Level Clock Enable Config Field */
	bool bImgClkDir; /* Image Clock Direction Config Field */
	bool bRegClkDir; /* Register Clock Direction Config Field */
	alt_u32 usiPacketSize; /* Data Packet Size Config Field */
	alt_u32 usiIntSyncPeriod; /* Internal Sync Period Config Field */
	alt_u32 uliTrapPumpingDwellCounter; /* Trap Pumping Dwell Counter Field */
	bool bSyncSel; /* Sync Source Selection Config Field */
	alt_u32 ucSensorSel; /* CCD Port Data Sensor Selection Config Field */
	bool bDigitiseEn; /* Digitalise Enable Config Field */
	bool bDGEn; /* DG (Drain Gate) Enable Field */
	bool bCcdReadEn; /* CCD Readout Enable Field */
	alt_u32 ucConvDly; /* Conversion Delay Value */
	bool bHighPrecisionHkEn; /* High Precison Housekeep Enable Field */
	alt_u32 uliCcd1WinListPtr; /* CCD 1 Window List Pointer Config Field */
	alt_u32 uliCcd1PktorderListPtr; /* CCD 1 Packet Order List Pointer Config Field */
	alt_u32 usiCcd1WinListLength; /* CCD 1 Window List Length Config Field */
	alt_u32 ucCcd1WinSizeX; /* CCD 1 Window Size X Config Field */
	alt_u32 ucCcd1WinSizeY; /* CCD 1 Window Size Y Config Field */
	alt_u32 ucReg8ConfigReserved; /* Register 8 Configuration Reserved */
	alt_u32 uliCcd2WinListPtr; /* CCD 2 Window List Pointer Config Field */
	alt_u32 uliCcd2PktorderListPtr; /* CCD 2 Packet Order List Pointer Config Field */
	alt_u32 usiCcd2WinListLength; /* CCD 2 Window List Length Config Field */
	alt_u32 ucCcd2WinSizeX; /* CCD 2 Window Size X Config Field */
	alt_u32 ucCcd2WinSizeY; /* CCD 2 Window Size Y Config Field */
	alt_u32 ucReg11ConfigReserved; /* Register 11 Configuration Reserved */
	alt_u32 uliCcd3WinListPtr; /* CCD 3 Window List Pointer Config Field */
	alt_u32 uliCcd3PktorderListPtr; /* CCD 3 Packet Order List Pointer Config Field */
	alt_u32 usiCcd3WinListLength; /* CCD 3 Window List Length Config Field */
	alt_u32 ucCcd3WinSizeX; /* CCD 3 Window Size X Config Field */
	alt_u32 ucCcd3WinSizeY; /* CCD 3 Window Size Y Config Field */
	alt_u32 ucReg14ConfigReserved; /* Register 14 Configuration Reserved */
	alt_u32 uliCcd4WinListPtr; /* CCD 4 Window List Pointer Config Field */
	alt_u32 uliCcd4PktorderListPtr; /* CCD 4 Packet Order List Pointer Config Field */
	alt_u32 usiCcd4WinListLength; /* CCD 4 Window List Length Config Field */
	alt_u32 ucCcd4WinSizeX; /* CCD 4 Window Size X Config Field */
	alt_u32 ucCcd4WinSizeY; /* CCD 4 Window Size Y Config Field */
	alt_u32 ucReg17ConfigReserved; /* Register 17 Configuration Reserved */
	alt_u32 usiCcdVodConfig; /* CCD Vod Configuration Config Field */
	alt_u32 usiCcd1VrdConfig; /* CCD 1 Vrd Configuration Config Field */
	alt_u32 ucCcd2VrdConfig0; /* CCD 2 Vrd Configuration Config Field */
	alt_u32 ucCcd2VrdConfig1; /* CCD 2 Vrd Configuration Config Field */
	alt_u32 usiCcd3VrdConfig; /* CCD 3 Vrd Configuration Config Field */
	alt_u32 usiCcd4VrdConfig; /* CCD 4 Vrd Configuration Config Field */
	alt_u32 ucCcdVgdConfig0; /* CCD Vgd Configuration Config Field */
	alt_u32 ucCcdVgdConfig1; /* CCD Vgd Configuration Config Field */
	alt_u32 usiCcdVogConfig; /* CCD Vog Configurion Config Field */
	alt_u32 usiCcdIgHiConfig; /* CCD Ig High Configuration Config Field */
	alt_u32 usiCcdIgLoConfig; /* CCD Ig Low Configuration Config Field */
	alt_u32 ucTrkHldHi; /* Trk Hld High Configuration Config Field */
	alt_u32 ucTrkHldLo; /* Trk Hld Low Configuration Config Field */
	alt_u32 ucReg21ConfigReserved0; /* Register 21 Configuration Reserved */
	alt_u32 ucCcdModeConfig; /* CCD Mode Configuration Config Field */
	alt_u32 ucReg21ConfigReserved1; /* Register 21 Configuration Reserved */
	bool bClearErrorFlag; /* Clear Error Flag Config Field */
	alt_u32 ucRCfg1; /* R Config 1 Field */
	alt_u32 ucRCfg2; /* R Config 2 Field */
	alt_u32 ucCdsclpLo; /* Cdsclp Lo Field */
	alt_u32 uliReg22ConfigReserved; /* Register 22 Configuration Reserved */
	alt_u32 usiCcd1LastEPacket; /* CCD 1 Last E Packet Field */
	alt_u32 usiCcd1LastFPacket; /* CCD 1 Last F Packet Field */
	alt_u32 usiCcd2LastEPacket; /* CCD 2 Last E Packet Field */
	alt_u32 ucReg23ConfigReserved; /* Register 23 Configuration Reserved */
	alt_u32 usiCcd2LastFPacket; /* CCD 2 Last F Packet Field */
	alt_u32 usiCcd3LastEPacket; /* CCD 3 Last E Packet Field */
	alt_u32 usiCcd3LastFPacket; /* CCD 3 Last F Packet Field */
	alt_u32 ucReg24ConfigReserved; /* Register 24 Configuration Reserved */
	alt_u32 usiCcd4LastEPacket; /* CCD 4 Last E Packet Field */
	alt_u32 usiCcd4LastFPacket; /* CCD 4 Last F Packet Field */
	alt_u32 usiSurfaceInversionCounter; /* Surface Inversion Counter Field */
	alt_u32 ucReg25ConfigReserved; /* Register 25 Configuration Reserved */
	alt_u32 usiReadoutPauseCounter; /* Readout Pause Counter Field */
	alt_u32 usiTrapPumpingShuffleCounter; /* Trap Pumping Shuffle Counter Field */
} TRmapMemAreaConfig;

/* RMAP Area HK Register Struct */
typedef struct RmapMemAreaHk {
	alt_u32 usiTouSense1; /* TOU Sense 1 HK Field */
	alt_u32 usiTouSense2; /* TOU Sense 2 HK Field */
	alt_u32 usiTouSense3; /* TOU Sense 3 HK Field */
	alt_u32 usiTouSense4; /* TOU Sense 4 HK Field */
	alt_u32 usiTouSense5; /* TOU Sense 5 HK Field */
	alt_u32 usiTouSense6; /* TOU Sense 6 HK Field */
	alt_u32 usiCcd1Ts; /* CCD 1 TS HK Field */
	alt_u32 usiCcd2Ts; /* CCD 2 TS HK Field */
	alt_u32 usiCcd3Ts; /* CCD 3 TS HK Field */
	alt_u32 usiCcd4Ts; /* CCD 4 TS HK Field */
	alt_u32 usiPrt1; /* PRT 1 HK Field */
	alt_u32 usiPrt2; /* PRT 2 HK Field */
	alt_u32 usiPrt3; /* PRT 3 HK Field */
	alt_u32 usiPrt4; /* PRT 4 HK Field */
	alt_u32 usiPrt5; /* PRT 5 HK Field */
	alt_u32 usiZeroDiffAmp; /* Zero Diff Amplifier HK Field */
	alt_u32 usiCcd1VodMon; /* CCD 1 Vod Monitor HK Field */
	alt_u32 usiCcd1VogMon; /* CCD 1 Vog Monitor HK Field */
	alt_u32 usiCcd1VrdMonE; /* CCD 1 Vrd Monitor E HK Field */
	alt_u32 usiCcd2VodMon; /* CCD 2 Vod Monitor HK Field */
	alt_u32 usiCcd2VogMon; /* CCD 2 Vog Monitor HK Field */
	alt_u32 usiCcd2VrdMonE; /* CCD 2 Vrd Monitor E HK Field */
	alt_u32 usiCcd3VodMon; /* CCD 3 Vod Monitor HK Field */
	alt_u32 usiCcd3VogMon; /* CCD 3 Vog Monitor HK Field */
	alt_u32 usiCcd3VrdMonE; /* CCD 3 Vrd Monitor E HK Field */
	alt_u32 usiCcd4VodMon; /* CCD 4 Vod Monitor HK Field */
	alt_u32 usiCcd4VogMon; /* CCD 4 Vog Monitor HK Field */
	alt_u32 usiCcd4VrdMonE; /* CCD 4 Vrd Monitor E HK Field */
	alt_u32 usiVccd; /* V CCD HK Field */
	alt_u32 usiVrclkMon; /* VRClock Monitor HK Field */
	alt_u32 usiViclk; /* VIClock HK Field */
	alt_u32 usiVrclkLow; /* VRClock Low HK Field */
	alt_u32 usi5vbPosMon; /* 5Vb Positive Monitor HK Field */
	alt_u32 usi5vbNegMon; /* 5Vb Negative Monitor HK Field */
	alt_u32 usi3v3bMon; /* 3V3b Monitor HK Field */
	alt_u32 usi2v5aMon; /* 2V5a Monitor HK Field */
	alt_u32 usi3v3dMon; /* 3V3d Monitor HK Field */
	alt_u32 usi2v5dMon; /* 2V5d Monitor HK Field */
	alt_u32 usi1v5dMon; /* 1V5d Monitor HK Field */
	alt_u32 usi5vrefMon; /* 5Vref Monitor HK Field */
	alt_u32 usiVccdPosRaw; /* Vccd Positive Raw HK Field */
	alt_u32 usiVclkPosRaw; /* Vclk Positive Raw HK Field */
	alt_u32 usiVan1PosRaw; /* Van 1 Positive Raw HK Field */
	alt_u32 usiVan3NegMon; /* Van 3 Negative Monitor HK Field */
	alt_u32 usiVan2PosRaw; /* Van Positive Raw HK Field */
	alt_u32 usiVdigRaw; /* Vdig Raw HK Field */
	alt_u32 usiVdigRaw2; /* Vdig Raw 2 HK Field */
	alt_u32 usiViclkLow; /* VIClock Low HK Field */
	alt_u32 usiCcd1VrdMonF; /* CCD 1 Vrd Monitor F HK Field */
	alt_u32 usiCcd1VddMon; /* CCD 1 Vdd Monitor HK Field */
	alt_u32 usiCcd1VgdMon; /* CCD 1 Vgd Monitor HK Field */
	alt_u32 usiCcd2VrdMonF; /* CCD 2 Vrd Monitor F HK Field */
	alt_u32 usiCcd2VddMon; /* CCD 2 Vdd Monitor HK Field */
	alt_u32 usiCcd2VgdMon; /* CCD 2 Vgd Monitor HK Field */
	alt_u32 usiCcd3VrdMonF; /* CCD 3 Vrd Monitor F HK Field */
	alt_u32 usiCcd3VddMon; /* CCD 3 Vdd Monitor HK Field */
	alt_u32 usiCcd3VgdMon; /* CCD 3 Vgd Monitor HK Field */
	alt_u32 usiCcd4VrdMonF; /* CCD 4 Vrd Monitor F HK Field */
	alt_u32 usiCcd4VddMon; /* CCD 4 Vdd Monitor HK Field */
	alt_u32 usiCcd4VgdMon; /* CCD 4 Vgd Monitor HK Field */
	alt_u32 usiIgHiMon; /* Ig High Monitor HK Field */
	alt_u32 usiIgLoMon; /* Ig Low Monitor HK Field */
	alt_u32 usiTsenseA; /* Tsense A HK Field */
	alt_u32 usiTsenseB; /* Tsense B HK Field */
	alt_u32 ucSpwStatusTimecodeFromSpw; /* SpW Status : Timecode From SpaceWire HK Field */
	alt_u32 ucSpwStatusRmapTargetStatus; /* SpW Status : RMAP Target Status HK Field */
	alt_u32 ucSpwStatusSpwStatusReserved; /* SpW Status : SpaceWire Status Reserved */
	bool bSpwStatusRmapTargetIndicate; /* SpW Status : RMAP Target Indicate HK Field */
	bool bSpwStatusStatLinkEscapeError; /* SpW Status : Status Link Escape Error HK Field */
	bool bSpwStatusStatLinkCreditError; /* SpW Status : Status Link Credit Error HK Field */
	bool bSpwStatusStatLinkParityError; /* SpW Status : Status Link Parity Error HK Field */
	bool bSpwStatusStatLinkDisconnect; /* SpW Status : Status Link Disconnect HK Field */
	bool bSpwStatusStatLinkRunning; /* SpW Status : Status Link Running HK Field */
	alt_u32 ucReg32HkReserved; /* Register 32 HK Reserved */
	alt_u32 usiFrameCounter; /* Frame Counter HK Field */
	alt_u32 usiReg33HkReserved; /* Register 33 HK Reserved */
	alt_u32 ucOpMode; /* Operational Mode HK Field */
	alt_u32 ucFrameNumber; /* Frame Number HK Field */
	bool bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongXCoordinate; /* Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field */
	bool bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongYCoordinate; /* Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field */
	bool bErrorFlagsESidePixelExternalSramBufferIsFull; /* Error Flags : E Side Pixel External SRAM Buffer is Full HK Field */
	bool bErrorFlagsFSidePixelExternalSramBufferIsFull; /* Error Flags : F Side Pixel External SRAM Buffer is Full HK Field */
	bool bErrorFlagsTooManyOverlappingWindows; /* Error Flags : Too Many Overlapping Windows */
	bool bErrorFlagsSramEdacCorrectable; /* Error Flags : SRAM EDAC Correctable */
	bool bErrorFlagsSramEdacUncorrectable; /* Error Flags : SRAM EDAC Uncorrectable */
	bool bErrorFlagsBlockRamEdacUncorrectable; /* Error Flags : BLOCK RAM EDAC Uncorrectable */
	alt_u32 uliErrorFlagsErrorFlagsReserved; /* Error Flags : Error Flags Reserved */
	alt_u32 ucFpgaMinorVersion; /* FPGA Minor Version Field */
	alt_u32 ucFpgaMajorVersion; /* FPGA Major Version Field */
	alt_u32 usiBoardId; /* Board ID Field */
	alt_u32 usiReg35HkReserved; /* Register 35 HK Reserved HK Field */
} TRmapMemAreaHk;

/* RMAP Memory Area Register Struct */
typedef struct RmapMemArea {
	TRmapMemAreaConfig xRmapMemAreaConfig; /* RMAP Config Memory Area */
	TRmapMemAreaHk xRmapMemAreaHk; /* RMAP HouseKeeping Memory Area */
} TRmapMemArea;

//! [public module structs definition]

//! [public function prototypes]
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_ */
