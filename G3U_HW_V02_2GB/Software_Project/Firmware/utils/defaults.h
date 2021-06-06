/*
 * defaults.h
 *
 *  Created on: 29 de set de 2020
 *      Author: rfranca
 */

#ifndef UTILS_DEFAULTS_H_
#define UTILS_DEFAULTS_H_

#include "../simucam_definitions.h"
#include "meb.h"
#include "configs_simucam.h"
#include "../driver/comm/comm.h"

//! [constants definition]
#define DEFT_MEB_DEFS_ID_LOWER_LIM      0
#define DEFT_FEE_DEFS_ID_LOWER_LIM      1000
#define DEFT_NUC_DEFS_ID_LOWER_LIM      10000
#define DEFT_NUC_DEFS_ID_RESERVED       0xFFFF
#define DEFT_RETRANSMISSION_TIMEOUT     5

/* General Simulation Parameters IDs */
enum DeftGenSimulationParamsID {
	eDeftMebOverScanSerialId     = 4,  /* CCD Serial Overscan Columns */
	eDeftMebPreScanSerialId      = 5,  /* CCD Serial Prescan Columns */
	eDeftMebOLNId                = 6,  /* CCD Parallel Overscan Lines */
	eDeftMebColsId               = 7,  /* CCD Columns */
	eDeftMebRowsId               = 8,  /* CCD Image Lines */
	eDeftMebExposurePeriodId     = 9,  /* SimuCam Exposure Period [ms] */
	eDeftMebBufferOverflowEnId   = 11, /* Output Buffer Overflow Enable */
	eDeftMebStartDelayId         = 12, /* CCD Start Readout Delay [ms] */
	eDeftMebSkipDelayId          = 13, /* CCD Line Skip Delay [ns] */
	eDeftMebLineDelayId          = 14, /* CCD Line Transfer Delay [ns] */
	eDeftMebADCPixelDelayId      = 15, /* CCD ADC And Pixel Transfer Delay [ns] */
	eDeftMebDebugLevelId         = 20, /* Serial Messages Debug Level */
	eDeftMebGuardFeeDelayId      = 22, /* FEEs Guard Delay [ms] */
	eDeftMebSyncSourceId         = 26  /* SimuCam Synchronism Source (0 = Internal / 1 = External) */
} EDeftGenSimulationParamsID;

