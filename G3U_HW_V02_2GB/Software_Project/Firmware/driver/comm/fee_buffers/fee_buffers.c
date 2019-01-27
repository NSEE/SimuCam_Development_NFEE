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
	volatile int* pviHoldContext = (volatile int*) pvContext;

	vFeebCh2IrqFlagClrBufferEmpty();
}

void vFeebCh3HandleIrq(void* pvContext) {
	volatile int* pviHoldContext = (volatile int*) pvContext;

	vFeebCh3IrqFlagClrBufferEmpty();
}

void vFeebCh4HandleIrq(void* pvContext) {
	volatile int* pviHoldContext = (volatile int*) pvContext;

	vFeebCh4IrqFlagClrBufferEmpty();
}

void vFeebCh5HandleIrq(void* pvContext) {
	volatile int* pviHoldContext = (volatile int*) pvContext;

	vFeebCh5IrqFlagClrBufferEmpty();
}

void vFeebCh6HandleIrq(void* pvContext) {
	volatile int* pviHoldContext = (volatile int*) pvContext;


	vFeebCh6IrqFlagClrBufferEmpty();
}

void vFeebCh7HandleIrq(void* pvContext) {
	volatile int* pviHoldContext = (volatile int*) pvContext;


	vFeebCh7IrqFlagClrBufferEmpty();
}

void vFeebCh8HandleIrq(void* pvContext) {
	volatile int* pviHoldContext = (volatile int*) pvContext;


	vFeebCh8IrqFlagClrBufferEmpty();
}

void vFeebCh1IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_BUFF_EPY_FLG_CLR_MSK);
}

void vFeebCh2IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_BUFF_EPY_FLG_CLR_MSK);
}

void vFeebCh3IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_BUFF_EPY_FLG_CLR_MSK);
}

void vFeebCh4IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_BUFF_EPY_FLG_CLR_MSK);
}

void vFeebCh5IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_BUFF_EPY_FLG_CLR_MSK);
}

void vFeebCh6IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_BUFF_EPY_FLG_CLR_MSK);
}

void vFeebCh7IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_BUFF_EPY_FLG_CLR_MSK);
}

void vFeebCh8IrqFlagClrBufferEmpty(void) {
	vFeebWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_BUFF_EPY_FLG_CLR_MSK);
}

bool bFeebCh1IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_BUFF_EPY_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh2IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_BUFF_EPY_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh3IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_BUFF_EPY_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh4IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_BUFF_EPY_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh5IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_BUFF_EPY_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh6IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_BUFF_EPY_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh7IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_BUFF_EPY_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bFeebCh8IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliFeebReadReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_BUFF_EPY_FLG_MSK) {
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
		alt_irq_register(COMM_CH_1_BUFFERS_IRQ, pvHoldContext,
				vFeebCh1HandleIrq);
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_BUFFERS_IRQ, pvHoldContext,
				vFeebCh2HandleIrq);
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_BUFFERS_IRQ, pvHoldContext,
				vFeebCh3HandleIrq);
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_BUFFERS_IRQ, pvHoldContext,
				vFeebCh4HandleIrq);
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_5_BUFFERS_IRQ, pvHoldContext,
				vFeebCh5HandleIrq);
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_6_BUFFERS_IRQ, pvHoldContext,
				vFeebCh6HandleIrq);
		break;
	case eCommSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_7_BUFFERS_IRQ, pvHoldContext,
				vFeebCh7HandleIrq);
		break;
	case eCommSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_8_BUFFERS_IRQ, pvHoldContext,
				vFeebCh8HandleIrq);
		break;
	}
}

