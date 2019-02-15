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

#include "rtcc_spi.h"

#define RTCC_ALARM       (IORD_ALTERA_AVALON_PIO_DATA(RTCC_ALARM_BASE) & 0x01)
#define SPI_SCK(x)    IOWR_ALTERA_AVALON_PIO_DATA(RTCC_SCK_BASE,x)
#define SPI_CS_N(x) IOWR_ALTERA_AVALON_PIO_DATA(RTCC_CS_N_BASE,x)
#define SPI_SDI(x)    IOWR_ALTERA_AVALON_PIO_DATA(RTCC_SDI_BASE,x)
#define SPI_SDO       (IORD_ALTERA_AVALON_PIO_DATA(RTCC_SDO_BASE) & 0x01)
#define SPI_DELAY     usleep(150)  // based on 50MHZ of CPU clock

#if DEBUG_ON
char cDebugBuffer[256];
#endif

void v_spi_start(void){
    //Pull CS_n Low to start communication
    SPI_SCK(0);
    SPI_CS_N(0);
    SPI_DELAY;
}

void v_spi_send_byte(alt_u8 uc_data){

    alt_u8 i = 0;
    alt_u8 uc_data_mask = 0x80;

    for(i=0;i<8;i++)
    {
        SPI_SDI((uc_data & uc_data_mask)?1:0);
        uc_data_mask >>= 1;

        SPI_SCK(1);//sck=1; // clock high
        SPI_DELAY;
        SPI_SCK(0);//sck=0; // clock low
        SPI_DELAY;
    }

}

alt_u8 uc_spi_get_byte(void){

    alt_u8 i = 0;
    alt_u8 uc_data = 0;

    for(i=0;i<8;i++) // read byte
    {
        uc_data <<= 1;
        uc_data |= SPI_SDO;

        SPI_SCK(1);//sck=1; // clock high
        SPI_DELAY;
        SPI_SCK(0);//sck=0; // clock low
        SPI_DELAY;
    }

    return uc_data;
}

void v_spi_end(void){
    //Set CS_n to end communication
    SPI_SCK(0);
    SPI_DELAY;
    SPI_CS_N(1);
}

// Note. SCK: typical 19.2KHZ (53 ms)
bool RTCC_SPI_R_MAC(alt_u8 uc_EUI48_array[6])
{
    bool bSuccess = FALSE;

    alt_u8 uc_EUI48_B0 = 0;
    alt_u8 uc_EUI48_B1 = 0;
    alt_u8 uc_EUI48_B2 = 0;
    alt_u8 uc_EUI48_B3 = 0;
    alt_u8 uc_EUI48_B4 = 0;
    alt_u8 uc_EUI48_B5 = 0;

//    alt_u8 uc_sdi_mask;

    const alt_u8 uc_EUI48_B0_addr = 0x02;
//    const alt_u8 uc_EUI48_B1_addr = 0x03;
//    const alt_u8 uc_EUI48_B2_addr = 0x04;
//    const alt_u8 uc_EUI48_B3_addr = 0x05;
//    const alt_u8 uc_EUI48_B4_addr = 0x06;
//    const alt_u8 uc_EUI48_B5_addr = 0x07;

    const alt_u8 uc_IDREAD_cmd = 0x33;

//    int i = 0;
    
    // Start Communication
    v_spi_start();

    //Send IDREAD (0011 0011)
    v_spi_send_byte(uc_IDREAD_cmd);

    //Send Address (0x02 - 0x07)
    v_spi_send_byte(uc_EUI48_B0_addr);

    //Read MAC (EUI-48, 6 bytes)
    uc_EUI48_B0 = uc_spi_get_byte();
    uc_EUI48_B1 = uc_spi_get_byte();
    uc_EUI48_B2 = uc_spi_get_byte();
    uc_EUI48_B3 = uc_spi_get_byte();
    uc_EUI48_B4 = uc_spi_get_byte();
    uc_EUI48_B5 = uc_spi_get_byte();

    // End communication
    v_spi_end();

    bSuccess = TRUE;
    
    uc_EUI48_array[0] = uc_EUI48_B0;
    uc_EUI48_array[1] = uc_EUI48_B1;
    uc_EUI48_array[2] = uc_EUI48_B2;
    uc_EUI48_array[3] = uc_EUI48_B3;
    uc_EUI48_array[4] = uc_EUI48_B4;
    uc_EUI48_array[5] = uc_EUI48_B5;

#if DEBUG_ON
    if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		sprintf(cDebugBuffer, "RTCC EUI-48 MAC Address: 0x%02x:%02x:%02x:%02x:%02x:%02x \n", uc_EUI48_B0, uc_EUI48_B1, uc_EUI48_B2, uc_EUI48_B3, uc_EUI48_B4, uc_EUI48_B5);
		debug(fp, cDebugBuffer);
    }
#endif

    return bSuccess;
}


