  /**
  * @file   sinc.c
  * @Author Cassio Berni (ccberni@hotmail.com)
  * @date   Outubro, 2018
  * @brief  Source File para controle dos i/o´s sinc_in/sinc_out (placa painel e iso_simucam) via Avalon
  *
  */

#include "sinc.h"

//! [private function prototypes]
PRIVATE bool sinc_out_drive(bool on_off);
PRIVATE bool sinc_in_read(void);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
PUBLIC bool enable_sinc_out(void)
{
  sinc_out_drive(IO_ON);
  return  TRUE;
}

PUBLIC bool disable_sinc_out(void)
{
  sinc_out_drive(IO_OFF);
  return  TRUE;
}

PUBLIC bool read_sinc_in(void)
{
  bool result;
  result = sinc_in_read();
  return result;
}
//! [public functions]

//! [private functions]
/**
 * @name    sinc_out_drive
 * @brief
 * @ingroup sinc
 *
 * Ativa ('1') ou desativa ('0') o sinc_out
 *
 * @param [in] on_off -> 0 = off / 1 = on
 *
 * @retval TRUE -> sucesso
 */
PRIVATE bool sinc_out_drive(bool on_off)
{
  alt_u8 io_value = 0x00;	
	
  if (on_off == IO_OFF) {
	 io_value = 0x00;
  }
  else {
	 io_value = 0x01;
  }
  IOWR_ALTERA_AVALON_PIO_DATA(SINC_OUT_ADDR_BASE, io_value);
  return TRUE;
}

/**
 * @name    sinc_in_read
 * @brief
 * @ingroup sinc
 *
 * Faz a leitura do i/o sinc_in e retorna valor
 *
 * @retval valor -> resultado da leitura
 */
PRIVATE bool sinc_in_read(void)
{
  alt_u8 io_value = 0x00;
  
  io_value = IORD_ALTERA_AVALON_PIO_DATA(SINC_IN_ADDR_BASE);
  io_value &= 0x01;
  if (io_value) {
	  return TRUE;
  }
  else {
	  return FALSE;
  }
}
//! [private functions]
