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
			if (!bDpktGetPacketHeader(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPixelDelay(pxDpktCh)) {
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
 * ADC Pixel Delay period in uliPeriodNs ns.
 */
alt_u16 usiAdcPxDelayCalcPeriodNs(alt_u32 uliPeriodNs){

    /*
     * Delay = AdcPxDelay * ClkCycles@100MHz
     * AdcPxDelay = Delay / ClkCycles@100MHz
     *
     * ClkCycles@100MHz = 10 ns
     *
     * Delay[ns] / 10 = Delay[ns] * 1e-1
     * AdcPxDelay = Delay[ns] * 1e-1
     */

    alt_u16 usiAdcPxDelay;
    usiAdcPxDelay = (alt_u16) ((float) uliPeriodNs * 1e-1);
    if (6 < usiAdcPxDelay) {
        usiAdcPxDelay -= 6;
    } else {
        usiAdcPxDelay = 0;
    }

    return usiAdcPxDelay;
}

/*
 * Return the necessary delay value for a
 * Line Transfer Delay period in uliPeriodNs ns.
 */
alt_u16 usiLineTrDelayCalcPeriodNs(alt_u32 uliPeriodNs) {

	/*
	 * Delay = LineTrDelay * ClkCycles@10MHz
	 * LineTrDelay = Delay / ClkCycles@10MHz
	 *
	 * ClkCycles@10MHz = 100 ns
	 *
	 * Delay[ns] / 100 = Delay[ns] * 1e-2
	 * LineTrDelay = Delay[ns] * 1e-2
	 */

	alt_u16 LineTrDelay;
	LineTrDelay = (alt_u16) ((float) uliPeriodNs * 1e-2);

	return LineTrDelay;
}
//! [public functions]

//! [private functions]
//! [private functions]
