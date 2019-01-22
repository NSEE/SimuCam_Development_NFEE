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
		COMM_LINK_CFG_STAT_REG_OFST);

		if (pxSpwcCh->xLinkConfig.bAutostart) {
			uliReg |= COMM_SPW_LNKCFG_AUTOSTART_MSK;
		} else {
			uliReg &= (~COMM_SPW_LNKCFG_AUTOSTART_MSK);
		}
		if (pxSpwcCh->xLinkConfig.bLinkStart) {
			uliReg |= COMM_SPW_LNKCFG_LINKSTART_MSK;
		} else {
			uliReg &= (~COMM_SPW_LNKCFG_LINKSTART_MSK);
		}
		if (pxSpwcCh->xLinkConfig.bDisconnect) {
			uliReg |= COMM_SPW_LNKCFG_DISCONNECT_MSK;
		} else {
			uliReg &= (~COMM_SPW_LNKCFG_DISCONNECT_MSK);
		}
		uliReg &= (~COMM_SPW_LNKCFG_TXDIVCNT_MSK);
		uliReg |= (COMM_SPW_LNKCFG_TXDIVCNT_MSK
				& alt_u32(pxSpwcCh->xLinkConfig.ucTxDivCnt << 24));

		vSpwcWriteReg(pxSpwcCh->puliSpwcChAddr, COMM_LINK_CFG_STAT_REG_OFST,
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
		COMM_LINK_CFG_STAT_REG_OFST);

		if (uliReg & COMM_SPW_LNKCFG_AUTOSTART_MSK) {
			pxSpwcCh->xLinkConfig.bAutostart = TRUE;
		} else {
			pxSpwcCh->xLinkConfig.bAutostart = FALSE;
		}
		if (uliReg & COMM_SPW_LNKCFG_LINKSTART_MSK) {
			pxSpwcCh->xLinkConfig.bStart = TRUE;
		} else {
			pxSpwcCh->xLinkConfig.bStart = FALSE;
		}
		if (uliReg & COMM_SPW_LNKCFG_DISCONNECT_MSK) {
			pxSpwcCh->xLinkConfig.bDisconnect = TRUE;
		} else {
			pxSpwcCh->xLinkConfig.bDisconnect = FALSE;
		}
		pxSpwcCh->xLinkConfig.ucTxDivCnt = alt_u8(
				(uliReg & COMM_SPW_LNKCFG_TXDIVCNT_MSK) >> 24);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr,
		COMM_LINK_CFG_STAT_REG_OFST);

		if (uliReg & COMM_SPW_LNKERR_DISCONNECT_MSK) {
			pxSpwcCh->xLinkError.bDisconnect = TRUE;
		} else {
			pxSpwcCh->xLinkError.bDisconnect = FALSE;
		}
		if (uliReg & COMM_SPW_LNKERR_PARITY_MSK) {
			pxSpwcCh->xLinkError.bParity = TRUE;
		} else {
			pxSpwcCh->xLinkError.bParity = FALSE;
		}
		if (uliReg & COMM_SPW_LNKERR_ESCAPE_MSK) {
			pxSpwcCh->xLinkError.bEscape = TRUE;
		} else {
			pxSpwcCh->xLinkError.bEscape = FALSE;
		}
		if (uliReg & COMM_SPW_LNKERR_CREDIT_MSK) {
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
		COMM_LINK_CFG_STAT_REG_OFST);

		if (uliReg & COMM_SPW_LNKSTAT_STARTED_MSK) {
			pxSpwcCh->xLinkStatus.bStarted = TRUE;
		} else {
			pxSpwcCh->xLinkStatus.bStarted = FALSE;
		}
		if (uliReg & COMM_SPW_LNKSTAT_CONNECTING_MSK) {
			pxSpwcCh->xLinkStatus.bConnecting = TRUE;
		} else {
			pxSpwcCh->xLinkStatus.bConnecting = FALSE;
		}
		if (uliReg & COMM_SPW_LNKSTAT_RUNNING_MSK) {
			pxSpwcCh->xLinkStatus.bRunning = TRUE;
		} else {
			pxSpwcCh->xLinkStatus.bRunning = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcGetTimecode(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr,
		COMM_TIMECODE_REG_OFST);

		pxSpwcCh->xTimecode.ucControl = alt_u8(
				(uliReg & COMM_TIMECODE_CONTROL_MSK) >> 6);
		pxSpwcCh->xTimecode.ucCounter = alt_u8(
				(uliReg & COMM_TIMECODE_TIME_MSK) >> 0);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bSpwcClearTimecode(TSpwcChannel *pxSpwcCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxSpwcCh != NULL) {
		uliReg = uliSpwcReadReg(pxSpwcCh->puliSpwcChAddr,
		COMM_TIMECODE_REG_OFST);

		uliReg |= COMM_TIMECODE_CLR_MSK;

		vSpwcWriteReg(pxSpwcCh->puliSpwcChAddr, COMM_TIMECODE_REG_OFST, uliReg);
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
			if (!bSpwcGetLink(pxSpwcCh)) {
				bStatus = FALSE;
			}
			if (!bSpwcGetLinkError(pxSpwcCh)) {
				bStatus = FALSE;
			}
			if (!bSpwcGetLinkStatus(pxSpwcCh)) {
				bStatus = FALSE;
			}
			if (!bSpwcGetTimecode(pxSpwcCh)) {
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

