/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>

#include "simucam_definitions.h"
#include "api_driver/ddr2/ddr2.h"
#include "api_driver/simucam_dma/simucam_dma.h"
#include "driver/ftdi/ftdi.h"
#include "crc.h"
#include "pattern.h"

FILE* fp;

int iTimeStart, iTimeElapsed = 0;

void vProtocolUsbTestAck(alt_u32 uliMemOffset, alt_u32 uliMemOffInc, alt_u8 ucMemId, alt_u8 ucFee, alt_u8 ucCcd, alt_u8 ucSide, alt_u16 usiHeight, alt_u16 usiWidth, alt_u16 usiExpNum, bool bMemDump, bool bVerbose);
//void vProtocolUsbTestNack(void);
//void vProtocolUsbTestWrongCrc(void);
void vFillCheckMemoryPattern(alt_u32 uliMemReplyOffset, alt_u32 uliMemPayloadOffset, alt_u32 uliMemPatternOffset, alt_u8 ucMemId, alt_u8 ucCcd, alt_u8 ucSide, alt_u16 usiHeight, alt_u16 usiWidth, alt_u16 usiExpNum, bool bMemDump);
//alt_u32 uliLittleToBigEndian(alt_u32 uliLittleEndianDword);
alt_u32 uliLittleToBigEndianPixel(alt_u32 uliLittleEndianDword);
void vLittleToBigEndianMask(alt_u32 uliLittleEndianDword[2]);
bool vFtdiInitIrq(void) ;

alt_u32 uliInitialState;

volatile alt_u32 uliPaylodOffset;
volatile bool bStopRx;

typedef struct PixelBlock {
	alt_u16 usiPixels[64];
	alt_u64 ulliMask;
} TPixelBlock;

typedef struct HalfCcdImage {
	TPixelBlock xPixelBlocks[162802];
} THalfCcdImage;

static volatile int viFtdiHoldContext;

void vFtdiHandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *)FTDI_MODULE_BASE_ADDR;
	alt_u32 uliTransferSize = 0;

	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxBuff0RdableIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuff0RdableIrqFlagClr = TRUE;

		uliTransferSize = vpxFtdiModule->xFtdiRxBufferStatus.usiRxBuff0UsedBytes;
		bSdmaDmaM2FtdiTransfer((alt_u32 *)uliPaylodOffset, uliTransferSize, eSdmaRxFtdi);
		uliPaylodOffset += uliTransferSize;

		if (uliTransferSize < FTDI_BUFFER_SIZE_TRANSFER) {
			bStopRx = TRUE;
		}

	}

	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxBuff1RdableIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuff1RdableIrqFlagClr = TRUE;

		uliTransferSize = vpxFtdiModule->xFtdiRxBufferStatus.usiRxBuff1UsedBytes;
		bSdmaDmaM2FtdiTransfer((alt_u32 *)uliPaylodOffset, uliTransferSize, eSdmaRxFtdi);
		uliPaylodOffset += uliTransferSize;

		if (uliTransferSize < FTDI_BUFFER_SIZE_TRANSFER) {
			bStopRx = TRUE;
		}

	}

	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxBuffLastRdableIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuffLastRdableIrqFlagClr = TRUE;

		uliTransferSize = vpxFtdiModule->xFtdiRxBufferStatus.usiRxDbuffUsedBytes;
		bSdmaDmaM2FtdiTransfer((alt_u32 *)uliPaylodOffset, uliTransferSize, eSdmaRxFtdi);
		uliPaylodOffset += uliTransferSize;

	}

	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxBuffLastEmptyIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxBuffLastEmptyIrqFlagClr = TRUE;

		uliTransferSize = 0;
		bStopRx = TRUE;

	}

	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxCommErrIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxCommErrIrqFlagClr = TRUE;

		uliTransferSize = 0;
		bStopRx = TRUE;

	}

}

