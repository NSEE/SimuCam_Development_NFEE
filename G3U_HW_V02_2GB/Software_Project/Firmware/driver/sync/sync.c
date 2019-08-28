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
//! [program memory public global variables]

//! [data memory private global variables]
const alt_u8 ucSyncIrqFlagsQtd = 5;
// A variable to hold the context of interrupt
static volatile int viHoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

/**
 * @name    vSyncHandleIrq
 * @brief
 * @ingroup sync
 *
 * Handle interrupt from sync ip
 * The value stored in *context is used to control program flow
 * in the rest of this program's routines
 *
 * @param [in] void* context
 *
 * @retval void
 */
void vSyncHandleIrq(void* pvContext) {
	volatile unsigned char ucIL;
	volatile unsigned char ucSyncL;
	unsigned char error_codel;
	tQMask uiCmdtoSend;

//	volatile int* pviHoldContext = (volatile int*) pvContext;

	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;

	// Check Sync Irq Flags
	if (vpxSyncModule->xSyncIrqFlag.bErrorIrqFlag) {

		/* Sync Error IRQ routine */

		vpxSyncModule->xSyncIrqFlagClr.bErrorIrqFlagClr = TRUE;
	}
	if (vpxSyncModule->xSyncIrqFlag.bBlankPulseIrqFlag) {

		/* Sync Blank Pulse IRQ routine */

		uiCmdtoSend.ulWord = 0;
		/* MasterSync? */
		ucSyncL = (vucN % 4);
		if ( ucSyncL == 0 )
			uiCmdtoSend.ucByte[2] = M_MASTER_SYNC;
		else if ( ucSyncL == 3 ) {
			uiCmdtoSend.ucByte[2] = M_PRE_MASTER;
		} else
			uiCmdtoSend.ucByte[2] = M_SYNC;

		uiCmdtoSend.ucByte[3] = M_MEB_ADDR;

		/* Send Priority message to the Meb Task to indicate the Master Sync */
		error_codel = OSQPostFront(xMebQ, (void *)uiCmdtoSend.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendMsgMasterSyncMeb( );
		}

		for( ucIL = 0; ucIL < N_OF_NFEE; ucIL++ ){
			if (xSimMeb.xFeeControl.xNfee[ucIL].xControl.bSimulating == TRUE) {
				uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucIL;
				error_codel = OSQPostFront(xFeeQ[ ucIL ], (void *)uiCmdtoSend.ulWord);
				if ( error_codel != OS_ERR_NONE ) {
					vFailSendMsgSync( ucIL );
				}
			}
		}

		vucN += 1;

		vpxSyncModule->xSyncIrqFlagClr.bBlankPulseIrqFlagClr = TRUE;
	}
	if (vpxSyncModule->xSyncIrqFlag.bMasterPulseIrqFlag) {

		/* Sync Master Pulse IRQ routine */

		vpxSyncModule->xSyncIrqFlagClr.bMasterPulseIrqFlagClr = TRUE;
	}
	if (vpxSyncModule->xSyncIrqFlag.bNormalPulseIrqFlag) {

		/* Sync Normal Pulse IRQ routine */

		vpxSyncModule->xSyncIrqFlagClr.bNormalPulseIrqFlagClr = TRUE;
	}
	if (vpxSyncModule->xSyncIrqFlag.bLastPulseIrqFlag) {

		/* Sync Last Pulse IRQ routine */

		vpxSyncModule->xSyncIrqFlagClr.bLastPulseIrqFlagClr = TRUE;
	}

	if ( vucN >= 252 ) /*Precisa zerar no módulo 4*/
		vucN = 0;
	else
		vucN += 1;

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
 * Make interrupt initialization
 *
 * @param [in] void
 *
 * @retval void
 */
void vSyncInitIrq(void) {
	// Recast the viHoldContext pointer to match the alt_irq_register() function
	// prototype.
	void* hold_context_ptr = (void*) &viHoldContext;
	// Register the interrupt handler
	alt_irq_register(SYNC_IRQ, hold_context_ptr, vSyncHandleIrq);
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncConfig.uliBlankTime = uliValue;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
 * '0' is allowed, but itÂ´s equivalent to '1'.
 *
 * @param [in] alt_u8 value
 *
 * @retval bool TRUE
 */
bool bSyncSetNCycles(alt_u8 ucValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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

	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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

	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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

	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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

	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncErrorInjection.uliErrorInjection = uliValue;
	return TRUE;
}

// Control reg
/**
 * @name    bSyncCtrExtnIrq
 * @brief
 * @ingroup sync
 *
 * Write a bool value into ExtnIrq bit of control register (0 -> ext. sync / 1 -> int. sync)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncCtrExtnIrq(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
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
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncControl.bChannel8En = bValue;
	return TRUE;
}

// Int enable register
/**
 * @name    bSyncIrqEnableError
 * @brief
 * @ingroup sync
 *
 * Write a bool value into int error enable bit of int enable register (0 -> int error disable / 1 -> int error enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableError(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bErrorIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqEnableBlankPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into int blank pulse enable bit of int enable register (0 -> int blank pulse disable / 1 -> int blank pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableBlankPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bBlankPulseIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqEnableMasterPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into int master pulse enable bit of int enable register (0 -> int master pulse disable / 1 -> int master pulse enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableMasterPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bMasterPulseIrqEn = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqEnableNormalPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into int normal pulse enable bit of int enable register (0 -> int blank normal disable / 1 -> int blank normal enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableNormalPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bNormalPulseIrq = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqEnableLastPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into int last pulse enable bit of int enable register (0 -> int blank last disable / 1 -> int blank last enable)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqEnableLastPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqEn.bLastPulseIrqEn = bValue;
	return TRUE;
}

// Int flag clear register
/**
 * @name    bSyncIrqFlagClrError
 * @brief
 * @ingroup sync
 *
 * Write a bool value into error bit of int flag clear register (0 -> keep int error flag unchanged / 1 -> clear int error flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrError(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bErrorIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqFlagClrBlankPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into blank pulse bit of int flag clear register (0 -> keep int blank pulse flag unchanged / 1 -> clear int blank pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrBlankPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bBlankPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqFlagClrMasterPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into master pulse bit of int flag clear register (0 -> keep int master pulse flag unchanged / 1 -> clear int master pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrMasterPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bMasterPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqFlagClrNormalPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into normal pulse bit of int flag clear register (0 -> keep int normal pulse flag unchanged / 1 -> clear int normal pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrNormalPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bNormalPulseIrqFlagClr = bValue;
	return TRUE;
}

/**
 * @name    bSyncIrqFlagClrLastPulse
 * @brief
 * @ingroup sync
 *
 * Write a bool value into last pulse bit of int flag clear register (0 -> keep int last pulse flag unchanged / 1 -> clear int last pulse flag)
 *
 * @param [in] bool value
 *
 * @retval bool TRUE
 */
bool bSyncIrqFlagClrLastPulse(bool bValue) {
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	vpxSyncModule->xSyncIrqFlagClr.bLastPulseIrqFlagClr = bValue;
	return TRUE;
}

// Int flag reg
/**
 * @name    bSyncIrqFlagError
 * @brief
 * @ingroup sync
 *
 * Read int error flag bit of int flag reg (0 -> no error int. occured / 1 -> error int. occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagError(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bErrorIrqFlag;
	return bResult;
}

/**
 * @name    bSyncIrqFlagBlankPulse
 * @brief
 * @ingroup sync
 *
 * Read int blank pulse flag bit of int flag reg (0 -> no int blank pulse occured / 1 -> int error occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagBlankPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bBlankPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncIrqFlagMasterPulse
 * @brief
 * @ingroup sync
 *
 * Read int master pulse flag bit of int flag reg (0 -> no int master pulse occured / 1 -> int error occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagMasterPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bMasterPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncIrqFlagNormalPulse
 * @brief
 * @ingroup sync
 *
 * Read int normal pulse flag bit of int flag reg (0 -> no int normal pulse occured / 1 -> int error occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagNormalPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bNormalPulseIrqFlag;
	return bResult;
}

/**
 * @name    bSyncIrqFlagLastPulse
 * @brief
 * @ingroup sync
 *
 * Read int last pulse flag bit of int flag reg (0 -> no int last pulse occured / 1 -> int error occured)
 *
 * @param [in] void
 *
 * @retval bool result
 */
bool bSyncIrqFlagLastPulse(void) {
	bool bResult;
	volatile TSyncModule *vpxSyncModule = (TSyncModule *)SYNC_BASE_ADDR;
	bResult = vpxSyncModule->xSyncIrqFlag.bLastPulseIrqFlag;
	return bResult;
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
