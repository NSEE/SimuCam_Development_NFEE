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

FILE* fp;

typedef struct FtdiRegisters {
	bool bFtdiClear;
	bool bFtdiStop;
	bool bFtdiStart;
	bool bTxDbufferEmpty;
	bool bTxDbufferWrready;
	bool bTxDbufferFull;
	bool bTxDbufferRdready;
	bool bRxDbufferEmpty;
	bool bRxDbufferWrready;
	bool bRxDbufferFull;
	bool bRxDbufferRdready;
	bool bTestTxRdreq;
	bool bTestTxRdempty;
	bool bTestTxRdfull;
	alt_u16 uiTestTxRdusedw;
	alt_u32 uliTestTxRddataData;
	alt_u8 ucTestTxRddataBe;
	bool bTestRxWrreq;
	alt_u32 uliTestRxWrdataData;
	alt_u8 ucTestRxWrdataBe;
	bool bTestRxWrempty;
	bool bTestRxWrfull;
	alt_u16 uiTestRxWrusedw;
} TFtdiRegisters;

void vWriteTest(void);
void vReadTest(void);
void vLoopbackTest(void);
void vLoopbackRandomTest(void);

alt_u32 uliInitialState;

int main() {
	printf("Hello from Nios II!\n\n");

	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) USB_3_FTDI_0_BASE;

	bDdr2SwitchMemory(DDR2_M2_ID);
	bSdmaInitM2Dma();

	alt_u64 *pulliDdr2Mem;
	alt_u32 uliAddrCnt = 0;

	// Clear Memory
	pulliDdr2Mem = (alt_u64 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (uliAddrCnt = 0; uliAddrCnt < 1024*2; uliAddrCnt++) {
		*pulliDdr2Mem = (alt_u64)0;
//		printf("Addr: 0x%08lX, Data: 0x%016llX \n", (alt_u32)pulliDdr2Mem, (alt_u64)(*pulliDdr2Mem));
		pulliDdr2Mem++;
	}

	// Stop and Clear Channel
	pxFtdi->bFtdiStop = TRUE;
	pxFtdi->bFtdiClear = TRUE;

	// Start Channel
//	pxFtdi->bFtdiStart = TRUE;

	usleep(5*1000*1000);

//	// Dump Raw Channel
//	alt_u32 *puliFtdiAddr = (alt_u32 *)USB_3_FTDI_0_BASE;
//	for (uliAddrCnt = 0; uliAddrCnt < 10; uliAddrCnt++) {
//		printf("Addr: 0x%08lX, Data: 0x%08lX \n", (alt_u32)puliFtdiAddr, (alt_u32)(*puliFtdiAddr));
//		puliFtdiAddr++;
//	}

//	vWriteTest();
//	vReadTest();
//	vLoopbackTest();
	vLoopbackRandomTest();

	while (1) {}

	return 0;
}

