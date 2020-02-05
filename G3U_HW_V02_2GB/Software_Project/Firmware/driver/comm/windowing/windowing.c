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
bool bWindCopyWindowingParam(alt_u32 uliWindowingParamAddr, alt_u8 ucMemoryId, alt_u8 ucCommCh){
	bool bStatus = FALSE;
	bool bValidMem = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;
	volatile TDpktWindowingParam *vpxWindowingParam = NULL;

	bValidMem = bDdr2SwitchMemory(ucMemoryId);

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *)uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *)uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *)uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *)uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *)uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *)uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh7:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *)uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	case eCommSpwCh8:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
		vpxWindowingParam = (TDpktWindowingParam *)uliWindowingParamAddr;
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if ((bValidMem) && (bValidCh)) {
		vpxCommChannel->xDataPacket.xDpktWindowingParam = *vpxWindowingParam;
		bStatus = TRUE;

//#if DEBUG_ON
//if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
//		fprintf(fp, "\nChannel %d Windowing Parameters:\n", ucCommCh);
//		fprintf(fp, "xDpktWindowingParam.xPacketOrderList = 0x");
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList15);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList14);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList13);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList12);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList11);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList10);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList9);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList8);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList7);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList6);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList5);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList4);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList3);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList2);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList1);
//		fprintf(fp, "%08lX", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliPacketOrderList0);
//		fprintf(fp, "\n");
//		fprintf(fp, "xDpktWindowingParam.uliLastEPacket = %lu \n", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliLastEPacket);
//		fprintf(fp, "xDpktWindowingParam.uliLastFPacket = %lu \n", vpxCommChannel->xDataPacket.xDpktWindowingParam.uliLastFPacket);
//		fprintf(fp, "\n");
//}
//#endif

	}

	return bStatus;
}
//! [public functions]

//! [private functions]
//! [private functions]
