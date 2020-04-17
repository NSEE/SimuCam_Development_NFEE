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
alt_msgdma_dev *pxDmaCh1LeftDev = NULL;
alt_msgdma_dev *pxDmaCh1RightDev = NULL;
alt_msgdma_dev *pxDmaCh2LeftDev = NULL;
alt_msgdma_dev *pxDmaCh2RightDev = NULL;
alt_msgdma_dev *pxDmaCh3LeftDev = NULL;
alt_msgdma_dev *pxDmaCh3RightDev = NULL;
alt_msgdma_dev *pxDmaCh4LeftDev = NULL;
alt_msgdma_dev *pxDmaCh4RightDev = NULL;
alt_msgdma_dev *pxDmaCh5LeftDev = NULL;
alt_msgdma_dev *pxDmaCh5RightDev = NULL;
alt_msgdma_dev *pxDmaCh6LeftDev = NULL;
alt_msgdma_dev *pxDmaCh6RightDev = NULL;
alt_msgdma_dev *pxDmaFtdiRxDev = NULL;
alt_msgdma_dev *pxDmaFtdiTxDev = NULL;
//! [data memory public global variables]

//! [public functions]
bool bSdmaInitCh1Dmas(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma devices
	pxDmaCh1LeftDev = alt_msgdma_open((char *) SDMA_DMA_CH_1_LEFT_NAME);
	pxDmaCh1RightDev = alt_msgdma_open((char *) SDMA_DMA_CH_1_RIGHT_NAME);

	// check if the devices was opened
	if ((pxDmaCh1LeftDev != NULL) && (pxDmaCh1RightDev != NULL)) {
		// devices opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh1LeftDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh1RightDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh1LeftDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) ||
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh1RightDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK))
		{
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bSdmaInitCh2Dmas(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma devices
	pxDmaCh2LeftDev = alt_msgdma_open((char *) SDMA_DMA_CH_2_LEFT_NAME);
	pxDmaCh2RightDev = alt_msgdma_open((char *) SDMA_DMA_CH_2_RIGHT_NAME);

	// check if the devices was opened
	if ((pxDmaCh2LeftDev != NULL) && (pxDmaCh2RightDev != NULL)) {
		// devices opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh2LeftDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh2RightDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh2LeftDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) ||
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh2RightDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK))
		{
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bSdmaInitCh3Dmas(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma devices
	pxDmaCh3LeftDev = alt_msgdma_open((char *) SDMA_DMA_CH_3_LEFT_NAME);
	pxDmaCh3RightDev = alt_msgdma_open((char *) SDMA_DMA_CH_3_RIGHT_NAME);

	// check if the devices was opened
	if ((pxDmaCh3LeftDev != NULL) && (pxDmaCh3RightDev != NULL)) {
		// devices opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh3LeftDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh3RightDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh3LeftDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) ||
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh3RightDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK))
		{
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bSdmaInitCh4Dmas(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma devices
	pxDmaCh4LeftDev = alt_msgdma_open((char *) SDMA_DMA_CH_4_LEFT_NAME);
	pxDmaCh4RightDev = alt_msgdma_open((char *) SDMA_DMA_CH_4_RIGHT_NAME);

	// check if the devices was opened
	if ((pxDmaCh4LeftDev != NULL) && (pxDmaCh4RightDev != NULL)) {
		// devices opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh4LeftDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh4RightDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh4LeftDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) ||
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh4RightDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK))
		{
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bSdmaInitCh5Dmas(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma devices
	pxDmaCh5LeftDev = alt_msgdma_open((char *) SDMA_DMA_CH_5_LEFT_NAME);
	pxDmaCh5RightDev = alt_msgdma_open((char *) SDMA_DMA_CH_5_RIGHT_NAME);

	// check if the devices was opened
	if ((pxDmaCh5LeftDev != NULL) && (pxDmaCh5RightDev != NULL)) {
		// devices opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh5LeftDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh5RightDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh5LeftDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) ||
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh5RightDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK))
		{
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bSdmaInitCh6Dmas(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma devices
	pxDmaCh6LeftDev = alt_msgdma_open((char *) SDMA_DMA_CH_6_LEFT_NAME);
	pxDmaCh6RightDev = alt_msgdma_open((char *) SDMA_DMA_CH_6_RIGHT_NAME);

	// check if the devices was opened
	if ((pxDmaCh6LeftDev != NULL) && (pxDmaCh6RightDev != NULL)) {
		// devices opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh6LeftDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaCh6RightDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh6LeftDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) ||
				(IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaCh6RightDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK))
		{
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bSdmaInitFtdiRxDma(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma device
	pxDmaFtdiRxDev = alt_msgdma_open((char *) SDMA_DMA_FTDI_RX_NAME);

	// check if the device was opened
	if (pxDmaFtdiRxDev != NULL) {
		// device opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaFtdiRxDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaFtdiRxDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bSdmaInitFtdiTxDma(void) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	// open dma device
	pxDmaFtdiTxDev = alt_msgdma_open((char *) SDMA_DMA_FTDI_TX_NAME);

	// check if the device was opened
	if (pxDmaFtdiTxDev != NULL) {
		// device opened
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaFtdiTxDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaFtdiTxDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
			usleep(1);
			usiCounter++;
			if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
				bFailDispatcher = TRUE;
				break;
			}
		}
		if (bFailDispatcher == FALSE)
			bStatus = TRUE;
	}

	return bStatus;
}

bool bSdmaResetChDma(alt_u8 ucChBufferId, alt_u8 ucBufferSide, bool bWait){
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	alt_msgdma_dev *pxChDmaDev = NULL;

	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			pxChDmaDev  = pxDmaCh1RightDev;
			break;
		case eSdmaLeftBuffer:
			pxChDmaDev = pxDmaCh1LeftDev;
			break;
		default:
			pxChDmaDev = NULL;
			break;
		}
		break;
	case eSdmaCh2Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			pxChDmaDev  = pxDmaCh2RightDev;
			break;
		case eSdmaLeftBuffer:
			pxChDmaDev = pxDmaCh2LeftDev;
			break;
		default:
			pxChDmaDev = NULL;
			break;
		}
		break;
	case eSdmaCh3Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			pxChDmaDev  = pxDmaCh3RightDev;
			break;
		case eSdmaLeftBuffer:
			pxChDmaDev = pxDmaCh3LeftDev;
			break;
		default:
			pxChDmaDev = NULL;
			break;
		}
		break;
	case eSdmaCh4Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			pxChDmaDev  = pxDmaCh4RightDev;
			break;
		case eSdmaLeftBuffer:
			pxChDmaDev = pxDmaCh4LeftDev;
			break;
		default:
			pxChDmaDev = NULL;
			break;
		}
		break;
	case eSdmaCh5Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			pxChDmaDev  = pxDmaCh5RightDev;
			break;
		case eSdmaLeftBuffer:
			pxChDmaDev = pxDmaCh5LeftDev;
			break;
		default:
			pxChDmaDev = NULL;
			break;
		}
		break;
	case eSdmaCh6Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			pxChDmaDev  = pxDmaCh6RightDev;
			break;
		case eSdmaLeftBuffer:
			pxChDmaDev = pxDmaCh6LeftDev;
			break;
		default:
			pxChDmaDev = NULL;
			break;
		}
		break;
	default:
		pxChDmaDev  = NULL;
		break;
	}

	if (pxChDmaDev != NULL) {
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxChDmaDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		if (bWait) {
			while (
					(IORD_ALTERA_MSGDMA_CSR_STATUS(pxChDmaDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK))
			{
				usleep(1);
				usiCounter++;
				if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
					bFailDispatcher = TRUE;
					break;
				}
			}
			if (bFailDispatcher == FALSE)
				bStatus = TRUE;
		} else {
			bStatus = TRUE;
		}
	}

	return bStatus;
}

