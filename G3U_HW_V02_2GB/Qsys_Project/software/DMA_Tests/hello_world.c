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

	pxDes = (alt_u8 *) AVSTAP32_0_BASE;
	*pxDes = (alt_u32) 50;

	*(pxDes+3) = (alt_u32) 50;

//	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
//	for (uiDataCnt = 0; uiDataCnt < 1024; uiDataCnt++) {
//		*pxDes32 = (alt_u32) uiDataCnt;
//		pxDes32++;
//	}

	usleep(1000 * 1000 * 1);

	pxDes32 = (alt_u32 *) AVSTAP32_0_BASE;
	for (uiDataCnt = 0; uiDataCnt < 1024; uiDataCnt++) {
		printf("Addr: %04lu; Data: %08lX \n", (alt_u32) pxDes32, *pxDes32);
		pxDes32++;
	}

	return 0;
}
