#include "mbed.h"

DigitalOut LED_RGB_RED(LED_RED, 1);
DigitalOut LED_RGB_GREEN(LED_GREEN, 1);
DigitalOut LED_RGB_BLUE(LED_BLUE, 1);

DigitalOut SCK(PTA5, 0);
DigitalOut CS_n(PTD4, 1);
DigitalIn  SDO(PTA12, PullNone);
DigitalOut SDI(PTA4, 0);

Serial USB(USBTX, USBRX);

#define LED_RED_ON (LED_RGB_RED.write(0))
#define LED_RED_OFF (LED_RGB_RED.write(1))
#define LED_GREEN_ON (LED_RGB_GREEN.write(0))
#define LED_GREEN_OFF (LED_RGB_GREEN.write(1))
#define LED_BLUE_ON (LED_RGB_BLUE.write(0))
#define LED_BLUE_OFF (LED_RGB_BLUE.write(1))

#define SPI_SCK(x)  (SCK.write(x))
#define SPI_CS_N(x) (CS_n.write(x))
#define SPI_SDO     (SDO.read())
#define SPI_SDI(x)  (SDI.write(x))
#define SPI_DELAY   wait_us(15)

#define READ   0x13
#define WRITE  0x12
#define IDREAD 0x33

#define RTCSEC_REGISTER_ADDRESS   0x01
#define RTCWKDAY_REGISTER_ADDRESS 0x04
#define CONTROL_REGISTER_ADDRESS  0x08

#define EUI48_B0_ADDRESS 0x02
#define EUI48_B1_ADDRESS 0x03
#define EUI48_B2_ADDRESS 0x04
#define EUI48_B3_ADDRESS 0x05
#define EUI48_B4_ADDRESS 0x06
#define EUI48_B5_ADDRESS 0x07

typedef char          alt_8;
typedef int           alt_16;
typedef long          alt_32;
typedef unsigned char alt_u8;
typedef unsigned int  alt_u16;

void v_spi_start(void);
void v_spi_send_byte(alt_u8 uc_data);
alt_u8 uc_spi_get_byte(void);
void v_spi_end(void);
void RTCC_SPI_READ_MAC(void);
void RTCC_SPI_START_SQUARE_WAVE_GENERATOR(void);
void RTCC_SPI_ENABLE_VBAT(void);

int main() {

        LED_RED_ON;
        wait(15);
        LED_RED_OFF;
        LED_BLUE_ON;
        RTCC_SPI_START_SQUARE_WAVE_GENERATOR();
        wait(5);
        LED_GREEN_ON;
        RTCC_SPI_ENABLE_VBAT();
        wait(5);
        LED_BLUE_OFF;
        LED_GREEN_ON;

    while(1) {
        RTCC_SPI_READ_MAC();
        wait(5);
    }
}

typedef unsigned long alt_u32;

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

void RTCC_SPI_READ_MAC(void){
    alt_u8 uc_EUI48_array[6] = {0,0,0,0,0,0};

    // Start Communication
    v_spi_start();
    // Send IDREAD (0011 0011)
    v_spi_send_byte(IDREAD);
    // Send Address (0x02 - 0x07)
    v_spi_send_byte(EUI48_B0_ADDRESS);
    // Read MAC (EUI-48, 6 bytes)
    uc_EUI48_array[0] = uc_spi_get_byte();
    uc_EUI48_array[1] = uc_spi_get_byte();
    uc_EUI48_array[2] = uc_spi_get_byte();
    uc_EUI48_array[3] = uc_spi_get_byte();
    uc_EUI48_array[4] = uc_spi_get_byte();
    uc_EUI48_array[5] = uc_spi_get_byte();
    // End communication
    v_spi_end();

    printf("RTCC EUI-48 MAC Address: 0x%x%x%x%x%x%x \n", uc_EUI48_array[0], uc_EUI48_array[1], uc_EUI48_array[2], uc_EUI48_array[3], uc_EUI48_array[4], uc_EUI48_array[5]);

}

void RTCC_SPI_ENABLE_VBAT(void){
    
    /*
    * Enviar READ Command (0x13)
    * Enviar RTCWKDAY Register ADDRESS (0x04)
    * Verificar se OSCRUN está setado (0x10)
    *
    * Enviar WRITE Command (0x12)
    * Enviar RTCWKDAY Register ADDRESS (0x04)
    * Configurar RTCWKDAY Register (0x09)
    * b7 - -       : 0
    * b6 - -       : 0
    * b5 - OSCRUN  : 0
    * b4 - PWRFAIL : 0
    * b3 - VBATEN  : 1
    * b2 - WKDAY2  : 0
    * b1 - WKDAY1  : 0
    * b0 - WKDAY0  : 1
    */

    alt_u8 const oscrun_bit_mask = 0x20;
    alt_u8 rtcwkday_reg = 0;

    do {
      // Start Communication
      v_spi_start();
      // Send WRITE (0001 0011)
      v_spi_send_byte(READ);
      // Send Address (RTCWKDAY)
      v_spi_send_byte(RTCWKDAY_REGISTER_ADDRESS);
      // Get Data
      rtcwkday_reg = uc_spi_get_byte();
      // End communication
      v_spi_end();
      SPI_DELAY;
    } while (!(rtcwkday_reg & oscrun_bit_mask));
    
    // Start Communication
    v_spi_start();
    // Send WRITE (0001 0010)
    v_spi_send_byte(WRITE);
    // Send Address (RTCWKDAY)
    v_spi_send_byte(RTCWKDAY_REGISTER_ADDRESS);
    // Send Data
    v_spi_send_byte(0x09);
    // End communication
    v_spi_end();
    
    SPI_DELAY;
   
    printf("VBAT Enabled \n");
    
}

void RTCC_SPI_START_SQUARE_WAVE_GENERATOR(void){
    
    /*
    * Enviar WRITE Command (0x12)
    * Enviar CONTROL Register ADDRESS (0x08)
    * Configurar CONTROL Register (0x41)
    * b7 - -       : 0
    * b6 - SQWEN   : 1
    * b5 - ALM1EN  : 0
    * b4 - ALM0EN  : 0
    * b3 - EXTOSC  : 0
    * b2 - CRSTRIM : 0
    * b1 - SQWFS1  : 0
    * b0 - SQWFS0  : 1
    * 
    * Enviar WRITE Command (0x12)
    * Enviar RTCSEC Register ADDRESS (0x01)
    * Configurar RTCSEC Register (0x80)
    * b7 - ST      : 1
    * b6 - SECTEN2 : 0
    * b5 - SECTEN1 : 0
    * b4 - SECTEN0 : 0
    * b3 - SECONE3 : 0
    * b2 - SECONE2 : 0
    * b1 - SECONE1 : 0
    * b0 - SECONE0 : 0
    */
    
    // Start Communication
    v_spi_start();
    // Send WRITE (0001 0010)
    v_spi_send_byte(WRITE);
    // Send Address (CONTROL)
    v_spi_send_byte(CONTROL_REGISTER_ADDRESS);
    // Send Data
    v_spi_send_byte(0x41);
    // End communication
    v_spi_end();
    
    SPI_DELAY;

    // Start Communication
    v_spi_start();  
    // Send WRITE (0001 0010)
    v_spi_send_byte(WRITE);
    // Send Address (RTCSEC)
    v_spi_send_byte(RTCSEC_REGISTER_ADDRESS);
    // Send Data
    v_spi_send_byte(0x80);
    // End communication
    v_spi_end();
    
    printf("Square Wave Generator Configured \n");
    
}
