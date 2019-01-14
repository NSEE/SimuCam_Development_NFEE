/*
 * fee_buffers.c
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#include "fee_buffers.h"

//! [private function prototypes]
static void vFeebWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliFeebReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viCh1HoldContext;
static volatile int viCh2HoldContext;
static volatile int viCh3HoldContext;
static volatile int viCh4HoldContext;
static volatile int viCh5HoldContext;
static volatile int viCh6HoldContext;
static volatile int viCh7HoldContext;
static volatile int viCh8HoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vFeebCh1HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh1IrqFlagClrBufferEmpty();
}

void vFeebCh2HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh2IrqFlagClrBufferEmpty();
}

void vFeebCh3HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh3IrqFlagClrBufferEmpty();
}

void vFeebCh4HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh4IrqFlagClrBufferEmpty();
}

void vFeebCh5HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh5IrqFlagClrBufferEmpty();
}

void vFeebCh6HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	vFeebCh6IrqFlagClrBufferEmpty();
}

void vFeebCh7HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh7IrqFlagClrBufferEmpty();
}

void vFeebCh8HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vFeebCh8IrqFlagClrBufferEmpty();
}

void vFeebCh1IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh2IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh3IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh4IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh5IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh6IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh7IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vFeebCh8IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

bool bFeebCh1IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh2IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh3IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh4IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh5IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh6IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh7IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh8IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

void vFeebInitIrq(alt_u8 ucCommCh) {
	void* pvHoldContext;
	switch (ucCommCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_A_IRQ, pvHoldContext,
				vFeebCh1HandleIrq);
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_B_IRQ, pvHoldContext,
				vFeebCh2HandleIrq);
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_C_IRQ, pvHoldContext,
				vFeebCh3HandleIrq);
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_D_IRQ, pvHoldContext,
				vFeebCh4HandleIrq);
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_E_IRQ, pvHoldContext,
				vFeebCh5HandleIrq);
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_F_IRQ, pvHoldContext,
				vFeebCh6HandleIrq);
		break;
	case eCommSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_G_IRQ, pvHoldContext,
				vFeebCh7HandleIrq);
		break;
	case eCommSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_H_IRQ, pvHoldContext,
				vFeebCh8HandleIrq);
		break;
	}
}

bool bFeebSetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_IRQ_CTRL_REG_OFFSET);

		if (pxFeebCh->xIrqControl.bLeftBufferEmptyEn) {
			uliReg |= COMM_IRQ_L_BUFFER_EMPTY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_L_BUFFER_EMPTY_EN_MSK);
		}
		if (pxFeebCh->xIrqControl.bRightBufferEmptyEn) {
			uliReg |= COMM_IRQ_R_BUFFER_EMPTY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_R_BUFFER_EMPTY_EN_MSK);
		}

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_IRQ_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_IRQ_CTRL_REG_OFFSET);

		if (uliReg & COMM_IRQ_L_BUFFER_EMPTY_EN_MSK) {
			pxFeebCh->xIrqControl.bLeftBufferEmptyEn = TRUE;
		} else {
			pxFeebCh->xIrqControl.bLeftBufferEmptyEn = FALSE;
		}
		if (uliReg & COMM_IRQ_R_BUFFER_EMPTY_EN_MSK) {
			pxFeebCh->xIrqControl.bRightBufferEmptyEn = TRUE;
		} else {
			pxFeebCh->xIrqControl.bRightBufferEmptyEn = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetIrqFlags(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_IRQ_FLAG_REG_OFFSET);

		if (uliReg & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
			pxFeebCh->xIrqFlag.bBufferEmptyFlag = TRUE;
		} else {
			pxFeebCh->xIrqFlag.bBufferEmptyFlag = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebSetWindowing(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (pxFeebCh->xWindowingConfig.bMasking) {
			uliReg |= COMM_CTRL_MASKING_EN_MSK;
		} else {
			uliReg &= (~COMM_CTRL_MASKING_EN_MSK);
		}

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_WINDOW_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetWindowing(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (uliReg & COMM_CTRL_MASKING_EN_MSK) {
			pxFeebCh->xWindowingConfig.bMasking = TRUE;
		} else {
			pxFeebCh->xWindowingConfig.bMasking = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebGetBuffersStatus(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_WINDOW_BUFFER_REG_OFFSET);

		if (uliReg & COMM_BUFF_STAT_L_BUFF_EPY_MSK) {
			pxFeebCh->xBufferStatus.bLeftBufferEmpty = TRUE;
		} else {
			pxFeebCh->xBufferStatus.bLeftBufferEmpty = FALSE;
		}
		if (uliReg & COMM_BUFF_STAT_R_BUFF_EPY_MSK) {
			pxFeebCh->xBufferStatus.bRightBufferEmpty = TRUE;
		} else {
			pxFeebCh->xBufferStatus.bRightBufferEmpty = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

//! [public functions]

//! [private functions]
static void vFeebWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliFeebReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
