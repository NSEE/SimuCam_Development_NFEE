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
#include "driver/comm/comm_channel.h"
#include "driver/ctrl_io_lvds/ctrl_io_lvds.h"
#include "driver/sync/sync.h"

// Master blank time = (MBT * 20 ns) = 400 ms
//#define MBT	10E6
#define MBT	20E6
// Blank time = (BT * 20 ns) = 200 ms
#define BT	10E6
// Period = (PER * 20 ns) = 6,25 s
//#define PER	312500E3
#define PER	312500E3*3
// One shot time = (OST * 20 ns) = 500 ms
#define OST	25E6
// Blank level polarity = '0'
#define POL FALSE
// Number of cycles = 4
#define N_CICLOS 4

FILE* fp;

typedef struct DataType {
	alt_u16 uiPixel[64];
	alt_u64 ullMask;
} TDataType;

typedef struct DataTypeBuffer {
	TDataType xData[16];
} TDataTypeBuffer;

int main() {
	printf("Hello from Nios II!\n\n");

	// Iso Config
	bEnableIsoDrivers();
	bEnableLvdsBoard();

	// Sync config
	// Configura um padrão de sync interno
	// MBT => 400 ms @ 20 ns (50 MHz)
	bSyncSetMbt(MBT);
	// BT => 200 ms @ 20 ns (50 MHz)
	bSyncSetBt(BT);
	// PER => 6,25s @ 20 ns (50 MHz)
	bSyncSetPer(  uliPerCalcPeriodMs( 25*1000 ) );
	// OST => 500 ms @ 20 ns (50 MHz)
	bSyncSetOst(OST);
	// Polaridade
	bSyncSetPolarity(POL);
	// N. de ciclos
	bSyncSetNCycles(N_CICLOS);
	// Altera mux para sync interno
	bSyncCtrExtnIrq(TRUE);
	// Habilita sync_out_ch1 enable (libera sync para o Ch 1)
	bSyncCtrCh1OutEnable(TRUE);
	bSyncCtrStart();
	bSyncCtrReset();

	//Channel Config
	TCommChannel xChA;
	TCommChannel *pxChA = &xChA;
	bCommInitCh(pxChA, eCommSpwCh1);
	// enable spw
	bSpwcGetLink(&(pxChA->xSpacewire));
	pxChA->xSpacewire.xLinkConfig.bLinkStart = FALSE;
	pxChA->xSpacewire.xLinkConfig.bAutostart = TRUE;
	pxChA->xSpacewire.xLinkConfig.bDisconnect = FALSE;
	bSpwcSetLink(&(pxChA->xSpacewire));
	// start channel
	bFeebStopCh(&(pxChA->xFeeBuffer));
	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(&(pxChA->xFeeBuffer));
	/* Start the module Double Buffer */
	bFeebStartCh(&(pxChA->xFeeBuffer));
	bFeebGetWindowing(&(pxChA->xFeeBuffer));
	pxChA->xFeeBuffer.xWindowingConfig.bMasking = TRUE;
	bFeebSetWindowing(&(pxChA->xFeeBuffer));
	/*Enable IRQ of FEE Buffer*/
	bFeebGetIrqControl(&(pxChA->xFeeBuffer));
	pxChA->xFeeBuffer.xIrqControl.bLeftBufferEmptyEn = TRUE;
	pxChA->xFeeBuffer.xIrqControl.bRightBufferEmptyEn = TRUE;
	bFeebSetIrqControl(&(pxChA->xFeeBuffer));
	// data packet
	bDpktGetPacketConfig(&(pxChA->xDataPacket));
	pxChA->xDataPacket.xDpktDataPacketConfig.usiCcdXSize = 2295;
	pxChA->xDataPacket.xDpktDataPacketConfig.usiCcdYSize = 4540;
	pxChA->xDataPacket.xDpktDataPacketConfig.usiDataYSize = 4510;
	pxChA->xDataPacket.xDpktDataPacketConfig.usiOverscanYSize = 30;
//	pxChA->xDataPacket.xDpktDataPacketConfig.usiPacketLength = 10 + 2048;
//	pxChA->xDataPacket.xDpktDataPacketConfig.usiPacketLength = 10 + 8;
//	pxChA->xDataPacket.xDpktDataPacketConfig.usiPacketLength = 2048;
	pxChA->xDataPacket.xDpktDataPacketConfig.usiPacketLength = 32140;
	pxChA->xDataPacket.xDpktDataPacketConfig.ucCcdNumber = 0;
	pxChA->xDataPacket.xDpktDataPacketConfig.ucFeeMode = eDpktFullImage;
	pxChA->xDataPacket.xDpktDataPacketConfig.ucProtocolId = 0xF0; /* 0xF0 ou  0x02*/
	pxChA->xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = 0x51;
	bDpktSetPacketConfig(&(pxChA->xDataPacket));

	bDdr2SwitchMemory(DDR2_M1_ID);

	alt_u32 uiDataCnt = 0;
	alt_u32 uiPixlCnt = 0;
	alt_u32 uiBuffCnt = 0;

	TDataTypeBuffer *pxDataBuffer = (TDataTypeBuffer *) DDR2_EXT_ADDR_WINDOWED_BASE;
	uiDataCnt = 0;
	for (uiBuffCnt = 0; uiBuffCnt < 16; uiBuffCnt++) {
		uiDataCnt++;
		for (uiPixlCnt = 0; uiPixlCnt < 64; uiPixlCnt++) {
//			pxDataBuffer->xData[uiBuffCnt].uiPixel[uiPixlCnt] = (alt_u16) uiDataCnt;
			pxDataBuffer->xData[uiBuffCnt].uiPixel[uiPixlCnt] = (alt_u16) 0;
//			pxDataBuffer->xData[uiBuffCnt].uiPixel[uiPixlCnt] = (alt_u16) 0xFFFF;
		}
		pxDataBuffer->xData[uiBuffCnt].ullMask = 0xFFFFFFFFFFFFFFFF;
//		pxDataBuffer->xData[uiBuffCnt].ullMask = 0xF;
//		pxDataBuffer->xData[uiBuffCnt].ullMask = 0;
	}

	pxDataBuffer = (TDataTypeBuffer *) (DDR2_EXT_ADDR_WINDOWED_BASE + 2176);
	uiDataCnt = 0;
	for (uiBuffCnt = 0; uiBuffCnt < 16; uiBuffCnt++) {
		uiDataCnt++;
		for (uiPixlCnt = 0; uiPixlCnt < 64; uiPixlCnt++) {
//			pxDataBuffer->xData[uiBuffCnt].uiPixel[uiPixlCnt] = (alt_u16) uiDataCnt;
//			pxDataBuffer->xData[uiBuffCnt].uiPixel[uiPixlCnt] = (alt_u16) 0;
			pxDataBuffer->xData[uiBuffCnt].uiPixel[uiPixlCnt] = (alt_u16) 0xFFFF;
		}
		pxDataBuffer->xData[uiBuffCnt].ullMask = 0xFFFFFFFFFFFFFFFF;
//		pxDataBuffer->xData[uiBuffCnt].ullMask = 0xF;
//		pxDataBuffer->xData[uiBuffCnt].ullMask = 0;
	}


//		alt_u32 *pxDes32;
//		pxDes32 = (alt_u32 *) DDR2_EXT_ADDR_WINDOWED_BASE;
//		for (uiDataCnt = 0; uiDataCnt < 544; uiDataCnt++) {
//			printf("Addr: %04lu; Data: %08lX \n", (alt_u32) pxDes32, *pxDes32);
//			pxDes32++;
//		}

	bSdmaInitM1Dma();

	usleep(5*1000*1000);

	bFeebCh1SetBufferSize(16, eSdmaLeftBuffer);

	if (bSdmaDmaM1Transfer((alt_u32 *)0, 16, eSdmaLeftBuffer, eSdmaCh1Buffer)) {
		printf("DMA Ok \n");
	} else {
		printf("DMA Fail \n");
	}


	if (bSdmaDmaM1Transfer((alt_u32 *)2176, 16, eSdmaLeftBuffer, eSdmaCh1Buffer)) {
		printf("DMA Ok \n");
	} else {
		printf("DMA Fail \n");
	}

	bSyncCtrStart();

//	bCommSetGlobalIrqEn(TRUE, eCommSpwCh1);

	for (uiBuffCnt = 0; uiBuffCnt < (10176 - 1); uiBuffCnt++) {
//	for (uiBuffCnt = 0; uiBuffCnt < (10176/2 - 1); uiBuffCnt++) {
//	for (uiBuffCnt = 0; uiBuffCnt < 1; uiBuffCnt++) {

		while (!bFeebGetCh1LeftBufferEmpty()) {}

		if (bSdmaDmaM1Transfer((alt_u32 *)0, 16, eSdmaLeftBuffer, eSdmaCh1Buffer)) {
			printf("DMA Ok \n");
		} else {
			printf("DMA Fail \n");
		}

		while (!bFeebGetCh1LeftBufferEmpty()) {}

		if (bSdmaDmaM1Transfer((alt_u32 *)2176, 16, eSdmaLeftBuffer, eSdmaCh1Buffer)) {
			printf("DMA Ok \n");
		} else {
			printf("DMA Fail \n");
		}

	}

	while (1) {}

	// start sync
//	bSyncCtrStart();

//
//	alt_u8 *pxDes;
//	alt_u32 *pxDes32;
//
//	alt_u32 uiDataCnt = 0;
//
//	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
//	for (uiDataCnt = 0; uiDataCnt < 1024; uiDataCnt++) {
//		*pxDes32 = (alt_u32) 0;
//		pxDes32++;
//	}
//
//	usleep(1000 * 1000 * 1);
//
//	TTypesTest *xTypesTest = (TTypesTest *) AVSTAP32_0_BASE;
//
////	xTypesTest->bit8_0 = 0xFF;
////	xTypesTest->bit16 = 0x5555;
////	xTypesTest->bit8_1 = 0x33;
////	xTypesTest->bit32 = 0x12345678;
////	xTypesTest->bool_0 = false;
////	xTypesTest->bool_1 = true;
//
//	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
//	*(pxDes32 + 0) = (alt_u32) 0x000000FF;
//	*(pxDes32 + 1) = (alt_u32) 0x00000001;
//	*(pxDes32 + 2) = (alt_u32) 0x00000033;
//	*(pxDes32 + 3) = (alt_u32) 0x12345678;
//	*(pxDes32 + 4) = (alt_u32) 0x00005555;
//	*(pxDes32 + 5) = (alt_u32) 0x00000000;
//
//	printf("bit8_0: %02X \n", xTypesTest->bit8_0);
//	 printf("bit16: %04X \n", xTypesTest->bit16);
//	printf("bit8_1: %02X \n", xTypesTest->bit8_1);
//     printf("bit32: %08lX \n", xTypesTest->bit32);
//	printf("bool_0: %08X \n", xTypesTest->bool_0);
//	printf("bool_1: %08X \n", xTypesTest->bool_1);
//
//
////	pxDes = (alt_u8 *) AVSTAP32_0_BASE;
////	for (uiDataCnt = 0; uiDataCnt < 1024; uiDataCnt++) {
////		*pxDes = (alt_u8) uiDataCnt;
////		pxDes++;
////	}
//
////	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
////	for (uiDataCnt = 0; uiDataCnt < 1024; uiDataCnt++) {
////		*pxDes32 = (alt_u32) uiDataCnt;
////		pxDes32++;
////	}
//
//	usleep(1000 * 1000 * 1);
//
//	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
//	for (uiDataCnt = 0; uiDataCnt < 10; uiDataCnt++) {
//		printf("Addr: %04lu; Data: %08lX \n", (alt_u32) pxDes32, *pxDes32);
//		pxDes32++;
//	}

	return 0;
}
