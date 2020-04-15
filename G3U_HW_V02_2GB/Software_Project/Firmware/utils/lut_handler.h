/*
 * lut_handler.h
 *
 *  Created on: 17 de mar de 2020
 *      Author: Tiago-note
 */

#ifndef UTILS_LUT_HANDLER_H_
#define UTILS_LUT_HANDLER_H_

#include "../simucam_definitions.h"

#define SIZE_LUT			8388608		/* Bytes - 8 MB*/
#define MEMORY_NUMBER_LUT	1			/* Which memory is the LUT*/
#define INITIAL_ADDR_LUT	2042626048	/* Initial addr 2GB - 100MB */
#define JUMP_ADDR_LUT		1024		/* Initial addr 2GB - 100MB */


/* LUT task operation modes */
typedef enum { sInitLut = 0, sConfigLut, sRunLut, sRequestFTDI, sWaitingIRQFinish, stoRequestFTDI, sFinishedFTDI } tLUTStates;


 /* LUT Struct */
typedef struct LUTStruct {
	volatile bool bUpdatedRam[N_OF_NFEE];		/* Is error injection Enabled?*/
	volatile bool bFakingLUT[N_OF_NFEE];		/* Is error injection Enabled?*/
	alt_u32 ulInitialAddr[N_OF_NFEE]; 			/* Initial Addr from RAM */
	alt_u32 ulSize; /* Error Injection Number of Error Repeats */
	alt_u8	ucDdrNumber;
	tLUTStates	eState;
} TLUTStruct;

void vLutInit( TLUTStruct *pLut  );

#endif /* UTILS_LUT_HANDLER_H_ */
