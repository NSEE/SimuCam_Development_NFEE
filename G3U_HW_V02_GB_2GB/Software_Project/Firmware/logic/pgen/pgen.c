/*
 * pgen.c
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

	#include "pgen.h"
	#include "pgen_registers.h"

	void PGEN_WRITE_REG32(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue){
		alt_u32 *pPgenAddr = PGEN_BASE;
		*(pPgenAddr + (alt_u32)uc_RegisterAddress) = (alt_u32) ul_RegisterValue;
	}

	alt_u32 PGEN_READ_REG32(alt_u8 uc_RegisterAddress){
		alt_u32 RegisterValue = 0;
		alt_u32 *pPgenAddr = PGEN_BASE;
		RegisterValue = *(pPgenAddr + (alt_u32)uc_RegisterAddress);
		return RegisterValue;
	}

	bool b_Pattern_Generator_Write_Register(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue){

		bool bSuccess = FALSE;

		if (uc_RegisterAddress <= 0x01) {
			PGEN_WRITE_REG32(uc_RegisterAddress, ul_RegisterValue);
			bSuccess = TRUE;
		}

		return bSuccess;
	}

	alt_u32 ul_Pattern_Generator_Read_Register(alt_u8 uc_RegisterAddress){

		alt_u32 ul_RegisterValue = 0;

		if (uc_RegisterAddress <= 0x01) {
			ul_RegisterValue = PGEN_READ_REG32(uc_RegisterAddress);
		}

		return ul_RegisterValue;
	}

	void v_Pattern_Generator_Start(void){

		PGEN_WRITE_REG32(PGEN_GENERATOR_CONTROL_STATUS_REGISTER_ADDRESS, (alt_u32)PGEN_START_CONTROL_BIT_MASK);

	}

	void v_Pattern_Generator_Stop(void){

		PGEN_WRITE_REG32(PGEN_GENERATOR_CONTROL_STATUS_REGISTER_ADDRESS, (alt_u32)PGEN_STOP_CONTROL_BIT_MASK);

	}

	void v_Pattern_Generator_Reset(void){

		PGEN_WRITE_REG32(PGEN_GENERATOR_CONTROL_STATUS_REGISTER_ADDRESS, (alt_u32)PGEN_RESET_CONTROL_BIT_MASK);

	}

	alt_u32 Pattern_Generator_Status(void){

		const alt_u32 ul_pgen_mask = PGEN_RESETED_STATUS_BIT_MASK | PGEN_STOPPED_STATUS_BIT_MASK;
		alt_u32 ul_pgen_status_value = PGEN_READ_REG32(PGEN_GENERATOR_CONTROL_STATUS_REGISTER_ADDRESS) & ul_pgen_mask;

		return ul_pgen_status_value;
	}

	bool Pattern_Generator_Configure_Initial_State(alt_u8 uc_Initial_CCD_ID, alt_u8 uc_Initial_CCD_SIDE, alt_u8 uc_Initial_TimeCode){

		bool bSuccess = FALSE;

		alt_u32 initial_state_config_value;
		if ((uc_Initial_CCD_ID < 4) && (uc_Initial_CCD_SIDE < 2)) {
			initial_state_config_value = (((alt_u32)uc_Initial_CCD_ID) << 9) | (((alt_u32)uc_Initial_CCD_SIDE) << 8) | ((alt_u32)uc_Initial_TimeCode);
			PGEN_WRITE_REG32(PGEN_INITIAL_TRANSMISSION_STATE_REGISTER_ADDRESS, initial_state_config_value);
			bSuccess = TRUE;
		}

		return bSuccess;
	}