/* N-FEE Configuration RMAP Area */
enum DeftNfeeCfgRmapAreaID {
	eDeftNfeeRmapAreaConfigVStartId                    = 1000, /* N-FEE RMAP Area Config Register 0, V Start Config Field */
	eDeftNfeeRmapAreaConfigVEndId                      = 1001, /* N-FEE RMAP Area Config Register 0, V End Config Field */
	eDeftNfeeRmapAreaConfigChargeInjectionWidthId      = 1002, /* N-FEE RMAP Area Config Register 1, Charge Injection Width Config Field */
	eDeftNfeeRmapAreaConfigChargeInjectionGapId        = 1003, /* N-FEE RMAP Area Config Register 1, Charge Injection Gap Config Field */
	eDeftNfeeRmapAreaConfigParallelToiPeriodId         = 1004, /* N-FEE RMAP Area Config Register 2, Parallel Toi Period Config Field */
	eDeftNfeeRmapAreaConfigParallelClkOverlapId        = 1005, /* N-FEE RMAP Area Config Register 2, Parallel Clock Overlap Config Field */
	eDeftNfeeRmapAreaConfigCcdReadoutOrder1stCcdId     = 1006, /* N-FEE RMAP Area Config Register 2, CCD Readout Order Config Field (1st CCD) */
	eDeftNfeeRmapAreaConfigCcdReadoutOrder2ndCcdId     = 1007, /* N-FEE RMAP Area Config Register 2, CCD Readout Order Config Field (2nd CCD) */
	eDeftNfeeRmapAreaConfigCcdReadoutOrder3rdCcdId     = 1008, /* N-FEE RMAP Area Config Register 2, CCD Readout Order Config Field (3rd CCD) */
	eDeftNfeeRmapAreaConfigCcdReadoutOrder4thCcdId     = 1009, /* N-FEE RMAP Area Config Register 2, CCD Readout Order Config Field (4th CCD) */
	eDeftNfeeRmapAreaConfigNFinalDumpId                = 1010, /* N-FEE RMAP Area Config Register 3, N Final Dump Config Field */
	eDeftNfeeRmapAreaConfigHEndId                      = 1011, /* N-FEE RMAP Area Config Register 3, H End Config Field */
	eDeftNfeeRmapAreaConfigChargeInjectionEnId         = 1012, /* N-FEE RMAP Area Config Register 3, Charge Injection Enable Config Field */
	eDeftNfeeRmapAreaConfigTriLevelClkEnId             = 1013, /* N-FEE RMAP Area Config Register 3, Tri Level Clock Enable Config Field */
	eDeftNfeeRmapAreaConfigImgClkDirId                 = 1014, /* N-FEE RMAP Area Config Register 3, Image Clock Direction Config Field */
	eDeftNfeeRmapAreaConfigRegClkDirId                 = 1015, /* N-FEE RMAP Area Config Register 3, Register Clock Direction Config Field */
	eDeftNfeeRmapAreaConfigPacketSizeId                = 1016, /* N-FEE RMAP Area Config Register 4, Data Packet Size Config Field */
	eDeftNfeeRmapAreaConfigIntSyncPeriodId             = 1017, /* N-FEE RMAP Area Config Register 4, Internal Sync Period Config Field */
	eDeftNfeeRmapAreaConfigTrapPumpingDwellCounterId   = 1018, /* N-FEE RMAP Area Config Register 5, Trap Pumping Dwell Counter Field */
	eDeftNfeeRmapAreaConfigSyncSelId                   = 1019, /* N-FEE RMAP Area Config Register 5, Sync Source Selection Config Field */
	eDeftNfeeRmapAreaConfigSensorSelId                 = 1020, /* N-FEE RMAP Area Config Register 5, CCD Port Data Sensor Selection Config Field */
	eDeftNfeeRmapAreaConfigDigitiseEnId                = 1021, /* N-FEE RMAP Area Config Register 5, Digitalise Enable Config Field */
	eDeftNfeeRmapAreaConfigDGEnId                      = 1022, /* N-FEE RMAP Area Config Register 5, DG (Drain Gate) Enable Field */
	eDeftNfeeRmapAreaConfigCcdReadEnId                 = 1023, /* N-FEE RMAP Area Config Register 5, CCD Readout Enable Field */
	eDeftNfeeRmapAreaConfigCcd1WinListPtrId            = 1025, /* N-FEE RMAP Area Config Register 6, CCD 1 Window List Pointer Config Field */
	eDeftNfeeRmapAreaConfigCcd1PktorderListPtrId       = 1026, /* N-FEE RMAP Area Config Register 7, CCD 1 Packet Order List Pointer Config Field */
	eDeftNfeeRmapAreaConfigCcd1WinListLengthId         = 1027, /* N-FEE RMAP Area Config Register 8, CCD 1 Window List Length Config Field */
	eDeftNfeeRmapAreaConfigCcd1WinSizeXId              = 1028, /* N-FEE RMAP Area Config Register 8, CCD 1 Window Size X Config Field */
	eDeftNfeeRmapAreaConfigCcd1WinSizeYId              = 1029, /* N-FEE RMAP Area Config Register 8, CCD 1 Window Size Y Config Field */
	eDeftNfeeRmapAreaConfigReg8ConfigReservedId        = 1030, /* N-FEE RMAP Area Config Register 8, Register 8 Configuration Reserved */
	eDeftNfeeRmapAreaConfigCcd2WinListPtrId            = 1031, /* N-FEE RMAP Area Config Register 9, CCD 2 Window List Pointer Config Field */
	eDeftNfeeRmapAreaConfigCcd2PktorderListPtrId       = 1032, /* N-FEE RMAP Area Config Register 10, CCD 2 Packet Order List Pointer Config Field */
	eDeftNfeeRmapAreaConfigCcd2WinListLengthId         = 1033, /* N-FEE RMAP Area Config Register 11, CCD 2 Window List Length Config Field */
	eDeftNfeeRmapAreaConfigCcd2WinSizeXId              = 1034, /* N-FEE RMAP Area Config Register 11, CCD 2 Window Size X Config Field */
	eDeftNfeeRmapAreaConfigCcd2WinSizeYId              = 1035, /* N-FEE RMAP Area Config Register 11, CCD 2 Window Size Y Config Field */
	eDeftNfeeRmapAreaConfigReg11ConfigReservedId       = 1036, /* N-FEE RMAP Area Config Register 11, Register 11 Configuration Reserved */
	eDeftNfeeRmapAreaConfigCcd3WinListPtrId            = 1037, /* N-FEE RMAP Area Config Register 12, CCD 3 Window List Pointer Config Field */
	eDeftNfeeRmapAreaConfigCcd3PktorderListPtrId       = 1038, /* N-FEE RMAP Area Config Register 13, CCD 3 Packet Order List Pointer Config Field */
	eDeftNfeeRmapAreaConfigCcd3WinListLengthId         = 1039, /* N-FEE RMAP Area Config Register 14, CCD 3 Window List Length Config Field */
	eDeftNfeeRmapAreaConfigCcd3WinSizeXId              = 1040, /* N-FEE RMAP Area Config Register 14, CCD 3 Window Size X Config Field */
	eDeftNfeeRmapAreaConfigCcd3WinSizeYId              = 1041, /* N-FEE RMAP Area Config Register 14, CCD 3 Window Size Y Config Field */
	eDeftNfeeRmapAreaConfigReg14ConfigReservedId       = 1042, /* N-FEE RMAP Area Config Register 14, Register 14 Configuration Reserved */
	eDeftNfeeRmapAreaConfigCcd4WinListPtrId            = 1043, /* N-FEE RMAP Area Config Register 15, CCD 4 Window List Pointer Config Field */
	eDeftNfeeRmapAreaConfigCcd4PktorderListPtrId       = 1044, /* N-FEE RMAP Area Config Register 16, CCD 4 Packet Order List Pointer Config Field */
	eDeftNfeeRmapAreaConfigCcd4WinListLengthId         = 1045, /* N-FEE RMAP Area Config Register 17, CCD 4 Window List Length Config Field */
	eDeftNfeeRmapAreaConfigCcd4WinSizeXId              = 1046, /* N-FEE RMAP Area Config Register 17, CCD 4 Window Size X Config Field */
	eDeftNfeeRmapAreaConfigCcd4WinSizeYId              = 1047, /* N-FEE RMAP Area Config Register 17, CCD 4 Window Size Y Config Field */
	eDeftNfeeRmapAreaConfigReg17ConfigReservedId       = 1048, /* N-FEE RMAP Area Config Register 17, Register 17 Configuration Reserved */
	eDeftNfeeRmapAreaConfigCcdVodConfigId              = 1049, /* N-FEE RMAP Area Config Register 18, CCD Vod Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcd1VrdConfigId             = 1050, /* N-FEE RMAP Area Config Register 18, CCD 1 Vrd Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcd2VrdConfig0Id            = 1051, /* N-FEE RMAP Area Config Register 18, CCD 2 Vrd Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcd2VrdConfig1Id            = 1052, /* N-FEE RMAP Area Config Register 19, CCD 2 Vrd Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcd3VrdConfigId             = 1053, /* N-FEE RMAP Area Config Register 19, CCD 3 Vrd Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcd4VrdConfigId             = 1054, /* N-FEE RMAP Area Config Register 19, CCD 4 Vrd Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcdVgdConfig0Id             = 1055, /* N-FEE RMAP Area Config Register 19, CCD Vgd Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcdVgdConfig1Id             = 1056, /* N-FEE RMAP Area Config Register 20, CCD Vgd Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcdVogConfigId              = 1057, /* N-FEE RMAP Area Config Register 20, CCD Vog Configurion Config Field */
	eDeftNfeeRmapAreaConfigCcdIgHiConfigId             = 1058, /* N-FEE RMAP Area Config Register 20, CCD Ig High Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcdIgLoConfigId             = 1059, /* N-FEE RMAP Area Config Register 21, CCD Ig Low Configuration Config Field */
	eDeftNfeeRmapAreaConfigCcdModeConfigId             = 1061, /* N-FEE RMAP Area Config Register 21, CCD Mode Configuration Config Field */
	eDeftNfeeRmapAreaConfigReg21ConfigReserved1Id      = 1062, /* N-FEE RMAP Area Config Register 21, Register 21 Configuration Reserved */
	eDeftNfeeRmapAreaConfigReg22ConfigReservedId       = 1064, /* N-FEE RMAP Area Config Register 22, Register 22 Configuration Reserved */
	eDeftNfeeRmapAreaConfigCcd1LastEPacketId           = 1065, /* N-FEE RMAP Area Config Register 23, CCD 1 Last E Packet Field */
	eDeftNfeeRmapAreaConfigCcd1LastFPacketId           = 1066, /* N-FEE RMAP Area Config Register 23, CCD 1 Last F Packet Field */
	eDeftNfeeRmapAreaConfigCcd2LastEPacketId           = 1067, /* N-FEE RMAP Area Config Register 23, CCD 2 Last E Packet Field */
	eDeftNfeeRmapAreaConfigReg23ConfigReservedId       = 1068, /* N-FEE RMAP Area Config Register 23, Register 23 Configuration Reserved */
	eDeftNfeeRmapAreaConfigCcd2LastFPacketId           = 1069, /* N-FEE RMAP Area Config Register 24, CCD 2 Last F Packet Field */
	eDeftNfeeRmapAreaConfigCcd3LastEPacketId           = 1070, /* N-FEE RMAP Area Config Register 24, CCD 3 Last E Packet Field */
	eDeftNfeeRmapAreaConfigCcd3LastFPacketId           = 1071, /* N-FEE RMAP Area Config Register 24, CCD 3 Last F Packet Field */
	eDeftNfeeRmapAreaConfigReg24ConfigReservedId       = 1072, /* N-FEE RMAP Area Config Register 24, Register 24 Configuration Reserved */
	eDeftNfeeRmapAreaConfigCcd4LastEPacketId           = 1073, /* N-FEE RMAP Area Config Register 25, CCD 4 Last E Packet Field */
	eDeftNfeeRmapAreaConfigCcd4LastFPacketId           = 1074, /* N-FEE RMAP Area Config Register 25, CCD 4 Last F Packet Field */
	eDeftNfeeRmapAreaConfigSurfaceInversionCounterId   = 1075, /* N-FEE RMAP Area Config Register 25, Surface Inversion Counter Field */
	eDeftNfeeRmapAreaConfigReg25ConfigReservedId       = 1076, /* N-FEE RMAP Area Config Register 25, Register 25 Configuration Reserved */
	eDeftNfeeRmapAreaConfigReadoutPauseCounterId       = 1077, /* N-FEE RMAP Area Config Register 26, Readout Pause Counter Field */
	eDeftNfeeRmapAreaConfigTrapPumpingShuffleCounterId = 1078, /* N-FEE RMAP Area Config Register 26, Trap Pumping Shuffle Counter Field */
	eDeftNfeeRmapAreaConfigConvDlyId                   = 1079, /* N-FEE RMAP Area Config Register 5, Conversion Delay Value */
	eDeftNfeeRmapAreaConfigHighPrecisionHkEnId         = 1080, /* N-FEE RMAP Area Config Register 5, High Precison Housekeep Enable Field */
	eDeftNfeeRmapAreaConfigTrkHldHiId                  = 1081, /* N-FEE RMAP Area Config Register 21, Trk Hld High Configuration Config Field */
	eDeftNfeeRmapAreaConfigTrkHldLoId                  = 1082, /* N-FEE RMAP Area Config Register 21, Trk Hld Low Configuration Config Field */
	eDeftNfeeRmapAreaConfigReg21ConfigReserved0Id      = 1083, /* N-FEE RMAP Area Config Register 21, Register 21 Configuration Reserved */
	eDeftNfeeRmapAreaConfigRCfg1Id                     = 1084, /* N-FEE RMAP Area Config Register 22, R Config 1 Field */
	eDeftNfeeRmapAreaConfigRCfg2Id                     = 1085, /* N-FEE RMAP Area Config Register 22, R Config 2 Field */
	eDeftNfeeRmapAreaConfigCdsclpLoId                  = 1086  /* N-FEE RMAP Area Config Register 22, Cdsclp Lo Field */
} EDeftNfeeCfgRmapAreaID;

