/*
 * spwc.c
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

	#include "spwc.h"

	alt_u32 ul_spwc_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_spwc_spacewire_link_control_status_register_value = 0x00000000;

	void SPWC_WRITE_REG32(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue){
		alt_u32 *pSpwcAddr = SPWC_BASE;
		*(pSpwcAddr + (alt_u32)uc_RegisterAddress) = (alt_u32) ul_RegisterValue;
	}

	alt_u32 SPWC_READ_REG32(alt_u8 uc_RegisterAddress){
		alt_u32 RegisterValue = 0;
		alt_u32 *pSpwcAddr = SPWC_BASE;
		RegisterValue = *(pSpwcAddr + (alt_u32)uc_RegisterAddress);
		return RegisterValue;
	}

	bool b_SpaceWire_Interface_Write_Register(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue){

		bool bSuccess = FALSE;

		if (uc_RegisterAddress <= 0x02) {
			SPWC_WRITE_REG32(uc_RegisterAddress, ul_RegisterValue);
			bSuccess = TRUE;
		}

		return bSuccess;
	}

	alt_u32 ul_SpaceWire_Interface_Read_Register(alt_u8 uc_RegisterAddress){

		alt_u32 ul_RegisterValue = 0;

		if (uc_RegisterAddress <= 0x02) {
			ul_RegisterValue = SPWC_READ_REG32(uc_RegisterAddress);
		}

		return ul_RegisterValue;
	}

	bool b_SpaceWire_Interface_Enable_Control(alt_u8 uc_RegisterOperation, alt_u32 ul_EnableMask){

		bool bSuccess = FALSE;

		const alt_u32 ul_spwc_mask = SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_RX_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK;
		if ((ul_EnableMask & ul_spwc_mask) != 0){
			switch (uc_RegisterOperation){

				case SPWC_REG_CLEAR:
					ul_spwc_interface_control_status_register_value &= ~ul_EnableMask;
					SPWC_WRITE_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_interface_control_status_register_value);
					bSuccess = TRUE;
				break;

				case SPWC_REG_SET:
					ul_spwc_interface_control_status_register_value |= ul_EnableMask;
					SPWC_WRITE_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_interface_control_status_register_value);
					bSuccess = TRUE;
				break;

			}
		}

		return bSuccess;
	}

	bool b_SpaceWire_Interface_Mode_Control(alt_u8 uc_InterfaceMode){

		bool bSuccess = FALSE;

		switch (uc_InterfaceMode){

			case SPWC_INTERFACE_NORMAL_MODE:
				ul_spwc_interface_control_status_register_value &= ~((alt_u32)SPWC_LOOPBACK_MODE_CONTROL_BIT_MASK);
				SPWC_WRITE_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_interface_control_status_register_value);
				bSuccess = TRUE;
			break;

			case SPWC_INTERFACE_LOOPBACK_MODE:
				ul_spwc_interface_control_status_register_value |= (alt_u32)SPWC_LOOPBACK_MODE_CONTROL_BIT_MASK;
				SPWC_WRITE_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_interface_control_status_register_value);
				bSuccess = TRUE;
			break;

		}

		return bSuccess;
	}

	void v_SpaceWire_Interface_Force_Reset(void){

		SPWC_WRITE_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_interface_control_status_register_value | SPWC_CODEC_FORCE_RESET_CONTROL_BIT_MASK);

	}

	bool v_SpaceWire_Interface_Interrupts_Enable_Control(alt_u8 uc_RegisterOperation, alt_u32 ul_InterruptMask){

		bool bSuccess = FALSE;

		const alt_u32 ul_spwc_mask = SPWC_LINK_ERROR_INTERRUPT_ENABLE_BIT_MASK | SPWC_TIMECODE_RECEIVED_INTERRUPT_ENABLE_BIT_MASK | SPWC_LINK_RUNNING_INTERRUPT_ENABLE_BIT_MASK;
		if ((ul_InterruptMask & ul_spwc_mask) != 0){
			switch (uc_RegisterOperation){

				case SPWC_REG_CLEAR:
					ul_spwc_interface_control_status_register_value &= ~ul_InterruptMask;
					SPWC_WRITE_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_interface_control_status_register_value);
					bSuccess = TRUE;
				break;

				case SPWC_REG_SET:
					ul_spwc_interface_control_status_register_value |= ul_InterruptMask;
					SPWC_WRITE_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_interface_control_status_register_value);
					bSuccess = TRUE;
				break;

			}
		}

		return bSuccess;
	}

	alt_u32 ul_SpaceWire_Interface_Interrupts_Flags_Read(void){

		const alt_u32 ul_spwc_mask = SPWC_LINK_ERROR_INTERRUPT_FLAG_MASK | SPWC_TIMECODE_RECEIVED_INTERRUPT_FLAG_MASK | SPWC_LINK_RUNNING_INTERRUPT_FLAG_MASK;
		alt_u32 ul_spwc_interrupts_flags_value = SPWC_READ_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS) & ul_spwc_mask;

		return ul_spwc_interrupts_flags_value;
	}

	void v_SpaceWire_Interface_Interrupts_Flags_Clear(alt_u32 ul_InterruptMask){

		const alt_u32 ul_spwc_mask = SPWC_LINK_ERROR_INTERRUPT_FLAG_MASK | SPWC_TIMECODE_RECEIVED_INTERRUPT_FLAG_MASK | SPWC_LINK_RUNNING_INTERRUPT_FLAG_MASK;
		SPWC_WRITE_REG32(SPWC_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, (ul_spwc_interface_control_status_register_value | ul_spwc_mask));

	}

	bool v_SpaceWire_Interface_Link_Control(alt_u8 uc_RegisterOperation, alt_u32 ul_ControlMask){

		bool bSuccess = FALSE;

		const alt_u32 ul_spwc_mask = SPWC_AUTOSTART_CONTROL_BIT_MASK | SPWC_LINK_START_CONTROL_BIT_MASK | SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK;
		if ((ul_ControlMask & ul_spwc_mask) != 0){
			switch (uc_RegisterOperation){

				case SPWC_REG_CLEAR:
					ul_spwc_spacewire_link_control_status_register_value &= ~ul_ControlMask;
					SPWC_WRITE_REG32(SPWC_SPACEWIRE_LINK_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_spacewire_link_control_status_register_value);
					bSuccess = TRUE;
				break;

				case SPWC_REG_SET:
					ul_spwc_spacewire_link_control_status_register_value |= ul_ControlMask;
					SPWC_WRITE_REG32(SPWC_SPACEWIRE_LINK_CONTROL_STATUS_REGISTER_ADDRESS, ul_spwc_spacewire_link_control_status_register_value);
					bSuccess = TRUE;
				break;

			}
		}

		return bSuccess;
	}

	alt_u32 ul_SpaceWire_Interface_Link_Error_Read(void){

		const alt_u32 ul_spwc_mask = SPWC_LINK_DISCONNECT_ERROR_BIT_MASK | SPWC_LINK_PARITY_ERROR_BIT_MASK | SPWC_LINK_ESCAPE_ERROR_BIT_MASK | SPWC_LINK_CREDIT_ERROR_BIT_MASK;
		alt_u32 ul_spwc_link_error_value = SPWC_READ_REG32(SPWC_SPACEWIRE_LINK_CONTROL_STATUS_REGISTER_ADDRESS) & ul_spwc_mask;

		return ul_spwc_link_error_value;
	}

	alt_u32 ul_SpaceWire_Interface_Link_Status_Read(void){

		const alt_u32 ul_spwc_mask = SPWC_LINK_STARTED_STATUS_BIT_MASK | SPWC_LINK_CONNECTING_STATUS_BIT_MASK | SPWC_LINK_RUNNING_STATUS_BIT_MASK;
		alt_u32 ul_spwc_link_status_value = SPWC_READ_REG32(SPWC_SPACEWIRE_LINK_CONTROL_STATUS_REGISTER_ADDRESS) & ul_spwc_mask;

		return ul_spwc_link_status_value;
	}

	void v_SpaceWire_Interface_Send_TimeCode(alt_u8 TimeCode){

		const alt_u32 ul_spwc_mask = (((alt_u32)TimeCode) << 1) | SPWC_TX_TIMECODE_CONTROL_BIT_MASK;
		SPWC_WRITE_REG32(SPWC_TIMECODE_CONTROL_REGISTER_ADDRESS, ul_spwc_mask);

	}

	alt_u16 ui_SpaceWire_Interface_Get_TimeCode(void){

		alt_u16 ui_timecode_value = (alt_u16)(SPWC_READ_REG32(SPWC_SPACEWIRE_LINK_CONTROL_STATUS_REGISTER_ADDRESS) >> 16);

		return ui_timecode_value;
	}
