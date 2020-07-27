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

/* Registers Addresses */
/* DEB Critical Configuration Area Registers Addresses */
#define RMAP_DCC_DTC_AEB_ONOFF_ADR      0x0000
#define RMAP_DCC_DTC_PLL_REG_1_ADR      0x0004
#define RMAP_DCC_DTC_PLL_REG_2_ADR      0x0008
#define RMAP_DCC_DTC_PLL_REG_3_ADR      0x000C
#define RMAP_DCC_DTC_PLL_REG_4_ADR      0x0010
#define RMAP_DCC_DTC_FEE_MOD_ADR        0x0014
#define RMAP_DCC_DTC_IMM_ONMOD_ADR      0x0018

/* DEB General Configuration Area Registers Addresses */
#define RMAP_DGC_DTC_IN_MOD_1_ADR       0x0104
#define RMAP_DGC_DTC_IN_MOD_2_ADR       0x0108
#define RMAP_DGC_DTC_WDW_SIZ_ADR        0x010C
#define RMAP_DGC_DTC_WDW_IDX_1_ADR      0x0110
#define RMAP_DGC_DTC_WDW_IDX_2_ADR      0x0114
#define RMAP_DGC_DTC_WDW_IDX_3_ADR      0x0118
#define RMAP_DGC_DTC_WDW_IDX_4_ADR      0x011C
#define RMAP_DGC_DTC_OVS_PAT_ADR        0x0120
#define RMAP_DGC_DTC_SIZ_PAT_ADR        0x0124
#define RMAP_DGC_DTC_TRG_25S_ADR        0x0128
#define RMAP_DGC_DTC_SEL_TRG_ADR        0x012C
#define RMAP_DGC_DTC_FRM_CNT_ADR        0x0130
#define RMAP_DGC_DTC_SEL_SYN_ADR        0x0134
#define RMAP_DGC_DTC_RSP_CPS_ADR        0x0138
#define RMAP_DGC_DTC_25S_DLY_ADR        0x013C
#define RMAP_DGC_DTC_TMOD_CONF_ADR      0x0140
#define RMAP_DGC_DTC_SPW_CFG_ADR        0x0144

/* DEB Housekeeping Area Registers Addresses */
#define RMAP_DHK_DEB_STATUS_ADR         0x1000
#define RMAP_DHK_DEB_OVF_ADR            0x1004
#define RMAP_DHK_SPW_STATUS_ADR         0x1008
#define RMAP_DHK_DEB_AHK1_ADR           0x100C
#define RMAP_DHK_DEB_AHK2_ADR           0x1010
#define RMAP_DHK_DEB_AHK3_ADR           0x1014

/* AEB Critical Configuration Area Registers Addresses */
#define RMAP_ACC_AEB_CONTROL_ADR        0x0000
#define RMAP_ACC_AEB_CONFIG_ADR         0x0004
#define RMAP_ACC_AEB_CONFIG_KEY_ADR     0x0008
#define RMAP_ACC_AEB_CONFIG_AIT1_ADR    0x000C
#define RMAP_ACC_AEB_CONFIG_PATTERN_ADR 0x0010
#define RMAP_ACC_VASP_I2C_CONTROL_ADR   0x0014
#define RMAP_ACC_DAC_CONFIG_1_ADR       0x0018
#define RMAP_ACC_DAC_CONFIG_2_ADR       0x001C
#define RMAP_ACC_PWR_CONFIG1_ADR        0x0024
#define RMAP_ACC_PWR_CONFIG2_ADR        0x0028
#define RMAP_ACC_PWR_CONFIG3_ADR        0x002C

/* AEB General Configuration Area Registers Addresses */
#define RMAP_AGC_ADC1_CONFIG_1_ADR      0x0100
#define RMAP_AGC_ADC1_CONFIG_2_ADR      0x0104
#define RMAP_AGC_ADC1_CONFIG_3_ADR      0x0108
#define RMAP_AGC_ADC2_CONFIG_1_ADR      0x010C
#define RMAP_AGC_ADC2_CONFIG_2_ADR      0x0110
#define RMAP_AGC_ADC2_CONFIG_3_ADR      0x0114
#define RMAP_AGC_SEQ_CONFIG_1_ADR       0x0120
#define RMAP_AGC_SEQ_CONFIG_2_ADR       0x0124
#define RMAP_AGC_SEQ_CONFIG_3_ADR       0x0128
#define RMAP_AGC_SEQ_CONFIG_4_ADR       0x012C
#define RMAP_AGC_SEQ_CONFIG_5_ADR       0x0130
#define RMAP_AGC_SEQ_CONFIG_6_ADR       0x0134
#define RMAP_AGC_SEQ_CONFIG_7_ADR       0x0138
#define RMAP_AGC_SEQ_CONFIG_8_ADR       0x013C
#define RMAP_AGC_SEQ_CONFIG_9_ADR       0x0140
#define RMAP_AGC_SEQ_CONFIG_10_ADR      0x0144
#define RMAP_AGC_SEQ_CONFIG_11_ADR      0x0148
#define RMAP_AGC_SEQ_CONFIG_12_ADR      0x014C
#define RMAP_AGC_SEQ_CONFIG_13_ADR      0x0150
#define RMAP_AGC_SEQ_CONFIG_14_ADR      0x0154

