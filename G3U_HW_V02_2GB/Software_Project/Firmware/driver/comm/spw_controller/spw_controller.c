/*
 * spw_controller.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "spw_controller.h"

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
bool bSpwcSetLink(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TSpwcChannel *vpxSpwcChannel;

	if (pxSpwcCh != NULL) {

		vpxSpwcChannel = (TSpwcChannel *)((alt_u32)pxSpwcCh + COMM_SPWC_BASE_ADDR_OFST);

		vpxSpwcChannel->xLinkConfig = pxSpwcCh->xLinkConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetLink(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TSpwcChannel *vpxSpwcChannel;

	if (pxSpwcCh != NULL) {

		vpxSpwcChannel = (TSpwcChannel *)((alt_u32)pxSpwcCh + COMM_SPWC_BASE_ADDR_OFST);

		pxSpwcCh->xLinkConfig = vpxSpwcChannel->xLinkConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TSpwcChannel *vpxSpwcChannel;

	if (pxSpwcCh != NULL) {

		vpxSpwcChannel = (TSpwcChannel *)((alt_u32)pxSpwcCh + COMM_SPWC_BASE_ADDR_OFST);

		pxSpwcCh->xLinkError = vpxSpwcChannel->xLinkError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TSpwcChannel *vpxSpwcChannel;

	if (pxSpwcCh != NULL) {

		vpxSpwcChannel = (TSpwcChannel *)((alt_u32)pxSpwcCh + COMM_SPWC_BASE_ADDR_OFST);

		pxSpwcCh->xLinkStatus = vpxSpwcChannel->xLinkStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetTimecode(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TSpwcChannel *vpxSpwcChannel;

	if (pxSpwcCh != NULL) {

		vpxSpwcChannel = (TSpwcChannel *)((alt_u32)pxSpwcCh + COMM_SPWC_BASE_ADDR_OFST);

		pxSpwcCh->xTimecode = vpxSpwcChannel->xTimecode;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcClearTimecode(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TSpwcChannel *vpxSpwcChannel;

	if (pxSpwcCh != NULL) {

		vpxSpwcChannel = (TSpwcChannel *)((alt_u32)pxSpwcCh + COMM_SPWC_BASE_ADDR_OFST);

		vpxSpwcChannel->xTimecode.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcEnableTimecode(TSpwcChannel *pxSpwcCh, bool bEnable) {
	bool bStatus = FALSE;
	volatile TSpwcChannel *vpxSpwcChannel;

	if (pxSpwcCh != NULL) {

		vpxSpwcChannel = (TSpwcChannel *)((alt_u32)pxSpwcCh + COMM_SPWC_BASE_ADDR_OFST);

		vpxSpwcChannel->xTimecode.bEnable = bEnable;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	alt_u32 *uliCommChBaseAddr;

	if (pxSpwcCh != NULL) {

		uliCommChBaseAddr = (alt_u32 *)((alt_u32)pxSpwcCh + COMM_SPWC_BASE_ADDR_OFST);

		switch (ucCommCh) {
		case eCommSpwCh1:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_1_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_2_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_3_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_4_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_5_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_6_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh7:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_7_BASE_ADDR;
			bValidCh = TRUE;
			break;
		case eCommSpwCh8:
			*uliCommChBaseAddr = (alt_u32) COMM_CHANNEL_8_BASE_ADDR;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bSpwcGetLink(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetLinkError(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetLinkStatus(pxSpwcCh)) {
				bInitFail = TRUE;
			}
			if (!bSpwcGetTimecode(pxSpwcCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
//! [private functions]

