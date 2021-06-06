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
volatile bool vbDeftDefaultsReceived = FALSE;
volatile alt_u32 vuliDeftExpectedDefaultsQtd = 1;
volatile alt_u32 vuliDeftReceivedDefaultsQtd = 0;
volatile TDeftMebDefaults vxDeftMebDefaults;
volatile TDeftFeeDefaults vxDeftFeeDefaults[N_OF_NFEE];
volatile TDeftNucDefaults vxDeftNucDefaults;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vDeftInitMebDefault() {

	vxDeftMebDefaults.pxGenSimulationParams = &(xDefaults);

	*(vxDeftMebDefaults.pxGenSimulationParams) = cxDefaultsGenSimulationParams;

}

bool bDeftInitFeeDefault(alt_u8 ucFee) {
	bool bStatus = FALSE;

	if (N_OF_NFEE > ucFee) {

		vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams = &(xConfSpw[ucFee]);

		vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig = cxDefaultsRmapMemAreaConfig;
		vxDeftFeeDefaults[ucFee].xRmapMemAreaHk = cxDefaultsRmapMemAreaHk;
		*(vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams) = cxDefaultsSpwInterfaceParams;

		bStatus = TRUE;
	}

	return (bStatus);
}

void vDeftInitNucDefault() {

	vxDeftNucDefaults.pxEthInterfaceParams = &(xConfEth);

	*(vxDeftNucDefaults.pxEthInterfaceParams) = cxDefaultsEthInterfaceParams;

}

bool bDeftSetMebDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	vxDeftMebDefaults.pxGenSimulationParams = &(xDefaults);

	switch (usiDefaultId) {

		/* CCD Serial Overscan Columns */
		case eDeftMebOverScanSerialId:
			vxDeftMebDefaults.pxGenSimulationParams->usiOverScanSerial = (alt_u16) uliDefaultValue;
			break;
		/* CCD Serial Prescan Columns */
		case eDeftMebPreScanSerialId:
			vxDeftMebDefaults.pxGenSimulationParams->usiPreScanSerial = (alt_u16) uliDefaultValue;
			break;
		/* CCD Parallel Overscan Lines */
		case eDeftMebOLNId:
			vxDeftMebDefaults.pxGenSimulationParams->usiOLN = (alt_u16) uliDefaultValue;
			break;
		/* CCD Columns */
		case eDeftMebColsId:
			vxDeftMebDefaults.pxGenSimulationParams->usiCols = (alt_u16) uliDefaultValue;
			break;
		/* CCD Image Lines */
		case eDeftMebRowsId:
			vxDeftMebDefaults.pxGenSimulationParams->usiRows = (alt_u16) uliDefaultValue;
			break;
		/* SimuCam Exposure Period [ms] */
		case eDeftMebExposurePeriodId:
			vxDeftMebDefaults.pxGenSimulationParams->usiExposurePeriod = (alt_u16) uliDefaultValue;
			break;
		/* Output Buffer Overflow Enable */
		case eDeftMebBufferOverflowEnId:
			vxDeftMebDefaults.pxGenSimulationParams->bBufferOverflowEn = (bool) uliDefaultValue;
			break;
		/* CCD Start Readout Delay [ms] */
		case eDeftMebStartDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->ulStartDelay = (alt_u32) uliDefaultValue;
			break;
		/* CCD Line Skip Delay [ns] */
		case eDeftMebSkipDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->ulSkipDelay = (alt_u32) uliDefaultValue;
			break;
		/* CCD Line Transfer Delay [ns] */
		case eDeftMebLineDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->ulLineDelay = (alt_u32) uliDefaultValue;
			break;
		/* CCD ADC And Pixel Transfer Delay [ns] */
		case eDeftMebADCPixelDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->ulADCPixelDelay = (alt_u32) uliDefaultValue;
			break;
		/* Serial Messages Debug Level */
		case eDeftMebDebugLevelId:
			vxDeftMebDefaults.pxGenSimulationParams->ucDebugLevel = (alt_u8) uliDefaultValue;
			break;
		/* FEEs Guard Delay [ms] */
		case eDeftMebGuardFeeDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->usiGuardFEEDelay = (alt_u16) uliDefaultValue;
			break;
		/* SimuCam Synchronism Source (0 = Internal / 1 = External) */
		case eDeftMebSyncSourceId:
			vxDeftMebDefaults.pxGenSimulationParams->ucSyncSource = (alt_u8 ) uliDefaultValue;
			break;

		default:
			bStatus = FALSE;
			break;
	}

	return (bStatus);
}

