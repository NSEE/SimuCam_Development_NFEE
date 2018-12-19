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

/**************************************************
 * Global
 **************************************************/

typedef struct pixel_data_block_t {
	alt_u16 pixel[16];
	alt_u64 mask;
};

void TestLeds(void);
bool TestDMA_M1_M2(void);
bool TestDMA_M2_M1(void);

void COMM_WRITE_REG32(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue);
alt_u32 COMM_READ_REG32(alt_u8 uc_RegisterAddress);

int main(void) {

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	printf(" \n Nucleo de Sistemas Eletronicos Embarcados - MebX\n\n");

	//Configura Display de 7 segmentos
	SSDP_CONFIG(SSDP_NORMAL_MODE);

	printf("Windowing Control Reg: %08x \n", COMM_READ_REG32(0));
	printf("Windowing Status Reg: %08x \n", COMM_READ_REG32(1));
	printf("Windowing Buffer Reg: %08x \n", COMM_READ_REG32(6));

	COMM_WRITE_REG32(0, 0x00000102);
	//COMM_WRITE_REG32(0, 0x00000002);

	printf("Windowing Control Reg: %08x \n", COMM_READ_REG32(0));
//	switch (getchar()) {
//	case 'a':
//		printf("Windowing Control Reg: %08x \n", COMM_READ_REG32(0));
//		break;
//
//	case 't':
//		DDR2_EEPROM_TEST(DDR2_M1_ID);
//		//DDR2_EEPROM_TEST(DDR2_M2_ID);
//		break;
//
//	default:
//		printf("errou \n");
//		break;
//	}

	printf("esperando \n");
	getchar();
	printf("foi \n");

	DDR2_SWITCH_MEMORY(DDR2_M1_ID);
	alt_u32 Ddr2Base = DDR2_EXTENDED_ADDRESS_WINDOWED_BASE;

	alt_u32 *pDDR;
	pDDR = (alt_u32 *) Ddr2Base;

//	*pDDR = 5;
//	pDDR++;
//	*pDDR = 3;
//	pDDR++;
//	*pDDR = 1;
//	pDDR++;
//	*pDDR = 43;
//
//	pDDR = (alt_u32 *)Ddr2Base;
//	printf("add : %u \n", *pDDR);
//	pDDR++;
//	printf("add : %u \n", *pDDR);
//	pDDR++;
//	printf("add : %u \n", *pDDR);
//	pDDR++;
//	printf("add : %u \n", *pDDR);

// buffer: 2176 B -> 544 dwords

	int data_counter = 0;

	unsigned long data = 1;

	pDDR = (alt_u32 *) Ddr2Base;
	for (data_counter = 0; data_counter < 544; data_counter++) {
		if (data_counter >= (512 + 1)) {
			*pDDR = 0xFFFFFFFF;
			pDDR++;
		} else {
			*pDDR = 0x55FE23D9;
			data++;
			pDDR++;
		}
	}

	// Configure DMA
	alt_msgdma_dev *DMADev = NULL;

	if (DMA_OPEN_DEVICE(&DMADev, (char *) DMA_DDR_M1_CSR_NAME) == FALSE) {
		printf("Error Opening DMA Device");
		return FALSE;
	}

	if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE) {
		printf("Error Reseting Dispatcher");
		return FALSE;
	}

	alt_u32 control_bits = 0x00000000;

	int TimeStart, TimeElapsed = 0;

	TimeStart = alt_nticks();

	int n = 0;

//	while (1) {

		switch (getchar()) {
		case 'l':
			printf("liga \n");
			COMM_WRITE_REG32(0, 0x00000102);
			break;

		case 's':
			printf("send \n");

			for (n = 0; n < 16; n++) {
				if (DMA_EXTENDED_SINGLE_TRANSFER(DMADev, (alt_u32) 0x00000000,
						(alt_u32) 0x00000000, (alt_u32) 0x00000001,
						(alt_u32) 0x0001C000, 2176, control_bits, DMA_WAIT,
						DMA_DEFAULT_WAIT_PERIOD) == FALSE) {
					printf("Error During DMA Transfer");
				}
			}
			break;

		default:
			printf("errou \n");
			break;
		}

	//}

	printf("Windowing Buffer Reg: %08x \n", COMM_READ_REG32(6));
	//getchar();
	printf("passou 1 \n");

	TimeElapsed = alt_nticks() - TimeStart;
	printf("%.3f sec\n", (float) TimeElapsed / (float) alt_ticks_per_second());

