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
#include "feeV2.h"
#include "ccd.h"
#include "lut_handler.h"

/* Used to get the priorities needed for the sync-reset function [bndky] */
#include "../rtos/tasks_configurations.h"



/* Simucam operation modes */
typedef enum { sInternal = 0, sExternal } tSimucamSync;
typedef enum { sNormalFEE = 0, sFastFEE } tFeeType;


/* MASK LOGIC
 * think in bit ---> end[7] end[6] end[5] end[4] end[3] end[2] end[1] end[0] => 7: always zero; 6: is the DataController; 0..5: NFEE0 to NFEE5
 * */

typedef struct SwapControl {
	bool lastReadOut;	/* Will be true in the last CCD readout */
	unsigned char end; 	/* 0111 1111 = 0x7F => Which NFEE(6) + DT Controller, each time they finish the use of the memory send message to Meb that will pass the bit to zero  */
}TSwapControl;

/*Moved to simucam definitions*/
typedef struct Simucam_MEB {
    tFeeType        eType;                  /* Normal or Fast FEE */
    tSimucamStates  eMode;                  /* Mode of operation for the Simucam */
    unsigned char ucActualDDR;              /* Control the swap mechanism of DDRs ( 0: DDR0 or 1: DDR1 ) */
    unsigned char ucNextDDR;              /* Control the swap mechanism of DDRs ( 0: DDR0 or 1: DDR1 ) */
    /* Note 3: The EP and RT parameters are common to all the N-FEE simulation entities. */
    float ucEP;                    			/* Exposure period [NFEESIM-UR-447] */
    float ucRT;                    			/* CCD readout time [NFEESIM-UR-447] */
    unsigned short int usiDelaySyncReset;
    float fLineTransferTime;
    float fPixelTransferTime;
    tSimucamSync  eSync;                    /* Internal or external sync [NFEESIM-UR-633]*/
    bool    bAutoResetSyncMode;              /* Auto Reset Sync Mode [NFEESIM-UR-728] */
    /* todo: estruturas de controle para o simucam */
    TNData_Control xDataControl;
    TNFee_Control xFeeControl;
    TSwapControl xSwapControl;
    TLUTStruct xLut;
} TSimucam_MEB;

extern TSimucam_MEB xSimMeb;
extern OS_EVENT *xQueueSyncReset;   /*[bndky]*/

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
void vSyncReset( unsigned short int ufSynchDelay, TNFee_Control *pxFeeCP ); /* [bndky] */

void vSendCmdQToNFeeCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
void vSendCmdQToNFeeCTRL_PRIO( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
void vSendCmdQToDataCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
void vSendCmdQToDataCTRL_PRIO( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );

void vSendCmdQToNFeeCTRL_GEN( unsigned char usiFeeInstP,unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );

#endif /* MEB_H_ */
