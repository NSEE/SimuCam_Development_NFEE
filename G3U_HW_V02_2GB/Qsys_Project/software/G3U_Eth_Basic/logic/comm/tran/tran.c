/*
 * tran.c
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

	#include "tran.h"

	#incude "rtos_tasks.h";
	
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
	
	bool b_Transparent_Interface_Send_SpaceWire_Data(char c_SpwID, alt_u8 *data_buffer, alt_u16 data_size){
		
		bool bSuccess = FALSE;
		
		alt_u16 *memory_location;
		alt_u64 memdata_addr;
		alt_u64 spwdata_addr;
		t_DMA_Transfer spw_data_transfer;
		alt_u16 cnt = 0;
		
		/* Initiate the Channel Memory Location for the Transparent Interface */
		switch (c_SpwID) {
			case 'A':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE);
				spwdata_addr = (alt_u64)(TRAN_A_SPWDATA_BASE);
				bSuccess = TRUE;
			break;
			case 'B':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_B_SPWDATA_BASE);				
				bSuccess = TRUE;
			break;
			case 'C':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 2*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 2*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_C_SPWDATA_BASE);
				bSuccess = TRUE;
			break;
			case 'D':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 3*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 3*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_D_SPWDATA_BASE);
				bSuccess = TRUE;
			break;
			case 'E':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 4*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 4*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_E_SPWDATA_BASE);
				bSuccess = TRUE;
			break;
			case 'F':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 5*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 5*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_F_SPWDATA_BASE);
				bSuccess = TRUE;
			break;
			case 'G':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 6*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 6*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_G_SPWDATA_BASE);
				bSuccess = TRUE;
			break;
			case 'H':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 7*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 7*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_H_SPWDATA_BASE);
				bSuccess = TRUE;
			break;
		}

		/* Check if the TX Buffer has enough space for the data */
		/* Each word in TX buffer can hold 4 bytes of data, but a space for the EOP must be left*/
		if ((bSuccess) && (uc_Transparent_Interface_TX_FIFO_Status_Used(c_SpwID) >= ((data_size >> 2) - 1))) {
			/* Write the data_buffer data in the correct format to be send by the Transparent Interface in the Channel Memory Location */
			for (cnt = 0; cnt < data_size; cnt++){
				memory_location[cnt] = (alt_u16)data_buffer[cnt];
			}
			/* Append an EOP to the end of the data in the Channel Memory Location */
			memory_location[data_size] = 0x0100 | (alt_u16)data_buffer[data_size];
			
			/* Make sure that the data alingment in the DDR memory is correct (4 data in each word) */
			cnt = data_size;
			while (cnt & 0x0003) {
				cnt++;
				memory_location[cnt] = 0xFFFF;
			}
			
			/* Generate the DMA transfer parameters */
			spw_data_transfer.read_addr = memdata_addr;
			spw_data_transfer.write_addr = spwdata_addr;
			spw_data_transfer.transfer_size_bytes = (alt_u32)(cnt < 1);
			
			/* Queque the DMA transfer */
			
		} else {
			bSuccess = FALSE;
		}
		
		return bSuccess;
	}
	
	alt_u16 ui_Transparent_Interface_Get_SpaceWire_Data(char c_SpwID, alt_u8 *data_buffer){
		
		alt_u16 ui_rx_data_size = 0;
		
		alt_u16 *memory_location;
		alt_u64 memdata_addr;
		alt_u64 spwdata_addr;
		t_DMA_Transfer spw_data_transfer;
		alt_u16 cnt = 0;
		alt_u16 rx_buffer_data_size = 0;
		
		/* Initiate the Channel Memory Location for the Transparent Interface */
		switch (c_SpwID) {
			case 'A':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE);
				spwdata_addr = (alt_u64)(TRAN_A_SPWDATA_BASE);
				bSuccess = TRUE;
				rx_buffer_data_size = 0xFFFF;
			break;
			case 'B':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_B_SPWDATA_BASE);
				rx_buffer_data_size = 0xFFFF;
			break;
			case 'C':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 2*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 2*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_C_SPWDATA_BASE);
				rx_buffer_data_size = 0xFFFF;
			break;
			case 'D':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 3*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 3*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_D_SPWDATA_BASE);
				rx_buffer_data_size = 0xFFFF;
			break;
			case 'E':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 4*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 4*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_E_SPWDATA_BASE);
				rx_buffer_data_size = 0xFFFF;
			break;
			case 'F':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 5*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 5*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_F_SPWDATA_BASE);
				rx_buffer_data_size = 0xFFFF;
			break;
			case 'G':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 6*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 6*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_G_SPWDATA_BASE);
				rx_buffer_data_size = 0xFFFF;
			break;
			case 'H':
				memory_location = (alt_u32)(TRAN_MEM_LOCATION_BASE + 7*TRAN_DATA_OFFSET);
				memdata_addr = (alt_u64)(TRAN_M1_MEMDATA_BASE + 7*TRAN_DATA_OFFSET);
				spwdata_addr = (alt_u64)(TRAN_H_SPWDATA_BASE);
				rx_buffer_data_size = 0xFFFF;
			break;
		
		if (rx_buffer_data_size = 0xFFFF) {
			/* Check the amount of data in the RX Buffer*/
			rx_buffer_data_size = (alt_u16)(uc_Transparent_Interface_TX_FIFO_Status_Used(c_SpwID) << 2);
			if (rx_buffer_data_size > 0) {
				/* Transfer the available data to the Channel Memory Location */
				/* Generate the DMA transfer parameters */
				spw_data_transfer.read_addr = spwdata_addr;
				spw_data_transfer.write_addr = memdata_addr;
				spw_data_transfer.transfer_size_bytes = (alt_u32)(rx_buffer_data_size << 1);
				/* Queque the DMA transfer */
				
				/* Convert all the available data in the Channel Memory Location to the data_buffer */
				for (cnt = 0; cnt < rx_buffer_data_size; cnt++) {
					/* check if the data is not an eop or invalid */
					if (!((memory_location[cnt] & 0x0100) || (memory_location[cnt] = 0xFFFF))) {
						data_buffer[ui_rx_data_size] = (alt_u8)(0x00FF & memory_location[cnt]);
						ui_rx_data_size++;
					}
				}
			}
		}
	
		return ui_rx_data_size;
	}
	