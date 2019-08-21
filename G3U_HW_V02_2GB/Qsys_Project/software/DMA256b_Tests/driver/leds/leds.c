  /**
  * @file   leds.c
  * @Author Rodrigo França (rodrigo.franca@maua.br | rodmarfra@gmail.com)
  * @date   Maio, 2017
  * @brief  Source File para acesso aos leds do painel MEB e da placa DE4 via Avalon
  *
  */

#include "leds.h"

alt_u8 LedsBoardControl = 0x00;
alt_u32 LedsPainelControl = 0x00010000;

/**
 * @name    LEDS_BOARD_DRIVE
 * @brief
 * @ingroup LEDS
 *
 * Acende/Apaga os leds da Placa DE4 (On/Off)
 *
 * @param [in] bDRIVE  Define se o led será ligado/desligado (LEDS_ON, LEDS_OFF)
 * @param [in] LedsMask  Mascara de leds a serem modificados
 *
 * @retval TRUE : Sucesso
 *
 */
bool bSetBoardLeds(bool bDRIVE, alt_u8 LedsMask){

  // Board LEDs state: ON = 0; OFF = 1;

  if (bDRIVE == LEDS_ON){
	LedsBoardControl &= (~LedsMask);
  } else {
	LedsBoardControl |= LedsMask;
  }
  IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BOARD_BASE, LedsBoardControl);

  return TRUE;
}

/**
 * @name    LEDS_PAINEL_DRIVE
 * @brief
 * @ingroup LEDS
 *
 * Acende/Apaga os leds do Painel MEB (On/Off)
 *
 * @param [in] bDRIVE  Define se o led será ligado/desligado (LEDS_ON, LEDS_OFF)
 * @param [in] LedsMask  Mascara de leds a serem modificados
 *
 * @retval TRUE : Sucesso
 *
 */
bool bSetPainelLeds(bool bDRIVE, alt_u32 LedsMask){

  // Painel LEDs state: ON = 1; OFF = 0;

  if (bDRIVE == LEDS_ON){
	LedsPainelControl |= LedsMask;
  } else {
	LedsPainelControl &= (~LedsMask);
  }
  IOWR_ALTERA_AVALON_PIO_DATA(LEDS_PAINEL_BASE, LedsPainelControl);

  return TRUE;
}
