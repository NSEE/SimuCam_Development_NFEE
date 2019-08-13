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

typedef struct TypesTest {


	alt_8 bit8_0;
	bool bool_1;
	alt_8 bit8_1;
	alt_32 bit32;
	alt_16 bit16;
	bool bool_0;


} TTypesTest;

int main() {
	printf("Hello from Nios II!\n\n");

	alt_u8 *pxDes;
	alt_u32 *pxDes32;

	alt_u32 uiDataCnt = 0;

	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
	for (uiDataCnt = 0; uiDataCnt < 1024; uiDataCnt++) {
		*pxDes32 = (alt_u32) 0;
		pxDes32++;
	}

	usleep(1000 * 1000 * 1);

	TTypesTest *xTypesTest = (TTypesTest *) AVSTAP32_0_BASE;

//	xTypesTest->bit8_0 = 0xFF;
//	xTypesTest->bit16 = 0x5555;
//	xTypesTest->bit8_1 = 0x33;
//	xTypesTest->bit32 = 0x12345678;
//	xTypesTest->bool_0 = false;
//	xTypesTest->bool_1 = true;

	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
	*(pxDes32 + 0) = (alt_u32) 0x000000FF;
	*(pxDes32 + 1) = (alt_u32) 0x00000001;
	*(pxDes32 + 2) = (alt_u32) 0x00000033;
	*(pxDes32 + 3) = (alt_u32) 0x12345678;
	*(pxDes32 + 4) = (alt_u32) 0x00005555;
	*(pxDes32 + 5) = (alt_u32) 0x00000000;

	printf("bit8_0: %02X \n", xTypesTest->bit8_0);
	 printf("bit16: %04X \n", xTypesTest->bit16);
	printf("bit8_1: %02X \n", xTypesTest->bit8_1);
     printf("bit32: %08lX \n", xTypesTest->bit32);
	printf("bool_0: %08X \n", xTypesTest->bool_0);
	printf("bool_1: %08X \n", xTypesTest->bool_1);


//	pxDes = (alt_u8 *) AVSTAP32_0_BASE;
//	for (uiDataCnt = 0; uiDataCnt < 1024; uiDataCnt++) {
//		*pxDes = (alt_u8) uiDataCnt;
//		pxDes++;
//	}

//	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
//	for (uiDataCnt = 0; uiDataCnt < 1024; uiDataCnt++) {
//		*pxDes32 = (alt_u32) uiDataCnt;
//		pxDes32++;
//	}

	usleep(1000 * 1000 * 1);

	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
	for (uiDataCnt = 0; uiDataCnt < 10; uiDataCnt++) {
		printf("Addr: %04lu; Data: %08lX \n", (alt_u32) pxDes32, *pxDes32);
		pxDes32++;
	}

	return 0;
}
