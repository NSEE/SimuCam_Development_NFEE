/*
 * fee_buffers.c
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#include "fee_buffers.h"

alt_msgdma_dev *pxDmaM1Dev = NULL;
alt_msgdma_dev *pxDmaM2Dev = NULL;

bool bFeebInitM1Dma(void) {
	bool bStatus = TRUE;
	alt_u16 usiCounter = 0;

	// open dma device
	pxDmaM1Dev = alt_msgdma_open((char *) FEEB_DMA_M1_NAME);

	// check if the device was opened
	if (pxDmaM1Dev == NULL) {
		// device not opened
		bStatus = FALSE;
	} else {
		// device opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaM1Dev->csr_base,
				ALTERA_MSGDMA_CSR_RESET_MASK);
		while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM1Dev->csr_base)
				& ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bStatus = FALSE;
				break;
			}
		}
	}

	return bStatus;
}

bool bFeebInitM2Dma(void) {
	bool bStatus = TRUE;
	alt_u16 usiCounter = 0;

	// open dma device
	pxDmaM2Dev = alt_msgdma_open((char *) FEEB_DMA_M2_NAME);

	// check if the device was opened
	if (pxDmaM2Dev == NULL) {
		// device not opened
		bStatus = FALSE;
	} else {
		// device opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaM2Dev->csr_base,
				ALTERA_MSGDMA_CSR_RESET_MASK);
		while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM2Dev->csr_base)
				& ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bStatus = FALSE;
				break;
			}
		}
	}

	return bStatus;
}

bool bFeebDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiSizeInBlocks,
		alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus = TRUE;
	alt_u16 usiCnt = 0;

	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;

	switch (ucChBufferId) {
	case eFeebCh1Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_1_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_1_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_1_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_1_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh2Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_2_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_2_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_2_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_2_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh3Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_3_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_3_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_3_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_3_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh4Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_4_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_4_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_4_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_4_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh5Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_5_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_5_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_5_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_5_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh6Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_6_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_6_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_6_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_6_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh7Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_7_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_7_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_7_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_7_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh8Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_8_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_8_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_8_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_8_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	default:
		bStatus = FALSE;
		break;
	}

	uliSrcAddrLow = (alt_u32) FEEB_M1_BASE_ADDR_LOW
			+ (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) FEEB_M1_BASE_ADDR_HIGH;

	if (bStatus) {
		if (pxDmaM1Dev == NULL) {
			bStatus = FALSE;
		} else {
			for (usiCnt = 0; usiCnt < usiSizeInBlocks; usiCnt++) {
				if (msgdma_construct_extended_mm_to_mm_descriptor(pxDmaM1Dev,
						&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
						(alt_u32 *) uliDestAddrLow,
						FEEB_PIXEL_BLOCK_SIZE_BYTES, uliControlBits,
						(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
						1, 1, 1, 1, 1)) {
					bStatus = FALSE;
					break;
				} else {
					if (msgdma_extended_descriptor_sync_transfer(pxDmaM1Dev,
							&xDmaExtendedDescriptor)) {
						bStatus = FALSE;
						break;
					}
					uliSrcAddrLow += (alt_u32) FEEB_PIXEL_BLOCK_SIZE_BYTES;
					uliSrcAddrHigh = (alt_u32) FEEB_M1_BASE_ADDR_HIGH;
				}
			}
		}
	}
	return bStatus;
}

bool bFeebDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiSizeInBlocks,
		alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus = TRUE;
	alt_u16 usiCnt = 0;

	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;

	switch (ucChBufferId) {
	case eFeebCh1Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_1_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_1_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_1_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_1_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh2Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_2_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_2_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_2_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_2_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh3Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_3_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_3_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_3_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_3_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh4Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_4_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_4_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_4_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_4_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh5Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_5_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_5_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_5_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_5_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh6Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_6_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_6_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_6_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_6_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh7Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_7_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_7_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_7_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_7_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eFeebCh8Buffer:
		switch (ucBufferSide) {
		case eFeebRightBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_8_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_8_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eFeebLeftBuffer:
			uliDestAddrLow = (alt_u32) FEEB_CH_8_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) FEEB_CH_8_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	default:
		bStatus = FALSE;
		break;
	}

	uliSrcAddrLow = (alt_u32) FEEB_M2_BASE_ADDR_LOW
			+ (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) FEEB_M2_BASE_ADDR_HIGH;

	if (bStatus) {
		if (pxDmaM2Dev == NULL) {
			bStatus = FALSE;
		} else {
			for (usiCnt = 0; usiCnt < usiSizeInBlocks; usiCnt++) {
				if (msgdma_construct_extended_mm_to_mm_descriptor(pxDmaM2Dev,
						&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
						(alt_u32 *) uliDestAddrLow,
						FEEB_PIXEL_BLOCK_SIZE_BYTES, uliControlBits,
						(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
						1, 1, 1, 1, 1)) {
					bStatus = FALSE;
					break;
				} else {
					if (msgdma_extended_descriptor_sync_transfer(pxDmaM2Dev,
							&xDmaExtendedDescriptor)) {
						bStatus = FALSE;
						break;
					}
					uliSrcAddrLow += (alt_u32) FEEB_PIXEL_BLOCK_SIZE_BYTES;
					uliSrcAddrHigh = (alt_u32) FEEB_M2_BASE_ADDR_HIGH;
				}
			}
		}
	}
	return bStatus;
}
