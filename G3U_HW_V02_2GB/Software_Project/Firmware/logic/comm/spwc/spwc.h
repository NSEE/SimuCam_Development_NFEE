/*
 * spwc.h
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

#ifndef SPWC_H_
#define SPWC_H_

	#include "system.h"
	#include "alt_types.h"
	
	#include "spwc_registers.h"
	
	typedef int bool;
	#define TRUE    1
	#define FALSE   0

	#define SPWC_A_BASE (COMMUNICATION_MODULE_A_BASE)
	#define SPWC_B_BASE (COMMUNICATION_MODULE_B_BASE)
	#define SPWC_C_BASE (COMMUNICATION_MODULE_C_BASE)
	#define SPWC_D_BASE (COMMUNICATION_MODULE_D_BASE)
	#define SPWC_E_BASE (COMMUNICATION_MODULE_E_BASE)
	#define SPWC_F_BASE (COMMUNICATION_MODULE_F_BASE)
	#define SPWC_G_BASE (COMMUNICATION_MODULE_G_BASE)
	#define SPWC_H_BASE (COMMUNICATION_MODULE_H_BASE)

	#define SPWC_REG_CLEAR 0
	#define SPWC_REG_SET   1

	#define SPWC_INTERFACE_BACKDOOR_MODE          0
	#define SPWC_INTERFACE_EXTERNAL_LOOPBACK_MODE 1
	#define SPWC_INTERFACE_LOOPBACK_MODE          2
	#define SPWC_INTERFACE_NORMAL_MODE            3


	bool b_SpaceWire_Interface_Write_Register(char c_SpwID, alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue);
	alt_u32 ul_SpaceWire_Interface_Read_Register(char c_SpwID, alt_u8 uc_RegisterAddress);
	bool b_SpaceWire_Interface_Enable_Control(char c_SpwID, alt_u8 uc_RegisterOperation, alt_u32 ul_EnableMask);
	bool b_SpaceWire_Interface_Mode_Control(char c_SpwID, alt_u8 uc_InterfaceMode);
	void v_SpaceWire_Interface_Force_Reset(char c_SpwID);
	bool v_SpaceWire_Interface_Interrupts_Enable_Control(char c_SpwID, alt_u8 uc_RegisterOperation, alt_u32 ul_InterruptMask);
	alt_u32 ul_SpaceWire_Interface_Interrupts_Flags_Read(char c_SpwID);
	void v_SpaceWire_Interface_Interrupts_Flags_Clear(char c_SpwID, alt_u32 ul_InterruptMask);
	bool v_SpaceWire_Interface_Link_Control(char c_SpwID, alt_u8 uc_RegisterOperation, alt_u32 ul_ControlMask);
	alt_u32 ul_SpaceWire_Interface_Link_Error_Read(char c_SpwID);
	alt_u32 ul_SpaceWire_Interface_Link_Status_Read(char c_SpwID);
	void v_SpaceWire_Interface_Send_TimeCode(char c_SpwID, alt_u8 TimeCode);
	bool b_SpaceWire_Interface_TimeCode_Arrived(char c_SpwID);
	alt_u8 uc_SpaceWire_Interface_Get_TimeCode(char c_SpwID);
	alt_u8 uc_SpaceWire_Interface_Get_TX_Div(char c_SpwID);
	bool b_SpaceWire_Interface_Set_TX_Div(char c_SpwID, alt_u8 uc_TxDiv);
	bool b_SpaceWire_Interface_Write_TX_Data(char c_SpwID, alt_u8 uc_TxFlag, alt_u8 uc_TxData);
	bool b_SpaceWire_Interface_Send_SpaceWire_Data(char c_SpwID, alt_u8 *data_buffer, alt_u16 data_size);
	bool b_SpaceWire_Interface_Read_RX_Data(char c_SpwID, alt_u8 *uc_RxFlag, alt_u8 *uc_RxData);
	alt_u16 ui_SpaceWire_Interface_Get_SpaceWire_Data(char c_SpwID, alt_u8 *data_buffer, alt_u16 buffer_size);

#endif /* SPWC_H_ */
