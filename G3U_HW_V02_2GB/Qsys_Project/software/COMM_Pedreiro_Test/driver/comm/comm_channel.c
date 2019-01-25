#include "comm_channel.h""

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
bool bCommInitCh(TCommChannel *pxCommCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;

	if (!bSpwcInitCh(&(pxCommCh->xSpacewire), ucCommCh)) {
		bStatus = FALSE;
	}
	vFeebInitIrq(ucCommCh);

	if (!bFeebInitCh(&(pxCommCh->xFeeBuffer), ucCommCh)) {
		bStatus = FALSE;
	}
	if (!bRmapInitCh(&(pxCommCh->xRmap), ucCommCh)) {
		bStatus = FALSE;
	}
	vRmapInitIrq(ucCommCh);

	if (!bDpktInitCh(&(pxCommCh->xDataPacket), ucCommCh)) {
		bStatus = FALSE;
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
//! [private functions]

