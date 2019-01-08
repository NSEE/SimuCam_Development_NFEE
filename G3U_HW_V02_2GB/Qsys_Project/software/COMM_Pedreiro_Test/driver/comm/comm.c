#include "comm.h"

//! [private function prototypes]
static void vCommWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliCommReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
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

void vCommCh1HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vCommCh1IrqFlagClrBufferEmpty();
}

void vCommCh2HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vCommCh2IrqFlagClrBufferEmpty();
}

void vCommCh3HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vCommCh3IrqFlagClrBufferEmpty();
}

void vCommCh4HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vCommCh4IrqFlagClrBufferEmpty();
}

void vCommCh5HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vCommCh5IrqFlagClrBufferEmpty();
}

void vCommCh6HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	vCommCh6IrqFlagClrBufferEmpty();
}

void vCommCh7HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vCommCh7IrqFlagClrBufferEmpty();
}

void vCommCh8HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vCommCh8IrqFlagClrBufferEmpty();
}

void vCommCh1IrqFlagClrBufferEmpty(void) {
	vCommWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vCommCh2IrqFlagClrBufferEmpty(void) {
	vCommWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vCommCh3IrqFlagClrBufferEmpty(void) {
	vCommWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vCommCh4IrqFlagClrBufferEmpty(void) {
	vCommWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vCommCh5IrqFlagClrBufferEmpty(void) {
	vCommWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vCommCh6IrqFlagClrBufferEmpty(void) {
	vCommWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vCommCh7IrqFlagClrBufferEmpty(void) {
	vCommWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

void vCommCh8IrqFlagClrBufferEmpty(void) {
	vCommWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET, (alt_u32) COMM_IRQ_BUFFER_EMPTY_FLAG_MSK);
}

bool bCommCh1IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliCommReadReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bCommCh2IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliCommReadReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bCommCh3IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliCommReadReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bCommCh4IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliCommReadReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bCommCh5IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliCommReadReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bCommCh6IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliCommReadReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bCommCh7IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliCommReadReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bCommCh8IrqFlagBufferEmpty(void) {
	bool bFlag;

	if (uliCommReadReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAG_REG_OFFSET) & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

void vCommInitIrq(alt_u8 ucSpwCh) {
	void* pvHoldContext;
	switch (ucSpwCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_A_IRQ, pvHoldContext,
				vCommCh1HandleIrq);
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_B_IRQ, pvHoldContext,
				vCommCh2HandleIrq);
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_C_IRQ, pvHoldContext,
				vCommCh3HandleIrq);
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_D_IRQ, pvHoldContext,
				vCommCh4HandleIrq);
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_E_IRQ, pvHoldContext,
				vCommCh5HandleIrq);
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_F_IRQ, pvHoldContext,
				vCommCh6HandleIrq);
		break;
	case eCommSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_G_IRQ, pvHoldContext,
				vCommCh7HandleIrq);
		break;
	case eCommSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_H_IRQ, pvHoldContext,
				vCommCh8HandleIrq);
		break;
	}
}