/* N-FEE Housekeeping RMAP Area */
enum DeftNfeeHkRmapAreaID {
	eDeftNfeeRmapAreaHkTouSense1Id                  = 2000, /* N-FEE RMAP Area HK Register 0, TOU Sense 1 HK Field */
	eDeftNfeeRmapAreaHkTouSense2Id                  = 2001, /* N-FEE RMAP Area HK Register 0, TOU Sense 2 HK Field */
	eDeftNfeeRmapAreaHkTouSense3Id                  = 2002, /* N-FEE RMAP Area HK Register 1, TOU Sense 3 HK Field */
	eDeftNfeeRmapAreaHkTouSense4Id                  = 2003, /* N-FEE RMAP Area HK Register 1, TOU Sense 4 HK Field */
	eDeftNfeeRmapAreaHkTouSense5Id                  = 2004, /* N-FEE RMAP Area HK Register 2, TOU Sense 5 HK Field */
	eDeftNfeeRmapAreaHkTouSense6Id                  = 2005, /* N-FEE RMAP Area HK Register 2, TOU Sense 6 HK Field */
	eDeftNfeeRmapAreaHkCcd1TsId                     = 2006, /* N-FEE RMAP Area HK Register 3, CCD 1 TS HK Field */
	eDeftNfeeRmapAreaHkCcd2TsId                     = 2007, /* N-FEE RMAP Area HK Register 3, CCD 2 TS HK Field */
	eDeftNfeeRmapAreaHkCcd3TsId                     = 2008, /* N-FEE RMAP Area HK Register 4, CCD 3 TS HK Field */
	eDeftNfeeRmapAreaHkCcd4TsId                     = 2009, /* N-FEE RMAP Area HK Register 4, CCD 4 TS HK Field */
	eDeftNfeeRmapAreaHkPrt1Id                       = 2010, /* N-FEE RMAP Area HK Register 5, PRT 1 HK Field */
	eDeftNfeeRmapAreaHkPrt2Id                       = 2011, /* N-FEE RMAP Area HK Register 5, PRT 2 HK Field */
	eDeftNfeeRmapAreaHkPrt3Id                       = 2012, /* N-FEE RMAP Area HK Register 6, PRT 3 HK Field */
	eDeftNfeeRmapAreaHkPrt4Id                       = 2013, /* N-FEE RMAP Area HK Register 6, PRT 4 HK Field */
	eDeftNfeeRmapAreaHkPrt5Id                       = 2014, /* N-FEE RMAP Area HK Register 7, PRT 5 HK Field */
	eDeftNfeeRmapAreaHkZeroDiffAmpId                = 2015, /* N-FEE RMAP Area HK Register 7, Zero Diff Amplifier HK Field */
	eDeftNfeeRmapAreaHkCcd1VodMonId                 = 2016, /* N-FEE RMAP Area HK Register 8, CCD 1 Vod Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd1VogMonId                 = 2017, /* N-FEE RMAP Area HK Register 8, CCD 1 Vog Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd1VrdMonEId                = 2018, /* N-FEE RMAP Area HK Register 9, CCD 1 Vrd Monitor E HK Field */
	eDeftNfeeRmapAreaHkCcd2VodMonId                 = 2019, /* N-FEE RMAP Area HK Register 9, CCD 2 Vod Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd2VogMonId                 = 2020, /* N-FEE RMAP Area HK Register 10, CCD 2 Vog Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd2VrdMonEId                = 2021, /* N-FEE RMAP Area HK Register 10, CCD 2 Vrd Monitor E HK Field */
	eDeftNfeeRmapAreaHkCcd3VodMonId                 = 2022, /* N-FEE RMAP Area HK Register 11, CCD 3 Vod Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd3VogMonId                 = 2023, /* N-FEE RMAP Area HK Register 11, CCD 3 Vog Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd3VrdMonEId                = 2024, /* N-FEE RMAP Area HK Register 12, CCD 3 Vrd Monitor E HK Field */
	eDeftNfeeRmapAreaHkCcd4VodMonId                 = 2025, /* N-FEE RMAP Area HK Register 12, CCD 4 Vod Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd4VogMonId                 = 2026, /* N-FEE RMAP Area HK Register 13, CCD 4 Vog Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd4VrdMonEId                = 2027, /* N-FEE RMAP Area HK Register 13, CCD 4 Vrd Monitor E HK Field */
	eDeftNfeeRmapAreaHkVccdId                       = 2028, /* N-FEE RMAP Area HK Register 14, V CCD HK Field */
	eDeftNfeeRmapAreaHkVrclkMonId                   = 2029, /* N-FEE RMAP Area HK Register 14, VRClock Monitor HK Field */
	eDeftNfeeRmapAreaHkViclkId                      = 2030, /* N-FEE RMAP Area HK Register 15, VIClock HK Field */
	eDeftNfeeRmapAreaHkVrclkLowId                   = 2031, /* N-FEE RMAP Area HK Register 15, VRClock Low HK Field */
	eDeftNfeeRmapAreaHk5vbPosMonId                  = 2032, /* N-FEE RMAP Area HK Register 16, 5Vb Positive Monitor HK Field */
	eDeftNfeeRmapAreaHk5vbNegMonId                  = 2033, /* N-FEE RMAP Area HK Register 16, 5Vb Negative Monitor HK Field */
	eDeftNfeeRmapAreaHk3v3bMonId                    = 2034, /* N-FEE RMAP Area HK Register 17, 3V3b Monitor HK Field */
	eDeftNfeeRmapAreaHk2v5aMonId                    = 2035, /* N-FEE RMAP Area HK Register 17, 2V5a Monitor HK Field */
	eDeftNfeeRmapAreaHk3v3dMonId                    = 2036, /* N-FEE RMAP Area HK Register 18, 3V3d Monitor HK Field */
	eDeftNfeeRmapAreaHk2v5dMonId                    = 2037, /* N-FEE RMAP Area HK Register 18, 2V5d Monitor HK Field */
	eDeftNfeeRmapAreaHk1v5dMonId                    = 2038, /* N-FEE RMAP Area HK Register 19, 1V5d Monitor HK Field */
	eDeftNfeeRmapAreaHk5vrefMonId                   = 2039, /* N-FEE RMAP Area HK Register 19, 5Vref Monitor HK Field */
	eDeftNfeeRmapAreaHkVccdPosRawId                 = 2040, /* N-FEE RMAP Area HK Register 20, Vccd Positive Raw HK Field */
	eDeftNfeeRmapAreaHkVclkPosRawId                 = 2041, /* N-FEE RMAP Area HK Register 20, Vclk Positive Raw HK Field */
	eDeftNfeeRmapAreaHkVan1PosRawId                 = 2042, /* N-FEE RMAP Area HK Register 21, Van 1 Positive Raw HK Field */
	eDeftNfeeRmapAreaHkVan3NegMonId                 = 2043, /* N-FEE RMAP Area HK Register 21, Van 3 Negative Monitor HK Field */
	eDeftNfeeRmapAreaHkVan2PosRawId                 = 2044, /* N-FEE RMAP Area HK Register 22, Van Positive Raw HK Field */
	eDeftNfeeRmapAreaHkVdigRawId                    = 2045, /* N-FEE RMAP Area HK Register 22, Vdig Raw HK Field */
	eDeftNfeeRmapAreaHkVdigRaw2Id                   = 2046, /* N-FEE RMAP Area HK Register 23, Vdig Raw 2 HK Field */
	eDeftNfeeRmapAreaHkViclkLowId                   = 2047, /* N-FEE RMAP Area HK Register 23, VIClock Low HK Field */
	eDeftNfeeRmapAreaHkCcd1VrdMonFId                = 2048, /* N-FEE RMAP Area HK Register 24, CCD 1 Vrd Monitor F HK Field */
	eDeftNfeeRmapAreaHkCcd1VddMonId                 = 2049, /* N-FEE RMAP Area HK Register 24, CCD 1 Vdd Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd1VgdMonId                 = 2050, /* N-FEE RMAP Area HK Register 25, CCD 1 Vgd Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd2VrdMonFId                = 2051, /* N-FEE RMAP Area HK Register 25, CCD 2 Vrd Monitor F HK Field */
	eDeftNfeeRmapAreaHkCcd2VddMonId                 = 2052, /* N-FEE RMAP Area HK Register 26, CCD 2 Vdd Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd2VgdMonId                 = 2053, /* N-FEE RMAP Area HK Register 26, CCD 2 Vgd Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd3VrdMonFId                = 2054, /* N-FEE RMAP Area HK Register 27, CCD 3 Vrd Monitor F HK Field */
	eDeftNfeeRmapAreaHkCcd3VddMonId                 = 2055, /* N-FEE RMAP Area HK Register 27, CCD 3 Vdd Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd3VgdMonId                 = 2056, /* N-FEE RMAP Area HK Register 28, CCD 3 Vgd Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd4VrdMonFId                = 2057, /* N-FEE RMAP Area HK Register 28, CCD 4 Vrd Monitor F HK Field */
	eDeftNfeeRmapAreaHkCcd4VddMonId                 = 2058, /* N-FEE RMAP Area HK Register 29, CCD 4 Vdd Monitor HK Field */
	eDeftNfeeRmapAreaHkCcd4VgdMonId                 = 2059, /* N-FEE RMAP Area HK Register 29, CCD 4 Vgd Monitor HK Field */
	eDeftNfeeRmapAreaHkIgHiMonId                    = 2060, /* N-FEE RMAP Area HK Register 30, Ig High Monitor HK Field */
	eDeftNfeeRmapAreaHkIgLoMonId                    = 2061, /* N-FEE RMAP Area HK Register 30, Ig Low Monitor HK Field */
	eDeftNfeeRmapAreaHkTsenseAId                    = 2062, /* N-FEE RMAP Area HK Register 31, Tsense A HK Field */
	eDeftNfeeRmapAreaHkTsenseBId                    = 2063, /* N-FEE RMAP Area HK Register 31, Tsense B HK Field */
	eDeftNfeeRmapAreaHkSpwStatusSpwStatusReservedId = 2064, /* N-FEE RMAP Area HK Register 32, SpW Status : SpaceWire Status Reserved */
	eDeftNfeeRmapAreaHkReg32HkReservedId            = 2065, /* N-FEE RMAP Area HK Register 32, Register 32 HK Reserved */
	eDeftNfeeRmapAreaHkReg33HkReservedId            = 2066, /* N-FEE RMAP Area HK Register 33, Register 33 HK Reserved */
	eDeftNfeeRmapAreaHkOpModeId                     = 2067, /* N-FEE RMAP Area HK Register 33, Operational Mode HK Field */
	eDeftNfeeRmapAreaHkFpgaMinorVersionId           = 2069, /* N-FEE RMAP Area HK Register 35, FPGA Minor Version Field */
	eDeftNfeeRmapAreaHkFpgaMajorVersionId           = 2070, /* N-FEE RMAP Area HK Register 35, FPGA Major Version Field */
	eDeftNfeeRmapAreaHkBoardIdId                    = 2071, /* N-FEE RMAP Area HK Register 35, Board ID Field */
	eDeftNfeeRmapAreaHkReg35HkReservedId            = 2072  /* N-FEE RMAP Area HK Register 35, Register 35 HK Reserved HK Field */
} EDeftNfeeHkRmapAreaID;

