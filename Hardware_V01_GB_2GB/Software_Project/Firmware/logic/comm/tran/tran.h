/*
 * tran.h
 *
 *  Created on: 06/10/2017
 *      Author: rfranca
 */

#ifndef TRAN_H_
#define TRAN_H_

	#define TRAN_BASE COMMUNICATION_MODULE_E_BASE

	#include "system.h"
	#include "alt_types.h"
	
	#include "tran_registers.h"

	typedef int bool;
	#define TRUE    1
	#define FALSE   0

	#define TRAN_REG_CLEAR 0
	#define TRAN_REG_SET   1

	bool b_Transparent_Interface_Write_Register(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue);
	alt_u32 ul_Transparent_Interface_Read_Register(alt_u8 uc_RegisterAddress);
	bool v_Transparent_Interface_Enable_Control(alt_u8 uc_RegisterOperation, alt_u32 ul_EnableMask);
	bool v_Transparent_Interface_Interrupts_Enable_Control(alt_u8 uc_RegisterOperation, alt_u32 ul_InterruptMask);
	alt_u32 ul_Transparent_Interface_Interrupts_Flags_Read(void);
	void v_Transparent_Interface_Interrupts_Flags_Clear(alt_u32 ul_InterruptMask);
	void v_Transparent_Interface_RX_FIFO_Reset(void);
	alt_u32 ul_Transparent_Interface_RX_FIFO_Status_Read(void);
	void v_Transparent_Interface_TX_FIFO_Reset(void);
	alt_u32 ul_Transparent_Interface_TX_FIFO_Status_Read(void);

#endif /* TRAN_H_ */
