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
#include "driver/seven_seg/seven_seg.h"

#include "logic/dma/dma.h"
#include "logic/sense/sense.h"
#include "logic/ddr2/ddr2.h"
#include "logic/comm/comm.h"
#include "logic/pgen/pgen.h"

/**************************************************
 * Global
**************************************************/

	alt_u32 const M1_addr = 0x00000000;
	alt_u32 const M1_size = 1*1024*1024*1024; // 1GiB
	alt_u32 const M2_addr = 0x00000000;
	alt_u32 const M2_size = 1*1024*1024*1024; // 1GiB
	alt_u32 const COMM_addr = 0x40000000;
	alt_u32 const PGEN_addr = 0x60000000;

void TestLeds(void);
bool TestDMA_M1_M2(void);
bool TestDMA_M2_M1(void);
bool TestDMA_OCM1_M1(void);
bool TestDMA_PGEN_M1(void);
bool TestDMA_PGEN_M2(void);
bool TestDMA_M1_COMM(void);
bool TestDMA_M2_COMM(void);

int main(void)
{

  alt_8 tempFPGA = 0;
  alt_8 tempBoard = 0;

  printf(" \n Nucleo de Sistemas Eletronicos Embarcados - MebX\n\n");

  //Configura Display de 7 segmentos
  SSDP_CONFIG(SSDP_NORMAL_MODE);

  TEMP_Read(&tempFPGA, &tempBoard);
  SSDP_UPDATE(tempFPGA);

  TestDMA_PGEN_M1();
  TestDMA_M1_COMM();

//  TestDMA_PGEN_M2();
//  TestDMA_M2_COMM();

//*******************************************************************************************

  //TestDMA_OCM1_M1();

  // Preencher OCM1 com dados aleatórios;
  // Verificar dados aleatórios em OCM1;
  // Transferir dados de OCM1 para M1 e medir;
  // Preencher OCM1 com zeros;
  // Verificar zeros de OCM1;
  // Transferir dados de M1 para OCM1 e medir;
  // Verificar dados aleatórios em OCM1;

//*******************************************************************************************


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

  //Acende os leds de status e atualiza a temperatura da FPGA no display de 7 segmentos a cada 1 segundo
  LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_ALL_MASK);
  while(1){
	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);
	usleep(1000*1000);
  }

  return 0;
}

void TestLeds (void){
  alt_8 led = 1;
  SSDP_CONFIG(SSDP_TEST_MODE);
  
  while(1){
    switch(led){
      case 1:
        LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_0_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_0_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_SPW_A_MASK);
        led++;
      break;
      case 2:
        LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_1_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_1_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_SPW_B_MASK);
        led++;
      break;
      case 3:
        LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_2_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_2_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_SPW_C_MASK);
        led++;
      break;
      case 4:
        LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_3_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_3_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_SPW_D_MASK);
        led++;
      break;
      case 5:
        LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_4_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_0_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_SPW_E_MASK);
        led++;
      break;
      case 6:
        LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_5_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_1_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_SPW_F_MASK);
        led++;
      break;
      case 7:
        LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_6_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_2_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_SPW_G_MASK);
        led++;
      break;
      case 8:
        LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_7_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_STATUS_3_MASK);
        LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_SPW_H_MASK);
        led = 1;
      break;
      default:
        led = 0;
    }
  
  usleep(1000*1000);
  
  LEDS_BOARD_DRIVE(LEDS_OFF, LEDS_BOARD_ALL_MASK);
  LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_STATUS_ALL_MASK);
  LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_SPW_ALL_MASK);
  
  }
}

/*
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
*/

bool TestDMA_OCM1_M1(void){

	bool bSuccess = TRUE;

	// Inicializa o DMA
	  alt_msgdma_dev *DMADev = NULL;

	  if (DMA_OPEN_DEVICE(&DMADev, (char *)DMA_M1_CSR_NAME) == FALSE){
	    printf("Error Opening DMA Device");
	    return FALSE;
	  }

	  if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
	    printf("Error Reseting Dispatcher");
	    return FALSE;
	  }

	  alt_u32 control_bits = 0x00000000;

	  alt_u16 ns;
	  const alt_u16 nun_steps = 1024;
