/*
 * windowing.c
 *
 *  Created on: 17 de jan de 2020
 *      Author: rfranca
 */

#include "windowing.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bWindCopyMebWindowingParam(alt_u32 uliWindowingParamAddr, alt_u8 ucMemoryId, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidMem = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;
	volatile TDpktWindowingParam *vpxWindowingParam = NULL;

	bValidMem = bDdr2SwitchMemory(ucMemoryId);

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *) uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *) uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *) uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *) uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *) uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *) uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if ((bValidMem) && (bValidCh) && (uliWindowingParamAddr < DDR2_M1_MEMORY_SIZE)) {
		vpxCommChannel->xDataPacket.xDpktWindowingParam = *vpxWindowingParam;
		bStatus = TRUE;

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
//		fprintf(fp, "\n");
			fprintf(fp, "Channel %d Windowing Parameters:\n", ucCommCh);
			fprintf(fp, "xDpktWindowingParam.xPacketOrderList = 0x");
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList15);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList14);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList13);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList12);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList11);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList10);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList9);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList8);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList7);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList6);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList5);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList4);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList3);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList2);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList1);
			fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList0);
			fprintf(fp, "\n");
			fprintf(fp, "xDpktWindowingParam.uliLastEPacket = %lu \n", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliLastEPacket);
			fprintf(fp, "xDpktWindowingParam.uliLastFPacket = %lu \n", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliLastFPacket);
//		fprintf(fp, "\n");
		}
#endif

	}

	return (bStatus);
}

bool bWindCopyCcdXWindowingConfig(alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;
	volatile TFtdiModule *vpxFtdiModule = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {

		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListPrt = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd1WinListPtr
				- COMM_WINDOING_RMAP_AREA_OFST);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1PacketOrderListPrt = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd1PktorderListPtr
				- COMM_WINDOING_RMAP_AREA_OFST);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListLength = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd1WinListLength);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowsSizeX = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd1WinSizeX);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowsSizeY = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd1WinSizeY);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1LastEPacket = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd1LastEPacket);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1LastFPacket = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd1LastFPacket);

		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowListPrt = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd2WinListPtr
				- COMM_WINDOING_RMAP_AREA_OFST);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2PacketOrderListPrt = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd2PktorderListPtr
				- COMM_WINDOING_RMAP_AREA_OFST);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowListLength = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd2WinListLength);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowsSizeX = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd2WinSizeX);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowsSizeY = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd2WinSizeY);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2LastEPacket = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd2LastEPacket);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2LastFPacket = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd2LastFPacket);

		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowListPrt = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd3WinListPtr
				- COMM_WINDOING_RMAP_AREA_OFST);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3PacketOrderListPrt = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd3PktorderListPtr
				- COMM_WINDOING_RMAP_AREA_OFST);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowListLength = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd3WinListLength);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowsSizeX = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd3WinSizeX);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowsSizeY = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd3WinSizeY);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3LastEPacket = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd3LastEPacket);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3LastFPacket = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd3LastFPacket);

		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowListPrt = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd4WinListPtr
				- COMM_WINDOING_RMAP_AREA_OFST);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4PacketOrderListPrt = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.uliCcd4PktorderListPtr
				- COMM_WINDOING_RMAP_AREA_OFST);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowListLength = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd4WinListLength);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowsSizeX = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd4WinSizeX);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowsSizeY = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.ucCcd4WinSizeY);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4LastEPacket = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd4LastEPacket);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4LastFPacket = (alt_u32) (vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig.usiCcd4LastFPacket);

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bWindClearWindowingArea(alt_u8 ucMemoryId, alt_u32 uliWindowingAreaAddr, alt_u32 uliWinAreaLengthBytes) {
	bool bStatus = FALSE;
	bool bValidMem = FALSE;
	alt_u32 *puliWindowingArea = NULL;
	alt_u32 uliWinLengthDwords = 0;
	alt_u32 uliAddrCnt = 0;

	bValidMem = bDdr2SwitchMemory(ucMemoryId);

	if ((bValidMem) && (uliWindowingAreaAddr < DDR2_M1_MEMORY_SIZE) && (uliWinAreaLengthBytes <= FTDI_WIN_AREA_PAYLOAD_SIZE)) {

		if (uliWinAreaLengthBytes % 4) {
			uliWinLengthDwords = (alt_u32) ((uliWinAreaLengthBytes / 4) + 1);
		} else {
			uliWinLengthDwords = (alt_u32) (uliWinAreaLengthBytes / 4);
		}

		puliWindowingArea = (alt_u32 *) uliWindowingAreaAddr;
		for (uliAddrCnt = 0; uliAddrCnt < uliWinLengthDwords; uliAddrCnt++) {
			*(puliWindowingArea + uliAddrCnt) = 0x00000000;
		}

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bWindSetWindowingAreaOffset(alt_u8 ucCommCh, alt_u8 ucMemoryId, alt_u32 uliWindowingAreaAddr) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if ((bValidCh) && (uliWindowingAreaAddr < DDR2_M1_MEMORY_SIZE)) {

		switch (ucMemoryId) {
		case DDR2_M1_ID:
			vpxCommChannel->xRmap.xRmapMemConfig.uliWinAreaOffHighDword = 0x00000000;
			vpxCommChannel->xRmap.xRmapMemConfig.uliWinAreaOffLowDword = DDR2_M1_MEMORY_BASE + uliWindowingAreaAddr;
			bStatus = TRUE;
			break;
		case DDR2_M2_ID:
			vpxCommChannel->xRmap.xRmapMemConfig.uliWinAreaOffHighDword = 0x00000000;
			vpxCommChannel->xRmap.xRmapMemConfig.uliWinAreaOffLowDword = DDR2_M2_MEMORY_BASE + uliWindowingAreaAddr;
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}

	}

	return (bStatus);
}
//! [public functions]

//! [private functions]
//! [private functions]
