/**
 * @file   sync.c
 * @Author Cassio Berni (ccberni@hotmail.com)
 * @date   Novembro, 2018
 * @brief  Source File para controle sync ip via Nios-Avalon
 *
 */

#include "sync.h"

//! [data memory public global variables]
volatile alt_u8 vucN;
//! [data memory public global variables]

//! [program memory public global variables]

/* Master blank time = 400 ms */
const alt_u16 cusiSyncNFeeMasterBlankTimeMs = 400;
/* Master detection time = 300 ms */
const alt_u16 cusiSyncNFeeMasterDetectionTimeMs = 300;
/* Normal blank time = 200 ms */
const alt_u16 cusiSyncNFeeNormalBlankTimeMs = 200;
/* Sync Period = 25 s */
const alt_u16 cusiSyncNFeeSyncPeriodMs = 25000;
/* Normal pulse duration = 6.25 s */
const alt_u16 cusiSyncNFeeNormalPulseDurationMs = 6250;
/* One shot time = 500 ms */
const alt_u16 cusiSyncNFeeOneShotTimeMs = 500;
/* Blank level polarity = '1' */
const bool cbSyncNFeePulsePolarity = TRUE;
/* Number of pulses = 4 */
const alt_u8 cusiSyncNFeeNumberOfPulses = 4;

//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viSyncHoldContext;
static volatile int viPreSyncHoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

/**
 * @name    vSyncHandleIrq
 * @brief
 * @ingroup sync
 *
 * Handle sync interrupt from sync ip
 * The value stored in *context is used to control program flow
 * in the rest of this program's routines
 *
 * @param [in] void* context
 *
 * @retval void
 */
void vSyncHandleIrq(void* pvContext) {
	volatile unsigned char ucIL;
//	volatile unsigned char ucSyncL;
	unsigned char error_codel;
	tQMask uiCmdtoSend;

//	volatile int* pviSyncHoldContext = (volatile int*) pvContext;

	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;

	uiCmdtoSend.ulWord = 0;
	xGlobal.bJustBeforSync = FALSE;

	// Check Sync Irq Flags
	//	if (vpxSyncModule->xSyncIrqFlag.bErrorIrqFlag) {
	//
	//		/* Sync Error IRQ routine */
	//
	//		vpxSyncModule->xSyncIrqFlagClr.bErrorIrqFlagClr = TRUE;
	//	}
	//	if (vpxSyncModule->xSyncIrqFlag.bBlankPulseIrqFlag) {
	//
	//		/* Sync Blank Pulse IRQ routine */
	//
	//		vpxSyncModule->xSyncIrqFlagClr.bBlankPulseIrqFlagClr = TRUE;
	//	}
	if (vpxSyncModule->xSyncIrqFlag.bNormalPulseIrqFlag) {
		vpxSyncModule->xSyncIrqFlagClr.bNormalPulseIrqFlagClr = TRUE;
		/* Sync Normal Pulse IRQ routine */

		uiCmdtoSend.ucByte[2] = M_SYNC;
		xGlobal.bPreMaster = FALSE;
		xGlobal.ucEP0_3++;

	} else if (vpxSyncModule->xSyncIrqFlag.bMasterPulseIrqFlag) {
		vpxSyncModule->xSyncIrqFlagClr.bMasterPulseIrqFlagClr = TRUE;
		/* Sync Master Pulse IRQ routine */

		uiCmdtoSend.ucByte[2] = M_MASTER_SYNC;
		xGlobal.bPreMaster = FALSE;
		xGlobal.ucEP0_3 = 0;

		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;

		/* Send Priority message to the Meb Task to indicate the Sync */
		error_codel = OSQPostFront(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendMsgMasterSyncDTC();
		}
	} else if (vpxSyncModule->xSyncIrqFlag.bLastPulseIrqFlag) {
		vpxSyncModule->xSyncIrqFlagClr.bLastPulseIrqFlagClr = TRUE;
		/* Sync Last Pulse IRQ routine */
		uiCmdtoSend.ucByte[2] = M_PRE_MASTER;
		xGlobal.bPreMaster = TRUE;
		xGlobal.ucEP0_3 = 3;

		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;

		/* Send Priority message to the Meb Task to indicate the Sync */
		error_codel = OSQPostFront(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendMsgMasterSyncDTC();
		}

	}

	uiCmdtoSend.ucByte[3] = M_LUT_H_ADDR;

	/* Send Priority message to the LUT Task to indicate the Sync */
	error_codel = OSQPostFront(xLutQ, (void *) uiCmdtoSend.ulWord);
	if (error_codel != OS_ERR_NONE) {
		vFailSendMsgMasterSyncLut();
	}

	uiCmdtoSend.ucByte[3] = M_MEB_ADDR;

	/* Send Priority message to the Meb Task to indicate the Sync */
	error_codel = OSQPostFront(xMebQ, (void *) uiCmdtoSend.ulWord);
	if (error_codel != OS_ERR_NONE) {
		vFailSendMsgMasterSyncMeb();
	}

	for (ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
		if (xSimMeb.xFeeControl.xNfee[ucIL].xControl.bSimulating == TRUE) {
			uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucIL;
			error_codel = OSQPostFront(xFeeQ[ucIL], (void *) uiCmdtoSend.ulWord);
			if (error_codel != OS_ERR_NONE) {
				vFailSendMsgSync(ucIL);
			}
		}
	}

}

