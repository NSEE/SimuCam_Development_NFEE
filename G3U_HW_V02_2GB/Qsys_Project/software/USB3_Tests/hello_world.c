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
#include "crc.h"
#include "pattern.h"

FILE* fp;

/* FTDI IRQ Control Register Struct */
typedef struct FtdiFtdiIrqControl {
 bool bFtdiGlobalIrqEn; /* FTDI Global IRQ Enable */
} TFtdiFtdiIrqControl;

/* FTDI Rx IRQ Control Register Struct */
typedef struct FtdiRxIrqControl {
 bool bRxBuff0RdableIrqEn; /* Rx Buffer 0 Readable IRQ Enable */
 bool bRxBuff1RdableIrqEn; /* Rx Buffer 1 Readable IRQ Enable */
 bool bRxBuffLastRdableIrqEn; /* Rx Last Buffer Readable IRQ Enable */
 bool bRxBuffLastEmptyIrqEn; /* Rx Last Buffer Empty IRQ Enable */
 bool bRxCommErrIrqEn; /* Rx Communication Error IRQ Enable */
} TFtdiRxIrqControl;

/* FTDI Rx IRQ Flag Register Struct */
typedef struct FtdiRxIrqFlag {
 bool bRxBuff0RdableIrqFlag; /* Rx Buffer 0 Readable IRQ Flag */
 bool bRxBuff1RdableIrqFlag; /* Rx Buffer 1 Readable IRQ Flag */
 bool bRxBuffLastRdableIrqFlag; /* Rx Last Buffer Readable IRQ Flag */
 bool bRxBuffLastEmptyIrqFlag; /* Rx Last Buffer Empty IRQ Flag */
 bool bRxCommErrIrqFlag; /* Rx Communication Error IRQ Flag */
} TFtdiRxIrqFlag;

/* FTDI Rx IRQ Flag Clear Register Struct */
typedef struct FtdiRxIrqFlagClr {
 bool bRxBuff0RdableIrqFlagClr; /* Rx Buffer 0 Readable IRQ Flag Clear */
 bool bRxBuff1RdableIrqFlagClr; /* Rx Buffer 1 Readable IRQ Flag Clear */
 bool bRxBuffLastRdableIrqFlagClr; /* Rx Last Buffer Readable IRQ Flag Clear */
 bool bRxBuffLastEmptyIrqFlagClr; /* Rx Last Buffer Empty IRQ Flag Clear */
 bool bRxCommErrIrqFlagClr; /* Rx Communication Error IRQ Flag Clear */
} TFtdiRxIrqFlagClr;

/* FTDI Module Control Register Struct */
typedef struct FtdiFtdiModuleControl {
 bool bModuleStart; /* Stop Module Operation */
 bool bModuleStop; /* Start Module Operation */
 bool bModuleClear; /* Clear Module Memories */
 bool bModuleLoopbackEn; /* Enable Module USB Loopback */
} TFtdiFtdiModuleControl;

/* FTDI Half-CCD Request Control Register Struct */
typedef struct FtdiHalfCcdReqControl {
 alt_u32 usiHalfCcdReqTimeout; /* Half-CCD Request Timeout */
 alt_u32 ucHalfCcdFeeNumber; /* Half-CCD FEE Number */
 alt_u32 ucHalfCcdCcdNumber; /* Half-CCD CCD Number */
 alt_u32 ucHalfCcdCcdSide; /* Half-CCD CCD Side */
 alt_u32 usiHalfCcdCcdHeight; /* Half-CCD CCD Height */
 alt_u32 usiHalfCcdCcdWidth; /* Half-CCD CCD Width */
 alt_u32 usiHalfCcdExpNumber; /* Half-CCD Exposure Number */
 bool bRequestHalfCcd; /* Request Half-CCD */
 bool bAbortHalfCcdReq; /* Abort Half-CCD Request */
 bool bRstHalfCcdController; /* Reset Half-CCD Controller */
} TFtdiHalfCcdReqControl;

/* FTDI Half-CCD Reply Status Register Struct */
typedef struct FtdiHalfCcdReplyStatus {
 alt_u32 ucHalfCcdFeeNumber; /* Half-CCD FEE Number */
 alt_u32 ucHalfCcdCcdNumber; /* Half-CCD CCD Number */
 alt_u32 ucHalfCcdCcdSide; /* Half-CCD CCD Side */
 alt_u32 usiHalfCcdCcdHeight; /* Half-CCD CCD Height */
 alt_u32 usiHalfCcdCcdWidth; /* Half-CCD CCD Width */
 alt_u32 usiHalfCcdExpNumber; /* Half-CCD Exposure Number */
 alt_u32 uliHalfCcdImgLengthBytes; /* Half-CCD Image Length [Bytes] */
 bool bHalfCcdReceived; /* Half-CCD Received */
 bool bHalfCcdControllerBusy; /* Half-CCD Controller Busy */
 bool bHalfCcdLastRxBuff; /* Half-CCD Last Rx Buffer */
} TFtdiHalfCcdReplyStatus;