bool bFeebSetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_IRQ_CONTROL_REG_OFST);

		if (pxFeebCh->xIrqControl.bLeftBufferEmptyEn) {
			uliReg |= COMM_IRQ_LEFT_BUFF_EPY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_LEFT_BUFF_EPY_EN_MSK);
		}
		if (pxFeebCh->xIrqControl.bRightBufferEmptyEn) {
			uliReg |= COMM_IRQ_RIGH_BUFF_EPY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_RIGH_BUFF_EPY_EN_MSK);
		}

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_IRQ_CONTROL_REG_OFST,
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
		COMM_IRQ_CONTROL_REG_OFST);

		if (uliReg & COMM_IRQ_LEFT_BUFF_EPY_EN_MSK) {
			pxFeebCh->xIrqControl.bLeftBufferEmptyEn = TRUE;
		} else {
			pxFeebCh->xIrqControl.bLeftBufferEmptyEn = FALSE;
		}
		if (uliReg & COMM_IRQ_RIGH_BUFF_EPY_EN_MSK) {
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
		COMM_IRQ_FLAGS_REG_OFST);

		if (uliReg & COMM_IRQ_BUFF_EPY_FLG_MSK) {
			pxFeebCh->xIrqFlag.bBufferEmptyFlag = TRUE;
		} else {
			pxFeebCh->xIrqFlag.bBufferEmptyFlag = FALSE;
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
		COMM_FEE_BUFF_STAT_REG_OFST);

		if (uliReg & COMM_WIND_LEFT_BUFF_EMPTY_MSK) {
			pxFeebCh->xBufferStatus.bLeftBufferEmpty = TRUE;
		} else {
			pxFeebCh->xBufferStatus.bLeftBufferEmpty = FALSE;
		}
		if (uliReg & COMM_WIND_RIGH_BUFF_EMPTY_MSK) {
			pxFeebCh->xBufferStatus.bRightBufferEmpty = TRUE;
		} else {
			pxFeebCh->xBufferStatus.bRightBufferEmpty = FALSE;
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
		COMM_FEE_BUFF_CFG_REG_OFST);

		if (pxFeebCh->xWindowingConfig.bMasking) {
			uliReg |= COMM_FEE_MASKING_EN_MSK;
		} else {
			uliReg &= (~COMM_FEE_MASKING_EN_MSK);
		}

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_FEE_BUFF_CFG_REG_OFST,
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
		COMM_FEE_BUFF_CFG_REG_OFST);

		if (uliReg & COMM_FEE_MASKING_EN_MSK) {
			pxFeebCh->xWindowingConfig.bMasking = TRUE;
		} else {
			pxFeebCh->xWindowingConfig.bMasking = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebStartCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_CFG_REG_OFST);

		uliReg |= COMM_FEE_MACHINE_START_MSK;

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_FEE_BUFF_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebStopCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_CFG_REG_OFST);

		uliReg |= COMM_FEE_MACHINE_STOP_MSK;

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_FEE_BUFF_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebClrCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliFeebReadReg(pxFeebCh->puliFeebChAddr,
		COMM_FEE_BUFF_CFG_REG_OFST);

		uliReg |= COMM_FEE_MACHINE_CLR_MSK;

		vFeebWriteReg(pxFeebCh->puliFeebChAddr, COMM_FEE_BUFF_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bFeebInitCh(TFeebChannel *pxFeebCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;

	if (pxFeebCh != NULL) {
		bStatus = TRUE;

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
			break;
		case eCommSpwCh2:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
			break;
		case eCommSpwCh3:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
			break;
		case eCommSpwCh4:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
			break;
		case eCommSpwCh5:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
			break;
		case eCommSpwCh6:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
			break;
		case eCommSpwCh7:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
			break;
		case eCommSpwCh8:
			pxFeebCh->puliFeebChAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
			break;
		default:
			bStatus = FALSE;
			break;
		}

		if (bStatus) {
			if (!bFeebGetIrqControl(pxFeebCh)) {
				bStatus = FALSE;
			}
			if (!bFeebGetIrqFlags(pxFeebCh)) {
				bStatus = FALSE;
			}
			if (!bFeebGetBuffersStatus(pxFeebCh)) {
				bStatus = FALSE;
			}
			if (!bFeebGetWindowing(pxFeebCh)) {
				bStatus = FALSE;
			}
		}
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
