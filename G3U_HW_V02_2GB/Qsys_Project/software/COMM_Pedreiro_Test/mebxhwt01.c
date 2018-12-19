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

#include "driver/comm/comm.h"
#include "driver/fee_buffers/fee_buffers.h"

/**************************************************
 * Global
 **************************************************/

comm_channel_t spw_a;
comm_channel_t spw_b;
comm_channel_t spw_c;
comm_channel_t spw_d;
comm_channel_t spw_e;
comm_channel_t spw_f;
comm_channel_t spw_g;
comm_channel_t spw_h;

void TestLeds(void);
bool TestDMA_M1_M2(void);
bool TestDMA_M2_M1(void);

int main(void) {

	alt_8 tempFPGA = 0;
	alt_8 tempBoard = 0;

	printf(" \n Nucleo de Sistemas Eletronicos Embarcados - MebX\n\n");

	//Configura Display de 7 segmentos
	SSDP_CONFIG(SSDP_NORMAL_MODE);

	comm_init_channel(&spw_a, spacewire_channel_a);
	comm_init_channel(&spw_b, spacewire_channel_b);
	comm_init_channel(&spw_c, spacewire_channel_c);
	comm_init_channel(&spw_d, spacewire_channel_d);
	comm_init_channel(&spw_e, spacewire_channel_e);
	comm_init_channel(&spw_f, spacewire_channel_f);
	comm_init_channel(&spw_g, spacewire_channel_g);
	comm_init_channel(&spw_h, spacewire_channel_h);

	spw_a.windowing_config.masking = TRUE;
	spw_a.link_config.autostart = TRUE;
	comm_config_windowing(&spw_a);
	comm_config_link(&spw_a);

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

	fee_pixel_data_block_t *pixel_block = (fee_pixel_data_block_t *) Ddr2Base;

	pixel_block->pixel[0] = 0x0100;
	pixel_block->pixel[1] = 0x0302;
	pixel_block->pixel[2] = 0x0504;
	pixel_block->pixel[3] = 0x0706;
	pixel_block->pixel[4] = 0x0908;
	pixel_block->pixel[5] = 0x0B0A;
	pixel_block->pixel[6] = 0x0D0C;
	pixel_block->pixel[7] = 0x0F0E;
	pixel_block->pixel[8] = 0x1110;
	pixel_block->pixel[9] = 0x1312;
	pixel_block->pixel[10] = 0x1514;
	pixel_block->pixel[11] = 0x1716;
	pixel_block->pixel[12] = 0x1918;
	pixel_block->pixel[13] = 0x1B1A;
	pixel_block->pixel[14] = 0x1D1C;
	pixel_block->pixel[15] = 0x1F1E;
	pixel_block->pixel[16] = 0x2120;
	pixel_block->pixel[17] = 0x2322;
	pixel_block->pixel[18] = 0x2524;
	pixel_block->pixel[19] = 0x2726;
	pixel_block->pixel[20] = 0x2928;
	pixel_block->pixel[21] = 0x2B2A;
	pixel_block->pixel[22] = 0x2D2C;
	pixel_block->pixel[23] = 0x2F2E;
	pixel_block->pixel[24] = 0x3130;
	pixel_block->pixel[25] = 0x3332;
	pixel_block->pixel[26] = 0x3534;
	pixel_block->pixel[27] = 0x3736;
	pixel_block->pixel[28] = 0x3938;
	pixel_block->pixel[29] = 0x3B3A;
	pixel_block->pixel[30] = 0x3D3C;
	pixel_block->pixel[31] = 0x3F3E;
	pixel_block->pixel[32] = 0x4140;
	pixel_block->pixel[33] = 0x4342;
	pixel_block->pixel[34] = 0x4544;
	pixel_block->pixel[35] = 0x4746;
	pixel_block->pixel[36] = 0x4948;
	pixel_block->pixel[37] = 0x4B4A;
	pixel_block->pixel[38] = 0x4D4C;
	pixel_block->pixel[39] = 0x4F4E;
	pixel_block->pixel[40] = 0x5150;
	pixel_block->pixel[41] = 0x5352;
	pixel_block->pixel[42] = 0x5554;
	pixel_block->pixel[43] = 0x5756;
	pixel_block->pixel[44] = 0x5958;
	pixel_block->pixel[45] = 0x5B5A;
	pixel_block->pixel[46] = 0x5D5C;
	pixel_block->pixel[47] = 0x5F5E;
	pixel_block->pixel[48] = 0x6160;
	pixel_block->pixel[49] = 0x6362;
	pixel_block->pixel[50] = 0x6564;
	pixel_block->pixel[51] = 0x6766;
	pixel_block->pixel[52] = 0x6968;
	pixel_block->pixel[53] = 0x6B6A;
	pixel_block->pixel[54] = 0x6D6C;
	pixel_block->pixel[55] = 0x6F6E;
	pixel_block->pixel[56] = 0x7170;
	pixel_block->pixel[57] = 0x7372;
	pixel_block->pixel[58] = 0x7574;
	pixel_block->pixel[59] = 0x7776;
	pixel_block->pixel[60] = 0x7978;
	pixel_block->pixel[61] = 0x7B7A;
	pixel_block->pixel[62] = 0x7D7C;
	pixel_block->pixel[63] = 0x7F7E;
	pixel_block->mask = 0xFFFFFFFFFFFFFFFF;

//	pixel_block->pixel[0    ] =  0x8180 ;
//	pixel_block->pixel[1    ] =  0x8382 ;
//	pixel_block->pixel[2    ] =  0x8584 ;
//	pixel_block->pixel[3    ] =  0x8786 ;
//	pixel_block->pixel[4    ] =  0x8988 ;
//	pixel_block->pixel[5    ] =  0x8B8A ;
//	pixel_block->pixel[6    ] =  0x8D8C ;
//	pixel_block->pixel[7    ] =  0x8F8E ;
//	pixel_block->pixel[8    ] =  0x9190 ;
//	pixel_block->pixel[9    ] =  0x9392 ;
//	pixel_block->pixel[10   ] =  0x9594 ;
//	pixel_block->pixel[11   ] =  0x9796 ;
//	pixel_block->pixel[12   ] =  0x9998 ;
//	pixel_block->pixel[13   ] =  0x9B9A ;
//	pixel_block->pixel[14   ] =  0x9D9C ;
//	pixel_block->pixel[15   ] =  0x9F9E ;
//	pixel_block->pixel[16   ] =  0xA1A0 ;
//	pixel_block->pixel[17   ] =  0xA3A2 ;
//	pixel_block->pixel[18   ] =  0xA5A4 ;
//	pixel_block->pixel[19   ] =  0xA7A6 ;
//	pixel_block->pixel[20   ] =  0xA9A8 ;
//	pixel_block->pixel[21   ] =  0xABAA ;
//	pixel_block->pixel[22   ] =  0xADAC ;
//	pixel_block->pixel[23   ] =  0xAFAE ;
//	pixel_block->pixel[24   ] =  0xB1B0 ;
//	pixel_block->pixel[25   ] =  0xB3B2 ;
//	pixel_block->pixel[26   ] =  0xB5B4 ;
//	pixel_block->pixel[27   ] =  0xB7B6 ;
//	pixel_block->pixel[28   ] =  0xB9B8 ;
//	pixel_block->pixel[29   ] =  0xBBBA ;
//	pixel_block->pixel[30   ] =  0xBDBC ;
//	pixel_block->pixel[31   ] =  0xBFBE ;
//	pixel_block->pixel[32   ] =  0xC1C0 ;
//	pixel_block->pixel[33   ] =  0xC3C2 ;
//	pixel_block->pixel[34   ] =  0xC5C4 ;
//	pixel_block->pixel[35   ] =  0xC7C6 ;
//	pixel_block->pixel[36   ] =   0xC9C8;
//	pixel_block->pixel[37   ] =   0xCBCA;
//	pixel_block->pixel[38   ] =   0xCDCC;
//	pixel_block->pixel[39   ] =   0xCFCE;
//	pixel_block->pixel[40   ] =   0xD1D0;
//	pixel_block->pixel[41   ] =   0xD3D2;
//	pixel_block->pixel[42   ] =   0xD5D4;
//	pixel_block->pixel[43   ] =   0xD7D6;
//	pixel_block->pixel[44   ] =   0xD9D8;
//	pixel_block->pixel[45   ] =   0xDBDA;
//	pixel_block->pixel[46   ] =   0xDDDC;
//	pixel_block->pixel[47   ] =   0xDFDE;
//	pixel_block->pixel[48   ] =   0xE1E0;
//	pixel_block->pixel[49   ] =   0xE3E2;
//	pixel_block->pixel[50   ] =   0xE5E4;
//	pixel_block->pixel[51   ] =   0xE7E6;
//	pixel_block->pixel[52   ] =   0xE9E8;
//	pixel_block->pixel[53   ] =   0xEBEA;
//	pixel_block->pixel[54   ] =   0xEDEC;
//	pixel_block->pixel[55   ] =   0xEFEE;
//	pixel_block->pixel[56   ] =   0xF1F0;
//	pixel_block->pixel[57   ] =   0xF3F2;
//	pixel_block->pixel[58   ] =   0xF5F4;
//	pixel_block->pixel[59   ] =   0xF7F6;
//	pixel_block->pixel[60   ] =   0xF9F8;
//	pixel_block->pixel[61   ] =   0xFBFA;
//	pixel_block->pixel[62   ] =   0xFDFC;
//	pixel_block->pixel[63   ] =   0xFFFE;

//	unsigned long data = 1;
//
//	pDDR = (alt_u32 *) Ddr2Base;
//	for (data_counter = 0; data_counter < 544; data_counter++) {
//		if (data_counter >= (512 + 1)) {
//			*pDDR = 0xFFFFFFFF;
//			pDDR++;
//		} else {
//			*pDDR = 0x55FE23D9;
//			data++;
//			pDDR++;
//		}
//	}

//	pDDR = (alt_u32 *) Ddr2Base;
//	for (data_counter = 0; data_counter < (136/4); data_counter++) {
//		printf("mem[%03u]: %08X \n", data_counter, *pDDR);
//		pDDR++;
//	}

// init DMA

	if (fee_init_m1_dma()) {
		printf("dma_m1 iniciado corretamente \n");
	}

	if (fee_init_m2_dma()) {
		printf("dma_m2 iniciado corretamente \n");
	}

	while (1) {
		printf("selecione memoria \n");
		switch (getchar()) {
		case '1':
			printf("m1 \n");
			if (fee_dma_m1_transfer(0, 16, right_buffer, channel_a_buffer)) {
				printf("dma_m1 transferido corretamente \n");
			}
			break;

		case '2':
			printf("m2 \n");
			if (fee_dma_m2_transfer(0, 16, right_buffer, channel_a_buffer)) {
				printf("dma_m2 transferido corretamente \n");
			}
			break;

		case 'a':
			printf("a \n");
			if (fee_dma_m1_transfer(0, 256, right_buffer, channel_a_buffer)) {
				printf("dma_m1 transferido corretamente \n");
			}
			usleep(500);
			comm_update_buffers_status(&spw_a);
			printf("empty: %u \n", spw_a.buffer_status.right_buffer_empty);
			break;

		default:
			printf("errou \n");
			break;
		}
	}
//}

//getchar();
	printf("passou 1 \n");

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

