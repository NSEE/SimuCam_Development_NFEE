/*
 * spw_controller.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "spw_controller.h"

//! [private function prototypes]
static void vSpwcWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliSpwcReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
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
	alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (pxSpwcCh->xLinkConfig.bAutostart) {
			uliReg |= COMM_CTRL_LINK_AUTOSTART_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_AUTOSTART_MSK);
		}
		if (pxSpwcCh->xLinkConfig.bStart) {
			uliReg |= COMM_CTRL_LINK_START_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_START_MSK);
		}
		if (pxSpwcCh->xLinkConfig.bDisconnect) {
			uliReg |= COMM_CTRL_LINK_DISCONNECT_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_DISCONNECT_MSK);
		}

		vSpwcWriteReg(pxSpwcCh->puliSpwcChAddr, COMM_WINDOW_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLink(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (uliReg & COMM_CTRL_LINK_AUTOSTART_MSK) {
			pxSpwcCh->xLinkConfig.bAutostart = TRUE;
		} else {
			pxSpwcCh->xLinkConfig.bAutostart = FALSE;
		}
		if (uliReg & COMM_CTRL_LINK_START_MSK) {
			pxSpwcCh->xLinkConfig.bStart = TRUE;
		} else {
			pxSpwcCh->xLinkConfig.bStart = FALSE;
		}
		if (uliReg & COMM_CTRL_LINK_DISCONNECT_MSK) {
			pxSpwcCh->xLinkConfig.bDisconnect = TRUE;
		} else {
			pxSpwcCh->xLinkConfig.bDisconnect = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr,
		COMM_WINDOW_STAT_REG_OFFSET);

		if (uliReg & COMM_STAT_LINK_DISC_ERR_MSK) {
			pxSpwcCh->xLinkError.bDisconnect = TRUE;
		} else {
			pxSpwcCh->xLinkError.bDisconnect = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_PAR_ERR_MSK) {
			pxSpwcCh->xLinkError.bParity = TRUE;
		} else {
			pxSpwcCh->xLinkError.bParity = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_ESC_ERR_MSK) {
			pxSpwcCh->xLinkError.bEscape = TRUE;
		} else {
			pxSpwcCh->xLinkError.bEscape = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_CRED_ERR_MSK) {
			pxSpwcCh->xLinkError.bCredit = TRUE;
		} else {
			pxSpwcCh->xLinkError.bCredit = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr,
		COMM_WINDOW_STAT_REG_OFFSET);

		if (uliReg & COMM_STAT_LINK_STARTED_MSK) {
			pxSpwcCh->xLinkStatus.bStarted = TRUE;
		} else {
			pxSpwcCh->xLinkStatus.bStarted = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_CONNECTING_MSK) {
			pxSpwcCh->xLinkStatus.bConnecting = TRUE;
		} else {
			pxSpwcCh->xLinkStatus.bConnecting = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_RUNNING_MSK) {
			pxSpwcCh->xLinkStatus.bRunning = TRUE;
		} else {
			pxSpwcCh->xLinkStatus.bRunning = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;

	if (pxSpwcCh != NULL) {
		bStatus = TRUE;

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
			break;
		case eCommSpwCh2:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
			break;
		case eCommSpwCh3:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
			break;
		case eCommSpwCh4:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
			break;
		case eCommSpwCh5:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
			break;
		case eCommSpwCh6:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
			break;
		case eCommSpwCh7:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
			break;
		case eCommSpwCh8:
			pxSpwcCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
			break;
		default:
			bStatus = FALSE;
			break;
		}

		if (bStatus) {
//			if (!bFeebGetWindowing(pxSpwcCh)) {
//				bStatus = FALSE;
//			}
			if (!bSpwcGetLink(pxSpwcCh)) {
				bStatus = FALSE;
			}
			if (!bSpwcGetLinkError(pxSpwcCh)) {
				bStatus = FALSE;
			}
			if (!bSpwcGetLinkStatus(pxSpwcCh)) {
				bStatus = FALSE;
			}
//			if (!bCommGetTimecodeRx(pxSpwcCh)) {
//				bStatus = FALSE;
//			}
//			if (!bCommGetTimecodeTx(pxSpwcCh)) {
//				bStatus = FALSE;
//			}
//			if (!bFeebGetIrqControl(pxSpwcCh)) {
//				bStatus = FALSE;
//			}
//			if (!bFeebGetIrqFlags(pxSpwcCh)) {
//				bStatus = FALSE;
//			}
//			if (!bFeebGetBuffersStatus(pxSpwcCh)) {
//				bStatus = FALSE;
//			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
static void vSpwcWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliSpwcReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
//! [private functions]

