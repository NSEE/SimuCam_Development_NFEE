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
bool bSpwcSetLink(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliSpwcReadReg(pxCh->puliSpwcChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (pxCh->xLinkConfig.bAutostart) {
			uliReg |= COMM_CTRL_LINK_AUTOSTART_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_AUTOSTART_MSK);
		}
		if (pxCh->xLinkConfig.bStart) {
			uliReg |= COMM_CTRL_LINK_START_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_START_MSK);
		}
		if (pxCh->xLinkConfig.bDisconnect) {
			uliReg |= COMM_CTRL_LINK_DISCONNECT_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_DISCONNECT_MSK);
		}

		vSpwcWriteReg(pxCh->puliSpwcChAddr, COMM_WINDOW_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLink(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliSpwcReadReg(pxCh->puliSpwcChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (uliReg & COMM_CTRL_LINK_AUTOSTART_MSK) {
			pxCh->xLinkConfig.bAutostart = TRUE;
		} else {
			pxCh->xLinkConfig.bAutostart = FALSE;
		}
		if (uliReg & COMM_CTRL_LINK_START_MSK) {
			pxCh->xLinkConfig.bStart = TRUE;
		} else {
			pxCh->xLinkConfig.bStart = FALSE;
		}
		if (uliReg & COMM_CTRL_LINK_DISCONNECT_MSK) {
			pxCh->xLinkConfig.bDisconnect = TRUE;
		} else {
			pxCh->xLinkConfig.bDisconnect = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLinkError(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliSpwcReadReg(pxCh->puliSpwcChAddr,
		COMM_WINDOW_STAT_REG_OFFSET);

		if (uliReg & COMM_STAT_LINK_DISC_ERR_MSK) {
			pxCh->xLinkError.bDisconnect = TRUE;
		} else {
			pxCh->xLinkError.bDisconnect = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_PAR_ERR_MSK) {
			pxCh->xLinkError.bParity = TRUE;
		} else {
			pxCh->xLinkError.bParity = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_ESC_ERR_MSK) {
			pxCh->xLinkError.bEscape = TRUE;
		} else {
			pxCh->xLinkError.bEscape = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_CRED_ERR_MSK) {
			pxCh->xLinkError.bCredit = TRUE;
		} else {
			pxCh->xLinkError.bCredit = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLinkStatus(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliSpwcReadReg(pxCh->puliSpwcChAddr,
		COMM_WINDOW_STAT_REG_OFFSET);

		if (uliReg & COMM_STAT_LINK_STARTED_MSK) {
			pxCh->xLinkStatus.bStarted = TRUE;
		} else {
			pxCh->xLinkStatus.bStarted = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_CONNECTING_MSK) {
			pxCh->xLinkStatus.bConnecting = TRUE;
		} else {
			pxCh->xLinkStatus.bConnecting = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_RUNNING_MSK) {
			pxCh->xLinkStatus.bRunning = TRUE;
		} else {
			pxCh->xLinkStatus.bRunning = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcInitCh(TSpwcChannel *pxCh, alt_u8 ucSpwCh) {
	bool bStatus = FALSE;

	if (pxCh != NULL) {
		bStatus = TRUE;

		switch (ucSpwCh) {
		case eCommSpwCh1:
			pxCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
			break;
		case eCommSpwCh2:
			pxCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
			break;
		case eCommSpwCh3:
			pxCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
			break;
		case eCommSpwCh4:
			pxCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
			break;
		case eCommSpwCh5:
			pxCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
			break;
		case eCommSpwCh6:
			pxCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
			break;
		case eCommSpwCh7:
			pxCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
			break;
		case eCommSpwCh8:
			pxCh->puliSpwcChAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
			break;
		default:
			bStatus = FALSE;
			break;
		}

		if (bStatus) {
			if (!bFeebGetWindowing(pxCh)) {
				bStatus = FALSE;
			}
			if (!bSpwcGetLink(pxCh)) {
				bStatus = FALSE;
			}
			if (!bSpwcGetLinkError(pxCh)) {
				bStatus = FALSE;
			}
			if (!bSpwcGetLinkStatus(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetTimecodeRx(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetTimecodeTx(pxCh)) {
				bStatus = FALSE;
			}
			if (!bFeebGetIrqControl(pxCh)) {
				bStatus = FALSE;
			}
			if (!bFeebGetIrqFlags(pxCh)) {
				bStatus = FALSE;
			}
			if (!bFeebGetBuffersStatus(pxCh)) {
				bStatus = FALSE;
			}
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

