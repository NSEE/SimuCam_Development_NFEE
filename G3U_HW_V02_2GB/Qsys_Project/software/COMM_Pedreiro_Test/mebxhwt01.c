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
#include "driver/reset/reset.h"
#include "driver/ctrl_io_lvds/ctrl_io_lvds.h"

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

//	rstc_hold_device_reset(RSTC_DEVICE_ALL_MASK);
//	usleep(5000);
	rstc_release_device_reset(RSTC_DEVICE_ALL_MASK);
	usleep(5000);
	usleep(5000000);

	disable_iso_drivers();
	disable_lvds_board();

	usleep(50000);

	enable_iso_drivers();
	enable_lvds_board();

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

//	comm_init_interrupt(spacewire_channel_a);
//	int_cnt = 0;
//	printf("int_cnt: %u \n", int_cnt);
//
//	spw_a.int_control.right_buffer_empty_en = FALSE;
//	comm_config_int_control(&spw_a);

	spw_a.link_config.autostart = FALSE;
	spw_a.link_config.start = FALSE;
	spw_a.link_config.disconnect = TRUE;
	spw_b.link_config.autostart = FALSE;
	spw_b.link_config.start = FALSE;
	spw_b.link_config.disconnect = TRUE;
	spw_c.link_config.autostart = FALSE;
	spw_c.link_config.start = FALSE;
	spw_c.link_config.disconnect = TRUE;
	spw_d.link_config.autostart = FALSE;
	spw_d.link_config.start = FALSE;
	spw_d.link_config.disconnect = TRUE;
	spw_e.link_config.autostart = FALSE;
	spw_e.link_config.start = FALSE;
	spw_e.link_config.disconnect = TRUE;
	spw_f.link_config.autostart = FALSE;
	spw_f.link_config.start = FALSE;
	spw_f.link_config.disconnect = TRUE;
	spw_g.link_config.autostart = FALSE;
	spw_g.link_config.start = FALSE;
	spw_g.link_config.disconnect = TRUE;
	spw_h.link_config.autostart = FALSE;
	spw_h.link_config.start = FALSE;
	spw_h.link_config.disconnect = TRUE;
	comm_config_link(&spw_a);
	comm_config_link(&spw_b);
	comm_config_link(&spw_c);
	comm_config_link(&spw_d);
	comm_config_link(&spw_e);
	comm_config_link(&spw_f);
	comm_config_link(&spw_g);
	comm_config_link(&spw_h);

	usleep(50000);
	usleep(5000000);

	spw_a.windowing_config.masking = TRUE;
	spw_a.link_config.autostart = TRUE;
//	spw_a.link_config.start = TRUE;
	spw_a.link_config.disconnect = FALSE;
	spw_b.windowing_config.masking = TRUE;
	spw_b.link_config.autostart = TRUE;
//	spw_b.link_config.start = TRUE;
	spw_b.link_config.disconnect = FALSE;
	spw_c.windowing_config.masking = TRUE;
	spw_c.link_config.autostart = TRUE;
//	spw_c.link_config.start = TRUE;
	spw_c.link_config.disconnect = FALSE;
	spw_d.windowing_config.masking = TRUE;
	spw_d.link_config.autostart = TRUE;
//	spw_d.link_config.start = TRUE;
	spw_d.link_config.disconnect = FALSE;
	spw_e.windowing_config.masking = TRUE;
	spw_e.link_config.autostart = TRUE;
//	spw_e.link_config.start = TRUE;
	spw_e.link_config.disconnect = FALSE;
	spw_f.windowing_config.masking = TRUE;
	spw_f.link_config.autostart = TRUE;
//	spw_f.link_config.start = TRUE;
	spw_f.link_config.disconnect = FALSE;
	spw_g.windowing_config.masking = TRUE;
	spw_g.link_config.autostart = TRUE;
//	spw_g.link_config.start = TRUE;
	spw_g.link_config.disconnect = FALSE;
	spw_h.windowing_config.masking = TRUE;
	spw_h.link_config.autostart = TRUE;
//	spw_h.link_config.start = TRUE;
	spw_h.link_config.disconnect = FALSE;
	comm_config_windowing(&spw_a);
	comm_config_windowing(&spw_b);
	comm_config_windowing(&spw_c);
	comm_config_windowing(&spw_d);
	comm_config_windowing(&spw_e);
	comm_config_windowing(&spw_f);
	comm_config_windowing(&spw_g);
	comm_config_windowing(&spw_h);
	comm_config_link(&spw_a);
	comm_config_link(&spw_b);
	comm_config_link(&spw_c);
	comm_config_link(&spw_d);
	comm_config_link(&spw_e);
	comm_config_link(&spw_f);
	comm_config_link(&spw_g);
	comm_config_link(&spw_h);

