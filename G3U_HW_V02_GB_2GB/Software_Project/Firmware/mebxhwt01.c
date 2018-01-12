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
#include "logic/comm/comm.h"
#include "logic/pgen/pgen.h"

/**************************************************
 * Global
**************************************************/

void DemoModeSpW(void);
void DemoModeLeds(void);
void TestLeds(void);
void TestSinc(void);
void TestRTCC(void);
bool TestDMA_M1_M2(void);
bool TestDMA_M2_M1(void);
bool Connection_Test_SpW(char c_SpwID, alt_u16 ui_minutos);

void Configure_SpW_Autostart(char c_SpwID);
void Set_SpW_Led(char c_SpwID);

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
  //DDR2_EEPROM_DUMP(DDR2_M1_ID);
  //DDR2_EEPROM_DUMP(DDR2_M2_ID);

  //Teste de escrita de leitura da DDR2 M1
  //DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_M1_ID, DDR2_VERBOSE, DDR2_TIME);
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

  sense_log();
  
  //LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_PAINEL_ALL_MASK);
  //LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_POWER_MASK);
  //LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_R_ALL_MASK);
  //Connection_Test_SpW('A', 5);
  //Connection_Test_SpW('B', 5);
  //Connection_Test_SpW('C', 5);
  //Connection_Test_SpW('D', 5);
  //Connection_Test_SpW('E', 5);
  //Connection_Test_SpW('F', 5);
  //Connection_Test_SpW('G', 5);
  //Connection_Test_SpW('H', 5);
  //LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_PAINEL_ALL_MASK);

  DemoModeSpW();
  DemoModeLeds();

	while(1){

			usleep(1000*1000);

	}

  return 0;
}

void DemoModeSpW(void){

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	alt_u32 st_leds_mask[4] = {LEDS_ST_1_MASK, LEDS_ST_2_MASK, LEDS_ST_3_MASK, LEDS_ST_4_MASK};
	alt_u8 st_leds_cnt = 0;

	LEDS_BOARD_DRIVE(LEDS_OFF, LEDS_BOARD_ALL_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_POWER_MASK);

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

	// Iniciar os módulos SpW no modo Autostart
	Configure_SpW_Autostart('A');
	Configure_SpW_Autostart('B');
	Configure_SpW_Autostart('C');
	Configure_SpW_Autostart('D');
	Configure_SpW_Autostart('E');
	Configure_SpW_Autostart('F');
	Configure_SpW_Autostart('G');
	Configure_SpW_Autostart('H');

	// Loop infinito
	//// A cada 1 segundo
	////// Atualiza a temperatura no display de sete segmentos
	////// Pisca uma luz de status diferente (ST1-ST4)
	//// A cada 10 ms
	////// Atualiza os Leds SpW de acordo com o status do link (r - standby, g - running, rg - erro)

	alt_u8 time_cnt = 100;
	while (1){
		time_cnt++;
		Set_SpW_Led('A');
		Set_SpW_Led('B');
		Set_SpW_Led('C');
		Set_SpW_Led('D');
		Set_SpW_Led('E');
		Set_SpW_Led('F');
		Set_SpW_Led('G');
		Set_SpW_Led('H');

		if (time_cnt >= 100){ // 10ms * 100 = 1000ms = 1s
			time_cnt = 0;

			TEMP_Read(&tempFPGA, &tempBoard);
			SSDP_UPDATE(tempFPGA);

			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_ST_1_MASK | LEDS_ST_2_MASK | LEDS_ST_3_MASK | LEDS_ST_4_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, st_leds_mask[st_leds_cnt]);
			st_leds_cnt = (st_leds_cnt + 1) & 0x03; // Valores de 0-3, 2 bits

		}
		usleep(10*1000);
	}

}

void DemoModeLeds(void){

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	LEDS_BOARD_DRIVE(LEDS_OFF, LEDS_BOARD_ALL_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_POWER_MASK);

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

		if (bPass) {
			printf("RTCC Test Succeeded!\n");
		} else {
			printf("RTCC Test Failed!\n");
		}

	  }

}

