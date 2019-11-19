#include "comm_channel.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bCommSetGlobalIrqEn(bool bGlobalIrqEnable, alt_u8 ucCommCh) {
	bool bStatus = FALSE;

	volatile TCommChannel *vpxCommChannel;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxCommChannel = (TCommChannel *) COMM_CHANNEL_1_BASE_ADDR;
		vpxCommChannel->xCommIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		vpxCommChannel = (TCommChannel *) COMM_CHANNEL_2_BASE_ADDR;
		vpxCommChannel->xCommIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		vpxCommChannel = (TCommChannel *) COMM_CHANNEL_3_BASE_ADDR;
		vpxCommChannel->xCommIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		vpxCommChannel = (TCommChannel *) COMM_CHANNEL_4_BASE_ADDR;
		vpxCommChannel->xCommIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eCommSpwCh5:
		vpxCommChannel = (TCommChannel *) COMM_CHANNEL_5_BASE_ADDR;
		vpxCommChannel->xCommIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eCommSpwCh6:
		vpxCommChannel = (TCommChannel *) COMM_CHANNEL_6_BASE_ADDR;
		vpxCommChannel->xCommIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eCommSpwCh7:
		vpxCommChannel = (TCommChannel *) COMM_CHANNEL_7_BASE_ADDR;
		vpxCommChannel->xCommIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	case eCommSpwCh8:
		vpxCommChannel = (TCommChannel *) COMM_CHANNEL_8_BASE_ADDR;
		vpxCommChannel->xCommIrqControl.bGlobalIrqEn = bGlobalIrqEnable;
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bCommInitCh(TCommChannel *pxCommCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bInitFail = FALSE;

	if (!bSpwcInitCh(&(pxCommCh->xSpacewire), ucCommCh)) {
		bInitFail = TRUE;
	}
	if (!vFeebInitIrq(ucCommCh)) {
		bInitFail = TRUE;
	}
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
//! [private functions]