bool bDeftSetFeeDefaultValues(alt_u8 ucFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {

		/* N-FEE RMAP Area Config Register 0, V Start Config Field */
		case eDeftNfeeRmapAreaConfigVStartId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiVStart                    = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 0, V End Config Field */
		case eDeftNfeeRmapAreaConfigVEndId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiVEnd                      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 1, Charge Injection Width Config Field */
		case eDeftNfeeRmapAreaConfigChargeInjectionWidthId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiChargeInjectionWidth      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 1, Charge Injection Gap Config Field */
		case eDeftNfeeRmapAreaConfigChargeInjectionGapId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiChargeInjectionGap        = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 2, Parallel Toi Period Config Field */
		case eDeftNfeeRmapAreaConfigParallelToiPeriodId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiParallelToiPeriod         = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 2, Parallel Clock Overlap Config Field */
		case eDeftNfeeRmapAreaConfigParallelClkOverlapId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiParallelClkOverlap        = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 2, CCD Readout Order Config Field (1st CCD) */
		case eDeftNfeeRmapAreaConfigCcdReadoutOrder1stCcdId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcdReadoutOrder1stCcd      = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 2, CCD Readout Order Config Field (2nd CCD) */
		case eDeftNfeeRmapAreaConfigCcdReadoutOrder2ndCcdId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcdReadoutOrder2ndCcd      = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 2, CCD Readout Order Config Field (3rd CCD) */
		case eDeftNfeeRmapAreaConfigCcdReadoutOrder3rdCcdId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcdReadoutOrder3rdCcd      = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 2, CCD Readout Order Config Field (4th CCD) */
		case eDeftNfeeRmapAreaConfigCcdReadoutOrder4thCcdId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcdReadoutOrder4thCcd      = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 3, N Final Dump Config Field */
		case eDeftNfeeRmapAreaConfigNFinalDumpId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiNFinalDump                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 3, H End Config Field */
		case eDeftNfeeRmapAreaConfigHEndId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiHEnd                      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 3, Charge Injection Enable Config Field */
		case eDeftNfeeRmapAreaConfigChargeInjectionEnId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bChargeInjectionEn           = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 3, Tri Level Clock Enable Config Field */
		case eDeftNfeeRmapAreaConfigTriLevelClkEnId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bTriLevelClkEn               = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 3, Image Clock Direction Config Field */
		case eDeftNfeeRmapAreaConfigImgClkDirId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bImgClkDir                   = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 3, Register Clock Direction Config Field */
		case eDeftNfeeRmapAreaConfigRegClkDirId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bRegClkDir                   = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 4, Data Packet Size Config Field */
		case eDeftNfeeRmapAreaConfigPacketSizeId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiPacketSize                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 4, Internal Sync Period Config Field */
		case eDeftNfeeRmapAreaConfigIntSyncPeriodId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiIntSyncPeriod             = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 5, Trap Pumping Dwell Counter Field */
		case eDeftNfeeRmapAreaConfigTrapPumpingDwellCounterId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliTrapPumpingDwellCounter   = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 5, Sync Source Selection Config Field */
		case eDeftNfeeRmapAreaConfigSyncSelId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bSyncSel                     = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 5, CCD Port Data Sensor Selection Config Field */
		case eDeftNfeeRmapAreaConfigSensorSelId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucSensorSel                  = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 5, Digitalise Enable Config Field */
		case eDeftNfeeRmapAreaConfigDigitiseEnId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bDigitiseEn                  = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 5, DG (Drain Gate) Enable Field */
		case eDeftNfeeRmapAreaConfigDGEnId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bDGEn                        = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 5, CCD Readout Enable Field */
		case eDeftNfeeRmapAreaConfigCcdReadEnId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bCcdReadEn                   = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 6, CCD 1 Window List Pointer Config Field */
		case eDeftNfeeRmapAreaConfigCcd1WinListPtrId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliCcd1WinListPtr            = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 7, CCD 1 Packet Order List Pointer Config Field */
		case eDeftNfeeRmapAreaConfigCcd1PktorderListPtrId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliCcd1PktorderListPtr       = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 8, CCD 1 Window List Length Config Field */
		case eDeftNfeeRmapAreaConfigCcd1WinListLengthId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd1WinListLength         = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 8, CCD 1 Window Size X Config Field */
		case eDeftNfeeRmapAreaConfigCcd1WinSizeXId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd1WinSizeX               = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 8, CCD 1 Window Size Y Config Field */
		case eDeftNfeeRmapAreaConfigCcd1WinSizeYId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd1WinSizeY               = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 8, Register 8 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg8ConfigReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg8ConfigReserved         = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 9, CCD 2 Window List Pointer Config Field */
		case eDeftNfeeRmapAreaConfigCcd2WinListPtrId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliCcd2WinListPtr            = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 10, CCD 2 Packet Order List Pointer Config Field */
		case eDeftNfeeRmapAreaConfigCcd2PktorderListPtrId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliCcd2PktorderListPtr       = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 11, CCD 2 Window List Length Config Field */
		case eDeftNfeeRmapAreaConfigCcd2WinListLengthId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd2WinListLength         = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 11, CCD 2 Window Size X Config Field */
		case eDeftNfeeRmapAreaConfigCcd2WinSizeXId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd2WinSizeX               = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 11, CCD 2 Window Size Y Config Field */
		case eDeftNfeeRmapAreaConfigCcd2WinSizeYId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd2WinSizeY               = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 11, Register 11 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg11ConfigReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg11ConfigReserved        = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 12, CCD 3 Window List Pointer Config Field */
		case eDeftNfeeRmapAreaConfigCcd3WinListPtrId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliCcd3WinListPtr            = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 13, CCD 3 Packet Order List Pointer Config Field */
		case eDeftNfeeRmapAreaConfigCcd3PktorderListPtrId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliCcd3PktorderListPtr       = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 14, CCD 3 Window List Length Config Field */
		case eDeftNfeeRmapAreaConfigCcd3WinListLengthId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd3WinListLength         = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 14, CCD 3 Window Size X Config Field */
		case eDeftNfeeRmapAreaConfigCcd3WinSizeXId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd3WinSizeX               = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 14, CCD 3 Window Size Y Config Field */
		case eDeftNfeeRmapAreaConfigCcd3WinSizeYId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd3WinSizeY               = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 14, Register 14 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg14ConfigReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg14ConfigReserved        = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 15, CCD 4 Window List Pointer Config Field */
		case eDeftNfeeRmapAreaConfigCcd4WinListPtrId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliCcd4WinListPtr            = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 16, CCD 4 Packet Order List Pointer Config Field */
		case eDeftNfeeRmapAreaConfigCcd4PktorderListPtrId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliCcd4PktorderListPtr       = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 17, CCD 4 Window List Length Config Field */
		case eDeftNfeeRmapAreaConfigCcd4WinListLengthId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd4WinListLength         = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 17, CCD 4 Window Size X Config Field */
		case eDeftNfeeRmapAreaConfigCcd4WinSizeXId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd4WinSizeX               = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 17, CCD 4 Window Size Y Config Field */
		case eDeftNfeeRmapAreaConfigCcd4WinSizeYId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd4WinSizeY               = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 17, Register 17 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg17ConfigReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg17ConfigReserved        = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 18, CCD Vod Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcdVodConfigId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcdVodConfig              = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 18, CCD 1 Vrd Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcd1VrdConfigId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd1VrdConfig             = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 18, CCD 2 Vrd Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcd2VrdConfig0Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd2VrdConfig0             = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 19, CCD 2 Vrd Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcd2VrdConfig1Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcd2VrdConfig1             = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 19, CCD 3 Vrd Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcd3VrdConfigId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd3VrdConfig             = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 19, CCD 4 Vrd Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcd4VrdConfigId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd4VrdConfig             = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 19, CCD Vgd Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcdVgdConfig0Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcdVgdConfig0              = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 20, CCD Vgd Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcdVgdConfig1Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcdVgdConfig1              = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 20, CCD Vog Configurion Config Field */
		case eDeftNfeeRmapAreaConfigCcdVogConfigId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcdVogConfig              = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 20, CCD Ig High Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcdIgHiConfigId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcdIgHiConfig             = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 21, CCD Ig Low Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcdIgLoConfigId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcdIgLoConfig             = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 21, CCD Mode Configuration Config Field */
		case eDeftNfeeRmapAreaConfigCcdModeConfigId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCcdModeConfig              = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 21, Register 21 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg21ConfigReserved1Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg21ConfigReserved1       = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 22, Register 22 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg22ConfigReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.uliReg22ConfigReserved       = (alt_u32) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 23, CCD 1 Last E Packet Field */
		case eDeftNfeeRmapAreaConfigCcd1LastEPacketId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd1LastEPacket           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 23, CCD 1 Last F Packet Field */
		case eDeftNfeeRmapAreaConfigCcd1LastFPacketId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd1LastFPacket           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 23, CCD 2 Last E Packet Field */
		case eDeftNfeeRmapAreaConfigCcd2LastEPacketId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd2LastEPacket           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 23, Register 23 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg23ConfigReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg23ConfigReserved        = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 24, CCD 2 Last F Packet Field */
		case eDeftNfeeRmapAreaConfigCcd2LastFPacketId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd2LastFPacket           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 24, CCD 3 Last E Packet Field */
		case eDeftNfeeRmapAreaConfigCcd3LastEPacketId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd3LastEPacket           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 24, CCD 3 Last F Packet Field */
		case eDeftNfeeRmapAreaConfigCcd3LastFPacketId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd3LastFPacket           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 24, Register 24 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg24ConfigReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg24ConfigReserved        = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 25, CCD 4 Last E Packet Field */
		case eDeftNfeeRmapAreaConfigCcd4LastEPacketId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd4LastEPacket           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 25, CCD 4 Last F Packet Field */
		case eDeftNfeeRmapAreaConfigCcd4LastFPacketId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiCcd4LastFPacket           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 25, Surface Inversion Counter Field */
		case eDeftNfeeRmapAreaConfigSurfaceInversionCounterId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiSurfaceInversionCounter   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 25, Register 25 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg25ConfigReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg25ConfigReserved        = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 26, Readout Pause Counter Field */
		case eDeftNfeeRmapAreaConfigReadoutPauseCounterId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiReadoutPauseCounter       = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 26, Trap Pumping Shuffle Counter Field */
		case eDeftNfeeRmapAreaConfigTrapPumpingShuffleCounterId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.usiTrapPumpingShuffleCounter = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 5, Conversion Delay Value */
		case eDeftNfeeRmapAreaConfigConvDlyId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucConvDly                    = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 5, High Precison Housekeep Enable Field */
		case eDeftNfeeRmapAreaConfigHighPrecisionHkEnId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.bHighPrecisionHkEn           = (bool) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 21, Trk Hld High Configuration Config Field */
		case eDeftNfeeRmapAreaConfigTrkHldHiId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucTrkHldHi                   = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 21, Trk Hld Low Configuration Config Field */
		case eDeftNfeeRmapAreaConfigTrkHldLoId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucTrkHldLo                   = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 21, Register 21 Configuration Reserved */
		case eDeftNfeeRmapAreaConfigReg21ConfigReserved0Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucReg21ConfigReserved0       = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 22, R Config 1 Field */
		case eDeftNfeeRmapAreaConfigRCfg1Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucRCfg1                      = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 22, R Config 2 Field */
		case eDeftNfeeRmapAreaConfigRCfg2Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucRCfg2                      = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area Config Register 22, Cdsclp Lo Field */
		case eDeftNfeeRmapAreaConfigCdsclpLoId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaConfig.ucCdsclpLo                   = (alt_u8) uliDefaultValue;
			break;

		/* N-FEE RMAP Area HK Register 0, TOU Sense 1 HK Field */
		case eDeftNfeeRmapAreaHkTouSense1Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiTouSense1                 = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 0, TOU Sense 2 HK Field */
		case eDeftNfeeRmapAreaHkTouSense2Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiTouSense2                 = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 1, TOU Sense 3 HK Field */
		case eDeftNfeeRmapAreaHkTouSense3Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiTouSense3                 = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 1, TOU Sense 4 HK Field */
		case eDeftNfeeRmapAreaHkTouSense4Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiTouSense4                 = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 2, TOU Sense 5 HK Field */
		case eDeftNfeeRmapAreaHkTouSense5Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiTouSense5                 = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 2, TOU Sense 6 HK Field */
		case eDeftNfeeRmapAreaHkTouSense6Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiTouSense6                 = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 3, CCD 1 TS HK Field */
		case eDeftNfeeRmapAreaHkCcd1TsId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd1Ts                    = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 3, CCD 2 TS HK Field */
		case eDeftNfeeRmapAreaHkCcd2TsId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd2Ts                    = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 4, CCD 3 TS HK Field */
		case eDeftNfeeRmapAreaHkCcd3TsId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd3Ts                    = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 4, CCD 4 TS HK Field */
		case eDeftNfeeRmapAreaHkCcd4TsId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd4Ts                    = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 5, PRT 1 HK Field */
		case eDeftNfeeRmapAreaHkPrt1Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiPrt1                      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 5, PRT 2 HK Field */
		case eDeftNfeeRmapAreaHkPrt2Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiPrt2                      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 6, PRT 3 HK Field */
		case eDeftNfeeRmapAreaHkPrt3Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiPrt3                      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 6, PRT 4 HK Field */
		case eDeftNfeeRmapAreaHkPrt4Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiPrt4                      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 7, PRT 5 HK Field */
		case eDeftNfeeRmapAreaHkPrt5Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiPrt5                      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 7, Zero Diff Amplifier HK Field */
		case eDeftNfeeRmapAreaHkZeroDiffAmpId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiZeroDiffAmp               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 8, CCD 1 Vod Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd1VodMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd1VodMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 8, CCD 1 Vog Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd1VogMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd1VogMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 9, CCD 1 Vrd Monitor E HK Field */
		case eDeftNfeeRmapAreaHkCcd1VrdMonEId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd1VrdMonE               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 9, CCD 2 Vod Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd2VodMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd2VodMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 10, CCD 2 Vog Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd2VogMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd2VogMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 10, CCD 2 Vrd Monitor E HK Field */
		case eDeftNfeeRmapAreaHkCcd2VrdMonEId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd2VrdMonE               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 11, CCD 3 Vod Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd3VodMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd3VodMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 11, CCD 3 Vog Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd3VogMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd3VogMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 12, CCD 3 Vrd Monitor E HK Field */
		case eDeftNfeeRmapAreaHkCcd3VrdMonEId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd3VrdMonE               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 12, CCD 4 Vod Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd4VodMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd4VodMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 13, CCD 4 Vog Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd4VogMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd4VogMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 13, CCD 4 Vrd Monitor E HK Field */
		case eDeftNfeeRmapAreaHkCcd4VrdMonEId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd4VrdMonE               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 14, V CCD HK Field */
		case eDeftNfeeRmapAreaHkVccdId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVccd                      = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 14, VRClock Monitor HK Field */
		case eDeftNfeeRmapAreaHkVrclkMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVrclkMon                  = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 15, VIClock HK Field */
		case eDeftNfeeRmapAreaHkViclkId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiViclk                     = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 15, VRClock Low HK Field */
		case eDeftNfeeRmapAreaHkVrclkLowId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVrclkLow                  = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 16, 5Vb Positive Monitor HK Field */
		case eDeftNfeeRmapAreaHk5vbPosMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usi5vbPosMon                 = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 16, 5Vb Negative Monitor HK Field */
		case eDeftNfeeRmapAreaHk5vbNegMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usi5vbNegMon                 = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 17, 3V3b Monitor HK Field */
		case eDeftNfeeRmapAreaHk3v3bMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usi3v3bMon                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 17, 2V5a Monitor HK Field */
		case eDeftNfeeRmapAreaHk2v5aMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usi2v5aMon                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 18, 3V3d Monitor HK Field */
		case eDeftNfeeRmapAreaHk3v3dMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usi3v3dMon                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 18, 2V5d Monitor HK Field */
		case eDeftNfeeRmapAreaHk2v5dMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usi2v5dMon                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 19, 1V5d Monitor HK Field */
		case eDeftNfeeRmapAreaHk1v5dMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usi1v5dMon                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 19, 5Vref Monitor HK Field */
		case eDeftNfeeRmapAreaHk5vrefMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usi5vrefMon                  = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 20, Vccd Positive Raw HK Field */
		case eDeftNfeeRmapAreaHkVccdPosRawId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVccdPosRaw                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 20, Vclk Positive Raw HK Field */
		case eDeftNfeeRmapAreaHkVclkPosRawId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVclkPosRaw                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 21, Van 1 Positive Raw HK Field */
		case eDeftNfeeRmapAreaHkVan1PosRawId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVan1PosRaw                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 21, Van 3 Negative Monitor HK Field */
		case eDeftNfeeRmapAreaHkVan3NegMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVan3NegMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 22, Van Positive Raw HK Field */
		case eDeftNfeeRmapAreaHkVan2PosRawId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVan2PosRaw                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 22, Vdig Raw HK Field */
		case eDeftNfeeRmapAreaHkVdigRawId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVdigRaw                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 23, Vdig Raw 2 HK Field */
		case eDeftNfeeRmapAreaHkVdigRaw2Id:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiVdigRaw2                  = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 23, VIClock Low HK Field */
		case eDeftNfeeRmapAreaHkViclkLowId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiViclkLow                  = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 24, CCD 1 Vrd Monitor F HK Field */
		case eDeftNfeeRmapAreaHkCcd1VrdMonFId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd1VrdMonF               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 24, CCD 1 Vdd Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd1VddMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd1VddMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 25, CCD 1 Vgd Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd1VgdMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd1VgdMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 25, CCD 2 Vrd Monitor F HK Field */
		case eDeftNfeeRmapAreaHkCcd2VrdMonFId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd2VrdMonF               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 26, CCD 2 Vdd Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd2VddMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd2VddMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 26, CCD 2 Vgd Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd2VgdMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd2VgdMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 27, CCD 3 Vrd Monitor F HK Field */
		case eDeftNfeeRmapAreaHkCcd3VrdMonFId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd3VrdMonF               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 27, CCD 3 Vdd Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd3VddMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd3VddMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 28, CCD 3 Vgd Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd3VgdMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd3VgdMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 28, CCD 4 Vrd Monitor F HK Field */
		case eDeftNfeeRmapAreaHkCcd4VrdMonFId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd4VrdMonF               = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 29, CCD 4 Vdd Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd4VddMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd4VddMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 29, CCD 4 Vgd Monitor HK Field */
		case eDeftNfeeRmapAreaHkCcd4VgdMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiCcd4VgdMon                = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 30, Ig High Monitor HK Field */
		case eDeftNfeeRmapAreaHkIgHiMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiIgHiMon                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 30, Ig Low Monitor HK Field */
		case eDeftNfeeRmapAreaHkIgLoMonId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiIgLoMon                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 31, Tsense A HK Field */
		case eDeftNfeeRmapAreaHkTsenseAId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiTsenseA                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 31, Tsense B HK Field */
		case eDeftNfeeRmapAreaHkTsenseBId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiTsenseB                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 32, SpW Status: SpaceWire Status Reserved */
		case eDeftNfeeRmapAreaHkSpwStatusSpwStatusReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.ucSpwStatusSpwStatusReserved = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 32, Register 32 HK Reserved */
		case eDeftNfeeRmapAreaHkReg32HkReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.ucReg32HkReserved            = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 33, Register 33 HK Reserved */
		case eDeftNfeeRmapAreaHkReg33HkReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiReg33HkReserved           = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 33, Operational Mode HK Field */
		case eDeftNfeeRmapAreaHkOpModeId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.ucOpMode                     = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 35, FPGA Minor Version Field */
		case eDeftNfeeRmapAreaHkFpgaMinorVersionId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.ucFpgaMinorVersion           = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 35, FPGA Major Version Field */
		case eDeftNfeeRmapAreaHkFpgaMajorVersionId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.ucFpgaMajorVersion           = (alt_u8) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 35, Board ID Field */
		case eDeftNfeeRmapAreaHkBoardIdId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiBoardId                   = (alt_u16) uliDefaultValue;
			break;
		/* N-FEE RMAP Area HK Register 35, Register 35 HK Reserved HK Field */
		case eDeftNfeeRmapAreaHkReg35HkReservedId:
			vxDeftFeeDefaults[ucFee].xRmapMemAreaHk.usiReg35HkReserved           = (alt_u16) uliDefaultValue;
			break;

		/* SpaceWire link set as Link Start */
		case eDeftSpwSpwLinkStartId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->bSpwLinkStart           = (bool) uliDefaultValue;
			break;
		/* SpaceWire link set as Link Auto-Start */
		case eDeftSpwSpwLinkAutostartId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->bSpwLinkAutostart       = (bool) uliDefaultValue;
			break;
		/* SpaceWire Link Speed [Mhz] */
		case eDeftSpwSpwLinkSpeedId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucSpwLinkSpeed          = (alt_u8) uliDefaultValue;
			break;
		/* Timecode Transmission Enable */
		case eDeftSpwTimeCodeTransmissionEnId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->bTimeCodeTransmissionEn = (bool) uliDefaultValue;
			break;
		/* RMAP Logical Address */
		case eDeftSpwLogicalAddrId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucLogicalAddr           = (alt_u8) uliDefaultValue;
			break;
		/* RMAP Key */
		case eDeftSpwRmapKeyId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucRmapKey               = (alt_u8) uliDefaultValue;
			break;
		/* Data Packet Protocol ID */
		case eDeftSpwDataProtIdId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucDataProtId            = (alt_u8) uliDefaultValue;
			break;
		/* Data Packet Target Logical Address */
		case eDeftSpwDpuLogicalAddrId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucDpuLogicalAddr        = (alt_u8) uliDefaultValue;
			break;

		default:
			bStatus = FALSE;
			break;
	}

	return (bStatus);
}