//	while (COMM_READ_REG32(6) || 0x00000001){
//	*pDes = (alt_u64) 0xFFFFFFFFFFFFFFFF;
//	}
//	//printf("pDes: %08x \n", *pDes);
//
//	printf("Windowing Buffer Reg: %08x \n", COMM_READ_REG32(6));
//
//	printf("passou 2 \n");
//
//	//getchar();
//	printf("passou 3 \n");
//	//alt_u32 data = *pDes;
//
//	//getchar();
//	printf("passou 4 \n");

//printf("%d \n", data);

//if (*pSrc++ != *pDes++){

	//Realiza teste dos LEDS, entra em um loop infinito.
	TestLeds();

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
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_ALL_MASK);

	// TESTE EPC - Reset
	//ResetFTDI();

	//initWrite();

	//FTDI_WRITE_REG(FTDI_BYTE_ENABLE_BURST_REG_OFFSET, 0b00001111);
	//FTDI_WRITE_REG(FTDI_DATA_BURST_REG_OFFSET, 0xF0A0B0C0);

	while (1) {
		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		usleep(1000 * 1000);

		// TESTE EPC - Read
		//ConfigFTDIRead();
		//ReadCicle();

		// TESTE EPC - Write
		//ConfigFTDIWrite();
		//WriteCicle();

//DummyWrite();
	}

	return 0;
}

void COMM_WRITE_REG32(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue) {
	alt_u32 *pPgenAddr = COMM_PEDREIRO_V1_01_A_BASE;
	*(pPgenAddr + (alt_u32) uc_RegisterAddress) = (alt_u32) ul_RegisterValue;
}

alt_u32 COMM_READ_REG32(alt_u8 uc_RegisterAddress) {
	alt_u32 RegisterValue = 0;
	alt_u32 *pPgenAddr = COMM_PEDREIRO_V1_01_A_BASE;
	RegisterValue = *(pPgenAddr + (alt_u32) uc_RegisterAddress);
	return RegisterValue;
}

/*
 void ResetFTDI(void){
 FTDI_WRITE_REG(FTDI_RESET_N_REG_OFFSET, 0x00000000);
 FTDI_WRITE_REG(FTDI_RESET_N_REG_OFFSET, 0xffffffff);
 }

 void ConfigFTDIRead(void){
 FTDI_WRITE_REG(FTDI_OE_REG_ADDRESS_OFFSET, 0x00000000);
 FTDI_WRITE_REG(FTDI_OE_N_REG_OFFSET, 0x00000000);
 FTDI_WRITE_REG(FTDI_RD_N_REG_OFFSET, 0xffffffff);
 FTDI_WRITE_REG(FTDI_WR_N_REG_OFFSET, 0xffffffff);
 FTDI_WRITE_REG(FTDI_DATA_REG_OFFSET, 0x00000000);
 FTDI_WRITE_REG(FTDI_BE_REG_OFFSET, 0x00000000);
 }

 void ConfigFTDIWrite(void){
 FTDI_WRITE_REG(FTDI_OE_REG_ADDRESS_OFFSET, 0x00000003);
 FTDI_WRITE_REG(FTDI_OE_N_REG_OFFSET, 0x00000001);
 FTDI_WRITE_REG(FTDI_RD_N_REG_OFFSET, 0xffffffff);
 FTDI_WRITE_REG(FTDI_WR_N_REG_OFFSET, 0xffffffff);
 FTDI_WRITE_REG(FTDI_DATA_REG_OFFSET, 0xA0B1C2D3);
 FTDI_WRITE_REG(FTDI_BE_REG_OFFSET, 0xffffffff);
 }

 void ReadCicle(void) {
 bool bRX_N_State = FTDI_READ_REG(FTDI_RXF_N_REG_OFFSET);
 //printf("RXF_N Pin: %d \n", bRX_N_State);

 while(!bRX_N_State) {
 printf("RXF_N Pin: %d \n", bRX_N_State);
 FTDI_WRITE_REG(FTDI_RD_N_REG_OFFSET, 0x00000000);
 FTDI_WRITE_REG(FTDI_RD_N_REG_OFFSET, 0xffffffff);
 printf("DATA: %x \n", FTDI_READ_REG(FTDI_DATA_REG_OFFSET));
 printf("BE: %x \n", FTDI_READ_REG(FTDI_BE_REG_OFFSET));

 bRX_N_State = FTDI_READ_REG(FTDI_RXF_N_REG_OFFSET);

 usleep(5*1000);
 }
 }

 void WriteCicle(void) {
 unsigned int i = 0;
 bool bTX_N_State = FTDI_READ_REG(FTDI_TXE_N_REG_OFFSET);
 printf("TXE_N Pin: %d \n", bTX_N_State);

 while(!bTX_N_State) {
 printf("DATA: %x \n", 0xA0B1C2D3);
 FTDI_WRITE_REG(FTDI_WR_N_REG_OFFSET, 0x00000000);
 FTDI_WRITE_REG(FTDI_WR_N_REG_OFFSET, 0xffffffff);

 bTX_N_State = FTDI_READ_REG(FTDI_TXE_N_REG_OFFSET);
 printf("TXE_N Pin: %d \n", bTX_N_State);

 printf("i: %d \n", i);
 i++;

 usleep(5*1000);
 }
 }
 */

