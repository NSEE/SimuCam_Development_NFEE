/*
 * Fee_Controller.h
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */

#ifndef FEE_CONTROLLER_H_
#define FEE_CONTROLLER_H_


#include "../simucam_definitions.h"
#include "fee.h"
#include "ccd.h"



#define N_OF_NFEE       1	/* ONLY for tests */
#define N_OF_FastFEE    2

#define N_OF_MSG_QUEUE 	12 	/* N_OF_NFEE * 2 => Two empty buffer ISRs */
#define N_MSG_FEE		4	/* The FEE entities will receive comands through the Queue, and this define is the length */

#define N_OF_MSG_QUEUE_MASK 	16 	/* N of commands in the Queue to Data controller and NFEE Controller */

typedef struct NFee_Control {
	TNFee   xNfee[N_OF_NFEE];               /* All instances of control for the NFEE */
	bool    *pbEnabledNFEEs[N_OF_NFEE];     /* Which are the NFEEs that are enabled */
	bool    *pbSimulatingNFEEs[N_OF_NFEE];     /* Which are the NFEEs that are enabled */
	unsigned char ucTimeCode;               /* Timecode [NFEESIM-UR-488]*/
	unsigned char ucIdNFEEMaster;       /* Set which N-FEE simulation is the master. [NFEESIM-UR-729]*/
	tSimucamStates sMode;
	bool 	*pbUpdateCReadOnly;
} TNFee_Control;

void vNFeeControlInit( TNFee_Control *xFeeControlL );
void vSetTimeCode( TNFee_Control *xFeeControlL, unsigned char ucTime );
void vResetTimeCode( TNFee_Control *xFeeControlL );
void vLoadDefaultIdNFEEMaster( TNFee_Control *xFeeControlL );
void vChangeIdNFEEMaster( TNFee_Control *xFeeControlL, unsigned char ucIdMaster );
void vChangeDefaultIdNFEEMaster( TNFee_Control *xFeeControlL, unsigned char ucIdMaster );



#endif /* FEE_CONTROLLER_H_ */