bool bSdmaResetFtdiDma(bool bWait){
	bool bStatusRx = FALSE;
	bool bStatusTx = FALSE;
	bool bStatus   = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	if (pxDmaFtdiRxDev != NULL) {
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaFtdiRxDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		if (bWait) {
			while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaFtdiRxDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
				usleep(1);
				usiCounter++;
				if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
					bFailDispatcher = TRUE;
					break;
				}
			}
			if (bFailDispatcher == FALSE)
				bStatusRx = TRUE;
		} else {
			bStatusRx = TRUE;
		}
	}

	usiCounter = 0;
	bFailDispatcher = FALSE;

	if (pxDmaFtdiTxDev != NULL) {
		// reset the dispatcher
		IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaFtdiTxDev->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
		if (bWait) {
			while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaFtdiTxDev->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
				usleep(1);
				usiCounter++;
				if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
					bFailDispatcher = TRUE;
					break;
				}
			}
			if (bFailDispatcher == FALSE)
				bStatusTx = TRUE;
		} else {
			bStatusTx = TRUE;
		}
	}

	if ((bStatusRx) && (bStatusTx)) {
		bStatus = TRUE;
	}

	return (bStatus);
}

bool bSdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus;

	alt_msgdma_dev *pxDmaM1TransferDev = NULL;
	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;
	bool bBufferEmptyFlag;
	bool bChannelFlag;
	bool bAddressFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	/* Assuming that the channel selected exist, change to FALSE if doesn't */
	bChannelFlag = TRUE;
	bStatus = FALSE;
	bBufferEmptyFlag = FALSE;
	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_1_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_1_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh1RightBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh1RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_1_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_1_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh1LeftBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh1LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh2Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_2_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_2_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh2RightBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh2RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_2_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_2_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh2LeftBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh2LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh3Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_3_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_3_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh3RightBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh3RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_3_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_3_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh3LeftBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh3LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh4Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_4_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_4_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh4RightBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh4RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_4_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_4_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh4LeftBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh4LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh5Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_5_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_5_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh5RightBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh5RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_5_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_5_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh5LeftBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh5LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh6Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_6_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_6_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh6RightBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh6RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_6_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_6_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh6LeftBufferEmpty();
			pxDmaM1TransferDev = pxDmaCh6LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh7Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_7_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_7_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh7RightBufferEmpty();
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_7_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_7_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh7LeftBufferEmpty();
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh8Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_8_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_8_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh8RightBufferEmpty();
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_8_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_8_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh8LeftBufferEmpty();
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	default:
		bChannelFlag = FALSE;
		break;
	}

	uliSrcAddrLow = (alt_u32) SDMA_M1_BASE_ADDR_LOW	+ (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) SDMA_M1_BASE_ADDR_HIGH;

	// Rounding up the size to the nearest multiple of 32 (32 bytes = 256b = size of memory access)
	if ((SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) % 32) {
		// Transfer size is not a multiple of 32
		uliRoundedTransferSizeInBytes = (alt_u32)(((SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) & 0xFFFFFFE0) + 32);
	} else {
		uliRoundedTransferSizeInBytes = (alt_u32)(SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks);
	}

	// Verify if the base address is a multiple o 32 (32 bytes = 256b = size of memory access)
	if (uliSrcAddrLow % 32) {
		// Address is not a multiple of 32
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bChannelFlag) && (bBufferEmptyFlag) && (bAddressFlag) && (uliTransferSizeInBlocks <= SDMA_MAX_BLOCKS)) {

		if (pxDmaM1TransferDev != NULL) {
			// reset the dma device
			bSdmaResetChDma(ucChBufferId, ucBufferSide, TRUE);
			// hold transfers for descriptor fifo space
			while (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM1TransferDev->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
				alt_busy_sleep(1); /* delay 1us */
			}
			/* Success = 0 */
			if (0 == iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM1TransferDev,
					&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
					(alt_u32 *) uliDestAddrLow,
					uliRoundedTransferSizeInBytes, uliControlBits,
					(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
					1, 1, 1, 1, 1)	) {
				/* Success = 0 */
				if (0 == iMsgdmaExtendedDescriptorAsyncTransfer(pxDmaM1TransferDev,	&xDmaExtendedDescriptor)) {
					bStatus = TRUE;
				}
			}
		}
	}
	return bStatus;
}

