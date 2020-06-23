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
bool bSdmaInitComm1Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitComm2Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitComm3Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitComm4Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitComm5Dmas(void) {
	bool bStatus = TRUE;
	return bStatus;
}

bool bSdmaInitComm6Dmas(void) {
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

bool bSdmaResetCommDma(alt_u8 ucChBufferId, alt_u8 ucBufferSide, bool bWait) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;

	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		break;
	case eSdmaCh2Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		break;
	case eSdmaCh3Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		break;
	case eSdmaCh4Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		break;
	case eSdmaCh5Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		break;
	case eSdmaCh6Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
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

bool bSdmaResetFtdiDma(bool bWait) {
	bool bStatusRx = FALSE;
	bool bStatusTx = FALSE;
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);

	vpxFtdiModule->xFtdiRxDataControl.bRxWrReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxFtdiModule->xFtdiRxDataStatus.bRxWrBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatusRx = TRUE;

	vpxFtdiModule->xFtdiTxDataControl.bTxRdReset = TRUE;
	if (bWait) {
		// wait for the avm controller to be free
		while (vpxFtdiModule->xFtdiTxDataStatus.bTxRdBusy) {
			alt_busy_sleep(1); /* delay 1us */
		}
	}
	bStatusTx = TRUE;

	if ((bStatusRx) && (bStatusTx)) {
		bStatus = TRUE;
	}

	return (bStatus);
}

bool bSdmaCommDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus = FALSE;

	volatile TCommChannel *vpxCommChannel = NULL;

	union Ddr2MemoryAddress unMemoryAddress;

	bool bMemoryFlag = FALSE;
	bool bAddressFlag = FALSE;
	bool bChannelFlag = FALSE;
	bool bBufferEmptyFlag = FALSE;
	bool bNotBusyFlag = FALSE;
	bool bTransferSizeFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucDdrMemId) {
	case eDdr2Memory1:
		unMemoryAddress.ulliMemAddr64b = DDR2_M1_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	case eDdr2Memory2:
		unMemoryAddress.ulliMemAddr64b = DDR2_M2_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	default:
		bMemoryFlag = FALSE;
		break;
	}

	/* Verify if the base address is a multiple o FEEB_DATA_ACCESS_WIDTH_BYTES (DSCH_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
	if (unMemoryAddress.ulliMemAddr64b % FEEB_DATA_ACCESS_WIDTH_BYTES) {
		/* Address is not a multiple of FEEB_DATA_ACCESS_WIDTH_BYTES */
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	switch (ucChBufferId) {
	case eSdmaCh1Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eSdmaCh2Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eSdmaCh3Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eSdmaCh4Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eSdmaCh5Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	case eSdmaCh6Buffer:
		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		bChannelFlag = TRUE;
		break;
	default:
		bChannelFlag = FALSE;
		break;
	}

	switch (ucBufferSide) {
	case eSdmaRightBuffer:
		bBufferEmptyFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
		bNotBusyFlag = !(vpxCommChannel->xFeeBuffer.xFeebBufferDataStatus.bRightRdBusy);
		break;
	case eSdmaLeftBuffer:
		bBufferEmptyFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
		bNotBusyFlag = !(vpxCommChannel->xFeeBuffer.xFeebBufferDataStatus.bLeftRdBusy);
		break;
	default:
		bBufferEmptyFlag = FALSE;
		bNotBusyFlag = FALSE;
		break;
	}

	if ((FEEB_TRANSFER_MIN_BLOCKS <= uliTransferSizeInBlocks) && (FEEB_TRANSFER_MAX_BLOCKS >= uliTransferSizeInBlocks)) {
		bTransferSizeFlag = TRUE;
		/* Rounding up the size to the nearest multiple of FEEB_DATA_ACCESS_WIDTH_BYTES (FEEB_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
		if ((FEEB_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) % FEEB_DATA_ACCESS_WIDTH_BYTES) {
			/* Transfer size is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
			uliRoundedTransferSizeInBytes = (alt_u32) (((FEEB_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks) & FEEB_DATA_TRANSFER_SIZE_MASK ) + FEEB_DATA_ACCESS_WIDTH_BYTES );
		} else {
			uliRoundedTransferSizeInBytes = (alt_u32) (FEEB_PIXEL_BLOCK_SIZE_BYTES * uliTransferSizeInBlocks);
		}
	}

	if ((bMemoryFlag) && (bAddressFlag) && (bChannelFlag) && (bBufferEmptyFlag) && (bNotBusyFlag) && (bTransferSizeFlag)) {

		// reset the avm controller
		bSdmaResetCommDma(ucChBufferId, ucBufferSide, TRUE);

		if (eSdmaRightBuffer == ucBufferSide) {
			// start new transfer
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			/* HW use zero as reference for transfer size, need to decrement one word from the total transfer size */
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliRightRdDataLenghtBytes = uliRoundedTransferSizeInBytes - FEEB_DATA_ACCESS_WIDTH_BYTES;
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.bRightRdStart = TRUE;
			bStatus = TRUE;
		} else {
			// start new transfer
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			/* HW use zero as reference for transfer size, need to decrement one word from the total transfer size */
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.uliLeftRdDataLenghtBytes = uliRoundedTransferSizeInBytes - FEEB_DATA_ACCESS_WIDTH_BYTES;
			vpxCommChannel->xFeeBuffer.xFeebBufferDataControl.bLeftRdStart = TRUE;
			bStatus = TRUE;
		}

	}

	return (bStatus);
}