/**
 * @name    vSyncPreHandleIrq
 * @brief
 * @ingroup sync
 *
 * Handle pre-sync interrupt from sync ip
 * The value stored in *context is used to control program flow
 * in the rest of this program's routines
 *
 * @param [in] void* context
 *
 * @retval void
 */
void vSyncPreHandleIrq(void* pvContext) {
	volatile unsigned char ucIL;
	unsigned char error_codel;
	tQMask uiCmdtoSend;

//	volatile int* pviPreSyncHoldContext = (volatile int*) pvContext;

	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;

	uiCmdtoSend.ulWord = 0;
	xGlobal.bJustBeforSync = TRUE;

	if (vpxSyncModule->xPreSyncIrqFlag.bPreMasterPulseIrqFlag) {
		vpxSyncModule->xPreSyncIrqFlagClr.bPreMasterPulseIrqFlagClr = TRUE;
		/* Sync Master Pulse IRQ routine */
		/* Pre-Sync Blank Pulse IRQ routine */
#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMajorMessage) {
			fprintf(fp, "Pre-Master Sync Signal\n");
		}
#endif
		uiCmdtoSend.ucByte[2] = M_BEFORE_MASTER;
	} else if (vpxSyncModule->xPreSyncIrqFlag.bPreBlankPulseIrqFlag) {
		// Check Sync Irq Flags
		vpxSyncModule->xPreSyncIrqFlagClr.bPreBlankPulseIrqFlagClr = TRUE;
		/* Pre-Sync Blank Pulse IRQ routine */
#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMajorMessage) {
			fprintf(fp, "Pre-Sync Signal\n");
		}
#endif
		uiCmdtoSend.ucByte[2] = M_BEFORE_SYNC;
	}

	for (ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
		//if (xSimMeb.xFeeControl.xNfee[ucIL].xControl.bSimulating == TRUE) {
		uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucIL;
		error_codel = OSQPostFront(xFeeQ[ucIL], (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendMsgSync(ucIL);
		}
		//}
	}

	uiCmdtoSend.ucByte[3] = M_LUT_H_ADDR;

	/* Send Priority message to the LUT Task to indicate the Sync */
	error_codel = OSQPostFront(xLutQ, (void *) uiCmdtoSend.ulWord);
	if (error_codel != OS_ERR_NONE) {
		vFailSendMsgMasterSyncLut();
	}

}