bool bCommSetIrqControl(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_IRQ_CTRL_REG_OFFSET);

		if (pxCh->xIrqControl.bLeftBufferEmptyEn) {
			uliReg |= COMM_IRQ_L_BUFFER_EMPTY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_L_BUFFER_EMPTY_EN_MSK);
		}
		if (pxCh->xIrqControl.bRightBufferEmptyEn) {
			uliReg |= COMM_IRQ_R_BUFFER_EMPTY_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_R_BUFFER_EMPTY_EN_MSK);
		}

		vCommWriteReg(pxCh->puliChAddr, COMM_IRQ_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetIrqControl(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_IRQ_CTRL_REG_OFFSET);

		if (uliReg & COMM_IRQ_L_BUFFER_EMPTY_EN_MSK) {
			pxCh->xIrqControl.bLeftBufferEmptyEn = TRUE;
		} else {
			pxCh->xIrqControl.bLeftBufferEmptyEn = FALSE;
		}
		if (uliReg & COMM_IRQ_R_BUFFER_EMPTY_EN_MSK) {
			pxCh->xIrqControl.bRightBufferEmptyEn = TRUE;
		} else {
			pxCh->xIrqControl.bRightBufferEmptyEn = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetIrqFlags(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_IRQ_FLAG_REG_OFFSET);

		if (uliReg & COMM_IRQ_BUFFER_EMPTY_FLAG_MSK) {
			pxCh->xIrqFlag.bBufferEmptyFlag = TRUE;
		} else {
			pxCh->xIrqFlag.bBufferEmptyFlag = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommSetWindowing(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (pxCh->xWindowingConfig.bMasking) {
			uliReg |= COMM_CTRL_MASKING_EN_MSK;
		} else {
			uliReg &= (~COMM_CTRL_MASKING_EN_MSK);
		}

		vCommWriteReg(pxCh->puliChAddr, COMM_WINDOW_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetWindowing(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (uliReg & COMM_CTRL_MASKING_EN_MSK) {
			pxCh->xWindowingConfig.bMasking = TRUE;
		} else {
			pxCh->xWindowingConfig.bMasking = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommSetLink(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (pxCh->xLinkConfig.bAutostart) {
			uliReg |= COMM_CTRL_LINK_AUTOSTART_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_AUTOSTART_MSK);
		}
		if (pxCh->xLinkConfig.bStart) {
			uliReg |= COMM_CTRL_LINK_START_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_START_MSK);
		}
		if (pxCh->xLinkConfig.bDisconnect) {
			uliReg |= COMM_CTRL_LINK_DISCONNECT_MSK;
		} else {
			uliReg &= (~COMM_CTRL_LINK_DISCONNECT_MSK);
		}

		vCommWriteReg(pxCh->puliChAddr, COMM_WINDOW_CTRL_REG_OFFSET,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetLink(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_WINDOW_CTRL_REG_OFFSET);

		if (uliReg & COMM_CTRL_LINK_AUTOSTART_MSK) {
			pxCh->xLinkConfig.bAutostart = TRUE;
		} else {
			pxCh->xLinkConfig.bAutostart = FALSE;
		}
		if (uliReg & COMM_CTRL_LINK_START_MSK) {
			pxCh->xLinkConfig.bStart = TRUE;
		} else {
			pxCh->xLinkConfig.bStart = FALSE;
		}
		if (uliReg & COMM_CTRL_LINK_DISCONNECT_MSK) {
			pxCh->xLinkConfig.bDisconnect = TRUE;
		} else {
			pxCh->xLinkConfig.bDisconnect = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetLinkError(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_WINDOW_STAT_REG_OFFSET);

		if (uliReg & COMM_STAT_LINK_DISC_ERR_MSK) {
			pxCh->xLinkError.bDisconnect = TRUE;
		} else {
			pxCh->xLinkError.bDisconnect = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_PAR_ERR_MSK) {
			pxCh->xLinkError.bParity = TRUE;
		} else {
			pxCh->xLinkError.bParity = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_ESC_ERR_MSK) {
			pxCh->xLinkError.bEscape = TRUE;
		} else {
			pxCh->xLinkError.bEscape = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_CRED_ERR_MSK) {
			pxCh->xLinkError.bCredit = TRUE;
		} else {
			pxCh->xLinkError.bCredit = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetLinkStatus(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_WINDOW_STAT_REG_OFFSET);

		if (uliReg & COMM_STAT_LINK_STARTED_MSK) {
			pxCh->xLinkStatus.bStarted = TRUE;
		} else {
			pxCh->xLinkStatus.bStarted = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_CONNECTING_MSK) {
			pxCh->xLinkStatus.bConnecting = TRUE;
		} else {
			pxCh->xLinkStatus.bConnecting = FALSE;
		}
		if (uliReg & COMM_STAT_LINK_RUNNING_MSK) {
			pxCh->xLinkStatus.bRunning = TRUE;
		} else {
			pxCh->xLinkStatus.bRunning = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetTimecodeRx(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_TIMECODE_RX_REG_OFFSET);

		pxCh->xTimecodeRx.ucControl = (alt_u8) ((uliReg
				& COMM_TIMECODE_RX_CONTROL_MSK) >> 7);
		pxCh->xTimecodeRx.ucCounter = (alt_u8) ((uliReg
				& COMM_TIMECODE_RX_COUNTER_MSK) >> 1);
		if (uliReg & COMM_TIMECODE_RX_RECEIVED_MSK) {
			pxCh->xTimecodeRx.bReceived = TRUE;
		} else {
			pxCh->xTimecodeRx.bReceived = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommClearTimecodeRxReceived(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = COMM_TIMECODE_RX_RECEIVED_MSK;

		vCommWriteReg(pxCh->puliChAddr, COMM_TIMECODE_RX_REG_OFFSET, uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommSendTimecodeTx(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg |= (alt_u32) (pxCh->xTimecodeTx.ucControl << 7);
		uliReg |= (alt_u32) (pxCh->xTimecodeTx.ucCounter << 1);
		if (pxCh->xTimecodeTx.bSend) {
			uliReg |= COMM_TIMECODE_TX_SEND_MSK;
		} else {
			uliReg &= (~COMM_TIMECODE_TX_SEND_MSK);
		}

		vCommWriteReg(pxCh->puliChAddr, COMM_TIMECODE_TX_REG_OFFSET, uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetTimecodeTx(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_TIMECODE_TX_REG_OFFSET);

		pxCh->xTimecodeTx.ucControl = (alt_u8) ((uliReg
				& COMM_TIMECODE_TX_CONTROL_MSK) >> 7);
		pxCh->xTimecodeTx.ucCounter = (alt_u8) ((uliReg
				& COMM_TIMECODE_TX_COUNTER_MSK) >> 1);
		if (uliReg & COMM_TIMECODE_TX_SEND_MSK) {
			pxCh->xTimecodeTx.bSend = TRUE;
		} else {
			pxCh->xTimecodeTx.bSend = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommGetBuffersStatus(TCommChannel *pxCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxCh != NULL) {
		uliReg = uliCommReadReg(pxCh->puliChAddr,
		COMM_WINDOW_BUFFER_REG_OFFSET);

		if (uliReg & COMM_BUFF_STAT_L_BUFF_EPY_MSK) {
			pxCh->xBufferStatus.bLeftBufferEmpty = TRUE;
		} else {
			pxCh->xBufferStatus.bLeftBufferEmpty = FALSE;
		}
		if (uliReg & COMM_BUFF_STAT_R_BUFF_EPY_MSK) {
			pxCh->xBufferStatus.bRightBufferEmpty = TRUE;
		} else {
			pxCh->xBufferStatus.bRightBufferEmpty = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bCommInitCh(TCommChannel *pxCh, alt_u8 ucSpwCh) {
	bool bStatus = FALSE;

	if (pxCh != NULL) {
		bStatus = TRUE;

		switch (ucSpwCh) {
		case eCommSpwCh1:
			pxCh->puliChAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
			break;
		case eCommSpwCh2:
			pxCh->puliChAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
			break;
		case eCommSpwCh3:
			pxCh->puliChAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
			break;
		case eCommSpwCh4:
			pxCh->puliChAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
			break;
		case eCommSpwCh5:
			pxCh->puliChAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
			break;
		case eCommSpwCh6:
			pxCh->puliChAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
			break;
		case eCommSpwCh7:
			pxCh->puliChAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
			break;
		case eCommSpwCh8:
			pxCh->puliChAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
			break;
		default:
			bStatus = FALSE;
			break;
		}

		if (bStatus) {
			if (!bCommGetWindowing(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetLink(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetLinkError(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetLinkStatus(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetTimecodeRx(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetTimecodeTx(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetIrqControl(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetIrqFlags(pxCh)) {
				bStatus = FALSE;
			}
			if (!bCommGetBuffersStatus(pxCh)) {
				bStatus = FALSE;
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
static void vCommWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliCommReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
//! [private functions]

