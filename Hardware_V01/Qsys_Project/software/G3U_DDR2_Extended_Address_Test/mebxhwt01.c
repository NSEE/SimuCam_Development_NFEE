/*************/
/* Includes	 */
/*************/

#include <stdio.h>
#include <io.h>
#include <unistd.h>
#include "system.h"

#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include <sys/alt_cache.h>
#include "sys/alt_timestamp.h"
#include <altera_msgdma.h>

//#include "includes.h"

#include "utils/util.h"
#include "utils/meb_includes.h"

#include "driver/i2c/i2c.h"
#include "driver/leds/leds.h"
#include "driver/power_spi/power_spi.h"
#include "driver/rtcc_spi/rtcc_spi.h"
#include "driver/seven_seg/seven_seg.h"

#include "logic/dma/dma.h"
#include "logic/sense/sense.h"
#include "logic/ddr2/ddr2.h"

/**************************************************
 * Global
**************************************************/

void TestLeds(void);
void TestSinc(void);
void TestRTCC(void);
bool TestDMA_M1_M2(void);
bool TestDMA_M2_M1(void);

int main(void)
{

  printf(" \n Nucleo de Sistemas Eletronicos Embarcados - MebX\n\n");

  //Configura Display de 7 segmentos
  SSDP_CONFIG(SSDP_NORMAL_MODE);

  //Teste inicial das memórias, para entender como o sub-windows funciona

  //alt_u32 *pDdr2Addr = DDR2_ADDRESS_SPAN_EXTENDER_CNTL_BASE;
  //alt_u32 *pDdr2DataAddr;

  // Coloca o sub-window offset no address 0x00000000
//  *(pDdr2Addr) = (alt_u32) 0x00000000;
//  *(pDdr2Addr) = (alt_u32) 0x00000000;
/*
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  *pDdr2DataAddr = 0x00000000;
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  *pDdr2DataAddr = 0x00000000;
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  *pDdr2DataAddr = 0x00000000;
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  *pDdr2DataAddr = 0x00000000;

  *(pDdr2Addr) = (alt_u32) 0x00000000;

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  *pDdr2DataAddr = 0xABEC384E;
  printf("Dado M1 0x00000000 escrito corretamente! \n");
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  *pDdr2DataAddr = 0xADB9FBE4;
  printf("Dado M1 0x10000000 escrito corretamente! \n");
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  *pDdr2DataAddr = 0xC5BC2FC3;
  printf("Dado M1 0x20000000 escrito corretamente! \n");
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  *pDdr2DataAddr = 0x66A9E26F;
  printf("Dado M1 0x30000000 escrito corretamente! \n");

  *(pDdr2Addr) = (alt_u32) 0x40000000;

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  *pDdr2DataAddr = 0x00000000;
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  *pDdr2DataAddr = 0x00000000;
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  *pDdr2DataAddr = 0x00000000;
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  *pDdr2DataAddr = 0x00000000;

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  *pDdr2DataAddr = 0x912BAD28;
  printf("Dado M2 0x00000000 escrito corretamente! \n");
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  *pDdr2DataAddr = 0xD176A72E;
  printf("Dado M2 0x10000000 escrito corretamente! \n");
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  *pDdr2DataAddr = 0xE15C1944;
  printf("Dado M2 0x20000000 escrito corretamente! \n");
  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  *pDdr2DataAddr = 0xC67737D6;
  printf("Dado M2 0x30000000 escrito corretamente! \n");

//  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
//  if (*pDdr2DataAddr == 0xABEC384E) {
//	  printf("Dado 1 lido corretamente! \n");
//  } else {
//	  printf("Falha ao ler Dado 1! \n");
//  }


  *(pDdr2Addr) = (alt_u32) 0x00000000;

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  if (*pDdr2DataAddr == 0xABEC384E) {
	  printf("0x00000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x00000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  if (*pDdr2DataAddr == 0xADB9FBE4) {
	  printf("0x10000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x10000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  if (*pDdr2DataAddr == 0xC5BC2FC3) {
	  printf("0x20000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x20000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  if (*pDdr2DataAddr == 0x66A9E26F) {
	  printf("0x30000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x30000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  if (*pDdr2DataAddr == 0x912BAD28) {
	  printf("0x00000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x00000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  if (*pDdr2DataAddr == 0xD176A72E) {
	  printf("0x10000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x10000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  if (*pDdr2DataAddr == 0xE15C1944) {
	  printf("0x20000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x20000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  if (*pDdr2DataAddr == 0xC67737D6) {
	  printf("0x30000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x30000000: Falha ao ler Dado M2! \n");
  }


  *(pDdr2Addr) = (alt_u32) 0x40000000;

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  if (*pDdr2DataAddr == 0xABEC384E) {
	  printf("0x00000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x00000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  if (*pDdr2DataAddr == 0xADB9FBE4) {
	  printf("0x10000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x10000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  if (*pDdr2DataAddr == 0xC5BC2FC3) {
	  printf("0x20000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x20000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  if (*pDdr2DataAddr == 0x66A9E26F) {
	  printf("0x30000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x30000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  if (*pDdr2DataAddr == 0x912BAD28) {
	  printf("0x00000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x00000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  if (*pDdr2DataAddr == 0xD176A72E) {
	  printf("0x10000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x10000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  if (*pDdr2DataAddr == 0xE15C1944) {
	  printf("0x20000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x20000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  if (*pDdr2DataAddr == 0xC67737D6) {
	  printf("0x30000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x30000000: Falha ao ler Dado M2! \n");
  }

  *(pDdr2Addr) = (alt_u32) 0x00000000;

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  if (*pDdr2DataAddr == 0xABEC384E) {
	  printf("0x00000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x00000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  if (*pDdr2DataAddr == 0xADB9FBE4) {
	  printf("0x10000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x10000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  if (*pDdr2DataAddr == 0xC5BC2FC3) {
	  printf("0x20000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x20000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  if (*pDdr2DataAddr == 0x66A9E26F) {
	  printf("0x30000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x30000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  if (*pDdr2DataAddr == 0x912BAD28) {
	  printf("0x00000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x00000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  if (*pDdr2DataAddr == 0xD176A72E) {
	  printf("0x10000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x10000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  if (*pDdr2DataAddr == 0xE15C1944) {
	  printf("0x20000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x20000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  if (*pDdr2DataAddr == 0xC67737D6) {
	  printf("0x30000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x30000000: Falha ao ler Dado M2! \n");
  }

  *(pDdr2Addr) = (alt_u32) 0x40000000;

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  if (*pDdr2DataAddr == 0xABEC384E) {
	  printf("0x00000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x00000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  if (*pDdr2DataAddr == 0xADB9FBE4) {
	  printf("0x10000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x10000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  if (*pDdr2DataAddr == 0xC5BC2FC3) {
	  printf("0x20000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x20000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  if (*pDdr2DataAddr == 0x66A9E26F) {
	  printf("0x30000000: Dado M1 lido corretamente! \n");
  } else {
	  printf("0x30000000: Falha ao ler Dado M1! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x00000000);
  if (*pDdr2DataAddr == 0x912BAD28) {
	  printf("0x00000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x00000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x10000000);
  if (*pDdr2DataAddr == 0xD176A72E) {
	  printf("0x10000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x10000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x20000000);
  if (*pDdr2DataAddr == 0xE15C1944) {
	  printf("0x20000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x20000000: Falha ao ler Dado M2! \n");
  }

  pDdr2DataAddr = (alt_u32*)(0x0FFFFFFFF+0x30000000);
  if (*pDdr2DataAddr == 0xC67737D6) {
	  printf("0x30000000: Dado M2 lido corretamente! \n");
  } else {
	  printf("0x30000000: Falha ao ler Dado M2! \n");
  }
*/
  /*
  // Escreve dado 0xABEC384E no endereço 0x00000000
  pDdr2DataAddr = (alt_u32*)(0x00000000+0x20000000);
  *pDdr2DataAddr = 0xABEC384E;
  printf("Dado 1 escrito corretamente! \n");

  // Le e confere dado 0xABEC384E no endereço 0x00000000
  pDdr2DataAddr = (alt_u32*)(0x00000000+0x20000000);
  if (*pDdr2DataAddr == 0xABEC384E) {
	  printf("Dado 1 lido corretamente! \n");
  } else {
	  printf("Falha ao ler Dado 1! \n");
  }

  // Coloca o sub-window offset no address 0x00000008
  *(pDdr2Addr) = (alt_u32) 0x00000008;

  // Le e confere dado 0xABEC384E no endereço 0x00000000
  pDdr2DataAddr = (alt_u32*)(0x00000000+0x20000000);
  if (*pDdr2DataAddr == 0xABEC384E) {
	  printf("Dado 1 lido corretamente! \n");
  } else {
	  printf("Falha ao ler Dado 1! \n");
  }

  // Escreve dado 0x8E42E41C no endereço 0x00000000
  pDdr2DataAddr = (alt_u32*)(0x00000000+0x20000000);
  *pDdr2DataAddr = 0x8E42E41C;
  printf("Dado 2 escrito corretamente! \n");

  // Le e confere dado 0x8E42E41C no endereço 0x00000000
  pDdr2DataAddr = (alt_u32*)(0x00000000+0x20000000);
  if (*pDdr2DataAddr == 0x8E42E41C) {
	  printf("Dado 2 lido corretamente! \n");
  } else {
	  printf("Falha ao ler Dado 2! \n");
  }

  // Coloca o sub-window offset no address 0x00000000
  *(pDdr2Addr) = (alt_u32) 0x00000000;

  // Le e confere dado 0x8E42E41C no endereço 0x00000000
  pDdr2DataAddr = (alt_u32*)(0x00000000+0x20000000);
  if (*pDdr2DataAddr == 0x8E42E41C) {
	  printf("Dado 2 lido corretamente! \n");
  } else {
	  printf("Falha ao ler Dado 2! \n");
  }
*/

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

  //Realiza teste dos LEDS, entra em um loop infinito.
  //TestLeds();

  //Teste das DDR2 EEPROMs
  //DDR2_EEPROM_TEST(DDR2_M1_ID);
  //DDR2_EEPROM_TEST(DDR2_M2_ID);
  
  //Dump das DDR2 EEPROMs
  //DDR2_EEPROM_DUMP(DDR2_M1_ID);
  //DDR2_EEPROM_DUMP(DDR2_M2_ID);

  //Teste de escrita de leitura da DDR2 M1
  //DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME);
  //DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME);

  //Teste de escrita de leitura da DDR2 M2
  //DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);
  //DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);
  
	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  //Teste de transferencia com DMA (M1 -> M2);
  TestDMA_M1_M2();
  
	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  //Teste de transferencia com DMA (M2 -> M1);
  TestDMA_M2_M1();

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  //TestLeds();
  //TestRTCC();
  //TestSinc();


	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_POWER_MASK);
	while(1){

			TEMP_Read(&tempFPGA, &tempBoard);
			SSDP_UPDATE(tempFPGA);
			usleep(1000*1000);

	}

  return 0;
}

