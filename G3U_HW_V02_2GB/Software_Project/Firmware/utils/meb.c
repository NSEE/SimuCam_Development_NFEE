/*
 * meb.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */


#include "meb.h"

void vSimucamStructureInit( TSimucam_MEB *xMeb ) {
    unsigned char ucIL = 0;

    // LoadTypeOfFeeSDCard();
    // todo: Load from SDCard for now is Hardcoded to Normal FEE
    xMeb->eType = sNormalFEE;
    
    /* Simucam start in the Meb Config Mode */
    xMeb->eMode = sMebConfig;

    /* Load EP */
    vLoadDefaultEPValue( xMeb );
    /* Load RT */
    vLoadDefaultRTValue( xMeb );
    /* Load SyncSource */
    vLoadDefaultSyncSource( xMeb );
    /* Reset TimeCode */
    vResetTimeCode( xMeb );
    /* Load Default Id for NFEE master */
    vLoadDefaultIdNFEEMaster( xMeb );
    /* Load Default Config for Auto Reset Mode */
    vLoadDefaultAutoResetSync( xMeb );

    // LoadNumberOfNFeesSDCard();
    /* todo: Load from SDCard for now is Hardcoded for 4 instances of NFEE */
    xMeb->ucNofFeesInUse = 2;

    /* Verify if if a Fast or Normal */
    if ( xMeb->eType == sNormalFEE ) {
        /* Are Normal Fee instances */
        for ( ucIL = 0; ucIL < N_OF_NFEE ) {
            if ( ucIL < xMeb->ucNofFeesInUse ) {
                vNFeeStructureInit( &xMeb->xNfee[ ucIL ], ucIL);
            } else {
                vNFeeNotInUse( &xMeb->xNfee[ ucIL ], ucIL);
            }
            xMeb->pbEnabledNFEEs[ ucIL ] = &xMeb->xNfee.xControl.bEnabled;
            xMeb->pbRunningDmaNFEEs[ ucIL ] = &xMeb->xNfee.xControl.bUsingDMA;
        }
    } else {
        /* Are Fast Fee instances */
        for ( ucIL = 0; ucIL < N_OF_FastFEE ) {
            if ( ucIL < xMeb->ucNofFeesInUse ) {
                // todo: Not in use yet
            } else {
                // todo: Not in use yet
            }            
        }
    }

    /* Reseting swap memory mechanism */
    xMeb->ucActualDDR = 0;

    /* At this point all structures that manage the aplication of Simucam and FEE are initialized, the tasks could start now */


}

/* Only in MEB_CONFIG */
/* Load Default value of EP - Exposure period [NFEESIM-UR-447] */
void vLoadDefaultEPValue( TSimucam_MEB *xMeb ) {
    //bGetEPSDCard();
    //todo: For now is hardcoded
    xMeb->ucEP = 25;
}

/* Only in MEB_CONFIG */
/* Change the active value of EP - Exposure period [NFEESIM-UR-447] */
void vChangeEPValue( TSimucam_MEB *xMeb, unsigned float ucValue ) {
    xMeb->ucEP = ucValue;
}

/* Only in MEB_CONFIG */
/* Change the default value of EP - Exposure period [NFEESIM-UR-447] */
void vChangeDefaultEPValue( TSimucam_MEB *xMeb, unsigned float ucValue ) {
    //bSaveEPSDCard(ucValue);
}

/* Only in MEB_CONFIG */
/* Load Default value of EP - Exposure period [NFEESIM-UR-447] */
void vLoadDefaultRTValue( TSimucam_MEB *xMeb ) {
    //bGetEPSDCard();
    //todo: For now is hardcoded
    xMeb->ucRT = 3.9;
}

/* Only in MEB_CONFIG */
/* Change the active value of RT - CCD readout time [NFEESIM-UR-447] */
void vChangeRTValue( TSimucam_MEB *xMeb, unsigned float ucValue ) {
    xMeb->ucRT = ucValue;
}

/* Only in MEB_CONFIG */
/* Change the default value of RT - CCD readout time [NFEESIM-UR-447] */
void vChangeDefaultRTValue( TSimucam_MEB *xMeb, unsigned float ucValue ) {
    //bSaveRTSDCard(ucValue);
}

/* Only in MEB_CONFIG */
/* Load Default Config Sync - Internal or external */
void vLoadDefaultSyncSource( TSimucam_MEB *xMeb ) {
    //bGetSyncSourceSDCard();
    //todo: For now is hardcoded
    xMeb->eSync = sInternal;
}

/* Only in MEB_CONFIG */
/* Change the Active Config Sync - Internal or external */
void vChangeSyncSource( TSimucam_MEB *xMeb, tSimucamSync eSource ) {
    xMeb->eSync = eSource;
}

/* Only in MEB_CONFIG */
/* Change the Default Config Sync - Internal or external */
void vChangeDefaultSyncSource( TSimucam_MEB *xMeb, tSimucamSync eSource ) {
    //bSaveSyncSourceSDCard(eSource);
}

/* Any mode */
/* Set the time code of the Simucam */
void vSetTimeCode( TSimucam_MEB *xMeb, unsigned char ucTime ) {
    xMeb->ucTimeCode = ucTime;
}

/* Reset the time code of the Simucam */
void vResetTimeCode( TSimucam_MEB *xMeb ) {
    xMeb->ucTimeCode = 0;
}

/* Only in MEB_CONFIG */
/* Load Default Config for AutoResetSync */
void vLoadDefaultAutoResetSync( TSimucam_MEB *xMeb ) {
    //bGetAutoResetSyncSDCard();
    //todo: For now is hardcoded
    xMeb->bAutoRestSyncMode = TRUE;
}

/* Only in MEB_CONFIG */
/* Change the Config for AutoResetSync*/
void vChangeAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset ) {
    xMeb->bAutoRestSyncMode = bAutoReset;
}

/* Only in MEB_CONFIG */
/* Change the Default Config for AutoResetSync */
void vChangeDefaultAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset ) {
    //bSaveAutoResetSyncSDCard(bAutoReset);
}

/* Only in MEB_CONFIG */
/* Load Default Config for IdNFEEMaster */
void vLoadDefaultIdNFEEMaster( TSimucam_MEB *xMeb ) {
    //bGetIdNFEEMasterSDCard();
    //todo: For now is hardcoded
    xMeb->ucIdNFEEMaster = 0;
}

/* Only in MEB_CONFIG */
/* Change the Config for IdNFEEMaster*/
void vChangeIdNFEEMaster( TSimucam_MEB *xMeb, unsigned char ucIdMaster ) {
    xMeb->ucIdNFEEMaster = ucIdMaster;
}

/* Only in MEB_CONFIG */
/* Change the Default Config for IdNFEEMaster */
void vChangeDefaultIdNFEEMaster( TSimucam_MEB *xMeb, unsigned char ucIdMaster ) {
    //bSaveIdNFEEMasterSDCard(ucIdMaster);
}

/* Any mode */
/* Synchronization Reset */
void vSyncReset( TSimucam_MEB *xMeb, unsigned float ufSynchDelay ) {
    
    // Stop all transmission

    // Put all NFEE in Stand-by mode, if not in Config mode

    // Reset the time code
    vResetTimeCode();

    // Wait ufSynchDelay milliseconds

    // Release a synchronization signal

    // Start new cycle

}