/* FTDI Rx Buffer Status Register Struct */
typedef struct FtdiRxBufferStatus {
 bool bRxBuff0Rdable; /* Rx Buffer 0 Readable */
 bool bRxBuff0Empty; /* Rx Buffer 0 Empty */
 alt_u32 usiRxBuff0UsedBytes; /* Rx Buffer 0 Used [Bytes] */
 bool bRxBuff0Full; /* Rx Buffer 0 Full */
 bool bRxBuff1Rdable; /* Rx Buffer 1 Readable */
 bool bRxBuff1Empty; /* Rx Buffer 1 Empty */
 alt_u32 usiRxBuff1UsedBytes; /* Rx Buffer 1 Used [Bytes] */
 bool bRxBuff1Full; /* Rx Buffer 1 Full */
 bool bRxDbuffRdable; /* Rx Double Buffer Readable */
 bool bRxDbuffEmpty; /* Rx Double Buffer Empty */
 alt_u32 usiRxDbuffUsedBytes; /* Rx Double Buffer Used [Bytes] */
 bool bRxDbuffFull; /* Rx Double Buffer Full */
} TFtdiRxBufferStatus;

/* FTDI Tx Buffer Status Register Struct */
typedef struct FtdiTxBufferStatus {
 bool bTxBuff0Wrable; /* Tx Buffer 0 Writeable */
 bool bTxBuff0Empty; /* Tx Buffer 0 Empty */
 alt_u32 usiTxBuff0SpaceBytes; /* Tx Buffer 0 Space [Bytes] */
 bool bTxBuff0Full; /* Tx Buffer 0 Full */
 bool bTxBuff1Wrable; /* Tx Buffer 1 Writeable */
 bool bTxBuff1Empty; /* Tx Buffer 1 Empty */
 alt_u32 usiTxBuff1SpaceBytes; /* Tx Buffer 1 Space [Bytes] */
 bool bTxBuff1Full; /* Tx Buffer 1 Full */
 bool bTxDbuffWrable; /* Tx Double Buffer Writeable */
 bool bTxDbuffEmpty; /* Tx Double Buffer Empty */
 alt_u32 usiTxDbuffSpaceBytes; /* Tx Double Buffer Space [Bytes] */
 bool bTxDbuffFull; /* Tx Double Buffer Full */
} TFtdiTxBufferStatus;

/* FTDI Rx Communication Error Register Struct */
typedef struct FtdiRxCommError {
 bool bRxCommErrState; /* Rx Communication Error State */
 alt_u16 usiRxCommErrCode; /* Rx Communication Error Code */
 bool bHalfCcdReqNackErr; /* Half-CCD Request Nack Error */
 bool bHalfCcdReplyHeadCrcErr; /* Half-CCD Reply Wrong Header CRC Error */
 bool bHalfCcdReplyHeadEohErr; /* Half-CCD Reply End of Header Error */
 bool bHalfCcdReplyPayCrcErr; /* Half-CCD Reply Wrong Payload CRC Error */
 bool bHalfCcdReplyPayEopErr; /* Half-CCD Reply End of Payload Error */
 bool bHalfCcdReqMaxTriesErr; /* Half-CCD Request Maximum Tries Error */
 bool bHalfCcdReplyCcdSizeErr; /* Half-CCD Request CCD Size Error */
 bool bHalfCcdReqTimeoutErr; /* Half-CCD Request Timeout Error */
} TFtdiRxCommError;

/* FTDI Reserved Register Struct */
typedef struct FtdiReserved {
 bool bTxBuff0EmptyIrq; /* Tx Buffer 0 Empty Irq */
 bool bTxBuff1EmptyIrq; /* Tx Buffer 1 Empty Irq */
 bool bLutTransmittedIrq; /* LUT Transmitted Irq */
 bool bTxCommProtocolErrIrq; /* Tx Communication Protocol Error Irq */
 alt_u32 uliLutLengthBytes; /* LUT Length Bytes */
 bool bTransmitLut; /* Transmit LUT */
 bool bLutLastBuffer; /* LUT Last Buffer */
 bool bLutTransmitted; /* LUT Transmitted */
 bool bTxBusy; /* Tx Busy */
 bool bTxBuffEmpty; /* Tx Buffer Empty */
} TFtdiReserved;

/* General Struct for Registers Access */
typedef struct FtdiModule {
 TFtdiFtdiIrqControl xFtdiFtdiIrqControl;
 TFtdiRxIrqControl xFtdiRxIrqControl;
 TFtdiRxIrqFlag xFtdiRxIrqFlag;
 TFtdiRxIrqFlagClr xFtdiRxIrqFlagClr;
 TFtdiFtdiModuleControl xFtdiFtdiModuleControl;
 TFtdiHalfCcdReqControl xFtdiHalfCcdReqControl;
 TFtdiHalfCcdReplyStatus xFtdiHalfCcdReplyStatus;
 TFtdiRxBufferStatus xFtdiRxBufferStatus;
 TFtdiTxBufferStatus xFtdiTxBufferStatus;
 TFtdiRxCommError xFtdiRxCommError;
 TFtdiReserved xFtdiReserved;
} TFtdiModule;

int iTimeStart, iTimeElapsed = 0;

