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
//! [data memory public global variables]

//! [public functions]
bool bSdmaInitCh1Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitCh2Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitCh3Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitCh4Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitCh5Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitCh6Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitFtdiRxDma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitFtdiTxDma(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaResetChDma(alt_u8 ucChBufferId, alt_u8 ucBufferSide, bool bWait){
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;

	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
		break;
	case eSdmaCh2Buffer:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
		break;
	case eSdmaCh3Buffer:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
		break;
	case eSdmaCh4Buffer:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
		break;
	case eSdmaCh5Buffer:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
		break;
	case eSdmaCh6Buffer:
		vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
		break;
	default:
		vpxCommChannel = NULL;
		break;
	}

	if (vpxCommChannel != NULL) {

		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.bRightRdReset = TRUE;
			if (bWait) {
				// wait for the avm controller to be free
				while (vpxCommChannel->xFeeBuffer.xFeebBufferDataStatus.bRightRdBusy) {
					alt_busy_sleep(1); /* delay 1us */
				}
			}
			bStatus = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.bLeftRdReset = TRUE;
			if (bWait) {
				// wait for the avm controller to be free
				while (vpxCommChannel->xFeeBuffer.xFeebBufferDataStatus.bLeftRdBusy) {
					alt_busy_sleep(1); /* delay 1us */
				}
			}
			bStatus = TRUE;
			break;
		default:
			bStatus = FALSE;
			break;
		}

	}

	return bStatus;
}

bool bSdmaResetFtdiDma(bool bWait){
	bool bStatusRx = FALSE;
	bool bStatusTx = FALSE;
	bool bStatus   = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	vpxFtdiModule->xFtdiDataControl.bRxWrReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxFtdiModule->xFtdiDataStatus.bRxWrBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatusRx = TRUE;

	vpxFtdiModule->xFtdiDataControl.bTxRdReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxFtdiModule->xFtdiDataStatus.bTxRdBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatusTx = TRUE;

	if ((bStatusRx) && (bStatusTx)) {
		bStatus = TRUE;
	}

	return (bStatus);
}

bool bSdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus = FALSE;

	volatile TCommChannel *vpxCommChannel = NULL;

	union MemoryAddress unMemoryAddress;

	bool bBufferEmptyFlag = FALSE;;
	bool bChannelFlag = FALSE;;
	bool bAddressFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh1RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh1LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh2RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh2LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh3RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh3LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh4RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh4LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh5RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh5LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh6RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh6LeftBufferEmpty();
			bChannelFlag = TRUE;
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

	unMemoryAddress.ulliMemAddr64b = SDMA_M1_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);

	// Rounding up the size to the nearest multiple of 32 (32 bytes = 256b = size of memory access)
	if ((SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) % 32) {
		// Transfer size is not a multiple of 32
		uliRoundedTransferSizeInBytes = (alt_u32)(((SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) & 0xFFFFFFE0) + 32);
	} else {
		uliRoundedTransferSizeInBytes = (alt_u32)(SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks);
	}

	// Verify if the base address is a multiple o 32 (32 bytes = 256b = size of memory access)
	if (unMemoryAddress.ulliMemAddr64b % 32) {
		// Address is not a multiple of 32
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bChannelFlag) && (bBufferEmptyFlag) && (bAddressFlag) && (uliTransferSizeInBlocks <= SDMA_MAX_BLOCKS)) {

		// reset the avm controller
		bSdmaResetChDma(ucChBufferId, ucBufferSide, TRUE);

		if (eSdmaRightBuffer == ucBufferSide) {
			// start new transfer
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdDataLenghtBytes = uliRoundedTransferSizeInBytes;
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.bRightRdStart = TRUE;
			bStatus = TRUE;
		} else {
			// start new transfer
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdDataLenghtBytes = uliRoundedTransferSizeInBytes;
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.bLeftRdStart = TRUE;
			bStatus = TRUE;
		}

	}
	return bStatus;
}

