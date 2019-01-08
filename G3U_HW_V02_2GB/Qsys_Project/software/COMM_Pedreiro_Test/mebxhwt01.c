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

void vTestLeds(void);

TCommChannel xSpw1;
TCommChannel xSpw2;
TCommChannel xSpw3;
TCommChannel xSpw4;
TCommChannel xSpw5;
TCommChannel xSpw6;
TCommChannel xSpw7;
TCommChannel xSpw8;

int main(void) {

//	vRstcHoldDeviceReset(RSTC_DEV_ALL_MSK);
//	usleep(5000);
	vRstcReleaseDeviceReset(RSTC_DEV_ALL_MSK);
	usleep(5000);
	usleep(1000000);

	disable_iso_drivers();
	disable_lvds_board();

	usleep(50000);

	enable_iso_drivers();
	enable_lvds_board();

	alt_8 ucTempFpga = 0;
	alt_8 ucTempBoard = 0;

	printf(" \n Nucleo de Sistemas Eletronicos Embarcados - MebX\n\n");

	//Configura Display de 7 segmentos
	SSDP_CONFIG(SSDP_NORMAL_MODE);

	bCommInitCh(&xSpw1, eCommSpwCh1);
	bCommInitCh(&xSpw2, eCommSpwCh2);
	bCommInitCh(&xSpw3, eCommSpwCh3);
	bCommInitCh(&xSpw4, eCommSpwCh4);
	bCommInitCh(&xSpw5, eCommSpwCh5);
	bCommInitCh(&xSpw6, eCommSpwCh6);
	bCommInitCh(&xSpw7, eCommSpwCh7);
	bCommInitCh(&xSpw8, eCommSpwCh8);

//	vCommInitIrq(eCommSpwCh1);
//	int_cnt = 0;
//	printf("int_cnt: %u \n", int_cnt);
//
//	xSpw1.xIrqControl.bRightBufferEmptyEn = FALSE;
//	bCommSetIrqControl(&xSpw1);

	xSpw1.xLinkConfig.bAutostart = FALSE;
	xSpw1.xLinkConfig.bStart = FALSE;
	xSpw1.xLinkConfig.bDisconnect = TRUE;
	xSpw2.xLinkConfig.bAutostart = FALSE;
	xSpw2.xLinkConfig.bStart = FALSE;
	xSpw2.xLinkConfig.bDisconnect = TRUE;
	xSpw3.xLinkConfig.bAutostart = FALSE;
	xSpw3.xLinkConfig.bStart = FALSE;
	xSpw3.xLinkConfig.bDisconnect = TRUE;
	xSpw4.xLinkConfig.bAutostart = FALSE;
	xSpw4.xLinkConfig.bStart = FALSE;
	xSpw4.xLinkConfig.bDisconnect = TRUE;
	xSpw5.xLinkConfig.bAutostart = FALSE;
	xSpw5.xLinkConfig.bStart = FALSE;
	xSpw5.xLinkConfig.bDisconnect = TRUE;
	xSpw6.xLinkConfig.bAutostart = FALSE;
	xSpw6.xLinkConfig.bStart = FALSE;
	xSpw6.xLinkConfig.bDisconnect = TRUE;
	xSpw7.xLinkConfig.bAutostart = FALSE;
	xSpw7.xLinkConfig.bStart = FALSE;
	xSpw7.xLinkConfig.bDisconnect = TRUE;
	xSpw8.xLinkConfig.bAutostart = FALSE;
	xSpw8.xLinkConfig.bStart = FALSE;
	xSpw8.xLinkConfig.bDisconnect = TRUE;
	bCommSetLink(&xSpw1);
	bCommSetLink(&xSpw2);
	bCommSetLink(&xSpw3);
	bCommSetLink(&xSpw4);
	bCommSetLink(&xSpw5);
	bCommSetLink(&xSpw6);
	bCommSetLink(&xSpw7);
	bCommSetLink(&xSpw8);

	usleep(50000);
	usleep(1000000);

	xSpw1.xWindowingConfig.bMasking = TRUE;
	xSpw1.xLinkConfig.bAutostart = TRUE;
	xSpw1.xLinkConfig.bStart = TRUE;
	xSpw1.xLinkConfig.bDisconnect = FALSE;
	xSpw2.xWindowingConfig.bMasking = TRUE;
	xSpw2.xLinkConfig.bAutostart = TRUE;
//	xSpw2.xLinkConfig.bStart = TRUE;
	xSpw2.xLinkConfig.bDisconnect = FALSE;
	xSpw3.xWindowingConfig.bMasking = TRUE;
	xSpw3.xLinkConfig.bAutostart = TRUE;
//	xSpw3.xLinkConfig.bStart = TRUE;
	xSpw3.xLinkConfig.bDisconnect = FALSE;
	xSpw4.xWindowingConfig.bMasking = TRUE;
	xSpw4.xLinkConfig.bAutostart = TRUE;
//	xSpw4.xLinkConfig.bStart = TRUE;
	xSpw4.xLinkConfig.bDisconnect = FALSE;
	xSpw5.xWindowingConfig.bMasking = TRUE;
	xSpw5.xLinkConfig.bAutostart = TRUE;
//	xSpw5.xLinkConfig.bStart = TRUE;
	xSpw5.xLinkConfig.bDisconnect = FALSE;
	xSpw6.xWindowingConfig.bMasking = TRUE;
	xSpw6.xLinkConfig.bAutostart = TRUE;
//	xSpw6.xLinkConfig.bStart = TRUE;
	xSpw6.xLinkConfig.bDisconnect = FALSE;
	xSpw7.xWindowingConfig.bMasking = TRUE;
	xSpw7.xLinkConfig.bAutostart = TRUE;
//	xSpw7.xLinkConfig.bStart = TRUE;
	xSpw7.xLinkConfig.bDisconnect = FALSE;
	xSpw8.xWindowingConfig.bMasking = TRUE;
	xSpw8.xLinkConfig.bAutostart = TRUE;
//	xSpw8.xLinkConfig.bStart = TRUE;
	xSpw8.xLinkConfig.bDisconnect = FALSE;
	bCommSetWindowing(&xSpw1);
	bCommSetWindowing(&xSpw2);
	bCommSetWindowing(&xSpw3);
	bCommSetWindowing(&xSpw4);
	bCommSetWindowing(&xSpw5);
	bCommSetWindowing(&xSpw6);
	bCommSetWindowing(&xSpw7);
	bCommSetWindowing(&xSpw8);
	bCommSetLink(&xSpw1);
	bCommSetLink(&xSpw2);
	bCommSetLink(&xSpw3);
	bCommSetLink(&xSpw4);
	bCommSetLink(&xSpw5);
	bCommSetLink(&xSpw6);
	bCommSetLink(&xSpw7);
	bCommSetLink(&xSpw8);

//	xSpw1.xWindowingConfig.bMasking = TRUE;
//	bCommSetWindowing(&xSpw1);

//	xSpw8.xLinkConfig.bAutostart = TRUE;
//	bCommSetLink(&xSpw8);
//
//	bCommGetLink(&xSpw8);
//	printf("empty r: %u \n", xSpw8.xLinkConfig.bAutostart);
//	vRstcHoldDeviceReset(RSTC_DEV_COMM_CH8_RST_CTRL_MSK);
//	usleep(5000);
//	vRstcReleaseDeviceReset(RSTC_DEV_COMM_CH8_RST_CTRL_MSK);
//	bCommGetLink(&xSpw8);
//	printf("empty r: %u \n", xSpw8.xLinkConfig.bAutostart);
//
//	xSpw8.xLinkConfig.bAutostart = TRUE;
//	bCommSetLink(&xSpw8);
//
//	bCommGetLink(&xSpw8);
//	printf("empty r: %u \n", xSpw8.xLinkConfig.bAutostart);

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
//	if (xSpw1.xLinkStatus.bRunning) {
//		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1R_MASK);
//		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1G_MASK);
//	}
//
//	if (xSpw8.xLinkStatus.bRunning) {
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

	TFeebBufferDataBlock *buffer_data_m1 =
			(TFeebBufferDataBlock *) Ddr2Base;

	buffer_data_m1->xPixelDataBlock[0].usiPixel[0] = 0x0100;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[1] = 0x0302;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[2] = 0x0504;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[3] = 0x0706;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[4] = 0x0908;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[5] = 0x0B0A;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[6] = 0x0D0C;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[7] = 0x0F0E;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[8] = 0x1110;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[9] = 0x1312;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[10] = 0x1514;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[11] = 0x1716;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[12] = 0x1918;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[13] = 0x1B1A;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[14] = 0x1D1C;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[15] = 0x1F1E;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[16] = 0x2120;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[17] = 0x2322;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[18] = 0x2524;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[19] = 0x2726;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[20] = 0x2928;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[21] = 0x2B2A;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[22] = 0x2D2C;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[23] = 0x2F2E;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[24] = 0x3130;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[25] = 0x3332;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[26] = 0x3534;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[27] = 0x3736;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[28] = 0x3938;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[29] = 0x3B3A;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[30] = 0x3D3C;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[31] = 0x3F3E;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[32] = 0x4140;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[33] = 0x4342;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[34] = 0x4544;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[35] = 0x4746;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[36] = 0x4948;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[37] = 0x4B4A;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[38] = 0x4D4C;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[39] = 0x4F4E;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[40] = 0x5150;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[41] = 0x5352;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[42] = 0x5554;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[43] = 0x5756;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[44] = 0x5958;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[45] = 0x5B5A;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[46] = 0x5D5C;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[47] = 0x5F5E;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[48] = 0x6160;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[49] = 0x6362;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[50] = 0x6564;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[51] = 0x6766;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[52] = 0x6968;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[53] = 0x6B6A;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[54] = 0x6D6C;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[55] = 0x6F6E;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[56] = 0x7170;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[57] = 0x7372;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[58] = 0x7574;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[59] = 0x7776;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[60] = 0x7978;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[61] = 0x7B7A;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[62] = 0x7D7C;
	buffer_data_m1->xPixelDataBlock[0].usiPixel[63] = 0x7F7E;
	buffer_data_m1->xPixelDataBlock[0].ulliMask = 0xFFFFFFFFFFFFFFFF;

	buffer_data_m1->xPixelDataBlock[1].usiPixel[0] = 0x8180;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[1] = 0x8382;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[2] = 0x8584;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[3] = 0x8786;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[4] = 0x8988;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[5] = 0x8B8A;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[6] = 0x8D8C;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[7] = 0x8F8E;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[8] = 0x9190;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[9] = 0x9392;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[10] = 0x9594;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[11] = 0x9796;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[12] = 0x9998;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[13] = 0x9B9A;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[14] = 0x9D9C;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[15] = 0x9F9E;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[16] = 0xA1A0;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[17] = 0xA3A2;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[18] = 0xA5A4;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[19] = 0xA7A6;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[20] = 0xA9A8;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[21] = 0xABAA;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[22] = 0xADAC;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[23] = 0xAFAE;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[24] = 0xB1B0;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[25] = 0xB3B2;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[26] = 0xB5B4;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[27] = 0xB7B6;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[28] = 0xB9B8;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[29] = 0xBBBA;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[30] = 0xBDBC;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[31] = 0xBFBE;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[32] = 0xC1C0;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[33] = 0xC3C2;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[34] = 0xC5C4;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[35] = 0xC7C6;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[36] = 0xC9C8;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[37] = 0xCBCA;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[38] = 0xCDCC;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[39] = 0xCFCE;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[40] = 0xD1D0;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[41] = 0xD3D2;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[42] = 0xD5D4;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[43] = 0xD7D6;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[44] = 0xD9D8;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[45] = 0xDBDA;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[46] = 0xDDDC;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[47] = 0xDFDE;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[48] = 0xE1E0;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[49] = 0xE3E2;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[50] = 0xE5E4;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[51] = 0xE7E6;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[52] = 0xE9E8;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[53] = 0xEBEA;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[54] = 0xEDEC;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[55] = 0xEFEE;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[56] = 0xF1F0;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[57] = 0xF3F2;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[58] = 0xF5F4;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[59] = 0xF7F6;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[60] = 0xF9F8;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[61] = 0xFBFA;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[62] = 0xFDFC;
	buffer_data_m1->xPixelDataBlock[1].usiPixel[63] = 0xFFFE;
	buffer_data_m1->xPixelDataBlock[1].ulliMask = 0xFFFFFFFFFFFFFFFF;

	buffer_data_m1->xPixelDataBlock[2] = buffer_data_m1->xPixelDataBlock[0];
	buffer_data_m1->xPixelDataBlock[3] = buffer_data_m1->xPixelDataBlock[1];
	buffer_data_m1->xPixelDataBlock[4] = buffer_data_m1->xPixelDataBlock[2];
	buffer_data_m1->xPixelDataBlock[5] = buffer_data_m1->xPixelDataBlock[3];
	buffer_data_m1->xPixelDataBlock[6] = buffer_data_m1->xPixelDataBlock[4];
	buffer_data_m1->xPixelDataBlock[7] = buffer_data_m1->xPixelDataBlock[5];
	buffer_data_m1->xPixelDataBlock[8] = buffer_data_m1->xPixelDataBlock[6];
	buffer_data_m1->xPixelDataBlock[9] = buffer_data_m1->xPixelDataBlock[7];
	buffer_data_m1->xPixelDataBlock[10] = buffer_data_m1->xPixelDataBlock[8];
	buffer_data_m1->xPixelDataBlock[11] = buffer_data_m1->xPixelDataBlock[9];
	buffer_data_m1->xPixelDataBlock[12] = buffer_data_m1->xPixelDataBlock[10];
	buffer_data_m1->xPixelDataBlock[13] = buffer_data_m1->xPixelDataBlock[11];
	buffer_data_m1->xPixelDataBlock[14] = buffer_data_m1->xPixelDataBlock[12];
	buffer_data_m1->xPixelDataBlock[15] = buffer_data_m1->xPixelDataBlock[13];

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

	TFeebBufferDataBlock *buffer_data_m2 =
			(TFeebBufferDataBlock *) Ddr2Base;

	buffer_data_m2->xPixelDataBlock[0].usiPixel[0] = 0x0100;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[1] = 0x0302;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[2] = 0x0504;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[3] = 0x0706;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[4] = 0x0908;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[5] = 0x0B0A;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[6] = 0x0D0C;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[7] = 0x0F0E;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[8] = 0x1110;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[9] = 0x1312;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[10] = 0x1514;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[11] = 0x1716;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[12] = 0x1918;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[13] = 0x1B1A;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[14] = 0x1D1C;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[15] = 0x1F1E;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[16] = 0x2120;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[17] = 0x2322;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[18] = 0x2524;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[19] = 0x2726;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[20] = 0x2928;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[21] = 0x2B2A;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[22] = 0x2D2C;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[23] = 0x2F2E;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[24] = 0x3130;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[25] = 0x3332;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[26] = 0x3534;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[27] = 0x3736;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[28] = 0x3938;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[29] = 0x3B3A;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[30] = 0x3D3C;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[31] = 0x3F3E;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[32] = 0x4140;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[33] = 0x4342;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[34] = 0x4544;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[35] = 0x4746;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[36] = 0x4948;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[37] = 0x4B4A;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[38] = 0x4D4C;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[39] = 0x4F4E;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[40] = 0x5150;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[41] = 0x5352;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[42] = 0x5554;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[43] = 0x5756;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[44] = 0x5958;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[45] = 0x5B5A;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[46] = 0x5D5C;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[47] = 0x5F5E;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[48] = 0x6160;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[49] = 0x6362;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[50] = 0x6564;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[51] = 0x6766;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[52] = 0x6968;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[53] = 0x6B6A;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[54] = 0x6D6C;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[55] = 0x6F6E;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[56] = 0x7170;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[57] = 0x7372;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[58] = 0x7574;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[59] = 0x7776;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[60] = 0x7978;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[61] = 0x7B7A;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[62] = 0x7D7C;
	buffer_data_m2->xPixelDataBlock[0].usiPixel[63] = 0x7F7E;
	buffer_data_m2->xPixelDataBlock[0].ulliMask = 0xFFFFFFFFFFFFFFFF;

	buffer_data_m2->xPixelDataBlock[1].usiPixel[0] = 0x8180;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[1] = 0x8382;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[2] = 0x8584;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[3] = 0x8786;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[4] = 0x8988;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[5] = 0x8B8A;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[6] = 0x8D8C;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[7] = 0x8F8E;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[8] = 0x9190;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[9] = 0x9392;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[10] = 0x9594;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[11] = 0x9796;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[12] = 0x9998;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[13] = 0x9B9A;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[14] = 0x9D9C;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[15] = 0x9F9E;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[16] = 0xA1A0;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[17] = 0xA3A2;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[18] = 0xA5A4;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[19] = 0xA7A6;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[20] = 0xA9A8;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[21] = 0xABAA;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[22] = 0xADAC;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[23] = 0xAFAE;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[24] = 0xB1B0;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[25] = 0xB3B2;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[26] = 0xB5B4;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[27] = 0xB7B6;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[28] = 0xB9B8;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[29] = 0xBBBA;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[30] = 0xBDBC;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[31] = 0xBFBE;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[32] = 0xC1C0;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[33] = 0xC3C2;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[34] = 0xC5C4;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[35] = 0xC7C6;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[36] = 0xC9C8;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[37] = 0xCBCA;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[38] = 0xCDCC;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[39] = 0xCFCE;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[40] = 0xD1D0;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[41] = 0xD3D2;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[42] = 0xD5D4;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[43] = 0xD7D6;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[44] = 0xD9D8;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[45] = 0xDBDA;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[46] = 0xDDDC;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[47] = 0xDFDE;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[48] = 0xE1E0;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[49] = 0xE3E2;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[50] = 0xE5E4;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[51] = 0xE7E6;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[52] = 0xE9E8;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[53] = 0xEBEA;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[54] = 0xEDEC;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[55] = 0xEFEE;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[56] = 0xF1F0;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[57] = 0xF3F2;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[58] = 0xF5F4;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[59] = 0xF7F6;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[60] = 0xF9F8;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[61] = 0xFBFA;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[62] = 0xFDFC;
	buffer_data_m2->xPixelDataBlock[1].usiPixel[63] = 0xFFFE;
	buffer_data_m2->xPixelDataBlock[1].ulliMask = 0xFFFFFFFFFFFFFFFF;

	buffer_data_m2->xPixelDataBlock[2] = buffer_data_m2->xPixelDataBlock[0];
	buffer_data_m2->xPixelDataBlock[3] = buffer_data_m2->xPixelDataBlock[1];
	buffer_data_m2->xPixelDataBlock[4] = buffer_data_m2->xPixelDataBlock[2];
	buffer_data_m2->xPixelDataBlock[5] = buffer_data_m2->xPixelDataBlock[3];
	buffer_data_m2->xPixelDataBlock[6] = buffer_data_m2->xPixelDataBlock[4];
	buffer_data_m2->xPixelDataBlock[7] = buffer_data_m2->xPixelDataBlock[5];
	buffer_data_m2->xPixelDataBlock[8] = buffer_data_m2->xPixelDataBlock[6];
	buffer_data_m2->xPixelDataBlock[9] = buffer_data_m2->xPixelDataBlock[7];
	buffer_data_m2->xPixelDataBlock[10] = buffer_data_m2->xPixelDataBlock[8];
	buffer_data_m2->xPixelDataBlock[11] = buffer_data_m2->xPixelDataBlock[9];
	buffer_data_m2->xPixelDataBlock[12] = buffer_data_m2->xPixelDataBlock[10];
	buffer_data_m2->xPixelDataBlock[13] = buffer_data_m2->xPixelDataBlock[11];
	buffer_data_m2->xPixelDataBlock[14] = buffer_data_m2->xPixelDataBlock[12];
	buffer_data_m2->xPixelDataBlock[15] = buffer_data_m2->xPixelDataBlock[13];

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

	if (bFeebInitM1Dma()) {
		printf("dma_m1 iniciado corretamente \n");
	}

	if (bFeebInitM2Dma()) {
		printf("dma_m2 iniciado corretamente \n");
	}

	if (bFeebDmaM1Transfer(0, 16, eFeebRightBuffer, eFeebCh1Buffer)) {
		if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh1Buffer)) {
			printf("channel a transferido corretamente \n");
		}
	}

	if (bFeebDmaM1Transfer(0, 16, eFeebRightBuffer, eFeebCh2Buffer)) {
		if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh2Buffer)) {
			printf("channel b transferido corretamente \n");
		}
	}

	if (bFeebDmaM1Transfer(0, 16, eFeebRightBuffer, eFeebCh3Buffer)) {
		if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh3Buffer)) {
			printf("channel c transferido corretamente \n");
		}
	}

	if (bFeebDmaM1Transfer(0, 16, eFeebRightBuffer, eFeebCh4Buffer)) {
		if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh4Buffer)) {
			printf("channel d transferido corretamente \n");
		}
	}

	if (bFeebDmaM1Transfer(0, 16, eFeebRightBuffer, eFeebCh5Buffer)) {
		if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh5Buffer)) {
			printf("channel e transferido corretamente \n");
		}
	}

	if (bFeebDmaM1Transfer(0, 16, eFeebRightBuffer, eFeebCh6Buffer)) {
		if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh6Buffer)) {
			printf("channel f transferido corretamente \n");
		}
	}

	if (bFeebDmaM1Transfer(0, 16, eFeebRightBuffer, eFeebCh7Buffer)) {
		if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh7Buffer)) {
			printf("channel g transferido corretamente \n");
		}
	}

	if (bFeebDmaM1Transfer(0, 16, eFeebRightBuffer, eFeebCh8Buffer)) {
		if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh8Buffer)) {
			printf("channel h transferido corretamente \n");
		}
	}

	bool loop = TRUE;

	while (loop) {
		usleep(5000);

		bCommGetLinkStatus(&xSpw1);
		if (xSpw1.xLinkStatus.bRunning) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1R_MASK);
		}

		bCommGetLinkStatus(&xSpw2);
		if (xSpw2.xLinkStatus.bRunning) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_2R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_2G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_2R_MASK);
		}

		bCommGetLinkStatus(&xSpw3);
		if (xSpw3.xLinkStatus.bRunning) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_3R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_3G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_3R_MASK);
		}

		bCommGetLinkStatus(&xSpw4);
		if (xSpw4.xLinkStatus.bRunning) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_4R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_4G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_4R_MASK);
		}

		bCommGetLinkStatus(&xSpw5);
		if (xSpw5.xLinkStatus.bRunning) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_5R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_5G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_5R_MASK);
		}

		bCommGetLinkStatus(&xSpw6);
		if (xSpw6.xLinkStatus.bRunning) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_6R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_6G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_6R_MASK);
		}

		bCommGetLinkStatus(&xSpw7);
		if (xSpw7.xLinkStatus.bRunning) {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_7R_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7G_MASK);
		} else {
			LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_7G_MASK);
			LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_7R_MASK);
		}

		bCommGetLinkStatus(&xSpw8);
		if (xSpw8.xLinkStatus.bRunning) {
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
			if (bFeebDmaM2Transfer(0, 16, eFeebRightBuffer, eFeebCh1Buffer)) {
				printf("dma_m2 transferido corretamente \n");
			}
			break;

		case '2':
			printf("m2 L \n");
			if (bFeebDmaM2Transfer(0, 16, eFeebLeftBuffer, eFeebCh1Buffer)) {
				printf("dma_m2 transferido corretamente \n");
			}
			break;

		case 'a':
			printf("a \n");
			if (bFeebDmaM2Transfer(0, 16, eFeebRightBuffer, eFeebCh1Buffer)) {
				printf("dma_m2 transferido corretamente \n");
			}
//			if (bFeebDmaM1Transfer(0, 16, eFeebLeftBuffer, eFeebCh1Buffer)) {
//				printf("dma_m1 transferido corretamente \n");
//			}
			usleep(500);
			bCommGetBuffersStatus(&xSpw1);
			printf("empty: %u \n", xSpw1.xBufferStatus.bRightBufferEmpty);
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

	bCommSetLink(&xSpw1);
	bCommSetLink(&xSpw8);

	//*xSpw1.puliChAddr = 0x102;
	printf("%08X", *(xSpw1.puliChAddr));

	usleep(10000);

	bCommGetLinkStatus(&xSpw1);
	if (xSpw1.xLinkStatus.bRunning) {
		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1R_MASK);
		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1G_MASK);
	} else {
		LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_1G_MASK);
		LEDS_PAINEL_DRIVE(LEDS_ON, LEDS_1R_MASK);
	}

	bCommGetLinkStatus(&xSpw8);
	if (xSpw8.xLinkStatus.bRunning) {
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
		bCommGetBuffersStatus(&xSpw1);
		printf("empty r: %u \n", xSpw1.xBufferStatus.bRightBufferEmpty);
		printf("empty l: %u \n", xSpw1.xBufferStatus.bLeftBufferEmpty);
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
	vTestLeds();

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
		TEMP_Read(&ucTempFpga, &ucTempBoard);
		SSDP_UPDATE(ucTempFpga);
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

void vTestLeds(void) {
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