void vSyncClearCounter(void) {
	// Recast the viHoldContext pointer to match the alt_irq_register() function
	// prototype.
	vucN = 0;
}

/**
 * @name    vSyncInitIrq
 * @brief
 * @ingroup sync
 *
 * Make sync interrupt initialization
 *
 * @param [in] void
 *
 * @retval void
 */
void vSyncInitIrq(void) {
	// Recast the viSyncHoldContext pointer to match the alt_irq_register() function
	// prototype.
	void* hold_context_ptr = (void*) &viSyncHoldContext;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	// Clear all flags
	vpxSyncModule->xSyncIrqFlagClr.bBlankPulseIrqFlagClr = TRUE;
	vpxSyncModule->xSyncIrqFlagClr.bNormalPulseIrqFlagClr = TRUE;
	vpxSyncModule->xSyncIrqFlagClr.bMasterPulseIrqFlagClr = TRUE;
	vpxSyncModule->xSyncIrqFlagClr.bLastPulseIrqFlagClr = TRUE;
	// Register the interrupt handler
	alt_irq_register(SYNC_SYNC_IRQ, hold_context_ptr, vSyncHandleIrq);
}

/**
 * @name    vSyncPreInitIrq
 * @brief
 * @ingroup sync
 *
 * Make pre-sync interrupt initialization
 *
 * @param [in] void
 *
 * @retval void
 */
void vSyncPreInitIrq(void) {
	// Recast the viPreSyncHoldContext pointer to match the alt_irq_register() function
	// prototype.
	void* hold_context_ptr = (void*) &viPreSyncHoldContext;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	// Clear all flags
	vpxSyncModule->xPreSyncIrqFlagClr.bPreBlankPulseIrqFlagClr = TRUE;
	vpxSyncModule->xPreSyncIrqFlagClr.bPreNormalPulseIrqFlagClr = TRUE;
	vpxSyncModule->xPreSyncIrqFlagClr.bPreMasterPulseIrqFlagClr = TRUE;
	vpxSyncModule->xPreSyncIrqFlagClr.bPreLastPulseIrqFlagClr = TRUE;
	// Register the interrupt handler
	alt_irq_register(SYNC_PRE_SYNC_IRQ, hold_context_ptr, vSyncPreHandleIrq);
}

// Status reg
/**
 * @name    bSyncStatusExtnIrq
 * @brief
 * @ingroup sync
 *
 * Read bit ExtnIrq of status reg (0 -> ext. sync / 1 -> int. sync)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncStatusExtnIrq(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncStatus.bIntExtN;
	return bResult;
}

/**
 * @name    ucSyncStatusState
 * @brief
 * @ingroup sync
 *
 * Read state byte of status reg (0 -> idle / 1 -> running / 2 -> one shot / 3 -> ErrInj)
 *
 * @param [in] void
 *
 * @retval alt_u8 result
 */
alt_u8 ucSyncStatusState(void) {
	alt_u8 ucResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	ucResult = vpxSyncModule->xSyncStatus.ucState;
	return ucResult;
}

/**
 * @name    ucSyncStatusErrorCode
 * @brief
 * @ingroup sync
 *
 * Read error code byte of status reg (0..255 -> TBD)
 *
 * @param [in] void
 *
 * @retval alt_u8 result
 */
alt_u8 ucSyncStatusErrorCode(void) {
	alt_u8 ucResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	ucResult = vpxSyncModule->xSyncStatus.ucErrorCode;
	return ucResult;
}

/**
 * @name    ucSyncStatusCycleNumber
 * @brief
 * @ingroup sync
 *
 * Read cycle number byte of status reg (0..255, tipically 0..3 (four cycles) for N-FEE, or 0 (one cycle) for F-FEE)
 *
 * @param [in] void
 *
 * @retval alt_u8 result
 */
alt_u8 ucSyncStatusCycleNumber(void) {
	alt_u8 ucResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	ucResult = vpxSyncModule->xSyncStatus.ucCycleNumber;
	return ucResult;
}

