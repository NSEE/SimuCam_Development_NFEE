/*
 * simucam_dma.c
 *
 *  Created on: 10/01/2019
 *      Author: rfranca
 */

#include "simucam_dma.h"

//! [private function prototypes]
static ALT_INLINE bool ALT_ALWAYS_INLINE bSdmaInitDma(alt_u8 ucMemoryId);
static ALT_INLINE bool ALT_ALWAYS_INLINE bSdmaDmaTransfer(alt_u8 ucMemoryId, alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId);
static ALT_INLINE bool ALT_ALWAYS_INLINE bFTDIDmaTransfer(alt_u8 ucMemoryId, alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucFtdiOperation);
//! [private function prototypes]

//! [data memory public global variables]
/* Memories Address Table format: [Memory][Dword] */
const alt_32 culiSdmaMemoryAddrTable[2][2] = {
		{SDMA_M1_BASE_ADDR_LOW, SDMA_M1_BASE_ADDR_HIGH},
		{SDMA_M2_BASE_ADDR_LOW, SDMA_M2_BASE_ADDR_HIGH}
};
/* Channel Address Table format: [Channel][Side][Dword] */
const alt_32 culiSdmaChAddrTable[8][2][2] = {
		{{SDMA_CH_1_L_BUFF_BASE_ADDR_LOW, SDMA_CH_1_L_BUFF_BASE_ADDR_HIGH}, {SDMA_CH_1_R_BUFF_BASE_ADDR_LOW, SDMA_CH_1_R_BUFF_BASE_ADDR_HIGH}},
		{{SDMA_CH_2_L_BUFF_BASE_ADDR_LOW, SDMA_CH_2_L_BUFF_BASE_ADDR_HIGH}, {SDMA_CH_2_R_BUFF_BASE_ADDR_LOW, SDMA_CH_2_R_BUFF_BASE_ADDR_HIGH}},
		{{SDMA_CH_3_L_BUFF_BASE_ADDR_LOW, SDMA_CH_3_L_BUFF_BASE_ADDR_HIGH}, {SDMA_CH_3_R_BUFF_BASE_ADDR_LOW, SDMA_CH_3_R_BUFF_BASE_ADDR_HIGH}},
		{{SDMA_CH_4_L_BUFF_BASE_ADDR_LOW, SDMA_CH_4_L_BUFF_BASE_ADDR_HIGH}, {SDMA_CH_4_R_BUFF_BASE_ADDR_LOW, SDMA_CH_4_R_BUFF_BASE_ADDR_HIGH}},
		{{SDMA_CH_5_L_BUFF_BASE_ADDR_LOW, SDMA_CH_5_L_BUFF_BASE_ADDR_HIGH}, {SDMA_CH_5_R_BUFF_BASE_ADDR_LOW, SDMA_CH_5_R_BUFF_BASE_ADDR_HIGH}},
		{{SDMA_CH_6_L_BUFF_BASE_ADDR_LOW, SDMA_CH_6_L_BUFF_BASE_ADDR_HIGH}, {SDMA_CH_6_R_BUFF_BASE_ADDR_LOW, SDMA_CH_6_R_BUFF_BASE_ADDR_HIGH}},
		{{SDMA_CH_7_L_BUFF_BASE_ADDR_LOW, SDMA_CH_7_L_BUFF_BASE_ADDR_HIGH}, {SDMA_CH_7_R_BUFF_BASE_ADDR_LOW, SDMA_CH_7_R_BUFF_BASE_ADDR_HIGH}},
		{{SDMA_CH_8_L_BUFF_BASE_ADDR_LOW, SDMA_CH_8_L_BUFF_BASE_ADDR_HIGH}, {SDMA_CH_8_R_BUFF_BASE_ADDR_LOW, SDMA_CH_8_R_BUFF_BASE_ADDR_HIGH}},
	};
/* Channel Get Buffer Empty Table format: [Channel][Side] */
bool (*bSdmaGetChBufferEmptyTable[8][2])(void) = {
		{bFeebGetCh1LeftBufferEmpty, bFeebGetCh1RightBufferEmpty},
		{bFeebGetCh2LeftBufferEmpty, bFeebGetCh2RightBufferEmpty},
		{bFeebGetCh3LeftBufferEmpty, bFeebGetCh3RightBufferEmpty},
		{bFeebGetCh4LeftBufferEmpty, bFeebGetCh4RightBufferEmpty},
		{bFeebGetCh5LeftBufferEmpty, bFeebGetCh5RightBufferEmpty},
		{bFeebGetCh6LeftBufferEmpty, bFeebGetCh6RightBufferEmpty},
		{bFeebGetCh7LeftBufferEmpty, bFeebGetCh7RightBufferEmpty},
		{bFeebGetCh8LeftBufferEmpty, bFeebGetCh8RightBufferEmpty},
};
alt_msgdma_dev *pxDmaMxDev[2] = {NULL, NULL};
//! [data memory public global variables]

