/*
 * data_packet.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "data_packet.h"

//! [private function prototypes]
static void vDpktWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliDpktReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
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
	alt_u32 uliReg = 0;

	if (pxDpktCh != NULL) {

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_CFG_1_REG_OFST);

		uliReg &= (~COMM_DATA_PKT_CCD_X_SIZE_MSK);
		uliReg |= (COMM_DATA_PKT_CCD_X_SIZE_MSK
				& alt_u32(pxDpktCh->xDpktDataPacketConfig.usiCcdXSize << 0));
		uliReg &= (~COMM_DATA_PKT_CCD_Y_SIZE_MSK);
		uliReg |= (COMM_DATA_PKT_CCD_Y_SIZE_MSK
				& alt_u32(pxDpktCh->xDpktDataPacketConfig.usiCcdYSize << 16));

		vDpktWriteReg(pxDpktCh->puliDpktChAddr, COMM_DATA_PKT_CFG_1_REG_OFST,
				uliReg);
		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_CFG_2_REG_OFST);

		uliReg &= (~COMM_DATA_PKT_DATA_Y_SIZE_MSK);
		uliReg |= (COMM_DATA_PKT_DATA_Y_SIZE_MSK
				& alt_u32(pxDpktCh->xDpktDataPacketConfig.usiDataYSize << 0));
		uliReg &= (~COMM_DATA_PKT_OVER_Y_SIZE_MSK);
		uliReg |=
				(COMM_DATA_PKT_OVER_Y_SIZE_MSK
						& alt_u32(
								pxDpktCh->xDpktDataPacketConfig.usiOverscanYSize
										<< 16));

		vDpktWriteReg(pxDpktCh->puliDpktChAddr, COMM_DATA_PKT_CFG_2_REG_OFST,
				uliReg);
		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_CFG_3_REG_OFST);

		uliReg &= (~COMM_DATA_PKT_LENGTH_MSK);
		uliReg |=
				(COMM_DATA_PKT_LENGTH_MSK
						& alt_u32(
								pxDpktCh->xDpktDataPacketConfig.usiPacketLength
										<< 0));

		vDpktWriteReg(pxDpktCh->puliDpktChAddr, COMM_DATA_PKT_CFG_3_REG_OFST,
				uliReg);
		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_CFG_4_REG_OFST);

		uliReg &= (~COMM_DATA_PKT_FEE_MODE_MSK);
		uliReg |= (COMM_DATA_PKT_FEE_MODE_MSK
				& alt_u32(pxDpktCh->xDpktDataPacketConfig.ucFeeMode << 0));
		uliReg &= (~COMM_DATA_PKT_CCD_NUMBER_MSK);
		uliReg |= (COMM_DATA_PKT_CCD_NUMBER_MSK
				& alt_u32(pxDpktCh->xDpktDataPacketConfig.ucCcdNumber << 8));

		vDpktWriteReg(pxDpktCh->puliDpktChAddr, COMM_DATA_PKT_CFG_4_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetPacketConfig(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxDpktCh != NULL) {

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_CFG_1_REG_OFST);

		pxDpktCh->xDpktDataPacketConfig.usiCcdXSize = alt_u16(
				(uliReg & COMM_DATA_PKT_CCD_X_SIZE_MSK) >> 0);
		pxDpktCh->xDpktDataPacketConfig.usiCcdYSize = alt_u16(
				(uliReg & COMM_DATA_PKT_CCD_Y_SIZE_MSK) >> 16);

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_CFG_2_REG_OFST);

		pxDpktCh->xDpktDataPacketConfig.usiDataYSize = alt_u16(
				(uliReg & COMM_DATA_PKT_DATA_Y_SIZE_MSK) >> 0);
		pxDpktCh->xDpktDataPacketConfig.usiOverscanYSize = alt_u16(
				(uliReg & COMM_DATA_PKT_OVER_Y_SIZE_MSK) >> 16);

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_CFG_3_REG_OFST);

		pxDpktCh->xDpktDataPacketConfig.usiPacketLength = alt_u16(
				(uliReg & COMM_DATA_PKT_LENGTH_MSK) >> 0);

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_CFG_4_REG_OFST);

		pxDpktCh->xDpktDataPacketConfig.ucFeeMode = alt_u8(
				(uliReg & COMM_DATA_PKT_FEE_MODE_MSK) >> 0);
		pxDpktCh->xDpktDataPacketConfig.ucCcdNumber = alt_u8(
				(uliReg & COMM_DATA_PKT_CCD_NUMBER_MSK) >> 8);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetPacketHeader(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxDpktCh != NULL) {

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_HDR_1_REG_OFST);

		pxDpktCh->xDpktDataPacketHeader.usiLength = alt_u16(
				(uliReg & COMM_DATA_PKT_HDR_LENGTH_MSK) >> 0);
		pxDpktCh->xDpktDataPacketHeader.usiType = alt_u16(
				(uliReg & COMM_DATA_PKT_HDR_TYPE_MSK) >> 16);

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_HDR_2_REG_OFST);

		pxDpktCh->xDpktDataPacketHeader.usiFrameCounter = alt_u16(
				(uliReg & COMM_DATA_PKT_HDR_FRAME_CNT_MSK) >> 0);
		pxDpktCh->xDpktDataPacketHeader.usiSequenceCounter = alt_u16(
				(uliReg & COMM_DATA_PKT_SEQ_CNT_MSK) >> 16);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktSetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxDpktCh != NULL) {

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_PX_DLY_1_REG_OFST);

		uliReg &= (~COMM_DATA_PKT_LINE_DLY_MSK);
		uliReg |= (COMM_DATA_PKT_LINE_DLY_MSK
				& alt_u32(pxDpktCh->xDpktPixelDelay.usiLineDelay << 0));

		vDpktWriteReg(pxDpktCh->puliDpktChAddr, COMM_DATA_PKT_PX_DLY_1_REG_OFST,
				uliReg);
		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_PX_DLY_2_REG_OFST);

		uliReg &= (~COMM_DATA_PKT_COLUMN_DLY_MSK);
		uliReg |= (COMM_DATA_PKT_COLUMN_DLY_MSK
				& alt_u32(pxDpktCh->xDpktPixelDelay.usiColumnDelay << 0));

		vDpktWriteReg(pxDpktCh->puliDpktChAddr, COMM_DATA_PKT_PX_DLY_2_REG_OFST,
				uliReg);
		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_PX_DLY_3_REG_OFST);

		uliReg &= (~COMM_DATA_PKT_ADC_DLY_MSK);
		uliReg |= (COMM_DATA_PKT_ADC_DLY_MSK
				& alt_u32(pxDpktCh->xDpktPixelDelay.usiAdcDelay << 0));

		vDpktWriteReg(pxDpktCh->puliDpktChAddr, COMM_DATA_PKT_PX_DLY_3_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxDpktCh != NULL) {

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_PX_DLY_1_REG_OFST);

		pxDpktCh->xDpktPixelDelay.usiLineDelay = alt_u16(
				(uliReg & COMM_DATA_PKT_LINE_DLY_MSK) >> 0);

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_PX_DLY_2_REG_OFST);

		pxDpktCh->xDpktPixelDelay.usiColumnDelay = alt_u16(
				(uliReg & COMM_DATA_PKT_COLUMN_DLY_MSK) >> 0);

		uliReg = uliDpktReadReg(pxDpktCh->puliDpktChAddr,
				COMM_DATA_PKT_PX_DLY_3_REG_OFST);

		pxDpktCh->xDpktPixelDelay.usiAdcDelay = alt_u16(
				(uliReg & COMM_DATA_PKT_ADC_DLY_MSK) >> 0);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktInitCh(TDpktChannel *pxDpktCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;

	if (pxDpktCh != NULL) {
		bStatus = TRUE;

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxDpktCh->puliDpktChAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
			break;
		case eCommSpwCh2:
			pxDpktCh->puliDpktChAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
			break;
		case eCommSpwCh3:
			pxDpktCh->puliDpktChAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
			break;
		case eCommSpwCh4:
			pxDpktCh->puliDpktChAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
			break;
		case eCommSpwCh5:
			pxDpktCh->puliDpktChAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
			break;
		case eCommSpwCh6:
			pxDpktCh->puliDpktChAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
			break;
		case eCommSpwCh7:
			pxDpktCh->puliDpktChAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
			break;
		case eCommSpwCh8:
			pxDpktCh->puliDpktChAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
			break;
		default:
			bStatus = FALSE;
			break;
		}

		if (bStatus) {
			if (!bDpktGetPacketConfig(pxDpktCh)) {
				bStatus = FALSE;
			}
			if (!bDpktGetPacketHeader(pxDpktCh)) {
				bStatus = FALSE;
			}
			if (!bDpktGetPixelDelay(pxDpktCh)) {
				bStatus = FALSE;
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
static void vDpktWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliDpktReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
//! [private functions]
