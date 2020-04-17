/*
 * test_module_simucam.c
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */


#include "test_module_simucam.h"

bool bTestSimucamCriticalHW( void ) {
	bool bSuccess;

	/*
	 * Verificar com Fran�a quais testes podemos realizar aqui
	 * SDcard para criar logs e pegar defaults
	 */

	bSuccess = bSdmaInitCh1Dmas();
	if (bSuccess==FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the DMAs for Channel 1.\n");
		}
		#endif
		return bSuccess;
	}

	bSuccess = bSdmaInitCh2Dmas();
	if (bSuccess==FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the DMAs for Channel 2.\n");
		}
		#endif
		return bSuccess;
	}

	bSuccess = bSdmaInitCh3Dmas();
	if (bSuccess==FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the DMAs for Channel 3.\n");
		}
		#endif
		return bSuccess;
	}

	bSuccess = bSdmaInitCh4Dmas();
	if (bSuccess==FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the DMAs for Channel 4.\n");
		}
		#endif
		return bSuccess;
	}

	bSuccess = bSdmaInitCh5Dmas();
	if (bSuccess==FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the DMAs for Channel 5.\n");
		}
		#endif
		return bSuccess;
	}

	bSuccess = bSdmaInitCh6Dmas();
	if (bSuccess==FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the DMAs for Channel 6.\n");
		}
		#endif
		return bSuccess;
	}

	bSuccess = bSdmaInitFtdiRxDma();
	if (bSuccess==FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the Rx DMA for FTDI.\n");
		}
		#endif
		return bSuccess;
	}

	bSuccess = bSdmaInitFtdiTxDma();
	if (bSuccess==FALSE) {
		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
			debug(fp, "SimuCam Critical HW Test: CRITICAL! Could not initiate the Tx DMA for FTDI.\n");
		}
		#endif
		return bSuccess;
	}

	//xDma[0].pDmaTranfer = bSdmaDmaM1Transfer;
	//xDma[0].pDmaTranfer = bSdmaDmaM2Transfer;

	return TRUE;
}
