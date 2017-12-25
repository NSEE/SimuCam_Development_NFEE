/*
 * tran.c
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

	#include "tran.h"

	alt_u32 ul_tran_a_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_b_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_c_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_d_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_e_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_f_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_g_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_h_interface_control_status_register_value = 0x00000000;

	void TRAN_WRITE_REG32(char c_SpwID, alt_u8 RegisterOffset, alt_u32 RegisterValue){
		switch (c_SpwID) {
			case 'A':
				alt_u32 *pTranAddr = TRAN_A_BASE;
			break;
			case 'B':
				alt_u32 *pTranAddr = TRAN_B_BASE;
			break;
			case 'C':
				alt_u32 *pTranAddr = TRAN_C_BASE;
			break;
			case 'D':
				alt_u32 *pTranAddr = TRAN_D_BASE;
			break;
			case 'E':
				alt_u32 *pTranAddr = TRAN_E_BASE;
			break;
			case 'F':
				alt_u32 *pTranAddr = TRAN_F_BASE;
			break;
			case 'G':
				alt_u32 *pTranAddr = TRAN_G_BASE;
			break;
			case 'H':
				alt_u32 *pTranAddr = TRAN_H_BASE;
			break;
			default:
				alt_u32 *pTranAddr = TRAN_A_BASE;
		}
		*(pTranAddr + (alt_u32)RegisterOffset) = (alt_u32) RegisterValue;
	}

	alt_u32 TRAN_READ_REG32(char c_SpwID, alt_u8 RegisterOffset){
		alt_u32 RegisterValue = 0;
		switch (c_SpwID) {
			case 'A':
				alt_u32 *pTranAddr = TRAN_A_BASE;
			break;
			case 'B':
				alt_u32 *pTranAddr = TRAN_B_BASE;
			break;
			case 'C':
				alt_u32 *pTranAddr = TRAN_C_BASE;
			break;
			case 'D':
				alt_u32 *pTranAddr = TRAN_D_BASE;
			break;
			case 'E':
				alt_u32 *pTranAddr = TRAN_E_BASE;
			break;
			case 'F':
				alt_u32 *pTranAddr = TRAN_F_BASE;
			break;
			case 'G':
				alt_u32 *pTranAddr = TRAN_G_BASE;
			break;
			case 'H':
				alt_u32 *pTranAddr = TRAN_H_BASE;
			break;
			default:
				alt_u32 *pTranAddr = TRAN_A_BASE;
		}
		RegisterValue = *(pTranAddr + (alt_u32)RegisterOffset);
		return RegisterValue;
	}

	bool b_Transparent_Interface_Write_Register(char c_SpwID, alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue){

		bool bSuccess = FALSE;

		if (uc_RegisterAddress <= 0x02) {
			TRAN_WRITE_REG32(c_SpwID, uc_RegisterAddress, ul_RegisterValue);
			bSuccess = TRUE;
		}

		return bSuccess;
	}

	alt_u32 ul_Transparent_Interface_Read_Register(char c_SpwID, alt_u8 uc_RegisterAddress){

		alt_u32 ul_RegisterValue = 0;

		if (uc_RegisterAddress <= 0x02) {
			ul_RegisterValue = TRAN_READ_REG32(c_SpwID, uc_RegisterAddress);
		}

		return ul_RegisterValue;
	}

	bool v_Transparent_Interface_Enable_Control(char c_SpwID, alt_u8 uc_RegisterOperation, alt_u32 ul_EnableMask){

		bool bSuccess = FALSE;

		const alt_u32 ul_tran_mask = TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_RX_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK;
		switch (c_SpwID) {
			case 'A':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'B':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_b_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'C':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_c_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'D':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_d_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'E':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_e_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'F':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_f_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'G':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_g_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'H':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_h_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			default:
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
		}
		if ((bSuccess == TRUE) && ((ul_EnableMask & ul_tran_mask) != 0)){
			switch (uc_RegisterOperation){
			
				case TRAN_REG_CLEAR:
					*ul_tran_interface_control_status_register_value &= ~ul_EnableMask;
					TRAN_WRITE_REG32(c_SpwID, TRAN_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, *ul_tran_interface_control_status_register_value);
					bSuccess = TRUE;
				break;

				case TRAN_REG_SET:
					*ul_tran_interface_control_status_register_value |= ul_EnableMask;
					TRAN_WRITE_REG32(c_SpwID, TRAN_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, *ul_tran_interface_control_status_register_value);
					bSuccess = TRUE;
				break;

			}
		} else {
			bSuccess = FALSE;
		}

		return bSuccess;
	}

	bool v_Transparent_Interface_Interrupts_Enable_Control(char c_SpwID, alt_u8 uc_RegisterOperation, alt_u32 ul_InterruptMask){

		bool bSuccess = FALSE;

		const alt_u32 ul_tran_mask = TRAN_INTERFACE_ERROR_INTERRUPT_ENABLE_BIT_MASK | TRAN_DATA_RECEIVED_INTERRUPT_ENABLE_BIT_MASK | TRAN_RX_FIFO_FULL_INTERRUPT_ENABLE_BIT_MASK | TRAN_TX_FIFO_EMPTY_INTERRUPT_ENABLE_BIT_MASK;
		switch (c_SpwID) {
			case 'A':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'B':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_b_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'C':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_c_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'D':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_d_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'E':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_e_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'F':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_f_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'G':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_g_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'H':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_h_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			default:
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
		}
		if ((bSuccess == TRUE) && ((ul_InterruptMask & ul_tran_mask) != 0)){
			switch (uc_RegisterOperation){

				case TRAN_REG_CLEAR:
					*ul_tran_interface_control_status_register_value &= ~ul_InterruptMask;
					TRAN_WRITE_REG32(c_SpwID, TRAN_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, *ul_tran_interface_control_status_register_value);
					bSuccess = TRUE;
				break;

				case TRAN_REG_SET:
					*ul_tran_interface_control_status_register_value |= ul_InterruptMask;
					TRAN_WRITE_REG32(c_SpwID, TRAN_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, *ul_tran_interface_control_status_register_value);
					bSuccess = TRUE;
				break;

			}
		} else {
			bSuccess = FALSE;
		}

		return bSuccess;
	}

	alt_u32 ul_Transparent_Interface_Interrupts_Flags_Read(char c_SpwID){

		const alt_u32 ul_tran_mask = TRAN_INTERFACE_ERROR_INTERRUPT_FLAG_MASK | TRAN_DATA_RECEIVED_INTERRUPT_FLAG_MASK | TRAN_RX_FIFO_FULL_INTERRUPT_FLAG_MASK | TRAN_TX_FIFO_EMPTY_INTERRUPT_FLAG_MASK;
		alt_u32 ul_tran_interrupts_flags_value = TRAN_READ_REG32(c_SpwID, TRAN_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS) & ul_tran_mask;

		return ul_tran_interrupts_flags_value;
	}

	void v_Transparent_Interface_Interrupts_Flags_Clear(char c_SpwID, alt_u32 ul_InterruptMask){

		const alt_u32 ul_tran_mask = TRAN_INTERFACE_ERROR_INTERRUPT_FLAG_MASK | TRAN_DATA_RECEIVED_INTERRUPT_FLAG_MASK | TRAN_RX_FIFO_FULL_INTERRUPT_FLAG_MASK | TRAN_TX_FIFO_EMPTY_INTERRUPT_FLAG_MASK;
		switch (c_SpwID) {
			case 'A':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'B':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_b_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'C':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_c_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'D':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_d_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'E':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_e_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'F':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_f_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'G':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_g_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'H':
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_h_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			default:
				alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
		}
		if ((bSuccess == TRUE) && ((ul_InterruptMask & ul_tran_mask) != 0)){
			TRAN_WRITE_REG32(c_SpwID, TRAN_INTERFACE_CONTROL_STATUS_REGISTER_ADDRESS, (*ul_tran_interface_control_status_register_value | ul_InterruptMask));
		} else {
			bSuccess = FALSE;
		}
	}

	void v_Transparent_Interface_RX_FIFO_Reset(char c_SpwID){

		TRAN_WRITE_REG32(c_SpwID, TRAN_RX_MODE_CONTROL_REGISTER_ADDRESS, (alt_u32)TRAN_RX_FIFO_RESET_CONTROL_BIT_MASK);

	}

	alt_u32 ul_Transparent_Interface_RX_FIFO_Status_Read(char c_SpwID){

		const alt_u32 ul_tran_mask = TRAN_RX_FIFO_EMPTY_STATUS_BIT_MASK | TRAN_RX_FIFO_FULL_STATUS_BIT_MASK;
		alt_u32 ul_tran_rx_fifo_status_value = TRAN_READ_REG32(c_SpwID, TRAN_RX_MODE_CONTROL_REGISTER_ADDRESS) & ul_tran_mask;

		return ul_tran_rx_fifo_status_value;
	}

	void v_Transparent_Interface_TX_FIFO_Reset(char c_SpwID){

		TRAN_WRITE_REG32(c_SpwID, TRAN_TX_MODE_CONTROL_REGISTER_ADDRESS, (alt_u32)TRAN_TX_FIFO_RESET_CONTROL_BIT_MASK);

	}

	alt_u32 ul_Transparent_Interface_TX_FIFO_Status_Read(char c_SpwID){

		const alt_u32 ul_tran_mask = TRAN_TX_FIFO_EMPTY_STATUS_BIT_MASK | TRAN_TX_FIFO_FULL_STATUS_BIT_MASK;
		alt_u32 ul_tran_tx_fifo_status_value = TRAN_READ_REG32(c_SpwID, TRAN_TX_MODE_CONTROL_REGISTER_ADDRESS) & ul_tran_mask;

		return ul_tran_tx_fifo_status_value;
	}
