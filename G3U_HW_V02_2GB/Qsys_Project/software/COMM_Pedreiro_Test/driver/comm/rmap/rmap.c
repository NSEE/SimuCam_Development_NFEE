/*
 * rmap.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "rmap.h"

//! [private function prototypes]
static void vRmapWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue);
static alt_u32 uliRmapReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
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
void vRmapCh1HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh1IrqFlagClrWriteCmd();
}

void vRmapCh2HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh2IrqFlagClrWriteCmd();
}

void vRmapCh3HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh3IrqFlagClrWriteCmd();
}

void vRmapCh4HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh4IrqFlagClrWriteCmd();
}

void vRmapCh5HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh5IrqFlagClrWriteCmd();
}

void vRmapCh6HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	vRmapCh6IrqFlagClrWriteCmd();
}

void vRmapCh7HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh7IrqFlagClrWriteCmd();
}

void vRmapCh8HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...
	vRmapCh8IrqFlagClrWriteCmd();
}

void vRmapCh1IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh2IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh3IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh4IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh5IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh6IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh7IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

void vRmapCh8IrqFlagClrWriteCmd(void) {
	vRmapWriteReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAGS_CLR_REG_OFST, (alt_u32) COMM_IRQ_RMAP_WRCMD_FLG_CLR_MSK);
}

bool bRmapCh1IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_1_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh2IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_2_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh3IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_3_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh4IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_4_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh5IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_5_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh6IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_6_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh7IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_7_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

bool bRmapCh8IrqFlagWriteCmd(void) {
	bool bFlag;

	if (uliRmapReadReg((alt_u32*) COMM_CHANNEL_8_BASE_ADDR,
	COMM_IRQ_FLAGS_REG_OFST) & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
		bFlag = TRUE;
	} else {
		bFlag = FALSE;
	}

	return bFlag;
}

alt_u32 uliRmapCh1WriteCmdAddress(void) {
	alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg(
	COMM_CHANNEL_1_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	return uliWriteAddr;
}

alt_u32 uliRmapCh2WriteCmdAddress(void) {
	alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg(
	COMM_CHANNEL_2_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	return uliWriteAddr;
}

alt_u32 uliRmapCh3WriteCmdAddress(void) {
	alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg(
	COMM_CHANNEL_3_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	return uliWriteAddr;
}

alt_u32 uliRmapCh4WriteCmdAddress(void) {
	alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg(
	COMM_CHANNEL_4_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	return uliWriteAddr;
}

alt_u32 uliRmapCh5WriteCmdAddress(void) {
	alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg(
	COMM_CHANNEL_5_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	return uliWriteAddr;
}

alt_u32 uliRmapCh6WriteCmdAddress(void) {
	alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg(
	COMM_CHANNEL_6_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	return uliWriteAddr;
}

alt_u32 uliRmapCh7WriteCmdAddress(void) {
	alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg(
	COMM_CHANNEL_7_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	return uliWriteAddr;
}

alt_u32 uliRmapCh8WriteCmdAddress(void) {
	alt_u32 uliWriteAddr;

	uliWriteAddr = uliRmapReadReg(
	COMM_CHANNEL_8_BASE_ADDR, COMM_RMAP_LST_WR_ADDR_REG_OFST);

	return uliWriteAddr;
}

// TODO: fix irq id
void vRmapInitIrq(alt_u8 ucCommCh) {
	void* pvHoldContext;
	switch (ucCommCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_A_IRQ, pvHoldContext,
				vRmapCh1HandleIrq);
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_B_IRQ, pvHoldContext,
				vRmapCh2HandleIrq);
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_C_IRQ, pvHoldContext,
				vRmapCh3HandleIrq);
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_D_IRQ, pvHoldContext,
				vRmapCh4HandleIrq);
		break;
	case eCommSpwCh5:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh5HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_E_IRQ, pvHoldContext,
				vRmapCh5HandleIrq);
		break;
	case eCommSpwCh6:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh6HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_F_IRQ, pvHoldContext,
				vRmapCh6HandleIrq);
		break;
	case eCommSpwCh7:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh7HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_G_IRQ, pvHoldContext,
				vRmapCh7HandleIrq);
		break;
	case eCommSpwCh8:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh8HoldContext;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_H_IRQ, pvHoldContext,
				vRmapCh8HandleIrq);
		break;
	}
}

bool bRmapSetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxRmapCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_IRQ_CONTROL_REG_OFST);

		if (pxRmapCh->xRmapIrqControl.bWriteCmdEn) {
			uliReg |= COMM_IRQ_RMAP_WRCMD_EN_MSK;
		} else {
			uliReg &= (~COMM_IRQ_RMAP_WRCMD_EN_MSK);
		}

		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_IRQ_CONTROL_REG_OFST,
				uliReg);
		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_IRQ_CONTROL_REG_OFST);

		if (uliReg & COMM_IRQ_RMAP_WRCMD_EN_MSK) {
			pxRmapCh->xRmapIrqControl.bWriteCmdEn = TRUE;
		} else {
			pxRmapCh->xRmapIrqControl.bWriteCmdEn = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_IRQ_FLAGS_REG_OFST);

		if (uliReg & COMM_IRQ_RMAP_WRCMD_FLG_MSK) {
			pxRmapCh->xRmapIrqFlag.bWriteCmdFlag = TRUE;
		} else {
			pxRmapCh->xRmapIrqFlag.bWriteCmdFlag = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CODEC_CFG_REG_OFST);

		uliReg &= (~COMM_RMAP_TARGET_LOG_ADDR_MSK);
		uliReg |= (COMM_RMAP_TARGET_LOG_ADDR_MSK
				& alt_u32(pxRmapCh->xRmapCodecConfig.ucLogicalAddress << 0));
		uliReg &= (~COMM_RMAP_TARGET_KEY_MSK);
		uliReg |= (COMM_RMAP_TARGET_KEY_MSK
				& alt_u32(pxRmapCh->xRmapCodecConfig.ucKey << 8));

		vRmapWriteReg(pxRmapCh->puliRmapChAddr, COMM_RMAP_CODEC_CFG_REG_OFST,
				uliReg);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CODEC_CFG_REG_OFST);

		pxRmapCh->xRmapCodecConfig.ucLogicalAddress = alt_u8(
				(uliReg & COMM_RMAP_TARGET_LOG_ADDR_MSK) >> 0);
		pxRmapCh->xRmapCodecConfig.ucKey = alt_u8(
				(uliReg & COMM_RMAP_TARGET_KEY_MSK) >> 8);

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CODEC_STAT_REG_OFST);

		if (uliReg & COMM_RMAP_STAT_CMD_RECEIVED_MSK) {
			pxRmapCh->xRmapCodecStatus.bCommandReceived = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bCommandReceived = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_WR_REQ_MSK) {
			pxRmapCh->xRmapCodecStatus.bWriteRequested = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bWriteRequested = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_WR_AUTH_MSK) {
			pxRmapCh->xRmapCodecStatus.bWriteAuthorized = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bWriteAuthorized = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_RD_REQ_MSK) {
			pxRmapCh->xRmapCodecStatus.bReadRequested = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bReadRequested = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_RD_AUTH_MSK) {
			pxRmapCh->xRmapCodecStatus.bReadAuthorized = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bReadAuthorized = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_REPLY_SEND_MSK) {
			pxRmapCh->xRmapCodecStatus.bReplySended = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bReplySended = FALSE;
		}
		if (uliReg & COMM_RMAP_STAT_DISCARD_PKG_MSK) {
			pxRmapCh->xRmapCodecStatus.bDiscardedPackage = TRUE;
		} else {
			pxRmapCh->xRmapCodecStatus.bCommandReceived = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetCodecError(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {
		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_CODEC_STAT_REG_OFST);

		if (uliReg & COMM_RMAP_ERR_EARLY_EOP_MSK) {
			pxRmapCh->xRmapCodecError.bEarlyEop = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bEarlyEop = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_EEP_MSK) {
			pxRmapCh->xRmapCodecError.bEep = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bEep = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_HEADER_CRC_MSK) {
			pxRmapCh->xRmapCodecError.bHeaderCRC = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bHeaderCRC = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_UNUSED_PKT_MSK) {
			pxRmapCh->xRmapCodecError.bUnusedPacketType = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bUnusedPacketType = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_INVALID_CMD_MSK) {
			pxRmapCh->xRmapCodecError.bInvalidCommandCode = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bInvalidCommandCode = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_TOO_MUCH_DATA_MSK) {
			pxRmapCh->xRmapCodecError.bTooMuchData = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bTooMuchData = FALSE;
		}
		if (uliReg & COMM_RMAP_ERR_INVALID_DCRC_MSK) {
			pxRmapCh->xRmapCodecError.bInvalidDataCrc = TRUE;
		} else {
			pxRmapCh->xRmapCodecError.bInvalidDataCrc = FALSE;
		}

		bStatus = TRUE;
	}

	return bStatus;
}

// TODO: function
bool bRmapSetMemConfigArea(TRmapChannel *pxRmapCh);

// TODO: function
bool bRmapGetMemConfigArea(TRmapChannel *pxRmapCh);

bool bRmapGetMemConfigStat(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	alt_u32 uliReg = 0;

	if (pxFeebCh != NULL) {

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_LST_RD_ADDR_REG_OFST);

		pxRmapCh->xRmapMemConfigStat.uliLastReadAddress = alt_u32(
				(uliReg & COMM_RMAP_LST_RD_ADDR_MSK) >> 0);

		uliReg = uliRmapReadReg(pxRmapCh->puliRmapChAddr,
		COMM_RMAP_LST_WR_ADDR_REG_OFST);

		pxRmapCh->xRmapMemConfigStat.uliLastWriteAddress = alt_u32(
				(uliReg & COMM_RMAP_LST_WR_ADDR_MSK) >> 0);

		bStatus = TRUE;
	}

	return bStatus;
}

// TODO: function
bool bRmapSetRmapMemHKArea(TRmapChannel *pxRmapCh);

// TODO: function
bool bRmapGetRmapMemHKArea(TRmapChannel *pxRmapCh);

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;

	if (pxRmapCh != NULL) {
		bStatus = TRUE;

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_1_BASE_ADDR;
			break;
		case eCommSpwCh2:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_2_BASE_ADDR;
			break;
		case eCommSpwCh3:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_3_BASE_ADDR;
			break;
		case eCommSpwCh4:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_4_BASE_ADDR;
			break;
		case eCommSpwCh5:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_5_BASE_ADDR;
			break;
		case eCommSpwCh6:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_6_BASE_ADDR;
			break;
		case eCommSpwCh7:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_7_BASE_ADDR;
			break;
		case eCommSpwCh8:
			pxRmapCh->puliRmapChAddr = (alt_u32 *) COMM_CHANNEL_8_BASE_ADDR;
			break;
		default:
			bStatus = FALSE;
			break;
		}

		if (bStatus) {
			if (!bRmapGetIrqControl(pxRmapCh)) {
				bStatus = FALSE;
			}
			if (!bRmapGetCodecConfig(pxRmapCh)) {
				bStatus = FALSE;
			}
			if (!bRmapGetCodecStatus(pxRmapCh)) {
				bStatus = FALSE;
			}
			if (!bRmapGetMemConfigArea(pxRmapCh)) {
				bStatus = FALSE;
			}
			if (!bRmapGetMemConfigStat(pxRmapCh)) {
				bStatus = FALSE;
			}
			if (!bRmapGetRmapMemHKArea(pxRmapCh)) {
				bStatus = FALSE;
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
static void vRmapWriteReg(alt_u32 *puliAddr, alt_u32 uliOffset,
		alt_u32 uliValue) {
	*(puliAddr + uliOffset) = uliValue;
}

static alt_u32 uliRmapReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}
//! [private functions]