// Config regs
/**
 * @name    bSyncSetMbt
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into master blank time register (pulse duration = value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
bool bSyncSetMbt(alt_u32 uliValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncConfig.uliMasterBlankTime = uliValue;
	return TRUE;
}

/**
 * @name    bSyncSetBt
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into blank time register (pulse duration = value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
bool bSyncSetBt(alt_u32 uliValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncConfig.uliBlankTime = uliValue;
	return TRUE;
}

/**
 * @name    bSyncSetPreBt
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into pre-blank time register (pulse duration = value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
bool bSyncSetPreBt(alt_u32 uliValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncConfig.uliPreBlankTime = uliValue;
	return TRUE;
}

/**
 * @name    bSyncSetPer
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into period register (period duration =  value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
bool bSyncSetPer(alt_u32 uliValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncConfig.uliPeriod = uliValue;
	return TRUE;
}

/**
 * @name    bSyncSetOst
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into one shot time register (pulse duration =  value * 20 ns)
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
bool bSyncSetOst(alt_u32 uliValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncConfig.uliOneShotTime = uliValue;
	return TRUE;
}

/**
 * @name    bSyncSetPolarity
 * @brief
 * @ingroup sync
 *
 * Write a bool value into Polarity bit of general config register (value defines the level of blank pulses)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncSetPolarity(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncGeneralConfig.bSignalPolarity = bValue;
	return TRUE;
}

/**
 * @name    bSyncSetNCycles
 * @brief
 * @ingroup sync
 *
 * Write an alt_u8 value into nCycles field of general config register.
 * This field defines the number of cycles of a "major cycle".
 * '0' is allowed, but it´s equivalent to '1'.
 *
 * @param [in] alt_u8 value
 *
 * @retval bool TRUE
 */
bool bSyncSetNCycles(alt_u8 ucValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncGeneralConfig.ucNumberOfCycles = ucValue;
	return TRUE;
}

/**
 * @name    uliSyncGetMbt
 * @brief
 * @ingroup sync
 *
 * Read mbt config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
alt_u32 uliSyncGetMbt(void) {
	alt_u32 uliAux;

	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	uliAux = vpxSyncModule->xSyncConfig.uliMasterBlankTime;
	return uliAux;
}

/**
 * @name    uliSyncGetBt
 * @brief
 * @ingroup sync
 *
 * Read bt config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
alt_u32 uliSyncGetBt(void) {
	alt_u32 uliAux;

	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	uliAux = vpxSyncModule->xSyncConfig.uliBlankTime;
	return uliAux;
}

/**
 * @name    uliSyncGetPer
 * @brief
 * @ingroup sync
 *
 * Read per config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
alt_u32 uliSyncGetPer(void) {
	alt_u32 uliAux;

	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	uliAux = vpxSyncModule->xSyncConfig.uliPeriod;
	return uliAux;
}

/**
 * @name    uliSyncGetOst
 * @brief
 * @ingroup sync
 *
 * Read ost config register.
 *
 * @param [in] void
 *
 * @retval alt_u32 value
 */
alt_u32 uliSyncGetOst(void) {
	alt_u32 uliAux;

	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	uliAux = vpxSyncModule->xSyncConfig.uliOneShotTime;
	return uliAux;
}

// Error injection reg
/**
 * @name    bSyncErrInj
 * @brief
 * @ingroup sync
 *
 * Write an alt_u32 value into error injection register.
 * Utilization: TBD
 *
 * @param [in] alt_u32 value
 *
 * @retval bool TRUE
 */
bool bSyncErrInj(alt_u32 uliValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncErrorInjection.uliErrorInjection = uliValue;
	return TRUE;
}

