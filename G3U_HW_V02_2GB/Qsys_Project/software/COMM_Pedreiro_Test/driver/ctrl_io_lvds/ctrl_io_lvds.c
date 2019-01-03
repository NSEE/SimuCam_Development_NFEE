  /**
  * @file   ctrl_io_lvds.c
  * @Author Cassio Berni (ccberni@hotmail.com)
  * @date   Outubro, 2018
  * @brief  Source File para controle dos i/o´s lvds (placa drivers_lvds e iso_simucam) via Avalon
  *
  */

#include "ctrl_io_lvds.h"

//! [private function prototypes]
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
PUBLIC bool enable_iso_drivers(void)
{
  ctrl_io_lvds_drive(IO_ON, EN_ISO_DRIVERS_MASK);
  return  TRUE;
}

PUBLIC bool disable_iso_drivers(void)
{
  ctrl_io_lvds_drive(IO_OFF, EN_ISO_DRIVERS_MASK);
  return  TRUE;
}

PUBLIC bool enable_lvds_board(void)
{
  ctrl_io_lvds_drive(IO_ON, PWDN_MASK);
  return  TRUE;
}

PUBLIC bool disable_lvds_board(void)
{
  ctrl_io_lvds_drive(IO_OFF, PWDN_MASK);
  return  TRUE;
}

PUBLIC bool set_pre_emphasys(alt_u8 pem_level)
{
  switch (pem_level) {
    case PEM_OFF:
      ctrl_io_lvds_drive(IO_OFF, PEM1_MASK | PEM0_MASK);
      break;
    case PEM_LO:
      ctrl_io_lvds_drive(IO_OFF, PEM1_MASK);
      ctrl_io_lvds_drive(IO_ON,  PEM0_MASK);
      break;
    case PEM_MID:
      ctrl_io_lvds_drive(IO_OFF, PEM0_MASK);
      ctrl_io_lvds_drive(IO_ON,  PEM1_MASK);
      break;
    case PEM_HI:
      ctrl_io_lvds_drive(IO_ON, PEM1_MASK | PEM0_MASK);
      break;
    default:
      break;
  }
  return TRUE;
}
//! [public functions]

//! [private functions]
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
PRIVATE bool ctrl_io_lvds_drive(bool on_off, alt_u8 mask)
{
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
