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

bool bFeebDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks,
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
			for (usiCnt = 0; usiCnt < usiTransferSizeInBlocks; usiCnt++) {
				if (iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM1Dev,
						&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
						(alt_u32 *) uliDestAddrLow,
						FEEB_PIXEL_BLOCK_SIZE_BYTES, uliControlBits,
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
					uliSrcAddrLow += (alt_u32) FEEB_PIXEL_BLOCK_SIZE_BYTES;
					uliSrcAddrHigh = (alt_u32) FEEB_M1_BASE_ADDR_HIGH;
				}
			}
		}
	}
	return bStatus;
}

bool bFeebDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks,
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
			for (usiCnt = 0; usiCnt < usiTransferSizeInBlocks; usiCnt++) {
				if (iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM2Dev,
						&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
						(alt_u32 *) uliDestAddrLow,
						FEEB_PIXEL_BLOCK_SIZE_BYTES, uliControlBits,
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
					uliSrcAddrLow += (alt_u32) FEEB_PIXEL_BLOCK_SIZE_BYTES;
					uliSrcAddrHigh = (alt_u32) FEEB_M2_BASE_ADDR_HIGH;
				}
			}
		}
	}
	return bStatus;
}

//! [private function prototypes]
static void vFeebWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliFeebReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viCh1HoldContext;
static volatile int viCh2HoldContext;
static volatile int viCh3HoldContext;
static volatile int viCh4HoldContext;
static volatile int viCh5HoldContext;
static volatile int viCh6HoldContext;
static volatile int viCh7HoldContext;
static volatile int viCh8HoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

void vFeebCh1HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh1IrqFlagClrBufferEmpty();
}

void vFeebCh2HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh2IrqFlagClrBufferEmpty();
}

void vFeebCh3HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh3IrqFlagClrBufferEmpty();
}

void vFeebCh4HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh4IrqFlagClrBufferEmpty();
}

void vFeebCh5HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh5IrqFlagClrBufferEmpty();
}

void vFeebCh6HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	vFeebCh6IrqFlagClrBufferEmpty();
}

void vFeebCh7HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh7IrqFlagClrBufferEmpty();
}

void vFeebCh8HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh8IrqFlagClrBufferEmpty();
}

void vFeebCh1IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh2IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh3IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh4IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh5IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh6IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh7IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh8IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

bool bFeebCh1IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh2IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh3IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh4IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh5IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh6IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh7IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh8IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

void vFeebInitIrq(alt_u8 ucSpwCh) {
	void* pvHoldContext;
	switch (ucSpwCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_A_IRQ, pvHoldContext,
				vFeebCh1HandleIrq);
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_B_IRQ, pvHoldContext,
				vFeebCh2HandleIrq);
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_C_IRQ, pvHoldContext,
				vFeebCh3HandleIrq);
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_D_IRQ, pvHoldContext,
				vFeebCh4HandleIrq);
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_E_IRQ, pvHoldContext,
				vFeebCh5HandleIrq);
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_F_IRQ, pvHoldContext,
				vFeebCh6HandleIrq);
		break;
	case eCommSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_G_IRQ, pvHoldContext,
				vFeebCh7HandleIrq);
		break;
	case eCommSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_H_IRQ, pvHoldContext,
				vFeebCh8HandleIrq);
		break;
	}
}

bool bFeebSetIrqControl(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliFeebReadReg(pxCh->puliSpwcChAddr,
		COMM_IRQ_CTRL_REG_OFFSET);

		if (pxCh->xIrqControl.bLeftBufferEmptyEn) {
			uliReg |= COMM_IRQ_L_BUFFER_EMPTY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_L_BUFFER_EMPTY_EN_MSK);
		}
		if (pxCh->xIrqControl.bRightBufferEmptyEn) {
			uliReg |= COMM_IRQ_R_BUFFER_EMPTY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_R_BUFFER_EMPTY_EN_MSK);
		}

		vFeebWriteReg(pxCh->puliSpwcChAddr, COMM_IRQ_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetIrqControl(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliFeebReadReg(pxCh->puliSpwcChAddr,
		COMM_IRQ_CTRL_REG_OFFSET);

		if (uliReg & COMM_IRQ_L_BUFFER_EMPTY_EN_MSK) {
			pxCh->xIrqControl.bLeftBufferEmptyEn = TRUE;
		} else {
			pxCh->xIrqControl.bLeftBufferEmptyEn = FALSE;
		}
		if (uliReg & COMM_IRQ_R_BUFFER_EMPTY_EN_MSK) {
			pxCh->xIrqControl.bRightBufferEmptyEn = TRUE;
		} else {
			pxCh->xIrqControl.bRightBufferEmptyEn = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetIrqFlags(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliFeebReadReg(pxCh->puliSpwcChAddr,
		COMM_IRQ_FLAG_REG_OFFSET);

		if (uliReg & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
			pxCh->xIrqFlag.bBufferEmptyFlag = TRUE;
		} else {
			pxCh->xIrqFlag.bBufferEmptyFlag = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebSetWindowing(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliFeebReadReg(pxCh->puliSpwcChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (pxCh->xWindowingConfig.bMasking) {
			uliReg |= COMM_CTRL_MASKING_EN_MSK;
		} else {
			uliReg &= (~COMM_CTRL_MASKING_EN_MSK);
		}

		vFeebWriteReg(pxCh->puliSpwcChAddr, COMM_WINDOW_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetWindowing(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliFeebReadReg(pxCh->puliSpwcChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (uliReg & COMM_CTRL_MASKING_EN_MSK) {
			pxCh->xWindowingConfig.bMasking = TRUE;
		} else {
			pxCh->xWindowingConfig.bMasking = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetBuffersStatus(TSpwcChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliFeebReadReg(pxCh->puliSpwcChAddr,
		COMM_WINDOW_BUFFER_REG_OFFSET);

		if (uliReg & COMM_BUFF_STAT_L_BUFF_EPY_MSK) {
			pxCh->xBufferStatus.bLeftBufferEmpty = TRUE;
		} else {
			pxCh->xBufferStatus.bLeftBufferEmpty = FALSE;
		}
		if (uliReg & COMM_BUFF_STAT_R_BUFF_EPY_MSK) {
			pxCh->xBufferStatus.bRightBufferEmpty = TRUE;
		} else {
			pxCh->xBufferStatus.bRightBufferEmpty = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

//! [public functions]

//! [private functions]
static void vFeebWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliFeebReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