//! [public functions]
bool bSdmaInitM1Dma(void) {
	bool bStatus = FALSE;

	bStatus = bSdmaInitDma(eSdmaMemory0);

	return bStatus;
}

bool bSdmaInitM2Dma(void) {
	bool bStatus = FALSE;

	bStatus = bSdmaInitDma(eSdmaMemory1);

	return bStatus;
}

ALT_INLINE bool ALT_ALWAYS_INLINE bSdmaInitDma(alt_u8 ucMemoryId) {
	bool bStatus = FALSE;
	bool bFailDispatcher = FALSE;
	alt_u16 usiCounter = 0;

	if (2 > ucMemoryId) {

		// open dma device
		pxDmaMxDev[ucMemoryId] = alt_msgdma_open((char *) SDMA_DMA_M1_NAME);

		// check if the device was opened
		if (pxDmaMxDev[ucMemoryId] != NULL) {
			// device opened
			// reset the dispatcher
			IOWR_ALTERA_MSGDMA_CSR_CONTROL(pxDmaMxDev[ucMemoryId]->csr_base, ALTERA_MSGDMA_CSR_RESET_MASK);
			while (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaMxDev[ucMemoryId]->csr_base) & ALTERA_MSGDMA_CSR_RESET_STATE_MASK) {
				usleep(1);
				usiCounter++;
				if (5000 <= usiCounter) { //wait at most 5ms for the device to be reseted
					bFailDispatcher = TRUE;
					break;
				}
			}
			if (bFailDispatcher == FALSE)  {
				bStatus = TRUE;
			}
		}

	} else {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			fprintf(fp, "Memory %d DMA Initialization: CRITICAL! Memory/DMA pair %d does not exist.\n", ucMemoryId, ucMemoryId);
		}
		#endif
	}

	return bStatus;
}

bool bSdmaDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus = FALSE;

	bStatus = bSdmaDmaTransfer(eSdmaMemory0, uliDdrInitialAddr, usiTransferSizeInBlocks, ucBufferSide, ucChBufferId);

	return bStatus;
}

bool bSdmaDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus = FALSE;

	bStatus = bSdmaDmaTransfer(eSdmaMemory1, uliDdrInitialAddr, usiTransferSizeInBlocks, ucBufferSide, ucChBufferId);

	return bStatus;
}