// Control reg
/**
 * @name    bSyncCtrExtn
 * @brief
 * @ingroup sync
 *
 * Write a bool value into ExtnIrq bit of control register (0 -> ext. sync / 1 -> int. sync)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrIntern(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bIntExtN = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrStart
 * @brief
 * @ingroup sync
 *
 * Generate a Start command by setting Start bit of control register (1 -> Start, auto return to zero)
 * Sync ip will be taken from idle to running state
 *
 * @param [in] void
 *
 * @retval bool TRUE
 */
bool bSyncCtrStart(void) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bStart = SYNC_BIT_ON;
	return TRUE;
}

/**
 * @name    bSyncCtrReset
 * @brief
 * @ingroup sync
 *
 * Generate a Reset command by setting Reset bit of control register (1 -> Reset, auto return to zero)
 * Sync ip will be taken from any state to idle state
 *
 * @param [in] void
 *
 * @retval bool TRUE
 */
bool bSyncCtrReset(void) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bReset = SYNC_BIT_ON;
	return TRUE;
}

/**
 * @name    bSyncCtrOneShot
 * @brief
 * @ingroup sync
 *
 * Generate a OneShot command by setting OneShot bit of control register (1 -> OneShot, auto return to zero)
 * Sync ip will be taken from idle state to OneShot state
 *
 * @param [in] void
 *
 * @retval bool TRUE
 */
bool bSyncCtrOneShot(void) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bOneShot = SYNC_BIT_ON;
	return TRUE;
}

/**
 * @name    bSyncCtrErrInj
 * @brief
 * @ingroup sync
 *
 * Generate a ErrInj command by setting ErrInj bit of control register (1 -> ErrInj, auto return to zero)
 * Sync ip will be taken from idle state to error injection state
 *
 * @param [in] void
 *
 * @retval bool TRUE
 */
bool bSyncCtrErrInj(void) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bErrInj = SYNC_BIT_ON;
	return TRUE;
}

