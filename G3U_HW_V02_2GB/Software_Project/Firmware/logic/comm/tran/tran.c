/*
 * tran.c
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

	#include "tran.h"

	#include "../../../rtos/rtos_tasks.h"
	#include "../../dma/dma.h"
	
	alt_u32 ul_tran_a_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_b_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_c_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_d_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_e_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_f_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_g_interface_control_status_register_value = 0x00000000;
	alt_u32 ul_tran_h_interface_control_status_register_value = 0x00000000;

	void TRAN_WRITE_REG32(char c_SpwID, alt_u8 RegisterOffset, alt_u32 RegisterValue){
		alt_u32 *pTranAddr = (alt_u32 *)TRAN_A_BASE;
		switch (c_SpwID) {
			case 'A':
				pTranAddr = (alt_u32 *)TRAN_A_BASE;
			break;
			case 'B':
				pTranAddr = (alt_u32 *)TRAN_B_BASE;
			break;
			case 'C':
				pTranAddr = (alt_u32 *)TRAN_C_BASE;
			break;
			case 'D':
				pTranAddr = (alt_u32 *)TRAN_D_BASE;
			break;
			case 'E':
				pTranAddr = (alt_u32 *)TRAN_E_BASE;
			break;
			case 'F':
				pTranAddr = (alt_u32 *)TRAN_F_BASE;
			break;
			case 'G':
				pTranAddr = (alt_u32 *)TRAN_G_BASE;
			break;
			case 'H':
				pTranAddr = (alt_u32 *)TRAN_H_BASE;
			break;
		}
		*(pTranAddr + (alt_u32)RegisterOffset) = (alt_u32) RegisterValue;
	}

	alt_u32 TRAN_READ_REG32(char c_SpwID, alt_u8 RegisterOffset){
		alt_u32 RegisterValue = 0;
		alt_u32 *pTranAddr = (alt_u32 *)TRAN_A_BASE;
		switch (c_SpwID) {
			case 'A':
				pTranAddr = (alt_u32 *)TRAN_A_BASE;
			break;
			case 'B':
				pTranAddr = (alt_u32 *)TRAN_B_BASE;
			break;
			case 'C':
				pTranAddr = (alt_u32 *)TRAN_C_BASE;
			break;
			case 'D':
				pTranAddr = (alt_u32 *)TRAN_D_BASE;
			break;
			case 'E':
				pTranAddr = (alt_u32 *)TRAN_E_BASE;
			break;
			case 'F':
				pTranAddr = (alt_u32 *)TRAN_F_BASE;
			break;
			case 'G':
				pTranAddr = (alt_u32 *)TRAN_G_BASE;
			break;
			case 'H':
				pTranAddr = (alt_u32 *)TRAN_H_BASE;
			break;
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
		alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
		switch (c_SpwID) {
			case 'A':
				ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'B':
				ul_tran_interface_control_status_register_value = &ul_tran_b_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'C':
				ul_tran_interface_control_status_register_value = &ul_tran_c_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'D':
				ul_tran_interface_control_status_register_value = &ul_tran_d_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'E':
				ul_tran_interface_control_status_register_value = &ul_tran_e_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'F':
				ul_tran_interface_control_status_register_value = &ul_tran_f_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'G':
				ul_tran_interface_control_status_register_value = &ul_tran_g_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'H':
				ul_tran_interface_control_status_register_value = &ul_tran_h_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
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
		alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
		switch (c_SpwID) {
			case 'A':
				ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'B':
				ul_tran_interface_control_status_register_value = &ul_tran_b_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'C':
				ul_tran_interface_control_status_register_value = &ul_tran_c_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'D':
				ul_tran_interface_control_status_register_value = &ul_tran_d_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'E':
				ul_tran_interface_control_status_register_value = &ul_tran_e_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'F':
				ul_tran_interface_control_status_register_value = &ul_tran_f_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'G':
				ul_tran_interface_control_status_register_value = &ul_tran_g_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'H':
				ul_tran_interface_control_status_register_value = &ul_tran_h_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
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
		bool bSuccess = FALSE;

		const alt_u32 ul_tran_mask = TRAN_INTERFACE_ERROR_INTERRUPT_FLAG_MASK | TRAN_DATA_RECEIVED_INTERRUPT_FLAG_MASK | TRAN_RX_FIFO_FULL_INTERRUPT_FLAG_MASK | TRAN_TX_FIFO_EMPTY_INTERRUPT_FLAG_MASK;
		alt_u32 *ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
		switch (c_SpwID) {
			case 'A':
				ul_tran_interface_control_status_register_value = &ul_tran_a_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'B':
				ul_tran_interface_control_status_register_value = &ul_tran_b_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'C':
				ul_tran_interface_control_status_register_value = &ul_tran_c_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'D':
				ul_tran_interface_control_status_register_value = &ul_tran_d_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'E':
				ul_tran_interface_control_status_register_value = &ul_tran_e_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'F':
				ul_tran_interface_control_status_register_value = &ul_tran_f_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'G':
				ul_tran_interface_control_status_register_value = &ul_tran_g_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
			case 'H':
				ul_tran_interface_control_status_register_value = &ul_tran_h_interface_control_status_register_value;
				bSuccess = TRUE;
			break;
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

		const alt_u32 ul_tran_mask = TRAN_RX_FIFO_USED_SPACE_VALUE_MASK | TRAN_RX_FIFO_EMPTY_STATUS_BIT_MASK | TRAN_RX_FIFO_FULL_STATUS_BIT_MASK;
		alt_u32 ul_tran_rx_fifo_status_value = TRAN_READ_REG32(c_SpwID, TRAN_RX_MODE_CONTROL_REGISTER_ADDRESS) & ul_tran_mask;

		return ul_tran_rx_fifo_status_value;
	}

	bool b_Transparent_Interface_RX_FIFO_Status_Empty(char c_SpwID){
		
		bool b_rx_fifo_empty = FALSE;
		
		if (TRAN_READ_REG32(c_SpwID, TRAN_RX_MODE_CONTROL_REGISTER_ADDRESS) & TRAN_RX_FIFO_EMPTY_STATUS_BIT_MASK) {
			b_rx_fifo_empty = TRUE;
		}
		
		return b_rx_fifo_empty;		
	}
	
	bool b_Transparent_Interface_RX_FIFO_Status_Full(char c_SpwID){
		
		bool b_rx_fifo_full = FALSE;
		
		if (TRAN_READ_REG32(c_SpwID, TRAN_RX_MODE_CONTROL_REGISTER_ADDRESS) & TRAN_RX_FIFO_FULL_STATUS_BIT_MASK) {
			b_rx_fifo_full = TRUE;
		}
		
		return b_rx_fifo_full;
	}

	alt_u8 uc_Transparent_Interface_RX_FIFO_Status_Used(char c_SpwID){
		
		alt_u8 uc_rx_fifo_used = 0;
		
		uc_rx_fifo_used = (alt_u8)((TRAN_READ_REG32(c_SpwID, TRAN_RX_MODE_CONTROL_REGISTER_ADDRESS) & TRAN_RX_FIFO_USED_SPACE_VALUE_MASK) >> 3);
		
		return uc_rx_fifo_used;
	}
	
	
	void v_Transparent_Interface_TX_FIFO_Reset(char c_SpwID){

		TRAN_WRITE_REG32(c_SpwID, TRAN_TX_MODE_CONTROL_REGISTER_ADDRESS, (alt_u32)TRAN_TX_FIFO_RESET_CONTROL_BIT_MASK);

	}

	alt_u32 ul_Transparent_Interface_TX_FIFO_Status_Read(char c_SpwID){

		const alt_u32 ul_tran_mask = TRAN_TX_FIFO_USED_SPACE_VALUE_MASK | TRAN_TX_FIFO_EMPTY_STATUS_BIT_MASK | TRAN_TX_FIFO_FULL_STATUS_BIT_MASK;
		alt_u32 ul_tran_tx_fifo_status_value = TRAN_READ_REG32(c_SpwID, TRAN_TX_MODE_CONTROL_REGISTER_ADDRESS) & ul_tran_mask;

		return ul_tran_tx_fifo_status_value;
	}

	bool b_Transparent_Interface_TX_FIFO_Status_Full(char c_SpwID){
		
		bool b_tx_fifo_empty = FALSE;
		
		if (TRAN_READ_REG32(c_SpwID, TRAN_TX_MODE_CONTROL_REGISTER_ADDRESS) & TRAN_TX_FIFO_EMPTY_STATUS_BIT_MASK) {
			b_tx_fifo_empty = TRUE;
		}
		
		return b_tx_fifo_empty;		
	}
	
	bool b_Transparent_Interface_TX_FIFO_Status_Empty(char c_SpwID){
		
		bool b_tx_fifo_full = FALSE;
		
		if (TRAN_READ_REG32(c_SpwID, TRAN_TX_MODE_CONTROL_REGISTER_ADDRESS) & TRAN_TX_FIFO_FULL_STATUS_BIT_MASK) {
			b_tx_fifo_full = TRUE;
		}
		
		return b_tx_fifo_full;
	}
	
	alt_u8 uc_Transparent_Interface_TX_FIFO_Status_Used(char c_SpwID){
		
		alt_u8 uc_tx_fifo_used = 0;
		
		uc_tx_fifo_used = (alt_u8)((TRAN_READ_REG32(c_SpwID, TRAN_TX_MODE_CONTROL_REGISTER_ADDRESS) & TRAN_TX_FIFO_USED_SPACE_VALUE_MASK) >> 3);
		
		return uc_tx_fifo_used;
	}
	
	bool b_Transparent_Interface_Switch_Channel(char c_SpwID){

		bool bSuccess;
		alt_u32 *pTranAddr = DDR2_ADDRESS_SPAN_EXTENDER_CNTL_BASE;

		  bSuccess = TRUE;
		  switch (c_SpwID) {
			  case 'A':
				*(pTranAddr)     = (alt_u32)( 0x00000000FFFFFFFF & TRAN_A_CHANNEL_WINDOWED_OFFSET);
				*(pTranAddr + 1) = (alt_u32)((0xFFFFFFFF00000000 & TRAN_A_CHANNEL_WINDOWED_OFFSET) >> 32);
			  break;
			  case 'B':
					*(pTranAddr)     = (alt_u32)( 0x00000000FFFFFFFF & TRAN_B_CHANNEL_WINDOWED_OFFSET);
					*(pTranAddr + 1) = (alt_u32)((0xFFFFFFFF00000000 & TRAN_B_CHANNEL_WINDOWED_OFFSET) >> 32);
				  break;
			  case 'C':
					*(pTranAddr)     = (alt_u32)( 0x00000000FFFFFFFF & TRAN_C_CHANNEL_WINDOWED_OFFSET);
					*(pTranAddr + 1) = (alt_u32)((0xFFFFFFFF00000000 & TRAN_C_CHANNEL_WINDOWED_OFFSET) >> 32);
				  break;
			  case 'D':
					*(pTranAddr)     = (alt_u32)( 0x00000000FFFFFFFF & TRAN_E_CHANNEL_WINDOWED_OFFSET);
					*(pTranAddr + 1) = (alt_u32)((0xFFFFFFFF00000000 & TRAN_E_CHANNEL_WINDOWED_OFFSET) >> 32);
				  break;
			  case 'E':
					*(pTranAddr)     = (alt_u32)( 0x00000000FFFFFFFF & TRAN_D_CHANNEL_WINDOWED_OFFSET);
					*(pTranAddr + 1) = (alt_u32)((0xFFFFFFFF00000000 & TRAN_D_CHANNEL_WINDOWED_OFFSET) >> 32);
				  break;
			  case 'F':
					*(pTranAddr)     = (alt_u32)( 0x00000000FFFFFFFF & TRAN_F_CHANNEL_WINDOWED_OFFSET);
					*(pTranAddr + 1) = (alt_u32)((0xFFFFFFFF00000000 & TRAN_F_CHANNEL_WINDOWED_OFFSET) >> 32);
				  break;
			  case 'G':
					*(pTranAddr)     = (alt_u32)( 0x00000000FFFFFFFF & TRAN_G_CHANNEL_WINDOWED_OFFSET);
					*(pTranAddr + 1) = (alt_u32)((0xFFFFFFFF00000000 & TRAN_G_CHANNEL_WINDOWED_OFFSET) >> 32);
				  break;
			  case 'H':
					*(pTranAddr)     = (alt_u32)( 0x00000000FFFFFFFF & TRAN_H_CHANNEL_WINDOWED_OFFSET);
					*(pTranAddr + 1) = (alt_u32)((0xFFFFFFFF00000000 & TRAN_H_CHANNEL_WINDOWED_OFFSET) >> 32);
				  break;
			  default:
				  bSuccess = FALSE;
				  printf("SpW Channel not identified!! Error switching channels!! \n");
		  }

		  return bSuccess;
	}


	bool b_Transparent_Interface_Send_SpaceWire_Data(char c_SpwID, alt_u8 *data_buffer, alt_u16 data_size){
		
		bool bSuccess = FALSE;
		
		alt_u32 *memory_location = DDR2_ADDRESS_SPAN_EXTENDER_WINDOWED_SLAVE_BASE;
		printf("memory_location = %u \n", memory_location);
		memory_location += (TRAN_BURST_REGISTERS_OFFSET + TRAN_TX_REGISTER_OFFSET)*2;
		printf("memory_location = %u \n", memory_location);

		alt_u16 cnt = 0;
		alt_u8 resto = 0;
		
		/* Initiate the Channel Memory Location for the Transparent Interface */
		if ((c_SpwID >= 'A') && (c_SpwID <= 'H')) {
			b_Transparent_Interface_Switch_Channel(c_SpwID);
			bSuccess          = TRUE;
		}

		/* Check if the TX Buffer has enough space for the data */
		/* Each word in TX buffer can hold 4 bytes of data, but a space for the EOP must be left*/
		if ((bSuccess) && (256 - (uc_Transparent_Interface_TX_FIFO_Status_Used(c_SpwID)) >= ((data_size >> 2) + 1))) {
			/* Write the data_buffer data in the correct format to be send by the Transparent Interface in the Channel Memory Location */
			for (cnt = 0; cnt < data_size; cnt++){
				*memory_location = (alt_u64)(0xFFFFFFFFFFFF0000 | data_buffer[cnt]);
			}
			/* Append an EOP to the end of the data in the Channel Memory Location */
			*memory_location = (alt_u64)(0xFFFFFFFFFFFF0000 | 0x0100 | (alt_u16)data_buffer[data_size]);
			
		} else {
			bSuccess = FALSE;
		}
		
		return bSuccess;
	}
	
	alt_u16 ui_Transparent_Interface_Get_SpaceWire_Data(char c_SpwID, alt_u8 *data_buffer){
		
		alt_u16 ui_rx_data_size = 0;
		
		alt_u64 *memory_location = 0;
		memory_location += TRAN_BURST_REGISTERS_OFFSET + TRAN_RX_REGISTER_OFFSET;

		alt_u16 cnt = 0;
		alt_u16 rx_buffer_data_size = 0;
		alt_u64 rx_data = 0;
		alt_u16 rx_data_buffer[4] = {0,0,0,0};

		/* Initiate the Channel Memory Location for the Transparent Interface */
		if ((c_SpwID >= 'A') && (c_SpwID <= 'H')) {
			b_Transparent_Interface_Switch_Channel(c_SpwID);
			rx_buffer_data_size = 0xFFFF;
		}
		
		if (0xFFFF == rx_buffer_data_size) {
			/* Check the amount of data in the RX Buffer*/
			rx_buffer_data_size = (alt_u16)(uc_Transparent_Interface_TX_FIFO_Status_Used(c_SpwID));
			if (rx_buffer_data_size > 0) {
				/* Transfer the available data to the Channel Memory Location */
				
				/* Convert all the available data in the Channel Memory Location to the data_buffer */
				for (cnt = 0; cnt < rx_buffer_data_size; cnt++) {

					rx_data = *memory_location;

					rx_data_buffer[0] = (alt_u16)(0x000000000000FFFF & rx_data);
					rx_data_buffer[1] = (alt_u16)((0x00000000FFFF0000 & rx_data) >> 16);
					rx_data_buffer[2] = (alt_u16)((0x0000FFFF00000000 & rx_data) >> 32);
					rx_data_buffer[3] = (alt_u16)((0xFFFF000000000000 & rx_data) >> 48);

					/* check if the data is not an eop or invalid */
					if (!((rx_data_buffer[0] & 0x0100) || (rx_data_buffer[0] == 0xFFFF))) {
						data_buffer[ui_rx_data_size] = (alt_u8)(0x00FF & rx_data_buffer[0]);
						ui_rx_data_size++;
					}

					/* check if the data is not an eop or invalid */
					if (!((rx_data_buffer[1] & 0x0100) || (rx_data_buffer[1] == 0xFFFF))) {
						data_buffer[ui_rx_data_size] = (alt_u8)(0x00FF & rx_data_buffer[1]);
						ui_rx_data_size++;
					}

					/* check if the data is not an eop or invalid */
					if (!((rx_data_buffer[2] & 0x0100) || (rx_data_buffer[2] == 0xFFFF))) {
						data_buffer[ui_rx_data_size] = (alt_u8)(0x00FF & rx_data_buffer[2]);
						ui_rx_data_size++;
					}

					/* check if the data is not an eop or invalid */
					if (!((rx_data_buffer[3] & 0x0100) || (rx_data_buffer[3] == 0xFFFF))) {
						data_buffer[ui_rx_data_size] = (alt_u8)(0x00FF & rx_data_buffer[3]);
						ui_rx_data_size++;
					}

				}
			} else {
				ui_rx_data_size = 0;
			}
		} else {
			ui_rx_data_size = 0;
		}
	
		return ui_rx_data_size;
	}
	
