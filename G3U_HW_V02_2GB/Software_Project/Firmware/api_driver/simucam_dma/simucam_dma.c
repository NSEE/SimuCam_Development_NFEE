/*
 * simucam_dma.c
 *
 *  Created on: 10/01/2019
 *      Author: rfranca
 */

#include "simucam_dma.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
alt_msgdma_dev *pxDmaM1Dev = NULL;
alt_msgdma_dev *pxDmaM2Dev = NULL;
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bSdmaInitM1Dma(void) {
	bool bStatus = TRUE;
	alt_u16 usiCounter = 0;

	// open dma device
	pxDmaM1Dev = alt_msgdma_open((char *) SDMA_DMA_M1_NAME);

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

bool bSdmaInitM2Dma(void) {
	bool bStatus = TRUE;
	alt_u16 usiCounter = 0;

	// open dma device
	pxDmaM2Dev = alt_msgdma_open((char *) SDMA_DMA_M2_NAME);

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

bool bSdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr,
		alt_u16 usiTransferSizeInBlocks, alt_u8 ucBufferSide,
		alt_u8 ucChBufferId) {
	bool bStatus = TRUE;
	alt_u16 usiCnt = 0;

	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;

	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_1_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_1_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_1_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_1_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh2Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_2_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_2_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_2_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_2_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh3Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_3_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_3_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_3_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_3_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh4Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_4_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_4_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_4_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_4_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh5Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_5_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_5_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_5_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_5_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh6Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_6_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_6_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_6_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_6_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh7Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_7_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_7_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_7_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_7_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh8Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_8_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_8_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_8_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_8_L_BUFF_BASE_ADDR_HIGH;
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

	uliSrcAddrLow = (alt_u32) SDMA_M1_BASE_ADDR_LOW
			+ (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) SDMA_M1_BASE_ADDR_HIGH;

	if (bStatus) {
		if (pxDmaM1Dev == NULL) {
			bStatus = FALSE;
		} else {
			for (usiCnt = 0; usiCnt < usiTransferSizeInBlocks; usiCnt++) {
				// hold transfers for descriptor fifo space
				while (0
						!= (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM1Dev->csr_base)
								& ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
					alt_busy_sleep(1); /* delay 1us */
				}
				if (iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM1Dev,
						&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
						(alt_u32 *) uliDestAddrLow,
						SDMA_PIXEL_BLOCK_SIZE_BYTES, uliControlBits,
						(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
						1, 1, 1, 1, 1)) {
					bStatus = FALSE;
					break;
				} else {
					if (iMsgdmaExtendedDescriptorSyncTransfer(pxDmaM1Dev,
							&xDmaExtendedDescriptor)) {
						bStatus = FALSE;
						break;
					}
					uliSrcAddrLow += (alt_u32) SDMA_PIXEL_BLOCK_SIZE_BYTES;
					uliSrcAddrHigh = (alt_u32) SDMA_M1_BASE_ADDR_HIGH;
				}
			}
		}
	}
	return bStatus;
}

bool bSdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr,
		alt_u16 usiTransferSizeInBlocks, alt_u8 ucBufferSide,
		alt_u8 ucChBufferId) {
	bool bStatus = TRUE;
	alt_u16 usiCnt = 0;

	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;

	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_1_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_1_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_1_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_1_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh2Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_2_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_2_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_2_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_2_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh3Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_3_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_3_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_3_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_3_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh4Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_4_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_4_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_4_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_4_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh5Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_5_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_5_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_5_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_5_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh6Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_6_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_6_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_6_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_6_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh7Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_7_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_7_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_7_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_7_L_BUFF_BASE_ADDR_HIGH;
			break;
		default:
			bStatus = FALSE;
			break;
		}
		break;
	case eSdmaCh8Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_8_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_8_R_BUFF_BASE_ADDR_HIGH;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_8_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_8_L_BUFF_BASE_ADDR_HIGH;
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

	uliSrcAddrLow = (alt_u32) SDMA_M2_BASE_ADDR_LOW
			+ (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) SDMA_M2_BASE_ADDR_HIGH;

	if (bStatus) {
		if (pxDmaM2Dev == NULL) {
			bStatus = FALSE;
		} else {
			for (usiCnt = 0; usiCnt < usiTransferSizeInBlocks; usiCnt++) {
				// hold transfers for descriptor fifo space
				while (0
						!= (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM2Dev->csr_base)
								& ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
					alt_busy_sleep(1); /* delay 1us */
				}
				if (iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM2Dev,
						&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
						(alt_u32 *) uliDestAddrLow,
						SDMA_PIXEL_BLOCK_SIZE_BYTES, uliControlBits,
						(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
						1, 1, 1, 1, 1)) {
					bStatus = FALSE;
					break;
				} else {
					if (iMsgdmaExtendedDescriptorSyncTransfer(pxDmaM2Dev,
							&xDmaExtendedDescriptor)) {
						bStatus = FALSE;
						break;
					}
					uliSrcAddrLow += (alt_u32) SDMA_PIXEL_BLOCK_SIZE_BYTES;
					uliSrcAddrHigh = (alt_u32) SDMA_M2_BASE_ADDR_HIGH;
				}
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
//! [private functions]