/**
 * @name    bSyncCtrSyncOutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into sync_out enable bit of control register (0 -> sync_out disable / 1 -> sync_out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrSyncOutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bOutEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrCh1OutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into cha_out enable bit of control register (0 -> ch A sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrCh1OutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel1En = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrCh2OutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chb_out enable bit of control register (0 -> ch B sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrCh2OutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel2En = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrCh3OutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chc_out enable bit of control register (0 -> ch C sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrCh3OutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel3En = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrCh4OutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chd_out enable bit of control register (0 -> ch D sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrCh4OutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel4En = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrCh5OutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into che_out enable bit of control register (0 -> ch E sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrCh5OutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel5En = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrCh6OutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chf_out enable bit of control register (0 -> ch F sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrCh6OutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel6En = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrCh7OutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chg_out enable bit of control register (0 -> ch G sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrCh7OutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel7En = bValue;
	return TRUE;
}

/**
 * @name    bSyncCtrCh8OutEnable
 * @brief
 * @ingroup sync
 *
 * Write a bool value into chh_out enable bit of control register (0 -> ch H sync out disable / 1 -> ch A sync out enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrCh8OutEnable(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel8En = bValue;
	return TRUE;
}

// Irq enable register
/**
 * @name    bSyncIrqEnableError
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq error enable bit of irq enable register (0 -> irq error disable / 1 -> irq error enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableError(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bErrorIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqEnableBlankPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq blank pulse enable bit of irq enable register (0 -> irq blank pulse disable / 1 -> irq blank pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableBlankPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bBlankPulseIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqEnableMasterPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq master pulse enable bit of irq enable register (0 -> irq master pulse disable / 1 -> irq master pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableMasterPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bMasterPulseIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqEnableNormalPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq normal pulse enable bit of irq enable register (0 -> irq normal pulse disable / 1 -> irq normal pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableNormalPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bNormalPulseIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqEnableLastPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq last pulse enable bit of irq enable register (0 -> irq last pulse disable / 1 -> irq last pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableLastPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bLastPulseIrqEn = bValue;
	return TRUE;
}

// Irq flag clear register
/**
 * @name    bSyncIrqFlagClrError
 * @brief
 * @ingroup sync
 *
 * Write a bool value into error bit of irq flag clear register (0 -> keep irq error flag unchanged / 1 -> clear irq error flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrError(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bErrorIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqFlagClrBlankPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into blank pulse bit of irq flag clear register (0 -> keep irq blank pulse flag unchanged / 1 -> clear irq blank pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrBlankPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bBlankPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqFlagClrMasterPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into master pulse bit of irq flag clear register (0 -> keep irq master pulse flag unchanged / 1 -> clear irq master pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrMasterPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bMasterPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqFlagClrNormalPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into normal pulse bit of irq flag clear register (0 -> keep irq normal pulse flag unchanged / 1 -> clear irq normal pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrNormalPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bNormalPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqFlagClrLastPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into last pulse bit of irq flag clear register (0 -> keep irq last pulse flag unchanged / 1 -> clear irq last pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrLastPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bLastPulseIrqFlagClr = bValue;
	return TRUE;
}

// Irq flag reg
/**
 * @name    bSyncIrqFlagError
 * @brief
 * @ingroup sync
 *
 * Read irq error flag bit of irq flag reg (0 -> no error int. occured / 1 -> error int. occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagError(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bErrorIrqFlag;
	return bResult;
}

/**
 * @name    bSyncIrqFlagBlankPulse
 * @brief
 * @ingroup sync
 *
 * Read irq blank pulse flag bit of irq flag reg (0 -> no irq blank pulse occured / 1 -> irq blank pulse occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagBlankPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bBlankPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncIrqFlagMasterPulse
 * @brief
 * @ingroup sync
 *
 * Read irq master pulse flag bit of irq flag reg (0 -> no irq master pulse occured / 1 -> irq master pulse occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagMasterPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bMasterPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncIrqFlagNormalPulse
 * @brief
 * @ingroup sync
 *
 * Read irq normal pulse flag bit of irq flag reg (0 -> no irq normal pulse occured / 1 -> irq normal pulse occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagNormalPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bNormalPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncIrqFlagLastPulse
 * @brief
 * @ingroup sync
 *
 * Read irq last pulse flag bit of irq flag reg (0 -> no irq last pulse occured / 1 -> irq last pulse occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagLastPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bLastPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncPreIrqEnableBlankPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq pre-blank pulse enable bit of irq enable register (0 -> irq pre-blank pulse disable / 1 -> irq pre-blank pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncPreIrqEnableBlankPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xPreSyncIrqEn.bPreBlankPulseIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncPreIrqEnableMasterPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq pre-master pulse enable bit of irq enable register (0 -> irq pre-master pulse disable / 1 -> irq pre-master pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncPreIrqEnableMasterPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xPreSyncIrqEn.bPreMasterPulseIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncPreIrqEnableNormalPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq pre-normal pulse enable bit of irq enable register (0 -> irq pre-normal pulse disable / 1 -> irq pre-normal pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncPreIrqEnableNormalPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xPreSyncIrqEn.bPreNormalPulseIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncPreIrqEnableLastPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into irq pre-last pulse enable bit of irq enable register (0 -> irq blank pre-last pulse disable / 1 -> irq blank pre-last pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncPreIrqEnableLastPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xPreSyncIrqEn.bPreLastPulseIrqEn = bValue;
	return TRUE;
}

// Irq flag clear register
/**
 * @name    bSyncPreIrqFlagClrBlankPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into pre-blank pulse bit of irq flag clear register (0 -> keep irq pre-blank pulse flag unchanged / 1 -> clear irq pre-blank pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncPreIrqFlagClrBlankPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xPreSyncIrqFlagClr.bPreBlankPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncPreIrqFlagClrMasterPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into pre-master pulse bit of irq flag clear register (0 -> keep irq pre-master pulse flag unchanged / 1 -> clear irq pre-master pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncPreIrqFlagClrMasterPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xPreSyncIrqFlagClr.bPreMasterPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncPreIrqFlagClrNormalPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into pre-normal pulse bit of irq flag clear register (0 -> keep irq pre-normal pulse flag unchanged / 1 -> clear irq pre-normal pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncPreIrqFlagClrNormalPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xPreSyncIrqFlagClr.bPreNormalPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncPreIrqFlagClrLastPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into pre-last pulse bit of irq flag clear register (0 -> keep irq pre-last pulse flag unchanged / 1 -> clear irq pre-last pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncPreIrqFlagClrLastPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	vpxSyncModule->xPreSyncIrqFlagClr.bPreLastPulseIrqFlagClr = bValue;
	return TRUE;
}

// Irq flag reg
/**
 * @name    bSyncPreIrqFlagBlankPulse
 * @brief
 * @ingroup sync
 *
 * Read irq pre-blank pulse flag bit of irq flag reg (0 -> no irq pre-blank pulse occured / 1 -> irq pre-blank pulse occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncPreIrqFlagBlankPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xPreSyncIrqFlag.bPreBlankPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncPreIrqFlagMasterPulse
 * @brief
 * @ingroup sync
 *
 * Read irq pre-master pulse flag bit of irq flag reg (0 -> no irq pre-master pulse occured / 1 -> irq pre-master pulse occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncPreIrqFlagMasterPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xPreSyncIrqFlag.bPreMasterPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncPreIrqFlagNormalPulse
 * @brief
 * @ingroup sync
 *
 * Read irq pre-normal pulse flag bit of irq flag reg (0 -> no irq pre-normal pulse occured / 1 -> irq pre-normal pulse occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncPreIrqFlagNormalPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xPreSyncIrqFlag.bPreNormalPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncPreIrqFlagLastPulse
 * @brief
 * @ingroup sync
 *
 * Read irq pre-last pulse flag bit of irq flag reg (0 -> no irq pre-last pulse occured / 1 -> irq pre-last pulse occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncPreIrqFlagLastPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xPreSyncIrqFlag.bPreLastPulseIrqFlag;
	return bResult;
}

/* Configure the entire Sync Period for a N-FEE (default: 25.0 s) */
bool bSyncConfigNFeeSyncPeriod(alt_u16 usiSyncPeriodMs) {
	bool bSuccess;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;

	if (cusiSyncNFeeSyncPeriodMs <= usiSyncPeriodMs) {

		const alt_u16 cusiLastPulsePeriodMs = usiSyncPeriodMs - (cusiSyncNFeeNormalPulseDurationMs * (cusiSyncNFeeNumberOfPulses - 1));

		vpxSyncModule->xSyncGeneralConfig.ucNumberOfCycles = cusiSyncNFeeNumberOfPulses;
		vpxSyncModule->xSyncGeneralConfig.bSignalPolarity = cbSyncNFeePulsePolarity;
		vpxSyncModule->xSyncConfig.uliPreBlankTime = uliPerCalcPeriodMs(100);
		vpxSyncModule->xSyncConfig.uliMasterBlankTime = uliPerCalcPeriodMs(cusiSyncNFeeNormalPulseDurationMs - cusiSyncNFeeMasterBlankTimeMs);
		vpxSyncModule->xSyncConfig.uliBlankTime = uliPerCalcPeriodMs(cusiSyncNFeeNormalPulseDurationMs - cusiSyncNFeeNormalBlankTimeMs);
		vpxSyncModule->xSyncConfig.uliLastBlankTime = uliPerCalcPeriodMs(cusiLastPulsePeriodMs - cusiSyncNFeeMasterBlankTimeMs);
		vpxSyncModule->xSyncConfig.uliPeriod = uliPerCalcPeriodMs(cusiSyncNFeeNormalPulseDurationMs);
		vpxSyncModule->xSyncConfig.uliLastPeriod = uliPerCalcPeriodMs(cusiLastPulsePeriodMs);
		vpxSyncModule->xSyncConfig.uliMasterDetectionTime = uliPerCalcPeriodMs(cusiSyncNFeeMasterDetectionTimeMs);
		vpxSyncModule->xSyncConfig.uliOneShotTime = uliPerCalcPeriodMs(cusiSyncNFeeOneShotTimeMs);

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlCriticalOnly) {
			fprintf(fp, "\nSync Module Configuration:\n");
			fprintf(fp, "xSyncModule.ucNumberOfCycles = %u \n", vpxSyncModule->xSyncGeneralConfig.ucNumberOfCycles);
			fprintf(fp, "xSyncModule.bSignalPolarity = %u \n", vpxSyncModule->xSyncGeneralConfig.bSignalPolarity);
			fprintf(fp, "xSyncModule.uliPreBlankTime = %u ms \n", usiRegCalcTimeMs(vpxSyncModule->xSyncConfig.uliPreBlankTime));
			fprintf(fp, "xSyncModule.uliMasterBlankTime = %u ms \n", usiRegCalcTimeMs(vpxSyncModule->xSyncConfig.uliPeriod - vpxSyncModule->xSyncConfig.uliMasterBlankTime));
			fprintf(fp, "xSyncModule.uliBlankTime = %u ms \n", usiRegCalcTimeMs(vpxSyncModule->xSyncConfig.uliPeriod - vpxSyncModule->xSyncConfig.uliBlankTime));
			fprintf(fp, "xSyncModule.uliLastBlankTime = %u ms \n", usiRegCalcTimeMs(vpxSyncModule->xSyncConfig.uliLastPeriod - vpxSyncModule->xSyncConfig.uliLastBlankTime));
			fprintf(fp, "xSyncModule.uliPeriod = %u ms \n", usiRegCalcTimeMs(vpxSyncModule->xSyncConfig.uliPeriod));
			fprintf(fp, "xSyncModule.uliLastPeriod = %u ms \n", usiRegCalcTimeMs(vpxSyncModule->xSyncConfig.uliLastPeriod));
			fprintf(fp, "xSyncModule.uliMasterDetectionTime = %u ms \n", usiRegCalcTimeMs(vpxSyncModule->xSyncConfig.uliMasterDetectionTime));
			fprintf(fp, "xSyncModule.uliOneShotTime = %u ms \n", usiRegCalcTimeMs(vpxSyncModule->xSyncConfig.uliOneShotTime));
			fprintf(fp, "\n");
		}
#endif

		bSuccess = TRUE;
	} else {
#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlCriticalOnly) {
			fprintf(fp, "\nSync Module Configuration Failure!! Period is to small\n");
		}
#endif
	}

	return bSuccess;
}

//! [private functions]

/*
 * Return the necessary PER value for a
 * Sync Signal period in usiPeriodMs ms.
 */
alt_u32 uliPerCalcPeriodMs(alt_u16 usiPeriodMs) {

	/*
	 * Period = PER * ClkCycles@50MHz
	 * PER = Period / ClkCycles@50MHz
	 *
	 * ClkCycles@50MHz = 20 ns = 20e-6 ms
	 *
	 * Period[ms] / 20e-6 = Period[ms] * 5e+4
	 * PER = Period[ms] * 5e+4
	 */

	alt_u32 uliPer;
	uliPer = usiPeriodMs * 5e+4;

	return uliPer;
}

/*
 * Return the time value, in ms, for a Sync register.
 */
alt_u16 usiRegCalcTimeMs(alt_u32 uliSyncReg) {

	/*
	 * Time = Register * ClkCycles@50MHz
	 *
	 * ClkCycles@50MHz = 20 ns = 20e-6 ms
	 *
	 * Time[ms] = Register[-] * 20e-6
	 */

	alt_u16 usiTimeMs;
	usiTimeMs = uliSyncReg * 20e-6;

	return usiTimeMs;
}
