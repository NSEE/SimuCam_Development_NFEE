/*
 * data_controller.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */


#include "data_controller.h"


void vDataControllerInit( TNData_Control *xDataControlL, TNFee_Control *xNfeeCOntrolL ) {
	unsigned char ucIL;

	xDataControlL->sMode = sMebInit;

	for ( ucIL = 0 ; ucIL < N_OF_NFEE; ucIL++ ) {
		xDataControlL->xReadOnlyFeeControl.xNfee[ucIL] = &xNfeeCOntrolL->xNfee[ucIL];
		/* We need the same structure of the FEE_Control to manipulate the data load of the memory, MEMORY MAP ONLY, this will not be updated, so we still need the xReadOnlyFeeControl */
		xDataControlL->xCopyNfee[ucIL] = xNfeeCOntrolL->xNfee[ucIL];
		xDataControlL->xReadOnlyFeeControl.pbEnabledNFEEs[ucIL] = xNfeeCOntrolL->pbEnabledNFEEs[ucIL];
		xDataControlL->bInsgestionSchedule[ucIL] = FALSE;
		xDataControlL->ucMoreThan2MSyncWithoutUpdate[ucIL] = FALSE;
	}
	
	xDataControlL->xReadOnlyFeeControl.ucTimeCode = &xNfeeCOntrolL->ucTimeCode;
	xDataControlL->bUpdateComplete = FALSE;
	xDataControlL->usiEPn = 0;

	/* The only inverse attribution */
	/* This variable indicates when the DataControl finishs to use the RAM, then FeeControl can start fill the buffer to the next MasterSync */
	xNfeeCOntrolL->pbUpdateCReadOnly = &xDataControlL->bUpdateComplete;
}
