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
	bSuccess = bSyncSetPer((alt_u32)PER);
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

	return bSuccess;
}


bool bStartSync(void) {
	alt_u32	aux_32;
	bool bSuccess;
	bSuccess = bSyncCtrStart();
	aux_32 = bSyncIrqEnableBlank(TRUE);
	return bSuccess;
}

bool bStopSync(void) {
	return bSyncCtrReset();
}