void TestLeds(void) {
	alt_8 led = 1;
	//SSDP_CONFIG(SSDP_TEST_MODE);

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	alt_u8 red = 0;

	TEMP_Read(&tempFPGA, &tempBoard);
	SSDP_UPDATE(tempFPGA);

	while (1) {
		switch (led) {
		case 1:
			LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_0_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_1_MASK);
			if (red) {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1R_MASK);
			} else {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1G_MASK);
			}
			led++;
			break;
		case 2:
			LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_1_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_2_MASK);
			if (red) {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2R_MASK);
			} else {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2G_MASK);
			}
			led++;
			break;
		case 3:
			LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_2_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_3_MASK);
			if (red) {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3R_MASK);
			} else {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3G_MASK);
			}
			led++;
			break;
		case 4:
			LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_3_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_4_MASK);
			if (red) {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4R_MASK);
			} else {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4G_MASK);
			}
			led++;
			break;
		case 5:
			LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_4_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_1_MASK);
			if (red) {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5R_MASK);
			} else {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5G_MASK);
			}
			led++;
			break;
		case 6:
			LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_5_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_2_MASK);
			if (red) {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6R_MASK);
			} else {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6G_MASK);
			}
			led++;
			break;
		case 7:
			LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_6_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_3_MASK);
			if (red) {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7R_MASK);
			} else {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7G_MASK);
			}
			led++;
			break;
		case 8:
			LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_7_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_4_MASK);
			if (red) {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8R_MASK);
			} else {
				LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8G_MASK);
			}
			led = 1;
			if (red) {
				red = 0;
			} else {
				red = 1;
			}
			break;
		default:
			led = 0;
		}

		usleep(1000 * 1000);

		LEDS_BOARD_DRIVE(LEDS_OFF, LEDS_BOARD_ALL_MASK);
		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_ST_ALL_MASK);
		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_GR_ALL_MASK);

		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);

	}
}

bool TestDMA_M1_M2(void) {

	alt_msgdma_dev *DMADev = NULL;

	if (DMA_OPEN_DEVICE(&DMADev, (char *) DMA_DDR_M1_CSR_BASE) == FALSE) {
		printf("Error Opening DMA Device");
		return FALSE;
	}

	if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE) {
		printf("Error Reseting Dispatcher");
		return FALSE;
	}

	alt_u32 control_bits = 0x00000000;

	const alt_u32 step = DDR2_M1_MEMORY_SIZE / 16;
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
	if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, 16, step,
			control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE) {
		printf("Error During DMA Transfer");
		return FALSE;
	}
	TimeElapsed = alt_nticks() - TimeStart;
	printf("%.3f sec\n", (float) TimeElapsed / (float) alt_ticks_per_second());

	if (DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M2_ID, DDR2_VERBOSE,
	DDR2_TIME) == TRUE) {
		printf("Transfer executed correctly\n");
	} else {
		printf("Transfer failed\n");
		return FALSE;
	}

	return TRUE;
}

bool TestDMA_M2_M1(void) {

	alt_msgdma_dev *DMADev = NULL;

	if (DMA_OPEN_DEVICE(&DMADev, (char *) DMA_DDR_M1_CSR_NAME) == FALSE) {
		printf("Error Opening DMA Device");
		return FALSE;
	}

	if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE) {
		printf("Error Reseting Dispatcher");
		return FALSE;
	}

	alt_u32 control_bits = 0x00000000;

	const alt_u32 step = DDR2_M2_MEMORY_SIZE / 16;
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
	if (DMA_MULTIPLE_TRANSFER(DMADev, read_addr_arr, write_addr_arr, 16, step,
			control_bits, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE) {
		printf("Error During DMA Transfer");
		return FALSE;
	}
	TimeElapsed = alt_nticks() - TimeStart;
	printf("%.3f sec\n", (float) TimeElapsed / (float) alt_ticks_per_second());

	if (DDR2_MEMORY_RANDOM_READ_TEST(DDR2_M1_ID, DDR2_VERBOSE,
	DDR2_TIME) == TRUE) {
		printf("Transfer executed correctly\n");
	} else {
		printf("Transfer failed\n");
		return FALSE;
	}

	return TRUE;
}

