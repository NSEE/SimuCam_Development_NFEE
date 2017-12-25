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

void DemoMode(void);
void TestLeds(void);
void TestSinc(void);
void TestRTCC(void);
bool TestDMA_M1_M2(void);
bool TestDMA_M2_M1(void);
bool Configure_SpW_A(void);
bool Configure_SpW_B(void);
bool Configure_SpW_C(void);
bool Configure_SpW_D(void);
bool Configure_SpW_E(void);
bool Configure_SpW_F(void);
bool Configure_SpW_G(void);
bool Configure_SpW_H(void);

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
  
  Configure_SpW_A();
  Configure_SpW_B();
  Configure_SpW_C();
  Configure_SpW_D();
  Configure_SpW_E();
  Configure_SpW_F();
  Configure_SpW_G();
  Configure_SpW_H();

  DemoMode();

	while(1){

			usleep(1000*1000);

	}

  return 0;
}

void DemoMode(void){

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

bool Configure_SpW_A(void){
	bool bPass = FALSE;
	
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset('A');
	v_Transparent_Interface_TX_FIFO_Reset('A');
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control('A', TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset('A');
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control('A', SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control('A', SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control('A', SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	printf("SpaceWire A configurado\n");
	
	bPass = TRUE;
	return bPass;
}

bool Configure_SpW_B(void){
	bool bPass = FALSE;
	
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset('B');
	v_Transparent_Interface_TX_FIFO_Reset('B');
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control('B', TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset('B');
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control('B', SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control('B', SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control('B', SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	printf("SpaceWire B configurado\n");
	
	bPass = TRUE;
	return bPass;
}

bool Configure_SpW_C(void){
	bool bPass = FALSE;
	
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset('C');
	v_Transparent_Interface_TX_FIFO_Reset('C');
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control('C', TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset('C');
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control('C', SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control('C', SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control('C', SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	printf("SpaceWire C configurado\n");
	
	bPass = TRUE;
	return bPass;
}

bool Configure_SpW_D(void){
	bool bPass = FALSE;
	
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset('D');
	v_Transparent_Interface_TX_FIFO_Reset('D');
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control('D', TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset('D');
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control('D', SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control('D', SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control('D', SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	printf("SpaceWire D configurado\n");
	
	bPass = TRUE;
	return bPass;
}

bool Configure_SpW_E(void){
	bool bPass = FALSE;
	
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset('E');
	v_Transparent_Interface_TX_FIFO_Reset('E');
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control('E', TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset('E');
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control('E', SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control('E', SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control('E', SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	printf("SpaceWire E configurado\n");
	
	bPass = TRUE;
	return bPass;
}

bool Configure_SpW_F(void){
	bool bPass = FALSE;
	
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset('F');
	v_Transparent_Interface_TX_FIFO_Reset('F');
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control('F', TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset('F');
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control('F', SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control('F', SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control('F', SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	printf("SpaceWire F configurado\n");
	
	bPass = TRUE;
	return bPass;
}

bool Configure_SpW_G(void){
	bool bPass = FALSE;
	
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset('G');
	v_Transparent_Interface_TX_FIFO_Reset('G');
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control('G', TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset('G');
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control('G', SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control('G', SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control('G', SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	printf("SpaceWire G configurado\n");
	
	bPass = TRUE;
	return bPass;
}

bool Configure_SpW_H(void){
	bool bPass = FALSE;
	
	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset('H');
	v_Transparent_Interface_TX_FIFO_Reset('H');
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control('H', TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset('H');
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control('H', SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control('H', SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control('H', SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");
	printf("SpaceWire H configurado\n");
	
	bPass = TRUE;
	return bPass;
}