//	  const alt_u32 step = DDR2_OCM1_MEMORY_SIZE/nun_steps;
	  const alt_u32 step = DDR2_OCM1_MEMORY_SIZE;

	  alt_u32 read_addr_arr[nun_steps];
	  read_addr_arr[0] = 0x60000000;
	  for (ns = 1; ns < nun_steps; ns++) {
//		read_addr_arr[ns] = read_addr_arr[ns-1] + step;
		read_addr_arr[ns] = read_addr_arr[ns-1];
	  }

	  alt_u32 write_addr_arr[nun_steps];
	  write_addr_arr[0] = 0x00000000;
	  for (ns = 1; ns < nun_steps; ns++) {
		  write_addr_arr[ns] = write_addr_arr[ns-1] + step;
	  }

    // Preencher OCM1 com dados aleatórios;
	DDR2_MEMORY_RANDOM_WRITE_TEST(DDR2_OCM1_ID, DDR2_VERBOSE, DDR2_TIME);

	// Verificar dados aleatórios em OCM1;
	DDR2_MEMORY_RANDOM_READ_TEST(DDR2_OCM1_ID, DDR2_VERBOSE, DDR2_TIME);

	// Transferir dados de OCM1 para M1 e medir;
	int TimeStart, TimeElapsed = 0;

	  TimeStart = alt_nticks();
	  if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, nun_steps, step, control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
	    printf("Error During DMA Transfer");
	    return FALSE;
	  }
	  int ix;
	  for (ix = 1; ix < (256); ix++){
		  write_addr_arr[0] = write_addr_arr[nun_steps-1] + step;
		  for (ns = 1; ns < nun_steps; ns++) {
			  write_addr_arr[ns] = write_addr_arr[ns-1] + step;
		  }
		  if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, nun_steps, step, control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
			  printf("Error During DMA Transfer");
			  return FALSE;
		  }
	  }

	  TimeElapsed = alt_nticks() - TimeStart;
	  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

	// Preencher OCM1 com zeros;
	  alt_u32 *pDestination;
	  for (pDestination = (alt_u32*)DDR2_OCM1_MEMORY_BASE; (alt_u32)pDestination < (DDR2_OCM1_MEMORY_BASE + DDR2_OCM1_MEMORY_SIZE); pDestination++){
	    *pDestination = 0;
	  }

	// Verificar zeros de OCM1;
	  alt_u32 *pSource;
	  for (pSource = (alt_u32*)DDR2_OCM1_MEMORY_BASE; (alt_u32)pSource < (DDR2_OCM1_MEMORY_BASE + DDR2_OCM1_MEMORY_SIZE); pSource++){
	    if (0 != *pSource){
	      bSuccess = FALSE;
	    }
	  }
	  if (bSuccess == FALSE){
		  printf("Error During Memory Clearing\n");
	  } else {
		  printf("Memory Clearing Successful\n");
	  }

/*
	// Transferir dados de M1 para OCM1 e medir;
	  TimeStart = alt_nticks();
	  if (DMA_MULTIPLE_TRANSFER(DMADev, write_addr_arr, read_addr_arr, nun_steps, step, control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
	    printf("Error During DMA Transfer");
	    return FALSE;
	  }
	  TimeElapsed = alt_nticks() - TimeStart;
	  printf("%.8f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());
	  printf("%d ticks\n", TimeElapsed);
	  printf("%d ticks per second\n", alt_ticks_per_second());

	// Verificar dados aleatórios em OCM1;
	  DDR2_MEMORY_RANDOM_READ_TEST(DDR2_OCM1_ID, DDR2_VERBOSE, DDR2_TIME);
*/
	return bSuccess;
}

bool TestDMA_PGEN_M1(void){

	// Configurar PGEN
	v_Pattern_Generator_Stop();
	printf("Stopped PGEN\n");
	if (Pattern_Generator_Configure_Initial_State(0, 0, 0) == FALSE){
		printf("Error Configuring PGEN\n");
	} else {
		printf("Configured PGEN\n");
	}
	v_Pattern_Generator_Reset();
	printf("Reseted PGEN\n");
	v_Pattern_Generator_Start();
	printf("Started PGEN\n");

	// Configurar DMA
	  alt_msgdma_dev *DMADev = NULL;

	  if (DMA_OPEN_DEVICE(&DMADev, (char *)DMA_M1_CSR_NAME) == FALSE){
	    printf("Error Opening DMA Device\n");
	    return FALSE;
	  } else {
		  printf("Opened DMA Device\n");
	  }

	  if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
	    printf("Error Reseting Dispatcher\n");
	    return FALSE;
	  } else {
	    printf("Reseted Dispatcher\n");
	  }

	  alt_u32 control_bits = 0x00000000;

	  alt_u16 ns;
	  const alt_u16 nun_steps = 16;