bool bSdmaFtdiDmaTransfer(alt_u8 ucDdrMemId, alt_u32 *uliDdrInitialAddr, alt_u32 uliTransferSizeInBytes, alt_u8 ucFtdiOperation) {
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);

	union Ddr2MemoryAddress unMemoryAddress;

	bool bMemoryFlag = FALSE;
	bool bAddressFlag = FALSE;
	bool bOperationFlag = FALSE;
	bool bNotBusyFlag = FALSE;
	bool bTransferSizeFlag = FALSE;

	alt_u32 uliRoundedTransferSizeInBytes = 0;

	switch (ucDdrMemId) {
	case eDdr2Memory1:
		unMemoryAddress.ulliMemAddr64b = DDR2_M1_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	case eDdr2Memory2:
		unMemoryAddress.ulliMemAddr64b = DDR2_M2_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		bMemoryFlag = TRUE;
		break;
	default:
		bMemoryFlag = FALSE;
		break;
	}

	/* Verify if the base address is a multiple o FTDI_DATA_ACCESS_WIDTH_BYTES (DSCH_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
	if (unMemoryAddress.ulliMemAddr64b % FTDI_DATA_ACCESS_WIDTH_BYTES) {
		/* Address is not a multiple of FTDI_DATA_ACCESS_WIDTH_BYTES */
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	switch (ucFtdiOperation) {
	case eSdmaTxFtdi:
		bOperationFlag = TRUE;
		bNotBusyFlag = !(vpxFtdiModule->xFtdiTxDataStatus.bTxRdBusy);
		break;
	case eSdmaRxFtdi:
		bOperationFlag = TRUE;
		bNotBusyFlag = !(vpxFtdiModule->xFtdiRxDataStatus.bRxWrBusy);
		break;
	default:
		bOperationFlag = FALSE;
		bNotBusyFlag = FALSE;
		break;
	}

	if ((FTDI_TRANSFER_MIN_BYTES <= uliTransferSizeInBytes) && (FTDI_TRANSFER_MAX_BYTES >= uliTransferSizeInBytes)) {
		bTransferSizeFlag = TRUE;
		/* Rounding up the size to the nearest multiple of FTDI_DATA_ACCESS_WIDTH_BYTES (FTDI_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
		if (uliTransferSizeInBytes % FTDI_DATA_ACCESS_WIDTH_BYTES) {
			/* Transfer size is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
			uliRoundedTransferSizeInBytes = (alt_u32) ((uliTransferSizeInBytes & FTDI_DATA_TRANSFER_SIZE_MASK ) + FTDI_DATA_ACCESS_WIDTH_BYTES );
		} else {
			uliRoundedTransferSizeInBytes = uliTransferSizeInBytes;
		}
	}

	if ((bMemoryFlag) && (bAddressFlag) && (bOperationFlag) && (bNotBusyFlag) && (bTransferSizeFlag)) {

		// reset the avm controller
		bSdmaResetFtdiDma(TRUE);

		if (eSdmaTxFtdi == ucFtdiOperation) {
			// start new transfer
			vpxFtdiModule->xFtdiTxDataControl.uliTxRdInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxFtdiModule->xFtdiTxDataControl.uliTxRdInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			/* HW use zero as reference for transfer size, need to decrement one word from the total transfer size */
			vpxFtdiModule->xFtdiTxDataControl.uliTxRdDataLenghtBytes = uliRoundedTransferSizeInBytes - FTDI_DATA_ACCESS_WIDTH_BYTES;
			vpxFtdiModule->xFtdiTxDataControl.bTxRdStart = TRUE;
			bStatus = TRUE;
		} else {
			// start new transfer
			vpxFtdiModule->xFtdiRxDataControl.uliRxWrInitAddrLowDword = unMemoryAddress.uliMemAddr32b[0];
			vpxFtdiModule->xFtdiRxDataControl.uliRxWrInitAddrHighDword = unMemoryAddress.uliMemAddr32b[1];
			/* HW use zero as reference for transfer size, need to decrement one word from the total transfer size */
			vpxFtdiModule->xFtdiRxDataControl.uliRxWrDataLenghtBytes = uliRoundedTransferSizeInBytes - FTDI_DATA_ACCESS_WIDTH_BYTES;
			vpxFtdiModule->xFtdiRxDataControl.bRxWrStart = TRUE;
			bStatus = TRUE;
		}

	}

	return (bStatus);
}
