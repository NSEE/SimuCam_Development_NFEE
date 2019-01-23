/*
 * data_controller.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */


#include "data_controller.h"


void vDataControllerInit( TNData_Control *xDataControlL, TNFee_Control *xNfeeCOntrolL ) {
	unsigned char ucIL;

	for ( ucIL = 0 ; ucIL < N_OF_NFEE; ucIL++ ) {
		xDataControlL->xReadOnlyFeeControl.xNfee[ucIL] = &xNfeeCOntrolL->xNfee[ucIL];
		xDataControlL->xReadOnlyFeeControl.pbEnabledNFEEs[ucIL] = xNfeeCOntrolL->pbEnabledNFEEs[ucIL];
	}
	
	xDataControlL->xReadOnlyFeeControl.ucTimeCode = &xNfeeCOntrolL->ucTimeCode;
	xDataControlL->bUpdateComplete = FALSE;


	/* The only inverse attribution */
	/* This variable indicates when the DataControl finishs to use the RAM, then FeeControl can start fill the buffer to the next MasterSync */
	xNfeeCOntrolL->pbUpdateCReadOnly = &xDataControlL->bUpdateComplete;
}