/* SpaceWire Interface Parameters */
enum DeftSpwInterfaceParamsID {
	eDeftSpwSpwLinkStartId           = 3000, /* SpaceWire link set as Link Start */
	eDeftSpwSpwLinkAutostartId       = 3001, /* SpaceWire link set as Link Auto-Start */
	eDeftSpwSpwLinkSpeedId           = 3002, /* SpaceWire Link Speed [Mhz] */
	eDeftSpwTimeCodeTransmissionEnId = 3003, /* Timecode Transmission Enable */
	eDeftSpwLogicalAddrId            = 3004, /* RMAP Logical Address */
	eDeftSpwRmapKeyId                = 3005, /* RMAP Key */
	eDeftSpwDataProtIdId             = 3006, /* Data Packet Protocol ID */
	eDeftSpwDpuLogicalAddrId         = 3007  /* Data Packet Target Logical Address */
} EDeftSpwInterfaceParamsID;

/* Ethernet Interface Parameters */
enum DeftEthInterfaceParamsID {
	eDeftEthTcpServerPortId = 10000, /* PUS TCP Server Port */
	eDeftEthDhcpV4EnableId  = 10001, /* PUS TCP Enable DHCP (dynamic) IP (all IPv4 fields below will be ignored if this is true) */
	eDeftEthIpV4AddressId   = 10002, /* PUS TCP address IPv4 uint32 representation (Example is 192.168.17.10) */
	eDeftEthIpV4SubnetId    = 10003, /* PUS TCP subnet IPv4 uint32 representation (Example is 255.255.255.0) */
	eDeftEthIpV4GatewayId   = 10004, /* PUS TCP gateway IPv4 uint32 representation (Example is 192.168.17.1) */
	eDeftEthIpV4DNSId       = 10005, /* PUS TCP DNS IPv4 uint32 representation (Example is 1.1.1.1) */
	eDeftEthPusHpPidId      = 10006, /* PUS HP_PID identification (>127 to disable verification) */
	eDeftEthPusHpPcatId     = 10007, /* PUS HP_PCAT identification (> 15 to disable verification) */
	eDeftEthPusEncapId      = 10008  /* PUS Default Encapsulation Protocol (0 = None, 1 = EDEN) */
} EDeftEthInterfaceParamsID;
//! [constants definition]

