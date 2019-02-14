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

	bSuccess = bSdmaInitM1Dma();
	if (bSuccess==FALSE) {
		return bSuccess;
	}

	bSuccess = bSdmaInitM2Dma();
	if (bSuccess==FALSE) {
		return bSuccess;
	}

	//xDma[0].pDmaTranfer = bSdmaDmaM1Transfer;
	//xDma[0].pDmaTranfer = bSdmaDmaM2Transfer;


	return TRUE;
}