bool bDeftSetNucDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {
	/* TcpServerPort */
	case eDeftEthTcpServerPortId:
		vxDeftNucDefaults.pxEthInterfaceParams->siPortPUS = (alt_u16) uliDefaultValue;
		break;
	/* PUS TCP Enable DHCP (dynamic) IP (all IPv4 fields below will be ignored if this is true) */
	case eDeftEthDhcpV4EnableId:
		vxDeftNucDefaults.pxEthInterfaceParams->bDHCP = (bool) uliDefaultValue;
		break;
	/* PUS TCP address IPv4 uint32 representation (Example is 192.168.17.10) */
	case eDeftEthIpV4AddressId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucIP[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucIP[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucIP[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucIP[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PUS TCP subnet IPv4 uint32 representation (Example is 255.255.255.0) */
	case eDeftEthIpV4SubnetId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucSubNet[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucSubNet[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucSubNet[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucSubNet[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PUS TCP gateway IPv4 uint32 representation (Example is 192.168.17.1) */
	case eDeftEthIpV4GatewayId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucGTW[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucGTW[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucGTW[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucGTW[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PUS TCP DNS IPv4 uint32 representation (Example is 1.1.1.1) */
	case eDeftEthIpV4DNSId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucDNS[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucDNS[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucDNS[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucDNS[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PUS HP_PID identification (>127 to disable verification) */
	case eDeftEthPusHpPidId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucPID = (alt_u8) uliDefaultValue;
		break;
	/* PUS HP_PCAT identification (> 15 to disable verification) */
	case eDeftEthPusHpPcatId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucPCAT = (alt_u8) uliDefaultValue;
		break;
	/* PUS Default Encapsulation Protocol (0 = None, 1 = EDEN) */
	case eDeftEthPusEncapId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucEncap = (alt_u8) uliDefaultValue;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return (bStatus);
}

bool bDeftSetDefaultValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = FALSE;

	if (0 == usiMebFee) { /* MEB or NUC Default */

		if (((DEFT_MEB_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_FEE_DEFS_ID_LOWER_LIM > usiDefaultId)) || (DEFT_NUC_DEFS_ID_RESERVED == usiDefaultId)) {

			/* Default ID is a MEB Default */
			bStatus = bDeftSetMebDefaultValues(usiDefaultId, uliDefaultValue);

		} else if (DEFT_NUC_DEFS_ID_LOWER_LIM <= usiDefaultId) {

			/* Default ID is a NUC Default */
			bStatus = bDeftSetNucDefaultValues(usiDefaultId, uliDefaultValue);

		}

	} else if ((N_OF_NFEE + 1) >= usiMebFee) { /* FEE Default */

		if ((DEFT_FEE_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_NUC_DEFS_ID_LOWER_LIM > usiDefaultId)) {

			/* Default ID is a FEE Default */
			bStatus = bDeftSetFeeDefaultValues(usiMebFee - 1, usiDefaultId, uliDefaultValue);

		}

	}

	if (TRUE == bStatus) {
		vuliDeftReceivedDefaultsQtd++;
	}

	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
