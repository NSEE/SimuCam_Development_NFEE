/*
 * fee_controler.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */


#include "fee_controller.h"

void vNFeeControlInit( TNFee_Control *xFeeControlL ) {
    unsigned char ucIL = 0;
    
    /* Reset TimeCode */
    vResetTimeCode( xFeeControlL );
    /* Load Default Id for NFEE master */
    vLoadDefaultIdNFEEMaster( xFeeControlL );

    xFeeControlL->sMode = sMebInit;

    /* Calculate the */
    for ( ucIL = 0; ucIL < N_OF_NFEE; ucIL++ ) {
        vNFeeStructureInit( &xFeeControlL->xNfee[ ucIL ], ucIL);
        xFeeControlL->pbEnabledNFEEs[ ucIL ] = &xFeeControlL->xNfee[ ucIL ].xControl.bEnabled;
        xFeeControlL->pbSimulatingNFEEs[ ucIL ] = &xFeeControlL->xNfee[ ucIL ].xControl.bSimulating;
        xFeeControlL->xNfee[ ucIL ].xControl.pActualMem = xFeeControlL->pActualMem;
    }

}

/* Any mode */
/* Set the time code of the Simucam */
void vSetTimeCode( TNFee_Control *xFeeControlL, unsigned char ucTime ) {
    xFeeControlL->ucTimeCode = ucTime;
}

/* Reset the time code of the Simucam */
void vResetTimeCode( TNFee_Control *xFeeControlL ) {
    xFeeControlL->ucTimeCode = 0;
}

/* Only in MEB_CONFIG */
/* Load Default Config for IdNFEEMaster */
void vLoadDefaultIdNFEEMaster( TNFee_Control *xFeeControlL ) {
    //bGetIdNFEEMasterSDCard();
    //todo: For now is hardcoded
    xFeeControlL->ucIdNFEEMaster = 0;
}

/* Only in MEB_CONFIG */
/* Change the Config for IdNFEEMaster*/
void vChangeIdNFEEMaster( TNFee_Control *xFeeControlL, unsigned char ucIdMaster ) {
    xFeeControlL->ucIdNFEEMaster = ucIdMaster;
}

/* Only in MEB_CONFIG */
/* Change the Default Config for IdNFEEMaster */
void vChangeDefaultIdNFEEMaster( TNFee_Control *xFeeControlL, unsigned char ucIdMaster ) {
    //bSaveIdNFEEMasterSDCard(ucIdMaster);
}