bool bSdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus;

	alt_msgdma_dev *pxDmaM2TransferDev = NULL;
	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;
	bool bBufferEmptyFlag;
	bool bChannelFlag;
	bool bAddressFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	/* Assuming that the channel selected exist, change to FALSE if doesn't */
	bChannelFlag = TRUE;
	bStatus = FALSE;
	bBufferEmptyFlag = FALSE;
	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_1_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_1_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh1RightBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh1RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_1_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_1_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh1LeftBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh1LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh2Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_2_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_2_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh2RightBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh2RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_2_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_2_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh2LeftBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh2LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh3Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_3_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_3_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh3RightBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh3RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_3_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_3_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh3LeftBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh3LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh4Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_4_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_4_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh4RightBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh4RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_4_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_4_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh4LeftBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh4LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh5Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_5_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_5_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh5RightBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh5RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_5_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_5_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh5LeftBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh5LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh6Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_6_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_6_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh6RightBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh6RightDev;
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_6_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_6_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh6LeftBufferEmpty();
			pxDmaM2TransferDev = pxDmaCh6LeftDev;
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh7Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_7_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_7_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh7RightBufferEmpty();
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_7_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_7_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh7LeftBufferEmpty();
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	case eSdmaCh8Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_8_R_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_8_R_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh8RightBufferEmpty();
			break;
		case eSdmaLeftBuffer:
			uliDestAddrLow = (alt_u32) SDMA_CH_8_L_BUFF_BASE_ADDR_LOW;
			uliDestAddrHigh = (alt_u32) SDMA_CH_8_L_BUFF_BASE_ADDR_HIGH;
			bBufferEmptyFlag = bFeebGetCh8LeftBufferEmpty();
			break;
		default:
			bChannelFlag = FALSE;
			bBufferEmptyFlag = FALSE;
			break;
		}
		break;
	default:
		bChannelFlag = FALSE;
		break;
	}

	uliSrcAddrLow = (alt_u32) SDMA_M2_BASE_ADDR_LOW + (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) SDMA_M2_BASE_ADDR_HIGH;

	// Rounding up the size to the nearest multiple of 32 (32 bytes = 256b = size of memory access)
	if ((SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) % 32) {
		// Transfer size is not a multiple of 32
		uliRoundedTransferSizeInBytes = (alt_u32)(((SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) & 0xFFFFFFE0) + 32);
	} else {
		uliRoundedTransferSizeInBytes = (alt_u32)(SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks);
	}

	// Verify if the base address is a multiple o 32 (32 bytes = 256b = size of memory access)
	if (uliSrcAddrLow % 32) {
		// Address is not a multiple of 32
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bChannelFlag) && (bBufferEmptyFlag) && (bAddressFlag) && (uliTransferSizeInBlocks <= SDMA_MAX_BLOCKS)) {

		if (pxDmaM2TransferDev != NULL) {
			// reset the dma device
			bSdmaResetChDma(ucChBufferId, ucBufferSide, TRUE);
			// hold transfers for descriptor fifo space
			while (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM2TransferDev->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
				alt_busy_sleep(1); /* delay 1us */
			}
			/* Success = 0 */
			if ( 0 == iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM2TransferDev,
					&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
					(alt_u32 *) uliDestAddrLow,
					uliRoundedTransferSizeInBytes, uliControlBits,
					(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
					1, 1, 1, 1, 1)) {
				/* Success = 0 */
				if ( 0 == iMsgdmaExtendedDescriptorAsyncTransfer(pxDmaM2TransferDev, &xDmaExtendedDescriptor)) {
					bStatus = TRUE;
				}
			}
		}
	}
	return bStatus;
}