bool bSdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus = FALSE;

	volatile TCommChannel *vpxCommChannel = NULL;

	union MemoryAddress unMemoryAddress;

	bool bBufferEmptyFlag = FALSE;;
	bool bChannelFlag = FALSE;;
	bool bAddressFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		switch (ucBufferSide) {
		case eSdmaRightBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh1RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_1_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh1LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh2RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_2_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh2LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh3RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_3_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh3LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh4RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_4_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh4LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh5RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_5_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh5LeftBufferEmpty();
			bChannelFlag = TRUE;
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
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh6RightBufferEmpty();
			bChannelFlag = TRUE;
			break;
		case eSdmaLeftBuffer:
			vpxCommChannel = (TCommChannel *)(COMM_CHANNEL_6_BASE_ADDR);
			bBufferEmptyFlag = bFeebGetCh6LeftBufferEmpty();
			bChannelFlag = TRUE;
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

	unMemoryAddress.ulliMemAddr64b = SDMA_M2_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);

	// Rounding up the size to the nearest multiple of 32 (32 bytes = 256b = size of memory access)
	if ((SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) % 32) {
		// Transfer size is not a multiple of 32
		uliRoundedTransferSizeInBytes = (alt_u32)(((SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) & 0xFFFFFFE0) + 32);
	} else {
		uliRoundedTransferSizeInBytes = (alt_u32)(SDMA_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks);
	}

	// Verify if the base address is a multiple o 32 (32 bytes = 256b = size of memory access)
	if (unMemoryAddress.ulliMemAddr64b % 32) {
		// Address is not a multiple of 32
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bChannelFlag) && (bBufferEmptyFlag) && (bAddressFlag) && (uliTransferSizeInBlocks <= SDMA_MAX_BLOCKS)) {

		// reset the avm controller
		bSdmaResetChDma(ucChBufferId, ucBufferSide, TRUE);

		if (eSdmaRightBuffer == ucBufferSide) {
			// start new transfer
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdDataLenghtBytes = uliRoundedTransferSizeInBytes;
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.bRightRdStart = TRUE;
			bStatus = TRUE;
		} else {
			// start new transfer
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdDataLenghtBytes = uliRoundedTransferSizeInBytes;
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.bLeftRdStart = TRUE;
			bStatus = TRUE;
		}

	}
	return bStatus;
}

bool bFTDIDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation){
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	union MemoryAddress unMemoryAddress;

	bool bAddressFlag = FALSE;
	bool bOperationFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucFtdiOperation) {

		case eSdmaTxFtdi:
			unMemoryAddress.ulliMemAddr64b = SDMA_M1_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);
			bOperationFlag = TRUE;
			break;

		case eSdmaRxFtdi:
			unMemoryAddress.ulliMemAddr64b = SDMA_M1_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);
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
	if (unMemoryAddress.ulliMemAddr64b % FTDI_WORD_SIZE_BYTES) {
		// Address is not a multiple of FTDI_WORD_SIZE_BYTES
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bOperationFlag) && (bAddressFlag) && (uliRoundedTransferSizeInBytes <= FTDI_BUFFER_SIZE_TRANSFER)) {

		// reset the avm controller
		bSdmaResetFtdiDma(TRUE);

		if (eSdmaTxFtdi == ucFtdiOperation) {
			// start new transfer
			vpxFtdiModule->xFtdiDataControl.uliTxRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxFtdiModule->xFtdiDataControl.uliTxRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			vpxFtdiModule->xFtdiDataControl.uliTxRdDataLenghtBytes = uliRoundedTransferSizeInBytes;
			vpxFtdiModule->xFtdiDataControl.bTxRdStart = TRUE;
			bStatus = TRUE;
		} else {
			// start new transfer
			vpxFtdiModule->xFtdiDataControl.uliRxWrInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxFtdiModule->xFtdiDataControl.uliRxWrInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			vpxFtdiModule->xFtdiDataControl.uliRxWrDataLenghtBytes = uliRoundedTransferSizeInBytes;
			vpxFtdiModule->xFtdiDataControl.bRxWrStart = TRUE;
			bStatus = TRUE;
		}

	}
	return bStatus;
}

bool bFTDIDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation){
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	union MemoryAddress unMemoryAddress;

	bool bAddressFlag = FALSE;
	bool bOperationFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucFtdiOperation) {

		case eSdmaTxFtdi:
			unMemoryAddress.ulliMemAddr64b = SDMA_M2_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);
			bOperationFlag = TRUE;
			break;

		case eSdmaRxFtdi:
			unMemoryAddress.ulliMemAddr64b = SDMA_M2_BASE_ADDR + (alt_u64)((alt_u32)uliDdrInitialAddr);
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
	if (unMemoryAddress.ulliMemAddr64b % FTDI_WORD_SIZE_BYTES) {
		// Address is not a multiple of FTDI_WORD_SIZE_BYTES
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bOperationFlag) && (bAddressFlag) && (uliRoundedTransferSizeInBytes <= FTDI_BUFFER_SIZE_TRANSFER)) {

		// reset the avm controller
		bSdmaResetFtdiDma(TRUE);

		if (eSdmaTxFtdi == ucFtdiOperation) {
			// start new transfer
			vpxFtdiModule->xFtdiDataControl.uliTxRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxFtdiModule->xFtdiDataControl.uliTxRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			vpxFtdiModule->xFtdiDataControl.uliTxRdDataLenghtBytes = uliRoundedTransferSizeInBytes;
			vpxFtdiModule->xFtdiDataControl.bTxRdStart = TRUE;
			bStatus = TRUE;
		} else {
			// start new transfer
			vpxFtdiModule->xFtdiDataControl.uliRxWrInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxFtdiModule->xFtdiDataControl.uliRxWrInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			vpxFtdiModule->xFtdiDataControl.uliRxWrDataLenghtBytes = uliRoundedTransferSizeInBytes;
			vpxFtdiModule->xFtdiDataControl.bRxWrStart = TRUE;
			bStatus = TRUE;
		}

	}
	return bStatus;
}
