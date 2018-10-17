  /**
  * @file   sinc.h
  * @Author Cassio Berni (ccberni@hotmail.com)
  * @date   Outubro, 2018
  * @brief  Header File para controle dos i/o´s sinc_in/sinc_out (placa painel e iso_simucam) via Avalon
  */
 
#ifndef SINC_H_
#define SINC_H_

#include "../../utils/meb_includes.h"
#include "system.h"
#include <altera_avalon_pio_regs.h>

//! [constants definition]
// address
#define SINC_IN_ADDR_BASE 	SINC_IN_BASE
#define SINC_OUT_ADDR_BASE	SINC_OUT_BASE

// io states
#define IO_ON   TRUE
#define IO_OFF  FALSE
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

#endif /* SINC_H_ */
