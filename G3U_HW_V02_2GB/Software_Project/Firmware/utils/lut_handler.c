/*
 * LutHandler.c
 *
 *  Created on: 17 de mar de 2020
 *      Author: Tiago-note
 */

#include "lut_handler.h"

void vLutInit( TLUTStruct *pLut ) {
	unsigned char ucIL;

	for (ucIL = 0; ucIL < N_OF_NFEE; ucIL++) {
		pLut->bUpdatedRam[ucIL] = FALSE;
		pLut->bFakingLUT[ucIL] = FALSE;
		pLut->ulInitialAddr[ucIL] = INITIAL_ADDR_LUT + ucIL*JUMP_ADDR_LUT + ucIL*SIZE_LUT;
	}

	pLut->eState = sInitLut;
	pLut->ucDdrNumber = MEMORY_NUMBER_LUT;
	pLut->ulSize = SIZE_LUT;
}

/*#define SIZE_LUT	‭		8388608‬
#define MEMORY_NUMBER_LUT	‭1
#define INITIAL_ADDR_LUT	‭‭2042626048‬	*/
