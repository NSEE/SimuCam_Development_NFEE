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
#include "../../utils/meb_includes.h"
#include "../../utils/util.h"
#include "system.h"
#include <altera_avalon_pio_regs.h>

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

#define LEDS_STATUS_0_MASK 0x0080
#define LEDS_STATUS_1_MASK 0x0040
#define LEDS_STATUS_2_MASK 0x0020
#define LEDS_STATUS_3_MASK 0x0010
#define LEDS_STATUS_ALL_MASK 0x00F0

#define LEDS_SPW_A_MASK 0x0001
#define LEDS_SPW_B_MASK 0x0004
#define LEDS_SPW_C_MASK 0x0002
#define LEDS_SPW_D_MASK 0x0008
#define LEDS_SPW_E_MASK 0x0100
#define LEDS_SPW_F_MASK 0x0400
#define LEDS_SPW_G_MASK 0x0200
#define LEDS_SPW_H_MASK 0x0800
#define LEDS_SPW_ALL_MASK 0x0F0F

#define LEDS_PAINEL_ALL_MASK 0x0FFF

/* prototype */
extern alt_u8 LedsBoardControl;
extern alt_u16 LedsPainelControl;

bool LEDS_BOARD_DRIVE(bool bDRIVE, alt_u8 LedsMask);
bool LEDS_PAINEL_DRIVE(bool bDRIVE, alt_u16 LedsMask);

#endif /* LEDS_H_ */
