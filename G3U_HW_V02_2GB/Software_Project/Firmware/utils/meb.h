/*
 * meb.h
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#ifndef MEB_H_
#define MEB_H_

#include "../simucam_definitions.h"
#include "fee_controller.h"
#include "data_controller.h"
#include "fee.h"
#include "ccd.h"



/* Simucam operation modes */
typedef enum { sMebConfig = 0, sRun } tSimucamStates;
typedef enum { sInternal = 0, sExternal } tSimucamSync;
typedef enum { sNormalFEE = 0, sFastFEE } tFeeType;


typedef struct Simucam_MEB {
    tFeeType        eType;                  /* Normal or Fast FEE */
    tSimucamStates  eMode;                  /* Mode of operation for the Simucam */
    unsigned char ucActualDDR;              /* Control the swap mechanism of DDRs ( 0: DDR0 or 1: DDR1 ) */
    /* Note 3: The EP and RT parameters are common to all the N-FEE simulation entities. */
    float ucEP;                    			/* Exposure period [NFEESIM-UR-447] */
    float ucRT;                    			/* CCD readout time [NFEESIM-UR-447] */
    tSimucamSync  eSync;                    /* Internal or external sync [NFEESIM-UR-633]*/
    bool    bAutoRestSyncMode;              /* Auto Reset Sync Mode [NFEESIM-UR-728] */
    /* todo: estruturas de controle para o simucam */
    TNData_Control xDataControl;
    TNFee_Control xFeeControl;
} TSimucam_MEB;


extern TSimucam_MEB xSimMeb;


void vSimucamStructureInit( TSimucam_MEB *xMeb );

void vLoadDefaultEPValue( TSimucam_MEB *xMeb );
void vChangeEPValue( TSimucam_MEB *xMeb, float ucValue );
void vChangeDefaultEPValue( TSimucam_MEB *xMeb, float ucValue );
void vLoadDefaultRTValue( TSimucam_MEB *xMeb );
void vChangeRTValue( TSimucam_MEB *xMeb, float ucValue );
void vChangeDefaultRTValue( TSimucam_MEB *xMeb, float ucValue );
void vLoadDefaultSyncSource( TSimucam_MEB *xMeb );
void vChangeSyncSource( TSimucam_MEB *xMeb, tSimucamSync eSource );
void vChangeDefaultSyncSource( TSimucam_MEB *xMeb, tSimucamSync eSource );
void vLoadDefaultAutoResetSync( TSimucam_MEB *xMeb );
void vChangeAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset );
void vChangeDefaultAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset );
void vSyncReset( TSimucam_MEB *xMeb, float ufSynchDelay );

#endif /* MEB_H_ */