void TestRTCC (void){

	bool bPass = FALSE;
	alt_u8 uc_EUI48_array[6];

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	   while(1){
		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		usleep(1000*1000);

		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		usleep(1000*1000);

		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		usleep(1000*1000);

		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		usleep(1000*1000);

		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		usleep(1000*1000);

		bPass = RTCC_SPI_R_MAC(uc_EUI48_array);

	  }

}

void TestSinc (void){

	alt_u8 uc_sinc_in = 0;

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	while (1){
		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		IOWR_ALTERA_AVALON_PIO_DATA(SINC_OUT_BASE, 1);
		usleep(1000*1000);
		uc_sinc_in = (IORD_ALTERA_AVALON_PIO_DATA(SINC_IN_BASE) & 0x01);
		if (uc_sinc_in == 1) {
			printf("Success");
		} else {
			printf("Failure");
		}
		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		IOWR_ALTERA_AVALON_PIO_DATA(SINC_OUT_BASE, 0);
		usleep(1000*1000);
		uc_sinc_in = (IORD_ALTERA_AVALON_PIO_DATA(SINC_IN_BASE) & 0x01);
		if (uc_sinc_in == 0) {
			printf("Success");
		} else {
			printf("Failure");
		}
	}

}

void TestLeds (void){

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	while(1){

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1G_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1G_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1R_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1R_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2G_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_2G_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2R_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_2R_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3G_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_3G_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3R_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_3R_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4G_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_4G_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4R_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_4R_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5G_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_5G_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5R_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_5R_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6G_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_6G_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6R_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_6R_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7G_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_7G_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7R_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_7R_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8G_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_8G_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8R_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_8R_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_POWER_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_POWER_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_1_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_ST_1_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_2_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_ST_2_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_3_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_ST_3_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_4_MASK);
	usleep(1000*1000);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_ST_4_MASK);
	}
}

