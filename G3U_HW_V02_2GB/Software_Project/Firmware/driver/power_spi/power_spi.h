// --------------------------------------------------------------------
// Copyright (c) 2008 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------

#ifndef __POWER_SPI_H__
#define __POWER_SPI_H__

#include "../../simucam_definitions.h"

#define POWER_DEVICE0_PORT_NUM  8
#define POWER_DEVICE1_PORT_NUM  4
#define POWER_PORT_NUM     (POWER_DEVICE0_PORT_NUM + POWER_DEVICE1_PORT_NUM)
#define POWER_DEVICE_NUM   2
bool POWER_SPI_RW(alt_u8 IcIndex, alt_u8 NextChannel, bool bEN, bool bSIGN, bool bSGL, alt_u32 *pValue);

#endif /*POWER_SPI_H_*/