ALT_INLINE bool ALT_ALWAYS_INLINE bSdmaDmaTransfer(alt_u8 ucMemoryId, alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBlocks, alt_u8 ucBufferSide, alt_u8 ucChBufferId) {
	bool bStatus;

	alt_msgdma_dev *pxDmaDev = NULL;
	bool bDmaMemFlag = FALSE;

	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;
	bool bBufferEmptyFlag = FALSE;
	bool bChannelFlag = FALSE;
	bool bAddressFlag = FALSE;

	alt_u16 usiRoundedTransferSizeInBytes = 0;

	/* Assign the correct DMA to the dma dev pointer */
	if (2 > ucMemoryId) {
		pxDmaDev = pxDmaMxDev[ucMemoryId];
		bDmaMemFlag = TRUE;
	}

	if (8 > ucChBufferId) {
		if (2 > ucBufferSide) {
			uliDestAddrLow = culiSdmaChAddrTable[ucChBufferId][ucBufferSide][eSdmaDwordLow];
			uliDestAddrHigh = culiSdmaChAddrTable[ucChBufferId][ucBufferSide][eSdmaDwordHigh];
			bBufferEmptyFlag = (*bSdmaGetChBufferEmptyTable[ucChBufferId][ucBufferSide])();
			bChannelFlag = TRUE;
		}
	}

	uliSrcAddrLow = (alt_u32) culiSdmaMemoryAddrTable[ucMemoryId][eSdmaDwordLow] + (alt_u32) uliDdrInitialAddr;
	uliSrcAddrHigh = (alt_u32) culiSdmaMemoryAddrTable[ucMemoryId][eSdmaDwordHigh];

	// Rounding up the size to the nearest multiple of 32 (32 bytes = 256b = size of memory access)
	if ((SDMA_PIXEL_BLOCK_SIZE_BYTES*usiTransferSizeInBlocks) % 32) {
		// Transfer size is not a multiple of 32
		usiRoundedTransferSizeInBytes = ((alt_u16) ((SDMA_PIXEL_BLOCK_SIZE_BYTES*usiTransferSizeInBlocks) / 32) + 1) * 32;
	} else {
		usiRoundedTransferSizeInBytes = (SDMA_PIXEL_BLOCK_SIZE_BYTES*usiTransferSizeInBlocks);
	}

	// Verify if the base address is a multiple o 32 (32 bytes = 256b = size of memory access)
	if (uliSrcAddrLow % 32) {
		// Address is not a multiple of 32
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bDmaMemFlag) && (bChannelFlag) && (bBufferEmptyFlag) && (bAddressFlag) && (SDMA_MAX_BLOCKS >= usiTransferSizeInBlocks)) {

		if (pxDmaDev != NULL) {
			// hold transfers for descriptor fifo space
			while (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaDev->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
				alt_busy_sleep(1); /* delay 1us */
			}
			/* Success = 0 */
			if (0 == iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaDev,
					&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
					(alt_u32 *) uliDestAddrLow,
					usiRoundedTransferSizeInBytes, uliControlBits,
					(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
					1, 1, 1, 1, 1)	) {
				/* Success = 0 */
				if (0 == iMsgdmaExtendedDescriptorAsyncTransfer(pxDmaDev,	&xDmaExtendedDescriptor)) {
					bStatus = TRUE;
				}
			}
		}
	} else {

		if (!bDmaMemFlag) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FEE Channel DMA %d Transfer: CRITICAL! Memory/DMA pair %d does not exist.\n", ucMemoryId, ucMemoryId);
			}
			#endif
		}

		if (!bChannelFlag) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FEE Channel DMA %d Transfer: CRITICAL! Channel %d or Side %d does not exist.\n", ucMemoryId, ucChBufferId, ucBufferSide);
			}
			#endif
		}

		if (!bBufferEmptyFlag) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FEE Channel DMA %d Transfer: CRITICAL! Side %d buffer of Channel %d not empty.\n", ucMemoryId, ucBufferSide, ucChBufferId);
			}
			#endif
		}

		if (!bAddressFlag) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FEE Channel DMA %d Transfer: CRITICAL! Address 0x%08lX is not 256b aligned.\n", ucMemoryId, (alt_u32)uliDdrInitialAddr);
			}
			#endif
		}

		if (SDMA_MAX_BLOCKS < usiTransferSizeInBlocks) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FEE Channel DMA %d Transfer: CRITICAL! Transfer size of %d is larger than the maximum allowed of %d blocks.\n", ucMemoryId, usiTransferSizeInBlocks, SDMA_MAX_BLOCKS);
			}
			#endif
		}

	}
	return bStatus;
}

bool bFTDIDmaM1Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucFtdiOperation){
	bool bStatus = FALSE;

	bStatus = bFTDIDmaTransfer(eSdmaMemory0, uliDdrInitialAddr, usiTransferSizeInBytes, ucFtdiOperation);

	return bStatus;
}

bool bFTDIDmaM2Transfer(alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucFtdiOperation){
	bool bStatus = FALSE;

	bStatus = bFTDIDmaTransfer(eSdmaMemory1, uliDdrInitialAddr, usiTransferSizeInBytes, ucFtdiOperation);

	return bStatus;
}