/* AEB Housekeeping Area Registers Addresses */
#define RMAP_AHK_AEB_STATUS_ADR         0x1000
#define RMAP_AHK_TIMESTAMP_1_ADR        0x1008
#define RMAP_AHK_TIMESTAMP_2_ADR        0x100C
#define RMAP_AHK_ADC_RD_DATA_ADR        0x1010
#define RMAP_AHK_ADC1_RD_CONFIG_1_ADR   0x1080
#define RMAP_AHK_ADC1_RD_CONFIG_2_ADR   0x1084
#define RMAP_AHK_ADC1_RD_CONFIG_3_ADR   0x1088
#define RMAP_AHK_ADC1_RD_CONFIG_4_ADR   0x108C
#define RMAP_AHK_ADC2_RD_CONFIG_1_ADR   0x1090
#define RMAP_AHK_ADC2_RD_CONFIG_2_ADR   0x1094
#define RMAP_AHK_ADC2_RD_CONFIG_3_ADR   0x1098
#define RMAP_AHK_ADC2_RD_CONFIG_4_ADR   0x109C
#define RMAP_AHK_VASP_RD_CONFIG_ADR     0x10A0
#define RMAP_AHK_REVISION_ID_1_ADR      0x11F0
#define RMAP_AHK_REVISION_ID_2 _ADR     0x11F4
#define RMAP_AHK_REVISION_ID_3_ADR      0x11F8
#define RMAP_AHK_REVISION_ID_4_ADR      0x11FC
//! [constants definition]

//! [public module structs definition]

