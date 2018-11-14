/*
 * pgen.h
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

#ifndef PGEN_H_
#define PGEN_H_

	#include "system.h"
	#include "alt_types.h"

	typedef int bool;
	#define TRUE    1
	#define FALSE   0

	#define PGEN_BASE PATTERN_GENERATOR_A_BASE

	#define PGEN_LEFT_CCD_SIDE  0
	#define PGEN_RIGHT_CCD_SIDE 1

	bool b_Pattern_Generator_Write_Register(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue);
	alt_u32 ul_Pattern_Generator_Read_Register(alt_u8 uc_RegisterAddress);
	void v_Pattern_Generator_Start(void);
	void v_Pattern_Generator_Stop(void);
	void v_Pattern_Generator_Reset(void);
	alt_u32 Pattern_Generator_Status(void);
	bool Pattern_Generator_Configure_Initial_State(alt_u8 uc_Initial_CCD_ID, alt_u8 uc_Initial_CCD_SIDE, alt_u8 uc_Initial_TimeCode);

#endif /* PGEN_H_ */
