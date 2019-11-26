/*
 * data_controller.h
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */

#ifndef DATA_CONTROLLER_H_
#define DATA_CONTROLLER_H_


#include "../simucam_definitions.h"
#include "fee_controller.h"
#include "feeV2.h"
#include "ccd.h"

typedef enum { sSubInit  = 0, sSubMemUpdated, sSubSetupEpoch, sSubRequest, sSubWaitIRQBuffer, sSubScheduleDMA, sSubLastPckt, sWaitForEmptyBufferIRQ } tDTCSubStates;

typedef struct NFee_CtrlReadOnly {
	TNFee   *xNfee[N_OF_NFEE];               /* All instances of control for the NFEE */
	bool    *pbEnabledNFEEs[N_OF_NFEE];     /* Which are the NFEEs that are enabled */
	unsigned char *ucTimeCode;               /* Timecode [NFEESIM-UR-488]*/
} TNFee_CtrlReadOnly;


/* Data Controller for a Simucam of NFEEs.
 * The data controller is responsible for prepare the Ram memory for the N+1 master sync Simulation */
typedef struct NData_Control {
	unsigned char ucMoreThan2MSyncWithoutUpdate[N_OF_NFEE];
	bool bInsgestionSchedule[N_OF_NFEE];
	OS_EVENT *xSemDmaAccess[N_OF_NFEE];
	TNFee_CtrlReadOnly xReadOnlyFeeControl;
	bool bUpdateComplete;
	tSimucamStates sMode;
	volatile tDTCSubStates sRunMode;
	unsigned char *pNextMem;				/* Point to the actual memory in simulation */
	TNFee   xCopyNfee[N_OF_NFEE];           /* All instances of control for the NFEE */
	unsigned short int usiEPn;
	bool bFirstMaster;
} TNData_Control; /* Read Only Structure */

void vDataControllerInit( TNData_Control *xDataControlL, TNFee_Control *xNfeeCOntrolL );

#endif /* DATA_CONTROLLER_H_ */
