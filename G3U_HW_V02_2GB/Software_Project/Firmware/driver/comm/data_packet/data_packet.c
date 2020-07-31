/*
 * data_packet.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "data_packet.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//const alt_u32 culiDpktLeftCbufAddr[6] = {
//		0xF4000000,
//		0xF5000000,
//		0xF6000000,
//		0xF7000000,
//		0xF8000000,
//		0xF9000000
//};
//const alt_u32 culiDpktRightCbufAddr[6] = {
//		0xFA000000,
//		0xFB000000,
//		0xFC000000,
//		0xFD000000,
//		0xFE000000,
//		0xFF000000
//};

const alt_u32 culiDpktLeftCbufAddr[6] = {
		0x74000000,
		0x75000000,
		0x76000000,
		0x77000000,
		0x78000000,
		0x79000000
};
const alt_u32 culiDpktRightCbufAddr[6] = {
		0x7A000000,
		0x7B000000,
		0x7C000000,
		0x7D000000,
		0x7E000000,
		0x7F000000
};
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bDpktSetPacketConfig(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDataPacketConfig = pxDpktCh->xDpktDataPacketConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketConfig(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketConfig = vpxCommChannel->xDataPacket.xDpktDataPacketConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetPacketErrors(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDataPacketErrors = pxDpktCh->xDpktDataPacketErrors;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketErrors(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketErrors = vpxCommChannel->xDataPacket.xDpktDataPacketErrors;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketHeader(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketHeader = vpxCommChannel->xDataPacket.xDpktDataPacketHeader;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktPixelDelay = pxDpktCh->xDpktPixelDelay;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktPixelDelay = vpxCommChannel->xDataPacket.xDpktPixelDelay;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetPxCBufferControl(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktPxCBufferControl = pxDpktCh->xDpktPxCBufferControl;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetPxCBufferControl(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktPxCBufferControl = vpxCommChannel->xDataPacket.xDpktPxCBufferControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktConfigPxCBuffer(alt_u8 ucCommCh, alt_u8 ucMemoryId){
//	alt_u32 uliBufSizeBytes = 256;
	alt_u32 uliBufSizeBytes = 2*1024*1024;
//bool bDpktConfigPxCBuffer(alt_u8 ucCommCh, alt_u8 ucMemoryId, alt_u32 uliBufSizeBytes){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel;

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

//	if ((bValidCh) && (uliWindowingAreaAddr < DDR2_M1_MEMORY_SIZE)) {
	if (bValidCh) {

		switch (ucMemoryId) {
		case eDdr2Memory1:
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliLeftPxCBufInitAddrHighDword = 0x00000000;
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliLeftPxCBufInitAddrLowDword = DDR2_M1_MEMORY_BASE + culiDpktLeftCbufAddr[ucCommCh];
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliLeftPxCBufSizeBytes = uliBufSizeBytes;
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliRightPxCBufInitAddrHighDword = 0x00000000;
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliRightPxCBufInitAddrLowDword = DDR2_M1_MEMORY_BASE + culiDpktRightCbufAddr[ucCommCh];
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliRightPxCBufSizeBytes = uliBufSizeBytes;
			bStatus = TRUE;
			break;
		case eDdr2Memory2:
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliLeftPxCBufInitAddrHighDword = 0x00000000;
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliLeftPxCBufInitAddrLowDword = DDR2_M2_MEMORY_BASE + culiDpktLeftCbufAddr[ucCommCh];
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliLeftPxCBufSizeBytes = uliBufSizeBytes;
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliRightPxCBufInitAddrHighDword = 0x00000000;
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliRightPxCBufInitAddrLowDword = DDR2_M2_MEMORY_BASE + culiDpktRightCbufAddr[ucCommCh];
			vpxCommChannel->xDataPacket.xDpktPxCBufferControl.uliRightPxCBufSizeBytes = uliBufSizeBytes;
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}

	}

	return (bStatus);
}

bool bDpktSetSpacewireErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktSpacewireErrInj = pxDpktCh->xDpktSpacewireErrInj;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetSpacewireErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktSpacewireErrInj = vpxCommChannel->xDataPacket.xDpktSpacewireErrInj;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetTransmissionErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktTransmissionErrInj = pxDpktCh->xDpktTransmissionErrInj;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetTransmissionErrInj(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktTransmissionErrInj = vpxCommChannel->xDataPacket.xDpktTransmissionErrInj;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetWindowingParams(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktWindowingParam = pxDpktCh->xDpktWindowingParam;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetWindowingParams(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktWindowingParam = vpxCommChannel->xDataPacket.xDpktWindowingParam;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktInitCh(TDpktChannel *pxDpktCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bDpktGetPacketConfig(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPacketErrors(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPacketHeader(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPixelDelay(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPxCBufferControl(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetSpacewireErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetTransmissionErrInj(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetWindowingParams(pxDpktCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}

/*
 * Return the necessary delay value for a
 * Pixel Delay period in uliPeriodNs ns.
 */
alt_u32 uliPxDelayCalcPeriodNs(alt_u32 uliPeriodNs) {

	/*
	 * Delay = PxDelay * ClkCycles@100MHz
	 * PxDelay = Delay / ClkCycles@100MHz
	 *
	 * ClkCycles@100MHz = 10 ns
	 *
	 * Delay[ns] / 10 = Delay[ns] * 1e-1
	 * PxDelay = Delay[ns] * 1e-1
	 */

	alt_u32 uliPxDelay;
	//    uliPxDelay = (alt_u32) ((float) uliPeriodNs * 1e-1);
	uliPxDelay = (alt_u32) (uliPeriodNs / (alt_u32) 10);

	return uliPxDelay;
}

alt_u32 uliPxDelayCalcPeriodMs(alt_u32 uliPeriodMs) {

	/*
	 * Delay = PxDelay * ClkCycles@100MHz
	 * PxDelay = Delay / ClkCycles@100MHz
	 *
	 * ClkCycles@100MHz = 10 ns = 1e-5 ms
	 *
	 * Delay[ms] / 1e-5 = Delay[ms] * 1e+5
	 * PxDelay = Delay[ms] * 1e+5
	 */

	alt_u32 uliPxDelay;
	//    uliPxDelay = (alt_u32) ((float) uliPeriodMs * 1e+5);
	uliPxDelay = (alt_u32) (uliPeriodMs * (alt_u32) 100000);

	return uliPxDelay;
}

//! [public functions]

//! [private functions]
//! [private functions]