//! [public module structs definition]

/* MEB defaults */
typedef struct DeftMebDefaults {
	TGenSimulationParams *pxGenSimulationParams; /* General Simulation Parameters */
} TDeftMebDefaults;

/* FEE defaults */
typedef struct DeftFeeDefaults {
	TRmapMemAreaConfig xRmapMemAreaConfig; /* N-FEE Configuration RMAP Area */
	TRmapMemAreaHk xRmapMemAreaHk; /* N-FEE Housekeeping RMAP Area */
	TSpwInterfaceParams *pxSpwInterfaceParams; /* SpaceWire Interface Parameters */
} TDeftFeeDefaults;

/* NUC defaults */
typedef struct DeftNucDefaults {
	TEthInterfaceParams *pxEthInterfaceParams; /* Ethernet Interface Parameters */
} TDeftNucDefaults;
//! [public module structs definition]

//! [public function prototypes]
void vDeftInitMebDefault();
bool bDeftInitFeeDefault(alt_u8 ucFee);
void vDeftInitNucDefault();

bool bDeftSetMebDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue);
bool bDeftSetFeeDefaultValues(alt_u8 ucFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue);
bool bDeftSetNucDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue);

bool bDeftSetDefaultValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue);
//! [public function prototypes]

//! [data memory public global variables - use extern]
extern volatile bool vbDeftDefaultsReceived;
extern volatile alt_u32 vuliDeftExpectedDefaultsQtd;
extern volatile alt_u32 vuliDeftReceivedDefaultsQtd;
extern volatile TDeftMebDefaults vxDeftMebDefaults;
extern volatile TDeftFeeDefaults vxDeftFeeDefaults[N_OF_NFEE];
extern volatile TDeftNucDefaults vxDeftNucDefaults;
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* UTILS_DEFAULTS_H_ */
