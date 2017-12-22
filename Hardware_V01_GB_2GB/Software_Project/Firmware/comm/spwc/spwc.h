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

	#define SPWC_BASE COMMUNICATION_MODULE_E_BASE

	#define SPWC_REG_CLEAR 0
	#define SPWC_REG_SET   1

	#define SPWC_INTERFACE_NORMAL_MODE   0
	#define SPWC_INTERFACE_LOOPBACK_MODE 1

	bool b_SpaceWire_Interface_Write_Register(alt_u8 uc_RegisterAddress, alt_u32 ul_RegisterValue);
	alt_u32 ul_SpaceWire_Interface_Read_Register(alt_u8 uc_RegisterAddress);
	bool b_SpaceWire_Interface_Enable_Control(alt_u8 uc_RegisterOperation, alt_u32 ul_EnableMask);
	bool b_SpaceWire_Interface_Mode_Control(alt_u8 uc_InterfaceMode);
	void v_SpaceWire_Interface_Force_Reset(void);
	bool v_SpaceWire_Interface_Interrupts_Enable_Control(alt_u8 uc_RegisterOperation, alt_u32 ul_InterruptMask);
	alt_u32 ul_SpaceWire_Interface_Interrupts_Flags_Read(void);
	void v_SpaceWire_Interface_Interrupts_Flags_Clear(alt_u32 ul_InterruptMask);
	bool v_SpaceWire_Interface_Link_Control(alt_u8 uc_RegisterOperation, alt_u32 ul_ControlMask);
	alt_u32 ul_SpaceWire_Interface_Link_Error_Read(void);
	alt_u32 ul_SpaceWire_Interface_Link_Status_Read(void);
	void v_SpaceWire_Interface_Send_TimeCode(alt_u8 TimeCode);
	alt_u16 ui_SpaceWire_Interface_Get_TimeCode(void);

#endif /* SPWC_H_ */