ALT_INLINE bool ALT_ALWAYS_INLINE bFTDIDmaTransfer(alt_u8 ucMemoryId, alt_u32 *uliDdrInitialAddr, alt_u16 usiTransferSizeInBytes, alt_u8 ucFtdiOperation){
	bool bStatus;

	alt_msgdma_dev *pxDmaDev = NULL;
	bool bDmaMemFlag = FALSE;

	alt_msgdma_extended_descriptor xDmaExtendedDescriptor;

	alt_u32 uliDestAddrLow = 0;
	alt_u32 uliDestAddrHigh = 0;

	alt_u32 uliSrcAddrLow = 0;
	alt_u32 uliSrcAddrHigh = 0;

	alt_u32 uliControlBits = 0x00000000;
	bool bAddressFlag = FALSE;
	bool bOperationFlag = FALSE;

	alt_u16 usiRoundedTransferSizeInBytes = 0;

	bStatus = FALSE;

	/* Assign the correct DMA to the dma dev pointer */
	if (2 > ucMemoryId) {
		pxDmaDev = pxDmaMxDev[ucMemoryId];
		bDmaMemFlag = TRUE;
	}

	switch (ucFtdiOperation) {

		case eSdmaTxFtdi:
				uliSrcAddrLow   = (alt_u32) culiSdmaMemoryAddrTable[ucMemoryId][eSdmaDwordLow]	+ (alt_u32) uliDdrInitialAddr;
				uliSrcAddrHigh  = (alt_u32) culiSdmaMemoryAddrTable[ucMemoryId][eSdmaDwordHigh];
				uliDestAddrLow  = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_LOW;
				uliDestAddrHigh = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_HIGH;
				bOperationFlag = TRUE;
			break;

		case eSdmaRxFtdi:
				uliSrcAddrLow   = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_LOW;
				uliSrcAddrHigh  = (alt_u32) SDMA_FTDI_BUFF_BASE_ADDR_HIGH;
				uliDestAddrLow  = (alt_u32) culiSdmaMemoryAddrTable[ucMemoryId][eSdmaDwordLow]	+ (alt_u32) uliDdrInitialAddr;
				uliDestAddrHigh = (alt_u32) culiSdmaMemoryAddrTable[ucMemoryId][eSdmaDwordHigh];
				bOperationFlag = TRUE;
			break;

		default:
			bOperationFlag = FALSE;
			break;

	}

	// Rounding up the size to the nearest multiple of 8 (8 bytes = 64b = size of memory access)
	if (usiRoundedTransferSizeInBytes % 8) {
		// Transfer size is not a multiple of 8
		usiRoundedTransferSizeInBytes = ((alt_u16) (usiTransferSizeInBytes / 8) + 1) * 8;
	} else {
		usiRoundedTransferSizeInBytes = usiTransferSizeInBytes;
	}

	// Verify if the base address is a multiple o 8 (8 bytes = 64b = size of memory access)
	if (uliSrcAddrLow % 8) {
		// Address is not a multiple of 8
		bAddressFlag = FALSE;
	} else {
		bAddressFlag = TRUE;
	}

	if ((bDmaMemFlag) && (bOperationFlag) && (bAddressFlag) && (FTDI_BUFFER_SIZE_TRANSFER >= usiRoundedTransferSizeInBytes)) {

		if (pxDmaDev != NULL) {
			// hold transfers for descriptor fifo space
			while (0 != (IORD_ALTERA_MSGDMA_CSR_STATUS(pxDmaDev->csr_base) & ALTERA_MSGDMA_CSR_DESCRIPTOR_BUFFER_FULL_MASK)) {
				alt_busy_sleep(1); /* delay 1us */
			}
			/* Success = 0 */
			if (0 == iMsgdmaConstructExtendedMmToMmDescriptor(pxDmaDev,
					&xDmaExtendedDescriptor, (alt_u32 *) uliSrcAddrLow,
					(alt_u32 *) uliDestAddrLow,
					usiRoundedTransferSizeInBytes, uliControlBits,
					(alt_u32 *) uliSrcAddrHigh, (alt_u32 *) uliDestAddrHigh,
					1, 1, 1, 1, 1)	) {
				/* Success = 0 */
				if (0 == iMsgdmaExtendedDescriptorAsyncTransfer(pxDmaDev,	&xDmaExtendedDescriptor)) {
					bStatus = TRUE;
				}
			}
		}
	} else {

		if (!bDmaMemFlag) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 DMA %d Transfer: CRITICAL! Memory/DMA pair %d does not exist.\n", ucMemoryId, ucMemoryId);
			}
			#endif
		}

		if (!bOperationFlag) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 DMA %d Transfer: CRITICAL! Operation %d does not exist.\n", ucMemoryId, ucFtdiOperation);
			}
			#endif
		}

		if (!bAddressFlag) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 DMA %d Transfer: CRITICAL! Address 0x%08lX is not 256b aligned.\n", ucMemoryId, (alt_u32)uliDdrInitialAddr);
			}
			#endif
		}

		if (FTDI_BUFFER_SIZE_TRANSFER < usiRoundedTransferSizeInBytes) {
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "FTDI USB3 DMA %d Transfer: CRITICAL! Transfer size of %d is larger than the maximum allowed of %d bytes.\n", ucMemoryId, usiTransferSizeInBytes, FTDI_BUFFER_SIZE_TRANSFER);
			}
			#endif
		}

	}
	return bStatus;
}

