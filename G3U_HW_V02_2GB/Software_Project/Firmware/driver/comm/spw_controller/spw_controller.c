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
	volatile TCommChannel *vpxCommChannel;

	if (pxSpwcCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		vpxCommChannel->xSpacewire.xSpwcLinkConfig = pxSpwcCh->xSpwcLinkConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetLink(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxSpwcCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcLinkConfig = vpxCommChannel->xSpacewire.xSpwcLinkConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxSpwcCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcLinkError = vpxCommChannel->xSpacewire.xSpwcLinkError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxSpwcCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcLinkStatus = vpxCommChannel->xSpacewire.xSpwcLinkStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcGetTimecode(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxSpwcCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		pxSpwcCh->xSpwcTimecodeStatus = vpxCommChannel->xSpacewire.xSpwcTimecodeStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcClearTimecode(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxSpwcCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		vpxCommChannel->xSpacewire.xSpwcTimecodeConfig.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcEnableTimecode(TSpwcChannel *pxSpwcCh, bool bEnable) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxSpwcCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr);

		vpxCommChannel->xSpacewire.xSpwcTimecodeConfig.bEnable = bEnable;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxSpwcCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh5:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
			vpxCommChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_5_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh6:
			pxSpwcCh->xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
			vpxCommChannel->xSpacewire.xSpwcDevAddr.uliSpwcBaseAddr = (alt_u32) (COMM_CH_6_BASE_ADDR);
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

alt_u8 ucSpwcCalculateLinkDiv(alt_8 ucLinkSpeed) {
	alt_u8 ucLinkDiv;

	if (ucLinkSpeed < 100) {
		ucLinkDiv = (alt_u8) (round(200.0 / ((float) ucLinkSpeed))) - 1;
	} else {
		ucLinkDiv = 1;
	}

	return (ucLinkDiv);
}
//! [public functions]

//! [private functions]
//! [private functions]

