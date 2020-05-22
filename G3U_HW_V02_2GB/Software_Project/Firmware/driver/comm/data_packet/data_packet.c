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

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDataPacketConfig = pxDpktCh->xDpktDataPacketConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketConfig(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketConfig = vpxCommChannel->xDataPacket.xDpktDataPacketConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetPacketErrors(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDataPacketErrors = pxDpktCh->xDpktDataPacketErrors;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketErrors(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketErrors = vpxCommChannel->xDataPacket.xDpktDataPacketErrors;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketHeader(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketHeader = vpxCommChannel->xDataPacket.xDpktDataPacketHeader;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktPixelDelay = pxDpktCh->xDpktPixelDelay;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktPixelDelay = vpxCommChannel->xDataPacket.xDpktPixelDelay;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetErrorInjection(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktErrorInjection = pxDpktCh->xDpktErrorInjection;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetErrorInjection(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktErrorInjection = vpxCommChannel->xDataPacket.xDpktErrorInjection;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetWindowingParams(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktWindowingParam = pxDpktCh->xDpktWindowingParam;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetWindowingParams(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *)(pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

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
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_1_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_2_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_3_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_4_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_5_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_6_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh7:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_7_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_7_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh8:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_8_BASE_ADDR;
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_8_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) COMM_CHANNEL_8_BASE_ADDR;
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
			if (!bDpktGetErrorInjection(pxDpktCh)) {
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
alt_u32 uliPxDelayCalcPeriodNs(alt_u32 uliPeriodNs){

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
    uliPxDelay = (alt_u32) ( uliPeriodNs / (alt_u32)10 );

    return uliPxDelay;
}

alt_u32 uliPxDelayCalcPeriodMs(alt_u32 uliPeriodMs){

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
    uliPxDelay = (alt_u32) ( uliPeriodMs * (alt_u32)100000 );

    return uliPxDelay;
}

//! [public functions]

//! [private functions]
//! [private functions]
