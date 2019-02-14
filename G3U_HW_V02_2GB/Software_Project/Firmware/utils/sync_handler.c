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
	alt_u32	aux_32;

	vSyncInitIrq();

	#ifdef DEBUG_ON
		debug(fp, "Initializing Sync Module.\n");
	#endif

	// Configura um padrão de sync interno
	// MBT => 400 ms @ 20 ns (50 MHz)
	bSuccess = bSyncSetMbt(MBT);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}

	// BT => 200 ms @ 20 ns (50 MHz)
	bSuccess = bSyncSetBt(BT);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}

	// PER => 6,25s @ 20 ns (50 MHz)
	bSuccess = bSyncSetPer(  uliPerCalcPeriodMs( xDefaults.usiSyncPeriod ) );
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}

	// OST => 500 ms @ 20 ns (50 MHz)
	bSuccess = bSyncSetOst(OST);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}


	// Polaridade
	bSuccess = bSyncSetPolarity(POL);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}

	// N. de ciclos
	bSuccess = bSyncSetNCycles(N_CICLOS);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}

	// Altera mux para sync interno
	bSuccess = bSyncCtrExtnIrq(TRUE);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}

	// Habilita sync_out enable (deve aparecer na saída o sync int.)
	bSuccess = bSyncCtrSyncOutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}


	// Habilita sync_out_ch1 enable (libera sync para o Ch 1)
	bSuccess = bSyncCtrCh1OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}

	// Habilita sync_out_ch1 enable (libera sync para o Ch 1)
	bSuccess = bSyncCtrCh2OutEnable(TRUE);
	if ( bSuccess == FALSE ) {
		#ifdef DEBUG_ON
			debug(fp, "Sync Init: Temp Error.\n");
		#endif
		return bSuccess;
	}

	bSuccess = bSyncCtrStart();
	bSyncCtrReset();
	aux_32 = bSyncIrqEnableBlank(TRUE);


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

void bClearCounterSync(void) {

	vSyncClearCounter();
}
