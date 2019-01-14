/*
 * meb.h
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#ifndef MEB_H_
#define MEB_H_

#include "../simucam_definitions.h"
#include "fee.h"
#include "ccd.h"

#define N_OF_NFEE       6
#define N_OF_FastFEE    2

/* Simucam operation modes */
typedef enum { sMebConfig = 0, sRun } tSimucamStates;
typedef enum { sInternal = 0, sExternal } tSimucamSync;
typedef enum { sNormalFEE = 0, sFastFEE } tFeeType;


typedef struct Simucam_MEB {
    tFeeType        eType;                  /* Normal or Fast FEE */
    tSimucamStates  eMode;                  /* Mode of operation for the Simucam */
    unsigned char ucNofFeesInUse;           /* In the final version ucNofFeesInUse will be N_OF_NFEE */
    TNFee   xNfee[N_OF_NFEE];               /* All instances of control for the NFEE */
    unsigned char ucActualDDR;              /* Control the swap mechanism of DDRs ( 0: DDR0 or 1: DDR1 ) */
    /* Note 3: The EP and RT parameters are common to all the N-FEE simulation entities. */
    unsigned float ucEP;                    /* Exposure period [NFEESIM-UR-447] */
    unsigned float ucRT;                    /* CCD readout time [NFEESIM-UR-447] */
    tSimucamSync  eSync;                    /* Internal or external sync [NFEESIM-UR-633]*/
    unsigned char ucTimeCode;               /* Timecode [NFEESIM-UR-488]*/
    unsigned char ucIdNFEEMaster;       /* Set which N-FEE simulation is the master. [NFEESIM-UR-729]*/
    bool    bAutoRestSyncMode;              /* Auto Reset Sync Mode [NFEESIM-UR-728] */
    bool    *pbEnabledNFEEs[N_OF_NFEE];     /* Which are the NFEEs that are enabled */
    bool    *pbRunningDmaNFEEs[N_OF_NFEE];  /* This array will be used for optimization propurses, mark all the NFEE that need access to DMA */
    /*todo: estruturas de controle para o simucam*/
} TSimucam_MEB;

void vSimucamStructureInit( TSimucam_MEB *xMeb );

void vLoadDefaultEPValue( TSimucam_MEB *xMeb );
void vChangeEPValue( TSimucam_MEB *xMeb, unsigned float ucValue );
void vChangeDefaultEPValue( TSimucam_MEB *xMeb, unsigned float ucValue );
void vLoadDefaultRTValue( TSimucam_MEB *xMeb );
void vChangeRTValue( TSimucam_MEB *xMeb, unsigned float ucValue );
void vChangeDefaultRTValue( TSimucam_MEB *xMeb, unsigned float ucValue );
void vLoadDefaultSyncSource( TSimucam_MEB *xMeb );
void vChangeSyncSource( TSimucam_MEB *xMeb, tSimucamSync eSource );
void vChangeDefaultSyncSource( TSimucam_MEB *xMeb, tSimucamSync eSource );
void vSetTimeCode( TSimucam_MEB *xMeb, unsigned char ucTime );
void vResetTimeCode( TSimucam_MEB *xMeb );
void vLoadDefaultAutoResetSync( TSimucam_MEB *xMeb );
void vChangeAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset );
void vChangeDefaultAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset );
void vLoadDefaultIdNFEEMaster( TSimucam_MEB *xMeb );
void vChangeIdNFEEMaster( TSimucam_MEB *xMeb, unsigned char ucIdMaster );
void vChangeDefaultIdNFEEMaster( TSimucam_MEB *xMeb, unsigned char ucIdMaster );
void vSyncReset( TSimucam_MEB *xMeb, unsigned float ufSynchDelay );

#endif /* MEB_H_ */
