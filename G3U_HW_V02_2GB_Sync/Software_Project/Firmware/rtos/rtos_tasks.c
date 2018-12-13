/*
 * rtos_tasks.c
 *
 *  Created on: 24/04/2018
 *      Author: rfranca
 */

/* Includes */
#include "rtos_tasks.h"

#include "../alt_error_handler.h"

#include "../utils/util.h"
#include "../utils/meb_includes.h"

#include "../driver/i2c/i2c.h"
#include "../driver/leds/leds.h"
#include "../driver/power_spi/power_spi.h"
#include "../driver/rtcc_spi/rtcc_spi.h"
#include "../driver/seven_seg/seven_seg.h"

#include "../logic/dma/dma.h"
#include "../logic/sense/sense.h"
#include "../logic/ddr2/ddr2.h"
#include "../logic/comm/comm.h"
#include "../logic/pgen/pgen.h"

/* OS Error Variables */
alt_u8 error_code = 0;

/* Log Variables */
alt_8 tempFPGA = 0;
alt_8 tempBoard = 0;

/* DMA Variables*/
alt_msgdma_dev *DMADev = NULL;

/* OS Tasks Variables */
OS_STK MemDMATaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK SPWATaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK SPWBTaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK SPWCTaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK SPWDTaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK SPWETaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK SPWFTaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK SPWGTaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK SPWHTaskStk[SIMUCAM_TASK_STACKSIZE];
OS_STK LogTaskStk[SIMUCAM_TASK_STACKSIZE];

/* SpW Functions */
void Configure_SpW_Autostart(char c_SpwID);
void Set_SpW_Led(char c_SpwID);

/* OS Tasks */

/* Mem DMA Task, configure and manages the Memories DMA for use of the SpW Transparent Interface*/
void MemDMATask(void *task_data) {
	printf("Created \"mem dma\" Task (Prio:%d) \n", MEM_DMA_TASK_PRIORITY);

//	/* Open DMA Device */
//	if (DMA_OPEN_DEVICE(&DMADev, (char *)DMA_DDR_M_CSR_NAME) == FALSE){
//		printf("Error Opening DMA Device");
//	}
//
//	/* Reset DMA Device */
//	if (DMA_DISPATCHER_RESET(DMADev, DMA_WAIT, DMA_DEFAULT_WAIT_PERIOD) == FALSE){
//		printf("Error Reseting Dispatcher");
//	}
	
	/* read address - source address (data buffer) */
	/* write address - destination address (transparent interface) */
	/* transfer size bytes - number of bytes to be transfered */

	while (1) {
		OSTimeDlyHMSM(0, 1, 0, 0);
	}
}

/* SPW A Task, configure and monitor the SpW A channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWATask(void *task_data) {
	printf("Created \"spw a\" Task (Prio:%d) \n", SPW_A_TASK_PRIORITY);

	Configure_SpW_Autostart('A');
	while (1) {
		Set_SpW_Led('A');
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* SPW B Task, configure and monitor the SpW B channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWBTask(void *task_data) {
	printf("Created \"spw b\" Task (Prio:%d) \n", SPW_B_TASK_PRIORITY);

	Configure_SpW_Autostart('B');
	while (1) {
		Set_SpW_Led('B');
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* SPW C Task, configure and monitor the SpW C channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWCTask(void *task_data) {
	printf("Created \"spw c\" Task (Prio:%d) \n", SPW_C_TASK_PRIORITY);

	Configure_SpW_Autostart('C');
	while (1) {
		Set_SpW_Led('C');
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* SPW D Task, configure and monitor the SpW D channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWDTask(void *task_data) {
	printf("Created \"spw d\" Task (Prio:%d) \n", SPW_D_TASK_PRIORITY);

	Configure_SpW_Autostart('D');
	while (1) {
		Set_SpW_Led('D');
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* SPW E Task, configure and monitor the SpW E channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWETask(void *task_data) {
	printf("Created \"spw e\" Task (Prio:%d) \n", SPW_E_TASK_PRIORITY);

	Configure_SpW_Autostart('E');
	while (1) {
		Set_SpW_Led('E');
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* SPW F Task, configure and monitor the SpW F channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWFTask(void *task_data) {
	printf("Created \"spw f\" Task (Prio:%d) \n", SPW_F_TASK_PRIORITY);

	Configure_SpW_Autostart('F');
	while (1) {
		Set_SpW_Led('F');
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* SPW G Task, configure and monitor the SpW G channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWGTask(void *task_data) {
	printf("Created \"spw g\" Task (Prio:%d) \n", SPW_G_TASK_PRIORITY);

	Configure_SpW_Autostart('G');
	while (1) {
		Set_SpW_Led('G');
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* SPW H Task, configure and monitor the SpW H channel for incoming connections to set the status leds, update rate of 10 ms */
void SPWHTask(void *task_data) {
	printf("Created \"spw h\" Task (Prio:%d) \n", SPW_H_TASK_PRIORITY);

	Configure_SpW_Autostart('H');
	while (1) {
		Set_SpW_Led('H');
		OSTimeDlyHMSM(0, 0, 0, 10);
	}
}

