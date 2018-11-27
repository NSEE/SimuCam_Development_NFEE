  /**
  * @file   sync.c
  * @Author Cassio Berni (ccberni@hotmail.com)
  * @date   Novembro, 2018
  * @brief  Source File para controle sync ip via Nios-Avalon
  *
  */

#include "sync.h"

//! [private function prototypes]
PRIVATE bool sinc_out_drive(bool on_off);
PRIVATE bool sinc_in_read(void);
PRIVATE bool ctrl_io_lvds_drive(bool on_off, alt_u8 mask);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
PRIVATE alt_u8 io_value = 0x04;
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

/**
 * @name    ctrl_io_lvds_drive
 * @brief
 * @ingroup ctrl_io_lvds
 *
 * Ativa ('1') ou desativa ('0') os i/o´s de controle lvds
 *
 * @param [in] on_off -> 0 = io´s off / 1 = i/o´s on
 * @param [in] mask   -> mascara de i/o´s a serem alterados
 *
 * @retval TRUE -> sucesso
 */
PRIVATE bool ctrl_io_lvds_drive(bool on_off, alt_u32 mask)
{
  alt_u32 io_value = 0x00000000;

  io_value = IORD_ALTERA_AVALON_PIO_DATA(SINC_IN_ADDR_BASE);

  if (on_off == IO_OFF) {
   io_value &= (~mask);
  }
  else {
   io_value |= mask;
  }
  
  IOWR_ALTERA_AVALON_PIO_DATA(CTRL_IO_LVDS_ADDR_BASE, io_value);
  return TRUE;
}
//! [private functions]


  alt_u32 *pSsdpAddr = SSDP_BASE;
  *(pSsdpAddr + SSDP_CONTROL_REG_OFFSET) = (alt_u32) SspdConfigControl;

bool SSDP_UPDATE(alt_u8 SsdpData){

  alt_u32 *pSsdpAddr = SSDP_BASE;
  *(pSsdpAddr + SSDP_DATA_REG_OFFSET) = (alt_u32) SsdpData;
  
  return TRUE;
}

