/*
 * tran.h
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

#ifndef TRAN_H_
#define TRAN_H_

	#define TRAN_A_BASE COMMUNICATION_MODULE_A_BASE
	#define TRAN_B_BASE COMMUNICATION_MODULE_B_BASE
	#define TRAN_C_BASE COMMUNICATION_MODULE_C_BASE
	#define TRAN_D_BASE COMMUNICATION_MODULE_D_BASE
	#define TRAN_E_BASE COMMUNICATION_MODULE_E_BASE
	#define TRAN_F_BASE COMMUNICATION_MODULE_F_BASE
	#define TRAN_G_BASE COMMUNICATION_MODULE_G_BASE
	#define TRAN_H_BASE COMMUNICATION_MODULE_H_BASE
	
	#include "system.h"
	#include "alt_types.h"
	
	#include "tran_registers.h"

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
	void v_Transparent_Interface_TX_FIFO_Reset(char c_SpwID);
	alt_u32 ul_Transparent_Interface_TX_FIFO_Status_Read(char c_SpwID);

#endif /* TRAN_H_ */