/* RMAP Area Config Register Struct */
typedef struct RmapMemAreaConfig {
	alt_u16 usiVStart; /* V Start Config Field */
	alt_u16 usiVEnd; /* V End Config Field */
	alt_u16 usiChargeInjectionWidth; /* Charge Injection Width Config Field */
	alt_u16 usiChargeInjectionGap; /* Charge Injection Gap Config Field */
	alt_u16 usiParallelToiPeriod; /* Parallel Toi Period Config Field */
	alt_u16 usiParallelClkOverlap; /* Parallel Clock Overlap Config Field */
	alt_u8 ucCcdReadoutOrder1stCcd; /* CCD Readout Order Config Field (1st CCD) */
	alt_u8 ucCcdReadoutOrder2ndCcd; /* CCD Readout Order Config Field (2nd CCD) */
	alt_u8 ucCcdReadoutOrder3rdCcd; /* CCD Readout Order Config Field (3rd CCD) */
	alt_u8 ucCcdReadoutOrder4thCcd; /* CCD Readout Order Config Field (4th CCD) */
	alt_u16 usiNFinalDump; /* N Final Dump Config Field */
	alt_u16 usiHEnd; /* H End Config Field */
	bool bChargeInjectionEn; /* Charge Injection Enable Config Field */
	bool bTriLevelClkEn; /* Tri Level Clock Enable Config Field */
	bool bImgClkDir; /* Image Clock Direction Config Field */
	bool bRegClkDir; /* Register Clock Direction Config Field */
	alt_u16 usiPacketSize; /* Data Packet Size Config Field */
	alt_u16 usiIntSyncPeriod; /* Internal Sync Period Config Field */
	alt_u32 uliTrapPumpingDwellCounter; /* Trap Pumping Dwell Counter Field */
	bool bSyncSel; /* Sync Source Selection Config Field */
	alt_u8 ucSensorSel; /* CCD Port Data Sensor Selection Config Field */
	bool bDigitiseEn; /* Digitalise Enable Config Field */
	bool bDGEn; /* DG (Drain Gate) Enable Field */
	bool bCcdReadEn; /* CCD Readout Enable Field */
	alt_u8 ucReg5ConfigReserved; /* Register 5 Configuration Reserved */
	alt_u32 uliCcd1WinListPtr; /* CCD 1 Window List Pointer Config Field */
	alt_u32 uliCcd1PktorderListPtr; /* CCD 1 Packet Order List Pointer Config Field */
	alt_u16 usiCcd1WinListLength; /* CCD 1 Window List Length Config Field */
	alt_u8 ucCcd1WinSizeX; /* CCD 1 Window Size X Config Field */
	alt_u8 ucCcd1WinSizeY; /* CCD 1 Window Size Y Config Field */
	alt_u8 ucReg8ConfigReserved; /* Register 8 Configuration Reserved */
	alt_u32 uliCcd2WinListPtr; /* CCD 2 Window List Pointer Config Field */
	alt_u32 uliCcd2PktorderListPtr; /* CCD 2 Packet Order List Pointer Config Field */
	alt_u16 usiCcd2WinListLength; /* CCD 2 Window List Length Config Field */
	alt_u8 ucCcd2WinSizeX; /* CCD 2 Window Size X Config Field */
	alt_u8 ucCcd2WinSizeY; /* CCD 2 Window Size Y Config Field */
	alt_u8 ucReg11ConfigReserved; /* Register 11 Configuration Reserved */
	alt_u32 uliCcd3WinListPtr; /* CCD 3 Window List Pointer Config Field */
	alt_u32 uliCcd3PktorderListPtr; /* CCD 3 Packet Order List Pointer Config Field */
	alt_u16 usiCcd3WinListLength; /* CCD 3 Window List Length Config Field */
	alt_u8 ucCcd3WinSizeX; /* CCD 3 Window Size X Config Field */
	alt_u8 ucCcd3WinSizeY; /* CCD 3 Window Size Y Config Field */
	alt_u8 ucReg14ConfigReserved; /* Register 14 Configuration Reserved */
	alt_u32 uliCcd4WinListPtr; /* CCD 4 Window List Pointer Config Field */
	alt_u32 uliCcd4PktorderListPtr; /* CCD 4 Packet Order List Pointer Config Field */
	alt_u16 usiCcd4WinListLength; /* CCD 4 Window List Length Config Field */
	alt_u8 ucCcd4WinSizeX; /* CCD 4 Window Size X Config Field */
	alt_u8 ucCcd4WinSizeY; /* CCD 4 Window Size Y Config Field */
	alt_u8 ucReg17ConfigReserved; /* Register 17 Configuration Reserved */
	alt_u16 usiCcdVodConfig; /* CCD Vod Configuration Config Field */
	alt_u16 usiCcd1VrdConfig; /* CCD 1 Vrd Configuration Config Field */
	alt_u8 ucCcd2VrdConfig0; /* CCD 2 Vrd Configuration Config Field */
	alt_u8 ucCcd2VrdConfig1; /* CCD 2 Vrd Configuration Config Field */
	alt_u16 usiCcd3VrdConfig; /* CCD 3 Vrd Configuration Config Field */
	alt_u16 usiCcd4VrdConfig; /* CCD 4 Vrd Configuration Config Field */
	alt_u8 ucCcdVgdConfig0; /* CCD Vgd Configuration Config Field */
	alt_u8 ucCcdVgdConfig1; /* CCD Vgd Configuration Config Field */
	alt_u16 usiCcdVogConfig; /* CCD Vog Configurion Config Field */
	alt_u16 usiCcdIgHiConfig; /* CCD Ig High Configuration Config Field */
	alt_u16 usiCcdIgLoConfig; /* CCD Ig Low Configuration Config Field */
	alt_u16 usiReg21ConfigReserved0; /* Register 21 Configuration Reserved */
	alt_u8 ucCcdModeConfig; /* CCD Mode Configuration Config Field */
	alt_u8 ucReg21ConfigReserved1; /* Register 21 Configuration Reserved */
	bool bClearErrorFlag; /* Clear Error Flag Config Field */
	alt_u32 uliReg22ConfigReserved; /* Register 22 Configuration Reserved */
	alt_u16 usiCcd1LastEPacket; /* CCD 1 Last E Packet Field */
	alt_u16 usiCcd1LastFPacket; /* CCD 1 Last F Packet Field */
	alt_u16 usiCcd2LastEPacket; /* CCD 2 Last E Packet Field */
	alt_u8 ucReg23ConfigReserved; /* Register 23 Configuration Reserved */
	alt_u16 usiCcd2LastFPacket; /* CCD 2 Last F Packet Field */
	alt_u16 usiCcd3LastEPacket; /* CCD 3 Last E Packet Field */
	alt_u16 usiCcd3LastFPacket; /* CCD 3 Last F Packet Field */
	alt_u8 ucReg24ConfigReserved; /* Register 24 Configuration Reserved */
	alt_u16 usiCcd4LastEPacket; /* CCD 4 Last E Packet Field */
	alt_u16 usiCcd4LastFPacket; /* CCD 4 Last F Packet Field */
	alt_u16 usiSurfaceInversionCounter; /* Surface Inversion Counter Field */
	alt_u8 ucReg25ConfigReserved; /* Register 25 Configuration Reserved */
	alt_u16 usiReadoutPauseCounter; /* Readout Pause Counter Field */
	alt_u16 usiTrapPumpingShuffleCounter; /* Trap Pumping Shuffle Counter Field */
} TRmapMemAreaConfig;