int main() {
	printf("Hello from Nios II!\n\n");

	THalfCcdImage *pxHalfCcdImage = (THalfCcdImage *) DDR2_EXT_ADDR_WINDOWED_BASE;

	TFtdiModule *pxFtdi = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	bDdr2SwitchMemory(DDR2_M2_ID);
	bSdmaInitM2Dma();

	// Stop and Clear Channel
	pxFtdi->xFtdiFtdiModuleControl.bModuleLoopbackEn = FALSE;
	pxFtdi->xFtdiFtdiModuleControl.bModuleStop = TRUE;
	pxFtdi->xFtdiFtdiModuleControl.bModuleClear = TRUE;

//	// Start Channel
//	pxFtdi->xFtdiFtdiModuleControl.bModuleStart = TRUE;
//
//	// Enable Loopback
//	pxFtdi->xFtdiFtdiModuleControl.bModuleLoopbackEn = TRUE;
//	printf("Loopback Enabled! \n");
//
//	while (1) {}

	//Enable IRQs
	pxFtdi->xFtdiRxIrqControl.bRxBuff0RdableIrqEn = TRUE;
	pxFtdi->xFtdiRxIrqControl.bRxBuff1RdableIrqEn = TRUE;
	pxFtdi->xFtdiRxIrqControl.bRxBuffLastRdableIrqEn = TRUE;
	pxFtdi->xFtdiRxIrqControl.bRxBuffLastEmptyIrqEn = TRUE;
	pxFtdi->xFtdiRxIrqControl.bRxCommErrIrqEn = TRUE;
	pxFtdi->xFtdiFtdiIrqControl.bFtdiGlobalIrqEn = TRUE;
	vFtdiInitIrq();

	alt_u32 uliDataCnt = 0;
	alt_u64 *pulliDataAddr = (alt_u64 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (uliDataCnt = 0; uliDataCnt < 2767634; uliDataCnt++) {
		*pulliDataAddr = 0x5555555555555555;
		pulliDataAddr++;
	}

	usleep(1*1000*1000);

	printf("Ready! \n\n");

	alt_u8 ucCcdCnt = 0;
	alt_u8 ucFeeCnt = 0;
	alt_u16 usiExpNumCnt = 0;
	alt_u32 uliTransactionCnt = 0;

//	vProtocolUsbTestAck(DDR2_EXT_ADDR_WINDOWED_BASE, 0x4000000, DDR2_M2_ID, ucFeeCnt, ucCcdCnt, 0, 5000, 3000, usiExpNumCnt, FALSE, TRUE);

	int iTimeSync = 0;
	int iTimeSyncElapsed = 0;

	for (usiExpNumCnt = 0; usiExpNumCnt < 28; usiExpNumCnt++) {
		iTimeStart = alt_nticks();
		iTimeSync = alt_nticks();
		for (ucFeeCnt = 0; ucFeeCnt < 6; ucFeeCnt++) {
			for (ucCcdCnt = 0; ucCcdCnt < 4; ucCcdCnt++) {
				printf("Transaction: %ld \n", uliTransactionCnt); uliTransactionCnt++;
				vProtocolUsbTestAck(DDR2_EXT_ADDR_WINDOWED_BASE, 0x4000000, DDR2_M2_ID, ucFeeCnt, ucCcdCnt, 0, 4540, 2295, usiExpNumCnt, FALSE, FALSE);
//				vProtocolUsbTestAck(DDR2_EXT_ADDR_WINDOWED_BASE, 0x4000000, DDR2_M2_ID, 3, 2, 1, 100, 50, 5, FALSE, FALSE);
				printf("Transaction: %ld \n", uliTransactionCnt); uliTransactionCnt++;
				vProtocolUsbTestAck(DDR2_EXT_ADDR_WINDOWED_BASE, 0x4000000, DDR2_M2_ID, ucFeeCnt, ucCcdCnt, 1, 4540, 2295, usiExpNumCnt, FALSE, FALSE);
			}
		}

		iTimeElapsed = alt_nticks() - iTimeStart;
		printf("USB data written, size=%d bytes, %.3f sec\n", 0, (float) iTimeElapsed / (float) alt_ticks_per_second());

		iTimeSyncElapsed = alt_nticks() - iTimeSync;
		while (((float) iTimeSyncElapsed / (float) alt_ticks_per_second()) < 25.0) {
			usleep(1000);
			iTimeSyncElapsed = alt_nticks() - iTimeSync;
		}

	}

//	for (usiExpNumCnt = 0; usiExpNumCnt < 16; usiExpNumCnt++) {
//		iTimeStart = alt_nticks();
//		iTimeSync = alt_nticks();
//		for (ucFeeCnt = 0; ucFeeCnt < 1; ucFeeCnt++) {
//			for (ucCcdCnt = 0; ucCcdCnt < 4; ucCcdCnt++) {
//				printf("Transaction: %ld \n", uliTransactionCnt); uliTransactionCnt++;
//				vProtocolUsbTestAck(DDR2_EXT_ADDR_WINDOWED_BASE, 0x4000000, DDR2_M2_ID, ucFeeCnt, ucCcdCnt, 0, 4540/2, 2295, usiExpNumCnt, FALSE, FALSE);
//				printf("Transaction: %ld \n", uliTransactionCnt); uliTransactionCnt++;
//				vProtocolUsbTestAck(DDR2_EXT_ADDR_WINDOWED_BASE, 0x4000000, DDR2_M2_ID, ucFeeCnt, ucCcdCnt, 1, 4540/2, 2295, usiExpNumCnt, FALSE, FALSE);
//			}
//		}
//
//		iTimeElapsed = alt_nticks() - iTimeStart;
//		printf("USB data written, size=%d bytes, %.3f sec\n", 0, (float) iTimeElapsed / (float) alt_ticks_per_second());
//
//		iTimeSyncElapsed = alt_nticks() - iTimeSync;
//		while (((float) iTimeSyncElapsed / (float) alt_ticks_per_second()) < 2.5) {
//			usleep(1000);
//			iTimeSyncElapsed = alt_nticks() - iTimeSync;
//		}
//
//	}

	printf("Finished!! \n");

	while (1) {}

	return 0;
}

bool vFtdiInitIrq(void) {
	bool bStatus = FALSE;
	void* pvHoldContext;

	// Recast the hold_context pointer to match the alt_irq_register() function
	// prototype.
	pvHoldContext = (void*) &viFtdiHoldContext;
	// Register the interrupt handler
	alt_irq_register(4, pvHoldContext, vFtdiHandleIrq);
	bStatus = TRUE;

	return bStatus;
}

//void vProtocolUsbTestNack(void){
//
//	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) FTDI_MODULE_BASE_ADDR;
//	TFtdiProtocolHeader *pxFtdiProtHeader = (TFtdiProtocolHeader *) DDR2_EXT_ADDR_WINDOWED_BASE;
//	TFtdiProtocolHeader *pxFtdiProtReply = (TFtdiProtocolHeader *) DDR2_EXT_ADDR_WINDOWED_BASE;
//
//	int i = 0;
//
//	// Prepare Header
//	pxFtdiProtHeader->uliStartOfPackage = 0x55555555;
//	pxFtdiProtHeader->uliPackageId = 0x01010101;
//	pxFtdiProtHeader->ucImageSelectionNull = 0x00;
//	pxFtdiProtHeader->ucImageSelectionFee = 3;
//	pxFtdiProtHeader->ucImageSelectionCcd = 2;
//	pxFtdiProtHeader->ucImageSelectionSide = 1;
////	pxFtdiProtHeader->uiImageSizeHeight = 4450;
////	pxFtdiProtHeader->uiImageSizeWidth = 2295;
//	pxFtdiProtHeader->uiImageSizeHeight = 4;
//	pxFtdiProtHeader->uiImageSizeWidth = 8;
//	pxFtdiProtHeader->uiExposureNumberNull = 0x0000;
//	pxFtdiProtHeader->uiExposureNumberValue = 875;
//	// pxFtdiProtHeader->uliPayloadLength = 8192;
//	pxFtdiProtHeader->uliPayloadLength = 0;
//	pxFtdiProtHeader->uliHeaderCrc = crc__CRC32((unsigned char *)(DDR2_EXT_ADDR_WINDOWED_BASE + 4), 5*4);
//	pxFtdiProtHeader->uliEndOfHeader = 0x33333333;
//
////	// Prepare Header
////	pxFtdiProtHeader->uliStartOfPackage = 0x55555555;
////	pxFtdiProtHeader->uliPackageId = 0x01010101;
////	pxFtdiProtHeader->ucImageSelectionNull = 0x00;
////	pxFtdiProtHeader->ucImageSelectionFee = 0x11;
////	pxFtdiProtHeader->ucImageSelectionCcd = 0x33;
////	pxFtdiProtHeader->ucImageSelectionSide = 0x55;
////	pxFtdiProtHeader->uiImageSizeHeight = 0x7777;
////	pxFtdiProtHeader->uiImageSizeWidth = 0x9999;
////	pxFtdiProtHeader->uiExposureNumberNull = 0x0000;
////	pxFtdiProtHeader->uiExposureNumberValue = 0xAAAA;
////	pxFtdiProtHeader->uliPayloadLength = 0xCCCCCCCC;
////	pxFtdiProtHeader->uliHeaderCrc = 0xEEEEEEEE;
////	pxFtdiProtHeader->uliEndOfHeader = 0x33333333;
//
//	// Change from Little to Big Endian
//	alt_u16 ucDataCnt = 0;
//	alt_u32 *puliDataAddr = (alt_u32 *)DDR2_EXT_ADDR_WINDOWED_BASE;
////	for (ucDataCnt = 0; ucDataCnt < 8; ucDataCnt++) {
////		(*puliDataAddr) = uliLittleToBigEndian(*puliDataAddr);
////		puliDataAddr++;
////	}
//
//	// Dump Memory Tx
//	ucDataCnt = 0;
//	puliDataAddr = (alt_u32 *)DDR2_EXT_ADDR_WINDOWED_BASE;
//	for (ucDataCnt = 0; ucDataCnt < 8; ucDataCnt++) {
//		printf("Addr: 0x%08lX, Data: 0x%08lX \n", (alt_u32)puliDataAddr, (alt_u32)(*puliDataAddr));
//		puliDataAddr++;
//	}
//
//	// Start Channel
//	pxFtdi->xFtdiControlRegisters.bFtdiStart = TRUE;
//
//	// Transmitt Header to USB
//	ucDataCnt = 0;
//	puliDataAddr = (alt_u32 *)DDR2_EXT_ADDR_WINDOWED_BASE;
//	for (ucDataCnt = 0; ucDataCnt < 8; ucDataCnt++) {
//		pxFtdi->xFtdiUsbTxRegisters.uliUsbTxWrdataData = (*puliDataAddr);
//		pxFtdi->xFtdiUsbTxRegisters.ucUsbTxWrdataBe = 0xFF;
//		pxFtdi->xFtdiUsbTxRegisters.bUsbTxWrreq = TRUE;
//		printf("Test Tx Data(0x%08lX), BE(0x%X) \n", pxFtdi->xFtdiUsbTxRegisters.uliUsbTxWrdataData, pxFtdi->xFtdiUsbTxRegisters.ucUsbTxWrdataBe);
//		puliDataAddr++;
//	}
//	printf("Header Transmitted \n");
//
//	usleep(1*1000*1000);
//
//	// Receive data from USB
//	printf("\nReceiving data \n\n");
//
//	ucDataCnt = 0;
////	while (1) {
//
//	// Parse ACK/NACK
//	puliDataAddr = (alt_u32 *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x2000);
//	printf("Expecting ACK/NACK \n");
//	while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//	printf("Received [0x%04d] Start of Package: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//	*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//	while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//	printf("Received [0x%04d] Package ID: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//	*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//	while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//	printf("Received [0x%04d] Image Selection: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//	*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//	while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//	printf("Received [0x%04d] Image Size: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//	*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//	while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//	printf("Received [0x%04d] Exposure Number: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//	*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//	while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//	printf("Received [0x%04d] Payload Length: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//	*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//	while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//	printf("Received [0x%04d] Header CRC: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//	*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//	while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//	printf("Received [0x%04d] End of Header: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//	*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//	printf("Calculated ACK/NACK CRC: (0x%08lX) \n", crc__CRC32((unsigned char *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x2000 + 4), 5*4));
//	printf("Finished ACK/NACK \n \n");
//
//	usleep(1*1000*1000);
//
//	for (i = 0; i <3; i++) { // 3 times
//
//		// Parse Reply Header
//		puliDataAddr = (alt_u32 *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x3000);
//		pxFtdiProtReply = (TFtdiProtocolHeader *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x3000);
//		printf("Expecting Reply Header \n");
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Start of Package: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Package ID: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Image Selection: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Image Size: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Exposure Number: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Payload Length: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Header CRC: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] End of Header: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		printf("Calculated Reply Header CRC: (0x%08lX) \n", crc__CRC32((unsigned char *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x3000 + 4), 5*4));
//		printf("Finished Reply Header \n \n");
//
//		usleep(1*1000*1000);
//
//		// Prepare NACK
//		pxFtdiProtHeader = (TFtdiProtocolHeader *) (DDR2_EXT_ADDR_WINDOWED_BASE + 0x4000);
//		pxFtdiProtHeader->uliStartOfPackage = 0x55555555;
//		pxFtdiProtHeader->uliPackageId = 0x10101010;
//		pxFtdiProtHeader->ucImageSelectionNull = 0x00;
//		pxFtdiProtHeader->ucImageSelectionFee = 0;
//		pxFtdiProtHeader->ucImageSelectionCcd = 0;
//		pxFtdiProtHeader->ucImageSelectionSide = 0;
//		pxFtdiProtHeader->uiImageSizeHeight = 0;
//		pxFtdiProtHeader->uiImageSizeWidth = 0;
//		pxFtdiProtHeader->uiExposureNumberNull = 0x0000;
//		pxFtdiProtHeader->uiExposureNumberValue = 0;
//		pxFtdiProtHeader->uliPayloadLength = 0;
//		pxFtdiProtHeader->uliHeaderCrc = crc__CRC32((unsigned char *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x4000 + 4), 5*4);
//		pxFtdiProtHeader->uliEndOfHeader = 0x33333333;
//
//		// Transmitt NACK to USB
//		ucDataCnt = 0;
//		puliDataAddr = (alt_u32 *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x4000);
//		for (ucDataCnt = 0; ucDataCnt < 8; ucDataCnt++) {
//			pxFtdi->xFtdiUsbTxRegisters.uliUsbTxWrdataData = (*puliDataAddr);
//			pxFtdi->xFtdiUsbTxRegisters.ucUsbTxWrdataBe = 0xFF;
//			pxFtdi->xFtdiUsbTxRegisters.bUsbTxWrreq = TRUE;
//			printf("Test Tx Data(0x%08lX), BE(0x%X) \n", pxFtdi->xFtdiUsbTxRegisters.uliUsbTxWrdataData, pxFtdi->xFtdiUsbTxRegisters.ucUsbTxWrdataBe);
//			puliDataAddr++;
//		}
//		printf("NACK Transmitted \n\n");
//
//		usleep(1*1000*1000);
//	}
//
//	while (1) {
//
//		if (!pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {
////			printf("Usb Rx[0x%04d] Data(0x%08lX), BE(0x%X) \n", ucDataCnt, uliLittleToBigEndian(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData), pxFtdi->xFtdiUsbRxRegisters.ucUsbRxRddataBe);
////			*puliDataAddr = (alt_u32)uliLittleToBigEndian(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData);
//			printf("Usb Rx[0x%04d] Data(0x%08lX), BE(0x%X) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData), pxFtdi->xFtdiUsbRxRegisters.ucUsbRxRddataBe);
//			*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData);
//			pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE;
//			puliDataAddr++;
//			ucDataCnt++;
//		}
//
//	}
//
//	if (pxFtdiProtReply->ucImageSelectionFee == 0) {
//		usleep(1*1000*1000);
//	}
//
//}
//
//void vProtocolUsbTestWrongCrc(void){
//
//	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) FTDI_MODULE_BASE_ADDR;
//	TFtdiProtocolHeader *pxFtdiProtHeader = (TFtdiProtocolHeader *) DDR2_EXT_ADDR_WINDOWED_BASE;
////	TFtdiProtocolHeader *pxFtdiProtReply = (TFtdiProtocolHeader *) DDR2_EXT_ADDR_WINDOWED_BASE;
//
//	int i = 0;
//
//	// Prepare Header
//	pxFtdiProtHeader->uliStartOfPackage = 0x55555555;
//	pxFtdiProtHeader->uliPackageId = 0x01010101;
//	pxFtdiProtHeader->ucImageSelectionNull = 0x00;
//	pxFtdiProtHeader->ucImageSelectionFee = 3;
//	pxFtdiProtHeader->ucImageSelectionCcd = 2;
//	pxFtdiProtHeader->ucImageSelectionSide = 1;
////	pxFtdiProtHeader->uiImageSizeHeight = 4450;
////	pxFtdiProtHeader->uiImageSizeWidth = 2295;
//	pxFtdiProtHeader->uiImageSizeHeight = 4;
//	pxFtdiProtHeader->uiImageSizeWidth = 8;
//	pxFtdiProtHeader->uiExposureNumberNull = 0x0000;
//	pxFtdiProtHeader->uiExposureNumberValue = 875;
//	// pxFtdiProtHeader->uliPayloadLength = 8192;
//	pxFtdiProtHeader->uliPayloadLength = 0;
////	pxFtdiProtHeader->uliHeaderCrc = crc__CRC32((unsigned char *)(DDR2_EXT_ADDR_WINDOWED_BASE + 4), 5*4);
//	pxFtdiProtHeader->uliHeaderCrc = 0x12345678;
//	pxFtdiProtHeader->uliEndOfHeader = 0x33333333;
//
////	// Prepare Header
////	pxFtdiProtHeader->uliStartOfPackage = 0x55555555;
////	pxFtdiProtHeader->uliPackageId = 0x01010101;
////	pxFtdiProtHeader->ucImageSelectionNull = 0x00;
////	pxFtdiProtHeader->ucImageSelectionFee = 0x11;
////	pxFtdiProtHeader->ucImageSelectionCcd = 0x33;
////	pxFtdiProtHeader->ucImageSelectionSide = 0x55;
////	pxFtdiProtHeader->uiImageSizeHeight = 0x7777;
////	pxFtdiProtHeader->uiImageSizeWidth = 0x9999;
////	pxFtdiProtHeader->uiExposureNumberNull = 0x0000;
////	pxFtdiProtHeader->uiExposureNumberValue = 0xAAAA;
////	pxFtdiProtHeader->uliPayloadLength = 0xCCCCCCCC;
////	pxFtdiProtHeader->uliHeaderCrc = 0xEEEEEEEE;
////	pxFtdiProtHeader->uliEndOfHeader = 0x33333333;
//
//	// Change from Little to Big Endian
//	alt_u16 ucDataCnt = 0;
//	alt_u32 *puliDataAddr = (alt_u32 *)DDR2_EXT_ADDR_WINDOWED_BASE;
////	for (ucDataCnt = 0; ucDataCnt < 8; ucDataCnt++) {
////		(*puliDataAddr) = uliLittleToBigEndian(*puliDataAddr);
////		puliDataAddr++;
////	}
//
//	// Dump Memory Tx
//	ucDataCnt = 0;
//	puliDataAddr = (alt_u32 *)DDR2_EXT_ADDR_WINDOWED_BASE;
//	for (ucDataCnt = 0; ucDataCnt < 8; ucDataCnt++) {
//		printf("Addr: 0x%08lX, Data: 0x%08lX \n", (alt_u32)puliDataAddr, (alt_u32)(*puliDataAddr));
//		puliDataAddr++;
//	}
//
//	// Start Channel
//	pxFtdi->xFtdiControlRegisters.bFtdiStart = TRUE;
//
//	for (i = 0; i <3; i++) { // 3 times
//
//		// Transmitt Header to USB
//		ucDataCnt = 0;
//		puliDataAddr = (alt_u32 *)DDR2_EXT_ADDR_WINDOWED_BASE;
//		for (ucDataCnt = 0; ucDataCnt < 8; ucDataCnt++) {
//			pxFtdi->xFtdiUsbTxRegisters.uliUsbTxWrdataData = (*puliDataAddr);
//			pxFtdi->xFtdiUsbTxRegisters.ucUsbTxWrdataBe = 0xFF;
//			pxFtdi->xFtdiUsbTxRegisters.bUsbTxWrreq = TRUE;
//			printf("Test Tx Data(0x%08lX), BE(0x%X) \n", pxFtdi->xFtdiUsbTxRegisters.uliUsbTxWrdataData, pxFtdi->xFtdiUsbTxRegisters.ucUsbTxWrdataBe);
//			puliDataAddr++;
//		}
//		printf("Header Transmitted \n");
//
//		usleep(1*1000*1000);
//
//		// Receive data from USB
//		printf("\nReceiving data \n\n");
//
//		ucDataCnt = 0;
//	//	while (1) {
//
//		// Parse ACK/NACK
//		puliDataAddr = (alt_u32 *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x2000);
//		printf("Expecting ACK/NACK \n");
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Start of Package: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Package ID: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Image Selection: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Image Size: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Exposure Number: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Payload Length: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] Header CRC: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		while (pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {}
//		printf("Received [0x%04d] End of Header: (0x%08lX) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData));
//		*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData); pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE; puliDataAddr++; ucDataCnt++;
//		printf("Calculated ACK/NACK CRC: (0x%08lX) \n", crc__CRC32((unsigned char *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x2000 + 4), 5*4));
//		printf("Finished ACK/NACK \n \n");
//
//		usleep(1*1000*1000);
//
//	}
//
//	while (1) {
//
//		if (!pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdempty) {
////			printf("Usb Rx[0x%04d] Data(0x%08lX), BE(0x%X) \n", ucDataCnt, uliLittleToBigEndian(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData), pxFtdi->xFtdiUsbRxRegisters.ucUsbRxRddataBe);
////			*puliDataAddr = (alt_u32)uliLittleToBigEndian(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData);
//			printf("Usb Rx[0x%04d] Data(0x%08lX), BE(0x%X) \n", ucDataCnt, (pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData), pxFtdi->xFtdiUsbRxRegisters.ucUsbRxRddataBe);
//			*puliDataAddr = (alt_u32)(pxFtdi->xFtdiUsbRxRegisters.uliUsbRxRddataData);
//			pxFtdi->xFtdiUsbRxRegisters.bUsbRxRdreq = TRUE;
//			puliDataAddr++;
//			ucDataCnt++;
//		}
//
//	}
//
//}

void vProtocolUsbTestAck(alt_u32 uliMemOffset, alt_u32 uliMemOffInc, alt_u8 ucMemId, alt_u8 ucFee, alt_u8 ucCcd, alt_u8 ucSide, alt_u16 usiHeight, alt_u16 usiWidth, alt_u16 usiExpNum, bool bMemDump, bool bVerbose){

	TFtdiModule *pxFtdi = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	THalfCcdImage *pxHalfCcdImage = (THalfCcdImage *) DDR2_EXT_ADDR_WINDOWED_BASE;

	uliPaylodOffset = uliMemOffset;
	alt_u32 uliPatternOff = uliPaylodOffset + uliMemOffInc;

	// Start Channel
	pxFtdi->xFtdiFtdiModuleControl.bModuleStart = TRUE;

	printf("Starting Full-Image Request test: \n");
	printf("FEE[%d], CCD[%d], SIDE[%d], HEIGHT[%d], WIDTH[%d], EXP.NUM.[%d] \n", ucFee, ucCcd, ucSide, usiHeight, usiWidth, usiExpNum);

	// Transmitt Request Header
	pxFtdi->xFtdiHalfCcdReqControl.ucHalfCcdFeeNumber = ucFee;
	pxFtdi->xFtdiHalfCcdReqControl.ucHalfCcdCcdNumber = ucCcd;
	pxFtdi->xFtdiHalfCcdReqControl.ucHalfCcdCcdSide = ucSide;
	pxFtdi->xFtdiHalfCcdReqControl.usiHalfCcdCcdHeight = usiHeight;
	pxFtdi->xFtdiHalfCcdReqControl.usiHalfCcdCcdWidth = usiWidth;
	pxFtdi->xFtdiHalfCcdReqControl.usiHalfCcdExpNumber = usiExpNum;
	pxFtdi->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout = 0;
	pxFtdi->xFtdiHalfCcdReqControl.bRequestHalfCcd = TRUE;

//	while (1) {}

//	printf("0x00: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiFtdiIrqControl.bFtdiGlobalIrqEn)));
//	printf("0x01: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqControl.bRxBuff0RdableIrqEn)));
//	printf("0x02: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqControl.bRxBuff1RdableIrqEn)));
//	printf("0x03: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqControl.bRxBuffLastRdableIrqEn)));
//	printf("0x04: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqControl.bRxBuffLastEmptyIrqEn)));
//	printf("0x05: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqControl.bRxCommErrIrqEn)));
//	printf("0x06: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlag.bRxBuff0RdableIrqFlag)));
//	printf("0x07: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlag.bRxBuff1RdableIrqFlag)));
//	printf("0x08: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlag.bRxBuffLastRdableIrqFlag)));
//	printf("0x09: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlag.bRxBuffLastEmptyIrqFlag)));
//	printf("0x0A: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlag.bRxCommErrIrqFlag)));
//	printf("0x0B: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlagClr.bRxBuff0RdableIrqFlagClr)));
//	printf("0x0C: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlagClr.bRxBuff1RdableIrqFlagClr)));
//	printf("0x0D: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlagClr.bRxBuffLastRdableIrqFlagClr)));
//	printf("0x0E: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlagClr.bRxBuffLastEmptyIrqFlagClr)));
//	printf("0x0F: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiRxIrqFlagClr.bRxCommErrIrqFlagClr)));
//	printf("0x10: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiFtdiModuleControl.bModuleStart)));
//	printf("0x11: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiFtdiModuleControl.bModuleStop)));
//	printf("0x12: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiFtdiModuleControl.bModuleClear)));
//	printf("0x13: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiFtdiModuleControl.bModuleLoopbackEn)));
//	printf("0x14: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout)));
//	printf("0x14: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.ucHalfCcdFeeNumber)));
//	printf("0x14: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.ucHalfCcdCcdNumber)));
//	printf("0x15: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.ucHalfCcdCcdSide)));
//	printf("0x15: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.usiHalfCcdCcdHeight)));
//	printf("0x16: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.usiHalfCcdCcdWidth)));
//	printf("0x16: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.usiHalfCcdExpNumber)));
//	printf("0x17: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.bRequestHalfCcd)));
//	printf("0x18: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.bAbortHalfCcdReq)));
//	printf("0x19: 0x%08lX \n",(alt_u32)(&(pxFtdi->xFtdiHalfCcdReqControl.bRstHalfCcdController)));

	// Wait for an error or Rx Data
	bStopRx = FALSE;
	alt_u32 uliTransferSize = 0;
	alt_u32 uliTransferCnt = 0;

//	while (pxFtdi->xFtdiHalfCcdReplyStatus.bHalfCcdControllerBusy) {
//
//	}

	while (!bStopRx) {}

//	alt_u32 uliDataCnt = 0;
//	alt_u16 *pusiDataAddr = (alt_u16 *)uliMemOffset;
//	for (uliDataCnt = 0; uliDataCnt < pxFtdi->xFtdiHalfCcdReplyStatus.uliHalfCcdImgLengthBytes/2 + 64; uliDataCnt++) {
////		if (uliDataCnt > (pxFtdi->xFtdiHalfCcdReplyStatus.uliHalfCcdImgLengthBytes/2 - 64)) {
//		if (uliDataCnt < 128) {
//			printf("Addr: 0x%08lX ; Data: 0x%04X \n", (alt_u32)pusiDataAddr, (*pusiDataAddr));
//		}
//		pusiDataAddr++;
//	}
//
//	while (1) {}

//	while ((pxFtdi->xFtdiRxBufferStatus.bRxBuff0Full == FALSE) && (pxFtdi->xFtdiRxBufferStatus.bRxBuff1Full == FALSE)) {}

//	iTimeStart = alt_nticks();

//	while ((pxFtdi->xFtdiHalfCcdReplyStatus.bHalfCcdControllerBusy)) {
////	while ((!bStopRx)) {
//
////		if (pxFtdi->xFtdiRxIrqFlag.bRxBuff0RdableIrqFlag) {
//		if (pxFtdi->xFtdiRxBufferStatus.bRxBuff0Full) {
//
////			pxFtdi->xFtdiRxIrqFlagClr.bRxBuff0RdableIrqFlagClr = TRUE;
//			uliTransferSize = pxFtdi->xFtdiRxBufferStatus.usiRxBuff0UsedBytes;
//			bSdmaDmaM2FtdiTransfer((alt_u32 *)uliPaylodOffset, uliTransferSize, eSdmaRxFtdi);
//			uliPaylodOffset += uliTransferSize;
//			uliTransferCnt++;
//
//		}
////		if (pxFtdi->xFtdiRxIrqFlag.bRxBuff1RdableIrqFlag) {
//		if (pxFtdi->xFtdiRxBufferStatus.bRxBuff1Full) {
//
////			pxFtdi->xFtdiRxIrqFlagClr.bRxBuff1RdableIrqFlagClr = TRUE;
//			uliTransferSize = pxFtdi->xFtdiRxBufferStatus.usiRxBuff1UsedBytes;
//			bSdmaDmaM2FtdiTransfer((alt_u32 *)uliPaylodOffset, uliTransferSize, eSdmaRxFtdi);
//			uliPaylodOffset += uliTransferSize;
//			uliTransferCnt++;
//
//		}
//		if (pxFtdi->xFtdiRxIrqFlag.bRxBuffLastRdableIrqFlag) {
////		if ((uliTransferCnt == 3890) && ((pxFtdi->xFtdiRxBufferStatus.usiRxBuff0UsedBytes == 8128) || (pxFtdi->xFtdiRxBufferStatus.usiRxBuff1UsedBytes == 8128))) {
////		if ((uliTransferCnt == 64849) && ((pxFtdi->xFtdiRxBufferStatus.usiRxBuff0UsedBytes == 7008) || (pxFtdi->xFtdiRxBufferStatus.usiRxBuff1UsedBytes == 7008))) {
//
//			pxFtdi->xFtdiRxIrqFlagClr.bRxBuffLastRdableIrqFlagClr = TRUE;
////			uliTransferSize =  8128;
//			uliTransferSize =  7008;
//			bSdmaDmaM2FtdiTransfer((alt_u32 *)uliPaylodOffset, uliTransferSize, eSdmaRxFtdi);
//			uliPaylodOffset += uliTransferSize;
//
////			bStopRx = TRUE;
//
//		}
//		if (pxFtdi->xFtdiRxIrqFlag.bRxBuffLastEmptyIrqFlag) {
//
//			pxFtdi->xFtdiRxIrqFlagClr.bRxBuffLastEmptyIrqFlagClr = TRUE;
//			bStopRx = TRUE;
//			printf("Receival Complete \n");
//
//
//		}
//		if (pxFtdi->xFtdiRxIrqFlag.bRxCommErrIrqFlag) {
//
//			pxFtdi->xFtdiRxIrqFlagClr.bRxCommErrIrqFlagClr = TRUE;
//			bStopRx = TRUE;
//			printf("Error Occurred \n");
//
//		}

//	}

	// Check Contents
//	vFillCheckMemoryPattern(uliPatternOff, uliMemOffset, pxFtdi->xFtdiHalfCcdReplyStatus.uliHalfCcdImgLengthBytes, ucMemId, ucCcd, ucSide, usiHeight, usiWidth, usiExpNum, bMemDump);

	pxFtdi->xFtdiHalfCcdReqControl.bRstHalfCcdController = TRUE;

	usleep(1);

	pxFtdi->xFtdiFtdiModuleControl.bModuleStop = TRUE;
	pxFtdi->xFtdiFtdiModuleControl.bModuleClear = TRUE;

//		usleep(1*1000*1000);
//		usleep(100*1000);
	usleep(1);

	printf("\n\n");

}

void vFillCheckMemoryPattern(alt_u32 uliMemPatternOffset, alt_u32 uliMemPayloadOffset, alt_u32 uliPayloadLength, alt_u8 ucMemId, alt_u8 ucCcd, alt_u8 ucSide, alt_u16 usiHeight, alt_u16 usiWidth, alt_u16 usiExpNum, bool bMemDump){

	// Generate Pattern
	pattern_createPattern(ucMemId, uliMemPatternOffset, ucCcd, ucSide, usiWidth, usiHeight, (alt_u8)usiExpNum);

	// Check and Dump Pattern 32b
	alt_u16 ucErrorCnt = 0;
	alt_u32 ucDataCnt = 0;
	alt_u64 *puliDataAddr = (alt_u64 *)uliMemPatternOffset;
	alt_u64 *puliPayloadAddr = (alt_u64 *)uliMemPayloadOffset;
//	puliPayloadAddr += 4;
	for (ucDataCnt = 0; ucDataCnt < (uliPayloadLength)/8; ucDataCnt++) {
		if (bMemDump) {
//			printf("Addr: 0x%08lX, Data: 0x%016llX \n", (alt_u32)puliDataAddr, (alt_u64)(*puliDataAddr));
			printf("Payload: 0x%016llX, Pattern: 0x%016llX \n", (alt_u64)(*puliPayloadAddr), (alt_u64)(*puliDataAddr));
		}

//		if (ucDataCnt >= 6374820/8) {
//			printf("Addr: 0x%08lX, Payload: 0x%016llX, Pattern: 0x%016llX \n", (alt_u32)puliDataAddr, (alt_u64)(*puliPayloadAddr), (alt_u64)(*puliDataAddr));
//		}

		if ((alt_u64)(*puliDataAddr) != (alt_u64)(*puliPayloadAddr)) {
			ucErrorCnt++;
			if (!bMemDump) {
				printf("Addr: 0x%08lX, Payload: 0x%016llX, Pattern: 0x%016llX \n", (alt_u32)puliDataAddr, (alt_u64)(*puliPayloadAddr), (alt_u64)(*puliDataAddr));
			}
		}
		puliDataAddr++; puliPayloadAddr++;
	}

	if (ucErrorCnt > 0) {
		printf("Pattern and Payload does not match!! %04d errors!! \n", ucErrorCnt);
	} else {
		printf("Pattern and Payload match!! Payload Length: %ldB\n", uliPayloadLength);
	}

}

//
//alt_u32 uliLittleToBigEndian(alt_u32 uliLittleEndianDword){
//	alt_u32 uliBigEndianDword;
//
//	alt_u8 ucBytes[4];
//	ucBytes[0] = (alt_u8)((uliLittleEndianDword & 0x000000FF) >> 0);
//	ucBytes[1] = (alt_u8)((uliLittleEndianDword & 0x0000FF00) >> 8);
//	ucBytes[2] = (alt_u8)((uliLittleEndianDword & 0x00FF0000) >> 16);
//	ucBytes[3] = (alt_u8)((uliLittleEndianDword & 0xFF000000) >> 24);
//
//	uliBigEndianDword =
//		((ucBytes[0] << 24) & 0xFF000000) |
//		((ucBytes[1] << 16) & 0x00FF0000) |
//		((ucBytes[2] << 8) & 0x0000FF00) |
//		((ucBytes[3] << 0) & 0x000000FF);
//
//	return uliBigEndianDword;
//}


alt_u32 uliLittleToBigEndianPixel(alt_u32 uliLittleEndianDword){
	alt_u32 uliBigEndianDword;

	alt_u16 uiWords[2];
	uiWords[0] = (alt_u16)((uliLittleEndianDword & 0x0000FFFF) >> 0);
	uiWords[1] = (alt_u16)((uliLittleEndianDword & 0xFFFF0000) >> 16);

	uliBigEndianDword = (alt_u32)(
		((uiWords[0] << 16) & 0xFFFF0000) |
		((uiWords[1] << 0) & 0x0000FFFF));

	return uliBigEndianDword;
}

void vLittleToBigEndianMask(alt_u32 uliLittleEndianDword[2]){
	alt_u32 uliTemp = 0;

	uliTemp = uliLittleEndianDword[0];
	uliLittleEndianDword[0] = uliLittleEndianDword[1];
	uliLittleEndianDword[1] = uliTemp;

}