bool bFTDIDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation){
	bool bStatus;

	alt_msgdma_dev *pxDmaM1TransferDev = NULL;
	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;
	bool bAddressFlag = FALSE;
	bool bOperationFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	bStatus = FALSE;

	switch (ucFtdiOperation) {

		case eSdmaTxFtdi:
				uliSrcAddrLow   = (alt_u32) SDMA_M1_BASE_ADDR_LOW	+ (alt_u32) uliDdrInitialAddr;
				uliSrcAddrHigh  = (alt_u32) SDMA_M1_BASE_ADDR_HIGH;
				uliDestAddrLow  = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_LOW;
				uliDestAddrHigh = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_HIGH;
				pxDmaM1TransferDev = pxDmaFtdiTxDev;
				bOperationFlag = TRUE;
			break;

		case eSdmaRxFtdi:
				uliSrcAddrLow   = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_LOW;
				uliSrcAddrHigh  = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_HIGH;
				uliDestAddrLow  = (alt_u32) SDMA_M1_BASE_ADDR_LOW	+ (alt_u32) uliDdrInitialAddr;
				uliDestAddrHigh = (alt_u32) SDMA_M1_BASE_ADDR_HIGH;
				pxDmaM1TransferDev = pxDmaFtdiRxDev;
				bOperationFlag = TRUE;
			break;

		default:
			bOperationFlag = FALSE;
			break;

	}

	// Rounding up the size to the nearest multiple of FTDI_WORD_SIZE_BYTES
	if (uliTransferSizeInBytes % FTDI_WORD_SIZE_BYTES) {
		// Transfer size is not a multiple of FTDI_WORD_SIZE_BYTES
		uliRoundedTransferSizeInBytes = (alt_u32)((uliTransferSizeInBytes & 0xFFFFFFE0) + 32);
	} else {
		uliRoundedTransferSizeInBytes = uliTransferSizeInBytes;
	}

	// Verify if the base address is a multiple o FTDI_WORD_SIZE_BYTES
	if (uliSrcAddrLow % FTDI_WORD_SIZE_BYTES) {
		// Address is not a multiple of FTDI_WORD_SIZE_BYTES
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bOperationFlag) && (bAddressFlag) && (uliRoundedTransferSizeInBytes <= FTDI_BUFFER_SIZE_TRANSFER)) {

		if (pxDmaM1TransferDev != NULL) {

			// reset the dma device
			bSdmaResetFtdiDma(TRUE);

			// hold transfers for descriptor fifo space
			while (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM1TransferDev->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
				alt_busy_sleep(1); /* delay 1us */
			}

			/* Success = 0 */
			if (0 == iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM1TransferDev,
					&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
					(alt_u32 *) uliDestAddrLow,
					uliRoundedTransferSizeInBytes, uliControlBits,
					(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
					1, 1, 1, 1, 1)	) {
				/* Success = 0 */
				if (0 == iMsgdmaExtendedDescriptorAsyncTransfer(pxDmaM1TransferDev, &xDmaExtendedDescriptor)) {
					bStatus = TRUE;
				}
			}
		}
	}
	return bStatus;
}

