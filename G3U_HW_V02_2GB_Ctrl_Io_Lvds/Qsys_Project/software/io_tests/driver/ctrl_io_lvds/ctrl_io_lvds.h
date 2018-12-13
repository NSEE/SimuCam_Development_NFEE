  /**
  * @file   ctrl_io_lvds.h
  * @Author Cassio Berni (ccberni@hotmail.com)
  * @date   Outubro, 2018
  * @brief  Header File para controle dos i/o´s lvds (placa drivers_lvds e iso_simucam) via Avalon
  *
  * Exemplos de utilização em baixo nível (não é para utilizar assim, existe uma api definida):
  * ctrl_io_lvds_drive(IO_ON, EN_ISO_DRIVERS_MASK | PWDN_MASK | ...);
  * ctrl_io_lvds_drive(IO_OFF, PEM1_MASK | PEM0_MASK | ...);
  */
 
#ifndef CTRL_IO_LVDS_H_
#define CTRL_IO_LVDS_H_

#include "../../utils/meb_includes.h"
#include "system.h"
#include <altera_avalon_pio_regs.h>

//! [constants definition]
// address
#define CTRL_IO_LVDS_ADDR_BASE PIO_CTRL_IO_LVDS_BASE

// io states
#define IO_ON   TRUE
#define IO_OFF  FALSE

// io masks
#define EN_ISO_DRIVERS_MASK 0x08
#define PWDN_MASK           0x04
#define PEM1_MASK           0x02
#define PEM0_MASK           0x01

// Pre-emphasys levels
#define PEM_OFF             0
#define PEM_LO              1
#define PEM_MID             2
#define PEM_HI              3
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
PUBLIC bool enable_iso_drivers(void);
PUBLIC bool disable_iso_drivers(void);
PUBLIC bool enable_lvds_board(void);
PUBLIC bool disable_lvds_board(void);
PUBLIC bool set_pre_emphasys(alt_u8 pem_level);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* CTRL_IO_LVDS_H_ */
