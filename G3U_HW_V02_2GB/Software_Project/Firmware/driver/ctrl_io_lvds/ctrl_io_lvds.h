/**
 * @file   ctrl_io_lvds.h
 * @Author Cassio Berni (ccberni@hotmail.com)
 * @date   Outubro, 2018
 * @brief  Header File para controle dos i/o´s lvds (placa drivers_lvds e iso_simucam) via Avalon
 *
 * Exemplos de utilização em baixo nível (não é para utilizar assim, existe uma api definida):
 * ctrl_io_lvds_drive(LVDS_IO_ON, LVDS_EN_ISO_DRIVERS_MSK | LVDS_PWDN_MSK | ...);
 * ctrl_io_lvds_drive(LVDS_IO_OFF, LVDS_PEM1_MSK | LVDS_PEM0_MSK | ...);
 */

#ifndef CTRL_IO_LVDS_H_
#define CTRL_IO_LVDS_H_

#include "../../simucam_definitions.h"

//! [constants definition]
// address
#define LVDS_CTRL_IO_LVDS_ADDR_BASE     PIO_CTRL_IO_LVDS_BASE

// io states
#define LVDS_IO_ON                      TRUE
#define LVDS_IO_OFF                     FALSE

// io masks
#define LVDS_EN_ISO_DRIVERS_MSK         0x08
#define LVDS_PWDN_MSK                   0x04
#define LVDS_PEM1_MSK                   0x02
#define LVDS_PEM0_MSK                   0x01

// Pre-emphasys levels
#define LVDS_PEM_OFF                    0
#define LVDS_PEM_LO                     1
#define LVDS_PEM_MID                    2
#define LVDS_PEM_HI                     3
//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]
bool bEnableIsoDrivers(void);
bool bDisableIsoDrivers(void);
bool bEnableLvdsBoard(void);
bool bDisableLvdsBoard(void);
bool bSetPreEmphasys(alt_u8 ucPemLevel);

bool bEnableIsoLogic(void);
bool bDisableIsoLogic(void);
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