//	spw_a.windowing_config.masking = TRUE;
//	comm_config_windowing(&spw_a);

//	spw_h.link_config.autostart = TRUE;
//	comm_config_link(&spw_h);
//
//	comm_update_link(&spw_h);
//	printf("empty r: %u \n", spw_h.link_config.autostart);
//	rstc_hold_device_reset(RSTC_DEVICE_COMM_CH8_RST_CONTROL_MASK);
//	usleep(5000);
//	rstc_release_device_reset(RSTC_DEVICE_COMM_CH8_RST_CONTROL_MASK);
//	comm_update_link(&spw_h);
//	printf("empty r: %u \n", spw_h.link_config.autostart);
//
//	spw_h.link_config.autostart = TRUE;
//	comm_config_link(&spw_h);
//
//	comm_update_link(&spw_h);
//	printf("empty r: %u \n", spw_h.link_config.autostart);

	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_POWER_MASK);

	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1G_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1R_MASK);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_2G_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2R_MASK);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_3G_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3R_MASK);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_4G_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4R_MASK);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_5G_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5R_MASK);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_6G_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6R_MASK);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_7G_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7R_MASK);
	LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_8G_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8R_MASK);

//	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_ALL_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_1_MASK);
	LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_ST_3_MASK);

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

//	usleep(5000);
//	if (spw_a.link_status.running) {
//		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1R_MASK);
//		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1G_MASK);
//	}
//
//	if (spw_h.link_status.running) {
//		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_8R_MASK);
//		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8G_MASK);
//	}
//
//	printf("esperando \n");
////	getchar();
//	printf("foi \n");

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

	fee_buffer_data_block_t *buffer_data_m1 =
			(fee_buffer_data_block_t *) Ddr2Base;

	buffer_data_m1->pixel_data_block[0].pixel[0] = 0x0100;
	buffer_data_m1->pixel_data_block[0].pixel[1] = 0x0302;
	buffer_data_m1->pixel_data_block[0].pixel[2] = 0x0504;
	buffer_data_m1->pixel_data_block[0].pixel[3] = 0x0706;
	buffer_data_m1->pixel_data_block[0].pixel[4] = 0x0908;
	buffer_data_m1->pixel_data_block[0].pixel[5] = 0x0B0A;
	buffer_data_m1->pixel_data_block[0].pixel[6] = 0x0D0C;
	buffer_data_m1->pixel_data_block[0].pixel[7] = 0x0F0E;
	buffer_data_m1->pixel_data_block[0].pixel[8] = 0x1110;
	buffer_data_m1->pixel_data_block[0].pixel[9] = 0x1312;
	buffer_data_m1->pixel_data_block[0].pixel[10] = 0x1514;
	buffer_data_m1->pixel_data_block[0].pixel[11] = 0x1716;
	buffer_data_m1->pixel_data_block[0].pixel[12] = 0x1918;
	buffer_data_m1->pixel_data_block[0].pixel[13] = 0x1B1A;
	buffer_data_m1->pixel_data_block[0].pixel[14] = 0x1D1C;
	buffer_data_m1->pixel_data_block[0].pixel[15] = 0x1F1E;
	buffer_data_m1->pixel_data_block[0].pixel[16] = 0x2120;
	buffer_data_m1->pixel_data_block[0].pixel[17] = 0x2322;
	buffer_data_m1->pixel_data_block[0].pixel[18] = 0x2524;
	buffer_data_m1->pixel_data_block[0].pixel[19] = 0x2726;
	buffer_data_m1->pixel_data_block[0].pixel[20] = 0x2928;
	buffer_data_m1->pixel_data_block[0].pixel[21] = 0x2B2A;
	buffer_data_m1->pixel_data_block[0].pixel[22] = 0x2D2C;
	buffer_data_m1->pixel_data_block[0].pixel[23] = 0x2F2E;
	buffer_data_m1->pixel_data_block[0].pixel[24] = 0x3130;
	buffer_data_m1->pixel_data_block[0].pixel[25] = 0x3332;
	buffer_data_m1->pixel_data_block[0].pixel[26] = 0x3534;
	buffer_data_m1->pixel_data_block[0].pixel[27] = 0x3736;
	buffer_data_m1->pixel_data_block[0].pixel[28] = 0x3938;
	buffer_data_m1->pixel_data_block[0].pixel[29] = 0x3B3A;
	buffer_data_m1->pixel_data_block[0].pixel[30] = 0x3D3C;
	buffer_data_m1->pixel_data_block[0].pixel[31] = 0x3F3E;
	buffer_data_m1->pixel_data_block[0].pixel[32] = 0x4140;
	buffer_data_m1->pixel_data_block[0].pixel[33] = 0x4342;
	buffer_data_m1->pixel_data_block[0].pixel[34] = 0x4544;
	buffer_data_m1->pixel_data_block[0].pixel[35] = 0x4746;
	buffer_data_m1->pixel_data_block[0].pixel[36] = 0x4948;
	buffer_data_m1->pixel_data_block[0].pixel[37] = 0x4B4A;
	buffer_data_m1->pixel_data_block[0].pixel[38] = 0x4D4C;
	buffer_data_m1->pixel_data_block[0].pixel[39] = 0x4F4E;
	buffer_data_m1->pixel_data_block[0].pixel[40] = 0x5150;
	buffer_data_m1->pixel_data_block[0].pixel[41] = 0x5352;
	buffer_data_m1->pixel_data_block[0].pixel[42] = 0x5554;
	buffer_data_m1->pixel_data_block[0].pixel[43] = 0x5756;
	buffer_data_m1->pixel_data_block[0].pixel[44] = 0x5958;
	buffer_data_m1->pixel_data_block[0].pixel[45] = 0x5B5A;
	buffer_data_m1->pixel_data_block[0].pixel[46] = 0x5D5C;
	buffer_data_m1->pixel_data_block[0].pixel[47] = 0x5F5E;
	buffer_data_m1->pixel_data_block[0].pixel[48] = 0x6160;
	buffer_data_m1->pixel_data_block[0].pixel[49] = 0x6362;
	buffer_data_m1->pixel_data_block[0].pixel[50] = 0x6564;
	buffer_data_m1->pixel_data_block[0].pixel[51] = 0x6766;
	buffer_data_m1->pixel_data_block[0].pixel[52] = 0x6968;
	buffer_data_m1->pixel_data_block[0].pixel[53] = 0x6B6A;
	buffer_data_m1->pixel_data_block[0].pixel[54] = 0x6D6C;
	buffer_data_m1->pixel_data_block[0].pixel[55] = 0x6F6E;
	buffer_data_m1->pixel_data_block[0].pixel[56] = 0x7170;
	buffer_data_m1->pixel_data_block[0].pixel[57] = 0x7372;
	buffer_data_m1->pixel_data_block[0].pixel[58] = 0x7574;
	buffer_data_m1->pixel_data_block[0].pixel[59] = 0x7776;
	buffer_data_m1->pixel_data_block[0].pixel[60] = 0x7978;
	buffer_data_m1->pixel_data_block[0].pixel[61] = 0x7B7A;
	buffer_data_m1->pixel_data_block[0].pixel[62] = 0x7D7C;
	buffer_data_m1->pixel_data_block[0].pixel[63] = 0x7F7E;
	buffer_data_m1->pixel_data_block[0].mask = 0xFFFFFFFFFFFFFFFF;

	buffer_data_m1->pixel_data_block[1].pixel[0] = 0x8180;
	buffer_data_m1->pixel_data_block[1].pixel[1] = 0x8382;
	buffer_data_m1->pixel_data_block[1].pixel[2] = 0x8584;
	buffer_data_m1->pixel_data_block[1].pixel[3] = 0x8786;
	buffer_data_m1->pixel_data_block[1].pixel[4] = 0x8988;
	buffer_data_m1->pixel_data_block[1].pixel[5] = 0x8B8A;
	buffer_data_m1->pixel_data_block[1].pixel[6] = 0x8D8C;
	buffer_data_m1->pixel_data_block[1].pixel[7] = 0x8F8E;
	buffer_data_m1->pixel_data_block[1].pixel[8] = 0x9190;
	buffer_data_m1->pixel_data_block[1].pixel[9] = 0x9392;
	buffer_data_m1->pixel_data_block[1].pixel[10] = 0x9594;
	buffer_data_m1->pixel_data_block[1].pixel[11] = 0x9796;
	buffer_data_m1->pixel_data_block[1].pixel[12] = 0x9998;
	buffer_data_m1->pixel_data_block[1].pixel[13] = 0x9B9A;
	buffer_data_m1->pixel_data_block[1].pixel[14] = 0x9D9C;
	buffer_data_m1->pixel_data_block[1].pixel[15] = 0x9F9E;
	buffer_data_m1->pixel_data_block[1].pixel[16] = 0xA1A0;
	buffer_data_m1->pixel_data_block[1].pixel[17] = 0xA3A2;
	buffer_data_m1->pixel_data_block[1].pixel[18] = 0xA5A4;
	buffer_data_m1->pixel_data_block[1].pixel[19] = 0xA7A6;
	buffer_data_m1->pixel_data_block[1].pixel[20] = 0xA9A8;
	buffer_data_m1->pixel_data_block[1].pixel[21] = 0xABAA;
	buffer_data_m1->pixel_data_block[1].pixel[22] = 0xADAC;
	buffer_data_m1->pixel_data_block[1].pixel[23] = 0xAFAE;
	buffer_data_m1->pixel_data_block[1].pixel[24] = 0xB1B0;
	buffer_data_m1->pixel_data_block[1].pixel[25] = 0xB3B2;
	buffer_data_m1->pixel_data_block[1].pixel[26] = 0xB5B4;
	buffer_data_m1->pixel_data_block[1].pixel[27] = 0xB7B6;
	buffer_data_m1->pixel_data_block[1].pixel[28] = 0xB9B8;
	buffer_data_m1->pixel_data_block[1].pixel[29] = 0xBBBA;
	buffer_data_m1->pixel_data_block[1].pixel[30] = 0xBDBC;
	buffer_data_m1->pixel_data_block[1].pixel[31] = 0xBFBE;
	buffer_data_m1->pixel_data_block[1].pixel[32] = 0xC1C0;
	buffer_data_m1->pixel_data_block[1].pixel[33] = 0xC3C2;
	buffer_data_m1->pixel_data_block[1].pixel[34] = 0xC5C4;
	buffer_data_m1->pixel_data_block[1].pixel[35] = 0xC7C6;
	buffer_data_m1->pixel_data_block[1].pixel[36] = 0xC9C8;
	buffer_data_m1->pixel_data_block[1].pixel[37] = 0xCBCA;
	buffer_data_m1->pixel_data_block[1].pixel[38] = 0xCDCC;
	buffer_data_m1->pixel_data_block[1].pixel[39] = 0xCFCE;
	buffer_data_m1->pixel_data_block[1].pixel[40] = 0xD1D0;
	buffer_data_m1->pixel_data_block[1].pixel[41] = 0xD3D2;
	buffer_data_m1->pixel_data_block[1].pixel[42] = 0xD5D4;
	buffer_data_m1->pixel_data_block[1].pixel[43] = 0xD7D6;
	buffer_data_m1->pixel_data_block[1].pixel[44] = 0xD9D8;
	buffer_data_m1->pixel_data_block[1].pixel[45] = 0xDBDA;
	buffer_data_m1->pixel_data_block[1].pixel[46] = 0xDDDC;
	buffer_data_m1->pixel_data_block[1].pixel[47] = 0xDFDE;
	buffer_data_m1->pixel_data_block[1].pixel[48] = 0xE1E0;
	buffer_data_m1->pixel_data_block[1].pixel[49] = 0xE3E2;
	buffer_data_m1->pixel_data_block[1].pixel[50] = 0xE5E4;
	buffer_data_m1->pixel_data_block[1].pixel[51] = 0xE7E6;
	buffer_data_m1->pixel_data_block[1].pixel[52] = 0xE9E8;
	buffer_data_m1->pixel_data_block[1].pixel[53] = 0xEBEA;
	buffer_data_m1->pixel_data_block[1].pixel[54] = 0xEDEC;
	buffer_data_m1->pixel_data_block[1].pixel[55] = 0xEFEE;
	buffer_data_m1->pixel_data_block[1].pixel[56] = 0xF1F0;
	buffer_data_m1->pixel_data_block[1].pixel[57] = 0xF3F2;
	buffer_data_m1->pixel_data_block[1].pixel[58] = 0xF5F4;
	buffer_data_m1->pixel_data_block[1].pixel[59] = 0xF7F6;
	buffer_data_m1->pixel_data_block[1].pixel[60] = 0xF9F8;
	buffer_data_m1->pixel_data_block[1].pixel[61] = 0xFBFA;
	buffer_data_m1->pixel_data_block[1].pixel[62] = 0xFDFC;
	buffer_data_m1->pixel_data_block[1].pixel[63] = 0xFFFE;
	buffer_data_m1->pixel_data_block[1].mask = 0xFFFFFFFFFFFFFFFF;

	buffer_data_m1->pixel_data_block[2] = buffer_data_m1->pixel_data_block[0];
	buffer_data_m1->pixel_data_block[3] = buffer_data_m1->pixel_data_block[1];
	buffer_data_m1->pixel_data_block[4] = buffer_data_m1->pixel_data_block[2];
	buffer_data_m1->pixel_data_block[5] = buffer_data_m1->pixel_data_block[3];
	buffer_data_m1->pixel_data_block[6] = buffer_data_m1->pixel_data_block[4];
	buffer_data_m1->pixel_data_block[7] = buffer_data_m1->pixel_data_block[5];
	buffer_data_m1->pixel_data_block[8] = buffer_data_m1->pixel_data_block[6];
	buffer_data_m1->pixel_data_block[9] = buffer_data_m1->pixel_data_block[7];
	buffer_data_m1->pixel_data_block[10] = buffer_data_m1->pixel_data_block[8];
	buffer_data_m1->pixel_data_block[11] = buffer_data_m1->pixel_data_block[9];
	buffer_data_m1->pixel_data_block[12] = buffer_data_m1->pixel_data_block[10];
	buffer_data_m1->pixel_data_block[13] = buffer_data_m1->pixel_data_block[11];
	buffer_data_m1->pixel_data_block[14] = buffer_data_m1->pixel_data_block[12];
	buffer_data_m1->pixel_data_block[15] = buffer_data_m1->pixel_data_block[13];

	DDR2_SWITCH_MEMORY(DDR2_M2_ID);

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

	fee_buffer_data_block_t *buffer_data_m2 =
			(fee_buffer_data_block_t *) Ddr2Base;

	buffer_data_m2->pixel_data_block[0].pixel[0] = 0x0100;
	buffer_data_m2->pixel_data_block[0].pixel[1] = 0x0302;
	buffer_data_m2->pixel_data_block[0].pixel[2] = 0x0504;
	buffer_data_m2->pixel_data_block[0].pixel[3] = 0x0706;
	buffer_data_m2->pixel_data_block[0].pixel[4] = 0x0908;
	buffer_data_m2->pixel_data_block[0].pixel[5] = 0x0B0A;
	buffer_data_m2->pixel_data_block[0].pixel[6] = 0x0D0C;
	buffer_data_m2->pixel_data_block[0].pixel[7] = 0x0F0E;
	buffer_data_m2->pixel_data_block[0].pixel[8] = 0x1110;
	buffer_data_m2->pixel_data_block[0].pixel[9] = 0x1312;
	buffer_data_m2->pixel_data_block[0].pixel[10] = 0x1514;
	buffer_data_m2->pixel_data_block[0].pixel[11] = 0x1716;
	buffer_data_m2->pixel_data_block[0].pixel[12] = 0x1918;
	buffer_data_m2->pixel_data_block[0].pixel[13] = 0x1B1A;
	buffer_data_m2->pixel_data_block[0].pixel[14] = 0x1D1C;
	buffer_data_m2->pixel_data_block[0].pixel[15] = 0x1F1E;
	buffer_data_m2->pixel_data_block[0].pixel[16] = 0x2120;
	buffer_data_m2->pixel_data_block[0].pixel[17] = 0x2322;
	buffer_data_m2->pixel_data_block[0].pixel[18] = 0x2524;
	buffer_data_m2->pixel_data_block[0].pixel[19] = 0x2726;
	buffer_data_m2->pixel_data_block[0].pixel[20] = 0x2928;
	buffer_data_m2->pixel_data_block[0].pixel[21] = 0x2B2A;
	buffer_data_m2->pixel_data_block[0].pixel[22] = 0x2D2C;
	buffer_data_m2->pixel_data_block[0].pixel[23] = 0x2F2E;
	buffer_data_m2->pixel_data_block[0].pixel[24] = 0x3130;
	buffer_data_m2->pixel_data_block[0].pixel[25] = 0x3332;
	buffer_data_m2->pixel_data_block[0].pixel[26] = 0x3534;
	buffer_data_m2->pixel_data_block[0].pixel[27] = 0x3736;
	buffer_data_m2->pixel_data_block[0].pixel[28] = 0x3938;
	buffer_data_m2->pixel_data_block[0].pixel[29] = 0x3B3A;
	buffer_data_m2->pixel_data_block[0].pixel[30] = 0x3D3C;
	buffer_data_m2->pixel_data_block[0].pixel[31] = 0x3F3E;
	buffer_data_m2->pixel_data_block[0].pixel[32] = 0x4140;
	buffer_data_m2->pixel_data_block[0].pixel[33] = 0x4342;
	buffer_data_m2->pixel_data_block[0].pixel[34] = 0x4544;
	buffer_data_m2->pixel_data_block[0].pixel[35] = 0x4746;
	buffer_data_m2->pixel_data_block[0].pixel[36] = 0x4948;
	buffer_data_m2->pixel_data_block[0].pixel[37] = 0x4B4A;
	buffer_data_m2->pixel_data_block[0].pixel[38] = 0x4D4C;
	buffer_data_m2->pixel_data_block[0].pixel[39] = 0x4F4E;
	buffer_data_m2->pixel_data_block[0].pixel[40] = 0x5150;
	buffer_data_m2->pixel_data_block[0].pixel[41] = 0x5352;
	buffer_data_m2->pixel_data_block[0].pixel[42] = 0x5554;
	buffer_data_m2->pixel_data_block[0].pixel[43] = 0x5756;
	buffer_data_m2->pixel_data_block[0].pixel[44] = 0x5958;
	buffer_data_m2->pixel_data_block[0].pixel[45] = 0x5B5A;
	buffer_data_m2->pixel_data_block[0].pixel[46] = 0x5D5C;
	buffer_data_m2->pixel_data_block[0].pixel[47] = 0x5F5E;
	buffer_data_m2->pixel_data_block[0].pixel[48] = 0x6160;
	buffer_data_m2->pixel_data_block[0].pixel[49] = 0x6362;
	buffer_data_m2->pixel_data_block[0].pixel[50] = 0x6564;
	buffer_data_m2->pixel_data_block[0].pixel[51] = 0x6766;
	buffer_data_m2->pixel_data_block[0].pixel[52] = 0x6968;
	buffer_data_m2->pixel_data_block[0].pixel[53] = 0x6B6A;
	buffer_data_m2->pixel_data_block[0].pixel[54] = 0x6D6C;
	buffer_data_m2->pixel_data_block[0].pixel[55] = 0x6F6E;
	buffer_data_m2->pixel_data_block[0].pixel[56] = 0x7170;
	buffer_data_m2->pixel_data_block[0].pixel[57] = 0x7372;
	buffer_data_m2->pixel_data_block[0].pixel[58] = 0x7574;
	buffer_data_m2->pixel_data_block[0].pixel[59] = 0x7776;
	buffer_data_m2->pixel_data_block[0].pixel[60] = 0x7978;
	buffer_data_m2->pixel_data_block[0].pixel[61] = 0x7B7A;
	buffer_data_m2->pixel_data_block[0].pixel[62] = 0x7D7C;
	buffer_data_m2->pixel_data_block[0].pixel[63] = 0x7F7E;
	buffer_data_m2->pixel_data_block[0].mask = 0xFFFFFFFFFFFFFFFF;

	buffer_data_m2->pixel_data_block[1].pixel[0] = 0x8180;
	buffer_data_m2->pixel_data_block[1].pixel[1] = 0x8382;
	buffer_data_m2->pixel_data_block[1].pixel[2] = 0x8584;
	buffer_data_m2->pixel_data_block[1].pixel[3] = 0x8786;
	buffer_data_m2->pixel_data_block[1].pixel[4] = 0x8988;
	buffer_data_m2->pixel_data_block[1].pixel[5] = 0x8B8A;
	buffer_data_m2->pixel_data_block[1].pixel[6] = 0x8D8C;
	buffer_data_m2->pixel_data_block[1].pixel[7] = 0x8F8E;
	buffer_data_m2->pixel_data_block[1].pixel[8] = 0x9190;
	buffer_data_m2->pixel_data_block[1].pixel[9] = 0x9392;
	buffer_data_m2->pixel_data_block[1].pixel[10] = 0x9594;
	buffer_data_m2->pixel_data_block[1].pixel[11] = 0x9796;
	buffer_data_m2->pixel_data_block[1].pixel[12] = 0x9998;
	buffer_data_m2->pixel_data_block[1].pixel[13] = 0x9B9A;
	buffer_data_m2->pixel_data_block[1].pixel[14] = 0x9D9C;
	buffer_data_m2->pixel_data_block[1].pixel[15] = 0x9F9E;
	buffer_data_m2->pixel_data_block[1].pixel[16] = 0xA1A0;
	buffer_data_m2->pixel_data_block[1].pixel[17] = 0xA3A2;
	buffer_data_m2->pixel_data_block[1].pixel[18] = 0xA5A4;
	buffer_data_m2->pixel_data_block[1].pixel[19] = 0xA7A6;
	buffer_data_m2->pixel_data_block[1].pixel[20] = 0xA9A8;
	buffer_data_m2->pixel_data_block[1].pixel[21] = 0xABAA;
	buffer_data_m2->pixel_data_block[1].pixel[22] = 0xADAC;
	buffer_data_m2->pixel_data_block[1].pixel[23] = 0xAFAE;
	buffer_data_m2->pixel_data_block[1].pixel[24] = 0xB1B0;
	buffer_data_m2->pixel_data_block[1].pixel[25] = 0xB3B2;
	buffer_data_m2->pixel_data_block[1].pixel[26] = 0xB5B4;
	buffer_data_m2->pixel_data_block[1].pixel[27] = 0xB7B6;
	buffer_data_m2->pixel_data_block[1].pixel[28] = 0xB9B8;
	buffer_data_m2->pixel_data_block[1].pixel[29] = 0xBBBA;
	buffer_data_m2->pixel_data_block[1].pixel[30] = 0xBDBC;
	buffer_data_m2->pixel_data_block[1].pixel[31] = 0xBFBE;
	buffer_data_m2->pixel_data_block[1].pixel[32] = 0xC1C0;
	buffer_data_m2->pixel_data_block[1].pixel[33] = 0xC3C2;
	buffer_data_m2->pixel_data_block[1].pixel[34] = 0xC5C4;
	buffer_data_m2->pixel_data_block[1].pixel[35] = 0xC7C6;
	buffer_data_m2->pixel_data_block[1].pixel[36] = 0xC9C8;
	buffer_data_m2->pixel_data_block[1].pixel[37] = 0xCBCA;
	buffer_data_m2->pixel_data_block[1].pixel[38] = 0xCDCC;
	buffer_data_m2->pixel_data_block[1].pixel[39] = 0xCFCE;
	buffer_data_m2->pixel_data_block[1].pixel[40] = 0xD1D0;
	buffer_data_m2->pixel_data_block[1].pixel[41] = 0xD3D2;
	buffer_data_m2->pixel_data_block[1].pixel[42] = 0xD5D4;
	buffer_data_m2->pixel_data_block[1].pixel[43] = 0xD7D6;
	buffer_data_m2->pixel_data_block[1].pixel[44] = 0xD9D8;
	buffer_data_m2->pixel_data_block[1].pixel[45] = 0xDBDA;
	buffer_data_m2->pixel_data_block[1].pixel[46] = 0xDDDC;
	buffer_data_m2->pixel_data_block[1].pixel[47] = 0xDFDE;
	buffer_data_m2->pixel_data_block[1].pixel[48] = 0xE1E0;
	buffer_data_m2->pixel_data_block[1].pixel[49] = 0xE3E2;
	buffer_data_m2->pixel_data_block[1].pixel[50] = 0xE5E4;
	buffer_data_m2->pixel_data_block[1].pixel[51] = 0xE7E6;
	buffer_data_m2->pixel_data_block[1].pixel[52] = 0xE9E8;
	buffer_data_m2->pixel_data_block[1].pixel[53] = 0xEBEA;
	buffer_data_m2->pixel_data_block[1].pixel[54] = 0xEDEC;
	buffer_data_m2->pixel_data_block[1].pixel[55] = 0xEFEE;
	buffer_data_m2->pixel_data_block[1].pixel[56] = 0xF1F0;
	buffer_data_m2->pixel_data_block[1].pixel[57] = 0xF3F2;
	buffer_data_m2->pixel_data_block[1].pixel[58] = 0xF5F4;
	buffer_data_m2->pixel_data_block[1].pixel[59] = 0xF7F6;
	buffer_data_m2->pixel_data_block[1].pixel[60] = 0xF9F8;
	buffer_data_m2->pixel_data_block[1].pixel[61] = 0xFBFA;
	buffer_data_m2->pixel_data_block[1].pixel[62] = 0xFDFC;
	buffer_data_m2->pixel_data_block[1].pixel[63] = 0xFFFE;
	buffer_data_m2->pixel_data_block[1].mask = 0xFFFFFFFFFFFFFFFF;

	buffer_data_m2->pixel_data_block[2] = buffer_data_m2->pixel_data_block[0];
	buffer_data_m2->pixel_data_block[3] = buffer_data_m2->pixel_data_block[1];
	buffer_data_m2->pixel_data_block[4] = buffer_data_m2->pixel_data_block[2];
	buffer_data_m2->pixel_data_block[5] = buffer_data_m2->pixel_data_block[3];
	buffer_data_m2->pixel_data_block[6] = buffer_data_m2->pixel_data_block[4];
	buffer_data_m2->pixel_data_block[7] = buffer_data_m2->pixel_data_block[5];
	buffer_data_m2->pixel_data_block[8] = buffer_data_m2->pixel_data_block[6];
	buffer_data_m2->pixel_data_block[9] = buffer_data_m2->pixel_data_block[7];
	buffer_data_m2->pixel_data_block[10] = buffer_data_m2->pixel_data_block[8];
	buffer_data_m2->pixel_data_block[11] = buffer_data_m2->pixel_data_block[9];
	buffer_data_m2->pixel_data_block[12] = buffer_data_m2->pixel_data_block[10];
	buffer_data_m2->pixel_data_block[13] = buffer_data_m2->pixel_data_block[11];
	buffer_data_m2->pixel_data_block[14] = buffer_data_m2->pixel_data_block[12];
	buffer_data_m2->pixel_data_block[15] = buffer_data_m2->pixel_data_block[13];

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
//	for (data_counter = 0; data_counter < (136/4 * 16); data_counter++) {
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

	if (fee_dma_m1_transfer(0, 16, right_buffer, channel_a_buffer)) {
		if (fee_dma_m2_transfer(0, 16, left_buffer, channel_a_buffer)) {
			printf("channel a transferido corretamente \n");
		}
	}

	if (fee_dma_m1_transfer(0, 16, right_buffer, channel_b_buffer)) {
		if (fee_dma_m2_transfer(0, 16, left_buffer, channel_b_buffer)) {
			printf("channel b transferido corretamente \n");
		}
	}

	if (fee_dma_m1_transfer(0, 16, right_buffer, channel_c_buffer)) {
		if (fee_dma_m2_transfer(0, 16, left_buffer, channel_c_buffer)) {
			printf("channel c transferido corretamente \n");
		}
	}

	if (fee_dma_m1_transfer(0, 16, right_buffer, channel_d_buffer)) {
		if (fee_dma_m2_transfer(0, 16, left_buffer, channel_d_buffer)) {
			printf("channel d transferido corretamente \n");
		}
	}

	if (fee_dma_m1_transfer(0, 16, right_buffer, channel_e_buffer)) {
		if (fee_dma_m2_transfer(0, 16, left_buffer, channel_e_buffer)) {
			printf("channel e transferido corretamente \n");
		}
	}

	if (fee_dma_m1_transfer(0, 16, right_buffer, channel_f_buffer)) {
		if (fee_dma_m2_transfer(0, 16, left_buffer, channel_f_buffer)) {
			printf("channel f transferido corretamente \n");
		}
	}

	if (fee_dma_m1_transfer(0, 16, right_buffer, channel_g_buffer)) {
		if (fee_dma_m2_transfer(0, 16, left_buffer, channel_g_buffer)) {
			printf("channel g transferido corretamente \n");
		}
	}

	if (fee_dma_m1_transfer(0, 16, right_buffer, channel_h_buffer)) {
		if (fee_dma_m2_transfer(0, 16, left_buffer, channel_h_buffer)) {
			printf("channel h transferido corretamente \n");
		}
	}

	bool loop = TRUE;

	while (loop) {
		usleep(5000);

		comm_update_link_status(&spw_a);
		if (spw_a.link_status.running) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1R_MASK);
		}

		comm_update_link_status(&spw_b);
		if (spw_b.link_status.running) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_2R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_2G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2R_MASK);
		}

		comm_update_link_status(&spw_c);
		if (spw_c.link_status.running) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_3R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_3G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3R_MASK);
		}

		comm_update_link_status(&spw_d);
		if (spw_d.link_status.running) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_4R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_4G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4R_MASK);
		}

		comm_update_link_status(&spw_e);
		if (spw_e.link_status.running) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_5R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_5G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5R_MASK);
		}

		comm_update_link_status(&spw_f);
		if (spw_f.link_status.running) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_6R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_6G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6R_MASK);
		}

		comm_update_link_status(&spw_g);
		if (spw_g.link_status.running) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_7R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_7G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7R_MASK);
		}

		comm_update_link_status(&spw_h);
		if (spw_h.link_status.running) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_8R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_8G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8R_MASK);
		}
	}

	while (loop) {
		printf("selecione memoria \n");
		switch (getchar()) {
		case '1':
			printf("m2 R \n");
			if (fee_dma_m2_transfer(0, 16, right_buffer, channel_a_buffer)) {
				printf("dma_m2 transferido corretamente \n");
			}
			break;

		case '2':
			printf("m2 L \n");
			if (fee_dma_m2_transfer(0, 16, left_buffer, channel_a_buffer)) {
				printf("dma_m2 transferido corretamente \n");
			}
			break;

		case 'a':
			printf("a \n");
			if (fee_dma_m2_transfer(0, 16, right_buffer, channel_a_buffer)) {
				printf("dma_m2 transferido corretamente \n");
			}
//			if (fee_dma_m1_transfer(0, 16, left_buffer, channel_a_buffer)) {
//				printf("dma_m1 transferido corretamente \n");
//			}
			usleep(500);
			comm_update_buffers_status(&spw_a);
			printf("empty: %u \n", spw_a.buffer_status.right_buffer_empty);
			break;

		case 'r':
			printf("r \n");
			loop = FALSE;
			break;

		default:
			printf("errou \n");
			break;
		}
	}

	comm_config_link(&spw_a);
	comm_config_link(&spw_h);

	//*spw_a.channel_address = 0x102;
	printf("%08X", *(spw_a.channel_address));

	usleep(10000);

	comm_update_link_status(&spw_a);
	if (spw_a.link_status.running) {
		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1R_MASK);
		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1G_MASK);
	} else {
		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1G_MASK);
		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1R_MASK);
	}

	comm_update_link_status(&spw_h);
	if (spw_h.link_status.running) {
		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_8R_MASK);
		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8G_MASK);
	} else {
		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_8G_MASK);
		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_8R_MASK);
	}

	int i = 0;
	loop = TRUE;
	while (loop) {
		for (i = 0; i < 1000; i++) {
			usleep(1000);
		}
		comm_update_buffers_status(&spw_a);
		printf("empty r: %u \n", spw_a.buffer_status.right_buffer_empty);
		printf("empty l: %u \n", spw_a.buffer_status.left_buffer_empty);
		printf("int_cnt: %u \n", int_cnt);
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

