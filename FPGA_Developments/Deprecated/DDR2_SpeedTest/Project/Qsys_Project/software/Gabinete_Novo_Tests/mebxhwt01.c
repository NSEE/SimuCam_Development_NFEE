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

  //Realiza teste dos LEDS, entra em um loop infinito.
  //TestLeds();

  //Teste das DDR2 EEPROMs
  //DDR2_EEPROM_TEST(DDR2_M1_ID);
  //DDR2_EEPROM_TEST(DDR2_M2_ID);
  
  //Dump das DDR2 EEPROMs
  DDR2_EEPROM_DUMP(DDR2_M1_ID);
  DDR2_EEPROM_DUMP(DDR2_M2_ID);

  //Teste de escrita de leitura da DDR2 M1
  DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME);
  //DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME);

  //Teste de escrita de leitura da DDR2 M2
  //DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);
  //DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);
  
  //Teste de transferencia com DMA (M1 -> M2);
  //TestDMA_M1_M2();
  
  //Teste de transferencia com DMA (M2 -> M1);
  //TestDMA_M2_M1();

  //TestLeds();
  //TestRTCC();
  //TestSinc();

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;
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
  
  const alt_u32 step = DDR2_M1_MEMORY_SIZE/16;
  alt_u32 read_addr_arr[16];
    read_addr_arr[0] = DDR2_M1_MEMORY_BASE;
    read_addr_arr[1] = read_addr_arr[0] + step;
    read_addr_arr[2] = read_addr_arr[1] + step;
    read_addr_arr[3] = read_addr_arr[2] + step;
    read_addr_arr[4] = read_addr_arr[3] + step;
    read_addr_arr[5] = read_addr_arr[4] + step;
    read_addr_arr[6] = read_addr_arr[5] + step;
    read_addr_arr[7] = read_addr_arr[6] + step;
    read_addr_arr[8] = read_addr_arr[7] + step;
    read_addr_arr[9] = read_addr_arr[8] + step;
    read_addr_arr[10] = read_addr_arr[9] + step;
    read_addr_arr[11] = read_addr_arr[10] + step;
    read_addr_arr[12] = read_addr_arr[11] + step;
    read_addr_arr[13] = read_addr_arr[12] + step;
    read_addr_arr[14] = read_addr_arr[13] + step;
    read_addr_arr[15] = read_addr_arr[14] + step;

  alt_u32 write_addr_arr[16];
    write_addr_arr[0] = DDR2_M2_MEMORY_BASE;
    write_addr_arr[1] = write_addr_arr[0] + step;
    write_addr_arr[2] = write_addr_arr[1] + step;
    write_addr_arr[3] = write_addr_arr[2] + step;
    write_addr_arr[4] = write_addr_arr[3] + step;
    write_addr_arr[5] = write_addr_arr[4] + step;
    write_addr_arr[6] = write_addr_arr[5] + step;
    write_addr_arr[7] = write_addr_arr[6] + step;
    write_addr_arr[8] = write_addr_arr[7] + step;
    write_addr_arr[9] = write_addr_arr[8] + step;
    write_addr_arr[10] = write_addr_arr[9] + step;
    write_addr_arr[11] = write_addr_arr[10] + step;
    write_addr_arr[12] = write_addr_arr[11] + step;
    write_addr_arr[13] = write_addr_arr[12] + step;
    write_addr_arr[14] = write_addr_arr[13] + step;
    write_addr_arr[15] = write_addr_arr[14] + step;

  DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME);
	
  int TimeStart, TimeElapsed = 0;

  TimeStart = alt_nticks();
  if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, 16, step, control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
    printf("Error During DMA Transfer");
    return FALSE;
  }
  TimeElapsed = alt_nticks() - TimeStart;
  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

  if (DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME) == TRUE){
    printf("Transfer executed correctly\n");
  } else {
    printf("Transfer failed\n");
    return FALSE;
  }

  return TRUE;
}

bool TestDMA_M2_M1(void){

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
  
  const alt_u32 step = DDR2_M2_MEMORY_SIZE/16;
  alt_u32 read_addr_arr[16];
    read_addr_arr[0] = DDR2_M2_MEMORY_BASE;
    read_addr_arr[1] = read_addr_arr[0] + step;
    read_addr_arr[2] = read_addr_arr[1] + step;
    read_addr_arr[3] = read_addr_arr[2] + step;
    read_addr_arr[4] = read_addr_arr[3] + step;
    read_addr_arr[5] = read_addr_arr[4] + step;
    read_addr_arr[6] = read_addr_arr[5] + step;
    read_addr_arr[7] = read_addr_arr[6] + step;
    read_addr_arr[8] = read_addr_arr[7] + step;
    read_addr_arr[9] = read_addr_arr[8] + step;
    read_addr_arr[10] = read_addr_arr[9] + step;
    read_addr_arr[11] = read_addr_arr[10] + step;
    read_addr_arr[12] = read_addr_arr[11] + step;
    read_addr_arr[13] = read_addr_arr[12] + step;
    read_addr_arr[14] = read_addr_arr[13] + step;
    read_addr_arr[15] = read_addr_arr[14] + step;

  alt_u32 write_addr_arr[16];
    write_addr_arr[0] = DDR2_M1_MEMORY_BASE;
    write_addr_arr[1] = write_addr_arr[0] + step;
    write_addr_arr[2] = write_addr_arr[1] + step;
    write_addr_arr[3] = write_addr_arr[2] + step;
    write_addr_arr[4] = write_addr_arr[3] + step;
    write_addr_arr[5] = write_addr_arr[4] + step;
    write_addr_arr[6] = write_addr_arr[5] + step;
    write_addr_arr[7] = write_addr_arr[6] + step;
    write_addr_arr[8] = write_addr_arr[7] + step;
    write_addr_arr[9] = write_addr_arr[8] + step;
    write_addr_arr[10] = write_addr_arr[9] + step;
    write_addr_arr[11] = write_addr_arr[10] + step;
    write_addr_arr[12] = write_addr_arr[11] + step;
    write_addr_arr[13] = write_addr_arr[12] + step;
    write_addr_arr[14] = write_addr_arr[13] + step;
    write_addr_arr[15] = write_addr_arr[14] + step;

  DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M2_ID, DDR2_VERBOSE, DDR2_TIME);
	
  int TimeStart, TimeElapsed = 0;

  TimeStart = alt_nticks();
  if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, 16, step, control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
    printf("Error During DMA Transfer");
    return FALSE;
  }
  TimeElapsed = alt_nticks() - TimeStart;
  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

  if (DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME) == TRUE){
    printf("Transfer executed correctly\n");
  } else {
    printf("Transfer failed\n");
    return FALSE;
  }

  return TRUE;
}


