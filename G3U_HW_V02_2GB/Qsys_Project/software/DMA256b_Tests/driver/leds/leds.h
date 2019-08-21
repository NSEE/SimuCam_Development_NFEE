  /**
  * @file   leds.h
  * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
  * @date   Maio, 2017
  * @brief  Header File para acesso aos leds do painel MEB e da placa DE4 via Avalon
  *
  * Exemplo de utilização:
  *  LEDS_BOARD_DRIVE(LEDS_ON, LEDS_BOARD_0_MASK | LEDS_BOARD_7_MASK);
  *  LEDS_PAINEL_DRIVE(LEDS_OFF, LEDS_STATUS_2_MASK | LEDS_SPW_D_MASK);
  *
  */
 
#ifndef LEDS_H_
#define LEDS_H_

/* includes */
#include "../../simucam_definitions.h"

/* address */
#define LEDS_BOARD_BASE PIO_LED_BASE
#define LEDS_PAINEL_BASE PIO_LED_PAINEL_BASE

/* defines */
#define LEDS_ON TRUE
#define LEDS_OFF FALSE

#define LEDS_BOARD_0_MASK 0x01
#define LEDS_BOARD_1_MASK 0x02
#define LEDS_BOARD_2_MASK 0x04
#define LEDS_BOARD_3_MASK 0x08
#define LEDS_BOARD_4_MASK 0x10
#define LEDS_BOARD_5_MASK 0x20
#define LEDS_BOARD_6_MASK 0x40
#define LEDS_BOARD_7_MASK 0x80
#define LEDS_BOARD_ALL_MASK 0xFF

#define LEDS_1G_MASK 0x00000001
#define LEDS_1R_MASK 0x00000002
#define LEDS_2G_MASK 0x00000004
#define LEDS_2R_MASK 0x00000008
#define LEDS_3G_MASK 0x00000010
#define LEDS_3R_MASK 0x00000020
#define LEDS_4G_MASK 0x00000040
#define LEDS_4R_MASK 0x00000080
#define LEDS_5G_MASK 0x00000100
#define LEDS_5R_MASK 0x00000200
#define LEDS_6G_MASK 0x00000400
#define LEDS_6R_MASK 0x00000800
#define LEDS_7G_MASK 0x00001000
#define LEDS_7R_MASK 0x00002000
#define LEDS_8G_MASK 0x00004000
#define LEDS_8R_MASK 0x00008000
#define LEDS_G_ALL_MASK 0x00005555
#define LEDS_R_ALL_MASK 0x0000AAAA
#define LEDS_GR_ALL_MASK 0x0000FFFF

#define LEDS_POWER_MASK 0x00010000
#define LEDS_ST_1_MASK 0x00020000
#define LEDS_ST_2_MASK 0x00040000
#define LEDS_ST_3_MASK 0x00080000
#define LEDS_ST_4_MASK 0x00100000
#define LEDS_ST_ALL_MASK 0x001F0000

#define LEDS_PAINEL_ALL_MASK 0x001FFFFF

/* prototype */
extern alt_u8 LedsBoardControl;
extern alt_u32 LedsPainelControl;

bool bSetBoardLeds(bool bDRIVE, alt_u8 LedsMask);
bool bSetPainelLeds(bool bDRIVE, alt_u32 LedsMask);

#endif /* LEDS_H_ */
