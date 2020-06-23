// --------------------------------------------------------------------
// Copyright (c) 2009 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------

#include "power_spi.h"

#define SPI_SCK(x)    IOWR_ALTERA_AVALON_PIO_DATA(CSENSE_SCK_BASE,x)
#define SPI_FO(x)     IOWR_ALTERA_AVALON_PIO_DATA(CSENSE_ADC_FO_BASE,x)  
#define SPI_CS_N(s,x) IOWR_ALTERA_AVALON_PIO_DATA(CSENSE_CS_N_BASE,(x==1)?0x03:((s==0)?0x02:0x01))  
#define SPI_SDI(x)    IOWR_ALTERA_AVALON_PIO_DATA(CSENSE_SDI_BASE,x)
#define SPI_SDO       (IORD_ALTERA_AVALON_PIO_DATA(CSENSE_SDO_BASE) & 0x01)
#define SPI_DELAY     usleep(15)  // based on 50MHZ of CPU clock
// Note. SCK: typical 19.2KHZ (53 ms)
bool POWER_SPI_RW(alt_u8 IcIndex, alt_u8 NextChannel, bool bEN, bool bSIGN, bool bSGL, alt_u32 *pValue) {
	bool bSuccess;
	alt_u8 Config8;
	alt_u32 Value32 = 0, Mask32;
	int i, nWait = 0, nZeroCnt;
	const int nMaxWait = 1000000;

	//
	Config8 = 0x80;
	Config8 |= (bEN) ? 0x20 : 0x00;
	Config8 |= (bSGL) ? 0x10 : 0x00;
	Config8 |= (bSIGN) ? 0x08 : 0x00;
	Config8 |= NextChannel & 0x07; // channel

	SPI_FO(0); // use internal conversion clock
	SPI_SCK(0);  // set low to active extenal serial clock mode.
	SPI_CS_N(IcIndex, 0);  // chip select: active
	SPI_DELAY;

	// wait for converion end (when conversion done, SPI_SDO is low)
	while (SPI_SDO && nWait < nMaxWait) {
		nWait++;
	}

	if (SPI_SDO) {
		SPI_CS_N(IcIndex, 1);  // chip select: inactive
		return FALSE;
	}

	for (i = 0; i < 2; i++) // send config bits 7:6,
			// ignore EOC/ and DMY bits
			{
		SPI_SDI((Config8 & 0x80) ? 1 : 0);    //sdi=nextch.7; // put data on pin
		Config8 <<= 1; //nextch = rl(nextch); // get next config bit ready
		Value32 <<= 1; //result_0 = rl(result_0);// get ready to load lsb
		Value32 |= SPI_SDO; //result_0.0 = sdo; // load lsb

		SPI_SCK(1); //sck=1; // clock high
		SPI_DELAY;
		SPI_SCK(0); //sck=0; // clock low
		SPI_DELAY;
	}

	for (i = 0; i < 8; i++) // send config, read byte 3
			{
		SPI_SDI((Config8 & 0x80) ? 1 : 0); //sdi=nextch.7; // put data on pin
		Config8 <<= 1; //nextch = rl(nextch); // get next config bit ready

		Value32 <<= 1; //result_3 = rl(result_3);// get ready to load lsb
		Value32 |= SPI_SDO; //result_3.0 = sdo; // load lsb

		SPI_SCK(1); //sck=1; // clock high
		SPI_DELAY;
		SPI_SCK(0); //sck=0; // clock low
		SPI_DELAY;
	}

	for (i = 0; i < 8; i++) // read byte 2
			{
		Value32 <<= 1; //result_2 = rl(result_2);// get ready to load lsb
		Value32 |= SPI_SDO; //result_2.0 = sdo; // load lsb

		SPI_SCK(1); //sck=1; // clock high
		SPI_DELAY;
		SPI_SCK(0); //sck=0; // clock low
		SPI_DELAY;
	}

	for (i = 0; i < 8; i++) // read byte 1
			{
		Value32 <<= 1; //result_1 = rl(result_1);// get ready to load lsb
		Value32 |= SPI_SDO; //result_1.0 = sdo; // load lsb

		SPI_SCK(1); //sck=1; // clock high
		SPI_DELAY;
		SPI_SCK(0); //sck=0; // clock low
		SPI_DELAY;
	}

	for (i = 0; i < 6; i++) // read byte 0
			{
		Value32 <<= 1; //result_0 = rl(result_0);// get ready to load lsb
		Value32 |= SPI_SDO; //result_0.0 = sdo; // load lsb

		SPI_SCK(1); //sck=1; // clock high
		SPI_DELAY;
		SPI_SCK(0); //sck=0; // clock low
		SPI_DELAY;
	}
	SPI_SCK(1);
	SPI_DELAY;
	SPI_CS_N(IcIndex, 1);  // chip select: inactive

	// check parity
	nZeroCnt = 0;
	Mask32 = 0x01;
	for (i = 0; i < 32; i++) {
		if ((Value32 & Mask32) == 0x00) {
			nZeroCnt++;
		}
		Mask32 <<= 1;
	}
	bSuccess = (nZeroCnt & 0x01) ? FALSE : TRUE;
	if (!bSuccess) {
		return FALSE;
	}

	*pValue = Value32;

	return bSuccess;
}

