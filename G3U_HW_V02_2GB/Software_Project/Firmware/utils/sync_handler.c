/*
 * sync_handle.c
 *
 *  Created on: 25/01/2019
 *      Author: Tiago-note
 */

#include "sync_handler.h"

/* todo: Create a struct that will contain all config, and pass as parameter to the functions */

bool bInitSync( void ) {
	bool	bSuccess;

	#if DEBUG_ON
	if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
		debug(fp, "Initializing Sync Module.\n");
	}
	#endif

	// Configura um padrão de sync interno, periodo padrao = 25 s
	bSuccess = bSyncConfigNFeeSyncPeriod( xDefaults.usiExposurePeriod );
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Altera mux para sync intern
	bSuccess = bSyncCtrIntern(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Habilita sync_out enable (deve aparecer na saída o sync int.)
	bSuccess = bSyncCtrSyncOutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Habilita sync_out_ch1 enable (libera sync para o Ch 1)
	bSuccess = bSyncCtrCh1OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Habilita sync_out_ch2 enable (libera sync para o Ch 2)
	bSuccess = bSyncCtrCh2OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Habilita sync_out_ch3 enable (libera sync para o Ch 3)
	bSuccess = bSyncCtrCh3OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Habilita sync_out_ch4 enable (libera sync para o Ch 4)
	bSuccess = bSyncCtrCh4OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Habilita sync_out_ch5 enable (libera sync para o Ch 5)
	bSuccess = bSyncCtrCh5OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Habilita sync_out_ch6 enable (libera sync para o Ch 6)
	bSuccess = bSyncCtrCh6OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	// Habilita sync_out_ch7 enable (libera sync para o Ch 7)
	bSuccess = bSyncCtrCh7OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		return bSuccess;
	}

	bSuccess = bSyncCtrStart();
	bSyncCtrReset();

	vSyncInitIrq();
	vSyncPreInitIrq();

	bSyncIrqEnableMasterPulse(TRUE);
	bSyncIrqEnableNormalPulse(TRUE);
	bSyncIrqEnableLastPulse(TRUE);

	bSyncPreIrqEnableBlankPulse(TRUE);
	bSyncPreIrqEnableMasterPulse(TRUE);

	return bSuccess;
}

bool bStartSync(void) {

	bool bSuccess;
	bSyncCtrReset();
	bSuccess = bSyncCtrStart();

	return bSuccess;
}

bool bStopSync(void) {
	return bSyncCtrReset();
}

bool bClearSync(void){

	bool bSuccess;

	bSuccess = bSyncCtrIntern(TRUE); /*TRUE = Internal*/

	/* Disable all sync IRQs [rfranca] */
	bSyncIrqEnableError(FALSE);
	bSyncIrqEnableBlankPulse(FALSE);
	bSyncIrqEnableMasterPulse(FALSE);
	bSyncIrqEnableNormalPulse(FALSE);
	bSyncIrqEnableLastPulse(FALSE);
	bSyncPreIrqEnableBlankPulse(FALSE);
	bSyncPreIrqEnableMasterPulse(FALSE);
	bSyncPreIrqEnableNormalPulse(FALSE);
	bSyncPreIrqEnableLastPulse(FALSE);
	/* Clear all sync IRQ Flags [rfranca] */
	bSyncIrqFlagClrError(TRUE);
	bSyncIrqFlagClrBlankPulse(TRUE);
	bSyncIrqFlagClrMasterPulse(TRUE);
	bSyncIrqFlagClrNormalPulse(TRUE);
	bSyncIrqFlagClrLastPulse(TRUE);
	bSyncPreIrqFlagClrBlankPulse(TRUE);
	bSyncPreIrqFlagClrMasterPulse(TRUE);
	bSyncPreIrqFlagClrNormalPulse(TRUE);
	bSyncPreIrqFlagClrLastPulse(TRUE);
	/* Enable relevant sync IRQs [rfranca] */
	bSyncIrqEnableMasterPulse(TRUE);
	bSyncIrqEnableNormalPulse(TRUE);
	bSyncIrqEnableLastPulse(TRUE);
	bSyncPreIrqEnableBlankPulse(TRUE);
	bSyncPreIrqEnableMasterPulse(TRUE);

	return bSuccess;
}

void bClearCounterSync(void) {
	vSyncClearCounter();
}