//	  const alt_u32 step = DDR2_OCM1_MEMORY_SIZE/nun_steps;
	  const alt_u32 step = M1_size/nun_steps;

	  alt_u32 read_addr_arr[nun_steps];
	  read_addr_arr[0] = PGEN_addr;
	  for (ns = 1; ns < nun_steps; ns++) {
//		read_addr_arr[ns] = read_addr_arr[ns-1] + step;
		read_addr_arr[ns] = read_addr_arr[ns-1];
	  }

	  alt_u32 write_addr_arr[nun_steps];
	  write_addr_arr[0] = M1_addr;
	  for (ns = 1; ns < nun_steps; ns++) {
		  write_addr_arr[ns] = write_addr_arr[ns-1] + step;
	  }

	// Transferir 1GB de dados do PGEN para a M1 (transferencias de 64 MiB) e medir;
	int TimeStart, TimeElapsed = 0;

	  TimeStart = alt_nticks();
	  if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, nun_steps, step, control_bits, DMA_WAIT, 100) == FALSE){
	    printf("Error During DMA Transfer");
	    return FALSE;
	  }

	  printf("M1 1024 MiB results: ");
	  TimeElapsed = alt_nticks() - TimeStart;
	  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

	return TRUE;
}

bool TestDMA_PGEN_M2(void){

	// Configurar PGEN
	v_Pattern_Generator_Stop();
	printf("Stopped PGEN\n");
	if (Pattern_Generator_Configure_Initial_State(0, 0, 0) == FALSE){
		printf("Error Configuring PGEN\n");
	} else {
		printf("Configured PGEN\n");
	}
	v_Pattern_Generator_Reset();
	printf("Reseted PGEN\n");
	v_Pattern_Generator_Start();
	printf("Started PGEN\n");

	// Configurar DMA
	  alt_msgdma_dev *DMADev = NULL;

	  if (DMA_OPEN_DEVICE(&DMADev, (char *)DMA_M2_CSR_NAME) == FALSE){
	    printf("Error Opening DMA Device\n");
	    return FALSE;
	  } else {
		  printf("Opened DMA Device\n");
	  }

	  if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
	    printf("Error Reseting Dispatcher\n");
	    return FALSE;
	  } else {
	    printf("Reseted Dispatcher\n");
	  }

	  alt_u32 control_bits = 0x00000000;

	  alt_u16 ns;
	  const alt_u16 nun_steps = 16;
//	  const alt_u32 step = DDR2_OCM1_MEMORY_SIZE/nun_steps;
	  const alt_u32 step = M2_size/nun_steps;

	  alt_u32 read_addr_arr[nun_steps];
	  read_addr_arr[0] = PGEN_addr;
	  for (ns = 1; ns < nun_steps; ns++) {
//		read_addr_arr[ns] = read_addr_arr[ns-1] + step;
		read_addr_arr[ns] = read_addr_arr[ns-1];
	  }

	  alt_u32 write_addr_arr[nun_steps];
	  write_addr_arr[0] = M2_addr;
	  for (ns = 1; ns < nun_steps; ns++) {
		  write_addr_arr[ns] = write_addr_arr[ns-1] + step;
	  }

	// Transferir 1GB de dados do PGEN para a M2 (transferencias de 64 MiB) e medir;
	int TimeStart, TimeElapsed = 0;

	  TimeStart = alt_nticks();
	  if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, nun_steps, step, control_bits, DMA_WAIT, 100) == FALSE){
	    printf("Error During DMA Transfer");
	    return FALSE;
	  }

	  TimeElapsed = alt_nticks() - TimeStart;
	  printf("M2 1024 MiB results: ");
	  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

	return TRUE;
}