bool bFTDIDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation){
	bool bStatus;

	alt_msgdma_dev *pxDmaM2TransferDev = NULL;
	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;
	bool bAddressFlag = FALSE;
	bool bOperationFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	bStatus = FALSE;

	switch (ucFtdiOperation) {

		case eSdmaTxFtdi:
				uliSrcAddrLow   = (alt_u32) SDMA_M2_BASE_ADDR_LOW	+ (alt_u32) uliDdrInitialAddr;
				uliSrcAddrHigh  = (alt_u32) SDMA_M2_BASE_ADDR_HIGH;
				uliDestAddrLow  = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_LOW;
				uliDestAddrHigh = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_HIGH;
				pxDmaM2TransferDev = pxDmaFtdiTxDev;
				bOperationFlag = TRUE;
			break;

		case eSdmaRxFtdi:
				uliSrcAddrLow   = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_LOW;
				uliSrcAddrHigh  = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_HIGH;
				uliDestAddrLow  = (alt_u32) SDMA_M2_BASE_ADDR_LOW	+ (alt_u32) uliDdrInitialAddr;
				uliDestAddrHigh = (alt_u32) SDMA_M2_BASE_ADDR_HIGH;
				pxDmaM2TransferDev = pxDmaFtdiRxDev;
				bOperationFlag = TRUE;
			break;

		default:
			bOperationFlag = FALSE;
			break;

	}

	// Rounding up the size to the nearest multiple of FTDI_WORD_SIZE_BYTES
	if (uliTransferSizeInBytes % FTDI_WORD_SIZE_BYTES) {
		// Transfer size is not a multiple of FTDI_WORD_SIZE_BYTES
		uliRoundedTransferSizeInBytes = (alt_u32)((uliTransferSizeInBytes & 0xFFFFFFE0) + 32);
	} else {
		uliRoundedTransferSizeInBytes = uliTransferSizeInBytes;
	}

	// Verify if the base address is a multiple o FTDI_WORD_SIZE_BYTES
	if (uliSrcAddrLow % FTDI_WORD_SIZE_BYTES) {
		// Address is not a multiple of FTDI_WORD_SIZE_BYTES
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bOperationFlag) && (bAddressFlag) && (uliRoundedTransferSizeInBytes <= FTDI_BUFFER_SIZE_TRANSFER)) {

		if (pxDmaM2TransferDev != NULL) {

			// reset the dma device
			bSdmaResetFtdiDma(TRUE);

			// hold transfers for descriptor fifo space
			while (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaM2TransferDev->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
				alt_busy_sleep(1); /* delay 1us */
			}

			/* Success = 0 */
			if ( 0 == iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaM2TransferDev,
					&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
					(alt_u32 *) uliDestAddrLow,
					uliRoundedTransferSizeInBytes, uliControlBits,
					(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
					1, 1, 1, 1, 1)) {
				/* Success = 0 */
				if ( 0 == iMsgdmaExtendedDescriptorAsyncTransfer(pxDmaM2TransferDev, &xDmaExtendedDescriptor)) {
					bStatus = TRUE;
				}
			}
		}
	}
	return bStatus;
}