/* RMAP Area HK Register Struct */
typedef struct RmapMemAreaHk {
	alt_u16 usiTouSense1; /* TOU Sense 1 HK Field */
	alt_u16 usiTouSense2; /* TOU Sense 2 HK Field */
	alt_u16 usiTouSense3; /* TOU Sense 3 HK Field */
	alt_u16 usiTouSense4; /* TOU Sense 4 HK Field */
	alt_u16 usiTouSense5; /* TOU Sense 5 HK Field */
	alt_u16 usiTouSense6; /* TOU Sense 6 HK Field */
	alt_u16 usiCcd1Ts; /* CCD 1 TS HK Field */
	alt_u16 usiCcd2Ts; /* CCD 2 TS HK Field */
	alt_u16 usiCcd3Ts; /* CCD 3 TS HK Field */
	alt_u16 usiCcd4Ts; /* CCD 4 TS HK Field */
	alt_u16 usiPrt1; /* PRT 1 HK Field */
	alt_u16 usiPrt2; /* PRT 2 HK Field */
	alt_u16 usiPrt3; /* PRT 3 HK Field */
	alt_u16 usiPrt4; /* PRT 4 HK Field */
	alt_u16 usiPrt5; /* PRT 5 HK Field */
	alt_u16 usiZeroDiffAmp; /* Zero Diff Amplifier HK Field */
	alt_u16 usiCcd1VodMon; /* CCD 1 Vod Monitor HK Field */
	alt_u16 usiCcd1VogMon; /* CCD 1 Vog Monitor HK Field */
	alt_u16 usiCcd1VrdMonE; /* CCD 1 Vrd Monitor E HK Field */
	alt_u16 usiCcd2VodMon; /* CCD 2 Vod Monitor HK Field */
	alt_u16 usiCcd2VogMon; /* CCD 2 Vog Monitor HK Field */
	alt_u16 usiCcd2VrdMonE; /* CCD 2 Vrd Monitor E HK Field */
	alt_u16 usiCcd3VodMon; /* CCD 3 Vod Monitor HK Field */
	alt_u16 usiCcd3VogMon; /* CCD 3 Vog Monitor HK Field */
	alt_u16 usiCcd3VrdMonE; /* CCD 3 Vrd Monitor E HK Field */
	alt_u16 usiCcd4VodMon; /* CCD 4 Vod Monitor HK Field */
	alt_u16 usiCcd4VogMon; /* CCD 4 Vog Monitor HK Field */
	alt_u16 usiCcd4VrdMonE; /* CCD 4 Vrd Monitor E HK Field */
	alt_u16 usiVccd; /* V CCD HK Field */
	alt_u16 usiVrclkMon; /* VRClock Monitor HK Field */
	alt_u16 usiViclk; /* VIClock HK Field */
	alt_u16 usiVrclkLow; /* VRClock Low HK Field */
	alt_u16 usi5vbPosMon; /* 5Vb Positive Monitor HK Field */
	alt_u16 usi5vbNegMon; /* 5Vb Negative Monitor HK Field */
	alt_u16 usi3v3bMon; /* 3V3b Monitor HK Field */
	alt_u16 usi2v5aMon; /* 2V5a Monitor HK Field */
	alt_u16 usi3v3dMon; /* 3V3d Monitor HK Field */
	alt_u16 usi2v5dMon; /* 2V5d Monitor HK Field */
	alt_u16 usi1v5dMon; /* 1V5d Monitor HK Field */
	alt_u16 usi5vrefMon; /* 5Vref Monitor HK Field */
	alt_u16 usiVccdPosRaw; /* Vccd Positive Raw HK Field */
	alt_u16 usiVclkPosRaw; /* Vclk Positive Raw HK Field */
	alt_u16 usiVan1PosRaw; /* Van 1 Positive Raw HK Field */
	alt_u16 usiVan3NegMon; /* Van 3 Negative Monitor HK Field */
	alt_u16 usiVan2PosRaw; /* Van Positive Raw HK Field */
	alt_u16 usiVdigRaw; /* Vdig Raw HK Field */
	alt_u16 usiVdigRaw2; /* Vdig Raw 2 HK Field */
	alt_u16 usiViclkLow; /* VIClock Low HK Field */
	alt_u16 usiCcd1VrdMonF; /* CCD 1 Vrd Monitor F HK Field */
	alt_u16 usiCcd1VddMon; /* CCD 1 Vdd Monitor HK Field */
	alt_u16 usiCcd1VgdMon; /* CCD 1 Vgd Monitor HK Field */
	alt_u16 usiCcd2VrdMonF; /* CCD 2 Vrd Monitor F HK Field */
	alt_u16 usiCcd2VddMon; /* CCD 2 Vdd Monitor HK Field */
	alt_u16 usiCcd2VgdMon; /* CCD 2 Vgd Monitor HK Field */
	alt_u16 usiCcd3VrdMonF; /* CCD 3 Vrd Monitor F HK Field */
	alt_u16 usiCcd3VddMon; /* CCD 3 Vdd Monitor HK Field */
	alt_u16 usiCcd3VgdMon; /* CCD 3 Vgd Monitor HK Field */
	alt_u16 usiCcd4VrdMonF; /* CCD 4 Vrd Monitor F HK Field */
	alt_u16 usiCcd4VddMon; /* CCD 4 Vdd Monitor HK Field */
	alt_u16 usiCcd4VgdMon; /* CCD 4 Vgd Monitor HK Field */
	alt_u16 usiIgHiMon; /* Ig High Monitor HK Field */
	alt_u16 usiIgLoMon; /* Ig Low Monitor HK Field */
	alt_u16 usiTsenseA; /* Tsense A HK Field */
	alt_u16 usiTsenseB; /* Tsense B HK Field */
	alt_u8 ucSpwStatusTimecodeFromSpw; /* SpW Status : Timecode From SpaceWire HK Field */
	alt_u8 ucSpwStatusRmapTargetStatus; /* SpW Status : RMAP Target Status HK Field */
	alt_u8 ucSpwStatusSpwStatusReserved; /* SpW Status : SpaceWire Status Reserved */
	bool bSpwStatusRmapTargetIndicate; /* SpW Status : RMAP Target Indicate HK Field */
	bool bSpwStatusStatLinkEscapeError; /* SpW Status : Status Link Escape Error HK Field */
	bool bSpwStatusStatLinkCreditError; /* SpW Status : Status Link Credit Error HK Field */
	bool bSpwStatusStatLinkParityError; /* SpW Status : Status Link Parity Error HK Field */
	bool bSpwStatusStatLinkDisconnect; /* SpW Status : Status Link Disconnect HK Field */
	bool bSpwStatusStatLinkRunning; /* SpW Status : Status Link Running HK Field */
	alt_u8 ucReg32HkReserved; /* Register 32 HK Reserved */
	alt_u16 usiFrameCounter; /* Frame Counter HK Field */
	alt_u16 usiReg33HkReserved; /* Register 33 HK Reserved */
	alt_u8 ucOpMode; /* Operational Mode HK Field */
	alt_u8 ucFrameNumber; /* Frame Number HK Field */
	bool bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongXCoordinate; /* Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong X Coordinate HK Field */
	bool bErrorFlagsWindowPixelsFallOutsideCddBoundaryDueToWrongYCoordinate; /* Error Flags : Window Pixels Fall Outside CDD Boundary Due To Wrong Y Coordinate HK Field */
	bool bErrorFlagsESidePixelExternalSramBufferIsFull; /* Error Flags : E Side Pixel External SRAM Buffer is Full HK Field */
	bool bErrorFlagsFSidePixelExternalSramBufferIsFull; /* Error Flags : F Side Pixel External SRAM Buffer is Full HK Field */
	bool bErrorFlagsInvalidCcdMode; /* Error Flags : Invalid CCD Mode */
	alt_u32 uliErrorFlagsErrorFlagsReserved; /* Error Flags : Error Flags Reserved */
	alt_u8 ucFpgaMinorVersion; /* FPGA Minor Version Field */
	alt_u8 ucFpgaMajorVersion; /* FPGA Major Version Field */
	alt_u16 usiBoardId; /* Board ID Field */
	alt_u16 uliReg35HkReserved; /* Register 35 HK Reserved HK Field */
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