void vWriteTest(void){

	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) USB_3_FTDI_0_BASE;
	alt_u64 *pulliDdr2Mem;
	alt_u32 uliAddrCnt = 0;

	// Fill Memory
	alt_u16 ucDataCnt = 0;
	alt_u8 *pucDataAddr = (alt_u8 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (ucDataCnt = 0; ucDataCnt < (8*1024); ucDataCnt++) {
		*pucDataAddr = (alt_u8)ucDataCnt;
		pucDataAddr++;
	}

	usleep(1*1000*1000);

	// Check Memory Content
	pulliDdr2Mem = (alt_u64 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (uliAddrCnt = 0; uliAddrCnt < 1024; uliAddrCnt++) {
		printf("Addr: 0x%08lX, Data: 0x%016llX \n", (alt_u32)pulliDdr2Mem, (alt_u64)(*pulliDdr2Mem));
		pulliDdr2Mem++;
	}

	// Dump Channel Status
	printf("bFtdiClear        : %d \n", pxFtdi->bFtdiClear       );
	printf("bFtdiStop         : %d \n", pxFtdi->bFtdiStop        );
	printf("bFtdiStart        : %d \n", pxFtdi->bFtdiStart       );
	printf("bTxDbufferEmpty   : %d \n", pxFtdi->bTxDbufferEmpty  );
	printf("bTxDbufferWrready : %d \n", pxFtdi->bTxDbufferWrready);
	printf("bTxDbufferFull    : %d \n", pxFtdi->bTxDbufferFull   );
	printf("bTxDbufferRdready : %d \n", pxFtdi->bTxDbufferRdready);
	printf("bRxDbufferEmpty   : %d \n", pxFtdi->bRxDbufferEmpty  );
	printf("bRxDbufferWrready : %d \n", pxFtdi->bRxDbufferWrready);
	printf("bRxDbufferFull    : %d \n", pxFtdi->bRxDbufferFull   );
	printf("bRxDbufferRdready : %d \n", pxFtdi->bRxDbufferRdready);

	// Start Channel
	pxFtdi->bFtdiStart = TRUE;

	// Transmitt data to USB
	while (!pxFtdi->bTxDbufferWrready) {}

	if (bSdmaDmaM2FtdiTransfer((alt_u32 *)0, (8 * 1024), eSdmaTxFtdi)) {
		printf("DMA Tx Ok \n");
	} else {
		printf("DMA Tx Fail \n");
	}

	usleep(1*1000*1000);

	// Read Test Data (8kiB)
		printf("Test Tx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestTxRdempty, pxFtdi->uiTestTxRdusedw, pxFtdi->bTestTxRdfull);
		for (ucDataCnt = 0; ucDataCnt < (8*1024/4); ucDataCnt++) {
			while (pxFtdi->bTestTxRdempty) {}
			printf("Test Tx Data(0x%08lX), BE(0x%X) \n", pxFtdi->uliTestTxRddataData, pxFtdi->ucTestTxRddataBe);
			pxFtdi->bTestTxRdreq = TRUE;
		}
		printf("Test Tx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestTxRdempty, pxFtdi->uiTestTxRdusedw, pxFtdi->bTestTxRdfull);

}

void vReadTest(void){

	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) USB_3_FTDI_0_BASE;
	alt_u64 *pulliDdr2Mem;
	alt_u32 uliAddrCnt = 0;

	// Write Test Data to be read (8kiB)
		alt_u16 ucDataCnt = 0;
		for (ucDataCnt = 0; ucDataCnt < (8*1024); ucDataCnt = ucDataCnt + 4) {
			pxFtdi->uliTestRxWrdataData = (alt_u32)(((ucDataCnt) & 0x000000FF) | (((ucDataCnt + 1) << 8) & 0x0000FF00) | (((ucDataCnt + 2) << 16) & 0x00FF0000) | (((ucDataCnt + 3) << 24) & 0xFF000000));
			pxFtdi->ucTestRxWrdataBe = (alt_u8)0xFF;
			pxFtdi->bTestRxWrreq = TRUE;
//			printf("Test Rx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestRxWrempty, pxFtdi->uiTestRxWrusedw, pxFtdi->bTestRxWrfull);
		}
		printf("Test Rx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestRxWrempty, pxFtdi->uiTestRxWrusedw, pxFtdi->bTestRxWrfull);

		usleep(1*1000*1000);

		// Start Channel
		pxFtdi->bFtdiStart = TRUE;


	// Dump Channel Status
	printf("bFtdiClear        : %d \n", pxFtdi->bFtdiClear       );
	printf("bFtdiStop         : %d \n", pxFtdi->bFtdiStop        );
	printf("bFtdiStart        : %d \n", pxFtdi->bFtdiStart       );
	printf("bTxDbufferEmpty   : %d \n", pxFtdi->bTxDbufferEmpty  );
	printf("bTxDbufferWrready : %d \n", pxFtdi->bTxDbufferWrready);
	printf("bTxDbufferFull    : %d \n", pxFtdi->bTxDbufferFull   );
	printf("bTxDbufferRdready : %d \n", pxFtdi->bTxDbufferRdready);
	printf("bRxDbufferEmpty   : %d \n", pxFtdi->bRxDbufferEmpty  );
	printf("bRxDbufferWrready : %d \n", pxFtdi->bRxDbufferWrready);
	printf("bRxDbufferFull    : %d \n", pxFtdi->bRxDbufferFull   );
	printf("bRxDbufferRdready : %d \n", pxFtdi->bRxDbufferRdready);

	// Receive data from USB
	while (!pxFtdi->bRxDbufferRdready) {}

	if (bSdmaDmaM2FtdiTransfer((alt_u32 *)0, (8 * 1024), eSdmaRxFtdi)) {
		printf("DMA Rx Ok \n");
	} else {
		printf("DMA Rx Fail \n");
	}

	usleep(1*1000*1000);

	// Check Memory Content
	pulliDdr2Mem = (alt_u64 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (uliAddrCnt = 0; uliAddrCnt < 1024; uliAddrCnt++) {
		printf("Addr: 0x%08lX, Data: 0x%016llX \n", (alt_u32)pulliDdr2Mem, (alt_u64)(*pulliDdr2Mem));
		pulliDdr2Mem++;
	}
}

void vLoopbackTest(void){

	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) USB_3_FTDI_0_BASE;
	alt_u64 *pulliDdr2Mem;
	alt_u32 uliAddrCnt = 0;

	// Fill Memory
	alt_u16 ucDataCnt = 0;
	alt_u8 *pucDataAddr = (alt_u8 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (ucDataCnt = 0; ucDataCnt < (8*1024); ucDataCnt++) {
		*pucDataAddr = (alt_u8)ucDataCnt;
		pucDataAddr++;
	}

	usleep(1*1000*1000);

	// Check Memory Content
	pulliDdr2Mem = (alt_u64 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (uliAddrCnt = 0; uliAddrCnt < 1024; uliAddrCnt++) {
		printf("Addr: 0x%08lX, Data: 0x%016llX \n", (alt_u32)pulliDdr2Mem, (alt_u64)(*pulliDdr2Mem));
		pulliDdr2Mem++;
	}

	// Dump Channel Status
	printf("bFtdiClear        : %d \n", pxFtdi->bFtdiClear       );
	printf("bFtdiStop         : %d \n", pxFtdi->bFtdiStop        );
	printf("bFtdiStart        : %d \n", pxFtdi->bFtdiStart       );
	printf("bTxDbufferEmpty   : %d \n", pxFtdi->bTxDbufferEmpty  );
	printf("bTxDbufferWrready : %d \n", pxFtdi->bTxDbufferWrready);
	printf("bTxDbufferFull    : %d \n", pxFtdi->bTxDbufferFull   );
	printf("bTxDbufferRdready : %d \n", pxFtdi->bTxDbufferRdready);
	printf("bRxDbufferEmpty   : %d \n", pxFtdi->bRxDbufferEmpty  );
	printf("bRxDbufferWrready : %d \n", pxFtdi->bRxDbufferWrready);
	printf("bRxDbufferFull    : %d \n", pxFtdi->bRxDbufferFull   );
	printf("bRxDbufferRdready : %d \n", pxFtdi->bRxDbufferRdready);

	// Start Channel
	pxFtdi->bFtdiStart = TRUE;

	// Transmitt data to USB
	while (!pxFtdi->bTxDbufferWrready) {}

	if (bSdmaDmaM2FtdiTransfer((alt_u32 *)0, (8 * 1024), eSdmaTxFtdi)) {
		printf("DMA Tx Ok \n");
	} else {
		printf("DMA Tx Fail \n");
	}

	usleep(1*1000*1000);

	// Start Channel
	pxFtdi->bFtdiStop = TRUE;

	// Loopback Test Data (8kiB)
	printf("Test Tx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestTxRdempty, pxFtdi->uiTestTxRdusedw, pxFtdi->bTestTxRdfull);
	printf("Test Rx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestRxWrempty, pxFtdi->uiTestRxWrusedw, pxFtdi->bTestRxWrfull);
	for (ucDataCnt = 0; ucDataCnt < (8*1024/4); ucDataCnt++) {
		pxFtdi->uliTestRxWrdataData = pxFtdi->uliTestTxRddataData;
		pxFtdi->ucTestRxWrdataBe = pxFtdi->ucTestTxRddataBe;
		pxFtdi->bTestRxWrreq = TRUE;
		pxFtdi->bTestTxRdreq = TRUE;
	}
	printf("Test Tx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestTxRdempty, pxFtdi->uiTestTxRdusedw, pxFtdi->bTestTxRdfull);
	printf("Test Rx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestRxWrempty, pxFtdi->uiTestRxWrusedw, pxFtdi->bTestRxWrfull);

		usleep(1*1000*1000);

		// Start Channel
		pxFtdi->bFtdiStart = TRUE;

	// Dump Channel Status
	printf("bFtdiClear        : %d \n", pxFtdi->bFtdiClear       );
	printf("bFtdiStop         : %d \n", pxFtdi->bFtdiStop        );
	printf("bFtdiStart        : %d \n", pxFtdi->bFtdiStart       );
	printf("bTxDbufferEmpty   : %d \n", pxFtdi->bTxDbufferEmpty  );
	printf("bTxDbufferWrready : %d \n", pxFtdi->bTxDbufferWrready);
	printf("bTxDbufferFull    : %d \n", pxFtdi->bTxDbufferFull   );
	printf("bTxDbufferRdready : %d \n", pxFtdi->bTxDbufferRdready);
	printf("bRxDbufferEmpty   : %d \n", pxFtdi->bRxDbufferEmpty  );
	printf("bRxDbufferWrready : %d \n", pxFtdi->bRxDbufferWrready);
	printf("bRxDbufferFull    : %d \n", pxFtdi->bRxDbufferFull   );
	printf("bRxDbufferRdready : %d \n", pxFtdi->bRxDbufferRdready);

	// Receive data from USB
	while (!pxFtdi->bRxDbufferRdready) {}

	if (bSdmaDmaM2FtdiTransfer((alt_u32 *)0x2000, (8 * 1024), eSdmaRxFtdi)) {
		printf("DMA Rx Ok \n");
	} else {
		printf("DMA Rx Fail \n");
	}

	usleep(1*1000*1000);

	// Check Memory Content
	pulliDdr2Mem = (alt_u64 *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x2000);
	for (uliAddrCnt = 0; uliAddrCnt < 1024; uliAddrCnt++) {
		printf("Addr: 0x%08lX, Data: 0x%016llX \n", (alt_u32)pulliDdr2Mem, (alt_u64)(*pulliDdr2Mem));
		pulliDdr2Mem++;
	}

	// Match Memory Content
	alt_u64 *pulliDdr2MemWrite = (alt_u64 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	alt_u64 *pulliDdr2MemRead = (alt_u64 *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x2000);
	alt_u16 uiErrorCnt = 0;
	for (uliAddrCnt = 0; uliAddrCnt < 1024; uliAddrCnt++) {
		if (*pulliDdr2MemWrite != *pulliDdr2MemRead) {
			uiErrorCnt++;
		}
		pulliDdr2MemWrite++;
		pulliDdr2MemRead++;
	}
	if (uiErrorCnt == 0) {
		printf("Loopback Test Successful!! \n");
	} else {
		printf("Loopback Test Failed, with %d errors!! \n", uiErrorCnt);
	}

}

void vLoopbackRandomTest(void){

	TFtdiRegisters *pxFtdi = (TFtdiRegisters *) USB_3_FTDI_0_BASE;
	alt_u64 *pulliDdr2Mem;
	alt_u32 uliAddrCnt = 0;
	alt_u32 uliCurrentState;

	uliInitialState = alt_nticks();
	uliCurrentState = uliInitialState;

	// Fill Memory
	alt_u16 ucDataCnt = 0;
	alt_u32 *pucDataAddr = (alt_u32 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (ucDataCnt = 0; ucDataCnt < (8*1024/4); ucDataCnt++) {
		*pucDataAddr = (alt_u32)(uliXorshift32(&uliCurrentState));
		pucDataAddr++;
	}

	usleep(1*1000*1000);

	// Check Memory Content
	pulliDdr2Mem = (alt_u64 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	for (uliAddrCnt = 0; uliAddrCnt < 1024; uliAddrCnt++) {
		printf("Addr: 0x%08lX, Data: 0x%016llX \n", (alt_u32)pulliDdr2Mem, (alt_u64)(*pulliDdr2Mem));
		pulliDdr2Mem++;
	}

	// Dump Channel Status
	printf("bFtdiClear        : %d \n", pxFtdi->bFtdiClear       );
	printf("bFtdiStop         : %d \n", pxFtdi->bFtdiStop        );
	printf("bFtdiStart        : %d \n", pxFtdi->bFtdiStart       );
	printf("bTxDbufferEmpty   : %d \n", pxFtdi->bTxDbufferEmpty  );
	printf("bTxDbufferWrready : %d \n", pxFtdi->bTxDbufferWrready);
	printf("bTxDbufferFull    : %d \n", pxFtdi->bTxDbufferFull   );
	printf("bTxDbufferRdready : %d \n", pxFtdi->bTxDbufferRdready);
	printf("bRxDbufferEmpty   : %d \n", pxFtdi->bRxDbufferEmpty  );
	printf("bRxDbufferWrready : %d \n", pxFtdi->bRxDbufferWrready);
	printf("bRxDbufferFull    : %d \n", pxFtdi->bRxDbufferFull   );
	printf("bRxDbufferRdready : %d \n", pxFtdi->bRxDbufferRdready);

	// Start Channel
	pxFtdi->bFtdiStart = TRUE;

	// Transmitt data to USB
	while (!pxFtdi->bTxDbufferWrready) {}

	if (bSdmaDmaM2FtdiTransfer((alt_u32 *)0, (8 * 1024), eSdmaTxFtdi)) {
		printf("DMA Tx Ok \n");
	} else {
		printf("DMA Tx Fail \n");
	}

	usleep(1*1000*1000);

	// Start Channel
	pxFtdi->bFtdiStop = TRUE;

	// Loopback Test Data (8kiB)
	printf("Test Tx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestTxRdempty, pxFtdi->uiTestTxRdusedw, pxFtdi->bTestTxRdfull);
	printf("Test Rx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestRxWrempty, pxFtdi->uiTestRxWrusedw, pxFtdi->bTestRxWrfull);
	for (ucDataCnt = 0; ucDataCnt < (8*1024/4); ucDataCnt++) {
		pxFtdi->uliTestRxWrdataData = pxFtdi->uliTestTxRddataData;
		pxFtdi->ucTestRxWrdataBe = pxFtdi->ucTestTxRddataBe;
		pxFtdi->bTestRxWrreq = TRUE;
		pxFtdi->bTestTxRdreq = TRUE;
	}
	printf("Test Tx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestTxRdempty, pxFtdi->uiTestTxRdusedw, pxFtdi->bTestTxRdfull);
	printf("Test Rx Empty(%d), UsedW(%d), Full(%d) \n", pxFtdi->bTestRxWrempty, pxFtdi->uiTestRxWrusedw, pxFtdi->bTestRxWrfull);

		usleep(1*1000*1000);

		// Start Channel
		pxFtdi->bFtdiStart = TRUE;

	// Dump Channel Status
	printf("bFtdiClear        : %d \n", pxFtdi->bFtdiClear       );
	printf("bFtdiStop         : %d \n", pxFtdi->bFtdiStop        );
	printf("bFtdiStart        : %d \n", pxFtdi->bFtdiStart       );
	printf("bTxDbufferEmpty   : %d \n", pxFtdi->bTxDbufferEmpty  );
	printf("bTxDbufferWrready : %d \n", pxFtdi->bTxDbufferWrready);
	printf("bTxDbufferFull    : %d \n", pxFtdi->bTxDbufferFull   );
	printf("bTxDbufferRdready : %d \n", pxFtdi->bTxDbufferRdready);
	printf("bRxDbufferEmpty   : %d \n", pxFtdi->bRxDbufferEmpty  );
	printf("bRxDbufferWrready : %d \n", pxFtdi->bRxDbufferWrready);
	printf("bRxDbufferFull    : %d \n", pxFtdi->bRxDbufferFull   );
	printf("bRxDbufferRdready : %d \n", pxFtdi->bRxDbufferRdready);

	// Receive data from USB
	while (!pxFtdi->bRxDbufferRdready) {}

	if (bSdmaDmaM2FtdiTransfer((alt_u32 *)0x2000, (8 * 1024), eSdmaRxFtdi)) {
		printf("DMA Rx Ok \n");
	} else {
		printf("DMA Rx Fail \n");
	}

	usleep(1*1000*1000);

	// Check Memory Content
	pulliDdr2Mem = (alt_u64 *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x2000);
	for (uliAddrCnt = 0; uliAddrCnt < 1024; uliAddrCnt++) {
		printf("Addr: 0x%08lX, Data: 0x%016llX \n", (alt_u32)pulliDdr2Mem, (alt_u64)(*pulliDdr2Mem));
		pulliDdr2Mem++;
	}

	// Match Memory Content
	alt_u64 *pulliDdr2MemWrite = (alt_u64 *)DDR2_EXT_ADDR_WINDOWED_BASE;
	alt_u64 *pulliDdr2MemRead = (alt_u64 *)(DDR2_EXT_ADDR_WINDOWED_BASE + 0x2000);
	alt_u16 uiErrorCnt = 0;
	for (uliAddrCnt = 0; uliAddrCnt < 1024; uliAddrCnt++) {
		if (*pulliDdr2MemWrite != *pulliDdr2MemRead) {
			uiErrorCnt++;
		}
		pulliDdr2MemWrite++;
		pulliDdr2MemRead++;
	}
	if (uiErrorCnt == 0) {
		printf("Loopback Test Successful!! \n");
	} else {
		printf("Loopback Test Failed, with %d errors!! \n", uiErrorCnt);
	}

}

