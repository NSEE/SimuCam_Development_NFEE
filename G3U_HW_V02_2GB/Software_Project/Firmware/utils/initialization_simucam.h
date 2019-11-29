/*
 * initialization_simucam.h
 *
 *  Created on: 20/10/2018
 *      Author: TiagoLow
 */

#ifndef INITIALIZATION_SIMUCAM_H_
#define INITIALIZATION_SIMUCAM_H_

#include "../simucam_definitions.h"
#include "../driver/reset/reset.h"
#include "../driver/ctrl_io_lvds/ctrl_io_lvds.h"
#include "../driver/leds/leds.h"

 /* Intel System ID Peripheral Registers */
typedef struct SidpRegisters {
  alt_u32 uliId; /* 32-bit System ID */
  alt_u32 uliTimestamp; /* 32-bit System Timestamp */
} TSidpRegisters;

bool bInitSimucamCoreHW ( void );
void vInitSimucamBasicHW(void);

#endif /* INITIALIZATION_SIMUCAM_H_ */
