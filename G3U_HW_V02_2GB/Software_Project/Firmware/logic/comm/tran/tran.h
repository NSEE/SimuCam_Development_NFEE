/*
 * tran.h
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

#ifndef TRAN_H_
#define TRAN_H_

	#include "system.h"
	#include "alt_types.h"
	
	#include "tran_registers.h"

	#define TRAN_A_BASE (COMMUNICATION_MODULE_A_BASE)
	#define TRAN_B_BASE (COMMUNICATION_MODULE_B_BASE)
	#define TRAN_C_BASE (COMMUNICATION_MODULE_C_BASE)
	#define TRAN_D_BASE (COMMUNICATION_MODULE_D_BASE)
	#define TRAN_E_BASE (COMMUNICATION_MODULE_E_BASE)
	#define TRAN_F_BASE (COMMUNICATION_MODULE_F_BASE)
	#define TRAN_G_BASE (COMMUNICATION_MODULE_G_BASE)
	#define TRAN_H_BASE (COMMUNICATION_MODULE_H_BASE)

	#define TRAN_MEM_LOCATION_BASE (DDR2_ADDRESS_SPAN_EXTENDER_WINDOWED_SLAVE_BASE)
	
	#define TRAN_A_SPWDATA_BASE 0x00000002E0000000
	#define TRAN_B_SPWDATA_BASE 0x00000002C0000000
	#define TRAN_C_SPWDATA_BASE 0x00000002A0000000
	#define TRAN_D_SPWDATA_BASE 0x0000000280000000
	#define TRAN_E_SPWDATA_BASE 0x0000000260000000
	#define TRAN_F_SPWDATA_BASE 0x0000000240000000
	#define TRAN_G_SPWDATA_BASE 0x0000000220000000
	#define TRAN_H_SPWDATA_BASE 0x0000000200000000

	#define	TRAN_A_CHANNEL_WINDOWED_OFFSET 0x00000001e0000000
	#define	TRAN_B_CHANNEL_WINDOWED_OFFSET 0x00000001c0000000
	#define	TRAN_C_CHANNEL_WINDOWED_OFFSET 0x00000001a0000000
	#define	TRAN_D_CHANNEL_WINDOWED_OFFSET 0x0000000180000000
	#define	TRAN_E_CHANNEL_WINDOWED_OFFSET 0x0000000160000000
	#define	TRAN_F_CHANNEL_WINDOWED_OFFSET 0x0000000140000000
	#define	TRAN_G_CHANNEL_WINDOWED_OFFSET 0x0000000120000000
	#define	TRAN_H_CHANNEL_WINDOWED_OFFSET 0x0000000100000000

	#define	TRAN_BURST_REGISTERS_OFFSET 32

	#define	TRAN_RX_REGISTER_OFFSET 0
	#define	TRAN_TX_REGISTER_OFFSET 1

	#define TRAN_M1_MEMDATA_BASE 0x0000000000000000
	#define TRAN_M2_MEMDATA_BASE 0x0000000080000000
	
	#define TRAN_DATA_OFFSET 1024
		
	typedef int bool;
	#define TRUE    1
	#define FALSE   0

	#define TRAN_REG_CLEAR 0
	#define TRAN_REG_SET   1

	bool b_Transparent_Interface_Write_Register(char c_SpwID, alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue);
	alt_u32 ul_Transparent_Interface_Read_Register(char c_SpwID, alt_u8 uc_RegisterAddress);
	bool v_Transparent_Interface_Enable_Control(char c_SpwID, alt_u8 uc_RegisterOperation, alt_u32 ul_EnableMask);
	bool v_Transparent_Interface_Interrupts_Enable_Control(char c_SpwID, alt_u8 uc_RegisterOperation, alt_u32 ul_InterruptMask);
	alt_u32 ul_Transparent_Interface_Interrupts_Flags_Read(char c_SpwID);
	void v_Transparent_Interface_Interrupts_Flags_Clear(char c_SpwID, alt_u32 ul_InterruptMask);
	void v_Transparent_Interface_RX_FIFO_Reset(char c_SpwID);
	alt_u32 ul_Transparent_Interface_RX_FIFO_Status_Read(char c_SpwID);
	bool b_Transparent_Interface_RX_FIFO_Status_Empty(char c_SpwID);
	bool b_Transparent_Interface_RX_FIFO_Status_Full(char c_SpwID);
	alt_u8 uc_Transparent_Interface_RX_FIFO_Status_Used(char c_SpwID);
	void v_Transparent_Interface_TX_FIFO_Reset(char c_SpwID);
	alt_u32 ul_Transparent_Interface_TX_FIFO_Status_Read(char c_SpwID);
	bool b_Transparent_Interface_TX_FIFO_Status_Empty(char c_SpwID);
	bool b_Transparent_Interface_TX_FIFO_Status_Full(char c_SpwID);
	alt_u8 uc_Transparent_Interface_TX_FIFO_Status_Used(char c_SpwID);
	bool b_Transparent_Interface_Switch_Channel(char c_SpwID);
	bool b_Transparent_Interface_Send_SpaceWire_Data(char c_SpwID, alt_u8 *data_buffer, alt_u16 data_size);
	alt_u16 ui_Transparent_Interface_Get_SpaceWire_Data(char c_SpwID, alt_u8 *data_buffer);
	
#endif /* TRAN_H_ */
