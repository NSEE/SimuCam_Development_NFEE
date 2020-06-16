/*
 * meb.c
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */


#include "meb.h"

void vSimucamStructureInit( TSimucam_MEB *xMeb ) {
    // LoadTypeOfFeeSDCard();
    // todo: Load from SDCard for now is Hardcoded to Normal FEE
    xMeb->eType = sNormalFEE;
    
    /* Simucam start in the Meb Config Mode */
    xMeb->eMode = sMebInit;

    /* Load EP */
    vLoadDefaultEPValue( xMeb );
    /* Load RT */
    vLoadDefaultRTValue( xMeb );
    /* Load SyncSource */
    vLoadDefaultSyncSource( xMeb );
    /* Load Default Config for Auto Reset Mode */
    vLoadDefaultAutoResetSync( xMeb );

    /* todo: Change for change functions */
    xMeb->fLineTransferTime = 0;
    xMeb->fPixelTransferTime = 0;
    xMeb->usiDelaySyncReset = 500; /* milliseconds */

    /* Reseting swap memory mechanism */
    xMeb->ucActualDDR = 1;
    xMeb->ucNextDDR = 0;
    xMeb->xSwapControl.end = 0x00; /* 0x7F for N-FEE, need to adjust to F-FEE */
    xMeb->xSwapControl.lastReadOut = FALSE;

    xMeb->xFeeControl.pActualMem = &xMeb->ucActualDDR;
    xMeb->xDataControl.pNextMem = &xMeb->ucNextDDR;

    /* Verify if if a Fast or Normal */
    if ( xMeb->eType == sNormalFEE ) {
        /* Are Normal Fee instances */
    	vNFeeControlInit( &xMeb->xFeeControl );
        vDataControllerInit( &xMeb->xDataControl, &xMeb->xFeeControl );
        vLutInit( &xMeb->xLut );

    } else {
        /* Are Fast Fee instances */
        /* todo: Not in use yet */
    }

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
void vChangeEPValue( TSimucam_MEB *xMeb, float ucValue ) {
    xMeb->ucEP = ucValue;
}

/* Only in MEB_CONFIG */
/* Change the default value of EP - Exposure period [NFEESIM-UR-447] */
void vChangeDefaultEPValue( TSimucam_MEB *xMeb, float ucValue ) {
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
void vChangeRTValue( TSimucam_MEB *xMeb, float ucValue ) {
    xMeb->ucRT = ucValue;
}

/* Only in MEB_CONFIG */
/* Change the default value of RT - CCD readout time [NFEESIM-UR-447] */
void vChangeDefaultRTValue( TSimucam_MEB *xMeb, float ucValue ) {
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


/* Only in MEB_CONFIG */
/* Load Default Config for AutoResetSync */
void vLoadDefaultAutoResetSync( TSimucam_MEB *xMeb ) {
    //bGetAutoResetSyncSDCard();
    //todo: For now is hardcoded
    xMeb->bAutoResetSyncMode = TRUE;
}

/* Only in MEB_CONFIG */
/* Change the Config for AutoResetSync*/
void vChangeAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset ) {
    xMeb->bAutoResetSyncMode = bAutoReset;
}

/* Only in MEB_CONFIG */
/* Change the Default Config for AutoResetSync */
void vChangeDefaultAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset ) {
    //bSaveAutoResetSyncSDCard(bAutoReset);
}


/* Only in MEB_RUNNING */
/**
 * @author bndky
 * @name vSyncReset
 * @brief Function that coordinates the Synchronization Reset function.
 *
 * @param 	[in]	unsigned short int  ufSynchDelayL
 * @param	[in]	TNFee_Control 	    *pxFeeCP	
 *
 * @retval void
 **/
void vSyncReset( unsigned short int usiSynchDelayL, TNFee_Control *pxFeeCP ) {
    INT8U iErrorCodeL = 0;

    /* Send message to task queue */
    iErrorCodeL = OSQPost(xQueueSyncReset, (void *)((unsigned long int)usiSynchDelayL));
    if (iErrorCodeL == OS_ERR_NONE){

		#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage )
				fprintf(fp,"\n\n+++++++++++++++++++ Sync Reset: T = %hu ms+++++++++++++++++++++\n\n\n", usiSynchDelayL);
		#endif

        /* Resume sync reset task */
        iErrorCodeL = OSTaskResume(SYNC_RESET_HIGH_PRIO);

        if (iErrorCodeL != OS_NO_ERR){
            #if DEBUG_ON
                if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
                    fprintf(fp,"Sync Reset: Sync Reset Error 1\n");
            #endif
        }
    } else{
        #if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
				fprintf(fp,"Sync Reset: Sync Reset Error 2\n");
		#endif
    }
}

void vSendCmdQToNFeeCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}
}

void vSendCmdQToNFeeCTRL_PRIO( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPostFront(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}

	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPostFront(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord); /*todo: Tiago - Ficar de olho*/
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}
}


/* Send to FEEs using the NFEE Controller vSendCmdQToNFeeCTRL_GEN((M_NFEE_BASE_ADDR+usiFeeInstL), M_FEE_CONFIG, 0, usiFeeInstL );*/
void vSendCmdQToNFeeCTRL_GEN( unsigned char usiFeeInstP, unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + usiFeeInstP;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;


	/* Sync the Meb task and tell that has a PUS command waiting */
	error_codel = OSQPost(xFeeQ[ usiFeeInstP ], (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}
}


void vSendCmdQToDataCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/*Send a command to other entities (Data Controller) */
	error_codel = OSQPost(xQMaskDataCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgDataCTRL();
	}
}

void vSendCmdQToDataCTRL_PRIO( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/*Send a command to other entities (Data Controller) */
	error_codel = OSQPostFront(xQMaskDataCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailSendMsgFeeCTRL();
	}
}