bool TestDMA_M1_M2(void){

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

  alt_msgdma_dev *DMADev = NULL;

  if (DMA_OPEN_DEVICE(&DMADev, (char *)DMA_M1_M2_CSR_NAME) == FALSE){
    printf("Error Opening DMA Device");
    return FALSE;
  }

  if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
    printf("Error Reseting Dispatcher");
    return FALSE;
  }

  alt_u32 control_bits = 0x00000000;
  
  alt_u8 ns;
  const alt_u8 nun_steps = 32;
  const alt_u32 step = DDR2_M1_MEMORY_SIZE/nun_steps;

  alt_u32 read_addr_arr[nun_steps];
  read_addr_arr[0] = DDR2_M1_MEMORY_BASE;
  for (ns = 1; ns < nun_steps; ns++) {
	read_addr_arr[ns] = read_addr_arr[ns-1] + step;
  }

  alt_u32 write_addr_arr[nun_steps];
  write_addr_arr[0] = DDR2_M2_MEMORY_BASE;
  for (ns = 1; ns < nun_steps; ns++) {
	  write_addr_arr[ns] = write_addr_arr[ns-1] + step;
  }

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME);
	
	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  int TimeStart, TimeElapsed = 0;

  TimeStart = alt_nticks();
  if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, nun_steps, step, control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
    printf("Error During DMA Transfer");
    return FALSE;
  }
  TimeElapsed = alt_nticks() - TimeStart;
  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  if (DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME) == TRUE){
    printf("Transfer executed correctly\n");
  } else {
    printf("Transfer failed\n");
    return FALSE;
  }

  return TRUE;
}