void vProtocolUsbTestAck(alt_u32 uliMemOffset, alt_u32 uliMemOffInc, alt_u8 ucMemId, alt_u8 ucFee, alt_u8 ucCcd, alt_u8 ucSide, alt_u16 usiHeight, alt_u16 usiWidth, alt_u16 usiExpNum, bool bMemDump, bool bVerbose);
//void vProtocolUsbTestNack(void);
//void vProtocolUsbTestWrongCrc(void);
void vFillCheckMemoryPattern(alt_u32 uliMemReplyOffset, alt_u32 uliMemPayloadOffset, alt_u32 uliMemPatternOffset, alt_u8 ucMemId, alt_u8 ucCcd, alt_u8 ucSide, alt_u16 usiHeight, alt_u16 usiWidth, alt_u16 usiExpNum, bool bMemDump);
//alt_u32 uliLittleToBigEndian(alt_u32 uliLittleEndianDword);
alt_u32 uliLittleToBigEndianPixel(alt_u32 uliLittleEndianDword);
void vLittleToBigEndianMask(alt_u32 uliLittleEndianDword[2]);

alt_u32 uliInitialState;

int main() {
	printf("Hello from Nios II!\n\n");

	TFtdiModule *pxFtdi = (TFtdiModule *) USB_3_FTDI_0_BASE;

	bDdr2SwitchMemory(DDR2_M2_ID);
	bSdmaInitM2Dma();

	// Stop and Clear Channel
	pxFtdi->xFtdiFtdiModuleControl.bModuleLoopbackEn = FALSE;
	pxFtdi->xFtdiFtdiModuleControl.bModuleStop = TRUE;
	pxFtdi->xFtdiFtdiModuleControl.bModuleClear = TRUE;

	// Start Channel
//	pxFtdi->xFtdiFtdiModuleControl.bModuleStart = TRUE;

	// Enable Loopback
//	pxFtdi->xFtdiFtdiModuleControl.bModuleLoopbackEn = TRUE;
//	printf("Loopback Enabled! \n");

	//Enable IRQs
	pxFtdi->xFtdiRxIrqControl.bRxBuff0RdableIrqEn = TRUE;
	pxFtdi->xFtdiRxIrqControl.bRxBuff1RdableIrqEn = TRUE;
	pxFtdi->xFtdiRxIrqControl.bRxBuffLastRdableIrqEn = TRUE;
	pxFtdi->xFtdiRxIrqControl.bRxBuffLastEmptyIrqEn = TRUE;
	pxFtdi->xFtdiRxIrqControl.bRxCommErrIrqEn = TRUE;
	pxFtdi->xFtdiFtdiIrqControl.bFtdiGlobalIrqEn = TRUE;

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

//void vProtocolUsbTestNack(void){
//
//	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) USB_3_FTDI_0_BASE;
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
//	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) USB_3_FTDI_0_BASE;
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

	TFtdiModule *pxFtdi = (TFtdiModule *) USB_3_FTDI_0_BASE;

	alt_u32 uliPaylodOffset = uliMemOffset;
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

	// Wait for an error or Rx Data
	bool bStopRx = FALSE;
	alt_u32 uliTransferSize = 0;
	alt_u32 uliTransferCnt = 0;

//	while (pxFtdi->xFtdiHalfCcdReplyStatus.bHalfCcdControllerBusy) {
//
//	}

	while ((pxFtdi->xFtdiRxBufferStatus.bRxBuff0Full == FALSE) && (pxFtdi->xFtdiRxBufferStatus.bRxBuff1Full == FALSE)) {}

//	iTimeStart = alt_nticks();

	while ((pxFtdi->xFtdiHalfCcdReplyStatus.bHalfCcdControllerBusy)) {
//	while ((!bStopRx)) {

//		if (pxFtdi->xFtdiRxIrqFlag.bRxBuff0RdableIrqFlag) {
		if (pxFtdi->xFtdiRxBufferStatus.bRxBuff0Full) {

//			pxFtdi->xFtdiRxIrqFlagClr.bRxBuff0RdableIrqFlagClr = TRUE;
			uliTransferSize = pxFtdi->xFtdiRxBufferStatus.usiRxBuff0UsedBytes;
			bSdmaDmaM2FtdiTransfer((alt_u32 *)uliPaylodOffset, uliTransferSize, eSdmaRxFtdi);
			uliPaylodOffset += uliTransferSize;
			uliTransferCnt++;

		}
//		if (pxFtdi->xFtdiRxIrqFlag.bRxBuff1RdableIrqFlag) {
		if (pxFtdi->xFtdiRxBufferStatus.bRxBuff1Full) {

//			pxFtdi->xFtdiRxIrqFlagClr.bRxBuff1RdableIrqFlagClr = TRUE;
			uliTransferSize = pxFtdi->xFtdiRxBufferStatus.usiRxBuff1UsedBytes;
			bSdmaDmaM2FtdiTransfer((alt_u32 *)uliPaylodOffset, uliTransferSize, eSdmaRxFtdi);
			uliPaylodOffset += uliTransferSize;
			uliTransferCnt++;

		}
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

	}

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
	puliPayloadAddr += 4;
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
