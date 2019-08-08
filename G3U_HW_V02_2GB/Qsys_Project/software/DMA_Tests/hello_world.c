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

int main()
{
  printf("Hello from Nios II!\n\n");

  // write test data in memory
  bDdr2SwitchMemory(DDR2_M1_ID);

  alt_u32 uliDdr2Base;
  alt_u8 *pxDes;
  alt_u32 *pxDes32;

  alt_u16 uiDataCnt = 0;

  uliDdr2Base = DDR2_EXT_ADDR_WINDOWED_BASE;

  pxDes = (alt_u8 *) uliDdr2Base;
  for (uiDataCnt = 0; uiDataCnt < 2176; uiDataCnt++) {
	  *pxDes = (alt_u8)uiDataCnt;
	  pxDes++;
  }

//  pxDes = (alt_u8 *) uliDdr2Base;
//  for (uiDataCnt = 0; uiDataCnt < 2176; uiDataCnt++) {
//	  printf("Addr: %04lu; Data: %02X \n", (alt_u32)pxDes, *pxDes);
//	  pxDes++;
//  }

  pxDes32 = (alt_u32 *) AVSTAP256_0_BASE;
  *pxDes32 = 1;

  if (bSdmaInitM1Dma()){
	  printf("Ok1 \n");
  }
  if (bSdmaDmaM1Transfer((alt_u32 *)32, 1, eSdmaLeftBuffer, eSdmaCh1Buffer)){
	  printf("Ok2 \n");

	  usleep(1000*1000*1);

	  pxDes32 = (alt_u32 *) AVSTAP256_0_BASE;
	    for (uiDataCnt = 0; uiDataCnt < (2176/4 + 4); uiDataCnt++) {
	  	  printf("Addr: %04lu; Data: %08lX \n", (alt_u32)pxDes32, *pxDes32);
	  	  pxDes32++;
	    }

  } else {
	  printf("Fail2 \n");
  }



  return 0;
}