void TestSinc (void){

	alt_u8 uc_sinc_in = 0;

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;
	alt_u32 State = alt_nticks();
	alt_u32 x = 0;
	alt_u8 SincValue = 0;

	while (1){

		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);

		//RNG - XorShift32
		x = State;
		x ^= x << 13;
		x ^= x >> 17;
		x ^= x << 5;
		State = x;

		//Informação do Sinc é se o valor é par ou ímpar
		SincValue = (alt_u8)(State & 0x00000001);

		IOWR_ALTERA_AVALON_PIO_DATA(SINC_OUT_BASE, SincValue);
		usleep(1000*1000);

		uc_sinc_in = (IORD_ALTERA_AVALON_PIO_DATA(SINC_IN_BASE) & 0x01);
		if (uc_sinc_in == SincValue) {
			printf("Success, Value: %d\n", SincValue);
		} else {
			printf("Failure, Value: %d\n", SincValue);
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

/*
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
*/

bool Connection_Test_SpW(char c_SpwID, alt_u16 ui_minutos){
	bool bPass = FALSE;
	
	alt_u32 ui_leds_mask_r = 0;
	alt_u32 ui_leds_mask_g = 0;
	switch (c_SpwID){
		case 'A':
			ui_leds_mask_r = LEDS_1R_MASK;
			ui_leds_mask_g = LEDS_1G_MASK;
		break;
		case 'B':
			ui_leds_mask_r = LEDS_2R_MASK;
			ui_leds_mask_g = LEDS_2G_MASK;
		break;
		case 'C':
			ui_leds_mask_r = LEDS_3R_MASK;
			ui_leds_mask_g = LEDS_3G_MASK;
		break;
		case 'D':
			ui_leds_mask_r = LEDS_4R_MASK;
			ui_leds_mask_g = LEDS_4G_MASK;
		break;
		case 'E':
			ui_leds_mask_r = LEDS_5R_MASK;
			ui_leds_mask_g = LEDS_5G_MASK;
		break;
		case 'F':
			ui_leds_mask_r = LEDS_6R_MASK;
			ui_leds_mask_g = LEDS_6G_MASK;
		break;
		case 'G':
			ui_leds_mask_r = LEDS_7R_MASK;
			ui_leds_mask_g = LEDS_7G_MASK;
		break;
		case 'H':
			ui_leds_mask_r = LEDS_8R_MASK;
			ui_leds_mask_g = LEDS_8G_MASK;
		break;
	}

	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset(c_SpwID);
	v_Transparent_Interface_TX_FIFO_Reset(c_SpwID);
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control(c_SpwID, TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset(c_SpwID);
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control(c_SpwID, SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control(c_SpwID, SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_CLEAR, SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK | SPWC_LINK_START_CONTROL_BIT_MASK);
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	usleep(1000*1000);
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_SET, SPWC_LINK_START_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Start\n");
	printf("SpaceWire %c configurado\n", c_SpwID);
	
	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	// Espera o SPW conectar
	printf("Esperando Link SpaceWire ser iniciado...\n");
	while (!(ul_SpaceWire_Interface_Link_Status_Read(c_SpwID) & SPWC_LINK_RUNNING_STATUS_BIT_MASK)){
		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		usleep(1000*1000);
	}
	printf("Link SpaceWire %c iniciado!!\n", c_SpwID);

	LEDS_PAINEL_DRIVE(LEDS_OFF, ui_leds_mask_r);
	LEDS_PAINEL_DRIVE(LEDS_ON, ui_leds_mask_g);
	bPass = TRUE;

	alt_u16 ui_min_couter = 0;
	alt_u16 ui_next_milestone = 60;
	alt_u16 ui_minutos_print_counter = 0;
	printf("Aguardando %d minutos para testar consistencia do link\n", ui_minutos);
	for (ui_min_couter = 0; ui_min_couter < (ui_minutos*60); ui_min_couter++){
		if (ui_min_couter >= ui_next_milestone){
			ui_next_milestone += 60;
			ui_minutos_print_counter++;
			printf("  Faltando %d minutos...\n", ui_minutos - ui_minutos_print_counter);
		}
		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		if ((!(ul_SpaceWire_Interface_Link_Status_Read(c_SpwID) & SPWC_LINK_RUNNING_STATUS_BIT_MASK))) {
			// Link caiu
			printf("Queda do Link SpaceWire %c!!\n", c_SpwID);
			printf("Teste abortado!!\n");
			bPass = FALSE;
			break;
		}
		usleep(1000*1000);
	}
	printf("Desconectando Link SpaceWire %c!!\n", c_SpwID);
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_CLEAR, SPWC_LINK_START_CONTROL_BIT_MASK);
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_SET, SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK);

	LEDS_PAINEL_DRIVE(LEDS_OFF, ui_leds_mask_g);
	LEDS_PAINEL_DRIVE(LEDS_ON, ui_leds_mask_r);

	printf("Testes terminados!!\n\n");

	return bPass;
}

void Configure_SpW_Autostart(char c_SpwID){
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset(c_SpwID);
	v_Transparent_Interface_TX_FIFO_Reset(c_SpwID);
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control(c_SpwID, TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset(c_SpwID);
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control(c_SpwID, SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control(c_SpwID, SPWC_INTERFACE_NORMAL_MODE);
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_CLEAR, SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK | SPWC_LINK_START_CONTROL_BIT_MASK);
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("SpaceWire %c configurado\n", c_SpwID);
}

void Set_SpW_Led(char c_SpwID){
	alt_u32 ui_leds_mask_r = 0;
	alt_u32 ui_leds_mask_g = 0;
	switch (c_SpwID){
		case 'A':
			ui_leds_mask_r = LEDS_1R_MASK;
			ui_leds_mask_g = LEDS_1G_MASK;
		break;
		case 'B':
			ui_leds_mask_r = LEDS_2R_MASK;
			ui_leds_mask_g = LEDS_2G_MASK;
		break;
		case 'C':
			ui_leds_mask_r = LEDS_3R_MASK;
			ui_leds_mask_g = LEDS_3G_MASK;
		break;
		case 'D':
			ui_leds_mask_r = LEDS_4R_MASK;
			ui_leds_mask_g = LEDS_4G_MASK;
		break;
		case 'E':
			ui_leds_mask_r = LEDS_5R_MASK;
			ui_leds_mask_g = LEDS_5G_MASK;
		break;
		case 'F':
			ui_leds_mask_r = LEDS_6R_MASK;
			ui_leds_mask_g = LEDS_6G_MASK;
		break;
		case 'G':
			ui_leds_mask_r = LEDS_7R_MASK;
			ui_leds_mask_g = LEDS_7G_MASK;
		break;
		case 'H':
			ui_leds_mask_r = LEDS_8R_MASK;
			ui_leds_mask_g = LEDS_8G_MASK;
		break;
	}
	alt_u32 SpW_Link_Status = ul_SpaceWire_Interface_Link_Status_Read(c_SpwID);
	if (SpW_Link_Status & SPWC_LINK_RUNNING_STATUS_BIT_MASK){
		LEDS_PAINEL_DRIVE(LEDS_OFF, ui_leds_mask_r);
		LEDS_PAINEL_DRIVE(LEDS_ON, ui_leds_mask_g);
	} else if (SpW_Link_Status & (SPWC_LINK_DISCONNECT_ERROR_BIT_MASK | SPWC_LINK_PARITY_ERROR_BIT_MASK | SPWC_LINK_ESCAPE_ERROR_BIT_MASK | SPWC_LINK_CREDIT_ERROR_BIT_MASK)){
		LEDS_PAINEL_DRIVE(LEDS_ON, ui_leds_mask_g | ui_leds_mask_r);
	} else {
		LEDS_PAINEL_DRIVE(LEDS_OFF, ui_leds_mask_g);
		LEDS_PAINEL_DRIVE(LEDS_ON, ui_leds_mask_r);
	}
}
