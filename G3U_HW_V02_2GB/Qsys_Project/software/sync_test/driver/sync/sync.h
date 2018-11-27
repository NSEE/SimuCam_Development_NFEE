  /**
  * @file   sync.h
  * @Author Cassio Berni (ccberni@hotmail.com)
  * @date   Novembro, 2018
  * @brief  Header File para controle do sync ip via Nios-Avalon
  */
 
#ifndef SYNC_H_
#define SYNC_H_

#include "../../utils/meb_includes.h"
#include "system.h"
#include <altera_avalon_pio_regs.h>

//! [constants definition]
// address
#define SYNC_BASE_ADDR					SYNC_BASE
#define SYNC_STATUS_REG_OFFSET			0
#define SYNC_INT_ENABLE_REG_OFFSET		1
#define SYNC_INT_FLAG_CLEAR_REG_OFFSET	2
#define SYNC_INT_FLAG_REG_OFFSET 		3
#define SYNC_CONFIG_MBT_REG_OFFSET 		4
#define SYNC_CONFIG_BT_REG_OFFSET		5
#define SYNC_CONFIG_PER_REG_OFFSET		6
#define SYNC_CONFIG_OST_REG_OFFSET 		7
#define SYNC_CONFIG_GENERAL_REG_OFFSET 	8
#define SYNC_ERR_INJ_REG_OFFSET 		9
#define SYNC_CONTROL_REG_OFFSET			10

// io states
#define IO_ON   TRUE
#define IO_OFF  FALSE

// io masks
#define EN_ISO_DRIVERS_MASK 0x08
#define PWDN_MASK           0x04
#define PEM1_MASK           0x02
#define PEM0_MASK           0x01
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
PUBLIC bool enable_sinc_out(void);
PUBLIC bool disable_sinc_out(void);
PUBLIC bool read_sinc_in(void);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* SYNC_H_ */