bool TestDMA_M1_COMM(void){

	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset();
	v_Transparent_Interface_TX_FIFO_Reset();
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control(TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset();
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control(SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control(SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control(SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");

	// Espera o SPW conectar
	printf("Esperando Link SpaceWire ser iniciado...\n");
	while (!(ul_SpaceWire_Interface_Link_Status_Read() & SPWC_LINK_RUNNING_STATUS_BIT_MASK)){
		usleep(1000);
	}
	printf("Link SpaceWire iniciado!!\n");
	usleep(30*1000*1000);

	// Configurar DMA
	  alt_msgdma_dev *DMADev = NULL;

	  if (DMA_OPEN_DEVICE(&DMADev, (char *)DMA_M1_CSR_NAME) == FALSE){
	    printf("Error Opening DMA Device\n");
	    return FALSE;
	  } else {
		  printf("Opened DMA Device\n");
	  }

	  if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
	    printf("Error Reseting Dispatcher\n");
	    return FALSE;
	  } else {
	    printf("Reseted Dispatcher\n");
	  }

	  alt_u32 control_bits = 0x00000000;

	  alt_u32 read_addr  = M1_addr;
	  alt_u32 write_addr = COMM_addr;
	  alt_u32 size       = 4*1024; // 4 kiB

	// Transfere 4 kiB de dados da M1 para COMM e medir;
		int TimeStart, TimeElapsed = 0;

		  TimeStart = alt_nticks();
		  if (DMA_SINGLE_TRANSFER(DMADev, read_addr, write_addr, size, control_bits, DMA_WAIT, 100) == FALSE){
		    printf("Error During DMA Transfer");
		    return FALSE;
		  }

		  TimeElapsed = alt_nticks() - TimeStart;
		  printf("M1 to COMM, 4 kiB results: ");
		  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

		return TRUE;
}

bool TestDMA_M2_COMM(void){

	// Configura COMM
		// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset();
	v_Transparent_Interface_TX_FIFO_Reset();
	printf("Fifos da interface transparente resetados\n");
		// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control(TRAN_REG_SET, TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface Transparente Habilitada\n");
		// Reseta Codec
	v_SpaceWire_Interface_Force_Reset();
	printf("Codec Resetado\n");
		// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control(SPWC_REG_SET, SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK);
	printf("Interface SpaceWire Habilitado\n");
		// Coloca Codec no modo Normal
	b_SpaceWire_Interface_Mode_Control(SPWC_INTERFACE_NORMAL_MODE);
	printf("Interface SpaceWire colocado no modo Normal\n");
		// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control(SPWC_REG_SET, SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("Codec SpaceWire colocado no Link Autostart\n");

	// Espera o SPW conectar
	printf("Esperando Link SpaceWire ser iniciado...\n");
	while (!(ul_SpaceWire_Interface_Link_Status_Read() & SPWC_LINK_RUNNING_STATUS_BIT_MASK)){
		usleep(1000);
	}
	printf("Link SpaceWire iniciado!!\n");
	usleep(30*1000*1000);

	// Configurar DMA
	  alt_msgdma_dev *DMADev = NULL;

	  if (DMA_OPEN_DEVICE(&DMADev, (char *)DMA_M2_CSR_NAME) == FALSE){
	    printf("Error Opening DMA Device\n");
	    return FALSE;
	  } else {
		  printf("Opened DMA Device\n");
	  }

	  if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
	    printf("Error Reseting Dispatcher\n");
	    return FALSE;
	  } else {
	    printf("Reseted Dispatcher\n");
	  }

	  alt_u32 control_bits = 0x00000000;

	  alt_u32 read_addr  = M2_addr;
	  alt_u32 write_addr = COMM_addr;
	  alt_u32 size       = 4*1024; // 4 kiB

	// Transfere 4 kiB de dados da M2 para COMM e medir;
		int TimeStart, TimeElapsed = 0;

		  TimeStart = alt_nticks();
		  if (DMA_SINGLE_TRANSFER(DMADev, read_addr, write_addr, size, control_bits, DMA_WAIT, 100) == FALSE){
		    printf("Error During DMA Transfer");
		    return FALSE;
		  }

		  TimeElapsed = alt_nticks() - TimeStart;
		  printf("M2 to COMM, 4 kiB results: ");
		  printf("%.3f sec\n", (float)TimeElapsed/(float)alt_ticks_per_second());

		return TRUE;

}
