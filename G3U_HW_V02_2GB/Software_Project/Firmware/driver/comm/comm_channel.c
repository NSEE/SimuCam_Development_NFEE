#include "comm_channel.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables
static void vCommWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliCommReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bCommSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile alt_u32 uliReg = 0;
	alt_u32 *puliCommAddr = 0;

	switch (ucCommCh) {
	case eCommSpwCh1:
		puliCommAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		puliCommAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		puliCommAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		puliCommAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eCommSpwCh5:
		puliCommAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eCommSpwCh6:
		puliCommAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eCommSpwCh7:
		puliCommAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
		bValidCh = TRUE;
		break;
	case eCommSpwCh8:
		puliCommAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {
		uliReg = uliCommReadReg(puliCommAddr,
		COMM_IRQ_CONTROL_REG_OFST);

		if (bGlobalIrqEnable) {
			uliReg |= COMM_IRQ_GLOBAL_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_GLOBAL_EN_MSK);
		}

		vCommWriteReg(puliCommAddr, COMM_IRQ_CONTROL_REG_OFST, uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommInitCh(TCommChannel *pxCommCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bInitFail = FALSE;

	if (!bSpwcInitCh(&(pxCommCh->xSpacewire), ucCommCh)) {
		bInitFail = TRUE;
	}
//	if (!vFeebInitIrq(ucCommCh)) {
//		bInitFail = TRUE;
//	}
	if (!bFeebInitCh(&(pxCommCh->xFeeBuffer), ucCommCh)) {
		bInitFail = TRUE;
	}
	if (!bRmapInitCh(&(pxCommCh->xRmap), ucCommCh)) {
		bInitFail = TRUE;
	}
	if (!vRmapInitIrq(ucCommCh)) {
		bInitFail = TRUE;
	}
	if (!bDpktInitCh(&(pxCommCh->xDataPacket), ucCommCh)) {
		bInitFail = TRUE;
	}

	if (!bInitFail) {
		bStatus = TRUE;
	}

	return bStatus;
}
//! [public functions]

//! [private functions]
static void vCommWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliCommReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	volatile alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
//! [private functions]