/* Log Task, show the FPGA core temperature in the seven segments display, update rate of 1 s */
void LogTask(void *task_data) {
	printf("Created \"log\" Task (Prio:%d) \n", LOG_TASK_PRIORITY);
	while (1) {
		TEMP_Read(&tempFPGA, &tempBoard);
		SSDP_UPDATE(tempFPGA);
		OSTimeDlyHMSM(0, 0, 1, 0);
	}
}

/* Initialize the SimuCam Tasks */
void Init_Simucam_Tasks(void) {

	error_code = OSTaskCreateExt(MemDMATask,
	                             NULL,
	                             (void *) &MemDMATaskStk[SIMUCAM_TASK_STACKSIZE],
	                             MEM_DMA_TASK_PRIORITY,
	                             MEM_DMA_TASK_PRIORITY,
	                             MemDMATaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(SPWATask,
	                             NULL,
	                             (void *) &SPWATaskStk[SIMUCAM_TASK_STACKSIZE],
	                             SPW_A_TASK_PRIORITY,
	                             SPW_A_TASK_PRIORITY,
	                             SPWATaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(SPWBTask,
	                             NULL,
	                             (void *) &SPWBTaskStk[SIMUCAM_TASK_STACKSIZE],
	                             SPW_B_TASK_PRIORITY,
	                             SPW_B_TASK_PRIORITY,
	                             SPWBTaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(SPWCTask,
	                             NULL,
	                             (void *) &SPWCTaskStk[SIMUCAM_TASK_STACKSIZE],
	                             SPW_C_TASK_PRIORITY,
	                             SPW_C_TASK_PRIORITY,
	                             SPWCTaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(SPWDTask,
	                             NULL,
	                             (void *) &SPWDTaskStk[SIMUCAM_TASK_STACKSIZE],
	                             SPW_D_TASK_PRIORITY,
	                             SPW_D_TASK_PRIORITY,
	                             SPWDTaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(SPWETask,
	                             NULL,
	                             (void *) &SPWETaskStk[SIMUCAM_TASK_STACKSIZE],
	                             SPW_E_TASK_PRIORITY,
	                             SPW_E_TASK_PRIORITY,
	                             SPWETaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(SPWFTask,
	                             NULL,
	                             (void *) &SPWFTaskStk[SIMUCAM_TASK_STACKSIZE],
	                             SPW_F_TASK_PRIORITY,
	                             SPW_F_TASK_PRIORITY,
	                             SPWFTaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(SPWGTask,
	                             NULL,
	                             (void *) &SPWGTaskStk[SIMUCAM_TASK_STACKSIZE],
	                             SPW_G_TASK_PRIORITY,
	                             SPW_G_TASK_PRIORITY,
	                             SPWGTaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

	error_code = OSTaskCreateExt(SPWHTask,
	                             NULL,
	                             (void *) &SPWHTaskStk[SIMUCAM_TASK_STACKSIZE],
	                             SPW_H_TASK_PRIORITY,
	                             SPW_H_TASK_PRIORITY,
	                             SPWHTaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);
	
	error_code = OSTaskCreateExt(LogTask,
	                             NULL,
	                             (void *) &LogTaskStk[SIMUCAM_TASK_STACKSIZE],
	                             LOG_TASK_PRIORITY,
	                             LOG_TASK_PRIORITY,
	                             LogTaskStk,
	                             SIMUCAM_TASK_STACKSIZE,
	                             NULL,
	                             0);
	alt_uCOSIIErrorHandler(error_code, 0);

}

void Configure_SpW_Autostart(char c_SpwID) {
	// Configura COMM
	// Reseta TX e RX Fifo
	v_Transparent_Interface_RX_FIFO_Reset(c_SpwID);
	v_Transparent_Interface_TX_FIFO_Reset(c_SpwID);
	// Habilita a Interface Transparente
	v_Transparent_Interface_Enable_Control(c_SpwID, TRAN_REG_SET,
			TRAN_INTERFACE_ENABLE_CONTROL_BIT_MASK
					| TRAN_INTERFACE_TX_ENABLE_CONTROL_BIT_MASK | TRAN_INTERFACE_RX_ENABLE_CONTROL_BIT_MASK);
	// Reseta Codec
	v_SpaceWire_Interface_Force_Reset(c_SpwID);
	// Habilita a Interface SpaceWire
	b_SpaceWire_Interface_Enable_Control(c_SpwID, SPWC_REG_SET,
	SPWC_CODEC_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_TX_ENABLE_CONTROL_BIT_MASK | SPWC_CODEC_RX_ENABLE_CONTROL_BIT_MASK);
	// Coloca Codec no modo Normal
//	b_SpaceWire_Interface_Mode_Control(c_SpwID, SPWC_INTERFACE_NORMAL_MODE);
	b_SpaceWire_Interface_Mode_Control(c_SpwID, SPWC_INTERFACE_BACKDOOR_MODE);
	// Coloca Codec no link Autostart
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_CLEAR,
	SPWC_LINK_DISCONNECT_CONTROL_BIT_MASK | SPWC_LINK_START_CONTROL_BIT_MASK);
	v_SpaceWire_Interface_Link_Control(c_SpwID, SPWC_REG_SET,
	SPWC_AUTOSTART_CONTROL_BIT_MASK);
	printf("SpaceWire %c configurado\n", c_SpwID);
}

void Set_SpW_Led(char c_SpwID) {
	alt_u32 ui_leds_mask_r = 0;
	alt_u32 ui_leds_mask_g = 0;
	switch (c_SpwID) {
	case 'A':
		ui_leds_mask_r = LEDS_1R_MASK;
		ui_leds_mask_g = LEDS_1G_MASK;
		break;
	case 'B':
		ui_leds_mask_r = LEDS_2R_MASK;
		ui_leds_mask_g = LEDS_2G_MASK;
		break;
	case 'C':
		ui_leds_mask_r = LEDS_3R_MASK;
		ui_leds_mask_g = LEDS_3G_MASK;
		break;
	case 'D':
		ui_leds_mask_r = LEDS_4R_MASK;
		ui_leds_mask_g = LEDS_4G_MASK;
		break;
	case 'E':
		ui_leds_mask_r = LEDS_5R_MASK;
		ui_leds_mask_g = LEDS_5G_MASK;
		break;
	case 'F':
		ui_leds_mask_r = LEDS_6R_MASK;
		ui_leds_mask_g = LEDS_6G_MASK;
		break;
	case 'G':
		ui_leds_mask_r = LEDS_7R_MASK;
		ui_leds_mask_g = LEDS_7G_MASK;
		break;
	case 'H':
		ui_leds_mask_r = LEDS_8R_MASK;
		ui_leds_mask_g = LEDS_8G_MASK;
		break;
	}
	alt_u32 SpW_Link_Status = ul_SpaceWire_Interface_Link_Status_Read(c_SpwID);
	if (SpW_Link_Status & SPWC_LINK_RUNNING_STATUS_BIT_MASK) {
		LEDS_PAINEL_DRIVE(LEDS_OFF, ui_leds_mask_r);
		LEDS_PAINEL_DRIVE(LEDS_ON, ui_leds_mask_g);
	} else if (SpW_Link_Status
			& (SPWC_LINK_DISCONNECT_ERROR_BIT_MASK
					| SPWC_LINK_PARITY_ERROR_BIT_MASK
					| SPWC_LINK_ESCAPE_ERROR_BIT_MASK
					| SPWC_LINK_CREDIT_ERROR_BIT_MASK)) {
		LEDS_PAINEL_DRIVE(LEDS_ON, ui_leds_mask_g | ui_leds_mask_r);
	} else {
		LEDS_PAINEL_DRIVE(LEDS_OFF, ui_leds_mask_g);
		LEDS_PAINEL_DRIVE(LEDS_ON, ui_leds_mask_r);
	}
}