bool TestDMA_M2_M1(void){

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

  alt_msgdma_dev *DMADev = NULL;

  if (DMA_OPEN_DEVICE(&DMADev, (char *)DMA_M2_M1_CSR_NAME) == FALSE){
    printf("Error Opening DMA Device");
    return FALSE;
  }

  if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
    printf("Error Reseting Dispatcher");
    return FALSE;
  }

  alt_u32 control_bits = 0x00000000;
  
  alt_u8 ns;
  const alt_u8 nun_steps = 32;
  const alt_u32 step = DDR2_M2_MEMORY_SIZE/nun_steps;

  alt_u32 read_addr_arr[nun_steps];
  read_addr_arr[0] = DDR2_M2_MEMORY_BASE;
  for (ns = 1; ns < nun_steps; ns++) {
	read_addr_arr[ns] = read_addr_arr[ns-1] + step;
  }

  alt_u32 write_addr_arr[nun_steps];
  write_addr_arr[0] = DDR2_M1_MEMORY_BASE;
  for (ns = 1; ns < nun_steps; ns++) {
	  write_addr_arr[ns] = write_addr_arr[ns-1] + step;
  }

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	
  int TimeStart, TimeElapsed = 0;

  TimeStart = alt_nticks();
  if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, nun_steps, step, control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
    printf("Error During DMA Transfer");
    return FALSE;
  }
  TimeElapsed = alt_nticks() - TimeStart;
  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

  if (DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME) == TRUE){
    printf("Transfer executed correctly\n");
  } else {
    printf("Transfer failed\n");
    return FALSE;
  }

  return TRUE;
}


